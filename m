Return-Path: <kvm+bounces-72737-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YFzoAO2CqGmYvAAAu9opvQ
	(envelope-from <kvm+bounces-72737-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 20:07:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A9EA206E4D
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 20:07:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BED2E31593ED
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 19:01:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CD683DA5BB;
	Wed,  4 Mar 2026 19:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ux/svElR"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9679D352F87;
	Wed,  4 Mar 2026 19:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772650873; cv=none; b=tzlC8qGRBOITVsh6EH80vHqHDKDPHMGrWJjwT9mQTn6ynccokTiLxh2RHhgMzuLJqiLxaRg74CsfM/mrrgoT1JNWZ0iXMEZ3jfVbHIWImQYdn/fNT3TlpSs+jro6B6YdxQ0z15emudnmoMyu5JzbLZM/RubqwPzwaMeBPmgI9pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772650873; c=relaxed/simple;
	bh=lwP2L98nHTKfys118P4hGp0JhG7RVkMqDOnarwcsXRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bunXGACmnn0ZAaI8E+Vtk3mmme2Cz7N4G4TSaXUCt9k30EUz7DdyOuMtTssDFHNYvDqSr5v/Q2lUKt73W5ThqNfzbDv+fzxQ5hVcfR6czsKFoLwb4qYp8sEdlAKpVqL4IZdpJtrDZblu+WRInhtlGa9xs2sM6Cy98YkNX0RSQbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ux/svElR; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Wh9qbG+FlyiO8UJnUIqCRxZKnSQBC+n2Ht087H8Gkjc=; b=Ux/svElRXHueLOyBqfF1CjH034
	pVIaaWu+XZ2IzFCkCimQhpcWBz9HZWxXo3fVhBUVfsKzd83PTHdpBmtxIBz/2mEOeJwJMgHCUTHYY
	zPBWTxPIV4MAJw9I8nQsZAl2i/EIG2gVB/J7B7ks4SVOi2uD4WQdtxAPSGwNJpKbiEYLofE5P1cNw
	dG5JNemsOusR9NtxvbnEYiu3NLsng+pstSqqwC//Jq1omGSBxGMvOZNQi1if8OH7Awpt9YFIxf5u8
	gl/KAQsccjpTpyVG559RaXJAx58uOAdor3zwhjmi1zoJUGXCJCAxO1aPyYGmZS/S754Y4GFoZ8vQz
	cSkTSC1A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxrSh-0000000Dl6K-15gd;
	Wed, 04 Mar 2026 19:00:47 +0000
Date: Wed, 4 Mar 2026 19:00:47 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	vbabka@suse.cz, jannh@google.com, rppt@kernel.org, mhocko@suse.com,
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
Message-ID: <aaiBX5Mm36Kg0wq1@casper.infradead.org>
References: <20260226070609.3072570-1-surenb@google.com>
 <20260226070609.3072570-3-surenb@google.com>
 <74bffc7a-2b8c-40ae-ab02-cd0ced082e18@lucifer.local>
 <CAJuCfpHBfhKFeWAtQo4r-ofVtO=5MvG+OToEgc2DEY+cuZDSGw@mail.gmail.com>
 <aadeHiMqhHF0EQkt@casper.infradead.org>
 <CAJuCfpFB1ON8=rkqu3MkrbD2mVBeHLK4122nm9RH31fH3hT2Hw@mail.gmail.com>
 <aael1XWaOJN134la@casper.infradead.org>
 <76aff8f9-1c08-449a-a034-f3b93440d1a8@lucifer.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76aff8f9-1c08-449a-a034-f3b93440d1a8@lucifer.local>
X-Rspamd-Queue-Id: 5A9EA206E4D
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
	TAGGED_FROM(0.00)[bounces-72737-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[google.com,oracle.com,linux-foundation.org,kernel.org,nvidia.com,intel.com,gmail.com,sk.com,gourry.net,linux.alibaba.com,redhat.com,arm.com,linux.dev,suse.cz,suse.com,suse.de,linux.ibm.com,ellerman.id.au,kvack.org,lists.ozlabs.org,vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[44];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,casper.infradead.org:mid,infradead.org:dkim]
X-Rspamd-Action: no action

On Wed, Mar 04, 2026 at 04:53:27PM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Wed, Mar 04, 2026 at 03:24:05AM +0000, Matthew Wilcox wrote:
> > We could literally return any error code -- it never makes it to
> > userspace.  I forget where it is, but if you follow the syscall
> > return to user path, a dying task never makes it to running a single
> > instruction.
> 
> Thanks for that Matthew, that makes life easier then.
> 
> We can probably replace some of the more horrid if (err == -EINTR) stuff with
> fatal_signal_pending(current) to be clearer as a result.

Umm.  Be careful?  fatal_signal_pending() may become true at a later
point, so you may have acquired the lock _and_ fatal_signal_pending()
can be true.  I'd need to audit a patch to be sure that it's a
reasonable replacement.

