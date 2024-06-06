Return-Path: <kvm+bounces-18986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45E4B8FDC39
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 03:42:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B7EE5B21A2B
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 01:42:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C46E71401C;
	Thu,  6 Jun 2024 01:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pz2Vyoi1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4FD4C97
	for <kvm@vger.kernel.org>; Thu,  6 Jun 2024 01:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717638130; cv=none; b=uUyze782yAmoFrmoFfkCznIWvtEv8DNN59Qp9JmdU6FB9bX7SaSV2EuiFzHysAWsmBFeEJmv7Hp+lmsy+EJFW9taT9KDmOz7b5J7c1y1kGIP28cEXrGmxJxBB7sqf12Z9DLi6V25spVm7Q2v1rHBFizohTioQ2WgROcvtsPYq9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717638130; c=relaxed/simple;
	bh=BcyZzVD5Do5Vu3PtyEHezDSF2PFCv6ESu97EnZQyjyw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=jgG7g7W3To4uEuFLUb8UJ5z+n3icn7dLJGBhgFlZB663gqFosI9hb16VL0khi9F/feZEnJN2THZPFYfh62qrC9QfuXORau7MbiS3KEXGJZeLJOnUdWMtwmJUmgXyZT6AYwV8zqtsTepmmCTM0JiIG8H31kSPYoDSHQJqgMjFssw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pz2Vyoi1; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717638128; x=1749174128;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=BcyZzVD5Do5Vu3PtyEHezDSF2PFCv6ESu97EnZQyjyw=;
  b=Pz2Vyoi176ebS6LUHcHCGRycWLjv0aL53q81IwR48Kdq14LU3/RzPom5
   yg4ukyoyitRSStMkWfqMJXqwk30g25T4BKaSLt7e07m82qnOnGLIxUXtO
   JfJbgPq7opUwOoNR4PzvVP2yb7DCDcHk0J+yuC/Zhc5hzgNWgC00x68su
   aqxNez9qUg9GLlVTmXWBeZ2P21iGq/Q0v83dHYblbrS29xU292OpbxY0S
   prkeNpgJG/RFLsq6o5HL080l5nT1mslTrBeXZ90RbEG4Ndm2vPyzIS1GY
   A3OfSSzj7KxNxg0Szuy6hnvUNHA691tKo3i8K+SeT/plpHAXAgj3TMrhM
   w==;
X-CSE-ConnectionGUID: raYxdHuOR6ydhOWt2YvM6Q==
X-CSE-MsgGUID: aT80lni7R5SZw+Bq8+sAmA==
X-IronPort-AV: E=McAfee;i="6600,9927,11094"; a="14504057"
X-IronPort-AV: E=Sophos;i="6.08,218,1712646000"; 
   d="scan'208";a="14504057"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2024 18:42:08 -0700
X-CSE-ConnectionGUID: G/zJNXUoR1e9sWc1pCWm7w==
X-CSE-MsgGUID: Hvcpxb14TNK5M0HSK9pKmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,218,1712646000"; 
   d="scan'208";a="37898352"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.247.52]) ([10.125.247.52])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2024 18:42:06 -0700
Message-ID: <d3fd6518-587c-425d-a6a1-a5711215f15d@intel.com>
Date: Thu, 6 Jun 2024 09:42:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3] x86/asyncpf: fix async page fault
 issues
To: Dan Wu <dan1.wu@intel.com>, seanjc@google.com, pbonzini@redhat.com,
 kvm@vger.kernel.org
References: <20240108063014.41117-1-dan1.wu@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240108063014.41117-1-dan1.wu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Sean,

On 1/8/2024 2:30 PM, Dan Wu wrote:
> +struct kvm_vcpu_pv_apf_data {
> +      /* Used for 'page not present' events delivered via #PF */
> +      uint32_t  flags;
> +
> +      /* Used for 'page ready' events delivered via interrupt notification */
> +      uint32_t  token;
> +
> +      uint8_t  pad[56];
> +      uint32_t  enabled;

Cloud you please help cleanup the 'enabled' field when applying? since 
it has been removed.

> +} apf_reason __attribute__((aligned(64)));


