Return-Path: <kvm+bounces-64458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id AE500C83369
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 04:23:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4438634C221
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 03:23:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18D5B2206A7;
	Tue, 25 Nov 2025 03:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZKXJM8uF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBC319F464
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 03:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764040989; cv=none; b=IsrZRWCCDz9FwCbhaTpuwXtFOOc0HHmm9pgOlQWiPtbyW/3eCXBuir8xP00b3IfXVPqr9XTurOSl5M6ZTEKu8ZroOnT3vsYaYh0xC+D8SugJhX7KVSVETo0LnKoBarSqC5Y9uRuf7gWIr+OnTqkzZy0JDLu+dOQzC/6Ca7ub2Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764040989; c=relaxed/simple;
	bh=swjv2dIStOU/Ubq1bO+NPOfpG3tTacuZ4CVZNTwklFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d4ZQmb+gd4JPmbtoioL80RnV6tiD0WVefWri+DkyU1pCPrhaQQXAc6GJoGm5iDTva+erHhyaydWnWFjglu5uRWAbIIDgvpUCRJRPmNQpDDJPYJhXCmFszcuqYcW++KgS4b0jlDrlBnqexmZ3l6arBAQXegNEc0Q6bnP1nvn68cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZKXJM8uF; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764040987; x=1795576987;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=swjv2dIStOU/Ubq1bO+NPOfpG3tTacuZ4CVZNTwklFQ=;
  b=ZKXJM8uFb0fkNQCAXPlaZNqPxBC8e0schFl+LH9RMIszNxF8d/ddmYVW
   8X16Gz2p9wutic23htHAtIFL7ToyNadxH3alq7k7mgXdtXDG71uOZ/C5n
   xWcxxCGcNwta8Qjnt+1C4ygj1v/bo14oqRPR8XOlzeabUwZVvwR+Ny6jH
   DNzetf6w9wvRXtRUMlw6NSJhZh2Y5G5MimSMEoZ9af0ZFiZ89R1VbfGRV
   CXUg57BPZnrOT8QiM3lJ91j+E3870uLYhSD6f0JSb6JmiKSJ+LP/lJArF
   9pSwAx+k/8m+VNoGw6a/U2+SPGMcN6jMFpOMlFxDnlZ7f/A5ANu6Cfk8r
   w==;
X-CSE-ConnectionGUID: f0ZXf7wpSZKM1H8sCYRDCQ==
X-CSE-MsgGUID: C71W52eSTvOrCXH1MjPOqg==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="77422610"
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="77422610"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 19:23:05 -0800
X-CSE-ConnectionGUID: CLPwWsugTx+NOw5BCaXc/Q==
X-CSE-MsgGUID: C7h77fsXQcSZ3DgpKqKj0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="229792287"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa001.jf.intel.com with ESMTP; 24 Nov 2025 19:23:00 -0800
Date: Tue, 25 Nov 2025 11:47:39 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
	mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
	likexu@tencent.com, like.xu.linux@gmail.com, groug@kaod.org,
	khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
	den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
	dapeng1.mi@linux.intel.com, joe.jin@oracle.com,
	ewanhai-oc@zhaoxin.com, ewanhai@zhaoxin.com
Subject: Re: [PATCH v7 2/9] target/i386: disable PERFCORE when "-pmu" is
 configured
Message-ID: <aSUm22dRG6dczdkp@intel.com>
References: <20251111061532.36702-1-dongli.zhang@oracle.com>
 <20251111061532.36702-3-dongli.zhang@oracle.com>
 <aR2ky5WU8CqH8+lS@intel.com>
 <077866b9-eaa2-4671-bb96-6c6776d0f72b@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <077866b9-eaa2-4671-bb96-6c6776d0f72b@oracle.com>

> Please let me know whether you would like to include Patch 2 on
> "amd_perfmon_always_on" as part of the "compat_prop" patch, or if you'd prefer
> that I re-create Patch 2 with your Suggested-by.
> 
> Either option works for me.

I took some time to revisit the dependency issues with PDCM again, and I
do think the approach mentioned in previous reply should work.

Ok, let me pick your patch 1 & 2. I will rebase these on the CET series
(since I've also modified the dependency for Arch LBR). The entire
dependency fix series may take some time and may need to wait for
several weeks.

However, at least it's decoupled from the rest. :)

At the same time, I'll help go through the remaining patches 3-9 again,
as it's been quite a while since I last reviewed them.

> It seems the Patches 3 - 9 are not impacted by this Live Migration issue.
> Perhaps they may be accepted (or as well as Patch 2 "amd_perfmon_always_on")
> without "compat_prop" patch? They are independent with each other.

Yes, I think so.

> Another concern is Patch 3. Something unexpected may occur when live migrating
> from a KVM host without KVM_PMU_CAP_DISABLE to one that has it enabled. The
> migration will succeed, but the perceived perf/vPMU support could change.
> Can we assume it is the user's responsibility to ensure compatibility between
> KVM hosts when "-pmu" is specified?

Yes, I think so, too. I understand that QEMU needs to ensure vmstate
migration compatibility.

Thanks,
Zhao


