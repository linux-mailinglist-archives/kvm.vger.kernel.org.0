Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6356C161E9C
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 02:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgBRBlg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 17 Feb 2020 20:41:36 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2581 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726097AbgBRBlg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 20:41:36 -0500
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id AA90F4EEC760BFC529C0;
        Tue, 18 Feb 2020 09:41:33 +0800 (CST)
Received: from dggeme715-chm.china.huawei.com (10.1.199.111) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 18 Feb 2020 09:41:33 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme715-chm.china.huawei.com (10.1.199.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Tue, 18 Feb 2020 09:41:33 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Tue, 18 Feb 2020 09:41:33 +0800
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
Subject: Re: [PATCH] KVM: x86: don't notify userspace IOAPIC on edge-triggered
 interrupt EOI
Thread-Topic: [PATCH] KVM: x86: don't notify userspace IOAPIC on
 edge-triggered interrupt EOI
Thread-Index: AdXl+vxCGIl6i2nBTZGSqb8vkSSkRw==
Date:   Tue, 18 Feb 2020 01:41:33 +0000
Message-ID: <edf7454be5a743928cbc1bec5dce238d@huawei.com>
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
>> @@ -417,7 +417,7 @@ void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
>>  
>>  			kvm_set_msi_irq(vcpu->kvm, entry, &irq);
>>  
>> -			if (irq.level &&
>> +			if (irq.trig_mode &&
>>  			    kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
>>  						irq.dest_id, irq.dest_mode))
>>  				__set_bit(irq.vector, ioapic_handled_vectors);
>
>Assuming Radim's comment (13db77347db1) is correct, the change in
>3159d36ad799 looks wrong and your patch restores the status quo. Actually, kvm_set_msi_irq() always sets irq->level = 1 so checking it is pointless.
>
>Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Thanks for review.

>
> (but it is actually possible that there's a buggy userspace out there which expects EOI notifications; we won't find out unless we try to fix the bug).
>

Yeh, there may be a buggy userspace hidden from this unexpected EOI notifications. It may not be worth enough to fix it as we may spend many time
to catch the bug.
Perhaps we should only remove the pointless checking of irq->level for cleanup. :)

