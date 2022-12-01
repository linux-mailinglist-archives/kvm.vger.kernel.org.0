Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7163C63F226
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 15:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbiLAOAh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 09:00:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbiLAOAg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 09:00:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2769801D
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 05:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669903181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vDSFxCMO6SqDCXpKAEoPcvOZBAXYxBhJ3muPev7TTk8=;
        b=fNFrFRo2m4NVt0k/eqteCa4Lsga/l77JAmup/f8P9mCb0r3QXjyAhYlBGUBCbQ5eBbDuwK
        kYOf1xtZcKw0oAbJHevdeUnZvS/2cDcXrfpjrni7+eRBWaBV8DBU9BfV6H4FctxYIpXS3u
        zsKzv8wdIaxcgzuDo/PUxCZhHuJRKq8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-96-UuVqAzBbOJupNKsoiANswQ-1; Thu, 01 Dec 2022 08:59:40 -0500
X-MC-Unique: UuVqAzBbOJupNKsoiANswQ-1
Received: by mail-qk1-f197.google.com with SMTP id y22-20020a05620a25d600b006fc49e06062so6028188qko.4
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 05:59:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vDSFxCMO6SqDCXpKAEoPcvOZBAXYxBhJ3muPev7TTk8=;
        b=mfg8yMY8IpXJNsuw1DMOQ0ixHNILb1BsRUw1foMxZFG62TpFCSxg1z9kDsFiGH8a1S
         ASG1egFnfUMIMjfSIKENJ+pH3KarXsEkAnlgpWAYuzN2Ti5SF8N9xmPMhZThyZmOnF4Z
         Elp4NcojwzZ2k4fsTrutW/f6hpoGb1Hq6HMCYogdv6Eo7TOdzBQ/LUTepOWgbuxwGKtH
         CFrbJHwIL3glQXSVpFL0W5qPlWzx7cSkDpzRJdQRtmwde8MW3HvdFXW1lem7mOKJ7Dsa
         5hFcti6VSm6E8o91fVhK6CyFfxMPkmhVbxk1uPIl6LPk5fQQmA0oKmDhnlVez2BLZoCs
         3Q7w==
X-Gm-Message-State: ANoB5pkI9ecW5zFJ6HD7+fwu50u/ICfrV7U2yzx2qUuHPA5GynndcCpM
        iz+HwQ0Rq1OScbQ/qrXHc9rBR9Z4dOcfT4wibueKJSACGuDu0OEFtt6yhCBsdhYLeGweI84WFxL
        S8pfkpq3AuJUa
X-Received: by 2002:ac8:4408:0:b0:3a6:8b16:1c6b with SMTP id j8-20020ac84408000000b003a68b161c6bmr8101910qtn.83.1669903179930;
        Thu, 01 Dec 2022 05:59:39 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4JMi37GXYjpeNNBOEFyvaBmHvtN1MssvcrB/19CEYWUyKXhFI72f48MLu2xb+mb2FmI5uAbg==
X-Received: by 2002:ac8:4408:0:b0:3a6:8b16:1c6b with SMTP id j8-20020ac84408000000b003a68b161c6bmr8101892qtn.83.1669903179697;
        Thu, 01 Dec 2022 05:59:39 -0800 (PST)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id bl6-20020a05620a1a8600b006ec771d8f89sm3375408qkb.112.2022.12.01.05.59.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 05:59:39 -0800 (PST)
Message-ID: <3a3d705f-5867-5816-8545-df11b2ac8485@redhat.com>
Date:   Thu, 1 Dec 2022 14:59:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v3 15/27] svm: move some svm support
 functions into lib/x86/svm_lib.h
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Nico Boehr <nrb@linux.ibm.com>,
        Cathy Avery <cavery@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20221122161152.293072-1-mlevitsk@redhat.com>
 <20221122161152.293072-16-mlevitsk@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <20221122161152.293072-16-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 22/11/2022 um 17:11 schrieb Maxim Levitsky:
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  lib/x86/svm_lib.h | 53 +++++++++++++++++++++++++++++++++++++++++++++++
>  x86/svm.c         | 36 +-------------------------------
>  x86/svm.h         | 18 ----------------
>  x86/svm_npt.c     |  1 +
>  x86/svm_tests.c   |  1 +
>  5 files changed, 56 insertions(+), 53 deletions(-)
>  create mode 100644 lib/x86/svm_lib.h
> 
> diff --git a/lib/x86/svm_lib.h b/lib/x86/svm_lib.h
> new file mode 100644
> index 00000000..04910281
> --- /dev/null
> +++ b/lib/x86/svm_lib.h
> @@ -0,0 +1,53 @@
> +#ifndef SRC_LIB_X86_SVM_LIB_H_
> +#define SRC_LIB_X86_SVM_LIB_H_
> +
> +#include <x86/svm.h>
> +#include "processor.h"
> +
> +static inline bool npt_supported(void)
> +{
> +	return this_cpu_has(X86_FEATURE_NPT);
> +}
> +
> +static inline bool vgif_supported(void)
> +{
> +	return this_cpu_has(X86_FEATURE_VGIF);
> +}
> +
> +static inline bool lbrv_supported(void)
> +{
> +	return this_cpu_has(X86_FEATURE_LBRV);
> +}
> +
> +static inline bool tsc_scale_supported(void)
> +{
> +	return this_cpu_has(X86_FEATURE_TSCRATEMSR);
> +}
> +
> +static inline bool pause_filter_supported(void)
> +{
> +	return this_cpu_has(X86_FEATURE_PAUSEFILTER);
> +}
> +
> +static inline bool pause_threshold_supported(void)
> +{
> +	return this_cpu_has(X86_FEATURE_PFTHRESHOLD);
> +}
> +
> +static inline void vmmcall(void)
> +{
> +	asm volatile ("vmmcall" : : : "memory");
> +}
> +
> +static inline void stgi(void)
> +{
> +	asm volatile ("stgi");
> +}
> +
> +static inline void clgi(void)
> +{
> +	asm volatile ("clgi");
> +}
> +
Not an expert at all on this, but sti() and cli() in patch 1 are in
processor.h and stgi (g stansd for global?) and clgi are in a different
header? What about maybe moving them together?

