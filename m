Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 364148D413
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 15:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbfHNNCf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 09:02:35 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:60545 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbfHNNCe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 09:02:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1565787753; x=1597323753;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=ahedc4jUDKTjKYr/t9LKGSVGXplFx3U807P6YTr2BXY=;
  b=pxcnvuyy+e6NkEQZRmNvsII4zW0P1AEo78w3dH5gpd5a/LuIQNFJEbUS
   Gjoxz5a005sd9YSda+v/yy9DcRaWUd0b6jCQJxy8uirvoNJ/0I23+4DOt
   QN55pPqNb6/499xTAbRv8tJwV3Fp2q1mIB9yF4JR+CF/krABI1QC+w9ji
   w=;
X-IronPort-AV: E=Sophos;i="5.64,385,1559520000"; 
   d="scan'208";a="409587587"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-8549039f.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 14 Aug 2019 13:02:30 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-8549039f.us-west-2.amazon.com (Postfix) with ESMTPS id C0243A227C;
        Wed, 14 Aug 2019 13:02:29 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 14 Aug 2019 13:02:29 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.211) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 14 Aug 2019 13:02:26 +0000
Subject: Re: [PATCH 0/9] arm64: Stolen time support
To:     Steven Price <steven.price@arm.com>, Marc Zyngier <maz@kernel.org>
CC:     <kvm@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
        <linux-doc@vger.kernel.org>, Russell King <linux@armlinux.org.uk>,
        <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Will Deacon" <will@kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>
References: <20190802145017.42543-1-steven.price@arm.com>
 <20190803190522.5fec8f7d@why> <6789f477-8ab5-cc54-1ad2-8627917b07c9@arm.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <8ca5c106-7c12-4c6e-6d81-a90f281a9894@amazon.com>
Date:   Wed, 14 Aug 2019 15:02:25 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6789f477-8ab5-cc54-1ad2-8627917b07c9@arm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.160.211]
X-ClientProxiedBy: EX13D03UWA002.ant.amazon.com (10.43.160.144) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05.08.19 15:06, Steven Price wrote:
> On 03/08/2019 19:05, Marc Zyngier wrote:
>> On Fri,  2 Aug 2019 15:50:08 +0100
>> Steven Price <steven.price@arm.com> wrote:
>>
>> Hi Steven,
>>
>>> This series add support for paravirtualized time for arm64 guests and
>>> KVM hosts following the specification in Arm's document DEN 0057A:
>>>
>>> https://developer.arm.com/docs/den0057/a
>>>
>>> It implements support for stolen time, allowing the guest to
>>> identify time when it is forcibly not executing.
>>>
>>> It doesn't implement support for Live Physical Time (LPT) as there are
>>> some concerns about the overheads and approach in the above
>>> specification, and I expect an updated version of the specification to
>>> be released soon with just the stolen time parts.
>>
>> Thanks for posting this.
>>
>> My current concern with this series is around the fact that we allocate
>> memory from the kernel on behalf of the guest. It is the first example
>> of such thing in the ARM port, and I can't really say I'm fond of it.
>>
>> x86 seems to get away with it by having the memory allocated from
>> userspace, why I tend to like more. Yes, put_user is more
>> expensive than a straight store, but this isn't done too often either.
>>
>> What is the rational for your current approach?
> 
> As I see it there are 3 approaches that can be taken here:
> 
> 1. Hypervisor allocates memory and adds it to the virtual machine. This
> means that everything to do with the 'device' is encapsulated behind the
> KVM_CREATE_DEVICE / KVM_[GS]ET_DEVICE_ATTR ioctls. But since we want the
> stolen time structure to be fast it cannot be a trapping region and has
> to be backed by real memory - in this case allocated by the host kernel.
> 
> 2. Host user space allocates memory. Similar to above, but this time
> user space needs to manage the memory region as well as the usual
> KVM_CREATE_DEVICE dance. I've no objection to this, but it means
> kvmtool/QEMU needs to be much more aware of what is going on (e.g. how
> to size the memory region).

You ideally want to get the host overhead for a VM to as little as you 
can. I'm not terribly fond of the idea of reserving a full page just 
because we're too afraid of having the guest donate memory.

> 
> 3. Guest kernel "donates" the memory to the hypervisor for the
> structure. As far as I'm aware this is what x86 does. The problems I see
> this approach are:
> 
>   a) kexec becomes much more tricky - there needs to be a disabling
> mechanism for the guest to stop the hypervisor scribbling on memory
> before starting the new kernel.

I wouldn't call "quiesce a device" much more tricky. We have to do that 
for other devices as well today.

>   b) If there is more than one entity that is interested in the
> information (e.g. firmware and kernel) then this requires some form of
> arbitration in the guest because the hypervisor doesn't want to have to
> track an arbitrary number of regions to update.

Why would FW care?

>   c) Performance can suffer if the host kernel doesn't have a suitably
> aligned/sized area to use. As you say - put_user() is more expensive.

Just define the interface to always require natural alignment when 
donating a memory location?

> The structure is updated on every return to the VM.

If you really do suffer from put_user(), there are alternatives. You 
could just map the page on the registration hcall and then leave it 
pinned until the vcpu gets destroyed again.

> Of course x86 does prove the third approach can work, but I'm not sure
> which is actually better. Avoid the kexec cancellation requirements was
> the main driver of the current approach. Although many of the

I really don't understand the problem with kexec cancellation. Worst 
case, let guest FW set it up for you and propagate only the address down 
via ACPI/DT. That way you can mark the respective memory as reserved too.

But even with a Linux only mechanism, just take a look at 
arch/x86/kernel/kvmclock.c. All they do to remove the map is to hook 
into machine_crash_shutdown() and machine_shutdown().


Alex

> conversations about this were also tied up with Live Physical Time which
> adds its own complications.
> 
> Steve
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 
