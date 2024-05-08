Return-Path: <kvm+bounces-16983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CDEC88BF7AB
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 09:51:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B53B1C20C70
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 07:51:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D43CE3F8D6;
	Wed,  8 May 2024 07:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CtCbvi31"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758292C6B2
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 07:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715154661; cv=none; b=hbFMLIeHDeGOQzMKXyR8kIMP3kxYlmESQCIKUdNByUnr4AGt0k6WchfFaC1NsRLSmrkKfZRWjy5Z1VWMeYV5CBGWYn8d+4oAFs/mm7Ip//Y+CwWim1rV6h6ClBoKxshbtw1miRsTv9KeepXAacjgm2u0LXeY65h4/iXqGq6P+sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715154661; c=relaxed/simple;
	bh=zzEfmZ/dJmIjdWYZLr302I3iYwcl4ehqIfY6gL+Ct2Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oymMnZjLmf3VLOGa9SLqIKg7Ak5gJXIvLjdIGh7hiWhTA3p7+wAGQWC/1of75LORhQhMcgLe81NoaVTio9KT51rA8Z0xep4HHdjW1Kk4VYYf/ugTrXYgNRZEBD1cVJqoPd6FEq9xUhKlTEhA6f5V0VQrJNSX6OQbARbrzqA7Zqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CtCbvi31; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715154660; x=1746690660;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zzEfmZ/dJmIjdWYZLr302I3iYwcl4ehqIfY6gL+Ct2Q=;
  b=CtCbvi31+MFf+8qIPEZFsNP6hEZ95wO9zKpqVvJ7OtcNIC1G/0ivUnxb
   jRrconjqIBnSOt7aJxhsw5gGNA2K2c5XcifiTV8C2QG5ghHE1CUJP5f+K
   5NvqW3tQ9c2db5FpsWPIOtaW+31KdveTR+0qOuSFCnIABtyBCphosACPS
   LCXEDnPDIghc73UIUtyvcqDU/sSnSaBr3uAUWfmqy+WgfVec1QG6ojDPG
   /1G0Lan0E711cU3iLzjU1f8GfXeImsVXOHy3s6xIxIX37GoK51vFphKvE
   byXzFLR0R0QXrAO40P/myODtqCCkhYvVqmk+nol4Rx93+nn/yLuXhLjPy
   g==;
X-CSE-ConnectionGUID: 3lwD/cEORmyz2j7wB41eWA==
X-CSE-MsgGUID: Ml98EUvzTdaIcFsXGECv9Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="11423785"
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="11423785"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 00:50:57 -0700
X-CSE-ConnectionGUID: A4w1oc3+Skq2wawLzbV1IA==
X-CSE-MsgGUID: dOvri4tmQ5KuStHL37xYPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="29331639"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.227.51]) ([10.124.227.51])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 00:50:56 -0700
Message-ID: <193c8685-2bb8-46ec-9e34-72fd70300d15@intel.com>
Date: Wed, 8 May 2024 15:50:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] TDX module configurability of 0x80000008
To: Sean Christopherson <seanjc@google.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>
References: <f9f1da5dc94ad6b776490008dceee5963b451cda.camel@intel.com>
 <6e0dc5f2-169e-4277-b7fe-e69234ccc1fd@intel.com>
 <Zjpg3dhf0mWetkSE@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <Zjpg3dhf0mWetkSE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/8/2024 1:11 AM, Sean Christopherson wrote:
> On Wed, May 08, 2024, Xiaoyao Li wrote:
>> On 4/25/2024 12:55 AM, Edgecombe, Rick P wrote:
>>> One of the TDX module features is called MAXPA_VIRT. In short, it is similar to
>>> KVM’s allow_smaller_maxphyaddr. It requires an explicit opt-in by the VMM, and
>>> allows a TD’s 0x80000008.EAX[7:0] to be configured by the VMM. Accesses to
>>> physical addresses above the specified value by the TD will cause the TDX module
>>> to inject a mostly correct #PF with the RSVD error code set. It has to deal with
>>> the same problems as allow_smaller_maxphyaddr for correctly setting the RSVD
>>> bit. I wasn’t thinking to push this feature for KVM due the movement away from
>>> allow_smaller_maxphyaddr and towards 0x80000008.EAX[23:16].
>>>
>>
>> I would like to get your opinion of the MAXPA_VIRT feature of TDX. What is
>> likely the KVM's decision on it? Won't support it due to it has the same
>> limitation of allow_smaller_maxphyaddr?
> 
> Not supporting MAXPA_VIRT has my vote.  I'm of the opinion that allow_smaller_maxphyaddr
> should die a horrible, fiery death :-)

Thanks for the response. It's good to know your preference.

I'm not sure if there is any user of "allow_smaller_maxphyaddr". On QEMU 
side, it doesn't check it nor rely on it. QEMU always allow the user to 
configure a smaller PA.

