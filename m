Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 711CC568825
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 14:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233568AbiGFMQv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 08:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233552AbiGFMQo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 08:16:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D5F2D2873B
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 05:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657109801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DiS5N/dCrUb/b+/NGimgtpijfBwWCszgMLKEYLFHItM=;
        b=Or137eyhzF99OTopWfJP9cXDSOM7PwScDZAxXLjBdpdvQ8IrwM4IDqav/qYGfoIa+GAxQy
        c9LHMr7PPM+ZE0pGSgCvvDGD5aodQn58M4p0rJ+yFbgdwYOVuUJvAYmJ+ii0jeirvqGRLy
        fsYiVd10/DR1rt/JcauYMI2NirmJZbk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-Kzn0Nt9yOJ2i-zDrvsfUKA-1; Wed, 06 Jul 2022 08:16:36 -0400
X-MC-Unique: Kzn0Nt9yOJ2i-zDrvsfUKA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECA3B3C10688;
        Wed,  6 Jul 2022 12:16:35 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C46F492C3B;
        Wed,  6 Jul 2022 12:16:33 +0000 (UTC)
Message-ID: <2c3c8d8a7919f86a8062f93bf9dd56e2c8865459.camel@redhat.com>
Subject: Re: [PATCH v2 20/21] KVM: selftests: Use uapi header to get VMX and
 SVM exit reasons/codes
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Wed, 06 Jul 2022 15:16:32 +0300
In-Reply-To: <20220614204730.3359543-21-seanjc@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <20220614204730.3359543-21-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-14 at 20:47 +0000, Sean Christopherson wrote:
> Include the vmx.h and svm.h uapi headers that KVM so kindly provides
> instead of manually defining all the same exit reasons/code.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/include/x86_64/svm_util.h   |  7 +--
>  .../selftests/kvm/include/x86_64/vmx.h        | 51 +------------------
>  2 files changed, 4 insertions(+), 54 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
> index a339b537a575..7aee6244ab6a 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
> @@ -9,15 +9,12 @@
>  #ifndef SELFTEST_KVM_SVM_UTILS_H
>  #define SELFTEST_KVM_SVM_UTILS_H
>  
> +#include <asm/svm.h>
> +
>  #include <stdint.h>
>  #include "svm.h"
>  #include "processor.h"
>  
> -#define SVM_EXIT_EXCP_BASE     0x040
> -#define SVM_EXIT_HLT           0x078
> -#define SVM_EXIT_MSR           0x07c
> -#define SVM_EXIT_VMMCALL       0x081
> -
>  struct svm_test_data {
>         /* VMCB */
>         struct vmcb *vmcb; /* gva */
> diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
> index 99fa1410964c..e4206f69b716 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
> @@ -8,6 +8,8 @@
>  #ifndef SELFTEST_KVM_VMX_H
>  #define SELFTEST_KVM_VMX_H
>  
> +#include <asm/vmx.h>
> +
>  #include <stdint.h>
>  #include "processor.h"
>  #include "apic.h"
> @@ -100,55 +102,6 @@
>  #define VMX_EPT_VPID_CAP_AD_BITS               0x00200000
>  
>  #define EXIT_REASON_FAILED_VMENTRY     0x80000000
> -#define EXIT_REASON_EXCEPTION_NMI      0
> -#define EXIT_REASON_EXTERNAL_INTERRUPT 1
> -#define EXIT_REASON_TRIPLE_FAULT       2
> -#define EXIT_REASON_INTERRUPT_WINDOW   7
> -#define EXIT_REASON_NMI_WINDOW         8
> -#define EXIT_REASON_TASK_SWITCH                9
> -#define EXIT_REASON_CPUID              10
> -#define EXIT_REASON_HLT                        12
> -#define EXIT_REASON_INVD               13
> -#define EXIT_REASON_INVLPG             14
> -#define EXIT_REASON_RDPMC              15
> -#define EXIT_REASON_RDTSC              16
> -#define EXIT_REASON_VMCALL             18
> -#define EXIT_REASON_VMCLEAR            19
> -#define EXIT_REASON_VMLAUNCH           20
> -#define EXIT_REASON_VMPTRLD            21
> -#define EXIT_REASON_VMPTRST            22
> -#define EXIT_REASON_VMREAD             23
> -#define EXIT_REASON_VMRESUME           24
> -#define EXIT_REASON_VMWRITE            25
> -#define EXIT_REASON_VMOFF              26
> -#define EXIT_REASON_VMON               27
> -#define EXIT_REASON_CR_ACCESS          28
> -#define EXIT_REASON_DR_ACCESS          29
> -#define EXIT_REASON_IO_INSTRUCTION     30
> -#define EXIT_REASON_MSR_READ           31
> -#define EXIT_REASON_MSR_WRITE          32
> -#define EXIT_REASON_INVALID_STATE      33
> -#define EXIT_REASON_MWAIT_INSTRUCTION  36
> -#define EXIT_REASON_MONITOR_INSTRUCTION 39
> -#define EXIT_REASON_PAUSE_INSTRUCTION  40
> -#define EXIT_REASON_MCE_DURING_VMENTRY 41
> -#define EXIT_REASON_TPR_BELOW_THRESHOLD 43
> -#define EXIT_REASON_APIC_ACCESS                44
> -#define EXIT_REASON_EOI_INDUCED                45
> -#define EXIT_REASON_EPT_VIOLATION      48
> -#define EXIT_REASON_EPT_MISCONFIG      49
> -#define EXIT_REASON_INVEPT             50
> -#define EXIT_REASON_RDTSCP             51
> -#define EXIT_REASON_PREEMPTION_TIMER   52
> -#define EXIT_REASON_INVVPID            53
> -#define EXIT_REASON_WBINVD             54
> -#define EXIT_REASON_XSETBV             55
> -#define EXIT_REASON_APIC_WRITE         56
> -#define EXIT_REASON_INVPCID            58
> -#define EXIT_REASON_PML_FULL           62
> -#define EXIT_REASON_XSAVES             63
> -#define EXIT_REASON_XRSTORS            64
> -#define LAST_EXIT_REASON               64
>  
>  enum vmcs_field {
>         VIRTUAL_PROCESSOR_ID            = 0x00000000,

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



