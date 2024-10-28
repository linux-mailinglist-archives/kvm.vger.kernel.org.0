Return-Path: <kvm+bounces-29820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 311419B26D5
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 07:43:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB129282548
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 06:43:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F4D618E743;
	Mon, 28 Oct 2024 06:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X7Dc4T3q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D8318E37C
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 06:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097782; cv=none; b=sqA/WiF+zY5n8W8hQH2TJ51wpNV4w3TDwVEexINWu/qyRYIEyVkwa+oSD7mDH6wUP3BGg4Z9kLCN9UagMTXuRqgTyZY9A5+TCBQZnDIhdO7Uwk4i4mOTDkrKvQj8P15O3KbBW3Mn7lQqlNkpCMlfvQXNwlyCKaXb49urcct14Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097782; c=relaxed/simple;
	bh=/ojNyzEvkXc3gjW31rjjvySL+jX2GWb/Xty5DpADLSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tYaKl/NXK7lpAi+XyTZVbDinhgmzK0Crn2RFWFjnZc2HjISbyE4m60gFl3qhkVjFFlajp/M/1Q1m9Ol+CwMSbnnnEGHxMEX1GKU/5A10Kpvh+Y3Rjnv2WD3l83X37mRNymt9KNGGJy4EOPBYEH7uTV9Vh1owFpZov5V8cQd9z2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X7Dc4T3q; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730097781; x=1761633781;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/ojNyzEvkXc3gjW31rjjvySL+jX2GWb/Xty5DpADLSs=;
  b=X7Dc4T3qszp17f+GwUh1nXL2DwGEIc11DHDmmDksimXZ8/GRTNCGDOdt
   eJ4mZYyznribSOVWAlKpacAdYMgeLs9NeYkmwHfuSPe1A7rRqjESCf9WV
   Tza6HuPmxc1yh5qtBI4ug74eqovu87DNEqbDfxnEbyx+fOSZBNJoQSnZC
   ktM9WX3edZIt1oJCOvkD8k5bSfYTyIfc/Kizn72/DXklhp5ne2iGqooHw
   2ijfpspxKmD7EnuT5vA92SiXmtQHGXyQQyoh/Fc2ihHXwLcWsqI4+pMN8
   WWFZYd+VsBTRTMSfsVUbMGI+dkNXwVRkHipfjWvfeByJoQmaihbwLrqy0
   A==;
X-CSE-ConnectionGUID: 1Q0EaZHEQZeomQ7lR0Uzkw==
X-CSE-MsgGUID: TUyCQ8Q+SS69qa3qLbB1+g==
X-IronPort-AV: E=McAfee;i="6700,10204,11238"; a="40303042"
X-IronPort-AV: E=Sophos;i="6.11,238,1725346800"; 
   d="scan'208";a="40303042"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2024 23:43:00 -0700
X-CSE-ConnectionGUID: iH8c8OTIT/ObRXKruBliKw==
X-CSE-MsgGUID: t2yVzOgIQLm5dVqtEjvFKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,238,1725346800"; 
   d="scan'208";a="104850200"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa002.fm.intel.com with ESMTP; 27 Oct 2024 23:42:58 -0700
Date: Mon, 28 Oct 2024 14:59:17 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Babu Moger <babu.moger@amd.com>
Cc: pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org,
	John Allen <john.allen@amd.com>
Subject: Re: [PATCH v3 2/7] target/i386: Add RAS feature bits on EPYC CPU
 models
Message-ID: <Zx82ReAE9h7bLSNN@intel.com>
References: <cover.1729807947.git.babu.moger@amd.com>
 <63d01f172cabd5a7741434fb923ed7e1447776ee.1729807947.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63d01f172cabd5a7741434fb923ed7e1447776ee.1729807947.git.babu.moger@amd.com>

(+John)

Hi Babu,

This patch is fine for me.

However, users recently reported an issue with SUCCOR support on AMD
hosts: https://gitlab.com/qemu-project/qemu/-/issues/2571.

Could you please double check and clarify that issue on AMD host?

Thanks,
Zhao

On Thu, Oct 24, 2024 at 05:18:20PM -0500, Babu Moger wrote:
> Date: Thu, 24 Oct 2024 17:18:20 -0500
> From: Babu Moger <babu.moger@amd.com>
> Subject: [PATCH v3 2/7] target/i386: Add RAS feature bits on EPYC CPU models
> X-Mailer: git-send-email 2.34.1
> 
> Add the support for following RAS features bits on AMD guests.
> 
> SUCCOR: Software uncorrectable error containment and recovery capability.
> 	The processor supports software containment of uncorrectable errors
> 	through context synchronizing data poisoning and deferred error
> 	interrupts.
> 
> McaOverflowRecov: MCA overflow recovery support.
> 
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
> v3: No changes
> 
> v2: Added reviewed by from Zhao.
> ---
>  target/i386/cpu.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)


