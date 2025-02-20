Return-Path: <kvm+bounces-38676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C0DEEA3D8F9
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 12:41:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5ED6D7A4CDC
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 11:40:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8255B1F3FE8;
	Thu, 20 Feb 2025 11:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HGSrEO43"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83081F3D20
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 11:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740051648; cv=none; b=QiJBk4gdv3GTMIR4bZP+v1UKnl1gFtAfknlxHh6xGXJXtmzWZkJII/7A90Pekmz7Crt1tKVi84kdnQvgxYM3R4S3hs94Afb3zs3i/h0ixcVKWS3UbUHOdtg4PEAlV+kqbHMczktU9zn8NHrdYsWCUm9uSueutDNUcdHoH0jRVbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740051648; c=relaxed/simple;
	bh=wvVYXdb28yocyBnfn+6sHaNU/1L9E6JEziRM+W82XE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gBcjBtftyIwc1SfAnna+/VTJuU1W0BpjMDsZXYzqnOz/CdhNYRxyYDyrR+ElrPjydk1Q1Y5UfZ6Ry8pBqk6PpHM1lcg5Ylatblakan0x3vH8vAdim0VNTg10LtsF3GIguNkEuPj+qDtf2rYst/7pssIMb2VRKfMxMkpL7WQHjq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HGSrEO43; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740051647; x=1771587647;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wvVYXdb28yocyBnfn+6sHaNU/1L9E6JEziRM+W82XE0=;
  b=HGSrEO43gzqRRn+Y8+0UfaRV1StCfemBqBgYMLOKfvMYose6w3GqLYRT
   fZOjnKa856KIMUwVQfeA2IXjAM1/8hvVlaYy+HTnwmdqGtThbbFmKS4rj
   dqUajAsH+um5iN/M/am9oQ0VPOI3is1LKkm9UUb0vAUtHe4d3uqkcVJjq
   3PzfflVVCPj9bNR09YfLg7Q+7hAqXasxnax9kTU7MSNSH9cy+4Avg56Eu
   byKGJwLIWqNdGa/PTQUHfN1zcHqEQhT77e8dbMf21SGMhKNYRPiMB6KHA
   l5rNPN57zBJ5L2teBISlDg3FswhCJmEzRDW1mhXjGKwZBhiOMh90nwnnO
   g==;
X-CSE-ConnectionGUID: psSCzTsPTHKPOy4H7glJyQ==
X-CSE-MsgGUID: uES92Ps1Qa+wIR6M5sN+Ww==
X-IronPort-AV: E=McAfee;i="6700,10204,11350"; a="40946499"
X-IronPort-AV: E=Sophos;i="6.13,301,1732608000"; 
   d="scan'208";a="40946499"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 03:40:46 -0800
X-CSE-ConnectionGUID: 6Q9c9oxBQtmES3qrPPeglA==
X-CSE-MsgGUID: TUTSnQ/5T5iVTVK5IwvYwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="115507424"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa007.jf.intel.com with ESMTP; 20 Feb 2025 03:40:45 -0800
Date: Thu, 20 Feb 2025 20:00:20 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Babu Moger <babu.moger@amd.com>
Cc: pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org,
	davydov-max@yandex-team.ru
Subject: Re: [PATCH v5 4/6] target/i386: Add feature that indicates WRMSR to
 BASE reg is non-serializing
Message-ID: <Z7cZVNsZ/PCXA1+7@intel.com>
References: <cover.1738869208.git.babu.moger@amd.com>
 <ad5bf4dde8ab637e9c5c24d7391ad36c7aafd8b7.1738869208.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad5bf4dde8ab637e9c5c24d7391ad36c7aafd8b7.1738869208.git.babu.moger@amd.com>

On Thu, Feb 06, 2025 at 01:28:37PM -0600, Babu Moger wrote:
> Date: Thu, 6 Feb 2025 13:28:37 -0600
> From: Babu Moger <babu.moger@amd.com>
> Subject: [PATCH v5 4/6] target/i386: Add feature that indicates WRMSR to
>  BASE reg is non-serializing
> X-Mailer: git-send-email 2.34.1
> 
> Add the CPUID bit indicates that a WRMSR to MSR_FS_BASE, MSR_GS_BASE, or
> MSR_KERNEL_GS_BASE is non-serializing.
> 
> CPUID_Fn80000021_EAX
> Bit    Feature description
> 1      FsGsKernelGsBaseNonSerializing.
>        WRMSR to FS_BASE, GS_BASE and KernelGSbase are non-serializing.
> 
> Link: https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/programmer-references/57238.zip
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> Reviewed-by: Maksim Davydov <davydov-max@yandex-team.ru>
> ---
>  target/i386/cpu.c | 2 +-
>  target/i386/cpu.h | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


