Return-Path: <kvm+bounces-44088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA41BA9A4A1
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 09:47:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D47E5A333C
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 07:46:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E03920C488;
	Thu, 24 Apr 2025 07:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OB/Wu0p/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5C61F4CAB;
	Thu, 24 Apr 2025 07:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745480659; cv=none; b=CfmnSF0m8H64Spn8fwovLxdoCnvMukHyLJ0syxbzi/mL9+JUguDESYt5K0DW7QNOFUJM1bgdqyQpY1n+fmaQ3qEBfEGciUkkfvic42UFjKxlAFXtseuE2+5hFoZvLmsUH0Mu9WOnEsY99YSiRqHQEzAKpPyLG01J0yvZKlKUUn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745480659; c=relaxed/simple;
	bh=VnZ0ZKETltelPggcEVrc3mWHY8TQu/tmfh9OEL4vmMI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f4v7pq4kj8tHjD7sAlBD5E1TTmVIX7xMQcgW4PbFk2MYHbivdi70e645VoH5KxKhK3KWhrNvv/W2iHGuXSVsNgb6Bpq4RJ/spjmDIdwfoJxEFwnCztrahwR/QA1KyB8MFBapot2HePmbRy7qoHz99xRZFVVhBeW1xnzExEx2Puc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OB/Wu0p/; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745480658; x=1777016658;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VnZ0ZKETltelPggcEVrc3mWHY8TQu/tmfh9OEL4vmMI=;
  b=OB/Wu0p/r8d15aebZjNEJntfPO9eWB3D/pZUnPOZv9YQNClfiBNNVzqW
   KsM/uCZOF5AiVokmGN7VWM41rOCaTzTd3ExwHBFrt8bixmAw7EojDGD8h
   1YowSpfcLieySl6POEIYeClPzKs0txBlHWnfI6SokzyewlKKrpBnd+Jlz
   yigZlZQbLsGoEvQzjyhXtdblXT26G0TbuiE+VG/AK1VHAHXLwesW+UNQI
   yv8e/EA8vCnwjihXWRM6cyqap28mofCr+lCvKXP/JdrIUahwPH9gFzwgV
   91pB5dh5vqsYiOR43QX3ORlBONnA1qtmS5ivaf9dAduyuVt8m8DYm7oDm
   g==;
X-CSE-ConnectionGUID: V2WGM4HkS+aVeKFQFLBK6Q==
X-CSE-MsgGUID: wxBLYM9lRMGvXLXlRBz0Vw==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="57741542"
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="57741542"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 00:44:16 -0700
X-CSE-ConnectionGUID: MELztBFPQQ2RK/E68kIfoA==
X-CSE-MsgGUID: h1WZ0YKEQFuFYSt/MxBHnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="132274496"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 00:43:59 -0700
Message-ID: <02689dad-a10a-41a8-ad7e-e92d0a8d7e76@linux.intel.com>
Date: Thu, 24 Apr 2025 15:43:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 12/34] x86/msr: Remove pmu_msr_{read,write}()
To: Xin Li <xin@zytor.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 linux-pm@vger.kernel.org, linux-edac@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-acpi@vger.kernel.org,
 linux-hwmon@vger.kernel.org, netdev@vger.kernel.org,
 platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, acme@kernel.org,
 jgross@suse.com, andrew.cooper3@citrix.com, peterz@infradead.org,
 namhyung@kernel.org, mark.rutland@arm.com,
 alexander.shishkin@linux.intel.com, jolsa@kernel.org, irogers@google.com,
 adrian.hunter@intel.com, kan.liang@linux.intel.com, wei.liu@kernel.org,
 ajay.kaher@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
 tony.luck@intel.com, pbonzini@redhat.com, vkuznets@redhat.com,
 seanjc@google.com, luto@kernel.org, boris.ostrovsky@oracle.com,
 kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com
References: <20250422082216.1954310-1-xin@zytor.com>
 <20250422082216.1954310-13-xin@zytor.com>
 <7c44da88-72bb-4d1f-9f38-bf0e7e79b7a0@linux.intel.com>
 <45f95d01-4b98-457c-8272-c396a52b3844@zytor.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <45f95d01-4b98-457c-8272-c396a52b3844@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 4/24/2025 3:21 PM, Xin Li wrote:
> On 4/23/2025 11:33 PM, Mi, Dapeng wrote:
>> Could we merge this patch and previous patch into a single patch? It's
>> unnecessary to just modify the pmu_msr_read()/pmu_msr_write() in previous
>> patch and delete them immediately. It just wastes the effort.
> No, it's not wasting effort, it's for easier review.
>
> Look at this patch, you can easily tell that pmu_msr_read() and
> pmu_msr_write() are nothing more than pmu_msr_chk_emulated(), and
> then removing them makes a lot of sense.

These 2 patches are not complicated, it won't be difficult to review if
merging them into one as long as the commit message mentions it clearly.
Anyway I'm fine if you hope to keep them into two patches.



