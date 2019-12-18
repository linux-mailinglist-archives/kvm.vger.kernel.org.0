Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 726EE124BB8
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 16:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbfLRPa1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 10:30:27 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:35235 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727001AbfLRPa1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Dec 2019 10:30:27 -0500
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1ihbH2-0003tk-7u; Wed, 18 Dec 2019 16:30:04 +0100
To:     James Morse <james.morse@arm.com>
Subject: Re: [PATCH 7/7] KVM: arm/arm64: Elide CMOs when unmapping a range
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 18 Dec 2019 15:30:04 +0000
From:   Marc Zyngier <maz@kernel.org>
Cc:     Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Ra?= =?UTF-8?Q?dim_Kr=C4=8Dm=C3=A1=C5=99?= 
        <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-mips@vger.kernel.org>,
        <kvm-ppc@vger.kernel.org>, <kvm@vger.kernel.org>
In-Reply-To: <0c832b27-7041-a6c8-31c0-d71a25c6f5b8@arm.com>
References: <20191213182503.14460-1-maz@kernel.org>
 <20191213182503.14460-8-maz@kernel.org>
 <0c832b27-7041-a6c8-31c0-d71a25c6f5b8@arm.com>
Message-ID: <de462fe29fb40fb1644e6a071e6c0c69@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, jhogan@kernel.org, paulus@ozlabs.org, pbonzini@redhat.com, rkrcmar@redhat.com, sean.j.christopherson@intel.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi James,

On 2019-12-18 15:07, James Morse wrote:
> Hi Marc,
>
> On 13/12/2019 18:25, Marc Zyngier wrote:
>> If userspace issues a munmap() on a set of pages, there is no
>> expectation that the pages are cleaned to the PoC.
>
> (Pedantry: Clean and invalidate. If the guest wrote through a device
> mapping, we ditch any clean+stale lines with this path, meaning 
> swapout
> saves the correct values)

Indeed.

>> So let's
>> not do more work than strictly necessary, and set the magic
>> flag that avoids CMOs in this case.
>
> I think this assumes the pages went from anonymous->free, so no-one
> cares about the contents.
>
> If the pages are backed by a file, won't dirty pages will still get
> written back before the page is free? (e.g. EFI flash 'file' mmap()ed 
> in)

I believe so. Is that a problem?

> What if this isn't the only mapping of the page? Can't it be swapped
> out from another VMA? (tenuous example, poor man's memory mirroring?)

Swap-out wouldn't trigger this code path, as it would use a different
MMU notifier event (MMU_NOTIFY_CLEAR vs MMU_NOTIFY_UNMAP), I believe.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
