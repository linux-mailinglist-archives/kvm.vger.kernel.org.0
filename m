Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6B864443
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 11:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727764AbfGJJSM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 05:18:12 -0400
Received: from mga04.intel.com ([192.55.52.120]:27551 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727497AbfGJJSM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 05:18:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 02:18:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,474,1557212400"; 
   d="scan'208";a="173811519"
Received: from unknown (HELO [10.239.13.7]) ([10.239.13.7])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Jul 2019 02:18:09 -0700
Message-ID: <5D25AE9C.8090404@intel.com>
Date:   Wed, 10 Jul 2019 17:23:40 +0800
From:   Wei Wang <wei.w.wang@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.7.0
MIME-Version: 1.0
To:     Peter Zijlstra <peterz@infradead.org>
CC:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, ak@linux.intel.com, kan.liang@intel.com,
        mingo@redhat.com, rkrcmar@redhat.com, like.xu@intel.com,
        jannh@google.com, arei.gonglei@huawei.com, jmattson@google.com
Subject: Re: [PATCH v7 12/12] KVM/VMX/vPMU: support to report GLOBAL_STATUS_LBRS_FROZEN
References: <1562548999-37095-1-git-send-email-wei.w.wang@intel.com> <1562548999-37095-13-git-send-email-wei.w.wang@intel.com> <20190708150909.GP3402@hirez.programming.kicks-ass.net> <5D2408D7.3000002@intel.com> <20190709113549.GU3402@hirez.programming.kicks-ass.net>
In-Reply-To: <20190709113549.GU3402@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/09/2019 07:35 PM, Peter Zijlstra wrote:
>
> Yeah; although I'm not sure if its an implementation or specification
> problem. But as it exists it is of very limited use.
>
> Fundamentally our events (with exception of event groups) are
> independent. Events should always count, except when the PMI is running
> -- so as to not include the measurement overhead in the measurement
> itself. But this (mis)feature stops the entire PMU as soon as a single
> counter overflows, inhibiting all other counters from running (as they
> should) until the PMI has happened and reset the state.
>
> (Note that, strictly speaking, we even expect the overflowing counter to
> continue counting until the PMI happens. Having an overflow should not
> mean we loose events. A sampling and !sampling event should produce the
> same event count.)
>
> So even when there's only a single event (group) scheduled, it isn't
> strictly right. And when there's multiple events scheduled it is
> definitely wrong.
>
> And while I understand the purpose of the current semantics; it makes a
> single event group sample count more coherent, the fact that is looses
> events just bugs me something fierce -- and as shown, it breaks tools.

Thanks for sharing the finding.
If I understand this correctly, you observed that counter getting freezed
earlier than expected (expected to freeze at the time PMI gets generated).

Have you talked to anyone for possible freeze adjustment from the hardware?

Best,
Wei

