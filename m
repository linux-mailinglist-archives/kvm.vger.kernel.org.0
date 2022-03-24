Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B370A4E6B5B
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 00:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242353AbiCXX7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 19:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357254AbiCXX67 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 19:58:59 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160CBBB915
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 16:57:27 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id gb19so6088842pjb.1
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 16:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vRsyPprShKsOrs8+V50RHwTMspRZS0ZwGV5m58o59To=;
        b=TmQMvKZGl8j4AC9+v4TQ2kXOWE4RsoO0PUQfyv8K/3eGGglVyfPUBvNkpbx0WADAVX
         SWv5U0hghEFJvoNS53WxJmlQFThHCmccIV1OwXx1IXqVnhCRJj5ldB6GIIhFUZQkpUBs
         UPjpN35CdmUItN+SdZk8EO7smqV0JHbBFVaYUlEebB3I1hwHuVAfvKEofiSV1nC5THKW
         w6ey9Plu7+StcESpsTklDBdQNKgozR0jlWd46ClmNPXiLIJjSIZmlti/qMaK1N9OCVSO
         Ld3Gyz0ZuPiC04+rT0BO8fWXZbOL9QsskVlym4Iwep5HWIc0Z5Ko4gZ2na5rQl1vT7Z8
         b7Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vRsyPprShKsOrs8+V50RHwTMspRZS0ZwGV5m58o59To=;
        b=QK81EWLCNW0N5juEWbzOeWNl3yiutSJhz9yTzvNAHKa4pS39QRZfa5gdMA88JOEGck
         KJ4I1/l49HmIhAhI2e0AkjNapE0UN1nG27l5vRUWScUQliGZ+U2jvJcWuGxWZkUAaXDM
         jYDgWBYpm9Nmvwj0u3BRCriTMlWdP1fKHrxt8yogtS+G+t+oK26BX2+zVnNs/CDA3DUI
         gj/QpRJ+b807W7OfZ3VAl/Z43aTJY5soRicz3kQ/CzBX3Y5zLMjm9rNyjpMCgZYYjhYd
         Ilk1WqhydCexBqRvCAlAs3leFvYdn076gFsSbUtninds9eSIOO+ptLAJhGkP7oKe/11C
         6Nfw==
X-Gm-Message-State: AOAM532KwynZVAs25KdKbjyNhXGLebf0aknpi9o/FuvvV6TUdlphI3nO
        UCht9XdPWIA8VKJRJAeHqHv89Z2KShVGrQ==
X-Google-Smtp-Source: ABdhPJwAsmCkNyblumfyVgiJS5ne1xqn/dmpkY+KcZ9kHHTNU6HKNEuQtpYMbNoVb+ysMF8FKofOxg==
X-Received: by 2002:a17:90b:1811:b0:1c7:832a:3388 with SMTP id lw17-20020a17090b181100b001c7832a3388mr9399924pjb.40.1648166246379;
        Thu, 24 Mar 2022 16:57:26 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ep2-20020a17090ae64200b001c6a7c22aedsm3792497pjb.37.2022.03.24.16.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 16:57:25 -0700 (PDT)
Date:   Thu, 24 Mar 2022 23:57:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [FYI PATCH] Revert "KVM: x86/mmu: Zap only TDP MMU leafs in
 kvm_zap_gfn_range()"
Message-ID: <Yj0FYSC2sT4k/ELl@google.com>
References: <20220318164833.2745138-1-pbonzini@redhat.com>
 <d6367754-7782-7c29-e756-ac02dbd4520b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6367754-7782-7c29-e756-ac02dbd4520b@redhat.com>
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

On Mon, Mar 21, 2022, Paolo Bonzini wrote:
> On 3/18/22 17:48, Paolo Bonzini wrote:
> > This reverts commit cf3e26427c08ad9015956293ab389004ac6a338e.
> > 
> > Multi-vCPU Hyper-V guests started crashing randomly on boot with the
> > latest kvm/queue and the problem can be bisected the problem to this
> > particular patch. Basically, I'm not able to boot e.g. 16-vCPU guest
> > successfully anymore. Both Intel and AMD seem to be affected. Reverting
> > the commit saves the day.
> > 
> > Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> This is not enough, the following is also needed to account
> for "KVM: x86/mmu: Defer TLB flush to caller when freeing TDP MMU shadow
> pages":
> 
> ------------------- 8< ----------------
> From: Paolo Bonzini <pbonzini@redhat.com>
> Subject: [PATCH] kvm: x86/mmu: Flush TLB before zap_gfn_range releases RCU
> 
> Since "KVM: x86/mmu: Zap only TDP MMU leafs in kvm_zap_gfn_range()"
> is going to be reverted, it's not going to be true anymore that
> the zap-page flow does not free any 'struct kvm_mmu_page'.  Introduce
> an early flush before tdp_mmu_zap_leafs() returns, to preserve
> bisectability.

Can I have 1-2 weeks to try and root cause and fix the underlying issue before
sending reverts to Linus?  I really don't want to paper over a TLB flushing bug
or an off-by-one bug, and I really, really don't want to end up with another
scenario where KVM zaps everything just because.

Vitaly, can you provide repro instructions?  A nearly-complete QEMU command line
would be wonderful :-)  Is the issue unique to any particular guest kernel?  I've
been unable to repro with a 112 vCPU Linux guest with these Hyper-V enlightenments:

$ : dm | grep -i hyper-v
[    0.000000] Hypervisor detected: Microsoft Hyper-V
[    0.000000] Hyper-V: privilege flags low 0x2aff, high 0x830, hints 0x4e2c, misc 0x80d12
[    0.000000] Hyper-V Host Build:14393-10.0-0-0.0
[    0.000000] Hyper-V: Nested features: 0x80101
[    0.000000] Hyper-V: LAPIC Timer Frequency: 0x3d0900
[    0.000000] Hyper-V: Using hypercall for remote TLB flush
[    0.000004] tsc: Marking TSC unstable due to running on Hyper-V
[    0.129376] Booting paravirtualized kernel on Hyper-V
[    0.140419] Hyper-V: PV spinlocks disabled
[    0.247500] Hyper-V: Using IPI hypercalls
[    0.247502] Hyper-V: Using enlightened APIC (x2apic mode)

Actually, since this is apparently specific to kvm_zap_gfn_range(), can you add
printk "tracing" in update_mtrr(), kvm_post_set_cr0(), and __kvm_request_apicv_update()
to see what is actually triggering zaps?  Capturing the start and end GFNs would be very
helpful for the MTRR case.

The APICv update seems unlikely to affect only Hyper-V guests, though there is the auto
EOI crud.  And the other two only come into play with non-coherent DMA.  In other words,
figuring out exactly what sequence leads to failure should be straightforward.
