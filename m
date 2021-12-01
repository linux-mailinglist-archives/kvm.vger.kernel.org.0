Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B3F465202
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 16:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351204AbhLAPuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 10:50:11 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:46438 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351112AbhLAPt2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 10:49:28 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1msRnv-0008Hv-4u; Wed, 01 Dec 2021 16:45:55 +0100
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1638304315.git.maciej.szmigiero@oracle.com>
 <72e1c87ddce1c2836bf8a82962202dc4c34bb53f.1638304316.git.maciej.szmigiero@oracle.com>
 <Yabrr6Q9WxFb3Eec@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v6 25/29] KVM: Call kvm_arch_flush_shadow_memslot() on the
 old slot in kvm_invalidate_memslot()
Message-ID: <b60c2bf2-1feb-350b-486b-a9077cc3efce@maciej.szmigiero.name>
Date:   Wed, 1 Dec 2021 16:45:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <Yabrr6Q9WxFb3Eec@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01.12.2021 04:27, Sean Christopherson wrote:
> On Tue, Nov 30, 2021, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>
>> kvm_invalidate_memslot() calls kvm_arch_flush_shadow_memslot() on the
>> active, but KVM_MEMSLOT_INVALID slot.
>> Do it on the inactive (but valid) old slot instead since arch code really
>> should not get passed such invalid slot.
> 
> One other thing that's worth noting in the changelog is that "old->arch" may have
> stale data.  IMO that's perfectly ok, but it's definitely a quirk. 

Will add this caveat to this commit message.

> Ideally KVM
> would disallow touching "arch" for an INVALID slot, but that would require another
> arch hook if kvm_prepare_memory_region() failed to refresh old->arch if necessary
> before restoring it. :-/

It looks to me that only PPC book3s_hv actually uses the "arch" field in
its kvm_arch_flush_shadow_memslot() implementation.

But at the same time it does not seem to do lazy allocation for rmaps or
similar stuff.

However, the code there is complex enough for this change to be of
higher-than-usual risk.
That's why I have split it out from the main memslots sets rework.

Thanks,
Maciej
