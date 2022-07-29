Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319855849A4
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 04:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbiG2COk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 22:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbiG2COj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 22:14:39 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA17A7AB0B;
        Thu, 28 Jul 2022 19:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659060878; x=1690596878;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Hk7ObuyZNKuFnFxw79jUB5kZnRA2hTB7PWYDIHqm9xw=;
  b=MPe2rJYRAR2iXBsfNoJTXQ7Sj0BRIi4qXXAgp3wsaIz66kyeRVFput6W
   SUggjWK0VTcU1VMNLo82cZSfZOBEoC1Nbzbtr73yqJSBbZYbaJ2VXkFKd
   n5LPWjNyWTa0Imtx4z/Jf7TFiLLzzVoXWoCkqLfI0tmsiDXCLFEcxBS9Z
   1oGgjAufGFqY8olTPlQ1Ci7/HmGUuvwLEdb9InWhobTthhJeEyJWWnLY2
   TUWObctqvuLPW+ifrLHulgEpm1ldTJ5kFX6z+/+EcGi7iBFCAScoweh6k
   vmqUPxsOQ5bL+0QrSFepXrZaTZ+h87ZT/8tyqOYSvLFFuAH3bwEZ9YBTK
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="269053241"
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="269053241"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 19:14:38 -0700
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="633966880"
Received: from mdharmap-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.28.140])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 19:14:36 -0700
Message-ID: <83343080fe848fea9f2318e1d1a6ff5066c6a65c.camel@intel.com>
Subject: Re: [PATCH 1/4] KVM: x86: Tag kvm_mmu_x86_module_init() with __init
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Date:   Fri, 29 Jul 2022 14:14:34 +1200
In-Reply-To: <20220728221759.3492539-2-seanjc@google.com>
References: <20220728221759.3492539-1-seanjc@google.com>
         <20220728221759.3492539-2-seanjc@google.com>
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
> Mark kvm_mmu_x86_module_init() with __init, the entire reason it exists
> is to initialize variables when kvm.ko is loaded, i.e. it must never be
> called after module initialization.
>=20
> Fixes: 1d0e84806047 ("KVM: x86/mmu: Resolve nx_huge_pages when kvm.ko is =
loaded")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 +-
>  arch/x86/kvm/mmu/mmu.c          | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index e8281d64a431..5ffa578cafe1 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1704,7 +1704,7 @@ static inline int kvm_arch_flush_remote_tlb(struct =
kvm *kvm)
>  #define kvm_arch_pmi_in_guest(vcpu) \
>  	((vcpu) && (vcpu)->arch.handling_intr_from_guest)
> =20
> -void kvm_mmu_x86_module_init(void);
> +void __init kvm_mmu_x86_module_init(void);
>  int kvm_mmu_vendor_module_init(void);
>  void kvm_mmu_vendor_module_exit(void);
> =20
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 8e477333a263..2975fcb14c86 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6700,7 +6700,7 @@ static int set_nx_huge_pages(const char *val, const=
 struct kernel_param *kp)
>   * nx_huge_pages needs to be resolved to true/false when kvm.ko is loade=
d, as
>   * its default value of -1 is technically undefined behavior for a boole=
an.
>   */
> -void kvm_mmu_x86_module_init(void)
> +void __init kvm_mmu_x86_module_init(void)
>  {
>  	if (nx_huge_pages =3D=3D -1)
>  		__set_nx_huge_pages(get_nx_auto_mode());

Reviewed-by: Kai Huang <kai.huang@intel.com>

--=20
Thanks,
-Kai


