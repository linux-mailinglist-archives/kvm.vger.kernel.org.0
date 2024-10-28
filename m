Return-Path: <kvm+bounces-29799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B3F589B2384
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 04:25:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5FF3A1F210C0
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 03:25:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59567188A08;
	Mon, 28 Oct 2024 03:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cm6jjtrM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3DF186616
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 03:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730085894; cv=none; b=FkvHsu0ebEyzfy3u48gn2F+MAR3OsOLDXTa/YhnuUTjT3DBmZw9p1qoOQpgaPJy2cT+uWS3oOVzG2Tk1o1LZl5JHVt4ukZnK+SfLcjNraRdRwX/eNmXlyCTW4CV0FyA6dqyNQWU4IWOknXmj8akpLaHqCiu02qKBuynr/ACv1HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730085894; c=relaxed/simple;
	bh=+DoVMk67zblu+b37B6E5uAiS+mO4TLNtp2kdYeUmHEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CdjPsSpDVBfZKbTSZdRK5T93CxAHgeo0eB+tpwdN9Vwr6LtzH85LEciZjTSfcjGNBJ2XUG0SyKc7oL4MAeLX0/9v0omuzjJD4rFlUH6U4Ha5qRIWxD/W+KaVYhW7QkOVRL65DDjoqWHIFDMtFvcpowi5xnwA95OweFcuCudolj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cm6jjtrM; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730085893; x=1761621893;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+DoVMk67zblu+b37B6E5uAiS+mO4TLNtp2kdYeUmHEQ=;
  b=Cm6jjtrMuS1lG3Jvhw9e+EzrhgQrSk4c4afRNaA0PTK56u1aomE9Jrlk
   l8K08Ae7ZGh5BB8M18A0jhpVsSxK1UxfDP47QkawCVpNLuEk0JtrwE/gU
   3FNSKM79uTs81Q2RAzsFh67e8taVlRWsTw3GunGjaweoC29tUSHsW4gGf
   UnZObYmXBUnVQkAQl1dqK8JmD321h0NSti/ZiEIZaSuh3c1K25uDrGHtd
   nKFdfPRaolsFwY/XrBV3EKP3KZTnJYws3qnjxha49ytTxSXZNSCZAcnVj
   bm3v9AvSb2XrvIx/HqO+Iq97K1LmTTAWUY3yWk8rqQKdSMvQn4UglCcyZ
   g==;
X-CSE-ConnectionGUID: qt6kP5/fRBmjGwcT3Y/hYQ==
X-CSE-MsgGUID: VKbWRFhwSNKn7RgUL+jj/w==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="52229191"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="52229191"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2024 20:24:52 -0700
X-CSE-ConnectionGUID: 07U5wF8zTbGGMUom7qVg0w==
X-CSE-MsgGUID: oxB4oV3tRLC9uuUPLPfUag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,238,1725346800"; 
   d="scan'208";a="112315117"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 27 Oct 2024 20:24:50 -0700
Date: Mon, 28 Oct 2024 11:41:09 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Babu Moger <babu.moger@amd.com>
Cc: pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 1/7] target/i386: Fix minor typo in NO_NESTED_DATA_BP
 feature bit
Message-ID: <Zx8H1RJTniBeDNvV@intel.com>
References: <cover.1729807947.git.babu.moger@amd.com>
 <a6749acd125670d3930f4ca31736a91b1d965f2f.1729807947.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6749acd125670d3930f4ca31736a91b1d965f2f.1729807947.git.babu.moger@amd.com>

On Thu, Oct 24, 2024 at 05:18:19PM -0500, Babu Moger wrote:
> Date: Thu, 24 Oct 2024 17:18:19 -0500
> From: Babu Moger <babu.moger@amd.com>
> Subject: [PATCH v3 1/7] target/i386: Fix minor typo in NO_NESTED_DATA_BP
>  feature bit
> X-Mailer: git-send-email 2.34.1
> 
> Rename CPUID_8000_0021_EAX_No_NESTED_DATA_BP to
>        CPUID_8000_0021_EAX_NO_NESTED_DATA_BP.
> 
> No functional change intended.
> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
> v3: New patch.
> ---
>  target/i386/cpu.c | 2 +-
>  target/i386/cpu.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


