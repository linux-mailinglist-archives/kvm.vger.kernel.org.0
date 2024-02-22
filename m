Return-Path: <kvm+bounces-9348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 100E285EF0E
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 03:16:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC4B51F21605
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 02:16:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC4EE14298;
	Thu, 22 Feb 2024 02:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Viq+SppC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D83614287
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 02:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708568195; cv=none; b=Ls4hKloCCrxBk6tjdseXl+Gf3d/n3Y5hdmokxMS/YWIH6Kcf1QQI2cNq26NgX06QrQk+I3jRQ/gRydXqC2ia1I80rzoCSz/E1T0IYBxI+hiNNU+HodJMX5h1cxlkP7q7u9emIPipKxWr4GdXs1jQIUHZ13v/f9227mRs6FN6cdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708568195; c=relaxed/simple;
	bh=GVVlhEg+VUhDJj60uKfZHvT0dykSv132W4akNvfxTVs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M9exkivBPIUbKuh2KbiU7YkPVQ/HOi3IMUfrgWgjar8nAqlr6kWWacjZS7l6F/s3+1TN9XYd3aawRtHRNKmAlu2FnM2r6AbeliRS5qAW09Fzp6fHmcUgiSrMJ9RoSEojllGLLhMpMMCU/E0D4AkitNJzEZzw3B+tt4DiQEnanmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Viq+SppC; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708568194; x=1740104194;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GVVlhEg+VUhDJj60uKfZHvT0dykSv132W4akNvfxTVs=;
  b=Viq+SppCBYH5be9yhenGyvETbuD0H+T6ligcTv7SWwuYzPYuGRCp+ogL
   JIDd2z+Vcq92kGMM/U5/DKJXjZR5Ccx6nqp3wpHEqWDiL/bRijSFGy5my
   uX8KG2z3v5qWUlz393SJt9UFBbMphmKG8/hZeaEu7q8bOl7veoF78CzT/
   PmtQDDEg2Qzh9FG+PL8i97lJqyZJUme1NGKhto7oF8kziJKKLj025Kt8w
   2bdn9bdG1blPYBmjjpvmJ/DEhV/x/9ocnwUWKoKFvwVGt5OMG+g6LonUf
   IKRV08E7ky5kghdQkfBmaww4LOMAx6MvnF0pDLPcDD6htcQ86CDDpugtq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10991"; a="14182077"
X-IronPort-AV: E=Sophos;i="6.06,177,1705392000"; 
   d="scan'208";a="14182077"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2024 18:16:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,177,1705392000"; 
   d="scan'208";a="9915880"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.93.18.46]) ([10.93.18.46])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2024 18:16:32 -0800
Message-ID: <4a88cf43-dd29-4b57-8a9e-f76451b9af1f@linux.intel.com>
Date: Thu, 22 Feb 2024 10:16:29 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/2] Add support for LAM in QEMU
To: pbonzini@redhat.com
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, xiaoyao.li@intel.com,
 chao.gao@intel.com, robert.hu@linux.intel.com
References: <20240112060042.19925-1-binbin.wu@linux.intel.com>
 <d424a315-1b20-47bf-a88e-394f576c3cc1@linux.intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <d424a315-1b20-47bf-a88e-394f576c3cc1@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Ping...

Hi Paolo,
do you have time to have a look at this patchset?


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


