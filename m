Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 531FB6BBFA1
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 23:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbjCOWLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 18:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbjCOWLQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 18:11:16 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C5D51C93
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 15:11:14 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-541a39df9f4so106204417b3.20
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 15:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678918273;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gCEVwhMsnCNBhroQq0PksbnuOcAT6DZi9De9lSt4IwU=;
        b=UoCusXmLUWCe6yj0B3xqAo/e2gP0N3l66LAiPV7qbv1FXtcqD8hON9ildeCpsWSyns
         9HvXarlx5C5NN3zftMPb7YQZw0u95t+MR/v9AFKQP+o+gHanxi//X71O0uStrHXqX4/Q
         OnzqXqJPxSE/0R9uw3lz52EoSwn0x8gALTxQwBRj93QNNAQLcHXUnvXMXDBxfe2DhLZQ
         hgkSTNrThiVng5IytZ/P1Jc1MRGEfxjzy2jQ67FCEUQzq36W/H71+Zqn7ae6SJO2nNEt
         pwgW5Xygxj2fK9cSkq9zPIPif8Q/FiYqS4is28kVLt8utmM3okTkVKlSgzWQg7LEHnOv
         BvFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678918273;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gCEVwhMsnCNBhroQq0PksbnuOcAT6DZi9De9lSt4IwU=;
        b=5f9oopb1lt5DvoIj7A5f3XWQHKqCr25F5HYDuF6UogNhnpNpq3TXGNkNgOuGoT8pUP
         /W8sqXfGBGX5luWeZXInVqsanymYI4RTR9JJXVCoKLwwdjH+SP6U7IUGx088uLzGX24K
         nWmBvt8LMPZHXGOjMlYVjc4yAoMMPnuHNLfBcLCZalOrlAFgCzK8iw+5UAk/sOzEPLpq
         XN9b/me8SHENYgH8Y0skJCF3EtX2uaGGlY9A0LvuPyTR3aNAF3GyT6/hND1qihiMK42O
         pkDP/+Ic09XaZcKyghGs99WWWNWftkIMb/B26x4tbBY48PIRBcsZpy+A6GSYxXAmq0/8
         UY6w==
X-Gm-Message-State: AO0yUKWXHVGZ1LGLGh7h8I+fHsUUXDC5meLZdWnmllXstqbbPjRJZQIb
        5cQLRt7UKqb6DXAMyxjSBNdHtXDMEHI=
X-Google-Smtp-Source: AK7set9scqUadowaVlc0TWWMBSscLvdaL3SvbEDl4+28cp+izN7KJ3h05ZnpUGy+GyG+po/ozmVdQolkEWA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:d84d:0:b0:541:69bc:8626 with SMTP id
 n13-20020a81d84d000000b0054169bc8626mr888877ywl.10.1678918273681; Wed, 15 Mar
 2023 15:11:13 -0700 (PDT)
Date:   Wed, 15 Mar 2023 15:11:12 -0700
In-Reply-To: <20230201194604.11135-4-minipli@grsecurity.net>
Mime-Version: 1.0
References: <20230201194604.11135-1-minipli@grsecurity.net> <20230201194604.11135-4-minipli@grsecurity.net>
Message-ID: <ZBJCgG5leMwT22o8@google.com>
Subject: Re: [PATCH v3 3/6] KVM: x86: Do not unload MMU roots when only
 toggling CR0.WP
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Can you tweak the shortlog to something like this?  I want to make it very clear
that this applies only to the TDP case (more below).  I did a double take when I
first read the subject :-)

  KVM: x86: Do not unload MMU roots when only toggling CR0.WP with TDP enabled

On Wed, Feb 01, 2023, Mathias Krause wrote:
> There is no need to unload the MMU roots for a direct MMU role when only
> CR0.WP has changed -- the paging structures are still valid, only the
> permission bitmap needs to be updated.
> 
> One heavy user of toggling CR0.WP is grsecurity's KERNEXEC feature to
> implement kernel W^X.
> 
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

No need for this, I just threw a snippet at you as part of code review.  And IMO,
if someone goes through the pain of running benchmarks, they get full credit no
matter what ;-)

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

Past me was wrong, which is a very good thing in this case.  Per the APM,

  The host hCR0.WP bit is ignored under nested paging.

which means that CR0.WP doesn't need to be incorporated into the role.  Ha!  And
really-past me even wrote a very nice comment to call that out in commit 31e96bc63655
("KVM: nSVM: Add a comment to document why nNPT uses vmcb01, not vCPU state").

Double ha!  That's all moot, because if this code is reached for a nested MMU,
it means L2 is active and the CR0 being changed is gCR0, not L1's hCR0.

So more simply, this can be

	if (tdp_enabled && (cr0 ^ old_cr0) == X86_CR0_WP)

or if we want to exempt non-paging mode for the shadow MMU as well...

	if ((cr0 ^ old_cr0) == X86_CR0_WP && (tdp_enabled || !(cr0 & X86_CR0_PG)))

Actually, if we bother to check CR0.PG, then we might as well get greedy and
skip _all_ updates when paging is disabled.  E.g. end up with this over two
patches?  First one exempts the tdp_enabled case, second one completely exempts
paging disabled.

	/*
	 * CR0.WP is incorporated into the MMU role, but only for non-nested,
	 * indirect shadow MMUs.  If paging is disabled, no updates are needed
	 * as there are no permission bits to emulate.  If TDP is enabled, the
	 * MMU's metadata needs to be updated, e.g. so that emulating guest
	 * translations does the right thing, but there's no need to unload the
	 * root as CR0.WP doesn't affect SPTEs when TDP is enabled.
	 */
	if ((cr0 ^ old_cr0) == X86_CR0_WP) {
		if (!(cr0 & X86_CR0_PG))
			return;

		if (tdp_enabled) {
			kvm_init_mmu(vcpu);
			return;
		}
	}

