Return-Path: <kvm+bounces-19074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8D65900853
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 17:12:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47F38287336
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 15:12:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63E271940A5;
	Fri,  7 Jun 2024 15:12:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D441825740;
	Fri,  7 Jun 2024 15:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717773168; cv=none; b=emYSv6F/OLdBQui1NKGdl7mvvoFO8on3QseSDszFSBgyZG8jRV3tk3TrTlzcoLhPCNCBTznYYp9TpQJxM2qNsvg5iX8zxZ4yC+q88qFphZQn7T6Ax37RkgVBZtTp58qqYpW5fASYxYAsKq85IYM34A82CmaEg5TSijEOS7OCaRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717773168; c=relaxed/simple;
	bh=cAI7qnCyUWL53klNBARNIYIAmGI2f8rwVGyKdWH1ehE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nqApd+zv50x0SsgwQAk3HjCHt9IRFEM0AoaylidxJbHXoUy2k2LQEN5oZ342Hh0oF3orXbRBXdncbQuhu3xhW2BWaIZD+6dfwkV3acZBl1ealmsLnzyjBPIrYvHZAJ85NCMiwiol6UpyypXIaWdB7WnqY1hPLkoIUqwm8V9v4nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37809C2BBFC;
	Fri,  7 Jun 2024 15:12:45 +0000 (UTC)
Date: Fri, 7 Jun 2024 16:12:42 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Michael Kelley <mhklinux@outlook.com>
Cc: Steven Price <steven.price@arm.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v3 00/14] arm64: Support for running as a guest in Arm CCA
Message-ID: <ZmMjam3-L807AFR-@arm.com>
References: <20240605093006.145492-1-steven.price@arm.com>
 <SN6PR02MB415739D48B10C26D2673F3FED4FB2@SN6PR02MB4157.namprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR02MB415739D48B10C26D2673F3FED4FB2@SN6PR02MB4157.namprd02.prod.outlook.com>

On Fri, Jun 07, 2024 at 01:38:15AM +0000, Michael Kelley wrote:
> From: Steven Price <steven.price@arm.com> Sent: Wednesday, June 5, 2024 2:30 AM
> > This series adds support for running Linux in a protected VM under the
> > Arm Confidential Compute Architecture (CCA). This has been updated
> > following the feedback from the v2 posting[1]. Thanks for the feedback!
> > Individual patches have a change log for v3.
> > 
> > The biggest change from v2 is fixing set_memory_{en,de}crypted() to
> > perform a break-before-make sequence. Note that only the virtual address
> > supplied is flipped between shared and protected, so if e.g. a vmalloc()
> > address is passed the linear map will still point to the (now invalid)
> > previous IPA. Attempts to access the wrong address may trigger a
> > Synchronous External Abort. However any code which attempts to access
> > the 'encrypted' alias after set_memory_decrypted() is already likely to
> > be broken on platforms that implement memory encryption, so I don't
> > expect problems.
> 
> In the case of a vmalloc() address, load_unaligned_zeropad() could still
> make an access to the underlying pages through the linear address. In
> CoCo guests on x86, both the vmalloc PTE and the linear map PTE are
> flipped, so the load_unaligned_zeropad() problem can occur only during
> the transition between decrypted and encrypted. But even then, the
> exception handlers have code to fixup this case and allow everything to
> proceed normally.
> 
> I haven't looked at the code in your patches, but do you handle that case,
> or somehow prevent it?

If we can guarantee that only full a vm_struct area is changed at a
time, the vmap guard page would prevent this issue (not sure we can
though). Otherwise I think we either change the set_memory_*() code to
deal with the other mappings or we handle the exception.

We also have potential user mappings, do we need to do anything about
them?

-- 
Catalin

