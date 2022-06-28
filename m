Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA8D55DAC4
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241987AbiF1LfC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 07:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236261AbiF1LfB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 07:35:01 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DF32FFE8;
        Tue, 28 Jun 2022 04:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656416099; x=1687952099;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=SeZjE9dIzHv7ak+kD31OSIPBtrgZc4gdk0+yPRC0Dmw=;
  b=aVmPdVZ0U7rOMKOnO4RH8tSKt3bbJ7zuTqa3TXZFl2xWtXbR6EARU3H2
   u5wVk8CHpJ8Uom3ACfBjKJJUYK0EMoKj36JnSzE6AeW6Nbna+J70ujkPk
   DKeM0j1TQWUt9oSjnmb9J80o2DCnvWm3HiyMFn1D68Oy0PTSVpu65FE0b
   WJNI/kq+Ywhs9denZYwfFvAFhPwc11A4xci/8Je3A5gbwOrouf+sM+Hi1
   FqtkJ+J0ACRQmrTRIum/4JAWFQS4aV8KPpEHPh7k8Hj/9ypdA5npXSQe3
   WltpAkA5euINWTLuaZNxfN3h7fywBDYWY2oHgxpPjXVrQG6ff8BiUl1PS
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="270465555"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="270465555"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 04:34:59 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="680009884"
Received: from nherzalx-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.96.221])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 04:34:57 -0700
Message-ID: <2ecd255ac85fac7ffa1b90975c9e08f11ddee149.camel@intel.com>
Subject: Re: [PATCH v7 029/102] KVM: TDX: allocate/free TDX vcpu structure
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue, 28 Jun 2022 23:34:55 +1200
In-Reply-To: <dad0333516bcdb0fdeccc9d1483299aeae8d80fd.1656366338.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <dad0333516bcdb0fdeccc9d1483299aeae8d80fd.1656366338.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>=20
> The next step of TDX guest creation is to create vcpu.  Allocate TDX vcpu
> structures, initialize it.  Allocate pages of TDX vcpu for the TDX module=
.
>=20
> In the case of the conventional case, cpuid is empty at the initializatio=
n.
> and cpuid is configured after the vcpu initialization.  Because TDX
> supports only X2APIC mode, cpuid is forcibly initialized to support X2API=
C
> on the vcpu initialization.

The patch title and commit message of this patch are identical to the previ=
ous
patch.

What happened? Did you forget to squash two patches together?
=20
>=20
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/vmx/main.c    | 40 ++++++++++++++++++++++++++++++++++----
>  arch/x86/kvm/vmx/x86_ops.h |  8 ++++++++
>  2 files changed, 44 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 067f5de56c53..4f4ed4ad65a7 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -73,6 +73,38 @@ static void vt_vm_free(struct kvm *kvm)
>  		return tdx_vm_free(kvm);
>  }
> =20
> +static int vt_vcpu_precreate(struct kvm *kvm)
> +{
> +	if (is_td(kvm))
> +		return 0;
> +
> +	return vmx_vcpu_precreate(kvm);
> +}
> +
> +static int vt_vcpu_create(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_vcpu_create(vcpu);
> +
> +	return vmx_vcpu_create(vcpu);
> +}
> +
> +static void vt_vcpu_free(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_vcpu_free(vcpu);
> +
> +	return vmx_vcpu_free(vcpu);
> +}
> +
> +static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_vcpu_reset(vcpu, init_event);
> +
> +	return vmx_vcpu_reset(vcpu, init_event);
> +}
> +
>  static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	if (!is_td(kvm))
> @@ -98,10 +130,10 @@ struct kvm_x86_ops vt_x86_ops __initdata =3D {
>  	.vm_destroy =3D vt_vm_destroy,
>  	.vm_free =3D vt_vm_free,
> =20
> -	.vcpu_precreate =3D vmx_vcpu_precreate,
> -	.vcpu_create =3D vmx_vcpu_create,
> -	.vcpu_free =3D vmx_vcpu_free,
> -	.vcpu_reset =3D vmx_vcpu_reset,
> +	.vcpu_precreate =3D vt_vcpu_precreate,
> +	.vcpu_create =3D vt_vcpu_create,
> +	.vcpu_free =3D vt_vcpu_free,
> +	.vcpu_reset =3D vt_vcpu_reset,
> =20
>  	.prepare_switch_to_guest =3D vmx_prepare_switch_to_guest,
>  	.vcpu_load =3D vmx_vcpu_load,
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index ef6115ae0e88..42b634971544 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -138,6 +138,10 @@ int tdx_vm_init(struct kvm *kvm);
>  void tdx_mmu_release_hkid(struct kvm *kvm);
>  void tdx_vm_free(struct kvm *kvm);
> =20
> +int tdx_vcpu_create(struct kvm_vcpu *vcpu);
> +void tdx_vcpu_free(struct kvm_vcpu *vcpu);
> +void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
> +
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>  #else
>  static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { retu=
rn 0; }
> @@ -150,6 +154,10 @@ static inline void tdx_mmu_release_hkid(struct kvm *=
kvm) {}
>  static inline void tdx_flush_shadow_all_private(struct kvm *kvm) {}
>  static inline void tdx_vm_free(struct kvm *kvm) {}
> =20
> +static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNO=
TSUPP; }
> +static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
> +static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event=
) {}
> +
>  static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { ret=
urn -EOPNOTSUPP; }
>  #endif
> =20

