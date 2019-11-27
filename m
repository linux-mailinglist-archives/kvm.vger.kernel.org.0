Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00F0310AAAB
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 07:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfK0G2v convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 27 Nov 2019 01:28:51 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2463 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726026AbfK0G2u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 01:28:50 -0500
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 10E8E338613FD4519B03;
        Wed, 27 Nov 2019 14:28:47 +0800 (CST)
Received: from dggeme713-chm.china.huawei.com (10.1.199.109) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 27 Nov 2019 14:28:46 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme713-chm.china.huawei.com (10.1.199.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 27 Nov 2019 14:28:46 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Wed, 27 Nov 2019 14:28:46 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
CC:     Haiwei Li <lihaiwei.kernel@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: SVM: Fix "error" isn't initialized
Thread-Topic: [PATCH] KVM: SVM: Fix "error" isn't initialized
Thread-Index: AdWk60CcyspD19xwRk++tZYeJJNRuA==
Date:   Wed, 27 Nov 2019 06:28:46 +0000
Message-ID: <c526ce98659242a2a9f22ec898d7647d@huawei.com>
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

On 2019/11/27 11:44, Sean Christopherson wrote:
> On Wed, Nov 27, 2019 at 03:30:06AM +0000, linmiaohe wrote:
>>
>>> From: Haiwei Li <lihaiwei@tencent.com>
>>> Subject: [PATCH] initialize 'error'
>>>
>>> There are a bunch of error paths were "error" isn't initialized.
>> Hi,
>> In case error case, sev_guest_df_flush() do not set the error.
>> Can you set the value of error to reflect what error happened in 
>> sev_guest_df_flush()?
>> The current fix may looks confused when print "DF_FLUSH failed" with 
>> error = 0.
>> Thanks.
>>
>> PS: This is just my personal point.
> 
> Disclaimer: not my world at all...
> 
> Based on the prototype for __sev_do_cmd_locked(), @error is intended 
> to be filled only if there's an actual response from the PSP, which is 
> a 16-bit value.  So maybe init @psp_ret at the beginning of 
> __sev_do_cmd_locked() to
> -1 to indicate the command was never sent to the PSP?  And update the
> pr_err() in sev_asid_flush() to explicitly state it's the PSP return?
>

I think it's a good alternative. Many Thanks.
