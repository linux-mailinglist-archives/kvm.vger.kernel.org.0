Return-Path: <kvm+bounces-72384-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +KtWN8impWngCwAAu9opvQ
	(envelope-from <kvm+bounces-72384-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 16:03:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id E78A91DB5DB
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 16:03:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E8DBC3031DA6
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 14:57:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79DE440148E;
	Mon,  2 Mar 2026 14:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ikqD6uAl"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB0A3E714D;
	Mon,  2 Mar 2026 14:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772463441; cv=none; b=X5pUokxZNDAwaEngPB97zf1P+eDH5UWXUK1Nflgbwkv+KG2c0a0ph7XNVXQaP7ypeBuDMZycS1z+rtZQdxaYqVEPmX22rmwExwvHPRx1EtZ68KLSaqoYtC7B1fPBwIS52E4ySPX+Aha3UYoyDEaeu2T6CNvJ+xWzzT1Ngwez7yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772463441; c=relaxed/simple;
	bh=AXvtUVp1dqbd31BiNo7WZp/bdARrTW0igKEmAv50fNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KLlEnClSx3jAVszcqA8+1W2BYvu78ZiezJz6mecAyhNz3LGwqtw/nRmyL6jFDWXNzDBBJGG99nmH0Fcru29bHlU+QMJzY6vF9CTCzdS53HU/05IE06nyM7HxSCP2hsLJSJ6nRQ1eroPBB9Qnhw1yZ03IXfgjEBCLv9wJeqxPMQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ikqD6uAl; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=51FG2UnZd5khg0RiqyUJE+vDT2282n/46yWgskAeolw=; b=ikqD6uAloCgZUSOvOS1RgqjF4j
	0XIj9O9goT/8xRogpP2thUUsSIS6z6JWEPcQH9XZaVqqzGvygD4VsIpoHCr1qyKzC26ftB59EfJj4
	ZGmXp93LBinORiESM14NyWGh/7+QsJnxk+EgUkkCTpW8LcSlBacpm/5Tz9r8d3yMTeKHR7p/EvZPa
	LnsXDLD9suCcGnHP3/FwMEA8mhNGTTsBheT81VAn3/XPP0Sabalo7OY2Zq9wiCkH5hfCZ0iaMIIAN
	booolOQAPvKEaMjwKIc5sHw7R58mGIjeizpynkcC6PUcaiHg89lm4LO7xxSozE8eKTfj2NL0VoMs2
	DvbBhhPQ==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vx4hZ-00000009dtZ-23cs;
	Mon, 02 Mar 2026 14:56:53 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 06C34300B40; Mon, 02 Mar 2026 15:56:53 +0100 (CET)
Date: Mon, 2 Mar 2026 15:56:52 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@intel.com,
	dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
	will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
	hpa@zytor.com, arnd@arndb.de, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, shy828301@gmail.com,
	riel@surriel.com, jannh@google.com, jgross@suse.com,
	seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ioworker0@gmail.com
Subject: Re: [PATCH v5 2/2] x86/tlb: skip redundant sync IPIs for native TLB
 flush
Message-ID: <20260302145652.GH1395266@noisy.programming.kicks-ass.net>
References: <20260302063048.9479-1-lance.yang@linux.dev>
 <20260302063048.9479-3-lance.yang@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302063048.9479-3-lance.yang@linux.dev>
X-Rspamd-Queue-Id: E78A91DB5DB
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=casper.20170209];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72384-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[linux-foundation.org,kernel.org,intel.com,linux.intel.com,redhat.com,google.com,gmail.com,linutronix.de,alien8.de,zytor.com,arndb.de,oracle.com,nvidia.com,linux.alibaba.com,arm.com,surriel.com,suse.com,lists.linux.dev,vger.kernel.org,kvack.org];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[37];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[infradead.org:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterz@infradead.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.996];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,noisy.programming.kicks-ass.net:mid,infradead.org:dkim]
X-Rspamd-Action: no action

On Mon, Mar 02, 2026 at 02:30:36PM +0800, Lance Yang wrote:


> @@ -221,3 +222,18 @@ NOKPROBE_SYMBOL(native_load_idt);
>  
>  EXPORT_SYMBOL(pv_ops);
>  EXPORT_SYMBOL_GPL(pv_info);
> +
> +void __init native_pv_tlb_init(void)
> +{
> +	/*
> +	 * If PV backend already set the property, respect it.
> +	 * Otherwise, check if native TLB flush sends real IPIs to all target
> +	 * CPUs (i.e., not using INVLPGB broadcast invalidation).
> +	 */
> +	if (pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast)
> +		return;
> +
> +	if (pv_ops.mmu.flush_tlb_multi == native_flush_tlb_multi &&
> +	    !cpu_feature_enabled(X86_FEATURE_INVLPGB))
> +		pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast = true;
> +}

How about making this a static_branch instead?

> diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
> index 866ea78ba156..87ef7147eac8 100644
> --- a/arch/x86/include/asm/tlb.h
> +++ b/arch/x86/include/asm/tlb.h
> @@ -5,10 +5,23 @@
>  #define tlb_flush tlb_flush
>  static inline void tlb_flush(struct mmu_gather *tlb);
>  
> +#define tlb_table_flush_implies_ipi_broadcast tlb_table_flush_implies_ipi_broadcast
> +static inline bool tlb_table_flush_implies_ipi_broadcast(void);
> +
>  #include <asm-generic/tlb.h>
>  #include <linux/kernel.h>
>  #include <vdso/bits.h>
>  #include <vdso/page.h>
> +#include <asm/paravirt.h>
> +
> +static inline bool tlb_table_flush_implies_ipi_broadcast(void)
> +{
> +#ifdef CONFIG_PARAVIRT
> +	return pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast;
> +#else
> +	return !cpu_feature_enabled(X86_FEATURE_INVLPGB);
> +#endif
> +}

Then this turns into:

static inline bool tlb_table_flush_implies_ipi_broadcast(void)
{
	return static_branch_likely(&tlb_ipi_broadcast_key);
}



