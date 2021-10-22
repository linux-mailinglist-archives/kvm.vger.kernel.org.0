Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86261437972
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 16:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbhJVO70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 10:59:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51354 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233239AbhJVO7W (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 10:59:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634914624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/oKOiyyh2KJKHi/RebS+NG4NxiirIVYl7E9Ckncjl9I=;
        b=GDpFUliclVal3b12ZONL11QZV1j5Huc9NuMT9LZv4IomnOegqjh788KE351VlMKkTziEIL
        06iBFromK/Da1J90dz/ube0tkek0ezkgDty24+Zb9N1B1GiOy+syLV9cd+dz6wtGLDsCMG
        AXOgFaPl3/3/VXLUmGQZW2oe8YhDKRo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-OKRr6lvPPyCvbLStjdC_XA-1; Fri, 22 Oct 2021 10:57:02 -0400
X-MC-Unique: OKRr6lvPPyCvbLStjdC_XA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A82B806689;
        Fri, 22 Oct 2021 14:57:00 +0000 (UTC)
Received: from starship (unknown [10.40.192.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2ED291346F;
        Fri, 22 Oct 2021 14:56:54 +0000 (UTC)
Message-ID: <9c159d2f23dc3957a2fda0301b25fca67aa21b30.camel@redhat.com>
Subject: Re: [PATCH v2 0/4] KVM: x86: APICv cleanups
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 22 Oct 2021 17:56:54 +0300
In-Reply-To: <23d9b009-2b48-d93c-3c24-711c4757ca1b@redhat.com>
References: <20211022004927.1448382-1-seanjc@google.com>
         <23d9b009-2b48-d93c-3c24-711c4757ca1b@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-10-22 at 12:12 +0200, Paolo Bonzini wrote:
> On 22/10/21 02:49, Sean Christopherson wrote:
> > APICv cleanups and a dissertation on handling concurrent APIC access page
> > faults and APICv inhibit updates.
> > 
> > I've tested this but haven't hammered the AVIC stuff, I'd appreciate it if
> > someone with the Hyper-V setup can beat on the AVIC toggling.
> > 
> > Sean Christopherson (4):
> >    KVM: x86/mmu: Use vCPU's APICv status when handling APIC_ACCESS
> >      memslot
> >    KVM: x86: Move SVM's APICv sanity check to common x86
> >    KVM: x86: Move apicv_active flag from vCPU to in-kernel local APIC
> >    KVM: x86: Use rw_semaphore for APICv lock to allow vCPU parallelism
> > 
> >   arch/x86/include/asm/kvm_host.h |  3 +-
> >   arch/x86/kvm/hyperv.c           |  4 +--
> >   arch/x86/kvm/lapic.c            | 46 ++++++++++---------------
> >   arch/x86/kvm/lapic.h            |  5 +--
> >   arch/x86/kvm/mmu/mmu.c          | 29 ++++++++++++++--
> >   arch/x86/kvm/svm/avic.c         |  2 +-
> >   arch/x86/kvm/svm/svm.c          |  2 --
> >   arch/x86/kvm/vmx/vmx.c          |  4 +--
> >   arch/x86/kvm/x86.c              | 59 ++++++++++++++++++++++-----------
> >   9 files changed, 93 insertions(+), 61 deletions(-)
> > 
> 
> Queued, thanks.  I only made small edits to the comment in patch
> 1, to make it very slightly shorter.
> 
> 	 * 2a. APICv is globally disabled but locally enabled, and this
> 	 *     vCPU acquires mmu_lock before __kvm_request_apicv_update
> 	 *     calls kvm_zap_gfn_range().  This vCPU will install a stale
> 	 *     SPTE, but no one will consume it as (a) no vCPUs can be
> 	 *     running due to the kick from KVM_REQ_APICV_UPDATE, and
> 	 *     (b) because KVM_REQ_APICV_UPDATE is raised before the VM
> 	 *     state is update, vCPUs attempting to service the request
> 	 *     will block on apicv_update_lock.  The update flow will
> 	 *     then zap the SPTE and release the lock.
> 
> Paolo
> 

Hi Paolo and Sean!

Could you expalain to me why the scenario when  I expalined about in my reply previous version of patch 1
is not correct?

This is the scenario I was worried about:



    vCPU0                                   vCPU1
    =====                                   =====

- disable AVIC
- VMRUN
                                        - #NPT on AVIC MMIO access
                                        - *stuck on something prior to the page fault code*
- enable AVIC
- VMRUN
                                        - *still stuck on something prior to the page fault code*

- disable AVIC:

  - raise KVM_REQ_APICV_UPDATE request
                                        
  - set global avic state to disable

  - zap the SPTE (does nothing, doesn't race
        with anything either)

  - handle KVM_REQ_APICV_UPDATE -
    - disable vCPU0 AVIC

- VMRUN
                                        - *still stuck on something prior to the page fault code*

                                                            ...
                                                            ...
                                                            ...

                                        - now vCPU1 finally starts running the page fault code.

                                        - vCPU1 AVIC is still enabled 
                                          (because vCPU1 never handled KVM_REQ_APICV_UPDATE),
                                          so the page fault code will populate the SPTE.
                                          

                                        - handle KVM_REQ_APICV_UPDATE
                                           - finally disable vCPU1 AVIC

                                        - VMRUN (vCPU1 AVIC disabled, SPTE populated)

                                                         ***boom***



Best regards,
	Maxim Levitsky

