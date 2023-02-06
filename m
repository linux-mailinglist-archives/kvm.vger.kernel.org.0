Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9453968BA0F
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 11:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbjBFK1j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 05:27:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjBFK1i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 05:27:38 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E763659F
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 02:27:36 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id k13so2460777wrh.8
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 02:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Bt3iPbBqpkMMB6Blk/cGiMxMGE0Xi+8A+qjDF3j4Z7c=;
        b=pUPr4uBIwBBGyU3qcdAnhDXq44F65oSo0W+0p2xVcfzTzgYWvYmUkRryfd/onxt5A6
         TM+Y0rV8WqPJGOpTlcMrRCz34iDW5k03PSE2cKUU5+UKCiVKE6Rhq23f+vBY1qklPhsR
         bbGNg93hEXB/F6gQFkCmVTtRmYdn+6wG5mZG94fg/gK7teBXiKCovd53iqulZkTuwhb8
         +cBONpVEfDpXXMB/VVMWjZeB0FkXaNvr0S65pEY8aTHTtCbtgWuz/v36didiGaUn6Ozk
         odDsi+Tmk0kSYxEAHX73VXpq8mgO/8EOcQtJBzWtsUmADHc2znEfH7yr8oTyD4obKimK
         opKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bt3iPbBqpkMMB6Blk/cGiMxMGE0Xi+8A+qjDF3j4Z7c=;
        b=psx9ldWv+njNEaiA7x7pASAY/nqRj/gTJpTpKPRUYCipisuKVDsWfKhEKnxcRqw3pZ
         bi86Y7QcE6jM1ngwdeQ2YLd+r1JAS7PSYf3v3Ogwv/QqBE+txhUjHCgDVN+n2wxgbdMo
         uUGNcSWfcpAmvTtrqU3SwGSaroE/2Gkd1p+V5rBZXvSj0AZktRhjW4wjehLgg2WN9GFa
         7k07W2N/o3oA6a/c8LCbDI5Jz2HWmcT5IoNlvFRp9g1qzyKKA+k9bK0K8Exrn0yxtRh2
         rQtnjnOuPkg0zaPOcCWLeSen5F9CTEcNQIxHYTkGwbHwh8yGKzuYm90ZI85OUuD4pSTG
         sNzA==
X-Gm-Message-State: AO0yUKXQ82K+Zu7gAMFLL1RejNAOFd97b/r0AK2JJhMqaLZvRQ5z7u6C
        ZdBqSZfnln0FonIf9KfLc4qzLA==
X-Google-Smtp-Source: AK7set/sjxlnJr7H1WT5XBlG5bdkgPjayBIeY7bivdZDmicFbl3k2SAw2J/Eahpy+A9mqC5XRkP+sg==
X-Received: by 2002:a5d:5643:0:b0:2c3:be89:7c2b with SMTP id j3-20020a5d5643000000b002c3be897c2bmr8052767wrw.14.1675679254901;
        Mon, 06 Feb 2023 02:27:34 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id h9-20020a05600c314900b003dfeea6a85csm8444733wmo.31.2023.02.06.02.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 02:27:34 -0800 (PST)
Date:   Mon, 6 Feb 2023 11:27:33 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org, Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 06/14] RISC-V: KVM: Modify SBI extension handler to
 return SBI error code
Message-ID: <20230206102733.ftq2lu7frwqmcixu@orel>
References: <20230205011515.1284674-1-atishp@rivosinc.com>
 <20230205011515.1284674-7-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230205011515.1284674-7-atishp@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 04, 2023 at 05:15:07PM -0800, Atish Patra wrote:
