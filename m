Return-Path: <kvm+bounces-71244-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4NvBHbO5lWm7UQIAu9opvQ
	(envelope-from <kvm+bounces-71244-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 14:08:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E08E156854
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 14:08:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 60C3830263FD
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 13:07:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C298320CB1;
	Wed, 18 Feb 2026 13:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jt3wPQRh"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3779A2FDC3C;
	Wed, 18 Feb 2026 13:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771420069; cv=none; b=RKV7xvLciGShGs2lWCXPpXEw177jRK+iJsiWNaFjVVLhwE0bR+T5kcMkzAlLNcR52hVr8HpAC3ZhTX0eps+pD3DbOjkELICxoPnsEbwDz+PtQp5nWhO516kSs7NZnyTtBQ0kXIWDNxXevm76G4+vCc9VIEbz68h8+eHRtq8ciJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771420069; c=relaxed/simple;
	bh=MRGYwwW7dZPASMBAQbEnUUAmVM7Dk5+BeMxteCPdDpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A4yq0pdGX1aCsVa2p6Px/tdvkvQeNahT8TlXG52+LGyidDDxwnfM9UYjG9NvJSNTmsYBtQph1FIpArMYeQFxm/QZr+/13cCQUX490dYfRr9iwXWDGeklSj+kKEWJGssaCmOVdATZawT8ViTPbB9LG+EDQSVle+/HybeUEPJa1Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jt3wPQRh; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MRGYwwW7dZPASMBAQbEnUUAmVM7Dk5+BeMxteCPdDpY=; b=jt3wPQRhLZbn4iPv8TKFakFnNd
	8Gnijfv23M8CBuaPT69BRUwG1x2G0CjlMJvSY6UYI/JS39Dzrg4EGSmimCAQhdRTFyTSJ6utoS57c
	LHiKYdiX5Rr3LReSI880z4nIeBHa/10dKYxt6MwSyf7jVkhN8XSoufBePpdcTeZT/RAbcoKx+UQB2
	CbsvvNEHV603uZVde4B6xz1tbSwntTNoW6utsGgcv/OE3sa4Ol+sF0BJeiQx6666E05koInrZO1yx
	P2jsec9FGpHU+MlYSFJx23LqWaoVns3jq1hEwOnc1+bCjy0g6s6zbjiqFC9r0bCpFRFSISfEbKfW+
	yD7yl16Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vshH1-000000063U6-30XM;
	Wed, 18 Feb 2026 13:07:23 +0000
Date: Wed, 18 Feb 2026 13:07:23 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Heiko Carstens <hca@linux.ibm.com>, akpm@linux-foundation.org,
	david@kernel.org, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	vbabka@suse.cz, jannh@google.com, rppt@kernel.org, mhocko@suse.com,
	pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com,
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org,
	borntraeger@linux.ibm.com, frankja@linux.ibm.com,
	imbrenda@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com,
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm: use vma_start_write_killable() in
 process_vma_walk_lock()
Message-ID: <aZW5i4cqU1qUy3aa@casper.infradead.org>
References: <20260217163250.2326001-1-surenb@google.com>
 <20260217163250.2326001-4-surenb@google.com>
 <20260217191530.13857Aae-hca@linux.ibm.com>
 <CAJuCfpGxsX6kZAzZJZo7aGNxEbeqOhTV8epF+sHXyqUFOP1few@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpGxsX6kZAzZJZo7aGNxEbeqOhTV8epF+sHXyqUFOP1few@mail.gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=casper.20170209];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71244-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[42];
	FREEMAIL_CC(0.00)[linux.ibm.com,linux-foundation.org,kernel.org,nvidia.com,intel.com,gmail.com,sk.com,gourry.net,linux.alibaba.com,oracle.com,redhat.com,arm.com,linux.dev,suse.cz,google.com,suse.com,suse.de,ellerman.id.au,kvack.org,lists.ozlabs.org,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[willy@infradead.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[infradead.org:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2E08E156854
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 12:31:32PM -0800, Suren Baghdasaryan wrote:
> Hmm. My patchset is based on mm-new. I guess the code was modified in
> some other tree. Could you please provide a link to that patchset so I
> can track it? I'll probably remove this patch from my set until that
> one is merged.

mm-new is a bad place to be playing; better to base off mm-unstable.

