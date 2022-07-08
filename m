Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50C756B07D
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 04:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236867AbiGHCP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 22:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiGHCPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 22:15:25 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E16671BF0;
        Thu,  7 Jul 2022 19:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657246524; x=1688782524;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=xw1SIqIwzFrSgi8+b3nUio7hEWEDpdkeZIzua3urlUE=;
  b=NZskP09Grwb3LfS+V3/pZejFcBKLyhr3LzkQrIguzrjvuRttTAurIO5b
   03qjDKj+a0CO0SLm6E+kFLXOkZZuRWDY/nYZww+jb2R8zovGdar4AY2GU
   ZAg05vLP7DOi7ZMln5W0AtI6SIATdkDOHCOICZSqqeBsgBzP5Sat28jAv
   ANuN+p/H2pcjFS9sTxBkX/JR8Xvgfh52xUrJMVKas9agO0GTKvFIbk8Uh
   UYIveO0+IujToH2Ii9HDWsBUvYy4byVmxY4iWwdZFriv7YhZpW56t/5vL
   WT6pEsd/L98JLkI6MsF4Kt4BevYPxWSTfFvibXRQA4Q288CNi0ABUrfrA
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="285295785"
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="285295785"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 19:15:23 -0700
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="598226327"
Received: from pantones-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.54.208])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 19:15:22 -0700
Message-ID: <6cc36b662dffaf0aa2a2f389f073daa2d63a530b.camel@intel.com>
Subject: Re: [PATCH v7 033/102] KVM: x86/mmu: Add address conversion
 functions for TDX shared bits
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Date:   Fri, 08 Jul 2022 14:15:20 +1200
In-Reply-To: <69f4b4942d5f17fad40a8d08556488b8e4b7954d.1656366338.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <69f4b4942d5f17fad40a8d08556488b8e4b7954d.1656366338.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> From: Rick Edgecombe <rick.p.edgecombe@intel.com>

I don't think this is appropriate any more.  You can add Co-developed-by I
guess.

>=20
> TDX repurposes one GPA bits (51 bit or 47 bit based on configuration) to
> indicate the GPA is private(if cleared) or shared (if set) with VMM.  If
> GPA.shared is set, GPA is converted existing conventional EPT pointed by
> EPTP.  If GPA.shared bit is cleared, GPA is converted by Secure-EPT(S-EPT=
)

Not sure whether Secure EPT has even been mentioned before in this series. =
 If
not, perhaps better to explain it here.  Or not sure whether you need to me=
ntion
S-EPT at all.

> TDX module manages.  VMM has to issue SEAM call to TDX module to operate =
on

SEAM call -> SEAMCALL

> S-EPT.  e.g. populating/zapping guest page or shadow page by TDH.PAGE.{AD=
D,
> REMOVE} for guest page, TDH.PAGE.SEPT.{ADD, REMOVE} S-EPT etc.

Not sure why you want to mention those particular SEAMCALLs.

>=20
> Several hooks needs to be added to KVM MMU to support TDX.  Add a functio=
n

needs -> need.

Not sure why you need first sentence at all.

But I do think you should mention adding per-VM scope 'gfn_shared_mask' thi=
ng.

> to check if KVM MMU is running for TDX and several functions for address
> conversation between private-GPA and shared-GPA.
>=20
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/mmu.h              | 32 ++++++++++++++++++++++++++++++++
>  2 files changed, 34 insertions(+)
>=20
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index e5d4e5b60fdc..2c47aab72a1b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1339,7 +1339,9 @@ struct kvm_arch {
>  	 */
>  	u32 max_vcpu_ids;
> =20
> +#ifdef CONFIG_KVM_MMU_PRIVATE
>  	gfn_t gfn_shared_mask;
> +#endif

As Xiaoyao said, please introduce gfn_shared_mask in this patch.

And by applying this patch, nothing will prevent you to turn on INTEL_TDX_H=
OST
and KVM_INTEL, which also turns on KVM_MMU_PRIVATE.

So 'kvm_arch::gfn_shared_mask' is guaranteed to be 0?  If not, can legal
(shared) GFN for normal VM be potentially treated as private?

If yes, perhaps explicitly call out in changelog so people don't need to wo=
rry
about?

>  };
> =20
>  struct kvm_vm_stat {
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index f8192864b496..ccf0ba7a6387 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -286,4 +286,36 @@ static inline gpa_t kvm_translate_gpa(struct kvm_vcp=
u *vcpu,
>  		return gpa;
>  	return translate_nested_gpa(vcpu, gpa, access, exception);
>  }
> +
> +static inline gfn_t kvm_gfn_shared_mask(const struct kvm *kvm)
> +{
> +#ifdef CONFIG_KVM_MMU_PRIVATE
> +	return kvm->arch.gfn_shared_mask;
> +#else
> +	return 0;
> +#endif
> +}
> +
> +static inline gfn_t kvm_gfn_shared(const struct kvm *kvm, gfn_t gfn)
> +{
> +	return gfn | kvm_gfn_shared_mask(kvm);
> +}
> +
> +static inline gfn_t kvm_gfn_private(const struct kvm *kvm, gfn_t gfn)
> +{
> +	return gfn & ~kvm_gfn_shared_mask(kvm);
> +}
> +
> +static inline gpa_t kvm_gpa_private(const struct kvm *kvm, gpa_t gpa)
> +{
> +	return gpa & ~gfn_to_gpa(kvm_gfn_shared_mask(kvm));
> +}
> +
> +static inline bool kvm_is_private_gpa(const struct kvm *kvm, gpa_t gpa)
> +{
> +	gfn_t mask =3D kvm_gfn_shared_mask(kvm);
> +
> +	return mask && !(gpa_to_gfn(gpa) & mask);
> +}
> +
>  #endif

