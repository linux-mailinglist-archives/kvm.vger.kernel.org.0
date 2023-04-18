Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16FD16E60E7
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 14:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbjDRMMu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 08:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbjDRMMM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 08:12:12 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D71AC2;
        Tue, 18 Apr 2023 05:12:09 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-4edc51644b6so186422e87.1;
        Tue, 18 Apr 2023 05:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681819928; x=1684411928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mZ8h+ndNTMIUG24ZQra7ng8ybLcIsdGEtKK7j7YDL08=;
        b=DKG7EoCL8NbIwiEwC+Lab7Xdwm2o97Neo76N3IGb26fW83u795UP5NMTO80T0ICgzN
         ygEdvInUIeyZqpapnLOj7pNQdqbn8Y+4cAi133gWIN2yUOCADMiOp01k0dqyd8X6G4/X
         BNExSm/Qo8XydT6ZKW6ALf+499GSWLNClo02sFM8haVtc6eRNOc6ohJ6R2TZmQ8iIemM
         x7qOo8+aUrc7ePtnzj1Qgg/4vbnAtE0vZhNqqmSKY9A2PhEDUdHd5iLT7ItPw+gdijMC
         cSB4rTPlr1H+mB7v/iVdrlcN02/mFrOPShKz93m71KyMBMXfes4XioT+WgSPjyOBjyri
         Ps8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681819928; x=1684411928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mZ8h+ndNTMIUG24ZQra7ng8ybLcIsdGEtKK7j7YDL08=;
        b=l9MC7XlUzVXE+5z2wa98WB0uSH3kM9gKJFF9wMRsMcrbgJjwEpVNje2F+nf7GEA/sk
         sndeg0CNR3oJYts7xPjiyF9Nyr7xQK3nviV3jSktrvmkP6PsM8PzGcJ1F/C9w6DkCLpb
         RIOwHSyyYL+xHBc4ZY71N/TRp4tEWRmllSN9XjxktW4eRX0Z8piSjnoAPI4mT9xY3WUb
         1h7+RSXwx9qK2NhtkRALGIdNgkdkVR/71VIUoTYhtw4OTVxhSLrSOb0EWIbZDhCIl3k9
         CmcdxDMU+QmBSLvaAmTJwDvnLOkeM1hRko68Bkjfn1NpvkoHHpV9Y/6hBIo13ObUUT47
         r10A==
X-Gm-Message-State: AAQBX9c2yZULcwNQ3iD8bPiSu8RfMjHD/+gXjzMViMQ4qJDmmr47VXN4
        hjcQ6RCsL4JUrxMdAX50E4IeMlgGE+Q=
X-Google-Smtp-Source: AKy350b3PoLPnK9MS/gcU1l56xGcDit7YsnJDAt4tbpHAyV9FER72oyh/Yro8rt/I8/TwzU/wx6mEQ==
X-Received: by 2002:ac2:55a9:0:b0:4ec:9f36:9b63 with SMTP id y9-20020ac255a9000000b004ec9f369b63mr2793811lfg.5.1681819927548;
        Tue, 18 Apr 2023 05:12:07 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id o10-20020a05651238aa00b004cb43c9bf9asm2365908lft.208.2023.04.18.05.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 05:12:07 -0700 (PDT)
Date:   Tue, 18 Apr 2023 15:11:10 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Sagi Shahar <sagis@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH 3/5] KVM: TDX: Add base implementation for
 tdx_vm_move_enc_context_from
Message-ID: <20230418151110.00001354.zhi.wang.linux@gmail.com>
In-Reply-To: <20230407201921.2703758-4-sagis@google.com>
References: <20230407201921.2703758-1-sagis@google.com>
        <20230407201921.2703758-4-sagis@google.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  7 Apr 2023 20:19:19 +0000
Sagi Shahar <sagis@google.com> wrote:

What was the status of the src VM when calling the vm_move_enc_context_from?
Is it still active like common live migration or it has been paused?

