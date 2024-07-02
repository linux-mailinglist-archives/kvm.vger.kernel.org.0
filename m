Return-Path: <kvm+bounces-20818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1271B91ED50
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 05:07:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AA1861F22F99
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 03:07:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27866199BC;
	Tue,  2 Jul 2024 03:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z2GKVOtv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C0F15E8C
	for <kvm@vger.kernel.org>; Tue,  2 Jul 2024 03:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719889647; cv=none; b=n6A6WXcWCvmXknj3QnWxgzxEN9PPq47rYf8ok0DJj8RYOsxhdlYr0/GS7H+AbqK1/x2hWoo7BNb5eGI+YUQDmbfUafZGuNdGsxLn7HY4nSSpjnm610FaFQDiFXqMVGyc0/AdvMdxeEZ/9yC9ra6tdtZrM08MPa9kU8Eq3ZGktFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719889647; c=relaxed/simple;
	bh=m1TOvZROTBz/LcdC1Wgh7F6ey+p+v19zzSHQdL7htbE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cmUSKvptua0aZgbeiNaqtD7/mBbWQqUgofYgqKVO6sx8oQ0S58GdQsRqIN8BSdjCef0eY+W2kw0cH7nM4kz0rg4T3zZwh881jtbvBaoqvYAoNANh9ODKtWqwHkYN78db5/HFP/+uwCnmo8yDd7oeY3VIZvDatEE48WaYrK5sXw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z2GKVOtv; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719889645; x=1751425645;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=m1TOvZROTBz/LcdC1Wgh7F6ey+p+v19zzSHQdL7htbE=;
  b=Z2GKVOtvZcvNkijDERD95w/KdamokT2kNoqPfVcvI7yNUE/GGQJFY2EM
   pcYEjCo2tVQgOvxNt/HV7ZMWTQNg3VNzNxt9NAotY2DDF7QnZS+I31WV3
   P+84X2vfMlNRX8m8zzA2LTVBnn8GyO9bPmOICEgIuJOja3acMM9OkwnVY
   tE37vaweIdnyYV4tFTUKol7EXyLZHXnwhy5lLmZ+CI+tlE47akGLI6VEe
   9plOJadCqhxC8ESyMSsvm8aUi4W8MzxmX6TaUymnXLbbopS/Cpx6r+0WL
   YxtUEGmr7+0378ydNsgCFNItii2ROeeKY8vYjCTMHoTeY0VcfdCjXeJN5
   A==;
X-CSE-ConnectionGUID: tRZeOrbLSC2DTeamy6eX2g==
X-CSE-MsgGUID: E5xABAyDReCWWkQ5oW2aTw==
X-IronPort-AV: E=McAfee;i="6700,10204,11120"; a="17182588"
X-IronPort-AV: E=Sophos;i="6.09,178,1716274800"; 
   d="scan'208";a="17182588"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2024 20:07:25 -0700
X-CSE-ConnectionGUID: qGt3Wjr4STqlbzg6bBTehA==
X-CSE-MsgGUID: rutYRsDMRH6/Xxlkw3KM1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,178,1716274800"; 
   d="scan'208";a="45708043"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.26]) ([10.124.240.26])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2024 20:07:21 -0700
Message-ID: <ce80850a-fbd1-4e14-8107-47c7423fa204@intel.com>
Date: Tue, 2 Jul 2024 11:07:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 20/31] i386/sev: Add support for SNP CPUID validation
To: Pankaj Gupta <pankaj.gupta@amd.com>, qemu-devel@nongnu.org
Cc: brijesh.singh@amd.com, dovmurik@linux.ibm.com, armbru@redhat.com,
 michael.roth@amd.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
 isaku.yamahata@intel.com, berrange@redhat.com, kvm@vger.kernel.org,
 anisinha@redhat.com
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
 <20240530111643.1091816-21-pankaj.gupta@amd.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240530111643.1091816-21-pankaj.gupta@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/2024 7:16 PM, Pankaj Gupta wrote:
> From: Michael Roth <michael.roth@amd.com>
> 
> SEV-SNP firmware allows a special guest page to be populated with a
> table of guest CPUID values so that they can be validated through
> firmware before being loaded into encrypted guest memory where they can
> be used in place of hypervisor-provided values[1].
> 
> As part of SEV-SNP guest initialization, use this interface to validate
> the CPUID entries reported by KVM_GET_CPUID2 prior to initial guest
> start and populate the CPUID page reserved by OVMF with the resulting
> encrypted data.

How is KVM CPUIDs (leaf 0x40000001) validated?

I suppose not all KVM_FEATURE_XXX are supported for SNP guest. And SNP 
firmware doesn't validate such CPUID range. So how does them get validated?

> [1] SEV SNP Firmware ABI Specification, Rev. 0.8, 8.13.2.6
> 


