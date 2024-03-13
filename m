Return-Path: <kvm+bounces-11736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E7D5587A886
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 14:34:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F2EE1F2425A
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 13:34:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C8BA41C70;
	Wed, 13 Mar 2024 13:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IO4tH2PE"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523CE405FB;
	Wed, 13 Mar 2024 13:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710336833; cv=none; b=J465oQgO9NjEEqHi/l4mAej1fHtSLFWftNQlH2Hbprp1m4ZC/KH3Yd7xOubsqWmfPZaKPKhh+ulYjEiQVXFacQgGUmBOlJNn+LVzTSoNbJ5udzEs9Cmq/+z/UofCfv5WxqTm3FwB6IBKrue8It6eCTxYQDPlFHWpyPw2gnqZD0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710336833; c=relaxed/simple;
	bh=UKNfHkFUfW8BD4aHXiUmUAZ/Q8J+UTCD0Y4wEBqhxb8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f95qsLhTGs+0RdA3VO2CcMtyM+Hp7TJAjXKqpuOJuK9KFyWZ9Ok6vYTbZZYVWEvHAc2xKRRPYT8mzYVm9fpVplAL1QhI6OCD+gGLzdcTUXMGUXmp8xT1bQyKMT4b3+EjiTXyEmIb2PG7C0o+pDsiifdzZFZbJ6MO792clJYJPh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IO4tH2PE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=33U31DCV2KCLLZyQAScLDgQiaurxz3slXOJCTqSXSig=; b=IO4tH2PEhqV8bjmUANSsH9yBTe
	ptWtHefyPjRLVI3cib2dxXCEQFvJzGq3jL4INWhx3If8EpMEcuAZwnp1LsAodRkspZgaeRqZmIM5a
	88cHTcI+PTfP6CpHZ5f21IdgmTIpAMPPOIuGumIR+Tz23utC3sGTrildhKvMXJv2uxpX1AS9EdXlw
	jJFmJ4k9ltxclmV14y980yolFqFwOCp8e/MmyeSVyatBF8BYlq1JeGJ7YNJwV5Zxb2u0a8eDmKP0x
	rGhNv38w0JVWVcXJ6It/3ANdkzroiRADow26MsYNmw0lvKWliKYhgtPz8uUbB///5zwFNM+9mXyV6
	gFyyDiDQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkOjl-0000000AFHm-0hcx;
	Wed, 13 Mar 2024 13:33:41 +0000
Date: Wed, 13 Mar 2024 06:33:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: David Stevens <stevensd@chromium.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Christian Koenig <christian.koenig@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v11 0/8] KVM: allow mapping non-refcounted pages
Message-ID: <ZfGrNSmroP-r9EHy@infradead.org>
References: <20240229025759.1187910-1-stevensd@google.com>
 <ZeCIX5Aw5s1L0YEh@infradead.org>
 <CAD=HUj7fT2CVXLfi5mty0rSzpG_jK9fhcKYGQnTf_H8Hg-541Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD=HUj7fT2CVXLfi5mty0rSzpG_jK9fhcKYGQnTf_H8Hg-541Q@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 13, 2024 at 01:55:20PM +0900, David Stevens wrote:
> On Thu, Feb 29, 2024 at 10:36 PM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On Thu, Feb 29, 2024 at 11:57:51AM +0900, David Stevens wrote:
> > > Our use case is virtio-gpu blob resources [1], which directly map host
> > > graphics buffers into the guest as "vram" for the virtio-gpu device.
> > > This feature currently does not work on systems using the amdgpu driver,
> > > as that driver allocates non-compound higher order pages via
> > > ttm_pool_alloc_page().
> >
> > .. and just as last time around that is still the problem that needs
> > to be fixed instead of creating a monster like this to map
> > non-refcounted pages.
> >
> 
> Patches to amdgpu to have been NAKed [1] with the justification that
> using non-refcounted pages is working as intended and KVM is in the
> wrong for wanting to take references to pages mapped with VM_PFNMAP
> [2].

So make them not work for KVM as they should to kick the amdgpu
maintainers a***es.


