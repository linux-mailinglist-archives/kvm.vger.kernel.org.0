Return-Path: <kvm+bounces-30267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BEFD9B86CD
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 00:14:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10894281AA5
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 23:14:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAE5A1D0E0D;
	Thu, 31 Oct 2024 23:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j7T+fE8k"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF521E1A23;
	Thu, 31 Oct 2024 23:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416424; cv=none; b=qBMkqSFSSCcxKftDYa72y6s0KhWqh6YjJnWOzS2bjtw7geBBS8Md5LRzE3A5BM+jTZMjoBIfbXgNrkdyfP8Jbsslpf2ldQ3nAwro2boYzUQLQcOx4q05VOKzsSOpIJc5GRFcPlzoePzF5Ch+7gyMQKiXt14/i25VMwBLEr9YW8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416424; c=relaxed/simple;
	bh=PK+1p6s/avx7imwFKci0SiByVtzGXBl6H2kZeOjRglg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tFwDeGelq2mnv8+60We9z/0yeBdmXYgHuIM/+rNKmbUa2VRWUMVAB4AidFhRkRmqV2fKIThG2E+nykFuFdTbhOl77m/WzYgPHedvstqSVt+qLn1cgqV1g2k7XqhxAPC1Bx5Vt1LU3YESph/iP7aMC35HlNXtSx7KMhdOEsgiUm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j7T+fE8k; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730416420; x=1761952420;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PK+1p6s/avx7imwFKci0SiByVtzGXBl6H2kZeOjRglg=;
  b=j7T+fE8k5tZCe6gY3URZfAh09D27OoDUoroE80RYDp1YDg/Lcuymy3fN
   ZS4+r+0H5MhIAU8aotMe4KaAHQEXzrJOmubefWTmBUZT+O/M2CJZvBmO9
   hR7wAOWVAK4fd9BNNsTfIn/cjwaf229BQTk1ebpk4NB1FH38HScqSGBtu
   WQeef3ExHMvMd2NkyZ9S6UiOeW71R4u8RHP73d6YflBsqZwzPUgt7z51I
   4YMWWeIiMyQB4l/nUH4/zOW3WwY++LBQM/RFKDirDR0wFs/CXHgvmz7vT
   /nW38tjRQgnhVHPircCdth46Vk3j7zP0eF2FvKnk1qkfx8OaUJXSC7rK8
   g==;
X-CSE-ConnectionGUID: VWAZsNVpSgO+LsR9+fLpLw==
X-CSE-MsgGUID: epF5WaEYRnqyjJcADlfHRQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11242"; a="34115017"
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="34115017"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 16:13:38 -0700
X-CSE-ConnectionGUID: Od6sHebZR8iOh+dngIWUSA==
X-CSE-MsgGUID: 5mo4JC8tQGeruZYHg5dlqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="87604745"
Received: from adande-mobl.amr.corp.intel.com (HELO desk) ([10.125.145.235])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 16:13:38 -0700
Date: Thu, 31 Oct 2024 16:13:32 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Amit Shah <amit@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
	linux-doc@vger.kernel.org, amit.shah@amd.com,
	thomas.lendacky@amd.com, bp@alien8.de, tglx@linutronix.de,
	peterz@infradead.org, jpoimboe@kernel.org, corbet@lwn.net,
	mingo@redhat.com, dave.hansen@linux.intel.com, hpa@zytor.com,
	seanjc@google.com, pbonzini@redhat.com,
	daniel.sneddon@linux.intel.com, kai.huang@intel.com,
	sandipan.das@amd.com, boris.ostrovsky@oracle.com,
	Babu.Moger@amd.com, david.kaplan@amd.com
Subject: Re: [PATCH 2/2] x86: kvm: svm: add support for ERAPS and
 FLUSH_RAP_ON_VMRUN
Message-ID: <20241031231332.tdfbjcesjnkq435k@desk>
References: <20241031153925.36216-1-amit@kernel.org>
 <20241031153925.36216-3-amit@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031153925.36216-3-amit@kernel.org>

On Thu, Oct 31, 2024 at 04:39:25PM +0100, Amit Shah wrote:
> @@ -3559,6 +3582,27 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  
>  		trace_kvm_nested_vmexit(vcpu, KVM_ISA_SVM);
>  
> +		if (boot_cpu_has(X86_FEATURE_ERAPS)
> +		    && vmcb_is_larger_rap(svm->vmcb01.ptr)) {
		    ^
		    This should be at the end of previous line.

