Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BCA2DDCA1
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 02:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbgLRB2W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 20:28:22 -0500
Received: from belmont80srvr.owm.bell.net ([184.150.200.80]:33944 "EHLO
        mtlfep01.bell.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726851AbgLRB2V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Dec 2020 20:28:21 -0500
Received: from bell.net mtlfep01 184.150.200.30 by mtlfep01.bell.net
          with ESMTP
          id <20201218012740.FIXH120733.mtlfep01.bell.net@mtlspm01.bell.net>;
          Thu, 17 Dec 2020 20:27:40 -0500
Received: from starbug.dom ([67.68.23.153]) by mtlspm01.bell.net with ESMTP
          id <20201218012740.MLKT130487.mtlspm01.bell.net@starbug.dom>;
          Thu, 17 Dec 2020 20:27:40 -0500
Received: from starbug.dom (localhost [127.0.0.1])
        by starbug.dom (Postfix) with ESMTP id BB5551EBAC6;
        Thu, 17 Dec 2020 20:27:38 -0500 (EST)
From:   Richard Herbert <rherbert@sympatico.ca>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Subject: [PATCH 0/4] KVM: x86/mmu: Bug fixes and cleanups in get_mmio_spte()
Date:   Thu, 17 Dec 2020 20:27:38 -0500
Message-ID: <2001245.9o76ZdvQCi@starbug.dom>
In-Reply-To: <2346556.XAFRqVoOGU@starbug.dom>
References: <20201218003139.2167891-1-seanjc@google.com> <2346556.XAFRqVoOGU@starbug.dom>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-CM-Analysis: v=2.4 cv=AbB0o1bG c=1 sm=1 tr=0 ts=5fdc058c a=Kmoo8mppt6dxYrHuFgrAcA==:117 a=Kmoo8mppt6dxYrHuFgrAcA==:17 a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=ww6PLmxxykeOsXVbiHUA:9 a=CjuIK1q_8ugA:10 a=pHzHmUro8NiASowvMSCR:22 a=nt3jZW36AmriUCFCBwmW:22
X-CM-Envelope: MS4xfNEEu04CtsVlwGxMQ5DtGddkw/6a+MFkU8QWjQJfwp8dKIFe/Q7NwthaZuJ+Jv1xO7x5V0/T19wHB8nSF2kAn6myqlRv3UnQByhfdux1AGud6Uv6kQkM Vq3magofB7LyI7beJsF9voFs4AAYoWQZcpDgImNzXqJzBiTTsx6YyhvIa6dmt8F+rirnI8f/W+LE+8QdDc4AA/Vwl0c5z/VkuA3NeYk9ZQuUYLyhv5z8os5A
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

 Hi, Sean and all.

Thanks so much for these.  Very glad to report that the problem has been 
solved.  I applied all four patches, recompiled kernel 5.10.1 and successfully 
launched a Qemu VM.  Let's hope these will get merged into 5.10.2.

Thanks again for the hard work and quick fix.

Richard Herbert


On Thursday, December 17, 2020 7:31:35 PM EST Sean Christopherson wrote:

> Two fixes for bugs that were introduced along with the TDP MMU (though I
> strongly suspect only the one reported by Richard, fixed in patch 2/4, is
> hittable in practice).  Two additional cleanup on top to try and make the
> code a bit more readable and shave a few cycles.
> 
> Sean Christopherson (4):
>   KVM: x86/mmu: Use -1 to flag an undefined spte in get_mmio_spte()
>   KVM: x86/mmu: Get root level from walkers when retrieving MMIO SPTE
>   KVM: x86/mmu: Use raw level to index into MMIO walks' sptes array
>   KVM: x86/mmu: Optimize not-present/MMIO SPTE check in get_mmio_spte()
> 
>  arch/x86/kvm/mmu/mmu.c     | 53 +++++++++++++++++++++-----------------
>  arch/x86/kvm/mmu/tdp_mmu.c |  9 ++++---
>  arch/x86/kvm/mmu/tdp_mmu.h |  4 ++-
>  3 files changed, 39 insertions(+), 27 deletions(-)








