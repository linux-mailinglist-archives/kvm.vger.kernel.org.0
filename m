Return-Path: <kvm+bounces-39249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FC83A4597A
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 10:08:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A3EC2189802E
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 09:08:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0A2622423E;
	Wed, 26 Feb 2025 09:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fKGTbV5K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BFF226CF8
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 09:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740560876; cv=none; b=fo3sshNqlx1FFX3XDoeDheg/ZSOKbYyj8ZnjdlpP4VD/i4zTzPkeIP7iQUl+lhNC3cX/ma/e87318e+ZRgR8JUtjH4waZyCEsqxAJedc62gKUtABQsbEMkp4KTc6ugllRQPJG7AbnRM11G+E5UaxbRRcReRihMQyNiNUEXL8Uc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740560876; c=relaxed/simple;
	bh=Q7yrOEWZYBO+5YQiQdQ8RxUY22I2+Us/YMUUugFJp8c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rjz4vHdGMiXZNvxNSBdUgPNX2dT0WEUwZ37/gqxOU2dko8JobDo2KK3jx+FIBVIbyxykTeQ0KfXLGwAnDdmTObxF1VWDLHEQ82DHB7WLrrZ4BVhI95EnzYAI046SdikORVC02RMUfKXYldnvYG1V+40BX7OgWH8RTqKAYRHlHn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fKGTbV5K; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740560875; x=1772096875;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Q7yrOEWZYBO+5YQiQdQ8RxUY22I2+Us/YMUUugFJp8c=;
  b=fKGTbV5Ke9k+qvNJvPrKw4Fj8sPOr5tuTBMTfTQ1S8ehiiNdcomo3Wbo
   00H2YdgwKs7YCd3STh+b9CioJOhjimZFD991YbV3UePM0Yj58nXe6VH+S
   mZIdfKppf/FOa6vUJH67CwRSwjsuJCmE8ENO+OpPkxux/mDZYxpvSdp52
   mcYsi0MLJNBdGd9u+pITZ9vgcuV2TpW+iBrptnD41OzUYAyLXlPhG8vOP
   7oP1zYGZVP7HP6IU2cuCrdA+n7t0hNoAtjvJDlYmf8NQv/bGQskujMfg/
   oZmAG9G5qNEZ5q0PYiVGviBE4gGza7rp9Wl/B7bZsSwjr0JwQaoLJePzA
   Q==;
X-CSE-ConnectionGUID: CHatHAA6TzW9c8ZV0PLsPw==
X-CSE-MsgGUID: Iu60dOeHQsWKJmRcK/GSwQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11356"; a="66768417"
X-IronPort-AV: E=Sophos;i="6.13,316,1732608000"; 
   d="scan'208";a="66768417"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 01:07:55 -0800
X-CSE-ConnectionGUID: 550GVI5VSQe9bhVGUE8jjw==
X-CSE-MsgGUID: kleEU+83RlSJNtU1iEbc1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="147557391"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 01:07:50 -0800
Message-ID: <3f62c928-d9ee-4ffc-b54d-17e24c943d2d@intel.com>
Date: Wed, 26 Feb 2025 17:07:47 +0800
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
 <71f051114ab5db2a94506b4d8768ebfa79033590.camel@gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <71f051114ab5db2a94506b4d8768ebfa79033590.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/19/2025 7:26 PM, Francesco Lavra wrote:
> On Fri, 2025-01-24 at 08:20 -0500, Xiaoyao Li wrote:
>> +static void tdx_finalize_vm(Notifier *notifier, void *unused)
>> +{
>> +    TdxFirmware *tdvf = &tdx_guest->tdvf;
>> +    TdxFirmwareEntry *entry;
>> +
>> +    for_each_tdx_fw_entry(tdvf, entry) {
>> +        switch (entry->type) {
>> +        case TDVF_SECTION_TYPE_BFV:
>> +        case TDVF_SECTION_TYPE_CFV:
>> +            entry->mem_ptr = tdvf->mem_ptr + entry->data_offset;
>> +            break;
>> +        case TDVF_SECTION_TYPE_TD_HOB:
>> +        case TDVF_SECTION_TYPE_TEMP_MEM:
>> +            entry->mem_ptr = qemu_ram_mmap(-1, entry->size,
>> +
>> qemu_real_host_page_size(), 0, 0);
>> +            break;
> 
> Should check for MAP_FAILED return value.

will add the check for it.

>> +        default:
>> +            error_report("Unsupported TDVF section %d", entry-
>>> type);
>> +            exit(1);
> 
> Section entry types have already been checked against valid types in
> tdvf_parse_and_check_section_entry(), no need to check them again here.

I would rather keep it. It does no harm and I help catch issue when 
people adds new type in tdvf_parse_and_check_section_entry but miss this 
place.


