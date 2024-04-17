Return-Path: <kvm+bounces-14923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D9B08A7B19
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 05:37:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BF97BB21611
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 03:37:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04711405D8;
	Wed, 17 Apr 2024 03:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AtvX+FHj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E142260A;
	Wed, 17 Apr 2024 03:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713325065; cv=none; b=GhhFiRZgEYI5dtPsoFGqDHVkGwI3cG3BiznQFkQ4Z+Mxl/cEunFguDKOKYiTQjNeZCGjk1XwvWvMWHbBN8PHKt26BC3oLUF5iyubmExOhGaq+228xG9gLHZt6mnRv+26sxdLOnGpIHk1IzUKKA18kuZkr26HUW0m+qs+1DXAGf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713325065; c=relaxed/simple;
	bh=00HJtH0QWrCENAFZgWCzA9lQHeGivlTimNrmNg+L6yU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hy17a+VZNUoRtN/eqarGb7RLLScnlX89HsYZI7GNsbBez9y/VdHts1kY9Qtjm3EzHgRzt4wZvl6iAiLBuAVhZ5Ram8RW+maVTHtkRiFCNGzwpo6otRsJkiBsiSK/h8/dDzsg9ZSJCv1UVaE+12icoMq0CMlXluqJKcE4cnhalIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AtvX+FHj; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713325064; x=1744861064;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=00HJtH0QWrCENAFZgWCzA9lQHeGivlTimNrmNg+L6yU=;
  b=AtvX+FHjTpbd+w4ZVrm4IiGURpLrspuw36qLGDgVFWvQN4xd2Rucw4w7
   btJzxouTnbcrst8xHm9dEuWhX8K8VeRX81x5VKYboBJMr8035smrx6ELE
   65jH7rvsiCfF0GYIsWGunclZYhUS2WTX/r5r8L7a5CJNniHlhnsKgnYZa
   yvDuJtsvdNUshrW0mCYexvoLSkYBW3NB3CemyZsYEvdGC2ZYLoHXxDRBO
   SuzOEaz9dCfU8OZ8lSVpxWQPVlGaw4Lb3OcqijOW1fywH5nnGxSBPinzw
   Sv/Pnu6XuLh/rn/PJi1ZQYt7ipEkLRVcKWQanBNtvDdYmjN7Zm0xpLoe7
   Q==;
X-CSE-ConnectionGUID: oXe97HuOTuK1SXv3a2RmZg==
X-CSE-MsgGUID: wIL6GU5BRzKrBt/ZS6KnBw==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="8659938"
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="8659938"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 20:37:43 -0700
X-CSE-ConnectionGUID: 7Lv2mrblQ367wKv/S6Z1TA==
X-CSE-MsgGUID: +DJGUsdbQWOmCJVdobaxlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="53452059"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 20:37:39 -0700
Message-ID: <1e26b405-f382-45f4-9dd5-3ea5db68302a@intel.com>
Date: Wed, 17 Apr 2024 11:37:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 3/4] KVM: x86: Add a capability to configure bus
 frequency for APIC timer
To: Reinette Chatre <reinette.chatre@intel.com>, isaku.yamahata@intel.com,
 pbonzini@redhat.com, erdemaktas@google.com, vkuznets@redhat.com,
 seanjc@google.com, vannapurve@google.com, jmattson@google.com,
 mlevitsk@redhat.com, chao.gao@intel.com, rick.p.edgecombe@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1711035400.git.reinette.chatre@intel.com>
 <6146ef9f9e5a17a1940b0efb571c5143b0e9ef8f.1711035400.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <6146ef9f9e5a17a1940b0efb571c5143b0e9ef8f.1711035400.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/22/2024 12:37 AM, Reinette Chatre wrote:

...

> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 0b5a33ee71ee..20080fe4b8ee 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8063,6 +8063,23 @@ error/annotated fault.
>   
>   See KVM_EXIT_MEMORY_FAULT for more information.
>   
> +7.35 KVM_CAP_X86_APIC_BUS_FREQUENCY

As sean mentioned it previous comment, I would be the one prefers 
KVM_CAP_X86_APIC_BUS_CYCLES_NS

   Depending on whether people get hung up on nanoseconds not being a
   "frequency", either KVM_CAP_X86_APIC_BUS_FREQUENCY or
   KVM_CAP_X86_APIC_BUS_CYCLES_NS.

