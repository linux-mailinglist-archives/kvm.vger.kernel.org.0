Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD9F234124
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 10:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731922AbgGaIVv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 04:21:51 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:9306 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731823AbgGaIVv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 04:21:51 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C5B815532107EB983132;
        Fri, 31 Jul 2020 16:21:48 +0800 (CST)
Received: from [127.0.0.1] (10.174.186.173) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Fri, 31 Jul 2020
 16:21:41 +0800
Subject: Re: [Question] the check of ioeventfd collision in
 kvm_*assign_ioeventfd_idx
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "S. Tsirkin, Michael" <mst@redhat.com>, <gleb@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>,
        Xiexiangyou <xiexiangyou@huawei.com>
References: <bbece68b-fb39-d599-9ba7-a8ee8be16525@huawei.com>
 <CABgObfbFXYodCeGWSnKw0j_n2-QLxpnD_Uyc5r-_ApXv=x+qmw@mail.gmail.com>
 <4aa75d90-f2d2-888c-8970-02a41f3733e4@huawei.com>
 <cffcf9e1-6675-6815-ccfc-f48497ade818@redhat.com>
From:   Zhenyu Ye <yezhenyu2@huawei.com>
Message-ID: <18baa777-7f28-8f57-e815-11175bf4c59a@huawei.com>
Date:   Fri, 31 Jul 2020 16:21:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <cffcf9e1-6675-6815-ccfc-f48497ade818@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.186.173]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/7/31 14:44, Paolo Bonzini wrote:
> On 31/07/20 08:39, Zhenyu Ye wrote:
>> On 2020/7/31 2:03, Paolo Bonzini wrote:
>>> Yes, I think it's not needed. Probably the deassign check can be turned into an assertion?
>>>
>>> Paolo
>>>
>>
>> I think we can do this in the same function, and turnt he check of
>> p->eventfd into assertion in kvm_deassign_ioeventfd_idx(). Just like:
>>
>> ---8<---
>> static inline struct _ioeventfd *
>> get_ioeventfd(struct kvm *kvm, enum kvm_bus bus_idx,
>>               struct kvm_ioeventfd *args)
>> {
>>         static struct _ioeventfd *_p;
>>         bool wildcard = !(args->flags & KVM_IOEVENTFD_FLAG_DATAMATCH);
>>
>>         list_for_each_entry(_p, &kvm->ioeventfds, list)
>>                 if (_p->bus_idx == bus_idx &&
>>                     _p->addr == args->addr &&
>>                     (!_p->length || !args->len ||
>>                      (_p->length == args->len &&
>>                       (_p->wildcard || wildcard ||
>>                        _p->datamatch == args->datamatch))))
>>                         return _p;
>>
>>         return NULL;
>> }
>>
>> kvm_deassign_ioeventfd_idx() {
>> 	...
>> 	p = get_ioeventfd(kvm, bus_idx, args);
>> 	if (p) {
>> 		assert(p->eventfd == eventfd);
>> 		...
>> 	}
>>
>> ---8<----
>>
>> This may be easier to understand (keep the same logic in assign/deassign).
> 
> I think you should also warn if:
> 
> 1) p->length != args->len
>
> 2) p->wildcard != args->wildcard if p->length
>
> 3) p->datamatch != args->datamatch if p->length && !p->wildcard
> 
> but yeah it sounds like a plan.
> 

I will try to do this. :)

Zhenyu

