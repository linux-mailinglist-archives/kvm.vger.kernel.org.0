Return-Path: <kvm+bounces-31552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C52A9C4E31
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 06:27:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3348B1F2538C
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 05:27:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D11E0209F29;
	Tue, 12 Nov 2024 05:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EZZJ2995"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1E019EED4
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 05:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731389214; cv=none; b=ckdFvil1XBYyuXsk1MqDfV6XXHLLxFxtp8KRETzNGKr5EmEoGyf2qezPOz0H0c74fTg5yAgQJMauShNGpfPknXXUTyOkw3UHHFRINsjodJeM/WMNbFGSnrIQ529FhpIWo1H+o2Ccx694gGISt6chEcPL3ZFCQ887qNLZhe/yyl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731389214; c=relaxed/simple;
	bh=oVsiab41iybHXnR7/G592+h0G+z6OO1Cok65V6noxg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WZDuq+GGhv5u3zfuwYVB3EPjUG2dW62g/7EHWGVBz1hMmq2OWWizOxKhN39MwR5+MbZ1707O/9/QC0/7hkaKldWnjcFpMeLj/wfaYLW0UfE6sIzWAcCdD9kmlSqRG+2gIYBKr+PsFW39tIMGBYHpW2NF9bw89+18MisN9xOAyDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EZZJ2995; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=P63/LYtTlv4S5kaMqYTVFRVogiY6Pmn6mZmQEfBCrgo=; b=EZZJ2995WoLdVCIeFUmDxcFhtP
	c4vExF3kDnu+KWQs6dZqU+Gk3OeTwfRe018zV5Pbbo9Ha190pXhoHfrDfSBcfhHo6GPHJNzU6qIu0
	69PvpbaS2uqOZMzwaQbWiLDiloN1wIriRafgENChx8O7NRWsfINs/RfKHUx+uo/R6vDP91SEdJf3K
	GU2laAuy0U4XqHBwtreB7LR8xkBlGX3u3172lJrj48gpOAJBg45BXT7/uu43/Kxb84PpOcjAdGq65
	hz7VvRR0+49EGMDviLYCr+eYEO3tsDfD6tR1IGHDOFjmeaVM82+s5bLP/4XMdNZ77gmgdYO//QrmE
	lnuYxV4Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tAjQM-0000000DtBe-1Blq;
	Tue, 12 Nov 2024 05:26:46 +0000
Date: Tue, 12 Nov 2024 05:26:46 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Fuad Tabba <tabba@google.com>
Cc: David Hildenbrand <david@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>,
	linux-mm@kvack.org, kvm@vger.kernel.org,
	nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	rppt@kernel.org, jglisse@redhat.com, akpm@linux-foundation.org,
	muchun.song@linux.dev, simona@ffwll.ch, airlied@gmail.com,
	pbonzini@redhat.com, seanjc@google.com, jhubbard@nvidia.com,
	ackerleytng@google.com, vannapurve@google.com,
	mail@maciej.szmigiero.name, kirill.shutemov@linux.intel.com,
	quic_eberman@quicinc.com, maz@kernel.org, will@kernel.org,
	qperret@google.com, keirf@google.com, roypat@amazon.co.uk
Subject: Re: [RFC PATCH v1 00/10] mm: Introduce and use folio_owner_ops
Message-ID: <ZzLnFh1_4yYao_Yz@casper.infradead.org>
References: <20241108162040.159038-1-tabba@google.com>
 <20241108170501.GI539304@nvidia.com>
 <9dc212ac-c4c3-40f2-9feb-a8bcf71a1246@redhat.com>
 <CA+EHjTy3kNdg7pfN9HufgibE7qY1S+WdMZfRFRiF5sHtMzo64w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTy3kNdg7pfN9HufgibE7qY1S+WdMZfRFRiF5sHtMzo64w@mail.gmail.com>

On Mon, Nov 11, 2024 at 08:26:54AM +0000, Fuad Tabba wrote:
> Thanks for your comments Jason, and for clarifying my cover letter
> David. I think David has covered everything, and I'll make sure to
> clarify this in the cover letter when I respin.

I don't want you to respin.  I think this is a bad idea.

