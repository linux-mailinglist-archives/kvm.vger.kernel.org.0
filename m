Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D2B34AAFB
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 16:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbhCZPJV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 11:09:21 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:55446 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbhCZPJQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Mar 2021 11:09:16 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1616771352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=dSjIjx5Eeeu+KcGyXD3UGOYIXdlOREmUvOo1OvKWnzk=;
        b=lFvg9nhCllr59HQqFWmfeMeD/jj3su6D1ArVpw2Kw9ry0wCADyvNkxlV7P9fpFDvZ0stD8
        UUWMQaMPkOozEMcomZHk1KDxOTd9ltTMcK1J49eMmBqQ48ob1HK3dHdFRamC4Vq7rW1DxM
        pD7KVhD08pLYvtjWzdQ01/tzkw5YMXob/Jzaiedy5iQnGYhYGeibB1H/5Pk0hwp3yGM5mk
        TjhsS/l/a8JVhEEEkTdyujiX2GQlE8ugFFt17EpxgFIfoanPaE/x7HCBpP7b6MZ+fjIFZp
        4CGLYW6LvaRFkM1QwIJRNVNffhElVDwjERhKg8WbVx49drVAMmLwHOTNvzjdkA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1616771352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=dSjIjx5Eeeu+KcGyXD3UGOYIXdlOREmUvOo1OvKWnzk=;
        b=runoOFyPk1go3143pg71blr13Xyuo/S3yL1dBJTZ5lpapTOGsab+6IsaGUvxa/G1HaAS3u
        KRMIcl+WfLfKcsCw==
To:     Marc Zyngier <maz@kernel.org>
Cc:     Megha Dey <megha.dey@intel.com>, linux-kernel@vger.kernel.org,
        dave.jiang@intel.com, ashok.raj@intel.com, kevin.tian@intel.com,
        dwmw@amazon.co.uk, x86@kernel.org, tony.luck@intel.com,
        dan.j.williams@intel.com, jgg@mellanox.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, alex.williamson@redhat.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org,
        baolu.lu@linux.intel.com, ravi.v.shankar@intel.com
Subject: Re: [Patch V2 08/13] genirq: Set auxiliary data for an interrupt
In-Reply-To: <87v99efbn6.wl-maz@kernel.org>
Date:   Fri, 26 Mar 2021 16:09:11 +0100
Message-ID: <87h7kydka0.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 26 2021 at 10:32, Marc Zyngier wrote:
> On Thu, 25 Mar 2021 18:59:48 +0000,
> Thomas Gleixner <tglx@linutronix.de> wrote:
>> Though that leaves the question of the data type for 'val'. While u64 is
>> probably good enough for most stuff, anything which needs more than that
>> is left out (again). union as arguments are horrible especially if you
>> need the counterpart irq_get_auxdata() for which you need a pointer and
>> then you can't do a forward declaration. Something like this might work
>> though and avoid to make the pointer business unconditional:
>> 
>>         struct irq_auxdata {
>>                union {
>>         	     u64        val;
>>                      struct foo *foo;
>>                };
>>         };
>
> I guess that at some point, irq_get_auxdata() will become a
> requirement so we might as well bite the bullet now, and the above
> looks like a good start to me.

And because it's some time until rustification, we can come up with
something nasty like the below:

#define IRQ_AUXTYPE(t, m)       IRQ_AUXTYPE_ ## t

enum irq_auxdata_type {
        IRQ_AUXTYPE(U64,		val64),
        IRQ_AUXTYPE(IRQSTATE,		istate),
        IRQ_AUXTYPE(VCPU_AFFINITY,	vaff),
};

struct irq_auxdata {
        union {
                u64             val64;
                u8              istate;
                struct vcpu_aff *vaff;
       };
};

This does not protect you from accessing the wrong union member, but it
allows an analyzer to map IRQ_AUXTYPE_U64 to irq_auxdata::val64 and then
check both the call site and the implementation whether they fiddle with
some other member of irq_auxdata or do weird casts.

Maybe it's just nuts and has no value, but I had the urge to write some
nasty macros.

Thanks,

        tglx
