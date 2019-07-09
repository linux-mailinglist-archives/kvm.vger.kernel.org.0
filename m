Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2179062E70
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 05:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbfGIC6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 22:58:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:14717 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbfGIC6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jul 2019 22:58:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 19:58:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,469,1557212400"; 
   d="scan'208";a="173435531"
Received: from unknown (HELO [10.239.13.7]) ([10.239.13.7])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Jul 2019 19:58:51 -0700
Message-ID: <5D240435.2040801@intel.com>
Date:   Tue, 09 Jul 2019 11:04:21 +0800
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
References: <1562548999-37095-1-git-send-email-wei.w.wang@intel.com> <1562548999-37095-9-git-send-email-wei.w.wang@intel.com> <20190708144831.GN3402@hirez.programming.kicks-ass.net>
In-Reply-To: <20190708144831.GN3402@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/08/2019 10:48 PM, Peter Zijlstra wrote:
> On Mon, Jul 08, 2019 at 09:23:15AM +0800, Wei Wang wrote:
>> From: Like Xu <like.xu@intel.com>
>>
>> This patch adds support to enable/disable the host side save/restore
> This patch should be disqualified on Changelog alone...
>
>    Documentation/process/submitting-patches.rst:instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy

OK, we will discard "This patch" in the description:

To enable/disable the host side save/restore for the guest lbr stack on
vCPU switching, the host creates a perf event for the vCPU..

>> for the guest lbr stack on vCPU switching. To enable that, the host
>> creates a perf event for the vCPU, and the event attributes are set
>> to the user callstack mode lbr so that all the conditions are meet in
>> the host perf subsystem to save the lbr stack on task switching.
>>
>> The host side lbr perf event are created only for the purpose of saving
>> and restoring the lbr stack. There is no need to enable the lbr
>> functionality for this perf event, because the feature is essentially
>> used in the vCPU. So perf_event_create is invoked with need_counter=false
>> to get no counter assigned for the perf event.
>>
>> The vcpu_lbr field is added to cpuc, to indicate if the lbr perf event is
>> used by the vCPU only for context switching. When the perf subsystem
>> handles this event (e.g. lbr enable or read lbr stack on PMI) and finds
>> it's non-zero, it simply returns.
> *WHY* does the host need to save/restore? Why not make VMENTER/VMEXIT do
> this?

Because the VMX transition is much more frequent than the vCPU switching.
On SKL, saving 32 LBR entries could add 3000~4000 cycles overhead, this
would be too large for the frequent VMX transitions.

LBR state is saved when vCPU is scheduled out to ensure that this vCPU's
LBR data doesn't get lost (as another vCPU or host thread that is 
scheduled in
may use LBR)


> Many of these patches don't explain why things are done; that's a
> problem.

We'll improve, please help when you find anywhere isn't clear to you, 
thanks.

Best,
Wei
