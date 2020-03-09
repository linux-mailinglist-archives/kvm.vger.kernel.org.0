Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6895B17E865
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 20:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgCIT2i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 15:28:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:1482 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbgCIT2i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 15:28:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Mar 2020 12:28:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,534,1574150400"; 
   d="scan'208";a="235693532"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga008.fm.intel.com with ESMTP; 09 Mar 2020 12:28:37 -0700
Received: from [10.251.21.146] (kliang2-mobl.ccr.corp.intel.com [10.251.21.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 964265802A3;
        Mon,  9 Mar 2020 12:28:33 -0700 (PDT)
Subject: Re: [PATCH v1 01/11] perf/x86/core: Support KVM to assign a dedicated
 counter for guest PEBS
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Luwei Kang <luwei.kang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mingo@redhat.com, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, tglx@linutronix.de, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        pawan.kumar.gupta@linux.intel.com, ak@linux.intel.com,
        thomas.lendacky@amd.com, fenghua.yu@intel.com,
        like.xu@linux.intel.com
References: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
 <1583431025-19802-2-git-send-email-luwei.kang@intel.com>
 <20200306135317.GD12561@hirez.programming.kicks-ass.net>
 <b72cb68e-1a0a-eeff-21b4-ce412e939cfd@linux.intel.com>
 <20200309100443.GG12561@hirez.programming.kicks-ass.net>
 <97ce1ba4-d75a-8db2-ea2f-7d334942b4e6@linux.intel.com>
 <20200309150526.GI12561@hirez.programming.kicks-ass.net>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Message-ID: <45a1a575-9363-f778-b5f5-bcdf28d3e34b@linux.intel.com>
Date:   Mon, 9 Mar 2020 15:28:31 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200309150526.GI12561@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/9/2020 11:05 AM, Peter Zijlstra wrote:
>> In the new proposal, KVM user is treated the same as other host events with
>> event constraint. The scheduler is free to choose whether or not to assign a
>> counter for it.
> That's what it does, I understand that. I'm saying that that is creating
> artificial contention.
> 
> 
> Why is this needed anyway? Can't we force the guest to flush and then
> move it over to a new counter?

KVM only traps the MSR access. There is no MSR access during the 
scheduling in guest.
KVM/host only knows the request counter, when guest tries to enable the 
counter. It's too late for guest to start over.

Regarding to the artificial contention, as my understanding, it should 
rarely happen in practical.
Cloud vendors have to explicitly set pebs option in qemu to enable PEBS 
support for guest. They knows the environment well. They can avoid the 
contention. (We may implement some patches for qemu/KVM later to 
temporarily disable PEBS in runtime if they require.)

For now, I think we may print a warning when both host and guest require 
the same counter. Host can get a clue from the warning.

Thanks,
Kan
