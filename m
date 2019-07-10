Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8212F6436D
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 10:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfGJIQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 04:16:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:62928 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726710AbfGJIQQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 04:16:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 01:16:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,473,1557212400"; 
   d="scan'208";a="173797444"
Received: from unknown (HELO [10.239.13.7]) ([10.239.13.7])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Jul 2019 01:16:14 -0700
Message-ID: <5D25A019.6080708@intel.com>
Date:   Wed, 10 Jul 2019 16:21:45 +0800
From:   Wei Wang <wei.w.wang@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.7.0
MIME-Version: 1.0
To:     Peter Zijlstra <peterz@infradead.org>
CC:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, ak@linux.intel.com, kan.liang@intel.com,
        mingo@redhat.com, rkrcmar@redhat.com, like.xu@intel.com,
        jannh@google.com, arei.gonglei@huawei.com, jmattson@google.com
Subject: Re: [PATCH v7 08/12] KVM/x86/vPMU: Add APIs to support host save/restore
 the guest lbr stack
References: <1562548999-37095-1-git-send-email-wei.w.wang@intel.com> <1562548999-37095-9-git-send-email-wei.w.wang@intel.com> <20190709114554.GW3402@hirez.programming.kicks-ass.net>
In-Reply-To: <20190709114554.GW3402@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/09/2019 07:45 PM, Peter Zijlstra wrote:
>
>> +	 * config:        Actually this field won't be used by the perf core
>> +	 *                as this event doesn't have a perf counter.
>> +	 * sample_period: Same as above.
> If it's unused; why do we need to set it at all?

OK, we'll remove the unused fields.

>
>> +	 * sample_type:   tells the perf core that it is an lbr event.
>> +	 * branch_sample_type: tells the perf core that the lbr event works in
>> +	 *                the user callstack mode so that the lbr stack will be
>> +	 *                saved/restored on vCPU switching.
> Again; doesn't make sense. What does the user part have to do with
> save/restore? What happens when this vcpu thread drops to userspace for
> an assist?

This is a fake event which doesn't run the lbr on the host.
Returning to userspace doesn't need save/restore lbr, because userspace
wouldn't change those lbr msrs.

The event is created to save/restore lbr msrs on vcpu switching.
Host perf only do this save/restore for "user callstack mode" lbr event, 
so we
construct the event to be "user callstack mode" to reuse the host lbr 
save/restore.

An alternative method is to have KVM vcpu sched_in/out callback
save/restore those msrs, which don't need to create this fake event.

Please let me know if you prefer the second method.

Best,
Wei
