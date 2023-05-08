Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6583E6FB5F0
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 19:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbjEHR3s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 13:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232429AbjEHR3q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 13:29:46 -0400
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B80561B0;
        Mon,  8 May 2023 10:29:44 -0700 (PDT)
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-643990c5319so3236692b3a.2;
        Mon, 08 May 2023 10:29:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683566983; x=1686158983;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3rfke9qB1DRHiCuMEOyzzXuV8oi0P7zjijqnIYynp3o=;
        b=WJfaSuuV1ekEBAiD7cPHXE8+V1fa6ljBFWX4+wgtGd2BpjmEc5oaB9B2TwapRwAKtM
         MJJMVu8FqUEp8/0jin4K/2/FEUn1ZrE/k5wuDK7LRAoaocRmo8q9/T0ca3iTaW/CT7yS
         wFLr/e7SWBhy3cZgm5USsixgEOS0fI9WAkt/OtV3xVGy5AfdOgViPI4pNCel3zzV/ins
         2X6+wwY5b2gW26I4IcslgW6L1a0ovEfBYTw86Gi4l98rsdIkxYJO6SPC1xaEDc2gS9lt
         xxCYUgV2LUyXr0nuoGnE398GdJ1Lz/xMmAWTyR5qvtV8WaYtjl2MNVP06GrB/ycOu8fv
         R6OQ==
X-Gm-Message-State: AC+VfDxQ4MBRreQPfAhZsHBpVT3fjSYHJlLjJpf3FR8c0uIzqOMeZ2Zi
        QSG9tf/qKYdVSe7y/Wyo9rs=
X-Google-Smtp-Source: ACHHUZ75U4lCk4iijzyP5tOZ0JsVrz/EkvkWJ7HQDBXg3iSt23KVdFrierjfNZySz59EZ1uNpntsKQ==
X-Received: by 2002:a05:6a20:a107:b0:ff:7c74:a799 with SMTP id q7-20020a056a20a10700b000ff7c74a799mr11302220pzk.9.1683566983497;
        Mon, 08 May 2023 10:29:43 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([20.69.120.36])
        by smtp.gmail.com with ESMTPSA id i4-20020aa787c4000000b0063d2d9990ecsm232036pfo.87.2023.05.08.10.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 10:29:43 -0700 (PDT)
Date:   Mon, 8 May 2023 17:29:41 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Alexander Graf <graf@amazon.com>,
        Forrest Yuan Yu <yuanyu@google.com>,
        James Morris <jamorris@linux.microsoft.com>,
        John Andersen <john.s.andersen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>,
        Mihai =?utf-8?B?RG9uyJt1?= <mdontu@bitdefender.com>,
        =?utf-8?B?TmljdciZb3IgQ8OuyJt1?= <nicu.citu@icloud.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Thara Gopinath <tgopinath@microsoft.com>,
        Will Deacon <will@kernel.org>,
        Zahra Tarkhani <ztarkhani@microsoft.com>,
        =?utf-8?Q?=C8=98tefan_=C8=98icleru?= <ssicleru@bitdefender.com>,
        dev@lists.cloudhypervisor.org, kvm@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v1 3/9] virt: Implement Heki common code
Message-ID: <ZFkxhWhjyIzrPkt8@liuwe-devbox-debian-v2>
References: <20230505152046.6575-1-mic@digikod.net>
 <20230505152046.6575-4-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230505152046.6575-4-mic@digikod.net>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 05, 2023 at 05:20:40PM +0200, Mickaël Salaün wrote:
> From: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> 
> Hypervisor Enforced Kernel Integrity (Heki) is a feature that will use
> the hypervisor to enhance guest virtual machine security.
> 
> Configuration
> =============
> 
> Define the config variables for the feature. This feature depends on
> support from the architecture as well as the hypervisor.
> 
> Enabling HEKI
> =============
> 
> Define a kernel command line parameter "heki" to turn the feature on or
> off. By default, Heki is on.

For such a newfangled feature can we have it off by default? Especially
when there are unsolved issues around dynamically loaded code.

> 
[...]
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 3604074a878b..5cf5a7a97811 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -297,6 +297,7 @@ config X86
>  	select FUNCTION_ALIGNMENT_4B
>  	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>  	select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
> +	select ARCH_SUPPORTS_HEKI		if X86_64

Why is there a restriction on X86_64?

>  
>  config INSTRUCTION_DECODER
>  	def_bool y
> diff --git a/arch/x86/include/asm/sections.h b/arch/x86/include/asm/sections.h
> index a6e8373a5170..42ef1e33b8a5 100644
> --- a/arch/x86/include/asm/sections.h
> +++ b/arch/x86/include/asm/sections.h
[...]
>  
> +#ifdef CONFIG_HEKI
> +
> +/*
> + * Gather all of the statically defined sections so heki_late_init() can
> + * protect these sections in the host page table.
> + *
> + * The sections are defined under "SECTIONS" in vmlinux.lds.S
> + * Keep this array in sync with SECTIONS.
> + */

This seems a bit fragile, because it requires constant attention from
people who care about this functionality. Can this table be
automatically generated?

Thanks,
Wei.

> +struct heki_va_range __initdata heki_va_ranges[] = {
> +	{
> +		.va_start = _stext,
> +		.va_end = _etext,
> +		.attributes = HEKI_ATTR_MEM_NOWRITE | HEKI_ATTR_MEM_EXEC,
> +	},
> +	{
> +		.va_start = __start_rodata,
> +		.va_end = __end_rodata,
> +		.attributes = HEKI_ATTR_MEM_NOWRITE,
> +	},
> +#ifdef CONFIG_UNWINDER_ORC
> +	{
> +		.va_start = __start_orc_unwind_ip,
> +		.va_end = __stop_orc_unwind_ip,
> +		.attributes = HEKI_ATTR_MEM_NOWRITE,
> +	},
> +	{
> +		.va_start = __start_orc_unwind,
> +		.va_end = __stop_orc_unwind,
> +		.attributes = HEKI_ATTR_MEM_NOWRITE,
> +	},
> +	{
> +		.va_start = orc_lookup,
> +		.va_end = orc_lookup_end,
> +		.attributes = HEKI_ATTR_MEM_NOWRITE,
> +	},
> +#endif /* CONFIG_UNWINDER_ORC */
> +};
> +
