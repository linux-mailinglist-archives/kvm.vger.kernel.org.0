Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547B4287A5F
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 18:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731383AbgJHQvt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 12:51:49 -0400
Received: from mga03.intel.com ([134.134.136.65]:24713 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730603AbgJHQvt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Oct 2020 12:51:49 -0400
IronPort-SDR: AxZOlscEOQr32isxFdBagw2mwUOnsRxFy2QqXnFsTQNpLyRbTvzEGahCB13T9rKbOwxZZDqDs2
 d6F4VcOFURTA==
X-IronPort-AV: E=McAfee;i="6000,8403,9768"; a="165431166"
X-IronPort-AV: E=Sophos;i="5.77,351,1596524400"; 
   d="scan'208";a="165431166"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2020 09:51:48 -0700
IronPort-SDR: 8g4elyEY4dvLDkfzobNzjsd5vTBGnbZXOG7JjFRYCji6enAQFQOit7Ynlp5mtLGuPy3pz6LU8Z
 FddJo+2zjmUQ==
X-IronPort-AV: E=Sophos;i="5.77,351,1596524400"; 
   d="scan'208";a="528563332"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.209.50.136]) ([10.209.50.136])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2020 09:51:46 -0700
Subject: Re: [PATCH v3 11/18] dmaengine: idxd: ims setup for the vdcm
To:     Thomas Gleixner <tglx@linutronix.de>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        rafael@kernel.org, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
 <160021253189.67751.12686144284999931703.stgit@djiang5-desk3.ch.intel.com>
 <87mu17ghr1.fsf@nanos.tec.linutronix.de>
 <0f9bdae0-73d7-1b4e-b478-3cbd05c095f4@intel.com>
 <87r1q92mkx.fsf@nanos.tec.linutronix.de>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <44e19c5d-a0d2-0ade-442c-61727701f4d8@intel.com>
Date:   Thu, 8 Oct 2020 09:51:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <87r1q92mkx.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/8/2020 12:39 AM, Thomas Gleixner wrote:
> On Wed, Oct 07 2020 at 14:54, Dave Jiang wrote:
>> On 9/30/2020 12:57 PM, Thomas Gleixner wrote:
>>> Aside of that this is fiddling in the IMS storage array behind the irq
>>> chips back without any comment here and a big fat comment about the
>>> shared usage of ims_slot::ctrl in the irq chip driver.
>>>
>> This is to program the pasid fields in the IMS table entry. Was
>> thinking the pasid fields may be considered device specific so didn't
>> attempt to add the support to the core code.
> 
> Well, the problem is that this is not really irq chip functionality.
> 
> But the PASID programming needs to touch the IMS storage which is also
> touched by the irq chip.
> 
> This might be correct as is, but without a big fat comment explaining
> WHY it is safe to do so without any form of serialization this is just
> voodoo and unreviewable.
> 
> Can you please explain when the PASID is programmed and what the state
> of the interrupt is at that point? Is this a one off setup operation or
> does this happen dynamically at random points during runtime?

I will put in comments for the function to explain why and when we modify the 
pasid field for the IMS entry. Programming of the pasid is done right before we 
request irq. And the clearing is done after we free the irq. We will not be 
touching the IMS field at runtime. So the touching of the entry should be safe.

> 
> This needs to be clarified first.
> 
> Thanks,
> 
>          tglx
> 
> 
