Return-Path: <kvm+bounces-54369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A56E5B1FF1F
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 08:16:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF2D716AE77
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 06:16:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 584D02BD580;
	Mon, 11 Aug 2025 06:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iCqfn28b"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A7D299AAF
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 06:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754892974; cv=none; b=Prq/84fiskPWWzsRBFRRqOoPnZsTY57P/1IZA8+WXbUCN6cBkPm+GZBiq/2ARe7becvMJFO9gcXkreVGd44FhyJksnq+y8OWuLmWNhf30p93Ye5fAq4Qma3RoRuYV6g9HTwE321JDdR6kLIMVVfu1l2ElJ4+rmutqN8FHadT+FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754892974; c=relaxed/simple;
	bh=qRcx65tSfNjZNu4N52i2GEAwcQ+KCzjfWTM58pkbblA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KECFvOSFBazr4YbxSTFXJmBgwDGjQlZT/B/NSlGCSdHusUbb7xfFHJidSg+AzAR7rUDK+WtzX8dD5WOZ2cFrpW8vgaBbgY/tj0UDtTKZmWsA4sYq6l5H6usczV6AuMpDKMMqhYRT6nqGE8Wtvknww9W0z6qJfDgrKvYiy8uoR+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iCqfn28b; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2D5C4CEED;
	Mon, 11 Aug 2025 06:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754892974;
	bh=qRcx65tSfNjZNu4N52i2GEAwcQ+KCzjfWTM58pkbblA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=iCqfn28bYq4AR5JIRQdxQ/KX2jrNWORhwqCLV5/i7gMlzeiOi6IiBS8mgukd/1foB
	 nnqq4o4F5JNUaXlqpOn2JNUpsNAWZTkEViEipDXGcMTABBr2iYnccDh6w88MVJX916
	 jy5hV6Wqd9F4wLM2bwXQHhvmG2xGQ+kgmMEpsbN55etvk4s55QgA5brOzONCU0+rxo
	 a8m9zs69illOS64VjTLaDKsjLA6PtQK3Is7XYoal6Xv4VIflck4qPAkzV7nzr5zxy0
	 s/ZKnqlkXx+/eN02qfAIDT1RpXNfRlFDaPx1alu3EFLT9HroLYGP4KUheUcIKCQZ+s
	 xE0Bhywt3VvsQ==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Will Deacon <will@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Steven Price <steven.price@arm.com>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC PATCH kvmtool 09/10] vfio/iommufd: Add viommu and vdevice
 objects
In-Reply-To: <aJX089pd81f6vMCu@willie-the-truck>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
 <20250525074917.150332-9-aneesh.kumar@kernel.org>
 <aH4yMUWTuVtgqD7T@willie-the-truck> <yq5att31brz2.fsf@kernel.org>
 <f3b39fdc-e063-4d47-95dd-d4158f139053@arm.com>
 <aJX089pd81f6vMCu@willie-the-truck>
Date: Mon, 11 Aug 2025 11:46:09 +0530
Message-ID: <yq5ajz3agz86.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Will Deacon <will@kernel.org> writes:

> On Mon, Aug 04, 2025 at 11:33:27PM +0100, Suzuki K Poulose wrote:
>> On 24/07/2025 15:09, Aneesh Kumar K.V wrote:
>> > Will Deacon <will@kernel.org> writes:
>> > > On Sun, May 25, 2025 at 01:19:15PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> > > > +	dev_num = vdev->dev_hdr.dev_num;
>> > > > +	/* kvmtool only do 0 domain, 0 bus and 0 function devices. */
>> > > > +	guest_bdf = (0ULL << 32) | (0 << 16) | dev_num << 11 | (0 << 8);
>> > > 
>> > > I don't understand this. Shouldn't the BDF correspond to the virtual
>> > > configuration space? That's not allocated until later, but just going
>> > > with 0 isn't going to work.
>> > > 
>> > > What am I missing?
>> > > 
>> > 
>> > As I understand it, kvmtool supports only bus 0 and does not allow
>> > multifunction devices. Based on that, I derived the guest BDF as follows
>> > (correcting what was wrong in the original patch):
>> > 
>> > guest_bdf = (0ULL << 16) | (0 << 8) | dev_num << 3 | (0 << 0);
>> > 
>> > Are you suggesting that this approach is incorrect, and that we can use
>> > a bus number other than 0?
>> 
>> To put this other way, the emulation of the configuration space is based
>> on the "dev_num". i.e., CFG address is converted to the offset and
>> mapped to the "dev_num". So I think what we have here is correct.
>
> My point is that 'dev_num' isn't allocated until vfio_pci_setup_device(),
> which is called from __iommufd_configure_device() _after_  we've called
> iommufd_alloc_s1bypass_hwpt().
>
> So I don't see how this works. You have to allocate the virtual config
> space before you can allocate the virtual device with iommufd.
>

I did fix that in https://lore.kernel.org/all/yq5att31brz2.fsf@kernel.org/ 

-aneesh

