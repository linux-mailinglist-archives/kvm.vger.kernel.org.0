Return-Path: <kvm+bounces-25354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D9BC0964668
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 15:26:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0C181B29688
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 13:25:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A2091AAE1A;
	Thu, 29 Aug 2024 13:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ap6/COmG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B442A192B6F;
	Thu, 29 Aug 2024 13:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724937919; cv=none; b=JSZ3U1M9nRuQ6AboPA4zIIvCXiNLFW3cdifwUUF4Ueea263mbzBvbOmY0huC4mzPSJWuq+lgYYZOKDMEIvuVLbB2+4TYB0iUp7lbXm4Cy5Jpxun98LBTHmlEnt3h3/ncp+FHgkey+X+AWw1UwiLnU7g1i5ZIl63ICbfOoRM8cAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724937919; c=relaxed/simple;
	bh=n77bCPZhEhpA7pX7XHjUFUHJCMPAurXbxUj+f9Jyqa4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JG4P5eF/JkBq2j4PJMGYyW4VEYO2fnjCN8N817xGz7qxmMye7UMPnT8gX3Tc1AAb5MpiKWJ1EItKr4FDwd67RWsa4/hdDNekWtRFAjTz4WTQp2uLqcSqWGvSYf+xUG0FHdOYQCqQQvOonsolqUy0tzWOqVgztSVmnSPT9ALqY8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ap6/COmG; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724937918; x=1756473918;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=n77bCPZhEhpA7pX7XHjUFUHJCMPAurXbxUj+f9Jyqa4=;
  b=Ap6/COmG0Vk7rqFXWDN9mrUqEXm/BdBpyJIxOdZqVgHkdopxI2OZ6Bt/
   olfpCRy/Mx+tKXgGulf788nOkWWBU+ZDAohES6OQZfisSnCnW9MWSy0ig
   KxqWazMV2nTT8QLhalfR8VENGCDU0qZdyrFvqT3vsBOR2TAIZstV2dYNP
   rPrz7A1fn1p2wi4GUQe556wP1lXKS+Ousyy3lJQ9cGJGjSM+JEcBh5H+Y
   ryQf+A5YjGWDlByN6Fff1fnP+luYk2TRaxhPCqTOe+PO1lwCT5FgD9hTL
   G34lY4b0k2llqm9+AueI4kNbTAkGHim3dy6tVxzsudn210GsMMrY5Db5f
   w==;
X-CSE-ConnectionGUID: 6kMD3vlqTm6GyU9yFYOVrw==
X-CSE-MsgGUID: EIi7kagJQOii18LAEAsXAQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="34185220"
X-IronPort-AV: E=Sophos;i="6.10,185,1719903600"; 
   d="scan'208";a="34185220"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 06:25:18 -0700
X-CSE-ConnectionGUID: CMR8G9PlQnG+jJscNPSPbg==
X-CSE-MsgGUID: 6p7D2YcFRryMDkc3Pk+Z9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,185,1719903600"; 
   d="scan'208";a="68462912"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.26]) ([10.124.240.26])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 06:25:15 -0700
Message-ID: <4eb4a26e-ebad-478e-9635-93f7fbed103b@intel.com>
Date: Thu, 29 Aug 2024 21:25:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/25] KVM: TDX: Define TDX architectural definitions
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, linux-kernel@vger.kernel.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-3-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240812224820.34826-3-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/2024 6:47 AM, Rick Edgecombe wrote:
> +/*
> + * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is 1024B.
> + */
> +struct td_params {
> +	u64 attributes;
> +	u64 xfam;
> +	u16 max_vcpus;
> +	u8 reserved0[6];
> +
> +	u64 eptp_controls;
> +	u64 exec_controls;

TDX 1.5 renames 'exec_controls' to 'config_flags', maybe we need update 
it to match TDX 1.5 since the minimum supported TDX module of linux 
starts from 1.5.

Besides, TDX 1.5 defines more fields that was reserved in TDX 1.0, but 
most of them are not used by current TDX enabling patches. If we update 
TD_PARAMS to match with TDX 1.5, should we add them as well?

This leads to another topic that defining all the TDX structure in this 
patch seems unfriendly for review. It seems better to put the 
introduction of definition and its user in a single patch.

> +	u16 tsc_frequency;
> +	u8  reserved1[38];
> +
> +	u64 mrconfigid[6];
> +	u64 mrowner[6];
> +	u64 mrownerconfig[6];
> +	u64 reserved2[4];
> +
> +	union {
> +		DECLARE_FLEX_ARRAY(struct tdx_cpuid_value, cpuid_values);
> +		u8 reserved3[768];
> +	};
> +} __packed __aligned(1024);


