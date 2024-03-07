Return-Path: <kvm+bounces-11283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A60F4874ABD
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 10:23:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D54561C21097
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 09:23:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C7E6839F1;
	Thu,  7 Mar 2024 09:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VefQtWd5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBEF77F32
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 09:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709803339; cv=none; b=kvApmUo4iEr+Uban4zw+lNT84nZ6JhoKed2bAAdihX6RzfoPN0H5mdnvJbMIzFbCLew+RalqsyCSx2kmqrl+sEy3+R7E0znG/MTxJvVlVrVv9hyhHqCxxGR2rojo70eXLFI4pudXGtBxr1FrmzmZUo+xaDj2wgXb9AuNb9G1APk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709803339; c=relaxed/simple;
	bh=mH2vV5yBYodscgLGGjP3q4srUDrIk3WwzcYNpLXQoWc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XG3LO+5nNn812HiDLd+pXT5VMYDQGOkKVEurDlopUzeQka3obeTxi3O3Hz79NLxPepSbJHWkdVIDRQ3l70ErvOrLnOFDcA9RpRwxV58t8vgHnjWmIKCEWnNcQHNORQXx9l5mmCw6bZIwYF8bfB8pPUEjkVRsXys3WO/ubLTcKYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VefQtWd5; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709803338; x=1741339338;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mH2vV5yBYodscgLGGjP3q4srUDrIk3WwzcYNpLXQoWc=;
  b=VefQtWd5mRqLMEkyNDr7/R5s/ykeX7fBFLxoGgxtN6ckgZruX05YeNeK
   FU7W65COOS3DLPS/IbzOsC5aZQlxINwdDQjsO8DIRq0fr3vai9eU3kLKr
   aJU2oIRE8ksULFbFdeTjeGrc5i4GMpo8P7YU2B1SFhCvRFuza4DyiSILG
   oOPSoo8rFVCZ2ljs7ARl+6WnnCs7NAfjH9pxnZgy7uUeYAtvFS+pVmu1Z
   vAuIBrGtqL/yosq3DxyK8Ov0OEeZnr/UZyJCLt8v+RAGi1zsMickNp+Mj
   vYPRG445515tOdO7djvqm4cy3DX7f0fLqcUoPJdK3LTu2fUbkCUUDFDVW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="15106376"
X-IronPort-AV: E=Sophos;i="6.06,211,1705392000"; 
   d="scan'208";a="15106376"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 01:22:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,211,1705392000"; 
   d="scan'208";a="10478874"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.239.60]) ([10.124.239.60])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 01:22:11 -0800
Message-ID: <b0eb5d58-efbd-4f4a-98d6-d470b242c238@linux.intel.com>
Date: Thu, 7 Mar 2024 17:22:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 0/4] x86/pmu: PEBS fixes and new testcases
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>,
 Mingwei Zhang <mizhang@google.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Zhang Xiong <xiong.y.zhang@intel.com>, Lv Zhiyuan <zhiyuan.lv@intel.com>,
 Dapeng Mi <dapeng1.mi@intel.com>
References: <20240306230153.786365-1-seanjc@google.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20240306230153.786365-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 3/7/2024 7:01 AM, Sean Christopherson wrote:
> One bug fix where pmu_pebs attempts to enable PEBS for fixed counter on
> CPUs without Extended PEBS, and two new testcases to verify adaptive
> PEBS functionality.
>
> The new testcases are intended both to demonstrate that adaptive PEBS
> virtualization is currently broken, and to serve as a gatekeeper for
> re-enabling adapative PEBS in the future.
>
> https://lore.kernel.org/all/ZeepGjHCeSfadANM@google.com
>
> Sean Christopherson (4):
>    x86/pmu: Enable PEBS on fixed counters iff baseline PEBS is support
>    x86/pmu: Iterate over adaptive PEBS flag combinations
>    x86/pmu: Test adaptive PEBS without any adaptive counters
>    x86/pmu: Add a PEBS test to verify the host LBRs aren't leaked to the
>      guest
>
>   lib/x86/pmu.h  |   6 ++-
>   x86/pmu_pebs.c | 109 +++++++++++++++++++++++++++----------------------
>   2 files changed, 66 insertions(+), 49 deletions(-)

Tested-by: Dapeng Mi <dapeng1.mi@linux.intel.com>

>
> base-commit: 55dd01b4f066577b49f03fb7146723c4a65822c4

