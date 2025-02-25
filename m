Return-Path: <kvm+bounces-39129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4452A445FC
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 17:27:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0238F176072
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 16:25:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D56E918E054;
	Tue, 25 Feb 2025 16:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iyrFVoNO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98746166F1A;
	Tue, 25 Feb 2025 16:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740500699; cv=none; b=o+HcP1w8KQUGB8RMSjYOvd1zKMxPoAO2o1ftR3gDHYQwf83CK6C6bN1iNne9mPSv15Gk2BCiKQ5vzRVcQaYk9sqLTdhG5L1qM+o6F0aDhi2lvYNdCGBFtqmTSnIsZi14+Z4xMN07gT2FJ5EMj+4Zz9dynB7X6XoP208K3J4/+Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740500699; c=relaxed/simple;
	bh=d5Im4SoxuvcPh6FtOq83T6W8t4LFklHxofjadqDgeZ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nQFgGtoOzQuTfunwSkwLwo21Y6+Ei08tz7q335RRA7tS5ao5WOc3T2WlL+OsJuWQuhf8zij7MQ5W97H1YnzhEfmI9BfsTIQfdF5Ijiknlcec8OgOQ/wrrtmNOhPUs4kAXbj4hnJym8x3fqizL+UDVXMMCgTC0KdyN2paTfAmzcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iyrFVoNO; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740500698; x=1772036698;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=d5Im4SoxuvcPh6FtOq83T6W8t4LFklHxofjadqDgeZ8=;
  b=iyrFVoNOo6eeHLCtid19ubjWWoEaYudxIdyLKGpe08CJw7iu7F9YRdy/
   sx8wTZxNmQb0DLLzwkydt2zP+a7PX4RNmPZ0/gLKR5Lmy40COXq5HFjaS
   LGDRmn15VVMEHXpoDGqa4tGPPz6NCvHsMRKLGejdNcLri5UDGsYpKz2NE
   4hXZAV7wMGhI3bcG1rd6BpcAcTqAahpkvlB7j2gl0z3lMOVGJo72dO9ne
   ItaZxYuYgDc4uQOcw4A+UjXCJ9y4mvuaVivDp2IrJrLepJG2mgnzGeaMq
   bFngN9iXBN7EthLbgx4pTc1mXtrWI0e2f+MKrn24U/RUdO3Fd47orMj7s
   g==;
X-CSE-ConnectionGUID: 70k5ztAGQ5y6cDbPxlqOIw==
X-CSE-MsgGUID: kKTB0uPWSAmZ5MmL3SkY9Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11356"; a="66684022"
X-IronPort-AV: E=Sophos;i="6.13,314,1732608000"; 
   d="scan'208";a="66684022"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 08:24:57 -0800
X-CSE-ConnectionGUID: Z8f2P4wrSOqORlw23tXdVw==
X-CSE-MsgGUID: Rrujtc9uQU2VlV04wPxkmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="116922429"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 08:24:54 -0800
Message-ID: <1fd5ede5-e6a9-4aee-b540-0c9b75489917@intel.com>
Date: Wed, 26 Feb 2025 00:24:51 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 20/30] KVM: TDX: create/destroy VM structure
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: seanjc@google.com, Yan Zhao <yan.y.zhao@intel.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Tony Lindgren <tony.lindgren@linux.intel.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Kai Huang <kai.huang@intel.com>
References: <20250220170604.2279312-1-pbonzini@redhat.com>
 <20250220170604.2279312-21-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250220170604.2279312-21-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/21/2025 1:05 AM, Paolo Bonzini wrote:

...

> +int tdx_vm_init(struct kvm *kvm)
> +{
> +	kvm->arch.has_private_mem = true;

If it's going to have a next version, I think we can squash below patch 
into current:

https://lore.kernel.org/all/20250129095902.16391-4-adrian.hunter@intel.com/

> +	/* Place holder for TDX specific logic. */
> +	return __tdx_td_init(kvm);
> +}
> +


