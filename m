Return-Path: <kvm+bounces-24490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E9009567D4
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 12:07:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 816541C217A7
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 10:07:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C37EE15ECC2;
	Mon, 19 Aug 2024 10:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oCGPu7lZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22AD15E5CC;
	Mon, 19 Aug 2024 10:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724062069; cv=none; b=Vi6ClcUjnQqKYOcpK+1V8n4omLjyKo5cRzQ3f3vYdrt5hJoDrVJQeM0FKYkn6CQFcWHuHraMpHy/4+PTt0tEXbkQ6UFRwXMfCqDpPCpJaVtlV8cS+cWaniYbpwim/Aq8EyMlmZYIjtOW+BwNPEiwk0Vm9jFqcDC1WyMmy7SMVPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724062069; c=relaxed/simple;
	bh=hMLwmV1v/iwXdwcJc2K1nRaG3kj40a02vTxJYTegd3I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rgHimSAVrlX6TEQ1Rn5jV5EwC5nfddxwRZNmLfrWWKLt2+tg76LiQD/bipqEsLt0k09C3TZmOzUvHF2XeSJwAXyOdtJa2jtpKODeCZud4E2QBZvEkMTGgGw+4PxKJFiRasRI0gwLcsPmjIU1TLuvuHImosV8Emrk/YXfjWRTh08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oCGPu7lZ; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724062067; x=1755598067;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hMLwmV1v/iwXdwcJc2K1nRaG3kj40a02vTxJYTegd3I=;
  b=oCGPu7lZiKL9hkD+ROVQOAZ7OunfSDiyUFml4dzI7hnw9YGqTDjQZQVn
   TfFt2ELH8QiXnivu2NNEhUJ8JbBHvv9VWlSiqxTe5ktieBkdC/X/Vj+pm
   uUk2/QXQXf+CTQXTYP37CFwRcic2mPqLKV865x7XiJHBDAWnV48wfX2HX
   TfzqCLqnD1LZrHz1/xp69VtEZnSCQpbtF5+VKhtpV5DbMFWaZNBwxXWT6
   VeK0lKG0xDxwTFhTHG7punWmv6kind9aYc9RM34h0bskMI3x2weNBb+KR
   vCKv15t5XCElGqd8bIlsvhwslfsE/w3inG4uM30DZuqKxylecD6ofwLZk
   g==;
X-CSE-ConnectionGUID: hximKZjrTCGnJkeNOnBGKQ==
X-CSE-MsgGUID: 5/BuEUC/Qa675YJZaTYMGA==
X-IronPort-AV: E=McAfee;i="6700,10204,11168"; a="26055547"
X-IronPort-AV: E=Sophos;i="6.10,158,1719903600"; 
   d="scan'208";a="26055547"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2024 03:07:46 -0700
X-CSE-ConnectionGUID: bSSWweMTQbWB3unOWmvT6A==
X-CSE-MsgGUID: kwFJA890TW2/VfWWeG4Gmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,158,1719903600"; 
   d="scan'208";a="60306323"
Received: from unknown (HELO [10.238.8.207]) ([10.238.8.207])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2024 03:07:45 -0700
Message-ID: <d7995584-f844-4a05-99d7-a3a85ef11516@linux.intel.com>
Date: Mon, 19 Aug 2024 18:07:42 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] KVM: x86: Use is_kvm_hc_exit_enabled() instead of
 opencode
To: "Huang, Kai" <kai.huang@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 seanjc@google.com, isaku.yamahata@intel.com, rick.p.edgecombe@intel.com,
 michael.roth@amd.com
References: <20240813051256.2246612-1-binbin.wu@linux.intel.com>
 <20240813051256.2246612-3-binbin.wu@linux.intel.com>
 <0b27494f-7ce0-4ca7-8238-cb95999b3142@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <0b27494f-7ce0-4ca7-8238-cb95999b3142@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 8/14/2024 7:18 AM, Huang, Kai wrote:
>
>
> On 13/08/2024 5:12 pm, Binbin Wu wrote:
>> Use is_kvm_hc_exit_enabled() instead of opencode.
>>
>> No functional change intended.
>
> It would be helpful to mention currently hypercall_exit_enabled can 
> only have KVM_HC_MAP_GPA_RANGE bit set (so that there will be no 
> functional change).
I think it's not needed, because is_kvm_hc_exit_enabled() takes the input.
It just replaces the opencode with a helper API.

Maybe your comment was for the patch 1?

>
>>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
>
Thanks for your review.

