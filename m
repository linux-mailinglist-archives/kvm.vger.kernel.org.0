Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80B152D6F2
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 09:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfE2Htm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 03:49:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:44671 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbfE2Htm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 May 2019 03:49:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 May 2019 00:49:41 -0700
X-ExtLoop1: 1
Received: from unknown (HELO [10.239.13.7]) ([10.239.13.7])
  by orsmga006.jf.intel.com with ESMTP; 29 May 2019 00:49:39 -0700
Message-ID: <5CEE3AC4.3020904@intel.com>
Date:   Wed, 29 May 2019 15:54:44 +0800
From:   Wei Wang <wei.w.wang@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.7.0
MIME-Version: 1.0
To:     Eric Hankland <ehankland@google.com>
CC:     pbonzini@redhat.com, rkrcmar@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v1] KVM: x86: PMU Whitelist
References: <CAOyeoRWfPNmaWY6Lifdkdj3KPPM654vzDO+s3oduEMCJP+Asow@mail.gmail.com> <5CEC9667.30100@intel.com> <CAOyeoRWhfyuuYdguE6Wrzd7GOdow9qRE4MZ4OKkMc5cdhDT53g@mail.gmail.com>
In-Reply-To: <CAOyeoRWhfyuuYdguE6Wrzd7GOdow9qRE4MZ4OKkMc5cdhDT53g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/29/2019 02:14 AM, Eric Hankland wrote:
> On Mon, May 27, 2019 at 6:56 PM Wei Wang <wei.w.wang@intel.com> wrote:
>> On 05/23/2019 06:23 AM, Eric Hankland wrote:
>>> - Add a VCPU ioctl that can control which events the guest can monitor.
>>>
>>> Signed-off-by: ehankland <ehankland@google.com>
>>> ---
>>> Some events can provide a guest with information about other guests or the
>>> host (e.g. L3 cache stats); providing the capability to restrict access
>>> to a "safe" set of events would limit the potential for the PMU to be used
>>> in any side channel attacks. This change introduces a new vcpu ioctl that
>>> sets an event whitelist. If the guest attempts to program a counter for
>>> any unwhitelisted event, the kernel counter won't be created, so any
>>> RDPMC/RDMSR will show 0 instances of that event.
>> The general idea sounds good to me :)
>>
>> For the implementation, I would have the following suggestions:
>>
>> 1) Instead of using a whitelist, it would be better to use a blacklist to
>> forbid the guest from counting any core level information. So by default,
>> kvm maintains a list of those core level events, which are not supported to
>> the guest.
>>
>> The userspace ioctl removes the related events from the blacklist to
>> make them usable by the guest.
>>
>> 2) Use vm ioctl, instead of vcpu ioctl. The blacklist-ed events can be
>> VM wide
>> (unnecessary to make each CPU to maintain the same copy).
>> Accordingly, put the pmu event blacklist into kvm->arch.
>>
>> 3) Returning 1 when the guest tries to set the evetlsel msr to count an
>> event which is on the blacklist.
>>
>> Best,
>> Wei
> Thanks for the feedback. I have a couple concerns with a KVM
> maintained blacklist. First, I'm worried it will be difficult to keep
> such a list up to date and accurate (both coming up with the initial
> list since there are so many events, and updating it whenever any new
> events are published or vulnerabilities are discovered).

Not sure about "so many" above. I think there should be much
fewer events that may need to be blacklisted.

For example the event table 19-3 from SDM 19.2 shows hundreds of
events, how many of them would you think that need to be blacklisted?

> Second, users
> may want to differentiate between whole-socket and sub-socket VMs
> (some events may be fine for the whole-socket case) - keeping a single
> blacklist wouldn't allow for this.

Why wouldn't?
In any case (e.g. the whole socket dedicated to the single VM) we
want to unlock the blacklisted events, we can have the userspace
(e.g. qemu command line options "+event1, +event2") do ioctl to
have KVM do that.

Btw, for the L3 cache stats event example, I'm not sure if that could
be an issue if we have "AnyThread=0". I'll double confirm with
someone.

Best,
Wei