> +
> +#endif /* SRC_LIB_X86_SVM_LIB_H_ */
> diff --git a/x86/svm.c b/x86/svm.c
> index 0b2a1d69..8d90a242 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -14,6 +14,7 @@
>  #include "alloc_page.h"
>  #include "isr.h"
>  #include "apic.h"
> +#include "svm_lib.h"
>  
>  /* for the nested page table*/
>  u64 *pml4e;
> @@ -54,32 +55,6 @@ bool default_supported(void)
>  	return true;
>  }
>  
> -bool vgif_supported(void)
> -{
> -	return this_cpu_has(X86_FEATURE_VGIF);
> -}
> -
> -bool lbrv_supported(void)
> -{
> -	return this_cpu_has(X86_FEATURE_LBRV);
> -}
> -
> -bool tsc_scale_supported(void)
> -{
> -	return this_cpu_has(X86_FEATURE_TSCRATEMSR);
> -}
> -
> -bool pause_filter_supported(void)
> -{
> -	return this_cpu_has(X86_FEATURE_PAUSEFILTER);
> -}
> -
> -bool pause_threshold_supported(void)
> -{
> -	return this_cpu_has(X86_FEATURE_PFTHRESHOLD);
> -}
> -
> -
>  void default_prepare(struct svm_test *test)
>  {
>  	vmcb_ident(vmcb);
> @@ -94,10 +69,6 @@ bool default_finished(struct svm_test *test)
>  	return true; /* one vmexit */
>  }
>  
> -bool npt_supported(void)
> -{
> -	return this_cpu_has(X86_FEATURE_NPT);
> -}
>  
>  int get_test_stage(struct svm_test *test)
>  {
> @@ -128,11 +99,6 @@ static void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
>  	seg->base = base;
>  }
>  
> -inline void vmmcall(void)
> -{
> -	asm volatile ("vmmcall" : : : "memory");
> -}
> -
>  static test_guest_func guest_main;
>  
>  void test_set_guest(test_guest_func func)
> diff --git a/x86/svm.h b/x86/svm.h
> index 3cd7ce8b..7cb1b898 100644
> --- a/x86/svm.h
> +++ b/x86/svm.h
> @@ -53,21 +53,14 @@ u64 *npt_get_pdpe(u64 address);
>  u64 *npt_get_pml4e(void);
>  bool smp_supported(void);
>  bool default_supported(void);
> -bool vgif_supported(void);
> -bool lbrv_supported(void);
> -bool tsc_scale_supported(void);
> -bool pause_filter_supported(void);
> -bool pause_threshold_supported(void);
>  void default_prepare(struct svm_test *test);
>  void default_prepare_gif_clear(struct svm_test *test);
>  bool default_finished(struct svm_test *test);
> -bool npt_supported(void);
>  int get_test_stage(struct svm_test *test);
>  void set_test_stage(struct svm_test *test, int s);
>  void inc_test_stage(struct svm_test *test);
>  void vmcb_ident(struct vmcb *vmcb);
>  struct regs get_regs(void);
> -void vmmcall(void);
>  int __svm_vmrun(u64 rip);
>  void __svm_bare_vmrun(void);
>  int svm_vmrun(void);
> @@ -75,17 +68,6 @@ void test_set_guest(test_guest_func func);
>  
>  extern struct vmcb *vmcb;
>  
> -static inline void stgi(void)
> -{
> -    asm volatile ("stgi");
> -}
> -
> -static inline void clgi(void)
> -{
> -    asm volatile ("clgi");
> -}
> -
> -
>  
>  #define SAVE_GPR_C                              \
>          "xchg %%rbx, regs+0x8\n\t"              \
> diff --git a/x86/svm_npt.c b/x86/svm_npt.c
> index b791f1ac..8aac0bb6 100644
> --- a/x86/svm_npt.c
> +++ b/x86/svm_npt.c
> @@ -2,6 +2,7 @@
>  #include "vm.h"
>  #include "alloc_page.h"
>  #include "vmalloc.h"
> +#include "svm_lib.h"
>  
>  static void *scratch_page;
>  
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 202e9271..f86c2fa4 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -12,6 +12,7 @@
>  #include "delay.h"
>  #include "x86/usermode.h"
>  #include "vmalloc.h"
> +#include "svm_lib.h"
>  
>  #define SVM_EXIT_MAX_DR_INTERCEPT 0x3f
>  
> 

