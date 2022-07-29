Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE58584992
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 04:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbiG2CGL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 22:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233906AbiG2CGK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 22:06:10 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABCA2DAAA;
        Thu, 28 Jul 2022 19:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659060369; x=1690596369;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=rs2/eATCbmzadGWF1GWP/qxxvgampRL+4yn0gqpQz1Y=;
  b=Xhhqa2LA2pcPXVXplz89FkYW4sewVJdBrmizcVnsVdVCMJBxXSC3EPan
   v6/S9xTZossRR7J/kgXkbTYRTlJKoD67KunrwOzn9Jv+H2R2bRS1JdF6p
   Styjbs/7bHseK/SfWLSJBZO8OnJoT7P8+KOH5YiTh/aUTB3r4T3uUcnaW
   OlXD7C5tV1punox94iBgJSLiSWT9FxjrY4rWYvAhh+u1POHRxGoU9b05p
   DqTnIOFcpHc2WdtQfOUTYhAFwSPI6DjeVHdFAg1odZmBXC1ALlOVqStox
   ClRpnKS5iSzBSubHxhPWFyhnsw6ATsoSs898ONjO48luE6V1QNQ6VOVV2
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="350373905"
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="350373905"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 19:06:09 -0700
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="576759252"
Received: from mdharmap-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.28.140])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 19:06:07 -0700
Message-ID: <9bdfbad2dc9f193fb57f7ee113db7f1c2b96973c.camel@intel.com>
Subject: Re: [PATCH 3/4] KVM: SVM: Adjust MMIO masks (for caching) before
 doing SEV(-ES) setup
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Date:   Fri, 29 Jul 2022 14:06:05 +1200
In-Reply-To: <20220728221759.3492539-4-seanjc@google.com>
References: <20220728221759.3492539-1-seanjc@google.com>
         <20220728221759.3492539-4-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-07-28 at 22:17 +0000, Sean Christopherson wrote:
> Adjust KVM's MMIO masks to account for the C-bit location prior to doing
> SEV(-ES) setup.  A future patch will consume enable_mmio caching during
> SEV setup as SEV-ES _requires_ MMIO caching, i.e. KVM needs to disallow
> SEV-ES if MMIO caching is disabled.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index aef63aae922d..62e89db83bc1 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5034,13 +5034,16 @@ static __init int svm_hardware_setup(void)
>  	/* Setup shadow_me_value and shadow_me_mask */
>  	kvm_mmu_set_me_spte_mask(sme_me_mask, sme_me_mask);
> =20
> -	/* Note, SEV setup consumes npt_enabled. */
> +	svm_adjust_mmio_mask();
> +
> +	/*
> +	 * Note, SEV setup consumes npt_enabled and enable_mmio_caching (which
> +	 * may be modified by svm_adjust_mmio_mask()).
> +	 */
>  	sev_hardware_setup();

If I am not seeing mistakenly, the code in latest queue branch doesn't cons=
ume
enable_mmio_caching.  It is only added in your later patch.

So perhaps adjust the comment or merge patches together?

> =20
>  	svm_hv_hardware_setup();
> =20
> -	svm_adjust_mmio_mask();
> -
>  	for_each_possible_cpu(cpu) {
>  		r =3D svm_cpu_init(cpu);
>  		if (r)

