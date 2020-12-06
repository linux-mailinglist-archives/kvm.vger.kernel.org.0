Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027FC2D05BF
	for <lists+kvm@lfdr.de>; Sun,  6 Dec 2020 16:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgLFPyj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 10:54:39 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:34910 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbgLFPyj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 10:54:39 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.93.0.4)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1klwMA-0008Jv-Q9; Sun, 06 Dec 2020 16:53:50 +0100
Subject: Re: [PATCH] KVM: mmu: Fix SPTE encoding of MMIO generation upper half
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <156700708db2a5296c5ed7a8b9ac71f1e9765c85.1607129096.git.maciej.szmigiero@oracle.com>
 <370db207-7216-ae26-0c33-dab61e0fdaab@redhat.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Message-ID: <ef3b845e-9523-e680-14cd-398d18e412cb@maciej.szmigiero.name>
Date:   Sun, 6 Dec 2020 16:53:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <370db207-7216-ae26-0c33-dab61e0fdaab@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06.12.2020 11:09, Paolo Bonzini wrote:
> On 05/12/20 01:48, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>
>> Commit cae7ed3c2cb0 ("KVM: x86: Refactor the MMIO SPTE generation handling")
>> cleaned up the computation of MMIO generation SPTE masks, however it
>> introduced a bug how the upper part was encoded:
>> SPTE bits 52-61 were supposed to contain bits 10-19 of the current
>> generation number, however a missing shift encoded bits 1-10 there instead
>> (mostly duplicating the lower part of the encoded generation number that
>> then consisted of bits 1-9).
>>
>> In the meantime, the upper part was shrunk by one bit and moved by
>> subsequent commits to become an upper half of the encoded generation number
>> (bits 9-17 of bits 0-17 encoded in a SPTE).
>>
>> In addition to the above, commit 56871d444bc4 ("KVM: x86: fix overlap between SPTE_MMIO_MASK and generation")
>> has changed the SPTE bit range assigned to encode the generation number and
>> the total number of bits encoded but did not update them in the comment
>> attached to their defines, nor in the KVM MMU doc.
>> Let's do it here, too, since it is too trivial thing to warrant a separate
>> commit.
>>
>> Fixes: cae7ed3c2cb0 ("KVM: x86: Refactor the MMIO SPTE generation handling")
>> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>> ---
> 
> 
> Good catch.  What do you think about this alternative definition?  It computes everything from the bit ranges.
> 
> #define MMIO_SPTE_GEN_LOW_START         3
> #define MMIO_SPTE_GEN_LOW_END           11
> 
> #define MMIO_SPTE_GEN_HIGH_START        PT64_SECOND_AVAIL_BITS_SHIFT
> #define MMIO_SPTE_GEN_HIGH_END          62
> 
> #define MMIO_SPTE_GEN_LOW_MASK          GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
> 
> MMIO_SPTE_GEN_LOW_START)
> #define MMIO_SPTE_GEN_HIGH_MASK GENMASK_ULL(MMIO_SPTE_GEN_HIGH_END, \
> 
> MMIO_SPTE_GEN_HIGH_START)
> 
> #define MMIO_SPTE_GEN_LOW_BITS          (MMIO_SPTE_GEN_LOW_END - MMIO_SPTE_GEN_LOW_START + 1)
> #define MMIO_SPTE_GEN_HIGH_BITS         (MMIO_SPTE_GEN_HIGH_END - MMIO_SPTE_GEN_HIGH_START + 1)
> 
> #define MMIO_SPTE_GEN_LOW_SHIFT         (MMIO_SPTE_GEN_LOW_START - 0)
> #define MMIO_SPTE_GEN_HIGH_SHIFT        (MMIO_SPTE_GEN_HIGH_START - MMIO_SPTE_GEN_LOW_BITS)
> 
> #define MMIO_SPTE_GEN_MASK GENMASK_ULL(MMIO_SPTE_GEN_LOW_BITS + MMIO_SPTE_GEN_HIGH_BITS - 1, 0)

I like the exiting version more since it explicitly refers to start bits
0 and 9 of the encoded generation for easy cross-checking with bit ranges
in the comment above these defines in spte.h.

But if you prefer it to be specified as you had proposed above I will respin
the patch accordingly.

> Thanks,
> 
> Paolo
> 

Thanks,
Maciej
