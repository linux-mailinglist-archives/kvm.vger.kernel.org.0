Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19FA9572B1F
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 03:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbiGMBzx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 21:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiGMBzv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 21:55:51 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A3AC9207;
        Tue, 12 Jul 2022 18:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657677350; x=1689213350;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=pKiiCVx6jGcmxHkWq3i93Q32ZqFOuHeXNvvGly92q1U=;
  b=eDWQ+qFPk+rh9yr0IK2HosdxG2gxtFtmwpjtEWwfVsBwr57oQ0MXauxa
   GWuEmiUDlqq0fUnPbtJftLjqvz6JiBftcf6ehYmslQWaaMIOki/zfsZk0
   ykxW+LaTU8/IGTxUoDNj6CGzWoEmbV65/M/5LEh4gL7kfJJIF1lQSlnDa
   2pvrqV3jETXOLtPFZZoCzycG5b68D7KkJoldeMaj+U/hTi0D5vaGrTgzU
   +6ns/EK6CZcy+YZg4CIJqTkp800w7ozrn0VA969Sd36LArSwzyiqTWRif
   15FZgVl0Bf8gWFXFkeCdMMbYhj3K60RjyudLPfkvMEiF6FIDQItu0h34n
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="285110552"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="285110552"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 18:55:50 -0700
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="628113093"
Received: from ifatima-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.1.196])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 18:55:48 -0700
Message-ID: <e4604ad23788a6d2950c091d04b7b805684a1a01.camel@intel.com>
Subject: Re: [PATCH v7 002/102] Partially revert "KVM: Pass kvm_init()'s
 opaque param to additional arch funcs"
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Chao Gao <chao.gao@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Date:   Wed, 13 Jul 2022 13:55:46 +1200
In-Reply-To: <4566737e3c57c5ab17c0bc29d6f4758744b6eed1.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <4566737e3c57c5ab17c0bc29d6f4758744b6eed1.1656366337.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-27 at 14:52 -0700, isaku.yamahata@intel.com wrote:
> From: Chao Gao <chao.gao@intel.com>
>=20
> This partially reverts commit b99040853738 ("KVM: Pass kvm_init()'s opaqu=
e
> param to additional arch funcs") remove opaque from
> kvm_arch_check_processor_compat because no one uses this opaque now.
> Address conflicts for ARM (due to file movement) and manually handle RISC=
-V
> which comes after the commit.
>=20
> And changes about kvm_arch_hardware_setup() in original commit are still
> needed so they are not reverted.

I tried to dig the history to find out why we are doing this.

IMHO it's better to give a reason why you need to revert the opaque.  I gue=
ss no
one uses this opaque now doesn't mean we need to remove it?

Perhaps you should mention this is a preparation to
hardware_enable_all()/hardware_disable_all() during module loading time.=
=20
Instead of extending hardware_enable_all()/hardware_disable_all() to take t=
he
opaque and pass to kvm_arch_check_process_compat(), just remove the opaque.

Or perhaps just merge this patch to next one?

>=20
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Acked-by: Anup Patel <anup@brainfault.org>
> Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Link: https://lore.kernel.org/r/20220216031528.92558-3-chao.gao@intel.com
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/arm64/kvm/arm.c       |  2 +-
>  arch/mips/kvm/mips.c       |  2 +-
>  arch/powerpc/kvm/powerpc.c |  2 +-
>  arch/riscv/kvm/main.c      |  2 +-
>  arch/s390/kvm/kvm-s390.c   |  2 +-
>  arch/x86/kvm/x86.c         |  2 +-
>  include/linux/kvm_host.h   |  2 +-
>  virt/kvm/kvm_main.c        | 16 +++-------------
>  8 files changed, 10 insertions(+), 20 deletions(-)
>=20
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index a0188144a122..7588efbac6be 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -68,7 +68,7 @@ int kvm_arch_hardware_setup(void *opaque)
>  	return 0;
>  }
> =20
> -int kvm_arch_check_processor_compat(void *opaque)
> +int kvm_arch_check_processor_compat(void)
>  {
>  	return 0;
>  }
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index a25e0b73ee70..092d09fb6a7e 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -140,7 +140,7 @@ int kvm_arch_hardware_setup(void *opaque)
>  	return 0;
>  }
> =20
> -int kvm_arch_check_processor_compat(void *opaque)
> +int kvm_arch_check_processor_compat(void)
>  {
>  	return 0;
>  }
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 191992fcb2c2..ca8ef51092c6 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -446,7 +446,7 @@ int kvm_arch_hardware_setup(void *opaque)
>  	return 0;
>  }
> =20
> -int kvm_arch_check_processor_compat(void *opaque)
> +int kvm_arch_check_processor_compat(void)
>  {
>  	return kvmppc_core_check_processor_compat();
>  }
> diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> index 1549205fe5fe..f8d6372d208f 100644
> --- a/arch/riscv/kvm/main.c
> +++ b/arch/riscv/kvm/main.c
> @@ -20,7 +20,7 @@ long kvm_arch_dev_ioctl(struct file *filp,
>  	return -EINVAL;
>  }
> =20
> -int kvm_arch_check_processor_compat(void *opaque)
> +int kvm_arch_check_processor_compat(void)
>  {
>  	return 0;
>  }
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 72bd5c9b9617..a05493f1cacf 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -251,7 +251,7 @@ int kvm_arch_hardware_enable(void)
>  	return 0;
>  }
> =20
> -int kvm_arch_check_processor_compat(void *opaque)
> +int kvm_arch_check_processor_compat(void)
>  {
>  	return 0;
>  }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3d9dbaf9828f..30af2bd0b4d5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11799,7 +11799,7 @@ void kvm_arch_hardware_unsetup(void)
>  	static_call(kvm_x86_hardware_unsetup)();
>  }
> =20
> -int kvm_arch_check_processor_compat(void *opaque)
> +int kvm_arch_check_processor_compat(void)
>  {
>  	struct cpuinfo_x86 *c =3D &cpu_data(smp_processor_id());
> =20
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index c20f2d55840c..d4f130a9f5c8 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1442,7 +1442,7 @@ int kvm_arch_hardware_enable(void);
>  void kvm_arch_hardware_disable(void);
>  int kvm_arch_hardware_setup(void *opaque);
>  void kvm_arch_hardware_unsetup(void);
> -int kvm_arch_check_processor_compat(void *opaque);
> +int kvm_arch_check_processor_compat(void);
>  int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
>  bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
>  int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a67e996cbf7f..a5bada53f1fe 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5697,22 +5697,14 @@ void kvm_unregister_perf_callbacks(void)
>  }
>  #endif
> =20
> -struct kvm_cpu_compat_check {
> -	void *opaque;
> -	int *ret;
> -};
> -
> -static void check_processor_compat(void *data)
> +static void check_processor_compat(void *rtn)
>  {
> -	struct kvm_cpu_compat_check *c =3D data;
> -
> -	*c->ret =3D kvm_arch_check_processor_compat(c->opaque);
> +	*(int *)rtn =3D kvm_arch_check_processor_compat();
>  }
> =20
>  int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  		  struct module *module)
>  {
> -	struct kvm_cpu_compat_check c;
>  	int r;
>  	int cpu;
> =20
> @@ -5740,10 +5732,8 @@ int kvm_init(void *opaque, unsigned vcpu_size, uns=
igned vcpu_align,
>  	if (r < 0)
>  		goto out_free_1;
> =20
> -	c.ret =3D &r;
> -	c.opaque =3D opaque;
>  	for_each_online_cpu(cpu) {
> -		smp_call_function_single(cpu, check_processor_compat, &c, 1);
> +		smp_call_function_single(cpu, check_processor_compat, &r, 1);
>  		if (r < 0)
>  			goto out_free_2;
>  	}

