Return-Path: <kvm+bounces-58986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DE4C8BA8FD6
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 13:17:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 86D951C1746
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 11:17:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92B693002A1;
	Mon, 29 Sep 2025 11:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WrHm+POn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2F31373;
	Mon, 29 Sep 2025 11:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759144665; cv=none; b=TB+NY5VZGYgivg3S82jaRkObp1GHGugCKzIuFeV5vssk1AtS2C9UYALXgH6wNfNPrS3fG5tR3u4ZfZLXL5trNqhT16FqSYGsUyNVkk8iM63/rUhzB4jToKuHuzWxVLVodefry3P0r74tOQgNEhagwIYlkTKefXenVezVJzIARfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759144665; c=relaxed/simple;
	bh=QOGH17/1a5SdNwchfwgIwqy7O5B0PKqdG29VLyNFeVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dwld/bNUm3ZKykDB8BxLCvS0E5d7BgnAvYFT0kEueWdErdy+V+lvXtINU2MBdKCXTcLVOOrao/F8wf+OAwlBSPMkJ3pEjQTnrKNXvySLXRtWEicIinU4lXwyC63lotu9CEBW2Fei84XMrTXME6bWtg5BwNHk/ZFxLNyM0fuubeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WrHm+POn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF48FC4AF09;
	Mon, 29 Sep 2025 11:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759144665;
	bh=QOGH17/1a5SdNwchfwgIwqy7O5B0PKqdG29VLyNFeVo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WrHm+POnJM234takNss03niygYMBwjiniLcOEiF02hizWTvAJXlxsUAMNJN2HDnLD
	 RSDaksxxs5O3zlr3JI35yl0Gp9HLtCAV+vk5JqIeQ9FM0UdOiR6VvDdvKsHSXH+nWk
	 XHSvbzCrrWnxxoTZ/fyQOnqI+YBVfwsGnctn+hIvqAtjGqIrUu1f5gz3nXqVxXI1G+
	 SBLSdEC3bcPnozA1h38hlRcH/cJHG3UQmanuEkdCaUjlFPCdtx0JL5etwKJYOWz/3C
	 nesqqTf7uEuplivme1/8Q39aM4wY5gmQWJzLah0IdGEyRqF8EDxUj6vBPTBimPgJHJ
	 v3D2b2JQTORwA==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id BCAC7F40067;
	Mon, 29 Sep 2025 07:17:43 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 29 Sep 2025 07:17:43 -0400
X-ME-Sender: <xms:12raaOiauOaC3Gt7OC0JwLuQleiT_CyxKb0IGR4F8B1OZ2vVYHFoPg>
    <xme:12raaMZbJmxKcZzF3YPRFhMlTSeEF6tw49LbHP-eW6KqIbW9tbxRmoMHd6FEaStMl
    L_EB6hPd-jXRLHvYW17KTiOZyAtl0oLZoEIBTjGXOyKJAvxYs9pY4c>
X-ME-Received: <xmr:12raaCHsMqbXKafzTpZXoVXjBipsq2VQPjJBTw0M2Rswcovk2-3nxcn5woo1Rg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdejjeekjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeehieekueevudehvedtvdffkefhueefhfevtdduheehkedthfdtheejveelueffgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeefgedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohephigrnhdrhidriihhrghosehinhhtvghlrdgtohhmpdhrtghpthhtoheprhhitghkrd
    hprdgvughgvggtohhmsggvsehinhhtvghlrdgtohhmpdhrtghpthhtohepuggrvhgvrdhh
    rghnshgvnhesihhnthgvlhdrtghomhdprhgtphhtthhopegthhgrohdrghgrohesihhnth
    gvlhdrtghomhdprhgtphhtthhopehsvggrnhhjtgesghhoohhglhgvrdgtohhmpdhrtghp
    thhtohepsghpsegrlhhivghnkedruggvpdhrtghpthhtohepvhgrnhhnrghpuhhrvhgvse
    hgohhoghhlvgdrtghomhdprhgtphhtthhopehkrghirdhhuhgrnhhgsehinhhtvghlrdgt
    ohhmpdhrtghpthhtohepmhhinhhgohesrhgvughhrghtrdgtohhm
X-ME-Proxy: <xmx:12raaK-yCnJseAp-S2nmTWod-TSPlJwt-T7UbFnYNSyy5eNI_-ovOw>
    <xmx:12raaHWaB-OYOAKo--imS9oi1QIcHKcznXba2JkjDoP1jDhkV9-zfw>
    <xmx:12raaGZH_vzfDfWZe28TZh6M8WeiDSSj_My4d3f2R3nsOPt-gqK_Yg>
    <xmx:12raaMWg_0-FdlYGwoxPryTh_uJwATbk1n3y7p8_3GRDBdO9YUV7mQ>
    <xmx:12raaFI95t0vitef8bjpHzTks7uulms7slqRViIQXV3TXw5LyBwJQffV>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 29 Sep 2025 07:17:43 -0400 (EDT)
