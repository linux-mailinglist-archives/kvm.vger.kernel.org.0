Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6A72CD2C5
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 10:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387647AbgLCJmp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 04:42:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57626 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726070AbgLCJmo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 04:42:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606988478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HeYzdAXqS+NSDGuCOA9BgR8uttc50eB1DCAVPpwd4mc=;
        b=fXuTKHzvCVrRhNXHRqJIFEu8OeR1+fx3rOxA/F5vTUNu4yKpbusdAq2YMX8FUgcgdPyQDD
        A0uFWt43aB/qkxcLjLrc8Blxh74w611UmhArfZCmCPFShqeqq4tHdrT4LvGLhRRPtlUQy0
        eqrsSZnsGVtdazNKOMlPhJJTgLP8Koc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-IZ-rfgQIP6qKFWYJtDKRcw-1; Thu, 03 Dec 2020 04:41:16 -0500
X-MC-Unique: IZ-rfgQIP6qKFWYJtDKRcw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4E641097D88;
        Thu,  3 Dec 2020 09:41:14 +0000 (UTC)
Received: from [10.36.112.89] (ovpn-112-89.ams2.redhat.com [10.36.112.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6FD5F5C1BD;
        Thu,  3 Dec 2020 09:41:13 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 03/10] arm/arm64: gic: Remove memory
 synchronization from ipi_clear_active_handler()
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc:     andre.przywara@arm.com
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
 <20201125155113.192079-4-alexandru.elisei@arm.com>
 <038402be-a119-c162-04f2-d32db26e8a96@redhat.com>
 <df9e2243-008b-3f93-e499-98b887b6c848@arm.com>
 <7c18deb2-cdfc-0c74-f9d6-d08ace616060@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <0697d6ab-bfc0-da42-6c46-e496a5f32331@redhat.com>
Date:   Thu, 3 Dec 2020 10:41:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <7c18deb2-cdfc-0c74-f9d6-d08ace616060@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,

On 12/2/20 3:14 PM, Alexandru Elisei wrote:
> Hi,
> 
> On 12/2/20 2:02 PM, Alexandru Elisei wrote:
> 
>> Hi Eric,
>>
>> On 12/1/20 4:37 PM, Auger Eric wrote:
>>> Hi Alexandru,
>>>
>>> On 11/25/20 4:51 PM, Alexandru Elisei wrote:
>>>> The gicv{2,3}-active test sends an IPI from the boot CPU to itself, then
>>>> checks that the interrupt has been received as expected. There is no need
>>>> to use inter-processor memory synchronization primitives on code that runs
>>>> on the same CPU, so remove the unneeded memory barriers.
>>>>
>>>> The arrays are modified asynchronously (in the interrupt handler) and it is
>>>> possible for the compiler to infer that they won't be changed during normal
>>>> program flow and try to perform harmful optimizations (like stashing a
>>>> previous read in a register and reusing it). To prevent this, for GICv2,
>>>> the smp_wmb() in gicv2_ipi_send_self() is replaced with a compiler barrier.
>>>> For GICv3, the wmb() barrier in gic_ipi_send_single() already implies a
>>>> compiler barrier.
>>>>
>>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>>> ---
>>>>  arm/gic.c | 8 ++++----
>>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/arm/gic.c b/arm/gic.c
>>>> index 401ffafe4299..4e947e8516a2 100644
>>>> --- a/arm/gic.c
>>>> +++ b/arm/gic.c
>>>> @@ -12,6 +12,7 @@
>>>>   * This work is licensed under the terms of the GNU LGPL, version 2.
>>>>   */
>>>>  #include <libcflat.h>
>>>> +#include <linux/compiler.h>
>>>>  #include <errata.h>
>>>>  #include <asm/setup.h>
>>>>  #include <asm/processor.h>
>>>> @@ -260,7 +261,8 @@ static void check_lpi_hits(int *expected, const char *msg)
>>>>  
>>>>  static void gicv2_ipi_send_self(void)
>>>>  {> -	smp_wmb();
>>> nit: previous patch added it and this patch removes it. maybe squash the
>>> modifs into the previous patch saying only a barrier() is needed for self()?
>> You're right, this does look out of place. I'll merge this change into the
>> previous patch.
>>>> +	/* Prevent the compiler from optimizing memory accesses */
>>>> +	barrier();
>>>>  	writel(2 << 24 | IPI_IRQ, gicv2_dist_base() + GICD_SGIR);
>>>>  }
>>>>  
>>>> @@ -359,6 +361,7 @@ static struct gic gicv3 = {
>>>>  	},
>>>>  };
>>>>  
>>>> +/* Runs on the same CPU as the sender, no need for memory synchronization */
>>>>  static void ipi_clear_active_handler(struct pt_regs *regs __unused)
>>>>  {
>>>>  	u32 irqstat = gic_read_iar();
>>>> @@ -375,13 +378,10 @@ static void ipi_clear_active_handler(struct pt_regs *regs __unused)
>>>>  
>>>>  		writel(val, base + GICD_ICACTIVER);
>>>>  
>>>> -		smp_rmb(); /* pairs with wmb in stats_reset */
>>> the comment says it is paired with wmd in stats_reset. So is it OK to
>>> leave the associated wmb?
>> This patch removes multi-processor synchronization from the functions that run on
>> the same CPU. stats_reset() can be called from one CPU (the IPI_SENDER CPU) and
>> the variables it modifies accessed by the interrupt handlers running on different
>> CPUs, like it happens for the IPI tests. In that case we do need the proper
>> barriers in place.
> 
> Sorry, got confused about what you were asking. The next patch removes the
> smp_wmb() from stats_reset() which became redundant after the barriers added to
> the GIC functions that send IPIs. This patch is about removing barriers that were
> never needed in the first place because the functions were running on the same
> CPU, it's not dependent on anyGIC changes.

OK I get it. I was just confused by this pairing commment as we remove
one item and not the other but that's not an issue here as we do not
need the barrier in that case.

Feel free to add my R-b w/ or wo the squash:
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> 
> Thanks,
> Alex
> 

