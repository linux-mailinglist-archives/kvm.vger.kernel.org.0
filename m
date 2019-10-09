Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C78FD0DC7
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 13:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730384AbfJILj0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 07:39:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60674 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbfJILj0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 07:39:26 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 81FDC307D9D0;
        Wed,  9 Oct 2019 11:39:25 +0000 (UTC)
Received: from localhost.localdomain (ovpn-121-204.rdu2.redhat.com [10.10.121.204])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 73D61601AF;
        Wed,  9 Oct 2019 11:39:20 +0000 (UTC)
Subject: Re: KVM-unit-tests on AMD
To:     Nadav Amit <nadav.amit@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <E15A5945-440C-4E59-A82A-B22B61769884@gmail.com>
 <875zkz1lbh.fsf@vitty.brq.redhat.com>
 <912C44BF-308B-4F74-A145-04FF58F94046@gmail.com>
 <E01ED83B-53E8-4AEE-915C-3AE1DA1660E8@gmail.com>
From:   Cathy Avery <cavery@redhat.com>
Message-ID: <6534845f-df5b-67d7-57b8-e049bb258db6@redhat.com>
Date:   Wed, 9 Oct 2019 07:39:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <E01ED83B-53E8-4AEE-915C-3AE1DA1660E8@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Wed, 09 Oct 2019 11:39:25 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/8/19 4:02 PM, Nadav Amit wrote:
>> On Oct 8, 2019, at 9:30 AM, Nadav Amit <nadav.amit@gmail.com> wrote:
>>
>>> On Oct 8, 2019, at 5:19 AM, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>>
>>> Nadav Amit <nadav.amit@gmail.com> writes:
>>>
>>>> Is kvm-unit-test supposed to pass on AMD machines or AMD VMs?.
>>> It is supposed to but it doesn't :-) Actually, not only kvm-unit-tests
>>> but the whole SVM would appreciate some love ...
>>>
>>>> Clearly, I ask since they do not pass on AMD on bare-metal.
>>> On my AMD EPYC 7401P 24-Core Processor bare metal I get the following
>>> failures:
>>>
>>> FAIL vmware_backdoors (11 tests, 8 unexpected failures)
>>>
>>> (Why can't we just check
>>> /sys/module/kvm/parameters/enable_vmware_backdoor btw???)
>>>
>>> FAIL svm (15 tests, 1 unexpected failures)
>>>
>>> There is a patch for that:
>>>
>>> https://lore.kernel.org/kvm/d3eeb3b5-13d7-34d2-4ce0-fdd534f2bcc3@redhat.com/T/#t
>>>
>>> Inside a VM on this host I see the following:
>>>
>>> FAIL apic-split (timeout; duration=90s)
>>> FAIL apic (timeout; duration=30)
>>>
>>> (I manually inreased the timeout but it didn't help - this is worrisome,
>>> most likely this is a hang)
>>>
>>> FAIL vmware_backdoors (11 tests, 8 unexpected failures)
>>>
>>> - same as on bare metal
>>>
>>> FAIL port80 (timeout; duration=90s)
>>>
>>> - hang again?
>>>
>>> FAIL svm (timeout; duration=90s)
>>>
>>> - most likely a hang but this is 3-level nesting so oh well..
>>>
>>> FAIL kvmclock_test
>>>
>>> - bad but maybe something is wrong with TSC on the host? Need to
>>> investigate ...
>>>
>>> FAIL hyperv_clock
>>>
>>> - this is expected as it doesn't work when the clocksource is not TSC
>>> (e.g. kvm-clock)
>>>
>>> Are you seeing different failures?
>> Thanks for your quick response.
>>
>> I only ran the “apic” tests so far and I got the following failures:
>>
>> FAIL: correct xapic id after reset
>> …
>> x2apic not detected
>> FAIL: enable unsupported x2apic
>> FAIL: apicbase: relocate apic
>>
>> The test gets stuck after “apicbase: reserved low bits”.
>>
>> Well, I understand it is not a bare-metal thing.
> I ran the SVM test, and on bare-metal it does not pass.
>
> I don’t have the AMD machine for long enough to fix the issues, but for the
> record, here are test failures and crashes I encountered while running the
> tests on bare-metal.
>
> Failures:
> - cr3 read intercept emulate
> - npt_nx
> - npt_rsvd
> - npt_rsvd_pfwalk
> - npt_rw_pfwalk
> - npt_rw_l1mmio
>
> Crashes:
> - test_dr_intercept - Access to DR4 causes #UD
> - tsc_adjust_prepare - MSR access causes #GP
>
Interesting. I just ran the latest on bare-metal and it did pass.

enabling apic
enabling apic
paging enabled
cr0 = 80010011
cr3 = 62a000
cr4 = 20
NPT detected - running all tests with NPT enabled
PASS: null
PASS: vmrun
PASS: ioio
PASS: vmrun intercept check
PASS: cr3 read intercept
PASS: cr3 read nointercept
PASS: cr3 read intercept emulate
PASS: dr intercept check
PASS: next_rip
PASS: msr intercept check
PASS: mode_switch
PASS: asid_zero
PASS: sel_cr0_bug
PASS: npt_nx
PASS: npt_us
PASS: npt_rsvd
PASS: npt_rw
PASS: npt_rsvd_pfwalk
PASS: npt_rw_pfwalk
PASS: npt_l1mmio
PASS: npt_rw_l1mmio
PASS: tsc_adjust
     Latency VMRUN : max: 49300 min: 3160 avg: 3228
     Latency VMEXIT: max: 607780 min: 2940 avg: 2999
PASS: latency_run_exit
     Latency VMLOAD: max: 29720 min: 300 avg: 306
     Latency VMSAVE: max: 31660 min: 280 avg: 282
     Latency STGI:   max: 18860 min: 40 avg: 54
     Latency CLGI:   max: 16060 min: 40 avg: 53
PASS: latency_svm_insn
SUMMARY: 24 tests

