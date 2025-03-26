Return-Path: <kvm+bounces-42012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ACFA4A70F99
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 04:37:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2847419A06B9
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 03:37:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B45A1624CE;
	Wed, 26 Mar 2025 03:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NiSidF1X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DD5B67A
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 03:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742960178; cv=none; b=dFIof9pW2QsQ845SknBiUnfDUtczjimoChQwQ8oMuNy4qJSjfxYMZXkIO4Cy0PUBwOQKHx5+cdthnL7Bh7v+9WleZlaMQXe1qUwPk/ZH5Z0ydTgYexgHfChpYQmMKSPFB2c8z08ubLa1zER5iYCFvOsDqjkNJF6l6h/SLMq8Du8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742960178; c=relaxed/simple;
	bh=5lbOm40wW6H+uY1VgylzfldJsVnXOZbIS8SjKrOhmx0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ij9El2GsrM8WkFi+W7wSZH5gbNcjeOnEiFgG2sDj99JoJILx1P9ZYMYXj9JDxHJRQhAmfQ1VRbUfmkUklTqTJUc4mko81KU5Xxy1BiINhsqSw3geR1Klmm16omioz9Bv+LlObrN0yYTJoEKkDWTC4KfQnkRPro6MuihpW/U2sIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NiSidF1X; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742960176; x=1774496176;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5lbOm40wW6H+uY1VgylzfldJsVnXOZbIS8SjKrOhmx0=;
  b=NiSidF1XY4Yli61gioQVWzE9z0abjvOCxmXTACyZ/UGbVOK2qZrpc+bd
   Vle3PMqJ0a17FB6Ysgok9BmmT1JG867m6/MXYXASKz/9ZLGctA9NjfmvX
   RE3ALSR6BwhXhqwZdFfgaevVOmZg6m61tzXD8wyYlRMlq1Z2p8Vy+8Eqp
   LbQ+pY+1iJD/i+ZyNVAE52kiUtxYi46u7fAKisQOla+cEGZY601Ziojzl
   SrxxH9QDCVUmgAw77H2gaj9SBBf0XGsMKrXuCgns0g50dcLwmtdP+Ft9i
   69zuSfmt+CKPf6pcncKmyQp4JVVc307FYAY/knbZLlng+X055lVlmtRHg
   A==;
X-CSE-ConnectionGUID: 7Z5PhV7qQn+jYArZDM05qg==
X-CSE-MsgGUID: 68GXXeSPQKWhkM0h+o5f2g==
X-IronPort-AV: E=McAfee;i="6700,10204,11384"; a="31834299"
X-IronPort-AV: E=Sophos;i="6.14,276,1736841600"; 
   d="scan'208";a="31834299"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2025 20:36:15 -0700
X-CSE-ConnectionGUID: cO75iQ3uQiqwaOIRS8hllg==
X-CSE-MsgGUID: yWYrdEgdTSSYrnuCQi16YA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,276,1736841600"; 
   d="scan'208";a="129723204"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2025 20:36:12 -0700
Message-ID: <81e9d055-377c-4521-9588-a6bad60b3a6d@intel.com>
Date: Wed, 26 Mar 2025 11:36:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 52/52] docs: Add TDX documentation
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Igor Mammedov <imammedo@redhat.com>, Zhao Liu <zhao1.liu@intel.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>,
 Marcelo Tosatti <mtosatti@redhat.com>, Huacai Chen <chenhuacai@kernel.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Francesco Lavra <francescolavra.fl@gmail.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
 <20250124132048.3229049-53-xiaoyao.li@intel.com>
 <Z-L6CSajU284qAJ4@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <Z-L6CSajU284qAJ4@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/26/2025 2:46 AM, Daniel P. Berrangé wrote:
> On Fri, Jan 24, 2025 at 08:20:48AM -0500, Xiaoyao Li wrote:
>> Add docs/system/i386/tdx.rst for TDX support, and add tdx in
>> confidential-guest-support.rst
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
> 
>> ---
>>   docs/system/confidential-guest-support.rst |   1 +
>>   docs/system/i386/tdx.rst                   | 156 +++++++++++++++++++++
>>   docs/system/target-i386.rst                |   1 +
>>   3 files changed, 158 insertions(+)
>>   create mode 100644 docs/system/i386/tdx.rst
> 
> 
>> +Launching a TD (TDX VM)
>> +-----------------------
>> +
>> +To launch a TD, the necessary command line options are tdx-guest object and
>> +split kernel-irqchip, as below:
>> +
>> +.. parsed-literal::
>> +
>> +    |qemu_system_x86| \\
>> +        -object tdx-guest,id=tdx0 \\
>> +        -machine ...,kernel-irqchip=split,confidential-guest-support=tdx0 \\
>> +        -bios OVMF.fd \\
>> +
>> +Restrictions
>> +------------
>> +
>> + - kernel-irqchip must be split;
> 
> Is there a reason why we don't make QEMU set kernel-irqchip=split
> automatically when tdx-guest is enabled ?
> 
> It feels silly to default to a configuration that is known to be
> broken with TDX. I thought about making libvirt automatically
> set kernel-irqchip=split, or even above that making virt-install
> automatically set it. Addressing it in QEMU would seem the most
> appropriate place though.

For x86, if not with machine older than machine-4.0, the default 
kernel_irqchip is set to split when users don't set a value explicitly:

  if (s->kernel_irqchip_split == ON_OFF_AUTO_AUTO) {
         s->kernel_irqchip_split = mc->default_kernel_irqchip_split ? 
ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
     }


I think QEMU should only set it to split automatically for TDX guest 
when users don't provide a explicit value. And current code just works 
as expected.

Further, I think we can at least add the check in tdx_kvm_init() like this

if (kvm_state->kernel_irqchip_split != ON_OFF_AUTO_ON) {
	error_setg(errp, "TDX VM requires kernel_irqchip to be split");
	return -EINVAL;
}

Are you OK with it?

> 
> With regards,
> Daniel


