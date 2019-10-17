Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93DEBDA380
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2019 04:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390098AbfJQCMc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 16 Oct 2019 22:12:32 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:35772 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729268AbfJQCMc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 22:12:32 -0400
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 55D68A55E48D057E22C8;
        Thu, 17 Oct 2019 10:12:30 +0800 (CST)
Received: from dggeme713-chm.china.huawei.com (10.1.199.109) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 17 Oct 2019 10:12:29 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme713-chm.china.huawei.com (10.1.199.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 17 Oct 2019 10:12:29 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Thu, 17 Oct 2019 10:12:29 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mingfangsen <mingfangsen@huawei.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: SVM: Fix potential wrong physical id in
 avic_handle_ldr_update
Thread-Topic: [PATCH] KVM: SVM: Fix potential wrong physical id in
 avic_handle_ldr_update
Thread-Index: AdWEjr+4z8yau3AyRuWN8bh3iu3VDg==
Date:   Thu, 17 Oct 2019 02:12:29 +0000
Message-ID: <7db9f15500ab486b897bf1a7fa7e7161@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.189.20]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Vitaly Kuznetsov <vkuznets@redhat.com> writes:

>> Guest physical APIC ID may not equal to vcpu->vcpu_id in some case.
>> We may set the wrong physical id in avic_handle_ldr_update as we 
>> always use vcpu->vcpu_id.

Hi, Vitaly, thanks for your reply.
Do you think there may be a wrong physical id in avic_handle_ldr_update too ?

>>
>> @@ -4591,6 +4591,8 @@ static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
>>  	int ret = 0;
>>  	struct vcpu_svm *svm = to_svm(vcpu);
>>  	u32 ldr = kvm_lapic_get_reg(vcpu->arch.apic, APIC_LDR);
>> +	u32 apic_id_reg = kvm_lapic_get_reg(vcpu->arch.apic, APIC_ID);
>> +	u32 id = (apic_id_reg >> 24) & 0xff;
>
>If we reach here than we're guaranteed to be in xAPIC mode, right? Could you maybe export and use kvm_xapic_id() here then (and in
>avic_handle_apic_id_update() too)?
>

I think we're guaranteed to be in xAPIC mode when we reach here. I would have a try to export
and use use kvm_xapic_id here and in avic_handle_apic_id_update too.
Thanks for your suggestion.

Have a nice day.
Best wishes.
