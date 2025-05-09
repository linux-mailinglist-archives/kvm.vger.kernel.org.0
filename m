Return-Path: <kvm+bounces-46028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 401BAAB0D14
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 10:23:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56BF49C0884
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 08:22:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F41B274644;
	Fri,  9 May 2025 08:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NBdT1ouV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E90078F32
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 08:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746778956; cv=none; b=FI5EdFdkMF2RApEGrTAlGck+KgTN4CPrCVsTpyLZSYCeJtZQb+RW36JHX/pVUSffWh5CVb0LHmIBpa/5v5VgNiYp/fmTuZcJqHNVPBPa3o9bl5A5L3DGFklH1aHK7XzQ2WTKPdq5GtFmoRLIskwcmwDeTTjO/L9ugcVFtpshb9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746778956; c=relaxed/simple;
	bh=SDNBjb+qiPvs2UiFTyIhfPnnekIonyXpduju49LT/Pw=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Wv4KYHYSoNwWKc7fgibxF0Wpr96GFFdAEOHFbYkIDVgAqWmbw01QCpbFF4sv/dATgrzwmpavHvrbxFmymP9RXdj7ytHbprOL3+1XZ2nykTn2fYFTU35s72jFtT+rQEEl9wGUyqXuig4R6rBPcrNa3N6xyyj4RW+xFpeLQwYyfbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NBdT1ouV; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746778955; x=1778314955;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SDNBjb+qiPvs2UiFTyIhfPnnekIonyXpduju49LT/Pw=;
  b=NBdT1ouVCty2QWRYsVKEC7QrmscQ+V4cQWqG4uWejUiGse+Q4kjwgJjU
   urh2NFG6poAI8Vc2gNM5Asx73gPCxvd7smh8QboJzoas83lz96xPMVSkM
   Kde22+jntbwsKQRe/SP6wEsr++IZyOm22VcDG1eLWaodtu30i/1EFifnE
   wPQy+Rt9dhIdph8VFZ0sPPhbiboPzQnkAiPhxaaRsr3xUN7q6o+e1KQ7G
   qK4cKIEG+nGF1WqhIwqzyiGFx9gWnYvCKbND5mveix+jviMgZbVXsXMq0
   2Qsr3/AVdIvzotDgibDSt7nTeFQEEcsctWgqGcvZ1qSxlgXES1zqEkLPk
   Q==;
X-CSE-ConnectionGUID: iSrXHg7iRsS0hZBaMtuIMQ==
X-CSE-MsgGUID: pL54racgTfGUigcNyyQKxg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48712575"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="48712575"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 01:22:33 -0700
X-CSE-ConnectionGUID: qsKt87K1SCG8SqsIHY3Nxg==
X-CSE-MsgGUID: HTL3M13/QR6TTJpBH2OU3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="167627611"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.240.236]) ([10.124.240.236])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 01:22:29 -0700
Message-ID: <5fcf90b9-dff5-466c-9be5-2b6571a5de8a@linux.intel.com>
Date: Fri, 9 May 2025 16:22:26 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
Subject: Re: [PATCH v4 10/13] memory: Change NotifyStateClear() definition to
 return the result
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
 Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-11-chenyi.qiang@intel.com>
 <c7ee2562-5f66-44ed-b31f-db06916d3d7b@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <c7ee2562-5f66-44ed-b31f-db06916d3d7b@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/27/2025 10:26 AM, Chenyi Qiang wrote:
> Hi David,
> 
> Any thought on patch 10-12, which is to move the change attribute into a
> priority listener. A problem is how to handle the error handling of
> private_to_shared failure. Previously, we thought it would never be able
> to fail, but right now, it is possible in corner cases (e.g. -ENOMEM) in
> set_attribute_private(). At present, I simply raise an assert instead of
> adding any rollback work (see patch 11).

Do the pages need to be pinned when converting them to a shared state
and unpinned when converting to a private state? Or is this handled
within the vfio_state_change_notify callbacks?

Thanks,
baolu

