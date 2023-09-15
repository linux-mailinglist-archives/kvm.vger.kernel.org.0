Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53B0A7A1668
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 08:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbjIOGrs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 02:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbjIOGrp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 02:47:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4CAE8270E
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 23:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694760410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OFHb1X8GwFAV1GjpBawvQP043vGn+wTnVbsA2Tbt+oQ=;
        b=CLVGIHmdFf3+kha8vO7bcq9pwLJsrOZ1NuTfWeTiYaow0AP/TVkL+cubv+0pcKX0lLDFjE
        aqL5NoyIFOArZnygOVyQUL2SZd4FRz2hERvDCGlHhuZSkyuTIFuNq4U2MydzKbpuL5Iwzt
        NZtIwQzPyuOxDhaG30oroQdRKmW53WI=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-2u4sL_q1N--aXnBjojV97w-1; Fri, 15 Sep 2023 02:46:48 -0400
X-MC-Unique: 2u4sL_q1N--aXnBjojV97w-1
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-6bf0c48643fso2194588a34.0
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 23:46:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694760408; x=1695365208;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OFHb1X8GwFAV1GjpBawvQP043vGn+wTnVbsA2Tbt+oQ=;
        b=t3TJ6EV7q9ZuTHEuJXVeerVICVvWyYpZ2H5MRqx417eC0NC7St8UXOPM3dEsZ+K7WX
         LjInzyyZGz16k9NHPrBxYWslMz0qlxXyIE5oYvR1gehlJdJUrxGJhLfO10Vo5L/E0dZb
         JVmEYvVrxncveKUOyeaIMIWiWllULbUHXwZM3P6WOBx1nA/58UsUJoor0GRaEiOw3TTc
         EQxUn4jjJzrXhkWsgS79Ou+uVEf1qcxmoAgZpjRkNf99kVaWc9DdS/E0JOdvO2TfHGS9
         135MXaw9tO/z/tN+mNmFIoBxyWndgivC55qrc1hBwZ1lFAFcKEpezD/GVBXlzGRE6MES
         pxag==
X-Gm-Message-State: AOJu0YxaLeguE49/a2QZceOi06DW8zcMlKj0VWbQ96cpyxI1bXqolM47
        J5McrFeELHlJ+erQTpFJUywgE86zAfmTJy8/dQb1k+H/WE+5cmse1ydWMDwg8kxDae8RpOakwiY
        HNTe6b0YZCJmQ
X-Received: by 2002:a9d:7381:0:b0:6bd:5bc:7bda with SMTP id j1-20020a9d7381000000b006bd05bc7bdamr729266otk.19.1694760408031;
        Thu, 14 Sep 2023 23:46:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGDSdP3X8SAOYzXngeublio68T/+1l2GRslaw0MtT+GBt9TTzrGejFOiVGHPrfU6Zh2om+sYA==
X-Received: by 2002:a9d:7381:0:b0:6bd:5bc:7bda with SMTP id j1-20020a9d7381000000b006bd05bc7bdamr729233otk.19.1694760407778;
        Thu, 14 Sep 2023 23:46:47 -0700 (PDT)
Received: from redhat.com ([2804:1b3:a803:4ff9:7c29:fe41:6aa7:43df])
        by smtp.gmail.com with ESMTPSA id v5-20020a05683011c500b006b9e872c0a0sm1366615otq.68.2023.09.14.23.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 23:46:47 -0700 (PDT)
Date:   Fri, 15 Sep 2023 03:46:37 -0300
From:   Leonardo Bras <leobras@redhat.com>
To:     guoren@kernel.org
Cc:     paul.walmsley@sifive.com, anup@brainfault.org,
        peterz@infradead.org, mingo@redhat.com, will@kernel.org,
        palmer@rivosinc.com, longman@redhat.com, boqun.feng@gmail.com,
        tglx@linutronix.de, paulmck@kernel.org, rostedt@goodmis.org,
        rdunlap@infradead.org, catalin.marinas@arm.com,
        conor.dooley@microchip.com, xiaoguang.xing@sophgo.com,
        bjorn@rivosinc.com, alexghiti@rivosinc.com, keescook@chromium.org,
        greentime.hu@sifive.com, ajones@ventanamicro.com,
        jszhang@kernel.org, wefu@redhat.com, wuwei2016@iscas.ac.cn,
        linux-arch@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-csky@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>
Subject: Re: [PATCH V11 16/17] RISC-V: paravirt: pvqspinlock: KVM: Add
 paravirt qspinlock skeleton
Message-ID: <ZQP9zSl70Jd2T5wp@redhat.com>
References: <20230910082911.3378782-1-guoren@kernel.org>
 <20230910082911.3378782-17-guoren@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230910082911.3378782-17-guoren@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 10, 2023 at 04:29:10AM -0400, guoren@kernel.org wrote:
