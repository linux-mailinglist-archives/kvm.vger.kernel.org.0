Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCA3816F547
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 02:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729856AbgBZBsb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 25 Feb 2020 20:48:31 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:59862 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729763AbgBZBsb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 20:48:31 -0500
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id E7851DF0885B81E09881;
        Wed, 26 Feb 2020 09:48:28 +0800 (CST)
Received: from dggeme702-chm.china.huawei.com (10.1.199.98) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 26 Feb 2020 09:48:28 +0800
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme702-chm.china.huawei.com (10.1.199.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 26 Feb 2020 09:48:28 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1713.004;
 Wed, 26 Feb 2020 09:48:28 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: Fix some obsolete comments
Thread-Topic: [PATCH] KVM: Fix some obsolete comments
Thread-Index: AdXsRgRjeK2cvv6aTVeXyFgaCiJkyg==
Date:   Wed, 26 Feb 2020 01:48:28 +0000
Message-ID: <3e25a121a6754020ac3a1eda9fb7fad6@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.158]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:
>linmiaohe <linmiaohe@huawei.com> writes:
>
>> From: Miaohe Lin <linmiaohe@huawei.com>
>>
>
>Thank you for the cleanup, I looked at nested_svm_intercept() and I see room for improvement, e.g. (completely untested!)
>
>diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c index 76c24b3491f6..fcb26d64d3c7 100644
>--- a/arch/x86/kvm/svm.c
>+++ b/arch/x86/kvm/svm.c
>@@ -3280,42 +3280,36 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
>        case SVM_EXIT_IOIO:
>                vmexit = nested_svm_intercept_ioio(svm);
>                break;
>-       case SVM_EXIT_READ_CR0 ... SVM_EXIT_WRITE_CR8: {
>-               u32 bit = 1U << (exit_code - SVM_EXIT_READ_CR0);
>-               if (svm->nested.intercept_cr & bit)
>+       case SVM_EXIT_READ_CR0 ... SVM_EXIT_WRITE_CR8:
>+               if (svm->nested.intercept_cr &
>+                   BIT(exit_code - SVM_EXIT_READ_CR0))
>-       default: {
>-               u64 exit_bits = 1ULL << (exit_code - SVM_EXIT_INTR);
>-               if (svm->nested.intercept & exit_bits)
>+       default:
>+               if (svm->nested.intercept & BIT_ULL(exit_code - 
>+ SVM_EXIT_INTR))
>                        vmexit = NESTED_EXIT_DONE;
>        }
>-       }
> 
>        return vmexit;
> }
>
>Feel free to pick stuff you like and split your changes to this function in a separate patch.

Sounds good, many thanks for your improvement suggestion. Will do in a separate patch.

>>  	u32 exit_code = svm->vmcb->control.exit_code; diff --git 
>> throws
>> - * #UD or #GP.
>> + * #UD, #GP or #SS.
>
>Oxford comma, anyone? :-)))

I have no strong preference. ^_^

>>   */
>>  int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
>
>All your changes look correct, so
>
>Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>

Many thanks for your review, and nice suggestion again!

