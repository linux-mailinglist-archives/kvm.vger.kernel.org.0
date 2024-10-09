Return-Path: <kvm+bounces-28161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5786995EFE
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 07:37:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E1DE28684B
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 05:37:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F24DF160884;
	Wed,  9 Oct 2024 05:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PSmulrKz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90FC42AAF;
	Wed,  9 Oct 2024 05:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728452242; cv=none; b=mCj7n0B+gOBuPdHcZ8xK1CwssO5hg/8ZTOpwhjzm8eSatqmOe1dbMOg8vZ9lS7EQnowFViEpUacM3VtLc1KNbBvaqb+HKUVS8JANfKnOc7VFerAHErQNelVEo7FRvEGjCQhEBQD/ZsPuR90GcuwRgQCkqJDTvdQfZ4pEtqTXv+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728452242; c=relaxed/simple;
	bh=fVO/BFZDXzjJ6ZI3+lHMKCMSrYr6wvKKzkyPRsJIDHc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TyOA7U5Se3WmacBel11FbZsVny/fZCjsMGN7317s3BA4Z2jgb5Lmj+rsHZNilUOEzEX5cmlUwTn0WXMibl5ozXZ8jzXFHPXHmy7Ni+1wwslgJk8ItHyrGc5ROJJAIHpIfL58iNwN1k63bGvD5e9LWw3ABSQ0/RoaYHrQGkj08j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PSmulrKz; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728452241; x=1759988241;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fVO/BFZDXzjJ6ZI3+lHMKCMSrYr6wvKKzkyPRsJIDHc=;
  b=PSmulrKzvQC2+GKWWLgyBSxuGmUXIrWnpJHjnNHO9DxdcbPprEVj3cIJ
   tm4y3xY3ygdKV5RePZLSBkJ3F4KFmo3aNDrNVJcZ6H/rdIaCzodSeDaTg
   Nxv+VswwtEuB8cLTWn6yyzTNfl78uFnhp2eP7hWxuH/aefNXBcdloKAK0
   0yeg7mf11z1hjmWtQPKoEJniAq2XwlPF4+2QRhkj5AXNotg4lmM+82da+
   Bmxt6s4jGcyI/gns79NitjWy9ZtICsFxGRLZF3ggERlSLg90y6QZa9HaM
   ciw7sgZ8BDqrbtdj4n4MWYDktUfkmQL0I64vWqDeCQGAbmgfuKd0O+mDm
   A==;
X-CSE-ConnectionGUID: eOnjGW9gSjmvTBs5HwZ7LA==
X-CSE-MsgGUID: 2vSyGQgVQ2m5uUPdrrXnPQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11219"; a="27857070"
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="27857070"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2024 22:37:20 -0700
X-CSE-ConnectionGUID: AsxG5UkVRwy0V3IEQ9pSEA==
X-CSE-MsgGUID: /2T/s/5gQza1V9hYFf21Iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="80964297"
Received: from unknown (HELO [10.238.9.213]) ([10.238.9.213])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2024 22:37:18 -0700
Message-ID: <9626cbef-03c9-4b83-889c-6a5de4e95791@linux.intel.com>
Date: Wed, 9 Oct 2024 13:37:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/2] KVM: x86: Check hypercall's exit to userspace
 generically
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, seanjc@google.com,
 pbonzini@redhat.com
Cc: isaku.yamahata@intel.com, rick.p.edgecombe@intel.com,
 kai.huang@intel.com, yuan.yao@linux.intel.com, xiaoyao.li@intel.com
References: <20240826022255.361406-1-binbin.wu@linux.intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240826022255.361406-1-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Gentle ping...


On 8/26/2024 10:22 AM, Binbin Wu wrote:
> Currently in kvm_emulate_hypercall, KVM_HC_MAP_GPA_RANGE is checked
> specifically to decide whether a KVM hypercall needs to exit to userspace
> or not.  Do the check based on the hypercall_exit_enabled field of
> struct kvm_arch.
>
> Also use the API user_exit_on_hypercall() to replace the opencode.
>
> ---
> v3:
> - Rename is_kvm_hc_exit_enabled() to user_exit_on_hypercall(). (Sean)
> - Remove the WARN_ON_ONCE(). (Isaku, Sean)
> - Use BIT(hc_nr) instead of (1 << nr) (Yuan)
> - Added a comment to explain why check the !ret first. (Kai)
> - Add Kai and Isaku's Reviewed-by.
>
> v2:
> - Check the return value of __kvm_emulate_hypercall() before checking
>    hypercall_exit_enabled to avoid an invalid KVM hypercall nr.
>    https://lore.kernel.org/kvm/184d90a8-14a0-494a-9112-365417245911@linux.intel.com/
> - Add a warning if a hypercall nr out of the range of hypercall_exit_enabled
>    can express.
>
> Binbin Wu (2):
>    KVM: x86: Check hypercall's exit to userspace generically
>    KVM: x86: Use user_exit_on_hypercall() instead of opencode
>
>   arch/x86/kvm/svm/sev.c | 4 ++--
>   arch/x86/kvm/x86.c     | 7 ++++---
>   arch/x86/kvm/x86.h     | 4 ++++
>   3 files changed, 10 insertions(+), 5 deletions(-)
>
>
> base-commit: a1206bc992c3cd3f758a9b46117dfc7e59e8c10f


