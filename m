Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6114130B7E3
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 07:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhBBGcG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 01:32:06 -0500
Received: from mga03.intel.com ([134.134.136.65]:13447 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232130AbhBBGcF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 01:32:05 -0500
IronPort-SDR: CCs6/JuOJrw1cDAfJV0nTTLqAzF1beYT+iWVG0TDzFw5MJOCCf1xrznMxu2WVaqcdVZ41hqpxO
 hXsGh3j06daQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="180881759"
X-IronPort-AV: E=Sophos;i="5.79,394,1602572400"; 
   d="scan'208";a="180881759"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 22:31:22 -0800
IronPort-SDR: 8FniOqrO9Ivctu1xSYW+UdZ43i4NKweCiSiHG/IBLoH1S/pWXtf0qgBaD4enTrobJ/TDM5JFrh
 CLfR5ltdoGtA==
X-IronPort-AV: E=Sophos;i="5.79,394,1602572400"; 
   d="scan'208";a="370379554"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 22:31:18 -0800
Subject: Re: [PATCH v3 04/17] perf: x86/ds: Handle guest PEBS overflow PMI and
 inject it to guest
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <andi@firstfloor.org>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <20210104131542.495413-5-like.xu@linux.intel.com>
 <X/86UWuV/9yt14hQ@hirez.programming.kicks-ass.net>
 <9c343e40-bbdf-8af0-3307-5274070ee3d2@intel.com>
 <YAGEFgqQv281jVHc@hirez.programming.kicks-ass.net>
 <2c197d5a-09a8-968c-a942-c95d18983c9d@intel.com>
 <YAGqWNl2FKxVussV@hirez.programming.kicks-ass.net>
 <ed5b16cb-30c7-dab7-92c3-b70ba8483d1e@linux.intel.com>
 <YA6vy509FT8IUddS@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <22b30bc7-84d2-b251-e558-1d8095c76187@intel.com>
Date:   Tue, 2 Feb 2021 14:31:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YA6vy509FT8IUddS@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/1/25 19:47, Peter Zijlstra wrote:
> On Mon, Jan 25, 2021 at 04:26:22PM +0800, Like Xu wrote:
>
>> In the host and guest PEBS both enabled case,
>> we'll get a crazy dmesg *bombing* about spurious PMI warning
>> if we pass the host PEBS PMI "harmlessly" to the guest:
>>
>> [11261.502536] Uhhuh. NMI received for unknown reason 2c on CPU 36.
>> [11261.502539] Do you have a strange power saving mode enabled?
>> [11261.502541] Dazed and confused, but trying to continue
> How? AFAICT handle_pmi_common() will increment handled when
> GLOBAL_STATUS_BUFFER_OVF_BIT is set, irrespective of DS containing
> data.

Thanks for this comment, and it's enlightening.

For the case that both host and guest PEBS are enabled,
the host PEBS PMI will be injected into the guest only when
GLOBAL_STATUS_BUFFER_OVF_BIT is not set in the guest global_status.

>

