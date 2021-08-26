Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1443F8DB0
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 20:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241975AbhHZSOv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 14:14:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50600 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234536AbhHZSOu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 14:14:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630001643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sRuC5V6T0HI9RSkyu52RSwPk8VQRtun3hwD4VTXAwFo=;
        b=Ls3+/dzyKAyFZf5T6W6xIqiYXIErqeplQ5VaWL1X9S+nuFb4QgU8yt8o5nhTaKYFOjotaN
        gV08HhE1YwhROM7Z2Tj4lgKusUczIWWFmNMoWBauVOzsLfHdND/v9UaGgwdJ8q6FJV4Ihg
        iDqlAySAL/GiHhf4c74YjpjCnBwRn3E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-7Z0Km1TOOo-84TcMbwWzYA-1; Thu, 26 Aug 2021 14:14:01 -0400
X-MC-Unique: 7Z0Km1TOOo-84TcMbwWzYA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BABF18C89C4;
        Thu, 26 Aug 2021 18:14:00 +0000 (UTC)
Received: from localhost (unknown [10.22.10.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 52D055D9C6;
        Thu, 26 Aug 2021 18:13:57 +0000 (UTC)
Date:   Thu, 26 Aug 2021 14:13:56 -0400
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] KVM: x86: Fix stack-out-of-bounds memory access
 from ioapic_write_indirect()
Message-ID: <20210826181356.xhsie7kkqoeukeju@habkost.net>
References: <CAOpTY_ot8teH5x5vVS2HvuMx5LSKLPtyen_ZUM1p7ncci4LFbA@mail.gmail.com>
 <87k0kakip9.fsf@vitty.brq.redhat.com>
 <2df0b6d18115fb7f2701587b7937d8ddae38e36a.camel@redhat.com>
 <87h7fej5ov.fsf@vitty.brq.redhat.com>
 <36b6656637d1e6aaa2ab5098f7ebc27644466294.camel@redhat.com>
 <87bl5lkgfm.fsf@vitty.brq.redhat.com>
 <CAOpTY_q=0cuxXAToJrcqCRERY_sUSB1HNVBVNiEpH6Dsy0-+yA@mail.gmail.com>
 <87tujcidka.fsf@vitty.brq.redhat.com>
 <20210826145210.gpfbiagntwoswrzp@habkost.net>
 <YSfW62JxXXBI1/UE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YSfW62JxXXBI1/UE@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 26, 2021 at 06:01:15PM +0000, Sean Christopherson wrote:
> On Thu, Aug 26, 2021, Eduardo Habkost wrote:
> > > @@ -918,7 +918,7 @@ static bool kvm_apic_is_broadcast_dest(struct kvm *kvm, struct kvm_lapic **src,
> > >  static inline bool kvm_apic_map_get_dest_lapic(struct kvm *kvm,
> > >                 struct kvm_lapic **src, struct kvm_lapic_irq *irq,
> > >                 struct kvm_apic_map *map, struct kvm_lapic ***dst,
> > > -               unsigned long *bitmap)
> > > +               unsigned long *bitmap64)
> > 
> > You can communicate the expected bitmap size to the compiler
> > without typedefs if using DECLARE_BITMAP inside the function
> > parameter list is acceptable coding style (is it?).
> > 
> > For example, the following would have allowed the compiler to
> > catch the bug you are fixing:
> > 
> > Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> > ---
> > diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> > index d7c25d0c1354..e8c64747121a 100644
> > --- a/arch/x86/kvm/lapic.h
> > +++ b/arch/x86/kvm/lapic.h
> > @@ -236,7 +236,7 @@ bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
> >  void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
> >  
> >  void kvm_bitmap_or_dest_vcpus(struct kvm *kvm, struct kvm_lapic_irq *irq,
> > -			      unsigned long *vcpu_bitmap);
> > +			      DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS));
> >  
> >  bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq *irq,
> >  			struct kvm_vcpu **dest_vcpu);
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 76fb00921203..1df113894cba 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -1166,7 +1166,7 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
> >   * each available vcpu to identify the same.
> >   */
> >  void kvm_bitmap_or_dest_vcpus(struct kvm *kvm, struct kvm_lapic_irq *irq,
> > -			      unsigned long *vcpu_bitmap)
> > +			      DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS))
> >  {
> >  	struct kvm_lapic **dest_vcpu = NULL;
> >  	struct kvm_lapic *src = NULL;
> 
> Sadly, that would not have actually caught the bug.  In C++, an array param does
> indeed have a fixed size, but in C an array param is nothing more than syntatic
> sugar that is demoted to a plain ol' pointer.  E.g. gcc-10 and clang-11 both
> happily compile with "DECLARE_BITMAP(vcpu_bitmap, 0)" and the original single
> "unsigned long vcpu_bitmap".  Maybe there are gcc extensions to enforce array
> sizes?  But if there are, they are not (yet) enabled for kernel builds.

The compiler wouldn't have caught it today only because Linux is
compiled with `-Wno-stringop-overflow`.  I have some hope that
eventually the warning will be enabled, as indicated on the
commit message if commit 5a76021c2eff ("gcc-10: disable
'stringop-overflow' warning for now").

Even if the warning isn't enabled, the bitmap size declaration
would be a hint for humans reading the code.

-- 
Eduardo

