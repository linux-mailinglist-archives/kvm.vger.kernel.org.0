Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFEF14661B1
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 11:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241159AbhLBKvM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 05:51:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25964 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240993AbhLBKvL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Dec 2021 05:51:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638442068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nxrXd/Qbnx5+10y2XOAHYVIM838eOX6RKqgatEyS3E0=;
        b=EV7W0Q5fA4vo1Sb7pDbg++OSE/N4ukZXuJtMzCViGWFGklu+XMTsXr9AxQ8mwtQTQtufO4
        OD6SxNFg7PxQwIhgirpu/UgOs2w9CCOzlH5+09cOeeS/xi/ZJWdyl+kFPS/0IkGJgZDgdC
        goXieyRh7Zty5+iHNvVtwdl21oMZmyo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-400-CesdZHK2MK6LRTzbfbz1KQ-1; Thu, 02 Dec 2021 05:47:45 -0500
X-MC-Unique: CesdZHK2MK6LRTzbfbz1KQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B70A81CCB7;
        Thu,  2 Dec 2021 10:47:42 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 965E319D9F;
        Thu,  2 Dec 2021 10:47:22 +0000 (UTC)
Message-ID: <7c862212b92efea218ed542e0db7ddf7627c525c.camel@redhat.com>
Subject: Re: [PATCH v2 11/43] KVM: Don't block+unblock when halt-polling is
 successful
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Date:   Thu, 02 Dec 2021 12:47:21 +0200
In-Reply-To: <f55056c55892dd42592e5c242fa7a1561c6cee90.camel@redhat.com>
References: <20211009021236.4122790-1-seanjc@google.com>
         <20211009021236.4122790-12-seanjc@google.com>
         <cceb33be9e2a6ac504bb95a7b2b8cf5fe0b1ff26.camel@redhat.com>
         <4e883728e3e5201a94eb46b56315afca5e95ad9c.camel@redhat.com>
         <YaUNBfJh35WXMV0M@google.com>
         <f55056c55892dd42592e5c242fa7a1561c6cee90.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-12-02 at 12:20 +0200, Maxim Levitsky wrote:
> On Mon, 2021-11-29 at 17:25 +0000, Sean Christopherson wrote:
> > On Mon, Nov 29, 2021, Maxim Levitsky wrote:
> > > (This thing is that when you tell the IOMMU that a vCPU is not running,
> > > Another thing I discovered that this patch series totally breaks my VMs,
> > > without cpu_pm=on The whole series (I didn't yet bisect it) makes even my
> > > fedora32 VM be very laggy, almost unusable, and it only has one
> > > passed-through device, a nic).
> > 
> > Grrrr, the complete lack of comments in the KVM code and the separate paths for
> > VMX vs SVM when handling HLT with APICv make this all way for difficult to
> > understand than it should be.
> > 
> > The hangs are likely due to:
> > 
> >   KVM: SVM: Unconditionally mark AVIC as running on vCPU load (with APICv)
> > 
> > If a posted interrupt arrives after KVM has done its final search through the vIRR,
> > but before avic_update_iommu_vcpu_affinity() is called, the posted interrupt will
> > be set in the vIRR without triggering a host IRQ to wake the vCPU via the GA log.
> > 
> > I.e. KVM is missing an equivalent to VMX's posted interrupt check for an outstanding
> > notification after switching to the wakeup vector.
> > 
> > For now, the least awful approach is sadly to keep the vcpu_(un)blocking() hooks.
> > Unlike VMX's PI support, there's no fast check for an interrupt being posted (KVM
> > would have to rewalk the vIRR), no easy to signal the current CPU to do wakeup (I
> > don't think KVM even has access to the IRQ used by the owning IOMMU), and there's
> > no simplification of load/put code.
> 
> I have an idea.
>  
> Why do we even use/need the GA log?
> Why not, just disable the 'guest mode' in the iommu and let it sent good old normal interrupt
> when a vCPU is not running, just like we do when we inhibit the AVIC?
>  
> GA log makes all devices that share an iommu (there are 4 iommus per package these days,
> some without useful devices) go through a single (!) msi like interrupt,
> which is even for some reason implemented by a threaded IRQ in the linux kernel.


Yep, this gross hack works!


diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 958966276d00b8..6136b94f6b5f5e 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -987,8 +987,9 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
                entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
 
        WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
-       avic_update_iommu_vcpu_affinity(vcpu, h_physical_id,
-                                       svm->avic_is_running);
+
+       svm_set_pi_irte_mode(vcpu, svm->avic_is_running);
+       avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, true);
 }
 
 void avic_vcpu_put(struct kvm_vcpu *vcpu)
@@ -997,8 +998,9 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
        struct vcpu_svm *svm = to_svm(vcpu);
 
        entry = READ_ONCE(*(svm->avic_physical_id_cache));
-       if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
-               avic_update_iommu_vcpu_affinity(vcpu, -1, 0);
+       if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK) {
+               svm_set_pi_irte_mode(vcpu, false);
+       }
 
        entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
        WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
> 


GA log interrupts almost gone (there are still few because svm_set_pi_irte_mode sets is_running false)
devices works as expected sending normal interrupts unless guest is loaded, then normal interrupts disappear,
as expected.

Best regards,
	Maxim Levitsky

>  
> Best regards,
> 	Maxim Levitsky
> 
> > If the scheduler were changed to support waking in the sched_out path, then I'd be
> > more inclined to handle this in avic_vcpu_put() by rewalking the vIRR one final
> > time, but for now it's not worth it.
> > 
> > > If I apply though only the patch series up to this patch, my fedora VM seems
> > > to work fine, but my windows VM still locks up hard when I run 'LatencyTop'
> > > in it, which doesn't happen without this patch.
> > 
> > Buy "run 'LatencyTop' in it", do you mean running something in the Windows guest?
> > The only search results I can find for LatencyTop are Linux specific.
> > 
> > > So far the symptoms I see is that on VCPU 0, ISR has quite high interrupt
> > > (0xe1 last time I seen it), TPR and PPR are 0xe0 (although I have seen TPR to
> > > have different values), and IRR has plenty of interrupts with lower priority.
> > > The VM seems to be stuck in this case. As if its EOI got lost or something is
> > > preventing the IRQ handler from issuing EOI.
> > >  
> > > LatencyTop does install some form of a kernel driver which likely does meddle
> > > with interrupts (maybe it sends lots of self IPIs?).
> > >  
> > > 100% reproducible as soon as I start monitoring with LatencyTop.
> > >  
> > > Without this patch it works (or if disabling halt polling),
> > 
> > Huh.  I assume everything works if you disable halt polling _without_ this patch
> > applied?
> > 
> > If so, that implies that successful halt polling without mucking with vCPU IOMMU
> > affinity is somehow problematic.  I can't think of any relevant side effects other
> > than timing.
> > 


