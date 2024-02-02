Return-Path: <kvm+bounces-7776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E4C5846539
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 02:03:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C04401F25E6B
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 01:03:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C35FBE61;
	Fri,  2 Feb 2024 01:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xtC+82p3"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79BFBE59
	for <kvm@vger.kernel.org>; Fri,  2 Feb 2024 01:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706835795; cv=none; b=QILeQLq0uS+PnRNTpdyQglonfSr/9fuvPRH8mtSdcwLFm05Hth0x6OAWY4Y1n54+Hvgjd81N7uUNZY0mu4sfSIWoeIiath7bSxsq53I3PZvEnySigaBj800iamN+izLn6jN99Wd+TU7NWAeLiWI4dIz2daiKwf19MZ3PxJxV6IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706835795; c=relaxed/simple;
	bh=mFPlKhdz7L2eM2XkLINvK0cSi79KSTAM+3hkIu+Lwhs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U6uEnjew0C33d90H7KixPstpodYNDwXTnMLikSRqkFm/97bk1mk9gnHd8+YxA7H7Cq3iW/FZMHJgSacaCWMXsoWTZr+R0Cw4xzeowFpEOEjjIU1kvE7Hr4ityf+rzm3TIlPrDrFcvqBDntHjB/qQ/z3JIAAoDuOE94tpp6OU5nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xtC+82p3; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 2 Feb 2024 01:03:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706835791;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9PrC2aYf8pLPqSNAOw/QU3xgkqlWQAcR7b6XNjRtpdk=;
	b=xtC+82p3mHdVo0ZQsM8DKUpnebYwaUsmGbfs7pzyJ2Ii971A0l6GL0aPXqV/+r67EFrySG
	odZM1iGRMpopgj/+RAhgV9o1Yd+yNwrRsE54YIaMNhzP4eE4xFjWSA9YU5yzu7E1jt1BE/
	JWOZL2sKapXBIb0EpZBw9X7orERJIoI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Anish Moorthy <amoorthy@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
	robert.hoo.linux@gmail.com, dmatlack@google.com,
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Subject: Re: [PATCH v6 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
Message-ID: <Zbw_SOq9gsFfh284@linux.dev>
References: <20231109210325.3806151-1-amoorthy@google.com>
 <20231109210325.3806151-7-amoorthy@google.com>
 <CADrL8HWYKSiDZ_ahGbMXjup=r75B4JqC3LvT8A-qPVenV+MOiw@mail.gmail.com>
 <CAF7b7mrA3rB33sUZe3HX33+fXpF=8VwD284LpCcEn9KT9OgwUQ@mail.gmail.com>
 <CADrL8HXSzm_C9UwUb8-H_c6-TRgpkKLE+qeXfyN-X_rHGj2vuw@mail.gmail.com>
 <ZbrxiSNV7e1C6LO-@linux.dev>
 <ZbvGoz67L3gtnHhI@google.com>
 <CAF7b7mpAt9Dr2jqU6uH=e9gno282BwtHcU7cSSrdBWz7adAW1A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF7b7mpAt9Dr2jqU6uH=e9gno282BwtHcU7cSSrdBWz7adAW1A@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 01, 2024 at 11:24:54AM -0800, Anish Moorthy wrote:

[...]

> Gotcha, I'll go ahead and make the flags incompatible for the next
> version. Thanks for the tidbit on how RO memslots are used Oliver- I
> didn't know that we expect faults on these to be so rare.

You should definitely go and check your userspace to make sure that is
actually the case, but at least for open source VMMs that's the case :)

-- 
Thanks,
Oliver

