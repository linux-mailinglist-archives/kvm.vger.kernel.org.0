Return-Path: <kvm+bounces-38970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B09ABA413D9
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 04:04:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 362353B1F92
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 03:02:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6103619F11F;
	Mon, 24 Feb 2025 03:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a40sF6AQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD35C4400
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 03:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740366176; cv=none; b=Ht8nvsqzhRfAjIQJH+vDnoPLA5ET7AFKnWD++FxgZf5DSNhuiVqCPzcJQLgwrlza82YubqLaDlAymO3jtZMTiXtXcbAFoW+QgWyfrAM62mdpXDgMci1k54Areg7NTTWLEJ99JC22s3h3kbGkFKHkkpxjdesyX0AHPcER9zeuUk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740366176; c=relaxed/simple;
	bh=UNLLIUPfY7DEtqqTqUZRiyk4/ZLTCbe1mAfNZ1pQw/k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GoyIxBLh16sqYM1i0YVHEviZ2HGw7SAJEGdYoXOAjW5cZENtknEYcyXeRayBSZGbIze978c5D3HnZcNjjwPAEpZpKxx1MIBqt07CiuEaFjhDZ2crJ0ol3/I8RPqmxpxqx20b4gmVKApQyjb06sguo+/MWNCE8r7/gkzzvd02C4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a40sF6AQ; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740366175; x=1771902175;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UNLLIUPfY7DEtqqTqUZRiyk4/ZLTCbe1mAfNZ1pQw/k=;
  b=a40sF6AQKAuFiFqvtb0buU5xexUwRDstvyGH4YyV7jUfUfMjZXcPkVzA
   n1Wjns3/7kvsh2cPVPlODWkRJ/QxF9SQz19+nW2lPQ792LexSgZsM/bMc
   IKH0zFFn9ij1gxZ2AsJB1hROYAHKMWfDGgUk2J9jnarX1yJjOXK8kKNmC
   V6ULe9VRi7TOOKRBlHfiI37yupHMJIpUoN6puzq3/FJCcd6fnx0xCVb4W
   /NZYWVGNcSCex+1zQ+MGm77An8jzxPwDUYwa8VbtpSIm3/gJA/ZKPH1qq
   Pdgcv7foOffGkSJUlSfrmE1SyGp47FHgzgDfPuxXCU4Vg2f3uYeFQRm2/
   Q==;
X-CSE-ConnectionGUID: qui5rOu7R3+qPAxxVlUZYA==
X-CSE-MsgGUID: qH19GiWBR/6YVVQlPCPfSg==
X-IronPort-AV: E=McAfee;i="6700,10204,11354"; a="58656951"
X-IronPort-AV: E=Sophos;i="6.13,309,1732608000"; 
   d="scan'208";a="58656951"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2025 19:02:51 -0800
X-CSE-ConnectionGUID: +YKyiCq2SaqhydjnydPrlQ==
X-CSE-MsgGUID: +4e5JLDwSWKyTEVDRRPJEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="153129677"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2025 19:02:50 -0800
Message-ID: <5bca2f3f-d4bb-4a92-84a0-d5cd90da1b9d@intel.com>
Date: Mon, 24 Feb 2025 11:02:47 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH] x86: Drop "enabled" field from "struct
 kvm_vcpu_pv_apf_data"
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
References: <20250221225744.2231975-1-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250221225744.2231975-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/22/2025 6:57 AM, Sean Christopherson wrote:
> Remove the now-defunct (and never used in KVM-Unit-Tests) "enabled" field
> from kvm_vcpu_pv_apf_data.  The field was removed from KVM by commit
> ccb2280ec2f9 ("x86/kvm: Use separate percpu variable to track the enabling
> of asyncpf").
> 
> Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   x86/asyncpf.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/x86/asyncpf.c b/x86/asyncpf.c
> index 6474fede..0e6eb6ff 100644
> --- a/x86/asyncpf.c
> +++ b/x86/asyncpf.c
> @@ -50,7 +50,6 @@ struct kvm_vcpu_pv_apf_data {
>         uint32_t  token;
>   
>         uint8_t  pad[56];
> -      uint32_t  enabled;
>   } apf_reason __attribute__((aligned(64)));
>   
>   char *buf;
> 
> base-commit: f77fb696cfd0e4a5562cdca189be557946bf522f


