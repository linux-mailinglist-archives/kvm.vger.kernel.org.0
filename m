Return-Path: <kvm+bounces-2174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E90B57F2BFE
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 12:45:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 268231C21905
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 11:45:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A6CE487B3;
	Tue, 21 Nov 2023 11:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ms+7y6NE"
X-Original-To: kvm@vger.kernel.org
X-Greylist: delayed 97776 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 21 Nov 2023 03:45:36 PST
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90F99C
	for <kvm@vger.kernel.org>; Tue, 21 Nov 2023 03:45:36 -0800 (PST)
Date: Tue, 21 Nov 2023 12:45:32 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700567135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1vXyuuqR2RifIpsPOUI0tAd3q/Y+NUZ1cOd+TYwAMhc=;
	b=ms+7y6NECPDndmWrExsyh+K/Lat2tLhMW3aQiAS4Xjc+I5qat9O1rBlt9c8V8pYE23U8b6
	JkyJYys8jsx6/o6CeIDZ61HHyO+q0DxkNVlbRl5jFbx7KC3zcqdz20wnH+N6JTu8RTsR1v
	LU225GQQLGlDf6NQwVJcJPzJ1CeP9Ds=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	maz@kernel.org, oliver.upton@linux.dev, alexandru.elisei@arm.com, 
	jarichte@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 0/2] arm: pmu-overflow-interrupt: Fix
 failures on Amberwing
Message-ID: <20231121-ec0817b79479f12f457937a1@orel>
References: <20231113174316.341630-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113174316.341630-1-eric.auger@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 13, 2023 at 06:42:39PM +0100, Eric Auger wrote:
> On Qualcomm Amberwing, some pmu-overflow-interrupt failures can be observed.
> Although the even counter overflows, the interrupt is not seen as
> expected on guest side. This happens in the subtest after "promote to 64-b"
> comment.
> 
> After analysis, the PMU overflow interrupt actually hits, ie.
> kvm_pmu_perf_overflow() gets called and KVM_REQ_IRQ_PENDING is set,
> as expected. However the PMCR.E is reset by the handle_exit path, at
> kvm_pmu_handle_pmcr() before the next guest entry and
> kvm_pmu_flush_hwstate/kvm_pmu_update_state subsequent call.
> There, since the enable bit has been reset, kvm_pmu_update_state() does
> not inject the interrupt into the guest.
> 
> This does not seem to be a KVM bug but rather an unfortunate
> scenario where the test disables the PMCR.E too closely to the
> advent of the overflow interrupt.
> 
> Since it looks like a benign and inlikely case, let's resize the number
> of iterations to prevent the PMCR enable bit from being resetted
> immediately at the same time as the actual overflow event.
> 
> Also make pmu_stats volatile to prevent any optimizations.
> 
> Eric Auger (2):
>   arm: pmu: Declare pmu_stats as volatile
>   arm: pmu-overflow-interrupt: Increase count values
> 
>  arm/pmu.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> -- 
> 2.41.0
>

Merged into https://gitlab.com/kvm-unit-tests/kvm-unit-tests master

Thanks,
drew

