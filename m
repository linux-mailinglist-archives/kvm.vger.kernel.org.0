Return-Path: <kvm+bounces-19553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01FF7906482
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 08:56:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1F8D6B209DB
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 06:56:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48CB7137C24;
	Thu, 13 Jun 2024 06:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fOh11rD1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D278137924
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 06:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718261782; cv=none; b=ctm3pJxotmepfKD4BsSBoLDr1Z7z5TpX7hh8dLWEL5hFTU3NaPGOaeHby59/XoxfBl8U8c05xaX1JyZ9f1vPv99DZZzs9z8+Eoq3CVGTElyba1vkBMkPx7yHWRNNc+7nVnlyDxSdGpUP+LiCKHFAb/5/uTrzFLgwg5LwiJFroQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718261782; c=relaxed/simple;
	bh=aCam3PViCpM8DdraXfcSgE9gy+VAs4Jbi/oYNCofGWI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aNfYyuCGMHzb8NAmv6sKeUnjBvLm6sF64q16yIXdzrApruy0vVdsT4btI9yzolBiADqrGe8Kshu+0VqlcHnY9H7DaEgm0KeAosmPtgamqOmOcjvHvgzTIJvQ9OChLKdipUsYG27lN9fdJT8VV7+Lz1O+w8z9eXXZlS23MYrX21g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fOh11rD1; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718261781; x=1749797781;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aCam3PViCpM8DdraXfcSgE9gy+VAs4Jbi/oYNCofGWI=;
  b=fOh11rD1dw5ux5B2l9tzA2R3Di10fF31wfR1yeHUJPX+wsEnHEJiwEjb
   kFp1P5EcAkhxPds+NRKJTxLDH1zrEl1xnnbnr7cyLj03SuGKm7EEZXJ6o
   3mpdqqZ0qUEkTrl+97/NC1Af0NrCqXC1nyTBkujISEuQLRF852kBHv+sk
   P2hlH5/Jcm9gL3G/rJ/NtWumAXVAWxz5kLwDf949ZHcjPB1MmY7YjEGo1
   UW7PAHt49fBk6ZPSUOvy0J4HHEpHwOm1Wt/IfgBiMm7444YQHAA6gigwL
   EEMPx8U6pwTBfLLUzlmaB5nudWt/UOtlfOnbh8CybkNEkgeQKRj/k93gW
   A==;
X-CSE-ConnectionGUID: FZiGjESgQCOY9zqAZyGnAw==
X-CSE-MsgGUID: CTmIrrunRFutc1yhGcMpxg==
X-IronPort-AV: E=McAfee;i="6700,10204,11101"; a="15214404"
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="15214404"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 23:56:20 -0700
X-CSE-ConnectionGUID: fNLFrMJhTzC1k/HYhUz84g==
X-CSE-MsgGUID: ydyVExa1TXaD/U4j79RDKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="39902419"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa007.fm.intel.com with ESMTP; 12 Jun 2024 23:56:18 -0700
Date: Thu, 13 Jun 2024 15:11:48 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Babu Moger <babu.moger@amd.com>
Cc: pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH 3/4] i386/cpu: Enable perfmon-v2 and RAS feature bits on
 EPYC-Genoa
Message-ID: <ZmqbtLToD1ac7VO+@intel.com>
References: <cover.1718218999.git.babu.moger@amd.com>
 <1dc29da3f04b4639a3f0b36d0e97d391da9802a0.1718218999.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1dc29da3f04b4639a3f0b36d0e97d391da9802a0.1718218999.git.babu.moger@amd.com>

On Wed, Jun 12, 2024 at 02:12:19PM -0500, Babu Moger wrote:
> Date: Wed, 12 Jun 2024 14:12:19 -0500
> From: Babu Moger <babu.moger@amd.com>
> Subject: [PATCH 3/4] i386/cpu: Enable perfmon-v2 and RAS feature bits on
>  EPYC-Genoa
> X-Mailer: git-send-email 2.34.1
> 
> Following feature bits are added on EPYC-Genoa-v2 model.
> 
> perfmon-v2: Allows guests to make use of the PerfMonV2 features.

nit s/Allows/Allow/

> SUCCOR: Software uncorrectable error containment and recovery capability.
>             The processor supports software containment of uncorrectable errors
>             through context synchronizing data poisoning and deferred error
>             interrupts.
> 
> McaOverflowRecov: MCA overflow recovery support.
> 
> The feature details are available in APM listed below [1].
> [1] AMD64 Architecture Programmer's Manual Volume 2: System Programming
> Publication # 24593 Revision 3.41.
> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
> ---
>  target/i386/cpu.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


