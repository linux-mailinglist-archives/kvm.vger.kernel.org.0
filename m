Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02B061550CF
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 03:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgBGC7S convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 6 Feb 2020 21:59:18 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:40578 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726597AbgBGC7R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 21:59:17 -0500
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 04D312EDC18A8F6983C6;
        Fri,  7 Feb 2020 10:59:15 +0800 (CST)
Received: from dggeme713-chm.china.huawei.com (10.1.199.109) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 7 Feb 2020 10:59:14 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme713-chm.china.huawei.com (10.1.199.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 7 Feb 2020 10:59:14 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Fri, 7 Feb 2020 10:59:14 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: apic: reuse smp_wmb() in kvm_make_request()
Thread-Topic: [PATCH] KVM: apic: reuse smp_wmb() in kvm_make_request()
Thread-Index: AdXdYflqAMGIHsEtNky6XhNmzdckJQ==
Date:   Fri, 7 Feb 2020 02:59:14 +0000
Message-ID: <0f8ae71f59cd4b80ac93b9e1aa3b2428@huawei.com>
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
> On Thu, Feb 06, 2020 at 11:47:02AM +0100, Vitaly Kuznetsov wrote:
>> linmiaohe <linmiaohe@huawei.com> writes:
>> 
>> > From: Miaohe Lin <linmiaohe@huawei.com>
>> >
>> > There is already an smp_mb() barrier in kvm_make_request(). We reuse 
>> > it here.
>> > +			/*
>> > +			 * Make sure pending_events is visible before sending
>> > +			 * the request.
>> > +			 * There is already an smp_wmb() in kvm_make_request(),
>> > +			 * we reuse that barrier here.
>> > +			 */
>> 
>> Let me suggest an alternative wording,
>> 
>> "kvm_make_request() provides smp_wmb() so pending_events changes are 
>> guaranteed to be visible"
>> 
>> But there is nothing wrong with yours, it's just longer than it could 
>> be
>> :-)

Thanks for your alternative wording. It looks much better.

>I usually lean in favor of more comments, but in thise case I'd vote to drop the comment altogether.  There are lots of places that rely on the
>smp_wmb() in kvm_make_request() without a comment, e.g. the cases for APIC_DM_STARTUP and APIC_DM_REMRD in this same switch, kvm_inject_nmi(), etc...  One might wonder what makes INIT special.
>
>And on the flip side, APIC_DM_STARTUP is a good example of when a
>smp_wmb()/smp_rmb() is needed and commented correctly (though calling out the exactly location of the other half would be helpful).

Yeh, I think the comment should be dropped too. :)

Thanks to both for review! I would send v2.
