Return-Path: <kvm+bounces-51833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E1E9AFDE20
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:32:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2851A3A7B83
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:32:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1AB11FE45D;
	Wed,  9 Jul 2025 03:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YSViXEsv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED60194A44;
	Wed,  9 Jul 2025 03:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752031939; cv=none; b=ZBKgxEGYY0iFzJwrdsaJDpfelyzvsRgU06OOjXZX+zveUrbcoNZK8VSLxgFX/LqXo3GiTK8FIPKUjhn/N2M81G/5mYb9eqoZTN6vlINg+VqAJ7v4iiXMHLLsMD1welVZKe/azP+6VxFp2XPj0Lg3XSLPIa5mljRjCAu/bKUMC2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752031939; c=relaxed/simple;
	bh=1Pw8KyivSm4APrwkp5YnUtNQp3ayFykviGg3WVfhQzI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GmWkggC34wUi0Jbby5dGKb6B3UHzub17eJe2ma1cnOBVlD7krfsttfwjHOp/OxxsQHWLwjVE3kVuwlFxpaWwJdibVTyj8bqr/ULptf3FOnexTogE3mvpKkoVFhGD6A/CiGtYhrnrABztkiRQUQXPD43QPE6EsJFULhYL03s67Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YSViXEsv; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752031938; x=1783567938;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1Pw8KyivSm4APrwkp5YnUtNQp3ayFykviGg3WVfhQzI=;
  b=YSViXEsvhpQ7DSsHrv/ieYncbiIMmZ4yl5z2HI0+HCNBLnUm0QUobYuL
   W4DmbzSVM1Mpn/c9mbLuaEJlVag7nOAvIRmVVF0qa7maeI07rNsYViV91
   SBQb9g5os5+yJsZlvyRJODldXashiGGNrW7l7ZFRBMhF0/qeDdaGYIe6Q
   H2woR9Dz9VU1KZ5e0Rnj6MR2w/CgbgE2xu+Y8NxTTZE/Oobv3te/dmh9C
   AVFsFZt7Y8YG6ka+aZkbZW9ZH+NhdHueY3Gb5yBQTWXh70DR3TRsO/Us/
   jxcvJ60p1nTjGHbO6QruBY5DflAr+FoslvpvgaoITMJy8W6yAnqTPRiUG
   g==;
X-CSE-ConnectionGUID: dMXhehPnRkuopBSJ+uEJAw==
X-CSE-MsgGUID: Rz31AXkISnaK6jvhg0Jb0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="54138728"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="54138728"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 20:32:18 -0700
X-CSE-ConnectionGUID: M8ZxqpsMR7Szc4Ve2uCgkg==
X-CSE-MsgGUID: VuRcLl3hSI2nqboZfvW4IA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="159972471"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 20:32:12 -0700
Message-ID: <1f977a8e-0503-4596-93ea-720844451b09@intel.com>
Date: Wed, 9 Jul 2025 11:32:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] x86/tdx: Fix the typo of TDX_ATTR_MIGRTABLE
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "Hunter, Adrian" <adrian.hunter@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
 "Lindgren, Tony" <tony.lindgren@intel.com>, "bp@alien8.de" <bp@alien8.de>,
 "x86@kernel.org" <x86@kernel.org>
References: <20250708080314.43081-1-xiaoyao.li@intel.com>
 <20250708080314.43081-2-xiaoyao.li@intel.com>
 <a1bd44daa452356f4e763e4a980d075a831e2290.camel@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <a1bd44daa452356f4e763e4a980d075a831e2290.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/8/2025 10:20 PM, Edgecombe, Rick P wrote:
> On Tue, 2025-07-08 at 16:03 +0800, Xiaoyao Li wrote:
>> Fix the typo of TDX_ATTR_MIGRTABLE to TDX_ATTR_MIGRATABLE.
> 
> Can you add a little more. Something that explains the impact of the change.
> These names are stringified and printed out. So it will actually fix the dmesg
> output as well. But not any kind of machine readable proc or anything like that.

Good catch! I will add more in next version.

>>
>> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> 


