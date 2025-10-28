Return-Path: <kvm+bounces-61279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8639BC136AB
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 09:01:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF12D198102A
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 08:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57DD32D6E72;
	Tue, 28 Oct 2025 08:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zd5Wwnkz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B090819A2A3
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 08:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761638456; cv=none; b=ZNdOfD1WGIA2PUx4DRsht0lS4Iks6RQV8uLkbKShn/BG45UDxq5HujEOMHpVun3utr+G3WYi7Dw+bc7QzFK5RyZGDUmch46Pc8LtL42zYlIpohNqk+kvGsTx6sYWh91k0R9kBcyyk87iakno9hNx8/geVim2not87n5lCj5Vpro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761638456; c=relaxed/simple;
	bh=mcvEmhn/P4spbjgCX+JlikJJscb2AAuVknhLRFXGybU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KZiMNnzM5d1YU82TePsMMSuWD6WspH/spVzQx9WaVjdk0EszZmGUAi1J1D4MJmixU45knrrdEotIfOpL96dapHwKkFILIw5BeUHUtKMIWrPOYcBy/MfUqAd/ckpojxTO2gTCX1AJ09l4UxyjhzZIudWKHw//dfUbyz3Wz5aVMVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zd5Wwnkz; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761638455; x=1793174455;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mcvEmhn/P4spbjgCX+JlikJJscb2AAuVknhLRFXGybU=;
  b=Zd5Wwnkz7OZD44zF7SP8l7n19j2aCBzsFDySCHzOyH2btHOSVLHbE9CN
   PzYe5z0G5WaZeNN+gdJ4St/j/2lrrZuoiAEPrpWcZKPL2juZXPmWH474R
   YMSzAt8Mes3oPoSp1vy7ar0cdjluB8qcx20RwB26CsUVSU9OGSuVgILrS
   j0XX6wGlaX68sE6oSJipk9n5gTUswSKUpKk14/jtuWJ5DmIz3hxWdHhcA
   D/HRqzj4sDiBwc5plOcIdI6ZBkQbxgUzXbTBpZBdXsMhNAQc0zOBOBVxw
   ghXRXc7DzxUItZrFjNhZVSU0zjl+B0K1U87y2mY2jMG0ZiXpCPzAFDpDi
   w==;
X-CSE-ConnectionGUID: tXpRucYgRXybvnKQ0UU5Wg==
X-CSE-MsgGUID: eP+GcdAESQ+P+UB1gVnbsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63638485"
X-IronPort-AV: E=Sophos;i="6.19,260,1754982000"; 
   d="scan'208";a="63638485"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 01:00:54 -0700
X-CSE-ConnectionGUID: B/68hYG5QZiIHd3AJpjCNA==
X-CSE-MsgGUID: XsKYzkRSS0iy40nLviEy1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,260,1754982000"; 
   d="scan'208";a="189333690"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 01:00:50 -0700
Message-ID: <d6ef9ff0-ba22-4cbc-8fef-2c4378dc32af@intel.com>
Date: Tue, 28 Oct 2025 16:00:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/20] i386/cpu: Enable xsave support for CET states
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, Chao Gao
 <chao.gao@intel.com>, John Allen <john.allen@amd.com>,
 Babu Moger <babu.moger@amd.com>, Mathias Krause <minipli@grsecurity.net>,
 Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, Farrah Chen <farrah.chen@intel.com>,
 Yang Weijiang <weijiang.yang@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-12-zhao1.liu@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20251024065632.1448606-12-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/2025 2:56 PM, Zhao Liu wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Add CET_U/S bits in xstate area and report support in xstate
> feature mask.
> MSR_XSS[bit 11] corresponds to CET user mode states.
> MSR_XSS[bit 12] corresponds to CET supervisor mode states.
> 
> CET Shadow Stack(SHSTK) and Indirect Branch Tracking(IBT) features
> are enumerated via CPUID.(EAX=07H,ECX=0H):ECX[7] and EDX[20]
> respectively, two features share the same state bits in XSS, so
> if either of the features is enabled, set CET_U and CET_S bits
> together.
> 
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Co-developed-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>


