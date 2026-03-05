Return-Path: <kvm+bounces-72801-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UKZVBPdJqWlZ3wAAu9opvQ
	(envelope-from <kvm+bounces-72801-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 10:16:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A7CAE20E260
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 10:16:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3B4A3302BF6B
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 09:16:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AE42376BCC;
	Thu,  5 Mar 2026 09:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vYTlFh5P"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC94374E53
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 09:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772702191; cv=none; b=DHzeOcuRTUDF3by3PsqNC/KEphZWEWiQudS14A66Vu6IAAk99yaUv/oLrFleSWNSqqGp/9lT8/1er/iyiHVTD9R21Y3YZ21jYkqIz5po0Fb1DlMkTqZQFyAPzNjqFQc96/gWGdgoWYDeNtvltAklVMrI7PDgfjbOlT8jri14zvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772702191; c=relaxed/simple;
	bh=UMnrDwdAX1GIWTBc+oDF/W1dnRUB+o0y/Pccvdlj3XA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GaNbnOeKpVY05Q4wNyOQKPEKZErgwuv9yNfNEAKOR6YhXHgD50lyy5Up0BOFulV6EpJnohDZb6VSlffcPiWn1JlLOr/v1rYD/Grv+EPkHCYWC9mxLDjdyWpMoNVQQ8WtGfh2QrjROP+cgEot6UygcjLEb7izzCGEg1lZALKFW/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vYTlFh5P; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <5f0aea3d-3189-4712-a6e4-aaf70af3d830@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772702188;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fzXNnVl41rhrnz38phC4X7315ncIjw8uI7oB1uumDrY=;
	b=vYTlFh5P4RnXap2bKi5iM3bSYos1avkWrWoyZ6S9ovnLXURX6Ng1OmFgRSMpye96k1cbwW
	V1trl4Jl8R5kqscSzYNlyJ7l2iGMGX+aMJdR4/9OGfmBJnSnUmIPVuQ11NwJTaUGC8xEWM
	A2pGtpUi3RscntX+HprODuj4hL30rkk=
Date: Thu, 5 Mar 2026 17:16:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v6 2/2] x86/tlb: skip redundant sync IPIs for native TLB
 flush
Content-Language: en-US
To: Dave Hansen <dave.hansen@intel.com>
Cc: peterz@infradead.org, david@kernel.org, dave.hansen@linux.intel.com,
 ypodemsk@redhat.com, hughd@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
 arnd@arndb.de, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 akpm@linux-foundation.org, shy828301@gmail.com, riel@surriel.com,
 jannh@google.com, jgross@suse.com, seanjc@google.com, pbonzini@redhat.com,
 boris.ostrovsky@oracle.com, virtualization@lists.linux.dev,
 kvm@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com
References: <20260304021046.18550-1-lance.yang@linux.dev>
 <20260304021046.18550-3-lance.yang@linux.dev>
 <7dc30fbf-17c0-47db-8457-24b531cd0071@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <7dc30fbf-17c0-47db-8457-24b531cd0071@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A7CAE20E260
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72801-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[infradead.org,kernel.org,linux.intel.com,redhat.com,google.com,gmail.com,linutronix.de,alien8.de,zytor.com,arndb.de,oracle.com,nvidia.com,linux.alibaba.com,arm.com,linux-foundation.org,surriel.com,suse.com,lists.linux.dev,vger.kernel.org,kvack.org];
	RCPT_COUNT_TWELVE(0.00)[37];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lance.yang@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,linux.dev:dkim,linux.dev:mid]
X-Rspamd-Action: no action

Hi Dave,

Thanks for taking time to review!

On 2026/3/5 01:59, Dave Hansen wrote:
> On 3/3/26 18:10, Lance Yang wrote:
> ...
>> +	if (pv_ops.mmu.flush_tlb_multi == native_flush_tlb_multi &&
>> +	    !cpu_feature_enabled(X86_FEATURE_INVLPGB)) {
>> +		pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast = true;
>> +		static_branch_enable(&tlb_ipi_broadcast_key);
>> +	}
>> +}
> ...
>> +#ifndef CONFIG_PARAVIRT
>> +void __init native_pv_tlb_init(void)
>> +{
>> +	/*
>> +	 * For non-PARAVIRT builds, check if native TLB flush sends real IPIs
>> +	 * (i.e., not using INVLPGB broadcast invalidation).
>> +	 */
>> +	if (!cpu_feature_enabled(X86_FEATURE_INVLPGB))
>> +		static_branch_enable(&tlb_ipi_broadcast_key);
>> +}
>> +#endif
> 
> I really despise duplicated logic. The X86_FEATURE_INVLPGB check is
> small, but it is duplicated. You're also setting the static branch in a
> *bunch* of different places.

