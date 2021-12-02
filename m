Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF93466008
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 09:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240807AbhLBI7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 03:59:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:12358 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229891AbhLBI7b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 03:59:31 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10185"; a="234173597"
X-IronPort-AV: E=Sophos;i="5.87,281,1631602800"; 
   d="scan'208";a="234173597"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 00:56:09 -0800
X-IronPort-AV: E=Sophos;i="5.87,281,1631602800"; 
   d="scan'208";a="513105132"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.31.236]) ([10.255.31.236])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 00:56:05 -0800
Message-ID: <ee4934e1-e1e6-68dd-df67-424783c0f812@intel.com>
Date:   Thu, 2 Dec 2021 16:56:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.2
Subject: Re: [RFC PATCH v2 11/44] i386/tdx: Implement user specified tsc
 frequency
Content-Language: en-US
To:     Connor Kuehl <ckuehl@redhat.com>, isaku.yamahata@gmail.com,
        qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, seanjc@google.com,
        erdemaktas@google.com
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <564e6ae089c30aaba9443294ecca72da9ee7b7c4.1625704981.git.isaku.yamahata@intel.com>
 <42187f1c-26b5-b039-8fcf-f9268129feb8@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <42187f1c-26b5-b039-8fcf-f9268129feb8@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/23/2021 1:53 AM, Connor Kuehl wrote:
> On 7/7/21 7:54 PM, isaku.yamahata@gmail.com wrote:
>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>>
>> Reuse -cpu,tsc-frequency= to get user wanted tsc frequency and pass it
>> to KVM_TDX_INIT_VM.
>>
>> Besides, sanity check the tsc frequency to be in the legal range and
>> legal granularity (required by SEAM module).
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> ---
>> [..]
>> +    if (env->tsc_khz && (env->tsc_khz < TDX1_MIN_TSC_FREQUENCY_KHZ ||
>> +                         env->tsc_khz > TDX1_MAX_TSC_FREQUENCY_KHZ)) {
>> +        error_report("Invalid TSC %ld KHz, must specify cpu_frequecy 
>> between [%d, %d] kHz\n",
> 
> s/frequecy/frequency

will fix it, thanks!

>> +                      env->tsc_khz, TDX1_MIN_TSC_FREQUENCY_KHZ,
>> +                      TDX1_MAX_TSC_FREQUENCY_KHZ);
>> +        exit(1);
>> +    }
>> +
>> +    if (env->tsc_khz % (25 * 1000)) {
>> +        error_report("Invalid TSC %ld KHz, it must be multiple of 
>> 25MHz\n", env->tsc_khz);
> 
> Should this be 25KHz instead of 25MHz?

No. It equals to

	(evn->tsc_khz * 1000) % (25 * 1000 * 1000)




