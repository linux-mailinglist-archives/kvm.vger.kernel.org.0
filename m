Return-Path: <kvm+bounces-1054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 73FD27E488A
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 19:45:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CE945B20F1B
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 18:45:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C54C358AB;
	Tue,  7 Nov 2023 18:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wk/XAYNv"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FBF328C8
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 18:45:30 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E431313A
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 10:45:29 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-da1aa98ec19so7242782276.2
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 10:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699382729; x=1699987529; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qDCWSKP4vAXUfzgvit4LuMfPr8WJgpyfnDtKqeEtqPM=;
        b=wk/XAYNv1sOWUOx9OfKo051v4I4PAw012Dm0+OstdHfohkuLZ+iFiZrX7vekrus7qR
         OIWZSQBFjq9+zolNzdjiLFBurKhxYX6xtZxVQ3QJZbJXs0qx5evYgeAKYLGB9TVe7Y13
         shTrZV2oEhHH4kA++BLct7P/ln9dxqnNWuzRnDGeshE4qymb9PtwL/MSeujSujUIAfx9
         TkPPVfVGc1xBSt+MMie33xZgCp5ICqi2+CtYY7JTZsWcxkwqQP2aHawutoCJlxA1/OeC
         /CuAOWHBkbVJruxdEgwLpGhzdUJggpE7/sdpGd6Lc0nXkZdD4oNBSnPzPyyVlpXwWlsp
         iAdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699382729; x=1699987529;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qDCWSKP4vAXUfzgvit4LuMfPr8WJgpyfnDtKqeEtqPM=;
        b=tnL1GwXkHwJ3+RHrNpVIwxou/lnT1etmjgheRURrDAjC1Wde+yIYzP4ZX2Ty+b4pQV
         PP1dRZY1X5cRRMJzokmlUY6g41cWrWgDc53l11xlC3DsXaZVOGXt2Z8ga2Va0rLpN1QC
         XtlTNq9VhM4oTgD6QBF7YCwKWJiIPJmht9dXCA+A88lAY/mTKSIG72cbBFDMKrPyBKWG
         6X2net8f2JhGQjAodmL1j4FHwGr6PLKDhzH2NMKqJfD+uEF9NVZ/ETB78TY4+cj2HyEZ
         X4pOHQlet6MZwRbdJIZESGq/bFv5yzl948+q6PtYE94QxoF4MJBhSVj1LA71KpDd6qsj
         EGQw==
X-Gm-Message-State: AOJu0YwP9wYzpam78umlGcbJKl2TBCrVIkbm32XXmkI0Q7V7IYGsWSmh
	NaCE36II2FLHXD4rOJMCY9/AXBVtXVAtuXkvtg==
X-Google-Smtp-Source: AGHT+IG5qQtQqzPjeR5Y8G8AU6M7XDVXPeztR72N2C8qU92svUe1OJ6H7dpDFe3evTNNP4IMa8JRdAt/s/dkx9nskg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:c789:0:b0:d9a:c218:8177 with SMTP
 id w131-20020a25c789000000b00d9ac2188177mr566295ybe.8.1699382729191; Tue, 07
 Nov 2023 10:45:29 -0800 (PST)
Date: Tue, 07 Nov 2023 18:45:28 +0000
In-Reply-To: <ZUVxNs7q1yRyDq4a@linux.dev> (message from Oliver Upton on Fri, 3
 Nov 2023 22:16:22 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsntsf5hv1vb.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v3 2/3] KVM: arm64: selftests: Guarantee interrupts are handled
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, maz@kernel.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, ricarkol@google.com, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oliver.upton@linux.dev> writes:

> Hi Colton,

> On Fri, Nov 03, 2023 at 07:29:14PM +0000, Colton Lewis wrote:
>> Break up the asm instructions poking daifclr and daifset to handle
>> interrupts. R_RBZYL specifies pending interrupts will be handle after
>> context synchronization events such as an ISB.

>> Introduce a function wrapper for the WFI instruction.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>

> What's missing from the changelog is that you've spotted an actual bug,
> and this is really a bugfix.

I will update the changelog mentioning this is a bugfix.

>> ---
>>   tools/testing/selftests/kvm/aarch64/vgic_irq.c    | 12 ++++++------
>>   tools/testing/selftests/kvm/include/aarch64/gic.h |  3 +++
>>   tools/testing/selftests/kvm/lib/aarch64/gic.c     |  5 +++++
>>   3 files changed, 14 insertions(+), 6 deletions(-)

>> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c  
>> b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
>> index d3bf584d2cc1..85f182704d79 100644
>> --- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
>> +++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
>> @@ -269,13 +269,13 @@ static void guest_inject(struct test_args *args,
>>   	KVM_INJECT_MULTI(cmd, first_intid, num);

>>   	while (irq_handled < num) {
>> -		asm volatile("wfi\n"
>> -			     "msr daifclr, #2\n"
>> -			     /* handle IRQ */
>> -			     "msr daifset, #2\n"
>> -			     : : : "memory");
>> +		gic_wfi();
>> +		local_irq_enable();
>> +		isb();
>> +		/* handle IRQ */

> nit: this comment should appear above the isb()

I put it there because the manual specifies pending interrupts are
handled before the first instruction *after* the context sync, but I can
see why to put it above.

>> +		local_irq_disable();
>>   	}
>> -	asm volatile("msr daifclr, #2" : : : "memory");
>> +	local_irq_enable();

>>   	GUEST_ASSERT_EQ(irq_handled, num);
>>   	for (i = first_intid; i < num + first_intid; i++)
>> diff --git a/tools/testing/selftests/kvm/include/aarch64/gic.h  
>> b/tools/testing/selftests/kvm/include/aarch64/gic.h
>> index 9043eaef1076..f474714e4cb2 100644
>> --- a/tools/testing/selftests/kvm/include/aarch64/gic.h
>> +++ b/tools/testing/selftests/kvm/include/aarch64/gic.h
>> @@ -47,4 +47,7 @@ void gic_irq_clear_pending(unsigned int intid);
>>   bool gic_irq_get_pending(unsigned int intid);
>>   void gic_irq_set_config(unsigned int intid, bool is_edge);

>> +/* Execute a Wait For Interrupt instruction. */
>> +void gic_wfi(void);
>> +

> WFIs have nothing to do with the GIC, they're an instruction supported
> by the CPU. I'd just merge the definition and declaration into the
> header while you're at it.

> So, could you throw something like this in aarch64/processor.h?

> static inline void wfi(void)
> {
> 	asm volatile("wfi");
> }

Will do.

