Return-Path: <kvm+bounces-23646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AA6A994C3FB
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 19:56:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC39E1C2251D
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 17:56:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80AA01465A0;
	Thu,  8 Aug 2024 17:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lHymnHH+"
X-Original-To: kvm@vger.kernel.org
Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A7612CDAE
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 17:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723139758; cv=none; b=OBFpieIA7imAuyNacJjsZVjvfLHygAMfjC6Djs7207NHw3tduPpXh6m1tT9w18IVfZq7oECcEdCqx+CQ66uTlFvrfDwcb6MaR+/jSyl+yTgjT2xMtG7kiJNKau46FVaZLAGP8FV+GGda/wNU31374oKNm3ghGuA7sBOYQ9sOinw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723139758; c=relaxed/simple;
	bh=8cBJ/OUasyDlaDm+uV6M4jjd+cY/+LKS0yu/8qagYyg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WM0Io9M/OvAY9b3N0+5h2uhN4SSnwo1q41ISZ/sjsSEsgLSoNDjvXgf8K5AFpmxpiE+Af1lUbbwhQjv6v6cG3WgL5K8mPo5gf41NagXbWrIGhI9C+D+BsLSWriYLccuNAeJ+I1jwwOBgVWZfv0p7ajkAjarnUTb1rWP9dxmNolM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lHymnHH+; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 8 Aug 2024 17:55:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723139754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DHyamLELFxFvqyuXfn2/colLtUh6a7qi/U4t10FKUEY=;
	b=lHymnHH+dqyrt+owmksdWDKCRhPs0AE+y6sFwQXdVtonO8WOAhxZzK5l2z3DN5R5n7UC37
	k/ISQkrwhrvMooAe4gpq4IR3bmVLYto3Klkn80e7zjgbAdbsHSa9dY7mA4NQAnLYt8VmFd
	l1eSM9M6ectq/stI5676oH8yYrIhk8s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Ricardo Koller <ricarkol@google.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Move data barrier to end of split walk
Message-ID: <ZrUGpZVnUN1NaVga@linux.dev>
References: <20240808174243.2836363-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240808174243.2836363-1-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Colton,

On Thu, Aug 08, 2024 at 05:42:43PM +0000, Colton Lewis wrote:
> This DSB guarantees page table updates have been made visible to the
> hardware table walker. Moving the DSB from stage2_split_walker() to
> after the walk is finished in kvm_pgtable_stage2_split() results in a
> roughly 70% reduction in Clear Dirty Log Time in
> dirty_log_perf_test (modified to use eager page splitting) when using
> huge pages. This gain holds steady through a range of vcpus
> used (tested 1-64) and memory used (tested 1-64GB).

Would you have time to put together a patch for the dirty_log_perf_test
changes you've made? This would be quite valuable for testing future
improvements to eager page splitting.

> This is safe to do because nothing else is using the page tables while
> they are still being mapped and this is how other page table walkers
> already function. None of them have a data barrier in the walker
> itself because relative ordering of table PTEs to table contents comes
> from the release semantics of stage2_make_pte().
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

The diff itself looks good to me, so:

Acked-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver

