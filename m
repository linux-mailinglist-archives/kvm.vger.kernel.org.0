Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F337CF3D7
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 11:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbjJSJRd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 05:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235216AbjJSJRc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 05:17:32 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4996C12D
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 02:17:30 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-32dc9ff4a8fso1594054f8f.1
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 02:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697707048; x=1698311848; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bcsnYpAdLM0em0FjxCCFcChvrh3CN3lWApFF37wa+JE=;
        b=BPG/BIKe8y/kUb1c1997E4CB0SJBH8lvMMeUOwxjLgg3PdHnKFLeEa1b9P15H+Ygn6
         GZTakKl79VFLDWgSLF4ZhkcgDXn1hxlqU7thbIqvtYNANxLHnbLVWU3C1u5sR9+jfetr
         fsq3kEAydfAH8CcAocGVpMUHKTDZxhwxNVFBL/vzNjawjNXTkwy+rQR258xT23FY8gxD
         0w5sBPWW9Juj+umlRSFYMzPLHbWCWrRDHpDVhAgm3JyIesa90vcakvBHDCuvTjyYp2p+
         W/Ns/NOL4kmFtbmI2B2jhUaVKipdb5g5/6E9dCmVD8SDfa9LvpjRwcnaBRRk5E13ITV+
         vKJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697707048; x=1698311848;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bcsnYpAdLM0em0FjxCCFcChvrh3CN3lWApFF37wa+JE=;
        b=GI4WHs6EjRqECejrbdjTMRYXLaQ2+Cz6tgKLmZYOuG4wcem+LVZRmuHk28XABD5C85
         Iu7kbuJKJfN43OVKsqY2tytmJhPP203MaeY4OwboNfGA9NeAN2lvFXeSh5pPcbo/igIa
         qWL7UV9rnQkVfnaK8BPBNt6wR8B32nSfI1Odwm6mSHR5vCSuJ+NRolNiYo3uASddU2W1
         D4e5og9kCTJvsa7mxFtqcwCm4/I6FJ9/ke2Lu6+z3CQpZGRnBaflR28eA3W3ijtzgaj/
         PJCW2KvWLHvQiKCjITqYwtxVr0D81CL4hqF/ONkMzn4YlSWlKTUEn7XhEMQ3Rm7JBOUI
         vlFQ==
X-Gm-Message-State: AOJu0Yx2DHw+hZqLAOnbeJO73u834ez8E/vVWhKaf4Qj88XDAVBRq1GH
        6YaWu3YdT/ZHDSrJJl0/uan+Fg==
X-Google-Smtp-Source: AGHT+IG8jOCLnI027DgY6Yx/fVy/qYUq7DqIReW1lUlcofpdY/Llx77hEFpM5sP3dOt6SenXND9+/w==
X-Received: by 2002:adf:f74d:0:b0:32d:8da0:48d0 with SMTP id z13-20020adff74d000000b0032d8da048d0mr923979wrp.68.1697707048600;
        Thu, 19 Oct 2023 02:17:28 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id x8-20020adfec08000000b0032dbf6bf7a2sm3994451wrn.97.2023.10.19.02.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Oct 2023 02:17:27 -0700 (PDT)
Date:   Thu, 19 Oct 2023 11:17:26 +0200
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
Message-ID: <20231019-7471d3927d94ab7158d61c6b@orel>
References: <20231012051509.738750-1-apatel@ventanamicro.com>
 <20231012051509.738750-5-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012051509.738750-5-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
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

We should add this new register to the get-reg-list kselftest, i.e.

diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
index 234006d035c9..4a0f8a8cfbf8 100644
--- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
+++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
@@ -565,6 +565,7 @@ static __u64 base_regs[] = {
 	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_SBI_EXT | KVM_REG_RISCV_SBI_SINGLE | KVM_RISCV_SBI_EXT_SRST,
 	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_SBI_EXT | KVM_REG_RISCV_SBI_SINGLE | KVM_RISCV_SBI_EXT_HSM,
 	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_SBI_EXT | KVM_REG_RISCV_SBI_SINGLE | KVM_RISCV_SBI_EXT_PMU,
+	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_SBI_EXT | KVM_REG_RISCV_SBI_SINGLE | KVM_RISCV_SBI_EXT_DBCN,
 	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_SBI_EXT | KVM_REG_RISCV_SBI_SINGLE | KVM_RISCV_SBI_EXT_EXPERIMENTAL,
 	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_SBI_EXT | KVM_REG_RISCV_SBI_SINGLE | KVM_RISCV_SBI_EXT_VENDOR,
 	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_SBI_EXT | KVM_REG_RISCV_SBI_MULTI_EN | 0,

Thanks,
drew