> This should mostly match the logic in sev_vm_move_enc_context_from.
> 
> Signed-off-by: Sagi Shahar <sagis@google.com>
> ---
>  arch/x86/kvm/vmx/main.c    | 10 +++++++
>  arch/x86/kvm/vmx/tdx.c     | 56 ++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/tdx.h     |  2 ++
>  arch/x86/kvm/vmx/x86_ops.h |  5 ++++
>  4 files changed, 73 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 5b64fe5404958..9d5d0ac465bf6 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -979,6 +979,14 @@ static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
>  	return tdx_vcpu_ioctl(vcpu, argp);
>  }
>  
> +static int vt_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
> +{
> +	if (!is_td(kvm))
> +		return -ENOTTY;
> +
> +	return tdx_vm_move_enc_context_from(kvm, source_fd);
> +}
> +
>  #define VMX_REQUIRED_APICV_INHIBITS		       \
>  (						       \
>         BIT(APICV_INHIBIT_REASON_DISABLE)|	       \
> @@ -1141,6 +1149,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.dev_mem_enc_ioctl = tdx_dev_ioctl,
>  	.mem_enc_ioctl = vt_mem_enc_ioctl,
>  	.vcpu_mem_enc_ioctl = vt_vcpu_mem_enc_ioctl,
> +
> +	.vm_move_enc_context_from = vt_move_enc_context_from,
>  };
>  
>  struct kvm_x86_init_ops vt_init_ops __initdata = {
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 8af7e4e81c860..0999a6d827c99 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2826,3 +2826,59 @@ int __init tdx_init(void)
>  		INIT_LIST_HEAD(&per_cpu(associated_tdvcpus, cpu));
>  	return 0;
>  }
> +
> +static __always_inline bool tdx_guest(struct kvm *kvm)
> +{
> +	struct kvm_tdx *tdx_kvm = to_kvm_tdx(kvm);
> +
> +	return tdx_kvm->finalized;
> +}
        return is_td_finalized()?
> +
> +static int tdx_migrate_from(struct kvm *dst, struct kvm *src)
> +{
> +	return -EINVAL;
> +}
> +
> +int tdx_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
> +{
> +	struct kvm_tdx *dst_tdx = to_kvm_tdx(kvm);
> +	struct file *src_kvm_file;
> +	struct kvm_tdx *src_tdx;
> +	struct kvm *src_kvm;
> +	int ret;
> +
> +	src_kvm_file = fget(source_fd);
> +	if (!file_is_kvm(src_kvm_file)) {
> +		ret = -EBADF;
> +		goto out_fput;
> +	}
> +	src_kvm = src_kvm_file->private_data;
> +	src_tdx = to_kvm_tdx(src_kvm);
> +
> +	ret = pre_move_enc_context_from(kvm, src_kvm,
> +					&dst_tdx->migration_in_progress,
> +					&src_tdx->migration_in_progress);
> +	if (ret)
> +		goto out_fput;
> +
> +	if (tdx_guest(kvm) || !tdx_guest(src_kvm)) {
> +		ret = -EINVAL;
> +		goto out_post;
> +	}
> +
> +	ret = tdx_migrate_from(kvm, src_kvm);
> +	if (ret)
> +		goto out_post;
> +
> +	kvm_vm_dead(src_kvm);
> +	ret = 0;
> +
> +out_post:
> +	post_move_enc_context_from(kvm, src_kvm,
> +				 &dst_tdx->migration_in_progress,
> +				 &src_tdx->migration_in_progress);
> +out_fput:
> +	if (src_kvm_file)
> +		fput(src_kvm_file);
> +	return ret;
> +}
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 71818c5001862..21b7e710be1fd 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -24,6 +24,8 @@ struct kvm_tdx {
>  	atomic_t tdh_mem_track;
>  
>  	u64 tsc_offset;
> +
> +	atomic_t migration_in_progress;
>  };
>  
>  union tdx_exit_reason {
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index d049e0c72ed0c..275f5d75e9bf1 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -187,6 +187,8 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
>  void tdx_flush_tlb(struct kvm_vcpu *vcpu);
>  int tdx_sept_tlb_remote_flush(struct kvm *kvm);
>  void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
> +
> +int tdx_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd);
>  #else
>  static inline int tdx_init(void) { return 0; };
>  static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -ENOSYS; }
> @@ -241,6 +243,9 @@ static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { ret
>  static inline void tdx_flush_tlb(struct kvm_vcpu *vcpu) {}
>  static inline int tdx_sept_tlb_remote_flush(struct kvm *kvm) { return 0; }
>  static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
> +
> +static inline int tdx_vm_move_enc_context_from(struct kvm *kvm, u
> +					       nsigned int source_fd) { return -EOPNOTSUPP; }
>  #endif
>  
>  #if defined(CONFIG_INTEL_TDX_HOST) && defined(CONFIG_KVM_SMM)

