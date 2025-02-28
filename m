Return-Path: <kvm+bounces-39652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C199A48E41
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 02:59:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0BA73B3B2A
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 01:58:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8112713665A;
	Fri, 28 Feb 2025 01:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tk5S6FV+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5181017741;
	Fri, 28 Feb 2025 01:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740707934; cv=none; b=lfCybDnJUpuocu6miPVAwA1em8n7QN6h3BV8+v2e6KRrUqRAnEZjgxytEw7JKmirO1nrIwsg8d2LSpueafmO2+6wF0Pz4UI33DPvPaYxPlnSgfdf3CRVK7OojoJUwn7HCeP9mpVm76T3c8Eo9CYSZY612Yl5BM1yRow/+tCwKBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740707934; c=relaxed/simple;
	bh=eCIh5PRJ/fy3yCj1iy7+IdW4uh1ItY08zywudj3k84U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P7psxd42mAMm+UuLj//bbFmosjDbW5jjYyegct/NcKVRJrJpJIrBPQYL8hpKFjtpy6IbGl9yXzBpNBiEWy82fXTX9rN8s9PBRy6LKVAhia6bDl8K7GNwPzqDbZOa1TN+WJYpthdtekmYb8zXAvGpbV5EVujgjiHHYuWsTKx4DRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tk5S6FV+; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740707933; x=1772243933;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eCIh5PRJ/fy3yCj1iy7+IdW4uh1ItY08zywudj3k84U=;
  b=Tk5S6FV+44OrSKf1s8jMpzF7bjb2jP2lihJFQc91qLV4kMqLogUiDUiF
   gm2+YmUvZQucGt4cVEhCeYZxk4oHy1GHwt+kmbPtyDcAzht7Ss5JxmdC2
   RelkNxh2+0aLLVXBSYpW5dN0BQnueoO46t9JbkiCg39h8guHTFdyoFD3n
   11dv9Dkg7mQVFIzLKx2WzYNtDZlDKXFXtbAX4k5B4A5H+1dDqu47ytCGO
   oieSsLQ41orihJZPpPFZ28Ei6x0r0WUuq9ueQI1GwmlnAd5NPCnFvZYP2
   IYadeAV/QdgB08QS3cDiCRwS7alZczuKQUG6VOwCEf5ayE7xNR6hWNXM9
   A==;
X-CSE-ConnectionGUID: IGFTP9ppSOGVgsU/AH1cyQ==
X-CSE-MsgGUID: 56Xwx9EaQdm3skUaBeisUw==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="41754849"
X-IronPort-AV: E=Sophos;i="6.13,321,1732608000"; 
   d="scan'208";a="41754849"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 17:58:52 -0800
X-CSE-ConnectionGUID: +ciJbxvVSMO5z/18ybdH4g==
X-CSE-MsgGUID: 6sKXPNxKS/iD4cscdCuU/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="122430005"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 17:58:48 -0800
Message-ID: <c7368616-063a-44c1-81d4-12ee903c2072@intel.com>
Date: Fri, 28 Feb 2025 09:58:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 07/12] KVM: TDX: restore host xsave state when exit
 from the guest TD
To: Adrian Hunter <adrian.hunter@intel.com>, pbonzini@redhat.com,
 seanjc@google.com
Cc: kvm@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 binbin.wu@linux.intel.com, dmatlack@google.com, isaku.yamahata@intel.com,
 nik.borisov@suse.com, linux-kernel@vger.kernel.org, yan.y.zhao@intel.com,
 chao.gao@intel.com, weijiang.yang@intel.com
References: <20250129095902.16391-1-adrian.hunter@intel.com>
 <20250129095902.16391-8-adrian.hunter@intel.com>
 <5cbb181c-f226-4d50-8b92-04775e8b65e0@intel.com>
 <bac63116-916f-46f8-ae5b-945b43d181bc@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <bac63116-916f-46f8-ae5b-945b43d181bc@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/27/2025 10:29 PM, Adrian Hunter wrote:
>>>    +    vcpu->arch.cr4 = ~vcpu->arch.cr4_guest_rsvd_bits;
>> when userspace doesn't configure XFEATURE_MASK_PKRU in XFAM, it seems kvm_load_host_xsave_state() will skip restore host's PKRU value.
> That's correct.

FYI, in this case, it's safe and functional though 
kvm_load_host_xsave_state() skips restoring the host's PKRU value.
Because host's PKRU is not clobbered after TD exit when XFAM.PKU is 0. 
So no need to restore.

