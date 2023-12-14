Return-Path: <kvm+bounces-4539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EFFC9813E30
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 00:23:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 739551F2263E
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 23:23:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AA3F6C6D9;
	Thu, 14 Dec 2023 23:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TA4y3bHE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761E62DB6E
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 23:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2c9f4bb2e5eso681681fa.1
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 15:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702596184; x=1703200984; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4a9LEp0beFnu/8p3983YyIwXa8hmPxSMvxHr3zij24U=;
        b=TA4y3bHEAy+AHnv7w9ceMefhIpZX81GKa+Dq04/6PwGXdq+2mM49UI/XSbwzk43sPV
         MGl2YNsEpUZQE9ypEwmvJ/k49kwbRtOnPtPtV7k2cao661iOgVVHh3XSKaz4QTJtZK0h
         7QP9vpRFVXznwcXjNdZNQ7Jk+DkCGiDL57HM1Q0bEukpvGb3ZT2JwieP7XA83FEGhePM
         exlkQ4XHABRdFvogh+CbZ2q+mmqWlvaMA3PtWYny1X/VYkqOVcIHHqwr0yfwauMFoQlM
         ASlNQPjYboI/PAPtR5fJLy6ZzNp2isg2GdsaY3SYEqjnH6WSRlTjOrbikojQT6WDITEm
         nmGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702596184; x=1703200984;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4a9LEp0beFnu/8p3983YyIwXa8hmPxSMvxHr3zij24U=;
        b=C1DZ0irLMq/dvRxqZS3wU44Q3dvARX3pW7TXIOKudEsbhdLg9fA6caXtcIc5ce7ihV
         pHRSwfbyAp1e3VPT3mTjd0Zd9EkRr079s59/wW7K36K7eeHZV/4wPpEUg4/B+8VHg+YZ
         TzmEkt0SGZShdBXjgZnV/RFt8/3aPW6c8QynLmpb8hRbOpsvn8HR8tXuhiRhzAraCfXU
         UCDNyFUWzeUaEdwSyiiteiMxOP5AQA2slUCqHd5im+SMmzLT58wxAXs+VcLtKV3ptAk9
         Vnai0sz4G9B5wvNzejiZzte/x6LpiGE6Xo+NI+knmyKKhu5j+RBLVckBTbRiOYBrzsyS
         9knA==
X-Gm-Message-State: AOJu0YxetZd8uGdjblf4MeXm42pmMYmNSAwcCxUKektr5SRdZN0BZFa3
	3DvuAsfEWgWKoJ0/G6Z6Z5hmd+HHHH3rZH8H4cXgcw==
X-Google-Smtp-Source: AGHT+IGKGiS/3/StA5r2Dp0GkrO8zGz+mjoQ6rp95guWVJQ4BveWYe3uUJ9Y2ERNs/53quPYr0kQJkD/oq3vn9eLNMg=
X-Received: by 2002:a05:6512:3a91:b0:50e:1878:77d0 with SMTP id
 q17-20020a0565123a9100b0050e187877d0mr1270052lfu.6.1702596184337; Thu, 14 Dec
 2023 15:23:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1699368322.git.isaku.yamahata@intel.com> <413b6ecf9e1ac90f00d3d0debdef0c3f26673f7d.1699368322.git.isaku.yamahata@intel.com>
In-Reply-To: <413b6ecf9e1ac90f00d3d0debdef0c3f26673f7d.1699368322.git.isaku.yamahata@intel.com>
From: Sagi Shahar <sagis@google.com>
Date: Thu, 14 Dec 2023 15:22:52 -0800
Message-ID: <CAAhR5DFMwVsTMkCR-inY=5UFHJTpfx6qyrUbki=8oag5OU8MmA@mail.gmail.com>
Subject: Re: [PATCH v17 007/116] KVM: TDX: Make TDX VM type supported
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, 
	Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>, Kai Huang <kai.huang@intel.com>, 
	Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com, hang.yuan@intel.com, 
	tina.zhang@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 7, 2023 at 6:57=E2=80=AFAM <isaku.yamahata@intel.com> wrote:
