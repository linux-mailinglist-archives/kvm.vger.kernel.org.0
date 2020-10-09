Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D656E287F7E
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 02:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbgJIA1x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 20:27:53 -0400
Received: from mga12.intel.com ([192.55.52.136]:3671 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbgJIA1x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Oct 2020 20:27:53 -0400
IronPort-SDR: +MBYDWk4VhBxgPSfPPjPyvv9fX/ThHRYkaYyzH4eLFl91nZXuo/igUZi1y+RY3K5CpSx9C7bcQ
 qoaEL3fosooA==
X-IronPort-AV: E=McAfee;i="6000,8403,9768"; a="144746270"
X-IronPort-AV: E=Sophos;i="5.77,353,1596524400"; 
   d="scan'208";a="144746270"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2020 17:27:52 -0700
IronPort-SDR: G3ApJRs9DBx5tMoV7ZPGy8Bg/cN73V13Moz6rrx+oiCZ5sre2aH8z8P9emVRtPEZjgShz5RNjH
 txQKIq5ScDcA==
X-IronPort-AV: E=Sophos;i="5.77,353,1596524400"; 
   d="scan'208";a="528709663"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.209.50.136]) ([10.209.50.136])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2020 17:27:50 -0700
Subject: Re: [PATCH v3 11/18] dmaengine: idxd: ims setup for the vdcm
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     vkoul@kernel.org, megha.dey@intel.com, maz@kernel.org,
        bhelgaas@google.com, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        rafael@kernel.org, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
 <160021253189.67751.12686144284999931703.stgit@djiang5-desk3.ch.intel.com>
 <87mu17ghr1.fsf@nanos.tec.linutronix.de>
 <0f9bdae0-73d7-1b4e-b478-3cbd05c095f4@intel.com>
 <87r1q92mkx.fsf@nanos.tec.linutronix.de>
 <44e19c5d-a0d2-0ade-442c-61727701f4d8@intel.com>
 <87y2kgux2l.fsf@nanos.tec.linutronix.de> <20201008233210.GH4734@nvidia.com>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <ccb6ab6e-6079-160b-56f7-ab42c0816401@intel.com>
Date:   Thu, 8 Oct 2020 17:27:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201008233210.GH4734@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/8/2020 4:32 PM, Jason Gunthorpe wrote:
> On Fri, Oct 09, 2020 at 01:17:38AM +0200, Thomas Gleixner wrote:
>> Dave,
>>
>> On Thu, Oct 08 2020 at 09:51, Dave Jiang wrote:
>>> On 10/8/2020 12:39 AM, Thomas Gleixner wrote:
>>>> On Wed, Oct 07 2020 at 14:54, Dave Jiang wrote:
>>>>> On 9/30/2020 12:57 PM, Thomas Gleixner wrote:
>>>>>> Aside of that this is fiddling in the IMS storage array behind the irq
>>>>>> chips back without any comment here and a big fat comment about the
>>>>>> shared usage of ims_slot::ctrl in the irq chip driver.
>>>>>>
>>>>> This is to program the pasid fields in the IMS table entry. Was
>>>>> thinking the pasid fields may be considered device specific so didn't
>>>>> attempt to add the support to the core code.
>>>>
>>>> Well, the problem is that this is not really irq chip functionality.
>>>>
>>>> But the PASID programming needs to touch the IMS storage which is also
>>>> touched by the irq chip.
>>>>
>>>> This might be correct as is, but without a big fat comment explaining
>>>> WHY it is safe to do so without any form of serialization this is just
>>>> voodoo and unreviewable.
>>>>
>>>> Can you please explain when the PASID is programmed and what the state
>>>> of the interrupt is at that point? Is this a one off setup operation or
>>>> does this happen dynamically at random points during runtime?
>>>
>>> I will put in comments for the function to explain why and when we modify the
>>> pasid field for the IMS entry. Programming of the pasid is done right before we
>>> request irq. And the clearing is done after we free the irq. We will not be
>>> touching the IMS field at runtime. So the touching of the entry should be safe.
>>
>> Thanks for clarifying that.
>>
>> Thinking more about it, that very same thing will be needed for any
>> other IMS device and of course this is not going to end well because
>> some driver will fiddle with the PASID at the wrong time.
> 
> Why? This looks like some quirk of the IDXD HW where it just randomly
> put PASID along with the IRQ mask register. Probably because PASID is
> not the full 32 bits.

The hardware checks that the PASID in the descriptor matches the PASID in the 
IMS entry, to prevent user-mode software from arbitrarily choosing any interrupt 
vector it wants. User mode software has to request an IMS entry from the kernel 
driver and the driver fills in the PASID in the IMS so that only that process 
can use that IMS entry.

> 
> AFAIK the PASID is not tagged on the MemWr TLP triggering the
> interrupt, so it really is unrelated to the irq.
> 
> I think the ioread to get the PASID is rather ugly, it should pluck
> the PASID out of some driver specific data structure with proper
> locking, and thus use the sleepable version of the irqchip?
> 
> This is really not that different from what I was describing for queue
> contexts - the queue context needs to be assigned to the irq # before
> it can be used in the irq chip other wise there is no idea where to
> write the msg to. Just like pasid here.
> 
> Jason
> 
