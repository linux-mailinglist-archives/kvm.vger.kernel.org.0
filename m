Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B68964368
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 10:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfGJIOC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 04:14:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:58880 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726792AbfGJIOC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 04:14:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 01:14:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,473,1557212400"; 
   d="scan'208";a="159691111"
Received: from unknown (HELO [10.239.13.7]) ([10.239.13.7])
  by orsmga008.jf.intel.com with ESMTP; 10 Jul 2019 01:13:59 -0700
Message-ID: <5D259F92.6030107@intel.com>
Date:   Wed, 10 Jul 2019 16:19:30 +0800
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
References: <1562548999-37095-1-git-send-email-wei.w.wang@intel.com> <1562548999-37095-9-git-send-email-wei.w.wang@intel.com> <20190708144831.GN3402@hirez.programming.kicks-ass.net> <5D240435.2040801@intel.com> <20190709093917.GS3402@hirez.programming.kicks-ass.net> <5D247BC2.70104@intel.com> <20190709121912.GY3402@hirez.programming.kicks-ass.net>
In-Reply-To: <20190709121912.GY3402@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/09/2019 08:19 PM, Peter Zijlstra wrote:
>
>> For the lbr feature, could we thought of it as first come, first served?
>> For example, if we have 2 host threads who want to use lbr at the same time,
>> I think one of them would simply fail to use.
>>
>> So if guest first gets the lbr, host wouldn't take over unless some
>> userspace command (we added to QEMU) is executed to have the vCPU
>> actively stop using lbr.
> Doesn't work that way.
>
> Say you start KVM with LBR emulation, it creates this task event, it
> gets the LBR (nobody else wants it) and the guest works and starts using
> the LBR.
>
> Then the host creates a CPU LBR event and the vCPU suddenly gets denied
> the LBR and the guest no longer functions correctly.
>
> Or you should fail to VMENTER, in which case you starve the guest, but
> at least it doesn't malfunction.
>

Ok, I think we could go with the first option for now, like this:

When there are other host threads starting to use lbr, host perf notifies
kvm to disable the guest use of lbr (add a notifier_block), which includes:
  - cancel passing through lbr msrs to guest
  - upon guest access to the lbr msr (will trap to KVM now), return #GP
    (or 0).


Best,
Wei