>
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> NOTE: This patch is in position of the patch series for developers to be
> able to test codes during the middle of the patch series although this
> patch series doesn't provide functional features until the all the patche=
s
> of this patch series.  When merging this patch series, this patch can be
> moved to the end.
>
> As first step TDX VM support, return that TDX VM type supported to device
> model, e.g. qemu.  The callback to create guest TD is vm_init callback fo=
r
> KVM_CREATE_VM.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/vmx/main.c    | 18 ++++++++++++++++--
>  arch/x86/kvm/vmx/tdx.c     |  6 ++++++
>  arch/x86/kvm/vmx/vmx.c     |  6 ------
>  arch/x86/kvm/vmx/x86_ops.h |  3 ++-
>  4 files changed, 24 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 2b805bb95b9e..73a1c4b64819 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -10,6 +10,12 @@
>  static bool enable_tdx __ro_after_init;
>  module_param_named(tdx, enable_tdx, bool, 0444);
>
> +static bool vt_is_vm_type_supported(unsigned long type)
> +{
> +       return __kvm_is_vm_type_supported(type) ||
> +               (enable_tdx && tdx_is_vm_type_supported(type));
> +}
> +
>  static int vt_hardware_enable(void)
>  {
>         int ret;
> @@ -37,6 +43,14 @@ static __init int vt_hardware_setup(void)
>         return 0;
>  }
>
> +static int vt_vm_init(struct kvm *kvm)
> +{
> +       if (is_td(kvm))
> +               return -EOPNOTSUPP;     /* Not ready to create guest TD y=
et. */
> +
> +       return vmx_vm_init(kvm);
> +}
> +
>  #define VMX_REQUIRED_APICV_INHIBITS                            \
>         (BIT(APICV_INHIBIT_REASON_DISABLE)|                     \
>          BIT(APICV_INHIBIT_REASON_ABSENT) |                     \
> @@ -57,9 +71,9 @@ struct kvm_x86_ops vt_x86_ops __initdata =3D {
>         .hardware_disable =3D vmx_hardware_disable,
>         .has_emulated_msr =3D vmx_has_emulated_msr,
>
> -       .is_vm_type_supported =3D vmx_is_vm_type_supported,
> +       .is_vm_type_supported =3D vt_is_vm_type_supported,

I don't see is_vm_type_supported defined at HEAD.
I could only find it here:
https://lore.kernel.org/lkml/ab9d8654bd98ae24de05788a2ecaa4bea6c0c44b.16898=
93403.git.isaku.yamahata@intel.com/#r
Is [RFC PATCH v4 00/10] KVM: guest_memfd(), X86: Common base ..." a
dependency for this patch series?

>         .vm_size =3D sizeof(struct kvm_vmx),
> -       .vm_init =3D vmx_vm_init,
> +       .vm_init =3D vt_vm_init,
>         .vm_destroy =3D vmx_vm_destroy,
>
>         .vcpu_precreate =3D vmx_vcpu_precreate,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 1c9884164566..9d3f593eacb8 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -24,6 +24,12 @@ static int __init tdx_module_setup(void)
>         return 0;
>  }
>
> +bool tdx_is_vm_type_supported(unsigned long type)
> +{
> +       /* enable_tdx check is done by the caller. */
> +       return type =3D=3D KVM_X86_TDX_VM;
> +}
> +
>  struct vmx_tdx_enabled {
>         cpumask_var_t vmx_enabled;
>         atomic_t err;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 34165a3c99fa..83b0b62cab6c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7532,12 +7532,6 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
>         return err;
>  }
>
> -bool vmx_is_vm_type_supported(unsigned long type)
> -{
> -       /* TODO: Check if TDX is supported. */
> -       return __kvm_is_vm_type_supported(type);
> -}
> -
>  #define L1TF_MSG_SMT "L1TF CPU bug present and SMT on, data leak possibl=
e. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide=
/hw-vuln/l1tf.html for details.\n"
>  #define L1TF_MSG_L1D "L1TF CPU bug present and virtualization mitigation=
 disabled, data leak possible. See CVE-2018-3646 and https://www.kernel.org=
/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
>
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 86c8ee6954e5..ed9147f7b958 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -28,7 +28,6 @@ void vmx_hardware_unsetup(void);
>  int vmx_check_processor_compat(void);
>  int vmx_hardware_enable(void);
>  void vmx_hardware_disable(void);
> -bool vmx_is_vm_type_supported(unsigned long type);
>  int vmx_vm_init(struct kvm *kvm);
>  void vmx_vm_destroy(struct kvm *kvm);
>  int vmx_vcpu_precreate(struct kvm *kvm);
> @@ -137,8 +136,10 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
>
>  #ifdef CONFIG_INTEL_TDX_HOST
>  int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
> +bool tdx_is_vm_type_supported(unsigned long type);
>  #else
>  static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { retu=
rn -EOPNOTSUPP; }
> +static inline bool tdx_is_vm_type_supported(unsigned long type) { return=
 false; }
>  #endif
>
>  #endif /* __KVM_X86_VMX_X86_OPS_H */
> --
> 2.25.1
>

