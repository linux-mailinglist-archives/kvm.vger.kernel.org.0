Return-Path: <kvm+bounces-7644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 11EE5844EC5
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 02:41:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 790271F2E082
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 01:41:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 290EC4C7E;
	Thu,  1 Feb 2024 01:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AQmIM7Nr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F3F524B;
	Thu,  1 Feb 2024 01:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706751672; cv=none; b=WcK30kzqZt5cdQn7ag4QffJYpEy/vNOvNELxV5rABZ5PtsbiGq66PQmRkp1pgek9k3pbL0oV6yshAYhMmeJ2hLCPjN+MnxSQBcoEBKgGYFZe4MoKH0RUj73XniQBEYT3mQP2o3hAJQlUvBalebuUwnQV4wLPbWSuYZmMSCESV30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706751672; c=relaxed/simple;
	bh=wjNPj8TpVPxMj33O6Zocl9vYBSzey858v7bzOGiD7a0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BhGPOpDsxZCZNwrKXHF8ZIdgG/KhaMlaRs4At+E5p/m6StpwA2LyWBQONkLKprBbjtkPORCajKz6+pPQ57ND16ew7BLEL73xI36Wk6rDk3nGzU2znDi0a4caZbVAeZYh89akj6YgrlXkMQRuZFCEGHE3LYYg956RCjuQoj4NuGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AQmIM7Nr; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706751670; x=1738287670;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wjNPj8TpVPxMj33O6Zocl9vYBSzey858v7bzOGiD7a0=;
  b=AQmIM7NrzxkUtGiADWRSWNNQU2K+7z+ssFO94rEaAb8x1Bb5hfDGoyz1
   kjr4ViWLvGP2TIpBkdbGFC7Lrq4z1a3FaWw0/5lgsUEfrem+KtFaonb9r
   DNSH/r/kCCMEl/qHzt+vTewgrF/3UJ5RDkoTDngejKJ2/gOOZPiCwpV7G
   xjUZEAU4eynG9Tj6g+oxK/WzbtFRMByE247WrElyDgy9RmZeqZ8NziYF3
   js756piO67MpiW4lE7sFs8JIWJFnlfTpYQSQ61F7Rrmna08fzhnQGItU+
   RvtBkMmehbq1Y5qR7/kN2dL1Pjj0Ffy5HoEujRg/ODze4ZVl4nM1SjtbB
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="17164929"
X-IronPort-AV: E=Sophos;i="6.05,233,1701158400"; 
   d="scan'208";a="17164929"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 17:41:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,233,1701158400"; 
   d="scan'208";a="4272686"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.33.17]) ([10.93.33.17])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 17:41:05 -0800
Message-ID: <9b1ca7cc-1a16-4bab-8398-f9bdc4bc23cb@intel.com>
Date: Thu, 1 Feb 2024 09:41:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 006/121] KVM: x86/vmx: Refactor KVM VMX module
 init/exit functions
Content-Language: en-US
To: isaku.yamahata@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <f6c59ec1b4822263fc946b7d53a83f3b5ba59261.1705965634.git.isaku.yamahata@intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <f6c59ec1b4822263fc946b7d53a83f3b5ba59261.1705965634.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/23/2024 7:52 AM, isaku.yamahata@intel.com wrote:

...

> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index b6836bedc4d3..b936388853ab 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -6,11 +6,24 @@
>   
>   #include "x86.h"
>   
> -__init int vmx_hardware_setup(void);

...

>   
> +__init int vmx_hardware_setup(void);

this change belongs to Patch 4

>   void vmx_hardware_unsetup(void);
>   int vmx_check_processor_compat(void);
>   int vmx_hardware_enable(void);


