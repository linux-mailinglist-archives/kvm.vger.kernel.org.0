Return-Path: <kvm+bounces-61485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 233B6C20E08
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 16:18:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EAE763B786E
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 15:18:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 841FF36334B;
	Thu, 30 Oct 2025 15:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m01p9yUP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4B0157A72
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 15:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761837496; cv=none; b=VifcHg4b+A2kiMNkr5w4gQFGlHdBDGK6Y5Cl0RWU2GACMJ68ir8kxWkUTkYB5lSm4dj3df4Gc/UusnG2P4VbGnIt0JWwYg6Bb48P6s0Ing/vSJjuhIrtgy50PA4itceRcH9e1H4cQFWTZ+7sbQ9upRDT+505IvivLV0t4hvWF0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761837496; c=relaxed/simple;
	bh=VduxXOP15hvnXVLVHD1DZz+vUQBwNvjKz8GA04d6gnA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W5XWGri5SuqG7olfjMfPHbdNz8iU0PsuauhECwIan3n8xWmWKJvX3vneq54pF5hhS1WkLN7sx5CTg0UChfE3jFJlhWasiwfFGqH/jZsQzrizZkOFU27hrryuHLCWa3/D4v6oZXvmMnPWSVlo12bnC1ZZoLs1cFpp8F1U+DvAKfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m01p9yUP; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761837495; x=1793373495;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VduxXOP15hvnXVLVHD1DZz+vUQBwNvjKz8GA04d6gnA=;
  b=m01p9yUP5evpNODAf+WkgymwnL/FbAgD6ILIh9ES9rtTp8+3pqWjPx4l
   u0ExD+I2iOSMe9WOJtAegVxSfJ3tIcvd92qKGEgdgQI/9Mgd6EYVqO80W
   D8L6NzjGwEmMeL+98WJq4d7pNHlHRaMf0C3K5IAE0ysbzJQSYNOAKGSlC
   q7/GVJndmae/IAKwB4Me5GVI5tsn5qrQvZBA99BBXoGgGz0FlYMqUZina
   4Y4KcnYznXRwabY90KhIE5Xcqsj+P1ON0haC6G3qe7Sjhh9eAWGmpZ6dv
   3mYUCy87NfndPaiGmqBbZygNa1XPhZQ3P9g4VnXWYZFBYBeoBuAciLpKj
   Q==;
X-CSE-ConnectionGUID: 1DCQJluqRrqx61FenKWhsQ==
X-CSE-MsgGUID: NxzoOW6YR1y++wCWN2LtjA==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="64023817"
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="64023817"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 08:18:09 -0700
X-CSE-ConnectionGUID: BKpDafh+SFqWINZpG9uYXQ==
X-CSE-MsgGUID: fHZzOJB/SU2rlTrR2rLt/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="185862013"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa006.fm.intel.com with ESMTP; 30 Oct 2025 08:18:04 -0700
Date: Thu, 30 Oct 2025 23:40:16 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
	John Allen <john.allen@amd.com>, Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>
Subject: Re: [PATCH v3 07/20] i386/cpu: Reorganize dependency check for arch
 lbr state
Message-ID: <aQOG4O37f/hY9+iN@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-8-zhao1.liu@intel.com>
 <d34f682a-c6c0-4609-96e8-2a0b76585c7d@intel.com>
 <aP9FfUKoP2azthS8@intel.com>
 <b70c5b82-815b-4c4d-a1c6-f3f011d951f9@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b70c5b82-815b-4c4d-a1c6-f3f011d951f9@intel.com>

> Before this patch, if pmu is enabled and ARCH_LBR is configured, the leaf
> (0xd, 0xf) is constructed by
> 
> 	x86_cpu_get_supported_cpuid()
> 
> after this patch, it's constructed to
> 
> 	*eax = esa->size;
> 	*ebx = 0;
>         *ecx = 1;

Ah, there should be another 2 cases which need refactor/cleanup:
 * fill all registers with info from x86_ext_save_areas
 * fill info of x86_ext_save_areas from x86_cpu_get_supported_cpuid()

Regards,
Zhao


