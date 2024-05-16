Return-Path: <kvm+bounces-17520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B63638C7243
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 09:48:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5C3F1C2130E
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 07:48:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 755DF69959;
	Thu, 16 May 2024 07:48:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D1A2EB10;
	Thu, 16 May 2024 07:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715845720; cv=none; b=IM7gPUOG4xioYPH6hmu+naZD3FbvD6sRoqtxb15/D1edwPOA8bClFv/MoR3Nugoe04gFo5fRg4QnbGSWvhoDocqeYyNnD5sGbGG91mxUamv1saf9xZM/KjXwiy585pebNtleQZ+mtbhQFMTmUDUxze/X1bwKfOfk+8YQhpd0ipg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715845720; c=relaxed/simple;
	bh=T4oOZ1LmeWclvKPglpSa/G3iKDDHJ/ls07wv3wVQ2EA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fCfYru8rA1osYyQngV4iyQF1QlOqFJsEl6P1hNu9PIi7Qa3T8qquMgVSewkPU0BgC+FojIdcsYAbrUy2nfhf1DpWWNxupGSTcOZljQx+OWxhdpUfOVKsLuxk8HY9y/voSZDvmYaGGTmCJvV/mJn7LbGRuHWa4TZPSxvrOSJA5I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F562C113CC;
	Thu, 16 May 2024 07:48:36 +0000 (UTC)
Date: Thu, 16 May 2024 08:48:34 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v2 09/14] arm64: Enable memory encrypt for Realms
Message-ID: <ZkW6UgrwJT6G9UN-@arm.com>
References: <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-10-steven.price@arm.com>
 <ZkOmrMIMFCgEKuVw@arm.com>
 <5b2db977-7f0f-4c3a-b278-f195c7ddbd80@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b2db977-7f0f-4c3a-b278-f195c7ddbd80@arm.com>

On Wed, May 15, 2024 at 11:47:02AM +0100, Suzuki K Poulose wrote:
> On 14/05/2024 19:00, Catalin Marinas wrote:
> > On Fri, Apr 12, 2024 at 09:42:08AM +0100, Steven Price wrote:
> > Can someone summarise what the point of this protection bit is? The IPA
> > memory is marked as protected/unprotected already via the RSI call and
> > presumably the RMM disables/permits sharing with a non-secure hypervisor
> > accordingly irrespective of which alias the realm guest has the linear
> > mapping mapped to. What does it do with the top bit of the IPA? Is it
> > that the RMM will prevent (via Stage 2) access if the IPA does not match
> > the requested protection? IOW, it unmaps one or the other at Stage 2?
> 
> The Realm's IPA space is split in half. The lower half is "protected"
> and all pages backing the "protected" IPA is in the Realm world and
> thus cannot be shared with the hypervisor. The upper half IPA is
> "unprotected" (backed by Non-secure PAS pages) and can be accessed
> by the Host/hyp.

What about emulated device I/O where there's no backing RAM at an IPA.
Does it need to have the top bit set?

> The RSI call (RSI_IPA_STATE_SET) doesn't make an IPA unprotected. It
> simply "invalidates" a (protected) IPA to "EMPTY" implying the Realm doesn't
> intend to use the "ipa" as RAM anymore and any access to it from
> the Realm would trigger an SEA into the Realm. The RSI call triggers an exit
> to the host with the information and is a hint to the hypervisor to reclaim
> the page backing the IPA.
> 
> Now, given we need dynamic "sharing" of pages (instead of a dedicated
> set of shared pages), "aliasing" of an IPA gives us shared pages.
> i.e., If OS wants to share a page "x" (protected IPA) with the host,
> we mark that as EMPTY via RSI call and then access the "x" with top-bit
> set (aliasing the IPA x). This fault allows the hyp to map the page backing
> IPA "x" as "unprotected" at ALIAS(x) address.

Does the RMM sanity-checks that the NS hyp mappings are protected or
unprotected depending on the IPA range?

I assume that's also the case if the NS hyp is the first one to access a
page before the realm (e.g. inbound virtio transfer; no page allocated
yet because of a realm access).

-- 
Catalin

