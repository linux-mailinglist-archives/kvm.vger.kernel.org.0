Return-Path: <kvm+bounces-69849-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IHEgEv2qgGkFAQMAu9opvQ
	(envelope-from <kvm+bounces-69849-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 14:47:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DA29CCCEA4
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 14:47:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A844E3032CCB
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 13:42:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBAAB36A005;
	Mon,  2 Feb 2026 13:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cML3Fvhx"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E39A1A9F94;
	Mon,  2 Feb 2026 13:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770039767; cv=none; b=Wh+bKpvCIe0413ezoS1w09vEeQmw/r8MKXHbHVxk2G1rTXyutp52Mi+d+TJUN/BlH0WDiHpOiw60fzfvZFx1vdfmZc2leub103g6X/7nd7u/pGnyy0IWCPH9VUijOLU/LhEoKvYJCecN9/QmaFzrosbK1zqjJyUpfBsI4Z4wFqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770039767; c=relaxed/simple;
	bh=flMm1mESK5rb95gVoH/aoKPcdiwGr5AJdSSN5BWIm9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nbpxoxdpoQD5TTztgaeutddQLzOzfG4k5d71fyObqFcgwPdZDdPKZ6v9O+Yp28PvD0ZwLROfWu6qDHFa+W0lFMfjAiD5EvJSvUjSzrPahJ5++oislTVW7O+ATbeLocDZXj5N0oX4ICmKSUo2OHWx9MVcEOJAIOPIaCbGL6GpxxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cML3Fvhx; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FYBvBVbQkUIJwBmMc3AmsjMQCAxLks2LNy5Ykb6Sbho=; b=cML3FvhxJ1RsP4ckPgCxzFMSSr
	9X3dZB/+mAIDMaVtX8ICs5bLtkwwc0zKhd8MTQKfuLTvwhz+EGXgnS53RvFh2k6KEDFqkrKNAMm6M
	Juo4Yb1Tr/4Sgit3UdkfczDLuNCxto9d2UbIUdz8V2s4dzvLQE+wzTyGsMF9GYawGWhFYGr/Y0upH
	RSMOH379lYU0kjXrDJKiwIJvPJg+TtTISWh7WOVQmjW4HKcBUMNtwepXv/Y3veDlKrdjnTttUCSid
	ZznXVmu493xJXmiHSYKXiZ4a/7XVyfCfcW3J2Z9BmrABABfgFvF3w+Z3AFCvIUhLqTdukfLSfBwTU
	3bSohcPQ==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vmuCI-0000000GYdY-0git;
	Mon, 02 Feb 2026 13:42:34 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id A9BFF3008E2; Mon, 02 Feb 2026 14:42:33 +0100 (CET)
Date: Mon, 2 Feb 2026 14:42:33 +0100
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
Subject: Re: [PATCH v4 1/3] mm: use targeted IPIs for TLB sync with lockless
 page table walkers
Message-ID: <20260202134233.GG1395266@noisy.programming.kicks-ass.net>
References: <20260202074557.16544-1-lance.yang@linux.dev>
 <20260202074557.16544-2-lance.yang@linux.dev>
 <20260202094245.GD2995752@noisy.programming.kicks-ass.net>
 <0f44dfb7-fce3-44c1-ab25-b013ba18a59b@linux.dev>
 <20260202125146.GC1395266@noisy.programming.kicks-ass.net>
 <a79a6421-ca97-4a3f-8ec3-55e88da1ec83@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a79a6421-ca97-4a3f-8ec3-55e88da1ec83@linux.dev>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=casper.20170209];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69849-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[linux-foundation.org,kernel.org,intel.com,linux.intel.com,redhat.com,google.com,gmail.com,linutronix.de,alien8.de,zytor.com,arndb.de,oracle.com,nvidia.com,linux.alibaba.com,arm.com,surriel.com,suse.com,lists.linux.dev,vger.kernel.org,kvack.org];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[37];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[infradead.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterz@infradead.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,noisy.programming.kicks-ass.net:mid]
X-Rspamd-Queue-Id: DA29CCCEA4
X-Rspamd-Action: no action

On Mon, Feb 02, 2026 at 09:23:07PM +0800, Lance Yang wrote:

> Hmm... we need MB rather than RMB on the sync side. Is that correct?
> 
> Walker:
> [W]active_lockless_pt_walk_mm = mm -> MB -> [L]page-tables
> 
> Sync:
> [W]page-tables -> MB -> [L]active_lockless_pt_walk_mm
> 

This can work -- but only if the walker and sync touch the same
page-table address.

Now, typically I would imagine they both share the p4d/pud address at
the very least, right?


