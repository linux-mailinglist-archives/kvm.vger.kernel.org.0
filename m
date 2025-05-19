Return-Path: <kvm+bounces-46944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C2F2DABB2F0
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 03:41:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D559F3A3BAF
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 01:41:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C41AF1A5B84;
	Mon, 19 May 2025 01:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ax3Wmx+N"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A694B67F
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 01:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747618882; cv=none; b=QCMmId0x/GDORdqPck40iz7qRS2ZHLgcFow5oPrHlL8EzrwHIy5Npp/XhogkBYc7MsD4DyKDPfHKF0GpCEmYFWOxwiFNkC778lfGEG8Fdr7fmxhgwVvUiRQ2MJEsGdMwURZqPM4y12X6X5FRk+uKkAiqJz+nVTknPHs5rmfUnQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747618882; c=relaxed/simple;
	bh=8bHs+ArjuXoyWWFogB9cl5mRNW6ulxPQqWHlf2KmQVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qmKMunYtxHsTQa75/SEYZ4Wu27Y5ZdiUfjZEKjzl9Iye0gvq7oY8g3a8gSNyR788SlF8H+nJs0pdVXSzrBVuV32+hfolX0MjlnP3ZMTBBUweQSbEObjEOB6nHH764BeADS1B5NWBcJ8S6qNjk/+nc+emXR3U/z2h0SRmcenw2bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ax3Wmx+N; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sun, 18 May 2025 18:40:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747618868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rWlnN6iHkL3RXstnKSj+lwDH5uEBi7pc60tC98b9q5M=;
	b=ax3Wmx+NMw1xkAkBzBtxFl9a4AKU6VRhBnUQDioRGl9wm2B5KQS0WtxoGTWHgH9XwFj3RY
	HVU7snQyW3kST5tf20n3Fs3zoSdg8K75cJyY7SLm4xvy/9y8X1uoEh7PGLvs1KrsueTMlm
	Lep5/UUMGpBXYRfobuFAAW727pTRADk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v4 00/17] KVM: arm64: Recursive NV support
Message-ID: <aCqL8pZNAUdOeLJo@linux.dev>
References: <20250514103501.2225951-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250514103501.2225951-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, May 14, 2025 at 11:34:43AM +0100, Marc Zyngier wrote:
> Marc Zyngier (17):
>   arm64: sysreg: Add layout for VNCR_EL2
>   KVM: arm64: nv: Allocate VNCR page when required
>   KVM: arm64: nv: Extract translation helper from the AT code
>   KVM: arm64: nv: Snapshot S1 ASID tagging information during walk
>   KVM: arm64: nv: Move TLBI range decoding to a helper
>   KVM: arm64: nv: Don't adjust PSTATE.M when L2 is nesting
>   KVM: arm64: nv: Add pseudo-TLB backing VNCR_EL2
>   KVM: arm64: nv: Add userspace and guest handling of VNCR_EL2
>   KVM: arm64: nv: Handle VNCR_EL2-triggered faults
>   KVM: arm64: nv: Handle mapping of VNCR_EL2 at EL2
>   KVM: arm64: nv: Handle VNCR_EL2 invalidation from MMU notifiers
>   KVM: arm64: nv: Program host's VNCR_EL2 to the fixmap address
>   KVM: arm64: nv: Add S1 TLB invalidation primitive for VNCR_EL2
>   KVM: arm64: nv: Plumb TLBI S1E2 into system instruction dispatch
>   KVM: arm64: nv: Remove dead code from ERET handling
>   KVM: arm64: Allow userspace to request KVM_ARM_VCPU_EL2*
>   KVM: arm64: Document NV caps and vcpu flags

Let it rip!

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thanks,
Oliver