> From: Guo Ren <guoren@linux.alibaba.com>
> 
> Add the files functions needed to support the SBI PVLOCK (paravirt
> qspinlock kick_cpu) extension. This is a preparation for the next
> core implementation of kick_cpu.
> 
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Guo Ren <guoren@kernel.org>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  1 +
>  arch/riscv/include/uapi/asm/kvm.h     |  1 +
>  arch/riscv/kvm/Makefile               |  1 +
>  arch/riscv/kvm/vcpu_sbi.c             |  4 +++
>  arch/riscv/kvm/vcpu_sbi_pvlock.c      | 38 +++++++++++++++++++++++++++
>  5 files changed, 45 insertions(+)
>  create mode 100644 arch/riscv/kvm/vcpu_sbi_pvlock.c
> 
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index cdcf0ff07be7..7b4d60b54d7e 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -71,6 +71,7 @@ extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst;
>  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm;
>  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_experimental;
>  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_vendor;
> +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pvlock;
>  
>  #ifdef CONFIG_RISCV_PMU_SBI
>  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu;
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index 992c5e407104..d005c229f2da 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -148,6 +148,7 @@ enum KVM_RISCV_SBI_EXT_ID {
>  	KVM_RISCV_SBI_EXT_PMU,
>  	KVM_RISCV_SBI_EXT_EXPERIMENTAL,
>  	KVM_RISCV_SBI_EXT_VENDOR,
> +	KVM_RISCV_SBI_EXT_PVLOCK,
>  	KVM_RISCV_SBI_EXT_MAX,
>  };
>  
> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> index 4c2067fc59fc..6112750a3a0c 100644
> --- a/arch/riscv/kvm/Makefile
> +++ b/arch/riscv/kvm/Makefile
> @@ -26,6 +26,7 @@ kvm-$(CONFIG_RISCV_SBI_V01) += vcpu_sbi_v01.o
>  kvm-y += vcpu_sbi_base.o
>  kvm-y += vcpu_sbi_replace.o
>  kvm-y += vcpu_sbi_hsm.o
> +kvm-y += vcpu_sbi_pvlock.o
>  kvm-y += vcpu_timer.o
>  kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_pmu.o vcpu_sbi_pmu.o
>  kvm-y += aia.o
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index 9cd97091c723..c03c3d489b2b 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -74,6 +74,10 @@ static const struct kvm_riscv_sbi_extension_entry sbi_ext[] = {
>  		.ext_idx = KVM_RISCV_SBI_EXT_VENDOR,
>  		.ext_ptr = &vcpu_sbi_ext_vendor,
>  	},
> +	{
> +		.ext_idx = KVM_RISCV_SBI_EXT_PVLOCK,
> +		.ext_ptr = &vcpu_sbi_ext_pvlock,
> +	},
>  };
>  
>  void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run)
> diff --git a/arch/riscv/kvm/vcpu_sbi_pvlock.c b/arch/riscv/kvm/vcpu_sbi_pvlock.c
> new file mode 100644
> index 000000000000..544a456c5041
> --- /dev/null
> +++ b/arch/riscv/kvm/vcpu_sbi_pvlock.c
> @@ -0,0 +1,38 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c), 2023 Alibaba Cloud
> + *
> + * Authors:
> + *     Guo Ren <guoren@linux.alibaba.com>
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <linux/kvm_host.h>
> +#include <asm/sbi.h>
> +#include <asm/kvm_vcpu_sbi.h>
> +
> +static int kvm_sbi_ext_pvlock_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> +				      struct kvm_vcpu_sbi_return *retdata)
> +{
> +	int ret = 0;
> +	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> +	unsigned long funcid = cp->a6;
> +
> +	switch (funcid) {
> +	case SBI_EXT_PVLOCK_KICK_CPU:
> +		break;

IIUC, the kick implementation comes in the next patch but here it becomes a 
no-op. Is there any chance this may break a future bisect?

I don't understand a lot, but I would suggest either removing this no-op 
case SBI_EXT_PVLOCK_KICK_CPU, or merging this patch with the next one.

Other than that, LGTM.

Thanks,
Leo



> +	default:
> +		ret = SBI_ERR_NOT_SUPPORTED;
> +	}
> +
> +	retdata->err_val = ret;
> +
> +	return 0;
> +}
> +
> +const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pvlock = {
> +	.extid_start = SBI_EXT_PVLOCK,
> +	.extid_end = SBI_EXT_PVLOCK,
> +	.handler = kvm_sbi_ext_pvlock_handler,
> +};
> -- 
> 2.36.1
> 

