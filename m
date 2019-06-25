Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58E6852780
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 11:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730338AbfFYJHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 05:07:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:27064 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728365AbfFYJHX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 05:07:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jun 2019 02:07:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,415,1557212400"; 
   d="scan'208";a="245009051"
Received: from unknown (HELO [10.239.13.7]) ([10.239.13.7])
  by orsmga001.jf.intel.com with ESMTP; 25 Jun 2019 02:07:20 -0700
Message-ID: <5D11E58B.1060306@intel.com>
Date:   Tue, 25 Jun 2019 17:12:43 +0800
From:   Wei Wang <wei.w.wang@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.7.0
MIME-Version: 1.0
To:     Eric Hankland <ehankland@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v1] KVM: x86: PMU Whitelist
References: <CAOyeoRWfPNmaWY6Lifdkdj3KPPM654vzDO+s3oduEMCJP+Asow@mail.gmail.com> <5D036843.2010607@intel.com> <CAOyeoRXr4gmbBPq1RsStoPguiZB8Jxod-irYd3Dm_AGVcQRGSQ@mail.gmail.com>
In-Reply-To: <CAOyeoRXr4gmbBPq1RsStoPguiZB8Jxod-irYd3Dm_AGVcQRGSQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/25/2019 08:32 AM, Eric Hankland wrote:
> Thanks for your feedback - I'll  send out an updated version
 > incorporating your comments shortly (assuming you don't have more
 > after this).

Actually I have another thing to discuss:
probably we could consider to make this filter list white/black configurable
from userspace. For example, userspace option: filter-list=white/black

This reason is that for now, we start with only a couple of events to 
whitelist.
As people gradually add more (or future hardware has some enhancements to
give you more confidence), finally there may have much more whitelisted 
events.
Then users could reuse this interface to switch to "filter-list=black",
this will be more efficient, considering the amount of events to enlist 
and the
iteration of event comparisons.


>>> +struct  kvm_pmu_whitelist { +       __u64 event_mask;
 >>
 >> Is this "ARCH_PERFMON_EVENTSEL_EVENT |
 >> ARCH_PERFMON_EVENTSEL_UMASK"?
 >
 > In most cases, I envision this being the case, but it's possible
 > users may want other bits - see response to the next question below.
 >

Probably we don't need this field to be passed from userspace?

We could directly use AMD64_RAW_EVENTMASK_NB, which includes bit[35:32].
Since those bits are reserved on Intel CPUs, have them as mask should be 
fine.

Alternatively, we could add this event_mask field to struct kvm_pmu, and 
initalize
it in the vendor specific intel_pmu_init or amd_pmu_init.

Both options above look good to me.


>>> +       __u16  num_events; +       __u64 events[0];
 >>
 >> Can this be __u16? The lower 16 bits (umask+eventsel) already
 >> determines what the event is.
 >
 > It looks like newer AMD processors also use bits 32-35 for eventsel
 > (see AMD64_EVENTSEL_EVENT/AMD64_RAW_EVENT_MASK in
 > arch/x86/include/asm/perf_event.h or a recent reference guide),
 > though it doesn't look like this has made it to pmu_amd.c in kvm
 > yet.

OK, thanks for the reminder on the AMD side. I'm fine to keep it __u64.

>
 > Further, including the whole 64 bits could enable whitelisting some
 > events with particular modifiers (e.g. in_tx=0, but not in_tx=1).
 > I'm not sure if whitelisting with specific modifiers will be
 > necessary,

I think "eventsel+umask" should be enough to identify the event.
Other modifiers could be treated with other options when needed (e.g. 
AnyThread),
otherwise it would complicate the case (e.g. double/trouble the number 
of total events).

>
 > but we definitely need more than u16 if we want to support any AMD
 > events that make use of those bits in the future.
 >
 >>> +       struct kvm_pmu_whitelist *whitelist;
 >>
 >> This could be per-VM and under rcu?
 > I'll try this out in the next version.
 >
 >> Why not moving this filter to reprogram_gp_counter?
 >>
 >> You could directly compare "unit_mask, event_sel"  with
 >> whitelist->events[i]
 > The reason is that this approach provides uniform behavior whether
 > an event is programmed on a fixed purpose counter vs a general
 > purpose one. Though I admit it's unlikely that instructions
 > retired/cycles wouldn't be whitelisted (and ref cycles can't be
 > programmed on gp counters), so it wouldn't be missing too much if I
 > do move this to reprogram_gp_counter. What do you think?
 >

I'd prefer to moving it to reprogram_gp_counter, which
simplifies the implementation (we don't need
.get_event_code as you added in this version.), and it
should also be faster.

Another reason is that we are trying to build an alternative path
of PMU virtualization, which makes the vPMU sits on the hardware
directly, instead of the host perf subsystem. That path wouldn't
go deeper to reprogram_pmc, which invloves the perf subsystem
related implementation, but that path would still need this filter list.

For the fixed counter, we could add a bitmap flag to kvm_arch,
indicating which counter is whitelist-ed based on the
"eventsel+umask" value passed from userspace. This flag is
updated when updating the whitelist-ed events to kvm.
For example, if userspace gives "00+01" (INST_RETIRED_ANY),
then we enable fixed counter0 in the flag.

When reprogram_fixed_counter, we check the flag and return
if the related counter isn't whitelisted.

Best,
Wei

