Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC3D12505B
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 19:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfLRSLM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 13:11:12 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:44619 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726960AbfLRSLM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Dec 2019 13:11:12 -0500
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1ihdmZ-0007pw-8W; Wed, 18 Dec 2019 19:10:47 +0100
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v4 00/19] KVM: Dynamically size memslot arrays
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 18 Dec 2019 18:10:47 +0000
From:   Marc Zyngier <maz@kernel.org>
Cc:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <linux-mips@vger.kernel.org>, <kvm-ppc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-kernel@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
In-Reply-To: <20191217204041.10815-1-sean.j.christopherson@intel.com>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
Message-ID: <3a6b03cc1300bc3cffd3904e22c09478@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: sean.j.christopherson@intel.com, jhogan@kernel.org, paulus@ozlabs.org, borntraeger@de.ibm.com, frankja@linux.ibm.com, pbonzini@redhat.com, david@redhat.com, cohuck@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, christoffer.dall@arm.com, f4bug@amsat.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019-12-17 20:40, Sean Christopherson wrote:
> The end goal of this series is to dynamically size the memslot array 
> so
> that KVM allocates memory based on the number of memslots in use, as
> opposed to unconditionally allocating memory for the maximum number 
> of
> memslots.  On x86, each memslot consumes 88 bytes, and so with 2 
> address
> spaces of 512 memslots, each VM consumes ~90k bytes for the memslots.
> E.g. given a VM that uses a total of 30 memslots, dynamic sizing 
> reduces
> the memory footprint from 90k to ~2.6k bytes.
>
> The changes required to support dynamic sizing are relatively small,
> e.g. are essentially contained in patches 17/19 and 18/19.
>
> Patches 2-16 clean up the memslot code, which has gotten quite 
> crusty,
> especially __kvm_set_memory_region().  The clean up is likely not 
> strictly
> necessary to switch to dynamic sizing, but I didn't have a remotely
> reasonable level of confidence in the correctness of the dynamic 
> sizing
> without first doing the clean up.
>
> The only functional change in v4 is the addition of an x86-specific 
> bug
> fix in x86's handling of KVM_MR_MOVE.  The bug fix is not directly 
> related
> to dynamically allocating memslots, but it has subtle and hidden 
> conflicts
> with the cleanup patches, and the fix is higher priority than 
> anything
> else in the series, i.e. should be merged first.
>
> On non-x86 architectures, v3 and v4 should be functionally 
> equivalent,
> the only non-x86 change in v4 is the dropping of a "const" in
> kvm_arch_commit_memory_region().

Gave it another go on top of 5.5-rc2 on an arm64 box, and nothing
exploded. So thumbs up from me.

Thanks,

        M.
-- 
Jazz is not dead. It just smells funny...
