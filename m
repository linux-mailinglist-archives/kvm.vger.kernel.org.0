Return-Path: <kvm+bounces-42781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A26BA7CA34
	for <lists+kvm@lfdr.de>; Sat,  5 Apr 2025 18:23:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E4D33B707F
	for <lists+kvm@lfdr.de>; Sat,  5 Apr 2025 16:23:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D4FF15F306;
	Sat,  5 Apr 2025 16:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gY5FMrpt"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37412C9D;
	Sat,  5 Apr 2025 16:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743870200; cv=none; b=EzOjsJ4JWoSo/aAcmm8044vvX27ubOnBjrZayVG4UtHPuCATrMdNwNP3mMBls6Ush0wdVy1OVJ8D9lmFKLFWk8ww1T59UYJpKQIUcQC4Gk51UC8Ao02lbJOLAwg5kXpgNWRpkWuAYstbSOVomtnUObtV+XWi8Ym3j8L8HTUk5+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743870200; c=relaxed/simple;
	bh=S27g2fKB3N15D9kaiwuYmKC/CwTNWujQ5xlSyfiqCnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ovOUJ+Nweg1ltxSgeWVvDpFCpXJchbELhBrr87fUycXMPmIpgEYoWCML1Wz85povp25BYYDXDCasxDAx6Aw+lqf+fqUFPrvk2fmK1s0L88fTCdSKyb3ZLL9BLwXAejExkKeVrph+QBVlOykIsrGS5hKTFIdizdSYr2pHkSdaiv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gY5FMrpt; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=51H4DBdNtaQaW2P/B/Tj+hCm6+P7TC22nEECZ6yf2Ss=; b=gY5FMrpt99vpoQq5zifFxYYOLR
	UiwCIhj7+6nLg4OP9Hl2WYto8vqsQ/drN1hQwIllWv0o/Uo37zTZGbsrdG+PRNttzLB0EdrI2Lq5Y
	GZeGV1l1t2nVqgU0Yj3kowIS1IyJFJ+7GSsEhaWOU6ACbJRDagEZZhoDXr1rzbqgOQ7lzgTXeO3KH
	YXzIaUKG7oR0b7YBkZJUPrnMRHuH9NNOGleRDYUVep8VkJ3D9i5E2TdPuvDDX0pBkPmex4JkcbWWv
	W+qXj3i3bNCt6EkFjLggYI/9mb4C2mD1woYuX0Lk9uptcQ10Jf+c6znFNCK5QEmB3hJZJo524i6ZC
	/cho31sQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u16IV-0000000411K-2BVS;
	Sat, 05 Apr 2025 16:23:07 +0000
Date: Sat, 5 Apr 2025 17:23:07 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
	brauner@kernel.org, akpm@linux-foundation.org, xiaoyao.li@intel.com,
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
	amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
	mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
	ackerleytng@google.com, mail@maciej.szmigiero.name,
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
	liam.merwick@oracle.com, isaku.yamahata@gmail.com,
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
	steven.price@arm.com, quic_eberman@quicinc.com,
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com,
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com,
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org,
	qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
	shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com,
	hughd@google.com, jthoughton@google.com, peterx@redhat.com,
	pankaj.gupta@amd.com
Subject: Re: [PATCH v7 5/7] KVM: guest_memfd: Restore folio state after final
 folio_put()
Message-ID: <Z_FY62PJZmUfvRUZ@casper.infradead.org>
References: <20250328153133.3504118-1-tabba@google.com>
 <20250328153133.3504118-6-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250328153133.3504118-6-tabba@google.com>

On Fri, Mar 28, 2025 at 03:31:31PM +0000, Fuad Tabba wrote:
> +	write_lock(offsets_lock);
> +	folio_lock(folio);

write_lock() is a spinlock.
folio_lock() is a sleeping lock.

Do you not enable any kernel debugging during development?  It would
save you the embarassment of sending patches which are obvious garbage.

