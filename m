Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23FA031A46E
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 19:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbhBLSS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 13:18:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:52476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231720AbhBLSSr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 13:18:47 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFB7D64DDF;
        Fri, 12 Feb 2021 18:18:06 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lAd12-00Dsau-MJ; Fri, 12 Feb 2021 18:18:04 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 12 Feb 2021 18:18:04 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, kernel-team@android.com,
        Jianyong Wu <jianyong.wu@arm.com>
Subject: Re: [PATCH] KVM: arm64: Handle CMOs on Read Only memslots
In-Reply-To: <4bfd380b-a654-c104-f424-a258bb142e34@arm.com>
References: <20210211142738.1478292-1-maz@kernel.org>
 <4bfd380b-a654-c104-f424-a258bb142e34@arm.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <6c127a2d4276b56205d2d28cc0b9ffc2@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, will@kernel.org, kernel-team@android.com, jianyong.wu@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 2021-02-12 17:12, Alexandru Elisei wrote:
> Hi Marc,
> 
> I've been trying to get my head around what the architecture says about 
> CMOs, so
> please bare with me if I misunderstood some things.

No worries. I've had this patch for a few weeks now, and can't
make up my mind about it. It does address an actual issue though,
so I couldn't just discard it... ;-)

> On 2/11/21 2:27 PM, Marc Zyngier wrote:
>> It appears that when a guest traps into KVM because it is
>> performing a CMO on a Read Only memslot, our handling of
>> this operation is "slightly suboptimal", as we treat it as
>> an MMIO access without a valid syndrome.
>> 
>> The chances that userspace is adequately equiped to deal
>> with such an exception being slim, it would be better to
>> handle it in the kernel.
>> 
>> What we need to provide is roughly as follows:
>> 
>> (a) if a CMO hits writeable memory, handle it as a normal memory acess
>> (b) if a CMO hits non-memory, skip it
>> (c) if a CMO hits R/O memory, that's where things become fun:
>>   (1) if the CMO is DC IVAC, the architecture says this should result
>>       in a permission fault
>>   (2) if the CMO is DC CIVAC, it should work similarly to (a)
> 
> When you say it should work similarly to (a), you mean it should be 
> handled as a
> normal memory access, without the "CMO hits writeable memory" part, 
> right?

What I mean is that the cache invalidation should take place,
preferably without involving KVM at all (other than populating
S2 if required).

> 
>> 
>> We already perform (a) and (b) correctly, but (c) is a total mess.
>> Hence we need to distinguish between IVAC (c.1) and CIVAC (c.2).
>> 
>> One way to do it is to treat CMOs generating a translation fault as
>> a *read*, even when they are on a RW memslot. This allows us to
>> further triage things:
>> 
>> If they come back with a permission fault, that is because this is
>> a DC IVAC instruction:
>> - inside a RW memslot: no problem, treat it as a write (a)(c.2)
>> - inside a RO memslot: inject a data abort in the guest (c.1)
>> 
>> The only drawback is that DC IVAC on a yet unmapped page faults
>> twice: one for the initial translation fault that result in a RO
>> mapping, and once for the permission fault. I think we can live with
>> that.
> 
> I'm trying to make sure I understand what the problem is.
> 
> gfn_to_pfn_prot() returnsKVM_HVA_ERR_RO_BAD if the write is to a RO 
> memslot.
> KVM_HVA_ERR_RO_BAD is PAGE_OFFSET + PAGE_SIZE, which means that
> is_error_noslot_pfn() return true. In that case we exit to userspace
> with -EFAULT
> for DC IVAC and DC CIVAC. But what we should be doing is this:
> 
> - For DC IVAC, inject a dabt with ISS = 0x10, meaning an external abort 
> (that's
> what kvm_inject_dabt_does()).
> 
> - For DC CIVAC, exit to userspace with -EFAULT.
> 
> Did I get that right?

Not quite. What I *think* we should do is:

- DC CIVAC should just work, without going to userspace. I can't imagine
   a reason why we'd involve userspace for this, and we currently don't
   really have a good way to describe this to userspace.

- DC IVAC is more nuanced: we could either inject an exception (which
   is what this patch does), or perform the CMO ourselves as a DC CIVAC
   (consistent with the IVA->CIVA upgrade caused by having a S2 
translation).
   This second approach is comparable to what we do when the guest
   issues a CMO on an emulated MMIO address (we don't inject a fault).

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
