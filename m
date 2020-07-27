Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1144A22E4FD
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 06:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgG0Ei7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 00:38:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:18171 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgG0Ei7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 00:38:59 -0400
IronPort-SDR: oHt++YRZMMtHbKQAZju13K2pWl5Sywl9mgmz5q4fVb/YxhLlJrt39CQ7Axp4Kh9FzW230mRgjg
 Cxs0KFhWKRrw==
X-IronPort-AV: E=McAfee;i="6000,8403,9694"; a="152212542"
X-IronPort-AV: E=Sophos;i="5.75,401,1589266800"; 
   d="scan'208";a="152212542"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2020 21:38:58 -0700
IronPort-SDR: L6jOe41O0iqVqciMLpspnbWmF0D/4Y9vYi1l/Y5ngszxIkVL7I31Gq/pAxbYff5Pj9SPokJhGM
 6Q7GnAjVYErQ==
X-IronPort-AV: E=Sophos;i="5.75,401,1589266800"; 
   d="scan'208";a="463930493"
Received: from unknown (HELO [10.239.13.99]) ([10.239.13.99])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2020 21:38:55 -0700
Subject: Re: [RFC 2/2] KVM: VMX: Enable bus lock VM exit
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200628085341.5107-1-chenyi.qiang@intel.com>
 <20200628085341.5107-3-chenyi.qiang@intel.com>
 <878sg3bo8b.fsf@vitty.brq.redhat.com>
 <0159554d-82d5-b388-d289-a5375ca91323@intel.com>
 <87366bbe1y.fsf@vitty.brq.redhat.com>
 <adad61e8-8252-0491-7feb-992a52c1b4f3@intel.com>
 <87zh8j9to2.fsf@vitty.brq.redhat.com> <20200723012114.GP9114@linux.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <a1c2a7dc-d52a-daad-4078-3097579ffef2@intel.com>
Date:   Mon, 27 Jul 2020 12:38:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200723012114.GP9114@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/23/2020 9:21 AM, Sean Christopherson wrote:
> On Wed, Jul 01, 2020 at 04:49:49PM +0200, Vitaly Kuznetsov wrote:
>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>> So you want an exit to userspace for every bus lock and leave it all to
>>> userspace. Yes, it's doable.
>>
>> In some cases we may not even want to have a VM exit: think
>> e.g. real-time/partitioning case when even in case of bus lock we may
>> not want to add additional latency just to count such events.
> 
> Hmm, I suspect this isn't all that useful for real-time cases because they'd
> probably want to prevent the split lock in the first place, e.g. would prefer
> to use the #AC variant in fatal mode.  Of course, the availability of split
> lock #AC is a whole other can of worms.
> 
> But anyways, I 100% agree that this needs either an off-by-default module
> param or an opt-in per-VM capability.
> 

Maybe on-by-default or an opt-out per-VM capability?
Turning it on introduces no overhead if no bus lock happens in guest but 
gives KVM the capability to track every potential bus lock. If user 
doesn't want the extra latency due to bus lock VM exit, it's better try 
to fix the bus lock, which also incurs high latency.

>> I'd suggest we make the new capability tri-state:
>> - disabled (no vmexit, default)
>> - stats only (what this patch does)
>> - userspace exit
>> But maybe this is an overkill, I'd like to hear what others think.
> 
> Userspace exit would also be interesting for debug.  Another throttling
> option would be schedule() or cond_reched(), though that's probably getting
> into overkill territory.
> 

We're going to leverage host's policy, i.e., calling 
handle_user_bus_lock(), for throttling, as proposed in 
https://lkml.kernel.org/r/1595021700-68460-1-git-send-email-fenghua.yu@intel.com

