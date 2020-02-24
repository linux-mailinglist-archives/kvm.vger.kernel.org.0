Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3656169BF1
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 02:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgBXBor convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 23 Feb 2020 20:44:47 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:48706 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727151AbgBXBor (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Feb 2020 20:44:47 -0500
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 3F9634FCA9B9E5C9F61D;
        Mon, 24 Feb 2020 09:44:44 +0800 (CST)
Received: from dggeme752-chm.china.huawei.com (10.3.19.98) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 24 Feb 2020 09:44:43 +0800
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme752-chm.china.huawei.com (10.3.19.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Mon, 24 Feb 2020 09:44:43 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1713.004;
 Mon, 24 Feb 2020 09:44:43 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] KVM: X86: eliminate some meaningless code
Thread-Topic: [PATCH] KVM: X86: eliminate some meaningless code
Thread-Index: AdXqsyQk+rut2bDwRPO7k/XEvhn+sQ==
Date:   Mon, 24 Feb 2020 01:44:43 +0000
Message-ID: <5ac7a51dbcc7408d87b14be75b41f1dc@huawei.com>
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

Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> On Fri, Feb 21, 2020 at 10:05:26PM +0800, linmiaohe wrote:
>> From: Miaohe Lin <linmiaohe@huawei.com>
>> 
>> When kvm_vcpu_ioctl_get_cpuid2() fails, we set cpuid->nent to the 
>> value of
>> vcpu->arch.cpuid_nent. But this is in vain as cpuid->nent is not 
>> vcpu->copied to
>> userspace by copy_to_user() from call site. Get rid of this 
>> meaningless assignment and further cleanup the var r and out jump label.
>
>Ha, took me a while to see that.

Sorry about it. I'am not good at it. :(

>>
>> On the other hand, when kvm_vcpu_ioctl_get_cpuid2() succeeds, we do 
>>  			 vcpu->arch.cpuid_nent * sizeof(struct kvm_cpuid_entry2)))
>> -		goto out;
>> -	return 0;
>
>Hmm, so this ioctl() is straight up broken.  cpuid->nent should be updated on success so that userspace knows how many entries were retrieved, i.e.
>the code should look something like below, with kvm_arch_vcpu_ioctl() unchanged.
>
>I'm guessing no VMM actually uses this ioctl(), e.g. neither Qemu or CrosVM use it, which is why the broken behavior has gone unnoticed.  Don't suppose you'd want to write a selftest to hammer KVM_{SET,GET}_CPUID2?
>
>int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
>                              struct kvm_cpuid2 *cpuid,
>                              struct kvm_cpuid_entry2 __user *entries) {
>        if (cpuid->nent < vcpu->arch.cpuid_nent)
>                return -E2BIG;
>
>        if (copy_to_user(entries, &vcpu->arch.cpuid_entries,
>                         vcpu->arch.cpuid_nent * sizeof(struct kvm_cpuid_entry2)))
>                return -EFAULT;
>
>	cpuid->nent = vcpu->arch.cpuid_nent;
>
>        return 0;
>}
>

I searched KVM_GET_CPUID2 from Qemu, it's not used. So maybe we could just drop KVM_GET_CPUID2 altogether as
suggested by Paolo. Thanks for your review.

