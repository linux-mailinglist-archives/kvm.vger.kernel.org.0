Return-Path: <kvm+bounces-72394-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +PQxDmaypWlMEgAAu9opvQ
	(envelope-from <kvm+bounces-72394-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 16:53:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FF671DC32A
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 16:53:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BDED430F7E34
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 15:48:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4304241B352;
	Mon,  2 Mar 2026 15:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qn2tNu2a"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F6441163E
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 15:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772466526; cv=none; b=Bj1mie1ZBXkHEADYCmCCgxt1L5cbR89KqyLWHyS0JJzT4WDvhJCIjI5xQ+C7lU4K3BcBPUhmpr1z61rlxZzodlt/Kiiv81RhCwma+b/zUbqfZ5jHxBDAWM26RNFyNmngay3/wve51kjHzeiIfGU4tgRTilCHXJM6P/ECUKv5bOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772466526; c=relaxed/simple;
	bh=+EtwxgqdOWRZ2FQfy7w/Q9MnqfJZ8XSUbgIqg74laiY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fSkJhUDwfZ6HUfTRo++1WCzG4qQdqiDpx8QyiW62jtAUStWl3MyKK4dpAO48W8rP7X0ZkFQ9voUHZsIow2jINM10+tUEiv9XVTwUX6N2KlaxrFOhQkUIHdrnVGBSXFQiyDP8xjlwM96H3hohMRqn0ecDCCXWkip6Bo91DvqgwoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qn2tNu2a; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <42a719d3-5fbd-4b96-a150-6c0b4a1521a3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772466512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FTECatV7Hem2M5Whzj/+5qLaShaqM0faNoQsDp0E1eI=;
	b=qn2tNu2asGcPBaNPiLBEHqPA1ISUAYvFdlA3yDgMEjvnV9wFHAHANAKzMMQI7p+eoGhJbw
	GB+5m+Qs2PPeTQk6Pxy5HsBkMVi/kh8tLAqThalAcm3txH4p/T0ROgVUJGN2DzQ2qMT7uD
	UjSW9pewzRKpXJGWz1nxJ1hYJh2XlGg=
Date: Mon, 2 Mar 2026 23:48:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v5 2/2] x86/tlb: skip redundant sync IPIs for native TLB
 flush
Content-Language: en-US
To: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@intel.com,
 dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
 will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, arnd@arndb.de, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com,
 seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com
References: <20260302063048.9479-1-lance.yang@linux.dev>
 <20260302063048.9479-3-lance.yang@linux.dev>
 <20260302145652.GH1395266@noisy.programming.kicks-ass.net>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260302145652.GH1395266@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8FF671DC32A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72394-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[linux-foundation.org,kernel.org,intel.com,linux.intel.com,redhat.com,google.com,gmail.com,linutronix.de,alien8.de,zytor.com,arndb.de,oracle.com,nvidia.com,linux.alibaba.com,arm.com,surriel.com,suse.com,lists.linux.dev,vger.kernel.org,kvack.org];
	RCPT_COUNT_TWELVE(0.00)[37];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.994];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lance.yang@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,linux.dev:dkim,linux.dev:mid]
X-Rspamd-Action: no action



On 2026/3/2 22:56, Peter Zijlstra wrote:
> On Mon, Mar 02, 2026 at 02:30:36PM +0800, Lance Yang wrote:
> 
> 
>> @@ -221,3 +222,18 @@ NOKPROBE_SYMBOL(native_load_idt);
>>   
>>   EXPORT_SYMBOL(pv_ops);
>>   EXPORT_SYMBOL_GPL(pv_info);
>> +
>> +void __init native_pv_tlb_init(void)
>> +{
>> +	/*
>> +	 * If PV backend already set the property, respect it.
>> +	 * Otherwise, check if native TLB flush sends real IPIs to all target
>> +	 * CPUs (i.e., not using INVLPGB broadcast invalidation).
>> +	 */
>> +	if (pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast)
>> +		return;
>> +
>> +	if (pv_ops.mmu.flush_tlb_multi == native_flush_tlb_multi &&
>> +	    !cpu_feature_enabled(X86_FEATURE_INVLPGB))
>> +		pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast = true;
>> +}
> 
> How about making this a static_branch instead?

