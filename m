Return-Path: <kvm+bounces-51551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA29CAF881E
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:38:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3845D546EE0
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 06:38:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7554426159D;
	Fri,  4 Jul 2025 06:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lFASRjxK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E70E26156B
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 06:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751611111; cv=none; b=WXDPmU1fLCXwm2mIj7tCwsXqaia4fDS/IFdWadwpvfY8gIMabQs1RDW8gw/RsWXWqD425n3dNTnx2Yl1Bo7T3lJMNfC4ii5K0s8xvhe7RE8BKnucn/VGF9xVL7Ah+h545+VricwG7W1EVlvrsrLWKP7gn2CJEB2uusfPE7myyYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751611111; c=relaxed/simple;
	bh=bt+MTwmO3BdtCKtgNnE3EHY/qUg+x29ETWPNNozM6Uk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l5epQRkJPf4mecg4XfLpHehfKqFHFaQBV7koTvAFcSBVruR4dVMSpA5NsS/OYBCuowerqW1i5ePvDhcxb4wt/cKy2dwEzxAebHLEcnAWE54KylHSE+sS9n0KKt5/Q/eLG2p3Ab0VJMRqu2XL5Ah0QNWG2rHYnmHkCZxHeKAiQ44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lFASRjxK; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751611110; x=1783147110;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bt+MTwmO3BdtCKtgNnE3EHY/qUg+x29ETWPNNozM6Uk=;
  b=lFASRjxKUieDB4hLsYoHkkcB0ip+1pTN9D5tTNU2CTe4CzSn3n9NU/gg
   7T3gc+9jydzbb17ZxngtIa2Uwzcb59AtbyCeduW9A2lkoTgOdNv6y4zOJ
   I98Zu4BTIll8LU1fntEm9yhy3V/ZMVY2+azJsXmrRWyWbBi3kt6fQFSeb
   BhrO1cQ9YdbaniLNWf20O3rkpiuR4Bb4qoTFo2m4+HAQ8FGdsnEqTMh2h
   4hyLB+PXBmkpkqVkfoUWIrYFhVg0/INoVpYrGbtkKwFIwg05NHDRPLIpH
   IC2mpLzXZgzOfE7AwAiCw8yM0xOihhSF91WYtp/ArPp6JT3kjlby5/dAF
   Q==;
X-CSE-ConnectionGUID: Ovu/Z/omSJazFJB7vgQyaw==
X-CSE-MsgGUID: 5G5pb50FSMe/OYnRwSuCog==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="53868365"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="53868365"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 23:38:30 -0700
X-CSE-ConnectionGUID: YnxIqBSgSI+gHjnXHTDRRA==
X-CSE-MsgGUID: sJO6J26bS56wxee9BAsRiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="159118769"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 23:38:24 -0700
Message-ID: <e8d0edca-f79c-4d6c-b1a3-69ad506bf470@intel.com>
Date: Fri, 4 Jul 2025 14:38:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 28/39] accel: Expose and register
 generic_handle_interrupt()
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, Roman Bolshakov <rbolshakov@ddn.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>, Mads Ynddal <mads@ynddal.dk>,
 Fabiano Rosas <farosas@suse.de>, Laurent Vivier <lvivier@redhat.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Anthony PERARD <anthony@xenproject.org>, Paul Durrant <paul@xen.org>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Reinoud Zandijk <reinoud@netbsd.org>,
 Sunil Muthuswamy <sunilmut@microsoft.com>, kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org
References: <20250703173248.44995-1-philmd@linaro.org>
 <20250703173248.44995-29-philmd@linaro.org>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250703173248.44995-29-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/4/2025 1:32 AM, Philippe Mathieu-Daudé wrote:
> In order to dispatch over AccelOpsClass::handle_interrupt(),
> we need it always defined, 

It seems I can only understand it until I see the code to really require 
it to be mandatory.

But anyway, the change itself is correct.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> not calling a hidden handler under
> the hood. Make AccelOpsClass::handle_interrupt() mandatory.
> Expose generic_handle_interrupt() prototype and register it
> for each accelerator.

