Return-Path: <kvm+bounces-35344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C137A0FE7D
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 03:09:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 477A6169EFC
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 02:09:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F46B230274;
	Tue, 14 Jan 2025 02:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aPWLQlEJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F258493;
	Tue, 14 Jan 2025 02:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736820573; cv=none; b=ATN2uMjQxRgraKHeB+F//ziYJXtKGcLQ1K9S5tLI28wIppVgvHvQRWUVkeiBGS1+rvwdzp6jLAaL/Gn9d9SA+R9E9/b4idW1ucwVoIjNfDuB/oceSeTpKQ924IbdL8tsqTK3LD8CfAi2fd5VwvrneWkjm3S2exzkLrQBAON0C/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736820573; c=relaxed/simple;
	bh=oO1/R7SFlIHQk9AniUs96Nug2M0Xbh4DHekZynyB6HQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RjiVfGWjA3uWLWPFWP16/EBOw2Q6j/R7NaUHHdTvWpYFJv9afROhI35jTVdNVUvegd9kfU0ATHOHZ23VbT+rgKhpBDpF8uoqrkXpzUAHwyH1o9GbfQa6N6Ei4Ky5rDVLkpF0Eml0jhR4duRgCF06DRBEyU5B81VA4nGeK9BP9bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aPWLQlEJ; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736820572; x=1768356572;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oO1/R7SFlIHQk9AniUs96Nug2M0Xbh4DHekZynyB6HQ=;
  b=aPWLQlEJHTNeod2qB8Sxig/7iHlofuNX80o3Uxjg4QyBk6SXHUUYBk2I
   REi9DrOJ7vvewKiJml2nfg6rsvNx4tfsvXU43n6GxFZVJDbWaEam8FOl3
   TpKI31h76yzmqfz8t7KdhrhswklVbuUNdWVspgC601cJE3zgtnX72Zqu9
   jPQvFjvySfYBQeXJ/r5MbXqjpXFzKy/RF+kTjm9psgqZELABCOBHskVxq
   Z9B6mpbTSvlDlIfqX3eQKhjHQFrXhlzTyJz5LY5dzzgQl691iJJ/0uq1C
   kXwahvMHSHepkItabmvrhksBkWj6I4J51gRB31qN8kY6Gatij2GD1bUc9
   g==;
X-CSE-ConnectionGUID: gRL3cPVhSI2B+Qs8A+RSpA==
X-CSE-MsgGUID: 58+gG7+gQvmq9EvhzzHAxA==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="37332606"
X-IronPort-AV: E=Sophos;i="6.12,312,1728975600"; 
   d="scan'208";a="37332606"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2025 18:09:31 -0800
X-CSE-ConnectionGUID: wOI3YoYwRq6b9oAn8o+dFA==
X-CSE-MsgGUID: l/yt1qq6RbaLTL+5TgypnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,312,1728975600"; 
   d="scan'208";a="104481063"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2025 18:09:28 -0800
Message-ID: <34f6f399-c048-46f4-886e-f0d2a18d8bcc@intel.com>
Date: Tue, 14 Jan 2025 10:09:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] KVM: kvm_set_memory_region() cleanups
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tao Su <tao1.su@linux.intel.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>
References: <20250111002022.1230573-1-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250111002022.1230573-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/11/2025 8:20 AM, Sean Christopherson wrote:
> Cleanups related to kvm_set_memory_region(), salvaged from similar patches
> that were flying around when we were sorting out KVM_SET_USER_MEMORY_REGION2.
> 
> And, hopefully, the KVM-internal memslots hardening will also be useful for
> s390's ucontrol stuff (https://lore.kernel.org/all/Z4FJNJ3UND8LSJZz@google.com).

For the series:

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> v2:
>   - Keep check_memory_region_flags() where it is. [Xiaoyao]
>   - Rework the changelog for the last patch to account for the change in
>     motiviation.
>   - Fix double spaces goofs. [Tao]
>   - Add a lockdep assertion in the x86 code, too. [Tao]
> 
> v1: https://lore.kernel.org/all/20240802205003.353672-1-seanjc@google.com
> 
> Sean Christopherson (5):
>    KVM: Open code kvm_set_memory_region() into its sole caller (ioctl()
>      API)
>    KVM: Assert slots_lock is held when setting memory regions
>    KVM: Add a dedicated API for setting KVM-internal memslots
>    KVM: x86: Drop double-underscores from __kvm_set_memory_region()
>    KVM: Disallow all flags for KVM-internal memslots
> 
>   arch/x86/kvm/x86.c       |  7 ++++---
>   include/linux/kvm_host.h |  8 +++-----
>   virt/kvm/kvm_main.c      | 33 ++++++++++++++-------------------
>   3 files changed, 21 insertions(+), 27 deletions(-)
> 
> 
> base-commit: 10b2c8a67c4b8ec15f9d07d177f63b563418e948