Cool. Thanks for the suggestion!

> 
>> diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
>> index 866ea78ba156..87ef7147eac8 100644
>> --- a/arch/x86/include/asm/tlb.h
>> +++ b/arch/x86/include/asm/tlb.h
>> @@ -5,10 +5,23 @@
>>   #define tlb_flush tlb_flush
>>   static inline void tlb_flush(struct mmu_gather *tlb);
>>   
>> +#define tlb_table_flush_implies_ipi_broadcast tlb_table_flush_implies_ipi_broadcast
>> +static inline bool tlb_table_flush_implies_ipi_broadcast(void);
>> +
>>   #include <asm-generic/tlb.h>
>>   #include <linux/kernel.h>
>>   #include <vdso/bits.h>
>>   #include <vdso/page.h>
>> +#include <asm/paravirt.h>
>> +
>> +static inline bool tlb_table_flush_implies_ipi_broadcast(void)
>> +{
>> +#ifdef CONFIG_PARAVIRT
>> +	return pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast;
>> +#else
>> +	return !cpu_feature_enabled(X86_FEATURE_INVLPGB);
>> +#endif
>> +}
> 
> Then this turns into:
> 
> static inline bool tlb_table_flush_implies_ipi_broadcast(void)
> {
> 	return static_branch_likely(&tlb_ipi_broadcast_key);
> }

Right. That would be cleaner and faster, eliminating the branch overhead.

Trying using static_branch on top of this series, something like:

---8<---
diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
index 87ef7147eac8..409bbf335f26 100644
--- a/arch/x86/include/asm/tlb.h
+++ b/arch/x86/include/asm/tlb.h
@@ -10,17 +10,16 @@ static inline bool 
tlb_table_flush_implies_ipi_broadcast(void);

  #include <asm-generic/tlb.h>
  #include <linux/kernel.h>
+#include <linux/jump_label.h>
  #include <vdso/bits.h>
  #include <vdso/page.h>
  #include <asm/paravirt.h>

+DECLARE_STATIC_KEY_FALSE(tlb_ipi_broadcast_key);
+
  static inline bool tlb_table_flush_implies_ipi_broadcast(void)
  {
-#ifdef CONFIG_PARAVIRT
-	return pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast;
-#else
-	return !cpu_feature_enabled(X86_FEATURE_INVLPGB);
-#endif
+	return static_branch_likely(&tlb_ipi_broadcast_key);
  }

  static inline void tlb_flush(struct mmu_gather *tlb)
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index b681b8319295..bcf28980c319 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -15,6 +15,7 @@
  #include <linux/kprobes.h>
  #include <linux/pgtable.h>
  #include <linux/static_call.h>
+#include <linux/jump_label.h>

  #include <asm/bug.h>
  #include <asm/paravirt.h>
@@ -223,6 +224,8 @@ NOKPROBE_SYMBOL(native_load_idt);
  EXPORT_SYMBOL(pv_ops);
  EXPORT_SYMBOL_GPL(pv_info);

+DEFINE_STATIC_KEY_FALSE(tlb_ipi_broadcast_key);
+
  void __init native_pv_tlb_init(void)
  {
  	/*
@@ -230,10 +233,14 @@ void __init native_pv_tlb_init(void)
  	 * Otherwise, check if native TLB flush sends real IPIs to all target
  	 * CPUs (i.e., not using INVLPGB broadcast invalidation).
  	 */
-	if (pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast)
+	if (pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast) {
+		static_branch_enable(&tlb_ipi_broadcast_key);
  		return;
+	}

  	if (pv_ops.mmu.flush_tlb_multi == native_flush_tlb_multi &&
-	    !cpu_feature_enabled(X86_FEATURE_INVLPGB))
+	    !cpu_feature_enabled(X86_FEATURE_INVLPGB)) {
  		pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast = true;
+		static_branch_enable(&tlb_ipi_broadcast_key);
+	}
  }
---


Thanks,
Lance


