Return-Path: <kvm+bounces-25424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CAD496543E
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 02:49:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A60E286DC4
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 00:49:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 389C9175A6;
	Fri, 30 Aug 2024 00:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="etGcMieZ"
X-Original-To: kvm@vger.kernel.org
Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B7F1D1300
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 00:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724978931; cv=none; b=j4r5FyeP6m810MipUO5pWAG0duMKGoHDB9/9B50nxdmieFhfDt4FUSppj/fYNF0M+bIh4VKukzoLkzCEKOX8qR+JoHsBm3DNgp7So6OwlcAA01NdUReCo9TUkFiK28NIlF3cCPHLbWbqR3UmW0HiP8LP18tazSHmWGqiDcwcAwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724978931; c=relaxed/simple;
	bh=nvcQIMZEY/YWAkKwga+QFpE6n7wQ4iqysMtfgZ97hsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vh4q8sHpnZYErs4/ENah1xBhYgISbcvRj7oYF7XZTxQlHsDEMMyyGFwxH1aLx6RgcujriXmPTTPIzEiTyCfQ/yKsPNEVZxc4AToD+CjB8EC0P9xESqRAkz3es6G7Dx4BLSx7P5ikLpQvffdL1lwZAN3CiCVabuZk1trtbWhQoiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=etGcMieZ; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 29 Aug 2024 17:48:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724978927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8y2Kll8nT4BLVzBidS9pKQWgrXMIL/ggfNq4v3iS4Ns=;
	b=etGcMieZiC3utjViFAlpI9Q6jTA2GrUhjR3APrcFmjnyykescLwEzzLIR567rkcuifxprw
	492V+ebcrM2d4UHpenLZhBbJ/dJVOb5hUVdap+Mqd3d+QYeJ/tL9FfAttCtER+CVTJnnCs
	yWusU8FlhB1MN5HoGZPcNZMz3fz9HqM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: James Houghton <jthoughton@google.com>
Cc: Yu Zhao <yuzhao@google.com>, Sean Christopherson <seanjc@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	James Morse <james.morse@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v6 03/11] KVM: arm64: Relax locking for kvm_test_age_gfn
 and kvm_age_gfn
Message-ID: <ZtEW5Iym5QsJbONM@linux.dev>
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-4-jthoughton@google.com>
 <CADrL8HV5M-n72KDseDKWpGrUVMjC147Jqz98PxyG2ZeRVbFu8g@mail.gmail.com>
 <Zr_y7Fn63hdowfYM@google.com>
 <CAOUHufYc3hr-+fp14jgEkDN++v6t-z-PRf1yQdKtnje6SgLiiA@mail.gmail.com>
 <ZsOuEP6P0v45ffC0@linux.dev>
 <CADrL8HWf-Onu=4ONBO1CFZ1Tqj5bee=+NnRC333aKqkUy+0Sxg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADrL8HWf-Onu=4ONBO1CFZ1Tqj5bee=+NnRC333aKqkUy+0Sxg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 29, 2024 at 05:33:00PM -0700, James Houghton wrote:
> On Mon, Aug 19, 2024 at 1:42 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> > Asking since you had a setup / data earlier on when you were carrying
> > the series. Hopefully with supportive data we can get arm64 to opt-in
> > to HAVE_KVM_MMU_NOTIFIER_YOUNG_FAST_ONLY as well.
> 
> I'll keep trying some other approaches I can take for getting similar
> testing that Yu had; it is somewhat difficult for me to reproduce
> those tests (and it really shouldn't be.... sorry).

No need to apologize. Getting good test hardware for arm64 is a complete
chore. Sure would love a functional workstation with cores from this
decade...

> I think it makes most sense for me to drop the arm64 patch for now and
> re-propose it (or something stronger) alongside enabling aging. Does
> that sound ok?

I'm a bit disappointed that we haven't gotten forward progress on the
arm64 patches, but I also recognize this is the direction of travel as
the x86 patches are shaping up.

So yeah, I'm OK with it, but I'd love to get the arm64 side sorted out
soon while the context is still fresh.

-- 
Thanks,
Oliver