> Currently, the SBI extension handle is expected to return Linux error code.
> The top SBI layer converts the Linux error code to SBI specific error code
> that can be returned to guest invoking the SBI calls. This model works
> as long as SBI error codes have 1-to-1 mappings between them.
> However, that may not be true always. This patch attempts to disassociate
> both these error codes by allowing the SBI extension implementation to
> return SBI specific error codes as well.
> 
> The extension will continue to return the Linux error specific code which
> will indicate any problem *with* the extension emulation while the
> SBI specific error will indicate the problem *of* the emulation.
> 
> Suggested-by: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h | 10 ++++-
>  arch/riscv/kvm/vcpu_sbi.c             | 61 +++++++++++----------------
>  arch/riscv/kvm/vcpu_sbi_base.c        | 22 +++++-----
>  arch/riscv/kvm/vcpu_sbi_hsm.c         | 28 ++++++------
>  arch/riscv/kvm/vcpu_sbi_replace.c     | 43 +++++++++----------
>  arch/riscv/kvm/vcpu_sbi_v01.c         | 17 +++-----
>  6 files changed, 83 insertions(+), 98 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index 45ba341..8425556 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -18,6 +18,13 @@ struct kvm_vcpu_sbi_context {
>  	int return_handled;
>  };
>  
> +struct kvm_vcpu_sbi_return {
> +	unsigned long out_val;
> +	unsigned long err_val;
> +	struct kvm_cpu_trap *utrap;
> +	bool uexit;
> +};
> +
>  struct kvm_vcpu_sbi_extension {
>  	unsigned long extid_start;
>  	unsigned long extid_end;
> @@ -27,8 +34,7 @@ struct kvm_vcpu_sbi_extension {
>  	 * specific error codes.
>  	 */
>  	int (*handler)(struct kvm_vcpu *vcpu, struct kvm_run *run,
> -		       unsigned long *out_val, struct kvm_cpu_trap *utrap,
> -		       bool *exit);
> +		       struct kvm_vcpu_sbi_return *retdata);
>  
>  	/* Extension specific probe function */
>  	unsigned long (*probe)(struct kvm_vcpu *vcpu);
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index f96991d..fe2897e 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -12,26 +12,6 @@
>  #include <asm/sbi.h>
>  #include <asm/kvm_vcpu_sbi.h>
>  
> -static int kvm_linux_err_map_sbi(int err)
> -{
> -	switch (err) {
> -	case 0:
> -		return SBI_SUCCESS;
> -	case -EPERM:
> -		return SBI_ERR_DENIED;
> -	case -EINVAL:
> -		return SBI_ERR_INVALID_PARAM;
> -	case -EFAULT:
> -		return SBI_ERR_INVALID_ADDRESS;
> -	case -EOPNOTSUPP:
> -		return SBI_ERR_NOT_SUPPORTED;
> -	case -EALREADY:
> -		return SBI_ERR_ALREADY_AVAILABLE;
> -	default:
> -		return SBI_ERR_FAILURE;
> -	};
> -}
> -
>  #ifndef CONFIG_RISCV_SBI_V01
>  static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
>  	.extid_start = -1UL,
> @@ -125,11 +105,14 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  {
>  	int ret = 1;
>  	bool next_sepc = true;
> -	bool userspace_exit = false;
>  	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
>  	const struct kvm_vcpu_sbi_extension *sbi_ext;
> -	struct kvm_cpu_trap utrap = { 0 };
> -	unsigned long out_val = 0;
> +	struct kvm_cpu_trap utrap = {0};
> +	struct kvm_vcpu_sbi_return sbi_ret = {
> +		.out_val = 0,
> +		.err_val = 0,
> +		.utrap = &utrap,
> +	};
>  	bool ext_is_v01 = false;
>  
>  	sbi_ext = kvm_vcpu_sbi_find_ext(cp->a7);
> @@ -139,42 +122,46 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		    cp->a7 <= SBI_EXT_0_1_SHUTDOWN)
>  			ext_is_v01 = true;
>  #endif
> -		ret = sbi_ext->handler(vcpu, run, &out_val, &utrap, &userspace_exit);
> +		ret = sbi_ext->handler(vcpu, run, &sbi_ret);
>  	} else {
>  		/* Return error for unsupported SBI calls */
>  		cp->a0 = SBI_ERR_NOT_SUPPORTED;
>  		goto ecall_done;
>  	}
>  
> +	/*
> +	 * When the SBI extension returns a Linux error code, it exits the ioctl
> +	 * loop and forwards the error to userspace.
> +	 */
> +	if (ret < 0) {
> +		next_sepc = false;
> +		goto ecall_done;
> +	}
> +
>  	/* Handle special error cases i.e trap, exit or userspace forward */
> -	if (utrap.scause) {
> +	if (sbi_ret.utrap->scause) {
>  		/* No need to increment sepc or exit ioctl loop */
>  		ret = 1;
> -		utrap.sepc = cp->sepc;
> -		kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
> +		sbi_ret.utrap->sepc = cp->sepc;
> +		kvm_riscv_vcpu_trap_redirect(vcpu, sbi_ret.utrap);
>  		next_sepc = false;
>  		goto ecall_done;
>  	}
>  
>  	/* Exit ioctl loop or Propagate the error code the guest */
> -	if (userspace_exit) {
> +	if (sbi_ret.uexit) {
>  		next_sepc = false;
>  		ret = 0;
>  	} else {
> -		/**
> -		 * SBI extension handler always returns an Linux error code. Convert
> -		 * it to the SBI specific error code that can be propagated the SBI
> -		 * caller.
> -		 */
> -		ret = kvm_linux_err_map_sbi(ret);
> -		cp->a0 = ret;
> +		cp->a0 = sbi_ret.err_val;
>  		ret = 1;
>  	}
>  ecall_done:
>  	if (next_sepc)
>  		cp->sepc += 4;
> -	if (!ext_is_v01)
> -		cp->a1 = out_val;
> +	/* a1 should only be updated when we continue the ioctl loop */
> +	if (!ext_is_v01 && ret == 1)
> +		cp->a1 = sbi_ret.out_val;
>  
>  	return ret;
>  }
> diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_base.c
> index be47828..9945aff 100644
> --- a/arch/riscv/kvm/vcpu_sbi_base.c
> +++ b/arch/riscv/kvm/vcpu_sbi_base.c
> @@ -14,12 +14,11 @@
>  #include <asm/kvm_vcpu_sbi.h>
>  
>  static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> -				    unsigned long *out_val,
> -				    struct kvm_cpu_trap *trap, bool *exit)
> +				    struct kvm_vcpu_sbi_return *retdata)
>  {
> -	int ret = 0;
>  	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
>  	const struct kvm_vcpu_sbi_extension *sbi_ext;
> +	unsigned long *out_val = &retdata->out_val;
>  
>  	switch (cp->a6) {
>  	case SBI_EXT_BASE_GET_SPEC_VERSION:
> @@ -43,10 +42,11 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  			 * forward it to the userspace
>  			 */
>  			kvm_riscv_vcpu_sbi_forward(vcpu, run);
> -			*exit = true;
> +			retdata->uexit = true;
>  		} else {
>  			sbi_ext = kvm_vcpu_sbi_find_ext(cp->a0);
> -			*out_val = sbi_ext && sbi_ext->probe ? sbi_ext->probe(vcpu) : !!sbi_ext;
> +			*out_val = sbi_ext && sbi_ext->probe ?
> +					   sbi_ext->probe(vcpu) : !!sbi_ext;

This should have been done in the patch that introduced it. Or, not at
all, if we don't mind going up to 100 chars in KVM code (as checkpatch
allows).

>  		}
>  		break;
>  	case SBI_EXT_BASE_GET_MVENDORID:
> @@ -59,11 +59,11 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  		*out_val = vcpu->arch.mimpid;
>  		break;
>  	default:
> -		ret = -EOPNOTSUPP;
> +		retdata->err_val = SBI_ERR_NOT_SUPPORTED;
>  		break;
>  	}
>  
> -	return ret;
> +	return 0;
>  }
>  
>  const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base = {
> @@ -73,17 +73,15 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base = {
>  };
>  
>  static int kvm_sbi_ext_forward_handler(struct kvm_vcpu *vcpu,
> -					struct kvm_run *run,
> -					unsigned long *out_val,
> -					struct kvm_cpu_trap *utrap,
> -					bool *exit)
> +				       struct kvm_run *run,
> +				       struct kvm_vcpu_sbi_return *retdata)
>  {
>  	/*
>  	 * Both SBI experimental and vendor extensions are
>  	 * unconditionally forwarded to userspace.
>  	 */
>  	kvm_riscv_vcpu_sbi_forward(vcpu, run);
> -	*exit = true;
> +	retdata->uexit = true;
>  	return 0;
>  }
>  
> diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.c
> index 619ac0f..7dca0e9 100644
> --- a/arch/riscv/kvm/vcpu_sbi_hsm.c
> +++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
> @@ -21,9 +21,9 @@ static int kvm_sbi_hsm_vcpu_start(struct kvm_vcpu *vcpu)
>  
>  	target_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, target_vcpuid);
>  	if (!target_vcpu)
> -		return -EINVAL;
> +		return SBI_ERR_INVALID_PARAM;
>  	if (!target_vcpu->arch.power_off)
> -		return -EALREADY;
> +		return SBI_ERR_ALREADY_AVAILABLE;
>  
>  	reset_cntx = &target_vcpu->arch.guest_reset_context;
>  	/* start address */
> @@ -42,7 +42,7 @@ static int kvm_sbi_hsm_vcpu_start(struct kvm_vcpu *vcpu)
>  static int kvm_sbi_hsm_vcpu_stop(struct kvm_vcpu *vcpu)
>  {
>  	if (vcpu->arch.power_off)
> -		return -EACCES;
> +		return SBI_ERR_FAILURE;
>  
>  	kvm_riscv_vcpu_power_off(vcpu);
>  
> @@ -57,7 +57,7 @@ static int kvm_sbi_hsm_vcpu_get_status(struct kvm_vcpu *vcpu)
>  
>  	target_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, target_vcpuid);
>  	if (!target_vcpu)
> -		return -EINVAL;
> +		return SBI_ERR_INVALID_PARAM;
>  	if (!target_vcpu->arch.power_off)
>  		return SBI_HSM_STATE_STARTED;
>  	else if (vcpu->stat.generic.blocking)
> @@ -67,9 +67,7 @@ static int kvm_sbi_hsm_vcpu_get_status(struct kvm_vcpu *vcpu)
>  }
>  
>  static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> -				   unsigned long *out_val,
> -				   struct kvm_cpu_trap *utrap,
> -				   bool *exit)
> +				   struct kvm_vcpu_sbi_return *retdata)
>  {
>  	int ret = 0;
>  	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> @@ -88,27 +86,29 @@ static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  	case SBI_EXT_HSM_HART_STATUS:
>  		ret = kvm_sbi_hsm_vcpu_get_status(vcpu);
>  		if (ret >= 0) {
> -			*out_val = ret;
> -			ret = 0;
> +			retdata->out_val = ret;
> +			retdata->err_val = 0;
>  		}
> -		break;
> +		return 0;
>  	case SBI_EXT_HSM_HART_SUSPEND:
>  		switch (cp->a0) {
>  		case SBI_HSM_SUSPEND_RET_DEFAULT:
>  			kvm_riscv_vcpu_wfi(vcpu);
>  			break;
>  		case SBI_HSM_SUSPEND_NON_RET_DEFAULT:
> -			ret = -EOPNOTSUPP;
> +			ret = SBI_ERR_NOT_SUPPORTED;
>  			break;
>  		default:
> -			ret = -EINVAL;
> +			ret = SBI_ERR_INVALID_PARAM;
>  		}
>  		break;
>  	default:
> -		ret = -EOPNOTSUPP;
> +		ret = SBI_ERR_NOT_SUPPORTED;
>  	}
>  
> -	return ret;
> +	retdata->err_val = ret;
> +
> +	return 0;
>  }
>  
>  const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm = {
> diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
> index 03a0198..38fa4c0 100644
> --- a/arch/riscv/kvm/vcpu_sbi_replace.c
> +++ b/arch/riscv/kvm/vcpu_sbi_replace.c
> @@ -14,15 +14,15 @@
>  #include <asm/kvm_vcpu_sbi.h>
>  
>  static int kvm_sbi_ext_time_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> -				    unsigned long *out_val,
> -				    struct kvm_cpu_trap *utrap, bool *exit)
> +				    struct kvm_vcpu_sbi_return *retdata)
>  {
> -	int ret = 0;
>  	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
>  	u64 next_cycle;
>  
> -	if (cp->a6 != SBI_EXT_TIME_SET_TIMER)
> -		return -EINVAL;
> +	if (cp->a6 != SBI_EXT_TIME_SET_TIMER) {
> +		retdata->err_val = SBI_ERR_INVALID_PARAM;
> +		return 0;
> +	}
>  
>  #if __riscv_xlen == 32
>  	next_cycle = ((u64)cp->a1 << 32) | (u64)cp->a0;
> @@ -31,7 +31,7 @@ static int kvm_sbi_ext_time_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  #endif
>  	kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
>  
> -	return ret;
> +	return 0;
>  }
>  
>  const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_time = {
> @@ -41,8 +41,7 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_time = {
>  };
>  
>  static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> -				   unsigned long *out_val,
> -				   struct kvm_cpu_trap *utrap, bool *exit)
> +				   struct kvm_vcpu_sbi_return *retdata)
>  {
>  	int ret = 0;
>  	unsigned long i;
> @@ -51,8 +50,10 @@ static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  	unsigned long hmask = cp->a0;
>  	unsigned long hbase = cp->a1;
>  
> -	if (cp->a6 != SBI_EXT_IPI_SEND_IPI)
> -		return -EINVAL;
> +	if (cp->a6 != SBI_EXT_IPI_SEND_IPI) {
> +		retdata->err_val = SBI_ERR_INVALID_PARAM;
> +		return 0;
> +	}
>  
>  	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
>  		if (hbase != -1UL) {
> @@ -76,10 +77,8 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_ipi = {
>  };
>  
>  static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> -				      unsigned long *out_val,
> -				      struct kvm_cpu_trap *utrap, bool *exit)
> +				      struct kvm_vcpu_sbi_return *retdata)
>  {
> -	int ret = 0;
>  	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
>  	unsigned long hmask = cp->a0;
>  	unsigned long hbase = cp->a1;
> @@ -116,10 +115,10 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
>  		 */
>  		break;
>  	default:
> -		ret = -EOPNOTSUPP;
> +		retdata->err_val = SBI_ERR_NOT_SUPPORTED;
>  	}
>  
> -	return ret;
> +	return 0;
>  }
>  
>  const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence = {
> @@ -130,14 +129,12 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence = {
>  
>  static int kvm_sbi_ext_srst_handler(struct kvm_vcpu *vcpu,
>  				    struct kvm_run *run,
> -				    unsigned long *out_val,
> -				    struct kvm_cpu_trap *utrap, bool *exit)
> +				    struct kvm_vcpu_sbi_return *retdata)
>  {
>  	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
>  	unsigned long funcid = cp->a6;
>  	u32 reason = cp->a1;
>  	u32 type = cp->a0;
> -	int ret = 0;
>  
>  	switch (funcid) {
>  	case SBI_EXT_SRST_RESET:
> @@ -146,24 +143,24 @@ static int kvm_sbi_ext_srst_handler(struct kvm_vcpu *vcpu,
>  			kvm_riscv_vcpu_sbi_system_reset(vcpu, run,
>  						KVM_SYSTEM_EVENT_SHUTDOWN,
>  						reason);
> -			*exit = true;
> +			retdata->uexit = true;
>  			break;
>  		case SBI_SRST_RESET_TYPE_COLD_REBOOT:
>  		case SBI_SRST_RESET_TYPE_WARM_REBOOT:
>  			kvm_riscv_vcpu_sbi_system_reset(vcpu, run,
>  						KVM_SYSTEM_EVENT_RESET,
>  						reason);
> -			*exit = true;
> +			retdata->uexit = true;
>  			break;
>  		default:
> -			ret = -EOPNOTSUPP;
> +			retdata->err_val = SBI_ERR_NOT_SUPPORTED;
>  		}
>  		break;
>  	default:
> -		ret = -EOPNOTSUPP;
> +		retdata->err_val = SBI_ERR_NOT_SUPPORTED;
>  	}
>  
> -	return ret;
> +	return 0;
>  }
>  
>  const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst = {
> diff --git a/arch/riscv/kvm/vcpu_sbi_v01.c b/arch/riscv/kvm/vcpu_sbi_v01.c
> index 489f225..8f4c4fa 100644
> --- a/arch/riscv/kvm/vcpu_sbi_v01.c
> +++ b/arch/riscv/kvm/vcpu_sbi_v01.c
> @@ -14,9 +14,7 @@
>  #include <asm/kvm_vcpu_sbi.h>
>  
>  static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> -				      unsigned long *out_val,
> -				      struct kvm_cpu_trap *utrap,
> -				      bool *exit)
> +				   struct kvm_vcpu_sbi_return *retdata)
>  {
>  	ulong hmask;
>  	int i, ret = 0;
> @@ -24,6 +22,7 @@ static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  	struct kvm_vcpu *rvcpu;
>  	struct kvm *kvm = vcpu->kvm;
>  	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> +	struct kvm_cpu_trap *utrap = retdata->utrap;
>  
>  	switch (cp->a7) {
>  	case SBI_EXT_0_1_CONSOLE_GETCHAR:
> @@ -33,7 +32,7 @@ static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  		 * handled in kernel so we forward these to user-space
>  		 */
>  		kvm_riscv_vcpu_sbi_forward(vcpu, run);
> -		*exit = true;
> +		retdata->uexit = true;
>  		break;
>  	case SBI_EXT_0_1_SET_TIMER:
>  #if __riscv_xlen == 32
> @@ -48,8 +47,7 @@ static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  		break;
>  	case SBI_EXT_0_1_SEND_IPI:
>  		if (cp->a0)
> -			hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
> -							   utrap);
> +			hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0, utrap);
>  		else
>  			hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
>  		if (utrap->scause)
> @@ -65,14 +63,13 @@ static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  	case SBI_EXT_0_1_SHUTDOWN:
>  		kvm_riscv_vcpu_sbi_system_reset(vcpu, run,
>  						KVM_SYSTEM_EVENT_SHUTDOWN, 0);
> -		*exit = true;
> +		retdata->uexit = true;
>  		break;
>  	case SBI_EXT_0_1_REMOTE_FENCE_I:
>  	case SBI_EXT_0_1_REMOTE_SFENCE_VMA:
>  	case SBI_EXT_0_1_REMOTE_SFENCE_VMA_ASID:
>  		if (cp->a0)
> -			hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
> -							   utrap);
> +			hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0, utrap);
>  		else
>  			hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
>  		if (utrap->scause)
> @@ -103,7 +100,7 @@ static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  		}
>  		break;
>  	default:
> -		ret = -EINVAL;
> +		retdata->err_val = SBI_ERR_NOT_SUPPORTED;
>  		break;
>  	}
>  
> -- 
> 2.25.1
>

I actually gave this an r-b in v4, since I only pointed out nits, but
anyway, here it is again

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew
