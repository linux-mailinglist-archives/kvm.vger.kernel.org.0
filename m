Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316ED56AF4D
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 02:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237032AbiGHAHd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 20:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236929AbiGHAHc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 20:07:32 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BB96EE93
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 17:07:30 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id g16-20020a17090a7d1000b001ea9f820449so347868pjl.5
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 17:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BvInM824z/eyDNVvob0724ZwlBeB34Jd+5iTmePRCRk=;
        b=WIEatKSPj9cS9LPCVtf2KuRRV7SHE4Jlk7voos6nz1HzQ9P7x6n0NIxtrxXnroMiFy
         BTVsZvJ1adlQKqNstzCOk+tS0L+pfRutNDwBHI6f0R0tACHIk+E1+B7fp0TRGrE8G5PF
         qE8tr+fbJLcIHsS/aDnNEXud4FzWbezwuJgNx+grmDtAVhlGSsrAY+ZItxyPObCXRCTf
         Jyb1MuWH7fO2jplTmhCymGSxyzcACMLIcS1RuV4sYqIIJHyOOJnXwIyCkaiWfCX+sVWD
         DpbuPLdgKbqFBvcO9PR87VYCzXf21p7xGqBfAXeCj7DoTFpMi70CLhTx7u7gR2NxMZHi
         n3IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BvInM824z/eyDNVvob0724ZwlBeB34Jd+5iTmePRCRk=;
        b=gzhyQYWSv7rH324l8ag84LYcwccnsaLBveExDjKp8sYFfrw6kh5jj+kjaf6zCgjjgd
         N9oXQUnHWxJOpcLdhsX0/IlgT6y5oQVi7sTFPKegCoshD4YhjjqmgdPn6KcmarlJxS0g
         GrZ93ci4lq/rYHhTp2B9rY7J3FzJ+xwXvGmFkaGnXOggbQoUlXQH5t+2V5szz86PMd/S
         mfhE3vS9Mb5tW5RfeoBlmlfRASMER24IueY8aKk9orXmcSCOUyJZG59lsDK/en1V4gKD
         Pqw01m9DCKLTOVLBiKYEU27DfErjWFmHEZvnA1vZgvCvJXzbg7W0L3GRf6LYDAhyKswn
         rKmw==
X-Gm-Message-State: AJIora8la4XdU6n4AXEjEWD2Zc+Pm8NBBrz9Ggjt0eV91nf8Do6Xyidg
        RGnxrLZVZn1HASr4d5zPDPvWTCJDJI9rBw==
X-Google-Smtp-Source: AGRyM1uRncK0ea5e+0tfArxeCYxiva7Hm6cnqGXakM/m51I137j2YAKHdXRPGpMVo1+dCsJHFNU2Mg==
X-Received: by 2002:a17:902:aa41:b0:168:8d12:540b with SMTP id c1-20020a170902aa4100b001688d12540bmr775525plr.35.1657238850053;
        Thu, 07 Jul 2022 17:07:30 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id l2-20020a17090a4d4200b001ef8fb72224sm134877pjh.53.2022.07.07.17.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 17:07:29 -0700 (PDT)
Date:   Fri, 8 Jul 2022 00:07:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     bugzilla-daemon@kernel.org
Cc:     kvm@vger.kernel.org
Subject: Re: [Bug 216212] New: KVM does not handle nested guest enable PAE
 paging correctly when CR3 is not mapped in EPT
Message-ID: <Ysd1PfDyF1crnmyA@google.com>
References: <bug-216212-28872@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-216212-28872@https.bugzilla.kernel.org/>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 07, 2022, bugzilla-daemon@kernel.org wrote:
> Likely stack trace and cause of this bug (Linux source code version is 5.18.9):
> 
> Stack trace:
> 
> handle_cr
>     kvm_set_cr0
>         load_pdptrs
>             kvm_translate_gpa

Yeah, load_pdptrs() needs to call kvm_inject_emulated_page_fault() to inject a
TDP fault if translating the L2 GPA to an L1 GPA fails.  That part is easy to fix,
but communicating up the stack that the instruction has already faulted is going
to be painful due to the use of kvm_complete_insn_gp().  Ugh, and the emulator gets
involved too.

Not that it makes things worse than they already are, but I'm pretty sure MOV CR3
(via the emulator) and MOV CR4 are also affected.

I suspect the least awful solution will be to use proper error codes instead of 0/1
so that kvm_complete_insn_gp() and friends can differentiate between "success",
"injected #GP", and "already exploded", but it's still going to require a lot of
churn.

A more drastic, but maybe less painful (though as I type this out, it's becoming
ridiculously painful) alternative would be to not intercept CR0/CR4 paging bits
when running L2 and TDP is enabled, which would in theory allow KVM to drop
the call to kvm_translate_gpa().  load_pdptrs() would still be reachable via the
emulator, but I think iff the guest is playing TLB, so KVM could probably just
resume the guest in that case.

The primary reason KVM intercepts CR0/CR4 paging bits even when using TDP is so
that KVM doesn't need to refresh state to do software gva->gpa walks, e.g. to
correctly emulate memory accesses and reserved PTE bits.  The argument for
intercepting is that changing paging modes is a rare guest operation, whereas
emulating some form of memory access is relatively common.  And it's also simpler
in the sense that KVM can use common code for TDP and !TDP (shadow paging heavily
depends on caching paging state).

But emulating on behalf of L2 is quite rare, and having to deal with this bug
counters the "it's simpler" argument to some extent.  I _think_ ensuring the nested
MMU is properly initialized could be solved by adding a nested_gva_to_gpa() wrapper
instead of directly wiring mmu->gva_to_gpa() to the correct helper.

The messier part would be handling intercepts.  VMX would have to adjust
vmcs02.CRx_READ_SHADOW and resume the guest to deal with incidental interception,
e.g. if the guest toggles both CR0.CD and CR0.PG.  SVM is all or nothing for
intercepts, but PAE under NPT isn't required to load PDTRs at MOV CR, so we could
just drop that entire path for SVM+NPT.  But that would rely on KVM correctly
handling L1 NPT faults during PDPTE accesses on behalf of L2, which of course KVM
doesn't get right.

So yeah, maybe KVM can avoid some of the PAE pain in the long term if KVM stops
intercepting CR0/CR4 paging bits, but it's probably a bad idea for an immediate
fix.
