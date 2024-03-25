Return-Path: <kvm+bounces-12558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 816FF889711
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 10:06:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3652D1F36039
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 09:06:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C7CB70CAD;
	Mon, 25 Mar 2024 04:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LGJ2tZvN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63F9199E9E
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 00:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711326908; cv=none; b=c1ptDs+ZewUN+kStnrVPwEkuazEXtNPEIPiPkKi/so5wE1hA7dte1GKPJCk6FI1KXMKFupApc2GSang6DdXy+yA5dyhZFcscDKxVk+sLw8VIzGjm8kzNWLlXaAs9p45wP5PyM64i68ONqN1+TJurplF4wgNKjjt/RJMpSv6muNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711326908; c=relaxed/simple;
	bh=X+Z2kZZS93Y5BQ6xU/B3LH5TiW4Vb5piaiw2nSuDHVQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZfKstBe5u3ElerQu3FXA0NN4tq+T4CZxBA+YSCLtqCNItQ7r6ng4eqwNdb4qEI7xKSZCELFQpMcqj38i3q0+MLBLDjnUV9wNCycbawvWZTPd7dFLYoG2xgrWLcaHMZZNksiTm7t8g+odz8pzFFe+HIydYExfZ770u/zyPybLqcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LGJ2tZvN; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711326907; x=1742862907;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=X+Z2kZZS93Y5BQ6xU/B3LH5TiW4Vb5piaiw2nSuDHVQ=;
  b=LGJ2tZvNQvjE3svVmaJPx7b4eVb6bNINBYojBqtfxquSsW3NnGIuTZ69
   CsaSnhsAlq/BdHWDiW8tCpD96ScluNg6TYujwA5i4HyfYn3KbTo6N5vQK
   zLwhZrrN7NtG4SRwUWCSynmEic1q0nd7SdOq7X7meKxTR5jfCZs0Z4tfB
   FA3dDp/tzytxbl3BK8RUD9yfxarNpqItYXP/7tBxAFw0BS3u9Qq7uc3L5
   oVP+6Wki1cnswLoJWjKxdn5HSpY+afW2lA1ypw9HXWW0wEV0BJPCbprmC
   w+IBcknB5ZcWDLXq/NsaC3oWuKWvrLdklB4LEB0fY8nRFNdUY0ETrgGR/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11023"; a="23762849"
X-IronPort-AV: E=Sophos;i="6.07,152,1708416000"; 
   d="scan'208";a="23762849"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2024 17:35:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,152,1708416000"; 
   d="scan'208";a="15410868"
Received: from unknown (HELO [10.238.0.234]) ([10.238.0.234])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2024 17:35:04 -0700
Message-ID: <e60e9ae0-7c29-4936-a530-bae92d47a1dd@linux.intel.com>
Date: Mon, 25 Mar 2024 08:35:02 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/2] Add support for LAM in QEMU
To: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com
Cc: xiaoyao.li@intel.com, chao.gao@intel.com, robert.hu@linux.intel.com
References: <20240112060042.19925-1-binbin.wu@linux.intel.com>
 <d424a315-1b20-47bf-a88e-394f576c3cc1@linux.intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <d424a315-1b20-47bf-a88e-394f576c3cc1@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


Ping...

On 1/22/2024 4:55 PM, Binbin Wu wrote:
> Gentle ping...
> Please help to review and consider applying the patch series. (The KVM
> part has been merged).
>
>
> On 1/12/2024 2:00 PM, Binbin Wu wrote:
>> Linear-address masking (LAM) [1], modifies the checking that is 
>> applied to
>> *64-bit* linear addresses, allowing software to use of the untranslated
>> address bits for metadata and masks the metadata bits before using 
>> them as
>> linear addresses to access memory.
>>
>> When the feature is virtualized and exposed to guest, it can be used for
>> efficient
>> address sanitizers (ASAN) implementation and for optimizations in 
>> JITs and
>> virtual machines.
>>
>> The KVM patch series can be found in [2].
>>
>> [1] Intel ISE https://cdrdv2.intel.com/v1/dl/getContent/671368
>>      Chapter Linear Address Masking (LAM)
>> [2] 
>> https://lore.kernel.org/kvm/20230913124227.12574-1-binbin.wu@linux.intel.com
>>
>> ---
>> Changelog
>> v4:
>> - Add a reviewed-by from Xiaoyao for patch 1.
>> - Mask out LAM bit on CR4 if vcpu doesn't support LAM in 
>> cpu_x86_update_cr4() (Xiaoyao)
>>
>> v3:
>> - https://lists.gnu.org/archive/html/qemu-devel/2023-07/msg04160.html
>>
>> Binbin Wu (1):
>>    target/i386: add control bits support for LAM
>>
>> Robert Hoo (1):
>>    target/i386: add support for LAM in CPUID enumeration
>>
>>   target/i386/cpu.c    | 2 +-
>>   target/i386/cpu.h    | 9 ++++++++-
>>   target/i386/helper.c | 4 ++++
>>   3 files changed, 13 insertions(+), 2 deletions(-)
>>
>>
>> base-commit: f614acb7450282a119d85d759f27eae190476058
>


