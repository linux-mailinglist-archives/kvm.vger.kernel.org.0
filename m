Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD6471263DB
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 14:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfLSNqX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Dec 2019 08:46:23 -0500
Received: from foss.arm.com ([217.140.110.172]:38852 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726695AbfLSNqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Dec 2019 08:46:23 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E151131B;
        Thu, 19 Dec 2019 05:46:22 -0800 (PST)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A8C063F6CF;
        Thu, 19 Dec 2019 05:46:20 -0800 (PST)
Subject: Re: [PATCH 7/7] KVM: arm/arm64: Elide CMOs when unmapping a range
To:     Marc Zyngier <maz@kernel.org>
Cc:     Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org
References: <20191213182503.14460-1-maz@kernel.org>
 <20191213182503.14460-8-maz@kernel.org>
 <0c832b27-7041-a6c8-31c0-d71a25c6f5b8@arm.com>
 <de462fe29fb40fb1644e6a071e6c0c69@www.loen.fr>
From:   James Morse <james.morse@arm.com>
Message-ID: <01c9439f-0de1-78ca-632b-f662876cc4a1@arm.com>
Date:   Thu, 19 Dec 2019 13:46:19 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <de462fe29fb40fb1644e6a071e6c0c69@www.loen.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 18/12/2019 15:30, Marc Zyngier wrote:
> On 2019-12-18 15:07, James Morse wrote:
>> On 13/12/2019 18:25, Marc Zyngier wrote:
>>> If userspace issues a munmap() on a set of pages, there is no
>>> expectation that the pages are cleaned to the PoC.

>>> So let's
>>> not do more work than strictly necessary, and set the magic
>>> flag that avoids CMOs in this case.
>>
>> I think this assumes the pages went from anonymous->free, so no-one
>> cares about the contents.
>>
>> If the pages are backed by a file, won't dirty pages will still get
>> written back before the page is free? (e.g. EFI flash 'file' mmap()ed in)
> 
> I believe so. Is that a problem?

If we skipped the dcache maintenance on unmap, when the the dirty page is later reclaimed
the clean+stale lines are written back to the file. File-backed dirty pages will stick
around in the page cache in the hope someone else needs them.

This would happen for a guest:device-mapping that is written to, but is actually backed by
a mmap()d file. I think the EFI flash emulation does exactly this.


>> What if this isn't the only mapping of the page? Can't it be swapped
>> out from another VMA? (tenuous example, poor man's memory mirroring?)
> 
> Swap-out wouldn't trigger this code path, as it would use a different
> MMU notifier event (MMU_NOTIFY_CLEAR vs MMU_NOTIFY_UNMAP), I believe.

This was a half thought-through special case of the above. The sequence would be:

VM-A and VM-B both share a mapping of $page.

1. VM-A writes to $page through a device mapping
2. The kernel unmaps $page from VM-A for swap. KVM does the maintenance

3. VM-B writes to $page through a device mapping
4. VM-B exits, KVM skips the maintenance, $page may have clean+stale lines

5. Swap finds no further mappings, and writes $page and its clean+stale lines to disk.

Two VMs with a shared mapping is the 'easy' example. I think you just need a second
mapping for this to happen: it means the page isn't really free after the VM has exited.



Thanks,

James
