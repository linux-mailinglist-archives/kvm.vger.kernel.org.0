Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A4F1D4EE4
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 15:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgEONRs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 09:17:48 -0400
Received: from foss.arm.com ([217.140.110.172]:55944 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727125AbgEONRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 09:17:46 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA98A1042;
        Fri, 15 May 2020 06:17:45 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 08EE63F305;
        Fri, 15 May 2020 06:17:44 -0700 (PDT)
Subject: Re: [PATCH v4 kvmtool 01/12] ioport: mmio: Use a mutex and reference
 counting for locking
To:     =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>,
        kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com, maz@kernel.org
References: <1589470709-4104-1-git-send-email-alexandru.elisei@arm.com>
 <1589470709-4104-2-git-send-email-alexandru.elisei@arm.com>
 <1726c6b3-92e2-6a9f-83ba-c25d74c31156@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <1b5fea64-a06d-62c2-6361-cc2000481115@arm.com>
Date:   Fri, 15 May 2020 14:18:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1726c6b3-92e2-6a9f-83ba-c25d74c31156@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 5/15/20 11:13 AM, André Przywara wrote:
> On 14/05/2020 16:38, Alexandru Elisei wrote:
>
> Hi,
>
>> kvmtool uses brlock for protecting accesses to the ioport and mmio
>> red-black trees. brlock allows concurrent reads, but only one writer, which
>> is assumed not to be a VCPU thread (for more information see commit
>> 0b907ed2eaec ("kvm tools: Add a brlock)). This is done by issuing a
>> compiler barrier on read and pausing the entire virtual machine on writes.
>> When KVM_BRLOCK_DEBUG is defined, brlock uses instead a pthread read/write
>> lock.
>>
>> When we will implement reassignable BARs, the mmio or ioport mapping will
>> be done as a result of a VCPU mmio access. When brlock is a pthread
>> read/write lock, it means that we will try to acquire a write lock with the
>> read lock already held by the same VCPU and we will deadlock. When it's
>> not, a VCPU will have to call kvm__pause, which means the virtual machine
>> will stay paused forever.
>>
>> Let's avoid all this by using a mutex and reference counting the red-black
>> tree entries. This way we can guarantee that we won't unregister a node
>> that another thread is currently using for emulation.
> It's a pity that we can't use the traditional refcount pattern
> (initialise to 1) here, but I trust your analysis and testing that this
> is needed.

If it helps, the pattern is somewhat similar to kobject, which has a kobject_del
function (kref doesn't). kboject_del decrements the reference count only if the
parent is not NULL, then sets parent to NULL. The patch does what kobject_del
would have done if it didn't have a kref embedded in it.

>
> As far as my brain can process, this looks alright now:
>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
>
> Just a note: the usage of return and goto seems now somewhat
> inconsistent here: there are cases where we do "unlock;return;" in the
> middle of the function (kvm__deregister_mmio), and other cases where we
> use a "goto out", even though there is just a return at that label
> (kvm__emulate_mmio). In ioport__unregister() you seem to switch the scheme.
> But this is just cosmetical, and we can fix this up later, should we
> care, so this doesn't hold back this patch.

There are a number of inconsistencies in both files: mmio doesn't have its own
header file and ioport has, kvm__deregister_mmio should use unregister (like
ioport), it returns bool instead of an int (like ioport), when unregistering a
mmio region we call KVM_UNREGISTER_COALESCED_MMIO unconditionally, ioport
unregisters all ioports on exit and mmio doesn't, ioport creates a new device for
each call to ioport__register, etc, etc. Not to mention the fact that ioport is
used for architectures that don't have the notion of I/O ports. I think these
issues deserve their own cleanup series.

Thanks,
Alex
