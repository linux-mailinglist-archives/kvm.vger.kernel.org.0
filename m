Return-Path: <kvm+bounces-11785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D76D487B8AA
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 08:46:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1588F1C230D7
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 07:46:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09A9A5CDE6;
	Thu, 14 Mar 2024 07:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jz0lOh20"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6366C5C8E1;
	Thu, 14 Mar 2024 07:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710402362; cv=none; b=JAfsCJupCnkZ7xc01Sc0TEGTU+TMsxzs0cT2CXVFFLTJzDt7EG/uaXjg0jaXE0Cw06Vnjtrydcno1oXCFKPKSOC5ZkzBvOXQoWg/ypYwcnz378MvByhGIOjGntx0HRcXDq58YO5E4wo5HmNCQjbgxvzvT8pI4xxk5NKpSiMsS5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710402362; c=relaxed/simple;
	bh=+12a9Ym6krS0ceAODUt6qno/X9iDB65b21T7phg714I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e7+YnhQ19t2Z9O1Zk0I35MqBGcQtHLEJKYV8tMlWxkrHUh4vPLk/5Ov0brhrPTIjweFgtzobsr/zGChuhqdO50W4XEgJ1TsiAXAZnZRZfxbL0Y7UlqO3VhRKUh99HPqDTf0VvnKcSbkOvW0paeFBtHctGeG3VhIasCOlOf7uYgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jz0lOh20; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710402361; x=1741938361;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+12a9Ym6krS0ceAODUt6qno/X9iDB65b21T7phg714I=;
  b=jz0lOh20JO51GUWg6RwcbdzEwGgaouU0uGhRzd7M4siRSq2PHcBVKK+P
   sLGvWGc72WH+Gn/yF4b4j/jUJrnr0MynF6/dlchCxsSN/bj7NEs+tHLO1
   II+/KRWHx4LGITYN43p4SdRDbF3T8X/Mhw5SQoOrMb88eHgzyLvfFN36V
   nbXboTS05gHW/YPPm+3tRjbX8wWc36oBP4zO2jMhqvaQO5Os3F4p9BrtR
   JqNCN+FIS27WlZmMzVj6zsXZaiJoHFsvTWYQU9Wr8OTSXB3fSSCVUK7OP
   0b8jO70/YYh5CPUEZ0RAgNRncPRpBruCThGPfMrAfa9shwGaLPREuozY1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11012"; a="30645114"
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="30645114"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 00:45:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="16799150"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.242.47]) ([10.124.242.47])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 00:45:52 -0700
Message-ID: <ce00c848-16eb-4276-8f8c-03a97fcb4d86@linux.intel.com>
Date: Thu, 14 Mar 2024 15:45:49 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 028/130] KVM: TDX: Add TDX "architectural" error codes
To: Isaku Yamahata <isaku.yamahata@linux.intel.com>, isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Yuan Yao <yuan.yao@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <ae0b961d80ab90e43c6eff4a675e00ff80ab3b9f.1708933498.git.isaku.yamahata@intel.com>
 <20240226192757.GS177224@ls.amr.corp.intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240226192757.GS177224@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/27/2024 3:27 AM, Isaku Yamahata wrote:
> On Mon, Feb 26, 2024 at 12:25:30AM -0800,
> isaku.yamahata@intel.com wrote:
>
>> diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
>> index fdfd41511b02..28c4a62b7dba 100644
>> --- a/arch/x86/include/asm/shared/tdx.h
>> +++ b/arch/x86/include/asm/shared/tdx.h
>> @@ -26,7 +26,13 @@
>>   #define TDVMCALL_GET_QUOTE		0x10002
>>   #define TDVMCALL_REPORT_FATAL_ERROR	0x10003
>>   
>> -#define TDVMCALL_STATUS_RETRY		1
> Oops, I accidentally removed this constant to break tdx guest build.

Is this the same as "TDVMCALL_RETRY" added in the patch? Since both tdx 
guest code and VMM share the same header file, maybe it needs another 
patch to change the code in guest or you just follow the naming style of 
the exist code?
>
> diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
> index ef1c8e5a2944..1367a5941499 100644
> --- a/arch/x86/include/asm/shared/tdx.h
> +++ b/arch/x86/include/asm/shared/tdx.h
> @@ -28,6 +28,8 @@
>   #define TDVMCALL_REPORT_FATAL_ERROR    0x10003
>   #define TDVMCALL_SETUP_EVENT_NOTIFY_INTERRUPT  0x10004
>   
> +#define TDVMCALL_STATUS_RETRY          1
> +
>   /*
>    * TDG.VP.VMCALL Status Codes (returned in R10)
>    */


