Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE9F7D6CFF
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 03:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbfJOBrr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 21:47:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:57388 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbfJOBrq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 21:47:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 18:47:46 -0700
X-IronPort-AV: E=Sophos;i="5.67,297,1566889200"; 
   d="scan'208";a="189204875"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.239.196.183]) ([10.239.196.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 14 Oct 2019 18:47:43 -0700
Subject: Re: [PATCH v2 2/4] perf/core: Provide a kernel-internal interface to
 pause perf_event
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, wei.w.wang@intel.com, kan.liang@intel.com,
        like.xu@intel.com, ehankland@google.com, arbel.moshe@oracle.com,
        linux-kernel@vger.kernel.org
References: <20191013091533.12971-1-like.xu@linux.intel.com>
 <20191013091533.12971-3-like.xu@linux.intel.com>
 <20191014115158.GC2328@hirez.programming.kicks-ass.net>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <1aa1fa7e-6d06-3ab0-f9f9-9e90c9c0921c@linux.intel.com>
Date:   Tue, 15 Oct 2019 09:47:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191014115158.GC2328@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019/10/14 19:51, Peter Zijlstra wrote:
> On Sun, Oct 13, 2019 at 05:15:31PM +0800, Like Xu wrote:
>> Exporting perf_event_pause() as an external accessor for kernel users (such
>> as KVM) who may do both disable perf_event and read count with just one
>> time to hold perf_event_ctx_lock. Also the value could be reset optionally.
> 
>> +u64 perf_event_pause(struct perf_event *event, bool reset)
>> +{
>> +	struct perf_event_context *ctx;
>> +	u64 count, enabled, running;
>> +
>> +	ctx = perf_event_ctx_lock(event);
> 
>> +	_perf_event_disable(event);
>> +	count = __perf_event_read_value(event, &enabled, &running);
>> +	if (reset)
>> +		local64_set(&event->count, 0);
> 
> This local64_set() already assumes there are no child events, so maybe
> write the thing like:
> 
> 	WARN_ON_ONCE(event->attr.inherit);
> 	_perf_event_disable(event);
> 	count = local64_read(&event->count);
> 	local64_set(&event->count, 0);
> 

Thanks. It looks good to me and I will apply this.

> 
>> +	perf_event_ctx_unlock(event, ctx);
>> +
>> +	return count;
>> +}
>> +EXPORT_SYMBOL_GPL(perf_event_pause);
> 

