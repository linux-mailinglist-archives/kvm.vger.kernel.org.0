Return-Path: <kvm+bounces-52578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81601B06DEE
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 08:28:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77628504167
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 06:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2D3D2877D5;
	Wed, 16 Jul 2025 06:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LFbm8Rg9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC3E8634A
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 06:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752647315; cv=none; b=fLillmyY7BN1nKhbUBOT2UZlAxvLgDcO9/ogxFQAg9RTyapeEvStNLkw7icgbbaUcWK3lxEM7Sa27eTV/4V48RxXYqACaZCti3+KEyYz+wY3lp1xEnVme3b2qaj/tQpJCX/Hcsv31FIhHHb1JeLuA6TRAjDApSyqNKBHz9aa+gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752647315; c=relaxed/simple;
	bh=hKKcDyHx6DNwwChFLkdCBJRnzKlBjlTOVCeNq17uiac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BIo05xkG8ZUTIoVXuqlZgivUBcbV5xThRmNJqzIQv0eB2HFv41BkWjjqxx57/8UqCWFSsVBJrq2F7aY2x6MXkj6JBDReysr2ijOzBND38xpe/pmgjmGG90QTdXVp0IZ17bDGWn0C49tERBTyRc0uig5u8py5yE7SKs6k038BHbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LFbm8Rg9; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752647314; x=1784183314;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hKKcDyHx6DNwwChFLkdCBJRnzKlBjlTOVCeNq17uiac=;
  b=LFbm8Rg9LcBnx05cYw+qLaAzpDyXhTca1nmdnT6XyBVHAFhipVPa74c0
   ltVlKwSuAS4DoM7UsKgdW1IDVRUF/2xWMNwPC0ApO8qIG3QlgbtFISaMO
   SKgqYi+4Zu7ZDxm4GVhImhmYFiI8mihyiYi/2pcPalOeXtkGV2hsCVljM
   H4KzwCgZ07L+GsAK56wMUZ6FHHeWhqnjPk/Nt/mDEdmwoH/Y3yrpUJYHC
   Lc9UIDaAP1mCqqsELgjkZd/LmN1i1dqRVWnsJLTeqessAiuFRWemPMT1c
   UxwDUvdySltHMoMdZfLxXLiTw07YOsAU5b5EsyH5q8H73muI72QpDjGJy
   g==;
X-CSE-ConnectionGUID: Jt16A38nQ0uWTwauDsnoOQ==
X-CSE-MsgGUID: 6JE5l6jLRXGuiRcqyqd/bA==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="54819112"
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="54819112"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 23:28:33 -0700
X-CSE-ConnectionGUID: CD8i571HTe+5IMmERv/8xA==
X-CSE-MsgGUID: UcBip278QSC4SC3ckK4zhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="158145109"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 23:28:30 -0700
Message-ID: <74df57ca-a47e-46d8-b0ee-efb03dd774f3@intel.com>
Date: Wed, 16 Jul 2025 14:28:27 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] target/i386: Add TSA feature flag verw-clear
To: Babu Moger <babu.moger@amd.com>, pbonzini@redhat.com,
 zhao1.liu@intel.com, bp@alien8.de
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <12881b2c03fa351316057ddc5f39c011074b4549.1752176771.git.babu.moger@amd.com>
 <e6362672e3a67a9df661a8f46598335a1a2d2754.1752176771.git.babu.moger@amd.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <e6362672e3a67a9df661a8f46598335a1a2d2754.1752176771.git.babu.moger@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/11/2025 3:46 AM, Babu Moger wrote:
> Transient Scheduler Attacks (TSA) are new speculative side channel attacks
> related to the execution timing of instructions under specific
> microarchitectural conditions. In some cases, an attacker may be able to
> use this timing information to infer data from other contexts, resulting in
> information leakage
> 
> CPUID Fn8000_0021 EAX[5] (VERW_CLEAR). If this bit is 1, the memory form of
> the VERW instruction may be used to help mitigate TSA.
> 
> Link: https://www.amd.com/content/dam/amd/en/documents/resources/bulletin/technical-guidance-for-mitigating-transient-scheduler-attacks.pdf
> Co-developed-by: Borislav Petkov (AMD) <bp@alien8.de>
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Signed-off-by: Babu Moger <babu.moger@amd.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

