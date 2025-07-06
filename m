Return-Path: <kvm+bounces-51630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CFE5CAFA697
	for <lists+kvm@lfdr.de>; Sun,  6 Jul 2025 18:51:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F7B718923B5
	for <lists+kvm@lfdr.de>; Sun,  6 Jul 2025 16:51:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0455E288C30;
	Sun,  6 Jul 2025 16:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bVDC+am/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0703A78F36;
	Sun,  6 Jul 2025 16:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751820690; cv=none; b=gFgkg0tSSYqt6QabYRwfuIJCIVqi/tewlauEvkpb4l8YXpliVTQbDS28V2g9WIUqz0s6HAl9B2ULDFYbw35z5/IVlg0UjSlUoclPgByw6tVt29jfOvoYyTdzODMOay945WVsb4KrH7x5TKQ266fXS/3DDLUPJ+kcKudSykM6V4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751820690; c=relaxed/simple;
	bh=nlEyQhEw16C79uO0evj+Vjv3rpn6lWiDlaXgWwj9gk0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bRaGd9loSYWvKcCMfBr2PEs4Kfs6WPqAToIY2HQiBDTLwps06MgPpAhFl6OXuoSXEuLHCKWSnzAO2ZkQQLkZu+25vO3DZJDvGBVC6fcaCcX8dhxZFhvhcNl5w0zrxP2JHtM29VqDYCkpT8fLtLaStNqae67WQ2UMzKzS6BACqT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bVDC+am/; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751820688; x=1783356688;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nlEyQhEw16C79uO0evj+Vjv3rpn6lWiDlaXgWwj9gk0=;
  b=bVDC+am/KoGnhT6HdkEEkfzan3tS0Am9cLq4g4UQ38JMsWWcZF++gcYD
   frPkVj+jVob4uNRIVeZbqLw+eSd2XRKhS6vuUZHR8MccmtgtA0o8SqTb/
   S40BDNjWTX51ylpv9xcAel4lw2mRRnSfFyTZNDROzkLfAfrNo88dJBUvO
   Fw+17l19msbsUrPWsjK+o+zfz9YASa6GAetE4hvMykt+0TqGzAQQfi4cd
   GRK5sekzWOhIfujz67U522KeJZTYpxll34cuToPXc/H5BkQszGAtampWI
   J0DLUDE3LIAmzRkr83tiKxrdvQzZfU7obH9YVod8n41TAnl0nWuofb8/O
   g==;
X-CSE-ConnectionGUID: CajnHK0qQM+nFdTW7fi0Sw==
X-CSE-MsgGUID: n9HMrGxsQhukRWe1ZN9Oqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11486"; a="65114753"
X-IronPort-AV: E=Sophos;i="6.16,292,1744095600"; 
   d="scan'208";a="65114753"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2025 09:51:27 -0700
X-CSE-ConnectionGUID: cJxF1SzoQUyj4GSjmlQnVw==
X-CSE-MsgGUID: F8wvTVUVSL6IUAGQGoTQbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,292,1744095600"; 
   d="scan'208";a="192205025"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2025 09:51:21 -0700
Message-ID: <88443d81-78ac-45ad-b359-b328b9db5829@intel.com>
Date: Mon, 7 Jul 2025 00:51:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/23] Enable CET Virtualization
To: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org, seanjc@google.com,
 pbonzini@redhat.com, dave.hansen@intel.com
Cc: rick.p.edgecombe@intel.com, mlevitsk@redhat.com, john.allen@amd.com,
 weijiang.yang@intel.com, minipli@grsecurity.net, xin@zytor.com,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>
References: <20250704085027.182163-1-chao.gao@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250704085027.182163-1-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Chao,

On 7/4/2025 4:49 PM, Chao Gao wrote:
> Tests:
> ======================
> This series passed basic CET user shadow stack test and kernel IBT test in L1
> and L2 guest.
> The patch series_has_ impact to existing vmx test cases in KVM-unit-tests,the
> failures have been fixed here[1].
> One new selftest app[2] is introduced for testing CET MSRs accessibilities.
> 
> Note, this series hasn't been tested on AMD platform yet.
> 
> To run user SHSTK test and kernel IBT test in guest, an CET capable platform
> is required, e.g., Sapphire Rapids server, and follow below steps to build
> the binaries:
> 
> 1. Host kernel: Apply this series to mainline kernel (>= v6.6) and build.
> 
> 2. Guest kernel: Pull kernel (>= v6.6), opt-in CONFIG_X86_KERNEL_IBT
> and CONFIG_X86_USER_SHADOW_STACK options. Build with CET enabled gcc versions
> (>= 8.5.0).
> 
> 3. Apply CET QEMU patches[3] before build mainline QEMU.

You forgot to provide the links of [1][2][3].

