Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E84885EE42D
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 20:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234738AbiI1SRW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 14:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234032AbiI1SRH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 14:17:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97DA10759E
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 11:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664388969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xMO4mKpfNczNxeZW1DT6bXLOYvg3cQC3Gxcwr3VGJ+Y=;
        b=ee+yB4VKe6PGRJnkGkRLyHw3MW886tVv+8TFHGcwSdOf6V3J3pUauQMIf043+zQC1R0aIg
        FobAFMuPaUxNc/T6YRRaS1TvBmk8PxcOBoETSjCqI+VRWTYgBRcHMl09H1wdMgpoSLbUT1
        mMX0hX8kOjK+PChNqV1GOCKSTCiXh1w=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-6yJpjjx-NnuSdGWveV2tog-1; Wed, 28 Sep 2022 14:16:04 -0400
X-MC-Unique: 6yJpjjx-NnuSdGWveV2tog-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 691113826242;
        Wed, 28 Sep 2022 18:16:03 +0000 (UTC)
Received: from starship (unknown [10.40.193.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89F33492CA2;
        Wed, 28 Sep 2022 18:16:01 +0000 (UTC)
Message-ID: <6fcec4adb331452c64adf255c367af86072bd9d3.camel@redhat.com>
Subject: Re: [PATCH v3 05/28] KVM: x86: Don't inhibit APICv/AVIC if xAPIC ID
 mismatch is due to 32-bit ID
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 28 Sep 2022 21:16:00 +0300
In-Reply-To: <YzSMbSXQXyUY7M7G@google.com>
References: <20220920233134.940511-1-seanjc@google.com>
         <20220920233134.940511-6-seanjc@google.com>
         <d02d0b30-f29b-0ff6-98c7-89ddcd091c60@oracle.com>
         <e5d54876b233dc71a69249c3d02d649da5040a14.camel@redhat.com>
         <YzR7ezt67i1lH1/b@google.com>
         <1aea43e831cd7ed90c325b2c90bc6f3f9a1805b5.camel@redhat.com>
         <YzSMbSXQXyUY7M7G@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-09-28 at 18:03 +0000, Sean Christopherson wrote:
> On Wed, Sep 28, 2022, Maxim Levitsky wrote:
> > On Wed, 2022-09-28 at 16:51 +0000, Sean Christopherson wrote:
> > > > > It happens regardless of vCPU count (tested with 2, 32, 255, 380, and 
> > > > > 512 vCPUs). This state persists for all subsequent reboots, until the VM 
> > > > > is terminated. For vCPU counts < 256, when x2apic is disabled the 
> > > > > problem does not occur, and AVIC continues to work properly after reboots.
> > > 
> > > Bit of a shot in the dark, but does the below fix the issue?  There are two
> > > issues with calling kvm_lapic_xapic_id_updated() from kvm_apic_state_fixup():
> > > 
> > >   1. The xAPIC ID should only be refreshed on "set".
> > True - I didn't bother to fix it yet because it shouldn't cause harm, but
> > sure this needs to be fixed.
> 
> It's probably benign on its own, but with the missing "hardware enabled" check,
> it could be problematic if userspace does KVM_GET_LAPIC while the APIC is hardware
> disabled, after the APIC was previously in x2APIC mode.  I'm guessing QEMU does
> KVM_GET_LAPIC state when emulating reboot, hence the potential for being involved
> in the bug Alejandro is seeing.
> 
> > >   2. The refresh needs to be noted after memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
> > Are you sure? The check is first because if it fails, then error is returned to userspace
> > and the KVM's state left unchanged.
> > 
> > I assume you are talking about 
> > 
> >         ....
> > 	r = kvm_apic_state_fixup(vcpu, s, true);
> > 	if (r) {
> > 		kvm_recalculate_apic_map(vcpu->kvm);
> > 		return r;
> > 	}
> > 	memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
> 
> This isn't a failure path though, it's purely a "take note of the update", and
> KVM needs to do that processing _after_ the actual update.  Specifically,
> kvm_lapic_xapic_id_updated() consumes the internal APIC state:

Yes, I somehow blindly assumed that kvm_apic_state_fixup actually checks
the new state and not the existing state.

Probably because my original code did that, I think it just checked the 'id'
variable.. Oh well.
Thanks for catching this bug!

Best regards,
	Maxim Levitsky

> 
> 	if (kvm_xapic_id(apic) == apic->vcpu->vcpu_id)
> 		return;
> 
> Calling that before the internal state has been set with the incoming state from
> userspace is simply wrong.
> 
> The check that the x2APIC ID is "correct" stays where it is, this is purely the
> "is the xAPIC ID different" path.
> 


