Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 178307CF1D0
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 09:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbjJSH6C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 03:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232620AbjJSH6B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 03:58:01 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B88130
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 00:57:58 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-32d569e73acso6540749f8f.1
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 00:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697702277; x=1698307077; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BaT0UAyyKtssFxQND155cWxNkiluUWACURFJFcXVWDk=;
        b=OTQwklItlLRD3WcaPTmvA6bmBJJWVn+ObaccYbMF7ORoUMkWYRsnIWQvtTij5QRjtO
         l6Op/ZOlu+qTMpm+oxpcw3DO7xabclvPURK+gHyUFd050a1mwc2C5aQ+2mEuBtYoV+tW
         FoSeaRxJ/SDK8byHs5BC5vH44wCeQQrSQ+qEv/I1z3nt8/qPru7FRFe8FDHVuINUjAQE
         R1EGRUl8aw3Eiy7bPQKNc0l1nC1SIffvRoZKp2wj8TmOrOYz5cXT311q4xCki1Pecp70
         qx6g2aHoTX+YFH5m44wMQTSLDyOvCVJTFxcM/n9A5IaWvZERG8WtoI9ZidhLlw1Qfobo
         gnOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697702277; x=1698307077;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BaT0UAyyKtssFxQND155cWxNkiluUWACURFJFcXVWDk=;
        b=pRvHVncQjEUc3Y0jE/tdFliHV9hfdkYLVotv94YPNDSIouAaJ3Ii4yOoE1USu6nf+L
         XR1pPFAmM7SXF1wam49JNRTCK/KlvX933b6aH3j2wZImX5qTNIB5EwD8SwL6FKxEPD0z
         nNWq4VZaao5ngXPxo2XoEFDHZHfyGXEw70u/bjPcSRVQ8lYb1pUKmljniYCqer5tfexI
         4xHNrZooVBsDpn9QoemHIPZPEhTxo85f72a2RV7WyJlr9H1POV6GtymN17LE5UWBD70K
         nNyFyb+VfJ5R9cXdCXU6SxnIatWsPUt+y3qneLE3UQo127vPDxlNoSyFqXRlJP08YPJg
         vFhg==
X-Gm-Message-State: AOJu0YxkEd6up1mvRDDZmEt0gwIZQ4dy3wT3dZcW2Nua0A0V85WUh51/
        Oo0sI4UIP7hqDU1I08bRZV3RbA==
X-Google-Smtp-Source: AGHT+IEK/SMb4NUNaf8d2WXTwiv7iPTtR4vQFuKO9GOmaPzBWNUEn6ZcPIJGemg9D6f0QM31YvDQsw==
X-Received: by 2002:adf:f9cd:0:b0:32d:a335:e33d with SMTP id w13-20020adff9cd000000b0032da335e33dmr887824wrr.58.1697702277126;
        Thu, 19 Oct 2023 00:57:57 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id i3-20020a5d6303000000b0032db4e660d9sm3831000wru.56.2023.10.19.00.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Oct 2023 00:57:56 -0700 (PDT)
Date:   Thu, 19 Oct 2023 09:57:55 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Conor Dooley <conor@kernel.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/8] RISC-V: KVM: Allow some SBI extensions to be
 disabled by default
Message-ID: <20231019-1e6f411e1cbc4a3b0fbff3f5@orel>
References: <20231012051509.738750-1-apatel@ventanamicro.com>
 <20231012051509.738750-4-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012051509.738750-4-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 12, 2023 at 10:45:04AM +0530, Anup Patel wrote:
