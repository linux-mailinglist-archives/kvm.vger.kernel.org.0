Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 392AB15112
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 18:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfEFQU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 12:20:59 -0400
Received: from 6.mo1.mail-out.ovh.net ([46.105.43.205]:48902 "EHLO
        6.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbfEFQU6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 May 2019 12:20:58 -0400
Received: from player693.ha.ovh.net (unknown [10.108.42.88])
        by mo1.mail-out.ovh.net (Postfix) with ESMTP id DF6AE16AE10
        for <kvm@vger.kernel.org>; Mon,  6 May 2019 18:11:01 +0200 (CEST)
Received: from kaod.org (lfbn-1-10649-41.w90-89.abo.wanadoo.fr [90.89.235.41])
        (Authenticated sender: clg@kaod.org)
        by player693.ha.ovh.net (Postfix) with ESMTPSA id 2CC55570048B;
        Mon,  6 May 2019 16:10:58 +0000 (UTC)
Subject: Re: [PATCH v6 00/17] KVM: PPC: Book3S HV: add XIVE native
 exploitation mode
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm-ppc@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>, kvm@vger.kernel.org
References: <20190418103942.2883-1-clg@kaod.org>
 <20190430101146.GJ32205@blackberry>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <1197c5b2-e461-d1d8-28dd-b724ec4635dd@kaod.org>
Date:   Mon, 6 May 2019 18:10:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190430101146.GJ32205@blackberry>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 6671238425827380103
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrjeekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/30/19 12:11 PM, Paul Mackerras wrote:
> On Thu, Apr 18, 2019 at 12:39:25PM +0200, Cédric Le Goater wrote:
>> On the POWER9 processor, the XIVE interrupt controller can control
>> interrupt sources using MMIOs to trigger events, to EOI or to turn off
>> the sources. Priority management and interrupt acknowledgment is also
>> controlled by MMIO in the CPU presenter sub-engine.
>>
>> PowerNV/baremetal Linux runs natively under XIVE but sPAPR guests need
>> special support from the hypervisor to do the same. This is called the
>> XIVE native exploitation mode and today, it can be activated under the
>> PowerPC Hypervisor, pHyp. However, Linux/KVM lacks XIVE native support
>> and still offers the old interrupt mode interface using a KVM device
>> implementing the XICS hcalls over XIVE.
>>
>> The following series is proposal to add the same support under KVM.
>>
>> A new KVM device is introduced for the XIVE native exploitation
>> mode. It reuses most of the XICS-over-XIVE glue implementation
>> structures which are internal to KVM but has a completely different
>> interface. A set of KVM device ioctls provide support for the
>> hypervisor calls, all handled in QEMU, to configure the sources and
>> the event queues. From there, all interrupt control is transferred to
>> the guest which can use MMIOs.
>>
>> These MMIO regions (ESB and TIMA) are exposed to guests in QEMU,
>> similarly to VFIO, and the associated VMAs are populated dynamically
>> with the appropriate pages using a fault handler. These are now
>> implemented using mmap()s of the KVM device fd.
>>
>> Migration has its own specific needs regarding memory. The patchset
>> provides a specific control to quiesce XIVE before capturing the
>> memory. The save and restore of the internal state is based on the
>> same ioctls used for the hcalls.
>>
>> On a POWER9 sPAPR machine, the Client Architecture Support (CAS)
>> negotiation process determines whether the guest operates with a
>> interrupt controller using the XICS legacy model, as found on POWER8,
>> or in XIVE exploitation mode. Which means that the KVM interrupt
>> device should be created at run-time, after the machine has started.
>> This requires extra support from KVM to destroy KVM devices. It is
>> introduced at the end of the patchset and requires some attention.
>>
>> This is based on Linux 5.1-rc5 and is a candidate for 5.2. The OPAL
>> patches have been merged now.
> 
> Thanks, patch series applied to my kvm-ppc-next tree.  I added two
> patches of mine on top to make sure we exclude other execution paths
> in the device release method, and to clear the escalation interrupt
> hardware pointers on release.  I also modified your last patch to free
> the xive structures in book3s.c rather than powerpc.c in order to fix
> compilation for Book E configs.

OK. I have one minor cleanup removing bogus checks in the release method 
of the KVM device. 

Thanks,

C.
