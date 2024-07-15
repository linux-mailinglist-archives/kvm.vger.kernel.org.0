Return-Path: <kvm+bounces-21622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E4FA2930DB4
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 07:49:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E9DA1F21444
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 05:49:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D828A13B59B;
	Mon, 15 Jul 2024 05:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MpNYBvMg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DE8291E
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 05:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721022562; cv=none; b=mTpUB9Jet8V93LEpi3K7Yj9njoCxDTe+LybN7QBcMOn6cBHctwOSsvzuJMQ/pGQzeRwUUe1lfOn9+l/YMxp5ek5Sc/uHkJLoj5wMTLV1pl443HTxjJAorBAHg+kMFMF9mJFdlPPcQhhKAz4e8ATdLizAGT2b83sledwJcd0aGVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721022562; c=relaxed/simple;
	bh=xbqOul9NFiUKSoKUSxngJIUaRVgmU5rQRWdu6rBdgNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LkOVDh47mm3HEmXuGRIs8IehpRw2WcNT0YLHAvlwpdO0FANbRZaYgpc1dX4FodylZsMjxq+phsJeV64dZIWreF4Fkz54qWyzAcv/Qv0kK1qCkEFJTeSrAdO/kzCmz3fZMwi4TpjmjMWWYP9/Qj8rg+wnIBFLQ1C7mLc1MTznYxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MpNYBvMg; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721022560; x=1752558560;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=xbqOul9NFiUKSoKUSxngJIUaRVgmU5rQRWdu6rBdgNw=;
  b=MpNYBvMgmuZfD7VKtwoc7Xq6haj1b/QZFXoqpJV5nBFRoeNbehVCOhuX
   GRtcYTYIVd3LM9nJZ8NubkJgCTciPeBtMKg3cQHvuaLAAq8U9O05dFxJe
   ZEGpK9PngDw5TffwUwaKsRCLe2NPQVyfbOWGlHzUGzUh+NNoyQADPkhT3
   bOs2TD0mYl78JJZf7IMzTi1JibkzXhbycHyEf028DJOS9usxs0hzmhtr1
   1S2zUxdyZS8o8QEwu21juV5vvq6qc0nxgFVIkIjpkENT5GOnNipARJAA0
   f/kbOZ3GVSBuG6fjBClSdvcUzDnKwtltxQT16AuBo2VU54Van+JxaWMLN
   g==;
X-CSE-ConnectionGUID: I21cURS3TEqabxdmTMt8Lw==
X-CSE-MsgGUID: Qcvd70R8QbeoTNenZ5aXwQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11133"; a="29778245"
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="29778245"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2024 22:49:20 -0700
X-CSE-ConnectionGUID: R6pCJrDmTW6QaFs0COT3gA==
X-CSE-MsgGUID: Du5+YzzCQv2m4rCbtzEpaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="53880811"
Received: from linux.bj.intel.com ([10.238.157.71])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2024 22:49:18 -0700
Date: Mon, 15 Jul 2024 13:44:19 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
	xiaoyao.li@intel.com
Subject: Re: [PATCH v2] KVM: x86: Advertise AVX10.1 CPUID to userspace
Message-ID: <ZpS3M6zbyR1wPVQR@linux.bj.intel.com>
References: <20240603064002.266116-1-tao1.su@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240603064002.266116-1-tao1.su@linux.intel.com>

On Mon, Jun 03, 2024 at 02:40:02PM +0800, Tao Su wrote:
> Advertise AVX10.1 related CPUIDs, i.e. report AVX10 support bit via
> CPUID.(EAX=07H, ECX=01H):EDX[bit 19] and new CPUID leaf 0x24H so that
> guest OS and applications can query the AVX10.1 CPUIDs directly. Intel
> AVX10 represents the first major new vector ISA since the introduction of
> Intel AVX512, which will establish a common, converged vector instruction
> set across all Intel architectures[1].
> 
> AVX10.1 is an early version of AVX10, that enumerates the Intel AVX512
> instruction set at 128, 256, and 512 bits which is enabled on
> Granite Rapids. I.e., AVX10.1 is only a new CPUID enumeration with no
> VMX capability, Embedded rounding and Suppress All Exceptions (SAE),
> which will be introduced in AVX10.2.
> 
> Advertising AVX10.1 is safe because kernel doesn't enable AVX10.1 which is
> on KVM-only leaf now, just the CPUID checking is changed when using AVX512
> related instructions, e.g. if using one AVX512 instruction needs to check
> (AVX512 AND AVX512DQ), it can check ((AVX512 AND AVX512DQ) OR AVX10.1)
> after checking XCR0[7:5].
> 
> The versions of AVX10 are expected to be inclusive, e.g. version N+1 is
> a superset of version N. Per the spec, the version can never be 0, just
> advertise AVX10.1 if it's supported in hardware.
> 
> As more and more AVX related CPUIDs are added (it would have resulted in
> around 40-50 CPUID flags when developing AVX10), the versioning approach
> is introduced. But incrementing version numbers are bad for virtualization.
> E.g. if AVX10.2 has a feature that shouldn't be enumerated to guests for
> whatever reason, then KVM can't enumerate any "later" features either,
> because the only way to hide the problematic AVX10.2 feature is to set the
> version to AVX10.1 or lower[2]. But most AVX features are just passed
> through and don’t have virtualization controls, so AVX10 should not be
> problematic in practice.
> 
> [1] https://cdrdv2.intel.com/v1/dl/getContent/784267
> [2] https://lore.kernel.org/all/Zkz5Ak0PQlAN8DxK@google.com/
> 

Hi Sean, do you have any suggestions for this patch? Thanks!

