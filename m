Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F4F53FAC8
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 12:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240625AbiFGKEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 06:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240624AbiFGKDz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 06:03:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E6C15C5D90
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 03:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654596232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ap/ea5Xnr5bNkYBc/gjvXLi7f8rQXdBfxSXXArkzhjs=;
        b=Cj4lH2wLIL1d/CAIbZEZZEQD7/IKOMAK9RfVYykWZvzeMBtFs7sIiYKAT9vJSc0iL1k/xO
        2X4I7+flB8H+TzkEN3v1gAsHrSAXVzeizmrXrjNexdnw3N08bZ5PkMEt8moZ91GvSx+VUN
        FcxykPYtElkpMXFGx9c+APNutPKcFn8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-548-Umh9uVzdNhiVIzAmDwncPQ-1; Tue, 07 Jun 2022 06:03:51 -0400
X-MC-Unique: Umh9uVzdNhiVIzAmDwncPQ-1
Received: by mail-qk1-f197.google.com with SMTP id bm2-20020a05620a198200b006a5dac37fa2so13738886qkb.16
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 03:03:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Ap/ea5Xnr5bNkYBc/gjvXLi7f8rQXdBfxSXXArkzhjs=;
        b=2OfZ/ZK+qqKbhy/3h37yRVq3V1Ulo+dB4enSVnX+2eZDvnWd4BmCS84BVy2ZfW+YDb
         iIQ69Wo7ubcOETDfZdEfiVOk56A7bAr+oPWEREHPaVGT60SAm56epvjrnalWn4Y8q9uF
         oq+vOxovTX6P9f523Tpwhnool+vkybfMw8FbLWOU//PeWIx+72GDBGtAFH+yeGVsg4uL
         zyormZURyu74GiOmcXtVpteEBvD6afPuYbQvNabvuCYvCAdYRXl2ol64JpvMzJX1QO5B
         nTYh2KyVrdEuCXYlQjQjAM5+3MfkQSRudGNRiLTo3OJUlxOoVqVXeKQ6WsKe03vKRqbC
         Pr8g==
X-Gm-Message-State: AOAM532py2H8lYq0EKM862q4hScIZ2OvkQMBJ+Mi4qnC49k5WCHe0KG3
        iJ423NcKQtWxjHDP3Zdj1h5iwQtdc1k+qb0EC4EhBV6sqsk9S5D6wC+jsIHkAzNFcSOB8yDwTPz
        DeKPBcpWtLQp1
X-Received: by 2002:a05:620a:1672:b0:6a6:b0de:88ae with SMTP id d18-20020a05620a167200b006a6b0de88aemr9502578qko.191.1654596230526;
        Tue, 07 Jun 2022 03:03:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwL+Lux3U2smt/hKL3cajilOIB0if6MIVkVQu0anbpTi9HYKO5N42NE8prEF5fx5vOtIZXOyg==
X-Received: by 2002:a05:620a:1672:b0:6a6:b0de:88ae with SMTP id d18-20020a05620a167200b006a6b0de88aemr9502564qko.191.1654596230302;
        Tue, 07 Jun 2022 03:03:50 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id h10-20020a05620a284a00b006a6e13e2b4bsm794500qkp.24.2022.06.07.03.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 03:03:49 -0700 (PDT)
Message-ID: <42de55976d158eb34fe97595d4509c4de28771b7.camel@redhat.com>
Subject: Re: [PATCH v6 26/38] KVM: selftests: Move the function doing
 Hyper-V hypercall to a common header
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 07 Jun 2022 13:03:46 +0300
In-Reply-To: <20220606083655.2014609-27-vkuznets@redhat.com>
References: <20220606083655.2014609-1-vkuznets@redhat.com>
         <20220606083655.2014609-27-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-06 at 10:36 +0200, Vitaly Kuznetsov wrote:
> All Hyper-V specific tests issuing hypercalls need this.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  .../selftests/kvm/include/x86_64/hyperv.h       | 15 +++++++++++++++
>  .../selftests/kvm/x86_64/hyperv_features.c      | 17 +----------------
>  2 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> index f0a8a93694b2..e0a1b4c2fbbc 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> @@ -185,6 +185,21 @@
>  /* hypercall options */
>  #define HV_HYPERCALL_FAST_BIT          BIT(16)
>  
> +static inline u64 hyperv_hypercall(u64 control, vm_vaddr_t input_address,
> +                          vm_vaddr_t output_address)
> +{
> +       u64 hv_status;
> +
> +       asm volatile("mov %3, %%r8\n"
> +                    "vmcall"
> +                    : "=a" (hv_status),
> +                      "+c" (control), "+d" (input_address)
> +                    :  "r" (output_address)
> +                    : "cc", "memory", "r8", "r9", "r10", "r11");
> +
> +       return hv_status;
> +}
> +
>  /* Proper HV_X64_MSR_GUEST_OS_ID value */
>  #define HYPERV_LINUX_OS_ID ((u64)0x8100 << 48)
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> index 98c020356925..788d570e991e 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> @@ -48,21 +48,6 @@ static void do_wrmsr(u32 idx, u64 val)
>  static int nr_gp;
>  static int nr_ud;
>  
> -static inline u64 hypercall(u64 control, vm_vaddr_t input_address,
> -                           vm_vaddr_t output_address)
> -{
> -       u64 hv_status;
> -
> -       asm volatile("mov %3, %%r8\n"
> -                    "vmcall"
> -                    : "=a" (hv_status),
> -                      "+c" (control), "+d" (input_address)
> -                    :  "r" (output_address)
> -                    : "cc", "memory", "r8", "r9", "r10", "r11");
> -
> -       return hv_status;
> -}
> -
>  static void guest_gp_handler(struct ex_regs *regs)
>  {
>         unsigned char *rip = (unsigned char *)regs->rip;
> @@ -138,7 +123,7 @@ static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
>                         input = output = 0;
>                 }
>  
> -               res = hypercall(hcall->control, input, output);
> +               res = hyperv_hypercall(hcall->control, input, output);
>                 if (hcall->ud_expected)
>                         GUEST_ASSERT(nr_ud == 1);
>                 else

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

