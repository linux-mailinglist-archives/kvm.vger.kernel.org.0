Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96A0FDBA5A
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2019 01:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441847AbfJQX5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 19:57:37 -0400
Received: from new-01-2.privateemail.com ([198.54.127.55]:4693 "EHLO
        NEW-01-2.privateemail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729190AbfJQX5h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 19:57:37 -0400
Received: from MTA-08-1.privateemail.com (unknown [10.20.147.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by NEW-01.privateemail.com (Postfix) with ESMTPS id 38D1A60959;
        Thu, 17 Oct 2019 23:57:36 +0000 (UTC)
Received: from MTA-08.privateemail.com (localhost [127.0.0.1])
        by MTA-08.privateemail.com (Postfix) with ESMTP id 21EEF60038;
        Thu, 17 Oct 2019 19:57:36 -0400 (EDT)
Received: from zetta.local (unknown [10.20.151.244])
        by MTA-08.privateemail.com (Postfix) with ESMTPA id 95BDF60033;
        Thu, 17 Oct 2019 23:57:35 +0000 (UTC)
From:   Derek Yerger <derek@djy.llc>
Subject: Re: PROBLEM: Regression of MMU causing guest VM application errors
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, "Bonzini, Paolo" <pbonzini@redhat.com>
References: <1e525b08-6204-3238-5d56-513f82f1d7fb@djy.llc>
 <20191016112857.293a197d@x1.home> <20191016174943.GG5866@linux.intel.com>
Message-ID: <53f506b3-e864-b3ca-f18f-f8e9a1612072@djy.llc>
Date:   Thu, 17 Oct 2019 19:57:35 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20191016174943.GG5866@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/16/19 1:49 PM, Sean Christopherson wrote:
> On Wed, Oct 16, 2019 at 11:28:57AM -0600, Alex Williamson wrote:
>> On Wed, 16 Oct 2019 00:49:51 -0400
>> Derek Yerger<derek@djy.llc>  wrote:
>>
>>> In at least Linux 5.2.7 via Fedora, up to 5.2.18, guest OS applications
>>> repeatedly crash with segfaults. The problem does not occur on 5.1.16.
>>>
>>> System is running Fedora 29 with kernel 5.2.18. Guest OS is Windows 10 with an
>>> AMD Radeon 540 GPU passthrough. When on 5.2.7 or 5.2.18, specific windows
>>> applications frequently and repeatedly crash, throwing exceptions in random
>>> libraries. Going back to 5.1.16, the issue does not occur.
>>>
>>> The host system is unaffected by the regression.
>>>
>>> Keywords: kvm mmu pci passthrough vfio vfio-pci amdgpu
>>>
>>> Possibly related: Unmerged [PATCH] KVM: x86/MMU: Zap all when removing memslot
>>> if VM has assigned device
>> That was never merged because it was superseded by:
>>
>> d012a06ab1d2 Revert "KVM: x86/mmu: Zap only the relevant pages when removing a memslot"
>>
>> That revert also induced this commit:
>>
>> 002c5f73c508 KVM: x86/mmu: Reintroduce fast invalidate/zap for flushing memslot
>>
>> Both of these were merged to stable, showing up in 5.2.11 and 5.2.16
>> respectively, so seeing these sorts of issues might be considered a
>> known issue on 5.2.7, but not 5.2.18 afaik.  Do you have a specific
>> test that reliably reproduces the issue?  Thanks,
Test case 1: Kernel 5.2.18, PCI passthrough, Windows 10 guest, error condition.
Error 1: Application error in Firefox, restarting firefox and restoring tabs 
reliably causes application crash with stack overflow error.
Error 2: Guest BSOD by the morning if left idle
Error 3: Guest BSOD within 1 minute of using SolidWorks CAD software

Test case 2: Kernel 5.2.18, no PCI passthrough, same environment. Guest BSOD 
encountered.

Test case 3: Kernel 5.1.16, no PCI passthrough, same environment. Worked in 
Solidworks for 10 minutes without BSOD. Opened firefox and restored tabs, no crash.

Test case 4: Kernel 5.1.16, with PCI passthrough, same environment. Worked in 
Solidworks for a half hour. Opened firefox and restored tabs, no crash.

Other factors: The guest does not change between tests. Same drivers, software, 
etc. I have reliably switched between 5.2.x and 5.1.x multiple times in the past 
month and repeatably see issues with 5.2.x. At this point I'm unsure if it's PCI 
passthrough causing the problem.

I know I should probably start from fresh host and guest, but time isn't really 
permitting.
> Also, does the failure reproduce on on 5.2.1 - 5.2.6?  The memslot debacle
> exists on all flavors of 5.2.x, if the errors showed up in 5.2.7 then they
> are being caused by something else.
After experiencing the issue in absence of PCI passthrough, I believe the 
problem is unrelated to the memslot debacle. I'm stuck on 5.1.x for now, maybe 
I'll give up and get a dedicated windows machine /s
