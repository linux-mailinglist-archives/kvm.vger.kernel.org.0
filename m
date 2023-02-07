Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE2568D97F
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 14:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbjBGNg7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 08:36:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjBGNg5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 08:36:57 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F421EFDA;
        Tue,  7 Feb 2023 05:36:56 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id j17so3768918ioa.9;
        Tue, 07 Feb 2023 05:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LqXpd+6GmWYDfrIRkTLB84J6lnICdBCs34DL0km+tCE=;
        b=N3TcmGJVFjBtrwsZ2RG4pjyGUp1IacyuB4Ge+jbQnCYjWpR5tk8nUHdMH+Z6obEI1H
         z0X/O0xRNqMEDdgccTlG9Y7gpbfwsLpp3hKMEJrcBQop3wpBQzBcgoajBmlsE4AfkDwC
         8X8LuX5Iapn3LX1vHaRqUhsoAxb51bYWCuyBJ791BfFsPMMtmPLbwAx0sueTkfy321ad
         2NlzL0mInVCrooOWVM3xc5glk/MdRjO8RScLzBvgBPtJmDGMwLBRhI8mXXTsn0LdGQM5
         MJcHAEf29hMH+FSFiqrTw+L4zDL/Vd182Xv/iXLjSMjQxD3YG4lHyM8uChvuZww93qA1
         C4hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LqXpd+6GmWYDfrIRkTLB84J6lnICdBCs34DL0km+tCE=;
        b=Mo7g1jA3U0vNJ6rOoJC1+zQNzsZRKszPxkXSQfGw1BeZBh0esxSz8/8ar43sOpVIrs
         xnYcIpNrcZENzPe3djFI3kdPtFJZNtxNlOqdY8UIQzZq1Gt6mtIgRBc5qf3+qQLSdaKX
         /HVLsLw2ezE2IG5lLi2w+kNc3H226G987GZZLdVYPJHDtfdlYf+yKOlr78/aagdFLOG6
         mZoRve2zVBc6weYw2ldysay5OWkgHO/XcSIqm4rMkgB7T9v77GmZZNxSOLBvRv2CSUmG
         aUyygy4oC/440mPgCs/6Mlf+0HRr+xsLA1ZjMi6loEluejKBmH8pwbDIK/2vyMaBr2LY
         xYRw==
X-Gm-Message-State: AO0yUKXZ0Go3gzZbzMUEibmP4923EaDF3TCig/pnpMluaylKqfpRS40l
        MYwXbkePbxaSqJdebJ/lrHk=
X-Google-Smtp-Source: AK7set+ex0hb9lnsfVO1HWuaLoiKbuVU/Q+WxlhALTQlZDZjPXz+qVJEZ/j5ztvo/L3YqjPNy9cF5w==
X-Received: by 2002:a6b:7019:0:b0:72c:f57a:a37b with SMTP id l25-20020a6b7019000000b0072cf57aa37bmr2265815ioc.2.1675777016160;
        Tue, 07 Feb 2023 05:36:56 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id l7-20020a056638220700b0039e89ea68f9sm4254787jas.135.2023.02.07.05.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 05:36:55 -0800 (PST)
Date:   Tue, 7 Feb 2023 15:36:51 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 3/6] KVM: x86: Do not unload MMU roots when only
 toggling CR0.WP
Message-ID: <20230207153651.000067f8@gmail.com>
In-Reply-To: <20230201194604.11135-4-minipli@grsecurity.net>
References: <20230201194604.11135-1-minipli@grsecurity.net>
        <20230201194604.11135-4-minipli@grsecurity.net>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  1 Feb 2023 20:46:01 +0100
Mathias Krause <minipli@grsecurity.net> wrote:

> There is no need to unload the MMU roots for a direct MMU role when only
> CR0.WP has changed -- the paging structures are still valid, only the
> permission bitmap needs to be updated.
> 
> One heavy user of toggling CR0.WP is grsecurity's KERNEXEC feature to
> implement kernel W^X.
> 

Wouldn't it be better to factor out update_permission_bitmask and
update_pkru_bitmask in a common function and call it from here? So that
we can also skip: bunches of if..else..., recalculation of the rsvd mask
and shadow_zero_bit masks.

I suppose this is a critical path according to the patch comments and
kvm_init_mmu() is a non-critical path. Is it better to seperate 
them now for saving the maintanence efforts in future? E.g. something heavier 
might be introduced into the kvm_init_mmu() path and slows down this path.

> The optimization brings a huge performance gain for this case as the
> following micro-benchmark running 'ssdd 10 50000' from rt-tests[1] on a
> grsecurity L1 VM shows (runtime in seconds, lower is better):
> 
>                        legacy     TDP    shadow
> kvm.git/queue          11.55s   13.91s    75.2s
> kvm.git/queue+patch     7.32s    7.31s    74.6s
> 
> For legacy MMU this is ~36% faster, for TTP MMU even ~47% faster. Also
> TDP and legacy MMU now both have around the same runtime which vanishes
> the need to disable TDP MMU for grsecurity.
> 
> Shadow MMU sees no measurable difference and is still slow, as expected.
> 
> [1] https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git
> 
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---
> v2: handle the CR0.WP case directly in kvm_post_set_cr0() and only for
> the direct MMU role -- Sean
> 
> I re-ran the benchmark and it's even faster than with my patch, as the
> critical path is now the first one handled and is now inline. Thanks a
> lot for the suggestion, Sean!
> 
>  arch/x86/kvm/x86.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 508074e47bc0..f09bfc0a3cc1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -902,6 +902,15 @@ EXPORT_SYMBOL_GPL(load_pdptrs);
>  
>  void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0)
>  {
> +	/*
> +	 * Toggling just CR0.WP doesn't invalidate page tables per se, only the
> +	 * permission bits.
> +	 */
> +	if (vcpu->arch.mmu->root_role.direct && (cr0 ^ old_cr0) == X86_CR0_WP) {
> +		kvm_init_mmu(vcpu);
> +		return;
> +	}
> +
>  	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
>  		kvm_clear_async_pf_completion_queue(vcpu);
>  		kvm_async_pf_hash_reset(vcpu);

