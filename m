Return-Path: <kvm+bounces-12045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 21A1087F3EB
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 00:21:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B724B1F22310
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:20:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE0A75E088;
	Mon, 18 Mar 2024 23:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3RZ1lIWn"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905145DF2D;
	Mon, 18 Mar 2024 23:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710804048; cv=none; b=ptHv1SOe8RZBxmvU9vy9AB27E+UxjI0G/bWhAws28Eprp8FxMufZEWosYKlBkKozHnaOOvGu2I/5DT1t1cJ2ZpLULQVHOslMuIUEujItdY+YjvaKBg7iURheNAE4v4eCPDIvYG4fT3uTBmu3hFVYcouZCzOMz/47shcTGvuMva8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710804048; c=relaxed/simple;
	bh=DDHPuHjimB+eInGEiyuX23sCywLwLYXf4GLYlJb7AWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s//hlv5HP9OxkONus6Ql6BcxtLhx0nWk53rDEMIQ0SyP3YIHtmG+yL7ISu+Jn8ZMNtZxbMVhbv3n/I9GDmFB+Su1MQ+Id+QYPhqYzxR01AaO+L180fxbk5XE3lVGSK5tyQ/NvINXCa/mCmz9M1ObjO1ryB65aMdTU9n/OE+/P7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3RZ1lIWn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=U5hIl2aY7B11ZMNAsPi+v840t3fuUcO6Vox3nrOcilQ=; b=3RZ1lIWnO0oWioItdZPDwSg9rF
	EsyCQtd7T3cLWBxmAjAEpkvTFkcHEYQ1gM4uCyKlfY0x5IWBgd/nzM5BxShXPz3kqAbHEerSvMWv4
	l5bA2UDexKOMPIFD/BWlomNsu1kQP5jDMGYiKcTJWGcF9+s1ifnKdBZYbewBulXj0ls0KMte2tkYU
	Wnz78Ch3JZQrEoeCuEqNFc733Ds+qJPIoOGnmGRbb58btmR3aSnQsjItIBR+f7cbhm+P3EKtdkHQ/
	MehX1Ea56OmyMghzoowEKb6MbP2euzT22LPDI4egr8Oa84S/Ggkhpw5G2B5Ia2AseuzgHBkpHgt9C
	7cxfHhrg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmMHX-0000000AWmW-3N6Y;
	Mon, 18 Mar 2024 23:20:39 +0000
Date: Mon, 18 Mar 2024 16:20:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	David Stevens <stevensd@chromium.org>,
	Sean Christopherson <seanjc@google.com>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v11 0/8] KVM: allow mapping non-refcounted pages
Message-ID: <ZfjMRzJrN6cfhHJI@infradead.org>
References: <9e604f99-5b63-44d7-8476-00859dae1dc4@amd.com>
 <ZfHKoxVMcBAMqcSC@google.com>
 <93df19f9-6dab-41fc-bbcd-b108e52ff50b@amd.com>
 <ZfHhqzKVZeOxXMnx@google.com>
 <c84fcf0a-f944-4908-b7f6-a1b66a66a6bc@amd.com>
 <d2a95b5c-4c93-47b1-bb5b-ef71370be287@amd.com>
 <CAD=HUj5k+N+zrv-Yybj6K3EvfYpfGNf-Ab+ov5Jv+Zopf-LJ+g@mail.gmail.com>
 <985fd7f8-f8dd-4ce4-aa07-7e47728e3ebd@amd.com>
 <ZfeYU6hqlVF7y9YO@infradead.org>
 <CABgObfZCay5-zaZd9mCYGMeS106L055CxsdOWWvRTUk2TPYycg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgObfZCay5-zaZd9mCYGMeS106L055CxsdOWWvRTUk2TPYycg@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 18, 2024 at 02:10:55PM +0100, Paolo Bonzini wrote:
> Another possibility is to have a double-underscore version that allows
> FOLL_GET, and have the "clean" kvm_follow_pfn() forbid it. So you
> would still have the possibility to convert to __kvm_follow_pfn() with
> FOLL_GET first, and then when you remove the refcount you switch to
> kvm_follow_pfn().

That does sound much better.  Then again anything that actually wants
pages (either for a good reason or historic reasons) really should be
using get/pin_user_pages anyway and not use follow_pte.


