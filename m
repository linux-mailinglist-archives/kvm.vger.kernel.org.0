Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADCAA338A85
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 11:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbhCLKrr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 05:47:47 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:13886 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233497AbhCLKrP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 05:47:15 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DxjBr137Kz8x4p;
        Fri, 12 Mar 2021 18:45:24 +0800 (CST)
Received: from [10.174.184.135] (10.174.184.135) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Fri, 12 Mar 2021 18:47:04 +0800
Subject: Re: [PATCH v3 2/4] KVM: arm64: GICv4.1: Try to save hw pending state
 in save_pending_tables
To:     Marc Zyngier <maz@kernel.org>
CC:     Eric Auger <eric.auger@redhat.com>, Will Deacon <will@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Lorenzo Pieralisi" <lorenzo.pieralisi@arm.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
References: <20210127121337.1092-1-lushenming@huawei.com>
 <20210127121337.1092-3-lushenming@huawei.com> <87v99yf450.wl-maz@kernel.org>
 <3b47598f-0795-a165-1a64-abe02258b306@huawei.com>
 <87lfasg2wt.wl-maz@kernel.org>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <f43021d8-81f5-81ee-4561-7cfa52ae8023@huawei.com>
Date:   Fri, 12 Mar 2021 18:47:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <87lfasg2wt.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.135]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/3/12 17:02, Marc Zyngier wrote:
> On Thu, 11 Mar 2021 12:31:48 +0000,
> Shenming Lu <lushenming@huawei.com> wrote:
>>
>> On 2021/3/11 17:09, Marc Zyngier wrote:
> 
>>> I have asked that question in the past: is it actually safe to remap
>>> the vPEs and expect them to be runnable
>>
>> In my opinion, logically it can work, but there might be problems like the
>> one below that I didn't notice...
> 
> One thing is that you will have lost interrupts in the meantime
> (assuming your devices are still alive). How will you make up for
> that?

I think that devices should be paused for (not only) saving interrupt states,
and in fact, that's exactly what such as VFIO devices do...

> 
>>
>>>
>>> Also, the current code assumes that VMAPP.PTZ can be advertised if a
>>> VPT is mapped for the first time. Clearly, it is unlikely that the VPT
>>> will be only populated with 0s, so you'll end up with state corruption
>>> on the first remap.
>>
>> Oh, thanks for pointing it out.
>> And if we always signal PTZ when alloc = 1, does it mean that we
>> can't remap the vPE when the VPT is not empty, thus there is no
>> chance to get the VLPI state?  Could we just assume that the VPT is
>> not empty when first mapping the vPE?
> 
> I think we should drop the setting of PTZ altogether. It is a silly
> micro-optimisation, and if the HW can't parse the VPT efficiently when
> it is empty, then the HW is pretty bad, PTZ or not.

agree :-)

Thanks,
Shenming

> 
> Thanks,
> 
> 	M.
> 
