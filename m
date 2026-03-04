Return-Path: <kvm+bounces-72657-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MAdMJxymp2kHjAAAu9opvQ
	(envelope-from <kvm+bounces-72657-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 04:25:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 060351FA50A
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 04:25:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1FD1630E052D
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 03:24:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED3533659F9;
	Wed,  4 Mar 2026 03:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y55ilsFI"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CDF364EBE;
	Wed,  4 Mar 2026 03:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772594677; cv=none; b=hP8j3Q1k6kLu9Sxtex+CVa8JyBoBtNs25mTCKPuDrn37JPNbyQEXgXyzqLS7ttIIvecnJslCthEdRf9uII5Z6zzxGaFd3IDE9XzvpPjI/ZI5gNxdp9DXBA5Fl9BcX+2MUKeNixAkpC7P3QRCP7Q2ATiQFhOQyew2OcIf9Sbwh2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772594677; c=relaxed/simple;
	bh=+XUB+cPb6apo0xYcEzw+Ryc3ukmRfySainPZItfuUyU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZCFMjiby4GROcixkyvuD4hyIeyBbX/sO2+3BMus8853p6pgVW1XgTPzfHZsPoWkXOHicl6zRI7l/rL/dblumFVvQXt4xJurG+cIhRkDuPJIIRjjfK603foM1piQhJY4CHUVGzOguzUN6Tz0fy5FsUxsg/rTsr24oLMflRoLsqNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Y55ilsFI; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=uwaew1TASwLFpWF0VG/+hJg8qwclvjQWd4Xpfif75xM=; b=Y55ilsFIY2uEBOFXIvrtEYMcxx
	V/JrCLDxgjkhM/9AmmOM6p2YDvZEp3at1c81Mie4L08hbvdW5XczTSkOpKUYldRXpbRkzcpST75rE
	JSYtWs4lPnRkwt7VLpWnZS8EYTQrG9i0BWDSDV+inn6J4BRublQVBcsZz3JeLdeZOhCHNoqKY6jbX
	slhEqOeUTLTlm9sVqBgehi2kNsWbfS4dhEWJs3o+XtyJnOKyJLFluQ6KxU+iVO6wjIpviTd1Jv27X
	wgrr6MdnWMKHkAWtXiFA2/xvfrUlXJBSn38A1vOyJKFa1OXMKd+jiad+JQnbO2GJUwecYvLglkRKO
	MBiTn2xw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxcqD-0000000Cdoe-3gHX;
	Wed, 04 Mar 2026 03:24:05 +0000
Date: Wed, 4 Mar 2026 03:24:05 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org,
	david@kernel.org, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz,
	jannh@google.com, rppt@kernel.org, mhocko@suse.com,
	pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com,
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org,
	borntraeger@linux.ibm.com, frankja@linux.ibm.com,
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
	agordeev@linux.ibm.com, svens@linux.ibm.com,
	gerald.schaefer@linux.ibm.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: Re: [PATCH v3 2/3] mm: replace vma_start_write() with
 vma_start_write_killable()
Message-ID: <aael1XWaOJN134la@casper.infradead.org>
References: <20260226070609.3072570-1-surenb@google.com>
 <20260226070609.3072570-3-surenb@google.com>
 <74bffc7a-2b8c-40ae-ab02-cd0ced082e18@lucifer.local>
 <CAJuCfpHBfhKFeWAtQo4r-ofVtO=5MvG+OToEgc2DEY+cuZDSGw@mail.gmail.com>
 <aadeHiMqhHF0EQkt@casper.infradead.org>
 <CAJuCfpFB1ON8=rkqu3MkrbD2mVBeHLK4122nm9RH31fH3hT2Hw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFB1ON8=rkqu3MkrbD2mVBeHLK4122nm9RH31fH3hT2Hw@mail.gmail.com>
X-Rspamd-Queue-Id: 060351FA50A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=casper.20170209];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72657-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[oracle.com,linux-foundation.org,kernel.org,nvidia.com,intel.com,gmail.com,sk.com,gourry.net,linux.alibaba.com,redhat.com,arm.com,linux.dev,suse.cz,google.com,suse.com,suse.de,linux.ibm.com,ellerman.id.au,kvack.org,lists.ozlabs.org,vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[43];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[willy@infradead.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[infradead.org:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:dkim,infradead.org:email,oracle.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026 at 04:02:50PM -0800, Suren Baghdasaryan wrote:
> On Tue, Mar 3, 2026 at 2:18 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Tue, Mar 03, 2026 at 02:11:31PM -0800, Suren Baghdasaryan wrote:
> > > On Mon, Mar 2, 2026 at 6:53 AM Lorenzo Stoakes
> > > <lorenzo.stoakes@oracle.com> wrote:
> > > > Overall I'm a little concerned about whether callers can handle -EINTR in all
> > > > cases, have you checked? Might we cause some weirdness in userspace if a syscall
> > > > suddenly returns -EINTR when before it didn't?
> > >
> > > I did check the kernel users and put the patchset through AI reviews.
> > > I haven't checked if any of the affected syscalls do not advertise
> > > -EINTR as a possible error. Adding that to my todo list for the next
> > > respin.
> >
> > This only allows interruption by *fatal* signals.  ie there's no way
> > that userspace will see -EINTR because it's dead before the syscall
> > returns to userspace.  That was the whole point of killable instead of
> > interruptible.
> 
> Ah, I see. So, IIUC, that means any syscall can potentially fail with
> -EINTR and this failure code doesn't need to be documented. Is that
> right?

We could literally return any error code -- it never makes it to
userspace.  I forget where it is, but if you follow the syscall
return to user path, a dying task never makes it to running a single
instruction.

