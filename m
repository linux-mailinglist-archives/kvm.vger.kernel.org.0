Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29DCE7CF1DE
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 10:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344865AbjJSICA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 04:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232799AbjJSIB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 04:01:59 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D94126
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 01:01:57 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2c5056059e0so93615661fa.3
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 01:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697702515; x=1698307315; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wThBUxBh7v0znNn0ZPl0WI7OQvkdGdCrZ1lZ3b6Zyy4=;
        b=TKDKNnH7UEYugL3PqHv4G/pue0itDTbyzaWo4llf4Jg5vd7fKtuAYkA5nJpkma0VZV
         b7md8SubrS+e136mFp1dk48jczJRFHnqvLCgLIVNHiqavQUTHDVi+AIGUdQoS3g3Rkyk
         fsUQCSwrUcUTSIb3A5ngKK4jA83PTx8dynJkIH1iETBUXNj4KjRIXZOIpqoYM3O33pn5
         S7MMRIMmwqnjtcCD8eu5bRjfCuD/tcpJpjGf9yzfI7R7+ZtDsoFoYFSq8pJe6P11Mj0/
         wcxsOWxzYnjSyKbBqK1Z7dxKC2RaI6NXPJ5Igmx0c10jouzK2ddM3g4NeR74AvPTrt9X
         Xrbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697702515; x=1698307315;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wThBUxBh7v0znNn0ZPl0WI7OQvkdGdCrZ1lZ3b6Zyy4=;
        b=vJr947VCDWSQvpkxUicbHyizMJgQzc8A9sWTbNOSvArMQJy2u6EX23UA4maung22sj
         RJDyjpAxuOTetEhb5UnrOIsWSJGaOfQKIj9aZDMIUYrcI8ZH+wapgveuypH3hTT8PBlv
         pASMUzbYIJXmGRj02yNB6POnWKcoC0KpftrA3x+zBuDk0Qgtg35dugTz6sTsX1iWHpQK
         HOKISzM1HwSsgS/ljYCyvO/IyJeiHN5a0yhIqUaPunG239YVskiSmUkfK7ltDyy4Uzw+
         erJrDmvNo9M+3j5WkfNuNtklAXH2s/EkpRSmke9v/9mba70RMgsCjc6fSxFugtgdGBFO
         nIAQ==
X-Gm-Message-State: AOJu0YzEbzq+aAY5M90o3rO/girtIcJgH299tojqMRK4ddG+uhjZ90tK
        KIHawW5XWrbAPrgtwWIDsBeoWg==
X-Google-Smtp-Source: AGHT+IEkF+Ae4mUiCJOXGTWK+iVSfRk0ko7bvAOvA0qtVmbQYW0wA+W8atiyY1iQZ4X9vKJwGK3qXg==
X-Received: by 2002:a2e:bc04:0:b0:2c5:13e8:e6dc with SMTP id b4-20020a2ebc04000000b002c513e8e6dcmr1149965ljf.31.1697702515155;
        Thu, 19 Oct 2023 01:01:55 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id je6-20020a05600c1f8600b004063ea92492sm3790133wmb.22.2023.10.19.01.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Oct 2023 01:01:54 -0700 (PDT)
Date:   Thu, 19 Oct 2023 10:01:53 +0200
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
Subject: Re: [PATCH v2 4/8] RISC-V: KVM: Forward SBI DBCN extension to
 user-space
Message-ID: <20231019-5e79c16a0731f60d862ddfff@orel>
References: <20231012051509.738750-1-apatel@ventanamicro.com>
 <20231012051509.738750-5-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012051509.738750-5-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 12, 2023 at 10:45:05AM +0530, Anup Patel wrote:
> The frozen SBI v2.0 specification defines the SBI debug console
> (DBCN) extension which replaces the legacy SBI v0.1 console
> functions namely sbi_console_getchar() and sbi_console_putchar().
> 
> The SBI DBCN extension needs to be emulated in the KVM user-space
> (i.e. QEMU-KVM or KVMTOOL) so we forward SBI DBCN calls from KVM
> guest to the KVM user-space which can then redirect the console
> input/output to wherever it wants (e.g. telnet, file, stdio, etc).
> 
> The SBI debug console is simply a early console available to KVM
> guest for early prints and it does not intend to replace the proper
> console devices such as 8250, VirtIO console, etc.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  1 +
>  arch/riscv/include/uapi/asm/kvm.h     |  1 +
>  arch/riscv/kvm/vcpu_sbi.c             |  4 ++++
>  arch/riscv/kvm/vcpu_sbi_replace.c     | 32 +++++++++++++++++++++++++++
>  4 files changed, 38 insertions(+)
> 
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index c02bda5559d7..6a453f7f8b56 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -73,6 +73,7 @@ extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_ipi;
>  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence;
>  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst;
>  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm;
> +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_dbcn;
>  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_experimental;
>  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_vendor;
>  
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index 917d8cc2489e..60d3b21dead7 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -156,6 +156,7 @@ enum KVM_RISCV_SBI_EXT_ID {
>  	KVM_RISCV_SBI_EXT_PMU,
>  	KVM_RISCV_SBI_EXT_EXPERIMENTAL,
>  	KVM_RISCV_SBI_EXT_VENDOR,
> +	KVM_RISCV_SBI_EXT_DBCN,
>  	KVM_RISCV_SBI_EXT_MAX,
>  };
>  
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index 1b1cee86efda..bb76c3cf633f 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -66,6 +66,10 @@ static const struct kvm_riscv_sbi_extension_entry sbi_ext[] = {
>  		.ext_idx = KVM_RISCV_SBI_EXT_PMU,
>  		.ext_ptr = &vcpu_sbi_ext_pmu,
>  	},
> +	{
> +		.ext_idx = KVM_RISCV_SBI_EXT_DBCN,
> +		.ext_ptr = &vcpu_sbi_ext_dbcn,
> +	},
>  	{
>  		.ext_idx = KVM_RISCV_SBI_EXT_EXPERIMENTAL,
>  		.ext_ptr = &vcpu_sbi_ext_experimental,
> diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
> index 7c4d5d38a339..23b57c931b15 100644
> --- a/arch/riscv/kvm/vcpu_sbi_replace.c
> +++ b/arch/riscv/kvm/vcpu_sbi_replace.c
> @@ -175,3 +175,35 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst = {
>  	.extid_end = SBI_EXT_SRST,
>  	.handler = kvm_sbi_ext_srst_handler,
>  };
> +
> +static int kvm_sbi_ext_dbcn_handler(struct kvm_vcpu *vcpu,
> +				    struct kvm_run *run,
> +				    struct kvm_vcpu_sbi_return *retdata)
> +{
> +	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> +	unsigned long funcid = cp->a6;
> +
> +	switch (funcid) {
> +	case SBI_EXT_DBCN_CONSOLE_WRITE:
> +	case SBI_EXT_DBCN_CONSOLE_READ:
> +	case SBI_EXT_DBCN_CONSOLE_WRITE_BYTE:
> +		/*
> +		 * The SBI debug console functions are unconditionally
> +		 * forwarded to the userspace.
> +		 */
> +		kvm_riscv_vcpu_sbi_forward(vcpu, run);
> +		retdata->uexit = true;
> +		break;
> +	default:
> +		retdata->err_val = SBI_ERR_NOT_SUPPORTED;
> +	}
> +
> +	return 0;
> +}
> +
> +const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_dbcn = {
> +	.extid_start = SBI_EXT_DBCN,
> +	.extid_end = SBI_EXT_DBCN,
> +	.default_unavail = true,
> +	.handler = kvm_sbi_ext_dbcn_handler,
> +};
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
