Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C527202D65
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 00:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgFUW0v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Jun 2020 18:26:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41592 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726450AbgFUW0v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Jun 2020 18:26:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592778408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9fL1R/P86+hC+bgW9wsTzQuqTu+6VC/+xAUVsewgB9I=;
        b=G4VXnbG90dbyhigDc6L0AYyR36I6cbAjgRFV9qrL6qEPZQCYiRYnaVz9kaQ5naF2LdI3TQ
        jQS8xnb3QJ04Ny3SBlmOSaVCTVNWK5aogZJsMtGjtsIEnx0zcnDEBWJcvJJPJv0kgGiyqi
        SbcZ2MWNWNMbpWUvN8cHnY9PqNJ4eQs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-y7rNxRhZO6-0wxjb1FNJRg-1; Sun, 21 Jun 2020 18:26:44 -0400
X-MC-Unique: y7rNxRhZO6-0wxjb1FNJRg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44BB58014D4;
        Sun, 21 Jun 2020 22:26:43 +0000 (UTC)
Received: from localhost (unknown [10.40.208.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 869E05C220;
        Sun, 21 Jun 2020 22:26:40 +0000 (UTC)
Date:   Mon, 22 Jun 2020 00:26:37 +0200
From:   Igor Mammedov <imammedo@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v3] KVM: LAPIC: Recalculate apic map in batch
Message-ID: <20200622002637.33358827@redhat.com>
In-Reply-To: <3e025538-297b-74e5-f1b1-2193b614978b@redhat.com>
References: <1582684862-10880-1-git-send-email-wanpengli@tencent.com>
        <20200619143626.1b326566@redhat.com>
        <3e025538-297b-74e5-f1b1-2193b614978b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 19 Jun 2020 16:10:43 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 19/06/20 14:36, Igor Mammedov wrote:
> > qemu-kvm -m 2G -smp 4,maxcpus=8  -monitor stdio
> > (qemu) device_add qemu64-x86_64-cpu,socket-id=4,core-id=0,thread-id=0
> > 
> > in guest fails with:
> > 
> >  smpboot: do_boot_cpu failed(-1) to wakeup CPU#4
> > 
> > which makes me suspect that  INIT/SIPI wasn't delivered
> > 
> > Is it a know issue?
> >   
> 
> No, it isn't.  I'll revert.
> 
> Paolo
> 

Following fixes immediate issue:

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 34a7e0533dad..6dc177da19da 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2567,6 +2567,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
        }
        memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
 
+       apic->vcpu->kvm->arch.apic_map_dirty = true;
        kvm_recalculate_apic_map(vcpu->kvm);
        kvm_apic_set_version(vcpu);

Problem is that during kvm_arch_vcpu_create() new vcpu is not visible to
kvm_recalculate_apic_map(), so whoever many times map update was called
during it, it didn't affect apic map.

What broke hotplug is that kvm_vcpu_ioctl_set_lapic -> kvm_apic_set_state,
which is called after new vcpu is visible, used to make an unconditional update
which pulled in the new vcpu, but with this patch the map update is gone
since state hasn't actuaaly changed, so we lost the one call of
kvm_recalculate_apic_map() which did actually matter.

It happens to work for vcpus present at boot just by luck
(BSP updates SPIV after all vcpus has been created which triggers kvm_recalculate_apic_map())

I'm not sending formal patch yet, since I have doubts wrt subj.

following sequence looks like a race that can cause lost map update events:

         cpu1                            cpu2
                             
                                apic_map_dirty = true     
  ------------------------------------------------------------   
                                kvm_recalculate_apic_map:
                                     pass check
                                         mutex_lock(&kvm->arch.apic_map_lock);
                                         if (!kvm->arch.apic_map_dirty)
                                     and in process of updating map
  -------------------------------------------------------------
    other calls to
       apic_map_dirty = true         might be too late for affected cpu
  -------------------------------------------------------------
                                     apic_map_dirty = false
  -------------------------------------------------------------
    kvm_recalculate_apic_map:
    bail out on
      if (!kvm->arch.apic_map_dirty)

it's safer to revert this patch for now like you have suggested earlier.

If you prefer to keep it, I'll post above fixup as a patch.

