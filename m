Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE4CF152F2
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 19:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbfEFRmV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 13:42:21 -0400
Received: from 15.mo7.mail-out.ovh.net ([87.98.180.21]:42726 "EHLO
        15.mo7.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbfEFRmV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 May 2019 13:42:21 -0400
X-Greylist: delayed 8764 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 May 2019 13:42:20 EDT
Received: from player731.ha.ovh.net (unknown [10.108.35.210])
        by mo7.mail-out.ovh.net (Postfix) with ESMTP id DF8BD1126B9
        for <kvm@vger.kernel.org>; Mon,  6 May 2019 17:16:14 +0200 (CEST)
Received: from kaod.org (lfbn-1-10649-41.w90-89.abo.wanadoo.fr [90.89.235.41])
        (Authenticated sender: clg@kaod.org)
        by player731.ha.ovh.net (Postfix) with ESMTPSA id 2DBE955A8813;
        Mon,  6 May 2019 15:16:10 +0000 (UTC)
Subject: Re: [PATCH v6 14/17] KVM: PPC: Book3S HV: XIVE: add passthrough
 support
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm-ppc@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>, kvm@vger.kernel.org
References: <20190418103942.2883-1-clg@kaod.org>
 <20190418103942.2883-15-clg@kaod.org> <20190425070705.GA12768@blackberry>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <d83b5f6a-4d1e-714c-bd67-e3c37b64e5e9@kaod.org>
Date:   Mon, 6 May 2019 17:16:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190425070705.GA12768@blackberry>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 5746030177071434631
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrjeejgdeklecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/25/19 9:07 AM, Paul Mackerras wrote:
> On Thu, Apr 18, 2019 at 12:39:39PM +0200, Cédric Le Goater wrote:
>> The KVM XICS-over-XIVE device and the proposed KVM XIVE native device
>> implement an IRQ space for the guest using the generic IPI interrupts
>> of the XIVE IC controller. These interrupts are allocated at the OPAL
>> level and "mapped" into the guest IRQ number space in the range 0-0x1FFF.
>> Interrupt management is performed in the XIVE way: using loads and
>> stores on the addresses of the XIVE IPI interrupt ESB pages.
>>
>> Both KVM devices share the same internal structure caching information
>> on the interrupts, among which the xive_irq_data struct containing the
>> addresses of the IPI ESB pages and an extra one in case of pass-through.
>> The later contains the addresses of the ESB pages of the underlying HW
>> controller interrupts, PHB4 in all cases for now.
>>
>> A guest, when running in the XICS legacy interrupt mode, lets the KVM
>> XICS-over-XIVE device "handle" interrupt management, that is to
>> perform the loads and stores on the addresses of the ESB pages of the
>> guest interrupts. However, when running in XIVE native exploitation
>> mode, the KVM XIVE native device exposes the interrupt ESB pages to
>> the guest and lets the guest perform directly the loads and stores.
>>
>> The VMA exposing the ESB pages make use of a custom VM fault handler
>> which role is to populate the VMA with appropriate pages. When a fault
>> occurs, the guest IRQ number is deduced from the offset, and the ESB
>> pages of associated XIVE IPI interrupt are inserted in the VMA (using
>> the internal structure caching information on the interrupts).
>>
>> Supporting device passthrough in the guest running in XIVE native
>> exploitation mode adds some extra refinements because the ESB pages
>> of a different HW controller (PHB4) need to be exposed to the guest
>> along with the initial IPI ESB pages of the XIVE IC controller. But
>> the overall mechanic is the same.
>>
>> When the device HW irqs are mapped into or unmapped from the guest
>> IRQ number space, the passthru_irq helpers, kvmppc_xive_set_mapped()
>> and kvmppc_xive_clr_mapped(), are called to record or clear the
>> passthrough interrupt information and to perform the switch.
>>
>> The approach taken by this patch is to clear the ESB pages of the
>> guest IRQ number being mapped and let the VM fault handler repopulate.
>> The handler will insert the ESB page corresponding to the HW interrupt
>> of the device being passed-through or the initial IPI ESB page if the
>> device is being removed.
> 
> One comment below:
> 
>> @@ -257,6 +289,13 @@ static int kvmppc_xive_native_mmap(struct kvm_device *dev,
>>  
>>  	vma->vm_flags |= VM_IO | VM_PFNMAP;
>>  	vma->vm_page_prot = pgprot_noncached_wc(vma->vm_page_prot);
>> +
>> +	/*
>> +	 * Grab the KVM device file address_space to be able to clear
>> +	 * the ESB pages mapping when a device is passed-through into
>> +	 * the guest.
>> +	 */
>> +	xive->mapping = vma->vm_file->f_mapping;
> 
> I'm worried about the lifetime of this pointer.  At the least you
> should clear it in the release function for the device, when you get
> one.  It looks like you should hold the xive->mapping_lock around the
> clearing.  

Yes. This is should be cleaner.

> I think that should be OK then since the release function
> won't get called until all of the mmaps of the fd have been destroyed,
> as I understand things.

and you also have to close the fd by exiting QEMU or resetting the guest.  


Anyhow, I will send a cleanup in a followup patch. 

Thanks,

C. 