> Currently, all SBI extensions are enabled by default which is
> problematic for SBI extensions (such as DBCN) which are forwarded
> to the KVM user-space because we might have an older KVM user-space
> which is not aware/ready to handle newer SBI extensions. Ideally,
> the SBI extensions forwarded to the KVM user-space must be
> disabled by default.
> 
> To address above, we allow certain SBI extensions to be disabled
> by default so that KVM user-space must explicitly enable such
> SBI extensions to receive forwarded calls from Guest VCPU.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  4 +++
>  arch/riscv/kvm/vcpu.c                 |  6 ++++
>  arch/riscv/kvm/vcpu_sbi.c             | 45 ++++++++++++++++-----------
>  3 files changed, 36 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index 8d6d4dce8a5e..c02bda5559d7 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -35,6 +35,9 @@ struct kvm_vcpu_sbi_return {
>  struct kvm_vcpu_sbi_extension {
>  	unsigned long extid_start;
>  	unsigned long extid_end;
> +
> +	bool default_unavail;
> +
>  	/**
>  	 * SBI extension handler. It can be defined for a given extension or group of
>  	 * extension. But it should always return linux error codes rather than SBI
> @@ -59,6 +62,7 @@ int kvm_riscv_vcpu_get_reg_sbi_ext(struct kvm_vcpu *vcpu,
>  const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(
>  				struct kvm_vcpu *vcpu, unsigned long extid);
>  int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
> +void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu);
>  
>  #ifdef CONFIG_RISCV_SBI_V01
>  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01;
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index c061a1c5fe98..e087c809073c 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -141,6 +141,12 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	if (rc)
>  		return rc;
>  
> +	/*
> +	 * Setup SBI extensions
> +	 * NOTE: This must be the last thing to be initialized.
> +	 */
> +	kvm_riscv_vcpu_sbi_init(vcpu);

With this, we no longer defer probing to the first access (whether that's
by the guest or KVM userspace). With our current small set of SBI
extensions where only a single one has a probe function, then this
simpler approach is good enough. We can always go back to the lazy
approach later if needed.

> +
>  	/* Reset VCPU */
>  	kvm_riscv_reset_vcpu(vcpu);
>  
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index 9cd97091c723..1b1cee86efda 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -155,14 +155,8 @@ static int riscv_vcpu_set_sbi_ext_single(struct kvm_vcpu *vcpu,
>  	if (!sext)
>  		return -ENOENT;
>  
> -	/*
> -	 * We can't set the extension status to available here, since it may
> -	 * have a probe() function which needs to confirm availability first,
> -	 * but it may be too early to call that here. We can set the status to
> -	 * unavailable, though.
> -	 */
> -	if (!reg_val)
> -		scontext->ext_status[sext->ext_idx] =
> +	scontext->ext_status[sext->ext_idx] = (reg_val) ?
> +			KVM_RISCV_SBI_EXT_AVAILABLE :
>  			KVM_RISCV_SBI_EXT_UNAVAILABLE;

We're missing the change to riscv_vcpu_get_sbi_ext_single() which should
also drop the comment block explaining the limits to status knowledge
without initial probing (which we now do) and then just check for
available, i.e.

diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index bb76c3cf633f..92c42d9aba1c 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -186,15 +186,8 @@ static int riscv_vcpu_get_sbi_ext_single(struct kvm_vcpu *vcpu,
 	if (!sext)
 		return -ENOENT;
 
-	/*
-	 * If the extension status is still uninitialized, then we should probe
-	 * to determine if it's available, but it may be too early to do that
-	 * here. The best we can do is report that the extension has not been
-	 * disabled, i.e. we return 1 when the extension is available and also
-	 * when it only may be available.
-	 */
-	*reg_val = scontext->ext_status[sext->ext_idx] !=
-				KVM_RISCV_SBI_EXT_UNAVAILABLE;
+	*reg_val = scontext->ext_status[sext->ext_idx] ==
+				KVM_RISCV_SBI_EXT_AVAILABLE;
 
 	return 0;
 }

>  
>  	return 0;
> @@ -337,18 +331,8 @@ const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(
>  			    scontext->ext_status[entry->ext_idx] ==
>  						KVM_RISCV_SBI_EXT_AVAILABLE)
>  				return ext;
> -			if (scontext->ext_status[entry->ext_idx] ==
> -						KVM_RISCV_SBI_EXT_UNAVAILABLE)
> -				return NULL;
> -			if (ext->probe && !ext->probe(vcpu)) {
> -				scontext->ext_status[entry->ext_idx] =
> -					KVM_RISCV_SBI_EXT_UNAVAILABLE;
> -				return NULL;
> -			}
>  
> -			scontext->ext_status[entry->ext_idx] =
> -				KVM_RISCV_SBI_EXT_AVAILABLE;
> -			return ext;
> +			return NULL;
>  		}
>  	}
>  
> @@ -419,3 +403,26 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  
>  	return ret;
>  }
> +
> +void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
> +	const struct kvm_riscv_sbi_extension_entry *entry;
> +	const struct kvm_vcpu_sbi_extension *ext;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
> +		entry = &sbi_ext[i];
> +		ext = entry->ext_ptr;
> +
> +		if (ext->probe && !ext->probe(vcpu)) {
> +			scontext->ext_status[entry->ext_idx] =
> +				KVM_RISCV_SBI_EXT_UNAVAILABLE;
> +			continue;
> +		}
> +
> +		scontext->ext_status[entry->ext_idx] = ext->default_unavail ?
> +					KVM_RISCV_SBI_EXT_UNAVAILABLE :
> +					KVM_RISCV_SBI_EXT_AVAILABLE;
> +	}
> +}
> -- 
> 2.34.1
>

Thanks,
drew