Date: Mon, 29 Sep 2025 12:17:40 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"Hansen, Dave" <dave.hansen@intel.com>, "Gao, Chao" <chao.gao@intel.com>, 
	"seanjc@google.com" <seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, 
	"Annapurve, Vishal" <vannapurve@google.com>, "Huang, Kai" <kai.huang@intel.com>, 
	"mingo@redhat.com" <mingo@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 00/16] TDX: Enable Dynamic PAMT
Message-ID: <x5wtf2whjjofaxufloomkebek4wnaiyjnteguanpw3ijdaer6q@daize5ngmfcl>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <aNX6V6OSIwly1hu4@yzhao56-desk.sh.intel.com>
 <8f772a23-ea7f-40eb-8852-49f5e3e16c15@intel.com>
 <2b951e427c3f3f06fc310d151b7c9e960c32ec3f.camel@intel.com>
 <7927271c-61e6-4f90-9127-c855a92fe766@intel.com>
 <2fc6595ba9b2b3dc59a251fbac33daa73a107a92.camel@intel.com>
 <aNiQlgY5fkz4mY0l@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNiQlgY5fkz4mY0l@yzhao56-desk.sh.intel.com>

On Sun, Sep 28, 2025 at 09:34:14AM +0800, Yan Zhao wrote:
> On Sat, Sep 27, 2025 at 03:00:31AM +0800, Edgecombe, Rick P wrote:
> > On Fri, 2025-09-26 at 09:11 -0700, Dave Hansen wrote:
> > > If it can't return failure then the _only_ other option is to spin.
> > > Right?
> > 
> > Yea, but you could spin around the SEAMCALL or you could spin on
> > duplicate locks on the kernel side before making the SEAMCALL. Or put
> > more generally, you could prevent contention before you make the
> > SEACMALL. KVM does this also by kicking vCPUs out of the TDX module via
> > IPI in other cases.
> > 
> > > 
> > > I understand the reluctance to have such a nasty spin loop. But other
> > > than reworking the KVM code to do the retries at a higher level,
> > 
> > Re-working KVM code would be tough, although teaching KVM to fail zap
> > calls has come up before for TDX/gmem interactions. It was looked at
> > and decided to be too complex. Now I guess the benefit side of the
> > equation changes a little bit, but doing it only for TDX might still be
> > a bridge to far.
> > 
> > Unless anyone is holding onto another usage that might want this?
> > 
> > >  is there another option?
> > 
> > I don't see why we can't just duplicate the locking in a more matching
> > way on the kernel side. Before the plan to someday drop the global lock
> > if needed, was to switch to 2MB granular locks to match the TDX
> > module's exclusive lock internal behavior.
> > 
> > What Yan is basically pointing out is that there are shared locks that
> > are also taken on different ranges that could possibly contend with the
> > exclusive one that we are duplicating on the kernel side.
> > 
> > So the problem is not fundamental to the approach I think. We just took
> > a shortcut by ignoring the shared locks. For line-of-sight to a path to
> > remove the global lock someday, I think we could make the 2MB granular
> > locks be reader/writer to match the TDX module. Then around the
> > SEAMCALLs that take these locks, we could take them on the kernel side
> > in the right order for whichever SEAMCALL we are making.
> Not sure if that would work.
> 
> In the following scenario, where
> (a) adds PAMT pages B1, xx1 for A1's 2MB physical range.
> (b) adds PAMT pages A2, xx2 for B2's 2MB physical range.
> 
> A1, B2 are not from the same 2MB physical range,
> A1, A2 are from the same 2MB physical range.
> B1, B2 are from the same 2MB physical range.
> Physical addresses of xx1, xx2 are irrelevant.
> 
> 
>     CPU 0                                     CPU 1
>     ---------------------------------         -----------------------------
>     write_lock(&rwlock-of-range-A1);          write_lock(&rwlock-of-range-B2);
>     read_lock(&rwlock-of-range-B1);           read_lock(&rwlock-of-range-A2);
>     ...                                       ...
> (a) TDH.PHYMEM.PAMT.ADD(A1, B1, xx1)      (b) TDH.PHYMEM.PAMT.ADD(B2, A2, xx2)
>     ...                                       ...
>     read_unlock(&rwlock-of-range-B1);         read_unlock(&rwlock-of-range-A2);
>     write_unlock(&rwlock-of-range-A1);        write_unlock(&rwlock-of-range-B2);
> 
> 
> To match the reader/writer locks in the TDX module, it looks like we may
> encounter an AB-BA lock issue.
> 
> Do you have any suggestions for a better approach?
> 
> e.g., could the PAMT pages be allocated from a dedicated pool that ensures they
> reside in different 2MB ranges from guest private pages and TD control pages?

It can work: allocate 2M a time for PAMT and piecemeal it to TDX module
as needed. But it means if 2M allocation is failed, TDX is not functional.

Maybe just use a dedicated kmem_cache for PAMT allocations. Although, I
am not sure if there's a way to specify to kmem_cache what pages to ask
from page allocator.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

