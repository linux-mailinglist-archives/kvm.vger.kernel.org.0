Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784C35EE35A
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 19:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbiI1Rkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 13:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234607AbiI1Rku (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 13:40:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28307B4426
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 10:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664386846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fnnu4D0Chbk/Z8+NCjwUENwpIgx/DjGxPGd2Oiee5Pw=;
        b=f+IbFLLOUqwlJfPwq6BqpgqPyiho0OZjtZr2Uv6SCZv6bAq7YOCJln7Xs2bmeCQ49J2M1a
        1xOdi706fDiCll1CxoHBgD6UVAc3lW98TzSXJDIoP0AJbQwj3bJ2tX57HhLBxvv37SIKVD
        fZOXNqiFEqddS/HZpRrI+8yKcB9QYPo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-97-Te2Iw04rMlO5noLvfgVdUQ-1; Wed, 28 Sep 2022 13:40:41 -0400
X-MC-Unique: Te2Iw04rMlO5noLvfgVdUQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA82429DD99A;
        Wed, 28 Sep 2022 17:40:40 +0000 (UTC)
Received: from starship (unknown [10.40.193.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A44FE1121314;
        Wed, 28 Sep 2022 17:40:38 +0000 (UTC)
Message-ID: <2ca1b7c59e2abe661dd03309ad13eca7d692ff05.camel@redhat.com>
Subject: Re: [PATCH v3 07/28] KVM: x86: Inhibit APIC memslot if x2APIC and
 AVIC are enabled
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 28 Sep 2022 20:40:37 +0300
In-Reply-To: <YzR3PaZokwIPDoXb@google.com>
References: <20220920233134.940511-1-seanjc@google.com>
         <20220920233134.940511-8-seanjc@google.com>
         <e84ebf0a7ac9322bd0cfa742ef6dd2bbfdac0df9.camel@redhat.com>
         <YzHawRN8vpEzP7XD@google.com>
         <bcc3c67abc3b2c3d896b800c5f8f7295b7238271.camel@redhat.com>
         <YzR3PaZokwIPDoXb@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-09-28 at 16:33 +0000, Sean Christopherson wrote:
> On Wed, Sep 28, 2022, Maxim Levitsky wrote:
> > On Mon, 2022-09-26 at 17:00 +0000, Sean Christopherson wrote:
> > > Given the SRCU problem, I'd prefer to keep the management of the memslot in common
> > > code, even though I agree it's a bit silly.  And KVM_REQ_UNBLOCK is a perfect fit
> > > for dealing with the SRCU issue, i.e. handling this in AVIC code would require
> > > another hook on top of spreading the memslot management across x86 and SVM code.
> > 
> > OK, I am not going to argue about this. But what about at least not using an inhibit
> > bit for that but something else like a boolean, or maybe really add 'I am AVIC bit'
> > or rather something like vcpu->arch.apicv_type enum?
> > 
> > Or we can make SVM code just call a common function - just put these in a
> > function and call it from avic_set_virtual_apic_mode?
> 
> The issue is that kvm_vcpu_update_apicv() is called from kvm_lapic_set_base(),
> which is the one that may or may not hold SRCU.

Makes sense now.

> 
> > > > You are about to remove the KVM_REQ_UNBLOCK in other patch series.
> > > 
> > > No, KVM_REQ_UNHALT is being removed.  KVM_REQ_UNBLOCK needs to stay, although it
> > > has a rather weird name, e.g. KVM_REQ_WORK would probably be better.
> > 
> > Roger that!
> > And I guess lets rename it while we are at it.
> 
> I'll prep a patch.
> 
> > > > How about just raising KVM_REQ_APICV_UPDATE on current vCPU
> > > > and having a special case in kvm_vcpu_update_apicv of 
> > > > 
> > > > if (apic_access_memslot_enabled == false && apic_access_memslot_allocaed == true) {
> > > > 	drop srcu lock
> > > 
> > > This was my initial thought as well, but the issue is that SRCU may or may not be
> > > held, and so the unlock+lock would need to be conditional.  That's technically a
> > > solvable problem, as it's possible to detect if SRCU is held, but I really don't
> > > want to rely on kvm_vcpu.srcu_depth for anything other than proving that KVM doesn't
> > > screw up SRCU.
> > 
> > Why though? the KVM_REQ_APICV_UPDATE is only handled AFAIK in vcpu_enter_guest
> > which drops the srcu lock few lines afterwards, and therefore the
> > kvm_vcpu_update_apicv is always called with the lock held and it means that it
> > can drop it for the duration of slot update.
> > 
> > The original issue we had was that we tried to drop the srcu lock in 
> > 'kvm_set_apicv_inhibit' which indeed is called from various places,
> > with, or without the lock held.
> > 
> > Moving the memslot disable code to kvm_vcpu_update_apicv would actually solve
> > that, but it was not possible because kvm_vcpu_update_apicv is called
> > simultaneously on all vCPUs, and created various races, including toggling
> > the memslot twice.
> 
> As above, kvm_vcpu_update_apicv() can be called without SRCU held.  Oh, but that
> was a recent addition, commit 8fc9c7a3079e ("KVM: x86: Deactivate APICv on vCPU
> with APIC disabled").  I was wary of using KVM_REQ_APICV_UPDATE in kvm_lapic_set_base(),
> e.g. in case there was some dependency on updating _immediately, but since that's
> such a new addition I have no objection to switching to the request.
> 
> Similarly, is there a good reason for having nested_svm_vmexit() invoke
> kvm_vcpu_update_apicv() directly?  I'm confused by the "so that other vCPUs can
> start to benefit from it right away".  The nested inhibit is per-vCPU and so
> should only affect the current vCPU, no?  I.e. for all intents and purposes, using
> a request should be functionally equivalent.

It is kind of the other way around:

The mere fact of switching to vmcb02 *inhibits* the AVIC on the current vCPU,
but the AVIC inhibit is there only to set the is_running bits in the physid table
and in IOMMU to prevent its *peers* to try and send interrupts to it via AVIC.

It is the reason why APICv doesn't need it - the posted interrupts still work
just fine when a vCPU doens't use APICv, or uses a different posted interrupt vector
when it uses the nested APICv.

So it makes sense to remove that inhibit as soon as possible that the peers
could stop getting 'unaccellerated IPI' vmexits for nothing.


However back to the discussion, I don't think this is a problem.

We can just call both the kvm_vcpu_update_apicv() and a new function that
does the memslot disable from KVM_REQ_APICV_UPDATE, then 
plain kvm_vcpu_update_apicv() won't need to drop the srcu lock.

It is pretty much the same that you proposed, just instead of piggybacking on 
KVM_REQ_UNBLOCK, I proposed to piggyback on KVM_REQ_APICV_UPDATE.


Best regards,
	Maxim Levitsky


> 
> 	/*
> 	 * Un-inhibit the AVIC right away, so that other vCPUs can start
> 	 * to benefit from it right away.
> 	 */
> 	if (kvm_apicv_activated(vcpu->kvm))
> 		kvm_vcpu_update_apicv(vcpu);
> 


