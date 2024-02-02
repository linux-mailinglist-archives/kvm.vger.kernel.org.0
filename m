Return-Path: <kvm+bounces-7774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 14BDE846531
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 02:01:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 223431C2352B
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 01:01:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C8C26123;
	Fri,  2 Feb 2024 01:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uiDZLS8F"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579435384
	for <kvm@vger.kernel.org>; Fri,  2 Feb 2024 01:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706835704; cv=none; b=T+iDGLmmxZCboKY5+cmi6bOCjHNkQ+WWdnI6QAQA0g5cwO1fMeSCSbLcOk07IYOhD0iMZv1KAnAaCD8+gKnWlQBXeXf0lPSCOPRqn6FjTJQQ6n/yHvIQ6wqpLwwGkEeg3Ri4KkLUWkzfHdvcBoVsgpixK6yvc47oM9FdOPGfWVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706835704; c=relaxed/simple;
	bh=AHkze/xne8c2rDs/5YFU4CmPPZl+QCNpVbfvcAR9b8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OEcoU5LW3ranpuOXLOX71hMripr68j0wFOh/jmHv4GvtOnR7Xrbf9k07M0A5t6UH7mcOXCmcMvLJyDjORrxQHOy6wAOAr6HLQKLq1r0HmYEH5nqyxiIkfvdlranBhcOM9F71HtkavXdJWWA9OTzR32YP54xAouCGJ2t9W8xcP+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uiDZLS8F; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 2 Feb 2024 01:01:34 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706835700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6rGJ8egVATVZUAxthY7XJKnLICupdZkdjp3Ldt/jpN8=;
	b=uiDZLS8F47zN390ABNUPxK9LqG0DBwjE7CdRHKjDKHLEwwwKEFPOSsuiAZWme8f8Agzjxm
	oigF4Q+Sifb5Ey3cmSRIaRDhepMSmlAvlYEXbvT0FQLa2KTsoe339l1BW6J/kzaxWcmId7
	5H4NHPt4YnHufE6z/llS+RP7uKths20=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: James Houghton <jthoughton@google.com>,
	Anish Moorthy <amoorthy@google.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
	robert.hoo.linux@gmail.com, dmatlack@google.com,
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Subject: Re: [PATCH v6 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
Message-ID: <Zbw-7sxotjX3xWsO@linux.dev>
References: <20231109210325.3806151-1-amoorthy@google.com>
 <20231109210325.3806151-7-amoorthy@google.com>
 <CADrL8HWYKSiDZ_ahGbMXjup=r75B4JqC3LvT8A-qPVenV+MOiw@mail.gmail.com>
 <CAF7b7mrA3rB33sUZe3HX33+fXpF=8VwD284LpCcEn9KT9OgwUQ@mail.gmail.com>
 <CADrL8HXSzm_C9UwUb8-H_c6-TRgpkKLE+qeXfyN-X_rHGj2vuw@mail.gmail.com>
 <ZbrxiSNV7e1C6LO-@linux.dev>
 <ZbvGoz67L3gtnHhI@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZbvGoz67L3gtnHhI@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 01, 2024 at 08:28:19AM -0800, Sean Christopherson wrote:

[...]

> Yeah, I let's just make KVM_EXIT_ON_MISSING mutually exclusive with
> KVM_MEM_READONLY.  KVM (oviously) honors the primary MMU protections, so userspace
> can (and does) map read-only memory into the guest without READONLY.  As Oliver
> pointed out, making the *memslot* RO is intended for use cases where userspace
> wants writes to be treated like emulated MMIO.

Well, it was clear enough to me what open source VMMs are doing, I was
curious if Google's VMM is doing something strange with RO memslots that
made the optimization desirable. But it sounds like we're all in
agreement that RO memslots aren't consequential for post-copy.

> We can always add support in the future in the extremely unlikely event someone
> comes along with a legitimate reason for KVM_EXIT_ON_MISSING to play nice with
> KVM_MEM_READONLY.

+1, the less stupid things we let userspace do the better.

-- 
Thanks,
Oliver