Sorry for the mess :(

> Can this be arranged so that the PV code just tells the core code that
> it is compatible with flush_tlb_multi_implies_ipi_broadcast?

Yeah, much much better and cleaner!

> void __init bool is_pv_ok(void)
> {
> 	/* This check is super sketchy an unexplained: */
> 	if (pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast)
> 		return true;
> 
> 	if (pv_ops.mmu.flush_tlb_multi != native_flush_tlb_multi)
> 		return false;
> 
> 	pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast = true;
> 
> 	return true;
> }
> 
> void __init tlb_init(void)
> {
> 	if (!is_pv_ok())
> 		return;
> 
> 	if (cpu_feature_enabled(X86_FEATURE_INVLPGB))
> 		return;
> 		
> 	static_branch_enable(&tlb_ipi_broadcast_key);
> }
> 
> Isn't that like a billion times more readable? It has one
> X86_FEATURE_INVLPGB check and one static_branch_enable() point and no
> #ifdeffery other than defining a stub is_pv_ok().

Yep, absolutely ;) Will rework it for v7 as you suggested.

> BTW, why is there even an early return for the case where
> flush_tlb_multi_implies_ipi_broadcast is already set? Isn't this
> decision made once on the boot CPU and then never touched again? Do any
> PV instances actually set the bit?

Good point. No PV backend sets it today, so we don't need that check or
even the property. I'll drop them. If a PV backend ever needs to
indicate it sends real IPIs, we can add the property back then.

Does the following look reasonable?

---8<---
diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
index 866ea78ba156..74292abe8852 100644
--- a/arch/x86/include/asm/tlb.h
+++ b/arch/x86/include/asm/tlb.h
@@ -5,11 +5,19 @@
  #define tlb_flush tlb_flush
  static inline void tlb_flush(struct mmu_gather *tlb);

+#define tlb_table_flush_implies_ipi_broadcast 
tlb_table_flush_implies_ipi_broadcast
+static inline bool tlb_table_flush_implies_ipi_broadcast(void);
+
  #include <asm-generic/tlb.h>
  #include <linux/kernel.h>
  #include <vdso/bits.h>
  #include <vdso/page.h>

+static inline bool tlb_table_flush_implies_ipi_broadcast(void)
+{
+	return static_branch_likely(&tlb_ipi_broadcast_key);
+}
+
  static inline void tlb_flush(struct mmu_gather *tlb)
  {
  	unsigned long start = 0UL, end = TLB_FLUSH_ALL;
@@ -20,7 +28,12 @@ static inline void tlb_flush(struct mmu_gather *tlb)
  		end = tlb->end;
  	}

-	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, tlb->freed_tables);
+	/*
+	 * Pass both freed_tables and unshared_tables so that lazy-TLB CPUs
+	 * also receive IPIs during unsharing page tables.
+	 */
+	flush_tlb_mm_range(tlb->mm, start, end, stride_shift,
+			   tlb->freed_tables || tlb->unshared_tables);
  }

  static inline void invlpg(unsigned long addr)
diff --git a/arch/x86/include/asm/tlbflush.h 
b/arch/x86/include/asm/tlbflush.h
index 5a3cdc439e38..d086454eb760 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -5,6 +5,7 @@
  #include <linux/mm_types.h>
  #include <linux/mmu_notifier.h>
  #include <linux/sched.h>
+#include <linux/jump_label.h>

  #include <asm/barrier.h>
  #include <asm/processor.h>
@@ -15,9 +16,35 @@
  #include <asm/pti.h>
  #include <asm/processor-flags.h>
  #include <asm/pgtable.h>
+#include <asm/paravirt.h>

  DECLARE_PER_CPU(u64, tlbstate_untag_mask);

+DECLARE_STATIC_KEY_FALSE(tlb_ipi_broadcast_key);
+
+#ifdef CONFIG_PARAVIRT
+static inline bool __init pv_tlb_is_native(void)
+{
+	return pv_ops.mmu.flush_tlb_multi == native_flush_tlb_multi;
+}
+#else
+static inline bool __init pv_tlb_is_native(void)
+{
+	return true;
+}
+#endif
+
+static inline void __init native_pv_tlb_init(void)
+{
+	if (!pv_tlb_is_native())
+		return;
+
+	if (cpu_feature_enabled(X86_FEATURE_INVLPGB))
+		return;
+
+	static_branch_enable(&tlb_ipi_broadcast_key);
+}
+
  void __flush_tlb_all(void);

  #define TLB_FLUSH_ALL	-1UL
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 5cd6950ab672..3cdb04162843 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1167,6 +1167,7 @@ void __init native_smp_prepare_boot_cpu(void)
  		switch_gdt_and_percpu_base(me);

  	native_pv_lock_init();
+	native_pv_tlb_init();
  }

  void __init native_smp_cpus_done(unsigned int max_cpus)
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 621e09d049cb..43e60cca38f1 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -26,6 +26,8 @@

  #include "mm_internal.h"

+DEFINE_STATIC_KEY_FALSE(tlb_ipi_broadcast_key);
+
  #ifdef CONFIG_PARAVIRT
  # define STATIC_NOPV
  #else
---


Thanks,
Lance

