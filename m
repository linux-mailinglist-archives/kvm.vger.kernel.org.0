Return-Path: <kvm+bounces-47737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D02F4AC45E8
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 03:31:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 937A9189AE1F
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 01:31:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCF9D84039;
	Tue, 27 May 2025 01:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LX2waA6I"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD938F58
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 01:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748309467; cv=none; b=MMQCioYs8he4JYh/p3zk7wTrU+A4RexlpYbBOZVyKG+qGJQN/e0t3KmgafE/KYW6b0+gvCje81Zf8beBRy12DggI6TRmbPbFeRFD/mXk3HU2koqwKyi8NV0RsjSW51ql+vrUU2mB7iE99+WbW9bmOzla5eKsrEBdVBPTbBGVV9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748309467; c=relaxed/simple;
	bh=4CHpPyApsEzS/X3qk79JB1N8Nzcn1UsPrbhnlZZ587s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ewa2wvaISAlY/xjPTHHdGtfHEEgu0gQ37m22tWpfGfQBzTJ56AdqXTz4Wimz64LtkIYKhmgPOC+E9dF0KpE8rdGI7TiUMKv7/yCguwXiuWl9jcy5/lxHWWWFJw80KOhSBw1AsuNzl+aYIKA92wD4PRCloFFfVp4mfhbDLufK92Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LX2waA6I; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748309461; x=1779845461;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4CHpPyApsEzS/X3qk79JB1N8Nzcn1UsPrbhnlZZ587s=;
  b=LX2waA6IbwqqwxrrcWuQ6gJ4hfe9lrjMOiEotn5omfs5c0rD6zAAEFrU
   urNvQEMhVHNDf6KmmbS1eFHqCJ2jLk0kk2K+9q2dnc5vhLw3/3QXatBl1
   JMKvv0L3djoK6zMQO1jxwQpEiuqmuGPjVuWkvGNOlA/tt5U14CaSwnFWN
   65ZQs8ovN6Mfj3lFYLkuGZds4FH6Ms0l6oJLswvU6naBzeJKE0qSob+iy
   qU5c2Po+sVEeaWQDCLdxkXYZlh6hFKFg42qE/mPA/1Gfov7rUq3uHx+fR
   2SCuNnYZ3XAfzCV5uOfX3CRP0IQbsc4IG6VQnTJDjAymTHqe5tNPfXKHs
   w==;
X-CSE-ConnectionGUID: IVgbUdH5S/Kub4toHpVOlw==
X-CSE-MsgGUID: NGLocvuRTVehtY3VoH6Q3Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11445"; a="75675637"
X-IronPort-AV: E=Sophos;i="6.15,317,1739865600"; 
   d="scan'208";a="75675637"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2025 18:31:00 -0700
X-CSE-ConnectionGUID: qpfWMxfQQ++z01pNUrR2PQ==
X-CSE-MsgGUID: /p9csET5T/e2dticvOWiQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,317,1739865600"; 
   d="scan'208";a="147347854"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2025 18:30:57 -0700
Message-ID: <792cbff4-6d25-4f39-8a18-3f7affdfe5cd@intel.com>
Date: Tue, 27 May 2025 09:30:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/55] QEMU TDX support
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Gerd Hoffmann <kraxel@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
 Markus Armbruster <armbru@redhat.com>,
 Francesco Lavra <francescolavra.fl@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Zhao Liu <zhao1.liu@intel.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
 <e994b189-d155-44d0-ae7d-78e72f3ae0de@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <e994b189-d155-44d0-ae7d-78e72f3ae0de@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/27/2025 12:12 AM, Paolo Bonzini wrote:
> On 5/8/25 16:59, Xiaoyao Li wrote:
>> This is the v9 series of TDX QEMU enabling. The series is also available
>> at github:
>> https://github.com/intel-staging/qemu-tdx/tree/tdx-qemu-upstream-v9
>>
>> Note, this series has a dependency on
>> https://lore.kernel.org/qemu-devel/20241217123932.948789-1- 
>> xiaoyao.li@intel.com/
>>
>> =============
>> Changes in v9
>>
>> Comparing to v8, no big change in v9.
>>
>> V9 mainly collects Reviewed-by tags from Daniel and Zhao Liu (Thanks to
>> their review!) and v9 does some small change according to the review
>> feedback of them. Please see the individual patch for the detailed
>> change history.
> 
> Queued, thanks for your patience - this was a huge effort.
> 
> I'll wait until the kernel side is picked up and then send the pull 
> request.

Thanks, Paolo!

And thanks to Gerd Hoffmann, Daniel, Markus, Zhao Liu, ... and all the 
people who helped review and provided valuable feedback.

> Paolo
> 


