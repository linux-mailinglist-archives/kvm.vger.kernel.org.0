Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D4D1C5489
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 13:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbgEELkv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 07:40:51 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26473 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727090AbgEELkv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 07:40:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588678848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OlAdU6/nOacYHUCLOD5Zi1nKBtXm6BwKAesECeCW+3s=;
        b=b1FaYEZuGDr5jOHe2ZFqZsPA7fc75EqYX8woK5ZGbQvCfsbVDUSL0EFYK8xOxGwMVkXG7u
        rC70GpDDELkukV6CeI6NpslXEcztxAw7VSlp2oEa/tUyG4u2ozDOrNsotfUSKCrSXlpfju
        Mf2RJX8jMGnlIEsVGQ2tNwyyerX71j8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-GmWvodbxNKSrZrkiXB3jvQ-1; Tue, 05 May 2020 07:40:47 -0400
X-MC-Unique: GmWvodbxNKSrZrkiXB3jvQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09C51835B40;
        Tue,  5 May 2020 11:40:46 +0000 (UTC)
Received: from maximlenovopc.usersys.redhat.com (unknown [10.35.206.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C03B219C4F;
        Tue,  5 May 2020 11:40:44 +0000 (UTC)
Message-ID: <bec5e02f456a1be682e680c06326afd183c23318.camel@redhat.com>
Subject: Re: AVIC related warning in enable_irq_window
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Date:   Tue, 05 May 2020 14:40:43 +0300
In-Reply-To: <efbe933a-3ab6-fa57-37fb-affc87369948@amd.com>
References: <9ce7bb5c4fb8bcc4ac21103f7534a6edfcbe195d.camel@redhat.com>
         <758b27a8-74c0-087d-d90b-d95faee2f561@redhat.com>
         <c5c32371-4b4e-1382-c616-3830ba46bf85@amd.com>
         <159382e7fdf0f9b50d79e29554842289e92e1ed7.camel@redhat.com>
         <d22d32de-5d91-662a-bf53-8cfb115dbe8d@redhat.com>
         <c81cf9bb-840a-d076-bc0e-496916621bdd@amd.com>
         <23b0dfe5-eba4-136b-0d4a-79f57f8a03ff@redhat.com>
         <efbe933a-3ab6-fa57-37fb-affc87369948@amd.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-05-05 at 14:55 +0700, Suravee Suthikulpanit wrote:
> Paolo / Maxim,
> 
> On 5/4/20 5:49 PM, Paolo Bonzini wrote:
> > On 04/05/20 12:37, Suravee Suthikulpanit wrote:
> > > On 5/4/20 4:25 PM, Paolo Bonzini wrote:
> > > > On 04/05/20 11:13, Maxim Levitsky wrote:
> > > > > On Mon, 2020-05-04 at 15:46 +0700, Suravee Suthikulpanit wrote:
> > > > > > On 5/2/20 11:42 PM, Paolo Bonzini wrote:
> > > > > > > On 02/05/20 15:58, Maxim Levitsky wrote:
> > > > > > > > The AVIC is disabled by svm_toggle_avic_for_irq_window, which calls
> > > > > > > > kvm_request_apicv_update, which broadcasts the
> > > > > > > > KVM_REQ_APICV_UPDATE vcpu request,
> > > > > > > > however it doesn't broadcast it to CPU on which now we are
> > > > > > > > running, which seems OK,
> > > > > > > > because the code that handles that broadcast runs on each VCPU
> > > > > > > > entry, thus when this CPU will enter guest mode it will notice 
> > > > > > > > and disable the AVIC. >>>>>>>
> > > > > > > > However later in svm_enable_vintr, there is test
> > > > > > > > 'WARN_ON(kvm_vcpu_apicv_active(&svm->vcpu));'
> > > > > > > > which is still true on current CPU because of the above.
> > > > > > > 
> > > > > > > Good point!  We can just remove the WARN_ON I think.  Can you send
> > > > > > > a patch?
> > > > > > > 
> > > > > > 
> > > > > > Instead, as an alternative to remove the WARN_ON(), would it be
> > > > > > better to just explicitly calling kvm_vcpu_update_apicv(vcpu) 
> > > > > > to update the apicv_active flag right after kvm_request_apicv_update()?
> > > > > > 
> > > > > 
> > > > > This should work IMHO, other that the fact kvm_vcpu_update_apicv will
> > > > > be called again, when this vcpu is entered since the KVM_REQ_APICV_UPDATE
> > > > > will still be pending on it.
> > > > > It shoudn't be a problem, and we can even add a check to do nothing
> > > > > when it is called while avic is already in target enable state.
> > > > 
> > > > I thought about that but I think it's a bit confusing.  If we want to
> > > > keep the WARN_ON, Maxim can add an equivalent one to svm_vcpu_run, which
> > > > is even better because the invariant is clearer.
> > > > 
> > > > WARN_ON((vmcb->control.int_ctl & (AVIC_ENABLE_MASK | V_IRQ_MASK))
> > > >      == (AVIC_ENABLE_MASK | V_IRQ_MASK));
> > > > 
> 
> Based on my experiment, it seems that the hardware sets the V_IRQ_MASK bit
> when #VMEXIT despite this bit being ignored when AVIC is enabled.
> (I'll double check w/ HW team on this.) In this case, I don't think we can
> use the WARN_ON() as suggested above.
> 
> I think we should keep the warning in the svm_set_vintr() since we want to know
> if the V_IRQ, V_INTR_PRIO, V_IGN_TPR, and V_INTR_VECTOR are ignored when calling
> svm_set_vintr().
> 
> Instead, I would consider explicitly call kvm_vcpu_update_apicv() since it would
> be benefit from not having to wait for the next vcpu_enter_guest for this vcpu to process
> the request. This is less confusing to me. In this case, we would need to
> kvm_clear_request(KVM_REQ_APICV_UPDATE) for this vcpu as well.
> 
> On the other hand, would be it useful to implement kvm_make_all_cpus_request_but_self(),
> which sends request to all other corpus excluding itself?
> 
> > By the way, there is another possible cleanup: the clearing
> > of V_IRQ_MASK can be removed from interrupt_window_interception since it
> > has already called svm_clear_vintr.
> 
> Maxim, I can help with the clean up patches if you would prefer.

I currently am waiting for the decision on how to we are going to fix this.
I don't have a strong opinion on how to fix this, but at least I think that we know
what is going on. 

Initially I was thinking that something was broken in AVIC, especially when I noticed
that guest would hang when I did LatencyMon benchmark in it.
Luckily the other fix that I tested and reviewed seems to fix those hangs.

In a few days I plan to do some nvme passthrough stress testing as I used to do when I was
developing my nvme-mdev driver with AVIC. I am very curios on how this will turn out.

Best regards,
	Maxim Levitsky

> 
> Thanks,
> Suravee
> 
> 
> > Paolo
> > 
> 
> 


