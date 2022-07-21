Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32EB757CEDA
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 17:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiGUP0F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 11:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiGUP0D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 11:26:03 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1115124099
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 08:26:02 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id z3so2157402plb.1
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 08:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2uLd/RvlCglp7VMJKG7TRwZBoXRuAQZML6wCn6y9QPE=;
        b=U8YeA1C1xSmyf9+g6oR8D+gFOIU4wx6tbOqYi/lXgRktJn50dwvUYwjs0cAk4xYSRZ
         NdVOITGtBt1888pnTJF12EhfFQp1ZjMYxPtt2twRkUFC5rAwA58kPIJeQ+XWL7tAEKLv
         PHhv4UmiLlB2FD5ZZwJ87M+5IJ2jbF6D9yGS94EUIXg8+3+enWUWO58q+DA4ghVcBfOf
         OXYwfAaGtYbxz316MH3az8hvm+PgGNDH4LueZl+QJPAnZy0hrPWIYLVHo1UCrES6RVqB
         zP4RHCzc9gDewTG9NDS3IDGMN2jzDS63hbyUZsWGGW4vnuNXk0JbbXHxQeNFRWhTBvo/
         e97Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2uLd/RvlCglp7VMJKG7TRwZBoXRuAQZML6wCn6y9QPE=;
        b=8QC1wkBeaH2eSgOoElqfoblZ98zzcfmlOqb34KMAWH7U4iNDFZRNdFAa8xhbFgUvRP
         1RE3XS/VkV+4vR3dzQXuvLlbdqcBazLyvAkepF33XeOcGMgtQT8a5UZZMFcvkMwwMQ1o
         XQH5mlsDZBeFL9OBQWzdALPn0jZPh7ECSDTTJdDwsfGk5H/6j26vI6KlrzqZWVvTlFDV
         5gODFH1QauYAn9TlLZJliiEU3GV8gogqLXsjCFVbZPZriwfJC/g0xBzo0fZAqzU2jSXD
         mDDCmtKRbJ+CDx9WuCJwEgbTDvlmcMiyF8YgiiZuXCkKBnlG4jaYjkd6OfOtlqPc0Ix4
         oPqA==
X-Gm-Message-State: AJIora9OZcv9CGBvhWLN8uRWGFbiJNPm1syig/fFe+dtTjTFOxwOzApm
        W4Qnw/EZAivB9oyjj2AuuAcmfw==
X-Google-Smtp-Source: AGRyM1s4jbrd+HHmsGjYZRgS2raRakVuaIBd48F8IPCNE2NUCnQugca4NB0SWzvboULXHumLt45VtQ==
X-Received: by 2002:a17:90a:8914:b0:1dc:20c0:40f4 with SMTP id u20-20020a17090a891400b001dc20c040f4mr11806859pjn.11.1658417161366;
        Thu, 21 Jul 2022 08:26:01 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b001618b70dcc9sm1832358plb.101.2022.07.21.08.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 08:26:00 -0700 (PDT)
Date:   Thu, 21 Jul 2022 15:25:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH 07/12] KVM: X86/MMU: Remove the useless struct
 mmu_page_path
Message-ID: <YtlwBcvU5ro11wuy@google.com>
References: <20220605064342.309219-1-jiangshanlai@gmail.com>
 <20220605064342.309219-8-jiangshanlai@gmail.com>
 <YtcQ1GuTAttXaUk+@google.com>
 <CAJhGHyB=-bGrguLKtTh+EAr5zr--H97HUgR3WP=JTovQLkoevQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhGHyB=-bGrguLKtTh+EAr5zr--H97HUgR3WP=JTovQLkoevQ@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 21, 2022, Lai Jiangshan wrote:
> On Wed, Jul 20, 2022 at 4:15 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > Nit, s/useless/now-unused, or "no longer used".  I associate "useless" in shortlogs
> > as "this <xyz> is pointless and always has been pointless", whereas "now-unused"
> > is likely to be interpreted as "remove <xyz> as it's no longer used after recent
> > changes".
> >
> > Alternatively, can this patch be squashed with the patch that removes
> > mmu_pages_clear_parents()?  Yeah, it'll be a (much?) larger patch, but leaving
> > dead code behind is arguably worse.
> 
> Defined by the C-language and the machine, struct mmu_page_path is used
> in for_each_sp() and the data is set and updated every iteration.
> 
> It is not really dead code.

I'm not talking about just "struct mmu_page_path", but also the pointless updates
in for_each_sp().  And I think even if we're being super pedantic, it _is_ dead
code because C99 allows the compiler to drop code that the compiler can prove has
no side effects.  I learned this the hard way by discovering that an asm() blob
with an output constraint will be elided if the output isn't consumed and the asm()
blob isn't tagged volatile.

  In the abstract machine, all expressions are evaluated as specified by the
  semantics. An actual implementation need not evaluate part of an expression if
  it can deduce that its value is not used and that no needed side effects are
  produced (including any caused by calling a function or accessing a volatile object)

I don't see any advantage to separating this from mmu_pages_clear_parents().  It
doesn't make the code any easier to review.  I'd argue it does the opposite because
it makes it harder to see that mmu_pages_clear_parents() was the only user, i.e.
squashing this would provide further justification for dropping mmu_pages_clear_parents().
