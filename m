Return-Path: <kvm+bounces-39251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A90FA45980
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 10:08:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83E773A6544
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 09:08:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE626226CEE;
	Wed, 26 Feb 2025 09:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ns9M7ByS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910AB2135B7
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 09:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740560895; cv=none; b=ZDwZs+goYvm8H8plZJHd1F+7PBAVWucrDxNyVkZyv97wiGWKw/26M2yU588ggQb6/jTjWSkjywJ0CrJy9tTILbXs4s12l9CQeCUKr31PI08HROIfXbpHAusSKM2vZQiIclrtPUYiwxL/fd0GC4xSyZTarsaQI+eUNuVLuQyxBLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740560895; c=relaxed/simple;
	bh=GWWzRHBQNiFlJY0nRVjsPP62ueyICDRFNE/0/AqsqDM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PqWMHwGJplkBuDlUrf3TmGjWAN68F5pOrjimYNCRkLzvJw+vsVFW9IVbe0xWk+5rfsjE3YHh1W3YlIMNxEj4Babn/W582RZKieMlfmLqJvcP31zKIej3pkiRwrKTxyyosk33lNV317qhUXCYbweSgJ9J2LyXQJcjOVUOEjHs7FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ns9M7ByS; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740560894; x=1772096894;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GWWzRHBQNiFlJY0nRVjsPP62ueyICDRFNE/0/AqsqDM=;
  b=ns9M7BySKDyxnF9d1y/nPwIEQ3yi0FihmyzG31jaxUwHS1peOSrQqalF
   HERTfiNKsyZ1L/sgLdANgLb+ONQGex+gKhlrXNvA6wLRrKy6MEkL9y9p2
   w8E2SYcWHhHAGSOSvrbq3PePv6ymHiaqIcr96wmWwgz9ERcKm3tlWxT/z
   ADjdIB6lMmScMd3aLVGFHPtvJdVN5ecjpa8APgr2eCkWonRR8GZcZ4WaH
   BbcAsz6nVLllgvekctdqSHJyI+UQul2H82Ln6i6u+67lYnEQj7W0vIlma
   1J5+rJFXT0zzr4mqD2yc6ytqZUopp2os8i3Jm2+I8gSusFT8mNVbLEgVV
   w==;
X-CSE-ConnectionGUID: 3UBgwzB0QRadoL21PQipaQ==
X-CSE-MsgGUID: EQtN7qY0RC2AJ5LPH6KrDA==
X-IronPort-AV: E=McAfee;i="6700,10204,11356"; a="66768444"
X-IronPort-AV: E=Sophos;i="6.13,316,1732608000"; 
   d="scan'208";a="66768444"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 01:08:13 -0800
X-CSE-ConnectionGUID: lsIln+ngSEaSEg/4dP7mKg==
X-CSE-MsgGUID: C9wFepWBThaaQSCKNqD1xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="147557543"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 01:08:09 -0800
Message-ID: <4bbc83f9-f000-4f4b-834a-3804007745e4@intel.com>
Date: Wed, 26 Feb 2025 17:08:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 19/52] i386/tdx: Track mem_ptr for each firmware entry
 of TDVF
To: Francesco Lavra <francescolavra.fl@gmail.com>,
 Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>,
 Marcelo Tosatti <mtosatti@redhat.com>, Huacai Chen <chenhuacai@kernel.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
 <20250124132048.3229049-20-xiaoyao.li@intel.com>
 <4ec0652b387427cfadaef796ae9162921115bf43.camel@gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <4ec0652b387427cfadaef796ae9162921115bf43.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/20/2025 2:40 AM, Francesco Lavra wrote:
> On Fri, 2025-01-24 at 08:20 -0500, Xiaoyao Li wrote:
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index 73f90b0a2217..8564b3ae905d 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
>> @@ -12,10 +12,14 @@
>>   #include "qemu/osdep.h"
>>   #include "qemu/error-report.h"
>>   #include "qemu/base64.h"
>> +#include "qemu/mmap-alloc.h"
>>   #include "qapi/error.h"
>>   #include "qom/object_interfaces.h"
>>   #include "crypto/hash.h"
>> +#include "system/system.h"
>>   
>> +#include "hw/i386/x86.h"
>> +#include "hw/i386/tdvf.h"
>>   #include "hw/i386/x86.h"
> 
> Duplicated include
> 

Thanks for catching it!

