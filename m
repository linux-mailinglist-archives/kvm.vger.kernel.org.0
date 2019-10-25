Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEE8BE513C
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 18:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633057AbfJYQap (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 12:30:45 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:42492 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733010AbfJYQao (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Oct 2019 12:30:44 -0400
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iO2Tk-0008W8-Nd; Fri, 25 Oct 2019 18:30:20 +0200
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v3 00/15] KVM: Dynamically size memslot arrays
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 25 Oct 2019 17:30:20 +0100
From:   Marc Zyngier <maz@kernel.org>
Cc:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
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
        Christoffer Dall <christoffer.dall@arm.com>
In-Reply-To: <20191024230744.14543-1-sean.j.christopherson@intel.com>
References: <20191024230744.14543-1-sean.j.christopherson@intel.com>
Message-ID: <2fc05685467a01c2f1c2afeacefb2f68@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: sean.j.christopherson@intel.com, jhogan@kernel.org, paulus@ozlabs.org, borntraeger@de.ibm.com, frankja@linux.ibm.com, pbonzini@redhat.com, rkrcmar@redhat.com, david@redhat.com, cohuck@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019-10-25 00:07, Sean Christopherson wrote:
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
> e.g. are essentially contained in patches 14/15 and 15/15.  Patches 
> 1-13
> clean up the memslot code, which has gotten quite crusty, especially
> __kvm_set_memory_region().  The clean up is likely not strictly 
> necessary
> to switch to dynamic sizing, but I didn't have a remotely reasonable
> level of confidence in the correctness of the dynamic sizing without 
> first
> doing the clean up.

I've finally found time to test this on a garden variety of arm64 
boxes,
and nothing caught fire. It surely must be doing something right!

FWIW:

Tested-by: Marc Zyngier <maz@kernel.org>

         M.
-- 
Jazz is not dead. It just smells funny...
