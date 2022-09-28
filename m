Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBA475ED463
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 07:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbiI1Fza (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 01:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbiI1Fz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 01:55:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8088D6D553
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 22:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664344524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qSKMoML8jlo7ktvItBy7/G7Ijp2CasJY8TKQOTvEDco=;
        b=Nbp3Mxt8Gh1jlIbJea9HGhdO8X5UWXb0MJwCNoGEItVbxHMIMNAl8Q2xhGGdqRb9gBshVq
        3wl0tgYD/Y2aKse/0isZ1bJAcKw3TqUccdTLQi9tm2afgkn/UbzYIjJpHPjY1EwXo06DKo
        7TSJweTplDSBUL5u4Z7bd4LLOGfnfnM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-12-I-1dG2VSONCxTzQXFdx6Jg-1; Wed, 28 Sep 2022 01:55:22 -0400
X-MC-Unique: I-1dG2VSONCxTzQXFdx6Jg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12A7E185A7A8;
        Wed, 28 Sep 2022 05:55:22 +0000 (UTC)
Received: from starship (unknown [10.40.193.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F0462027061;
        Wed, 28 Sep 2022 05:55:19 +0000 (UTC)
Message-ID: <e5d54876b233dc71a69249c3d02d649da5040a14.camel@redhat.com>
Subject: Re: [PATCH v3 05/28] KVM: x86: Don't inhibit APICv/AVIC if xAPIC ID
 mismatch is due to 32-bit ID
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 28 Sep 2022 08:55:18 +0300
In-Reply-To: <d02d0b30-f29b-0ff6-98c7-89ddcd091c60@oracle.com>
References: <20220920233134.940511-1-seanjc@google.com>
         <20220920233134.940511-6-seanjc@google.com>
         <d02d0b30-f29b-0ff6-98c7-89ddcd091c60@oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-09-27 at 23:15 -0400, Alejandro Jimenez wrote:
> 
> On 9/20/2022 7:31 PM, Sean Christopherson wrote:
> > Truncate the vcpu_id, a.k.a. x2APIC ID, to an 8-bit value when comparing
> > it against the xAPIC ID to avoid false positives (sort of) on systems
> > with >255 CPUs, i.e. with IDs that don't fit into a u8.  The intent of
> > APIC_ID_MODIFIED is to inhibit APICv/AVIC when the xAPIC is changed from
> > it's original value,
> > 
> > The mismatch isn't technically a false positive, as architecturally the
> > xAPIC IDs do end up being aliased in this scenario, and neither APICv
> > nor AVIC correctly handles IPI virtualization when there is aliasing.
> > However, KVM already deliberately does not honor the aliasing behavior
> > that results when an x2APIC ID gets truncated to an xAPIC ID.  I.e. the
> > resulting APICv/AVIC behavior is aligned with KVM's existing behavior
> > when KVM's x2APIC hotplug hack is effectively enabled.
> > 
> > If/when KVM provides a way to disable the hotplug hack, APICv/AVIC can
> > piggyback whatever logic disables the optimized APIC map (which is what
> > provides the hotplug hack), i.e. so that KVM's optimized map and APIC
> > virtualization yield the same behavior.
> > 
> > For now, fix the immediate problem of APIC virtualization being disabled
> > for large VMs, which is a much more pressing issue than ensuring KVM
> > honors architectural behavior for APIC ID aliasing.
> 
> I built a host kernel with this entire series on top of mainline 
> v6.0-rc6, and booting a guest with AVIC enabled works as expected on the 
> initial boot. The issue is that during the first reboot AVIC is 
> inhibited due to APICV_INHIBIT_REASON_APIC_ID_MODIFIED, and I see 
> constant inhibition events due to APICV_INHIBIT_REASON_IRQWIN as seen in 


APICV_INHIBIT_REASON_IRQWIN is OK, because that happens about every time
the good old PIT timer fires which happens on reboot.

APICV_INHIBIT_REASON_APIC_ID_MODIFIED should not happen as you noted,
this needs investigation.

Best regards,
	Maxim Levitsky

> the traces:
> 
> qemu-system-x86-10147   [222] .....  1116.519052: 
> kvm_apicv_inhibit_changed: set reason=8, inhibits=0x120
> qemu-system-x86-10147   [222] .....  1116.519063: 
> kvm_apicv_inhibit_changed: cleared reason=8, inhibits=0x20
> qemu-system-x86-10147   [222] .....  1117.934222: 
> kvm_apicv_inhibit_changed: set reason=8, inhibits=0x120
> qemu-system-x86-10147   [222] .....  1117.934233: 
> kvm_apicv_inhibit_changed: cleared reason=8, inhibits=0x20
> 
> It happens regardless of vCPU count (tested with 2, 32, 255, 380, and 
> 512 vCPUs). This state persists for all subsequent reboots, until the VM 
> is terminated. For vCPU counts < 256, when x2apic is disabled the 
> problem does not occur, and AVIC continues to work properly after reboots.
> 
> I did not see this issue when testing a similar host kernel that did not 
> include this current patchset, but instead applied the earlier:
> https://lore.kernel.org/lkml/20220909195442.7660-1-suravee.suthikulpanit@amd.com/
> which inspired this [05/23] patch and the follow up [22/28] in this series.
> 
> I am using QEMU built from v7.1.0 upstream tag, plus the patch at:
> https://lore.kernel.org/qemu-devel/20220504131639.13570-1-suravee.suthikulpanit@amd.com/
> 
> Please feel free to request any other data points that might be relevant 
> and I'll try to collect them.
> 
> Alejandro
> > Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
> > Reported-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> > Cc: Maxim Levitsky <mlevitsk@redhat.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/lapic.c | 7 ++++++-
> >   1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index adac6ca9b7dc..a02defa3f7b5 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -2075,7 +2075,12 @@ static void kvm_lapic_xapic_id_updated(struct kvm_lapic *apic)
> >   	if (KVM_BUG_ON(apic_x2apic_mode(apic), kvm))
> >   		return;
> >   
> > -	if (kvm_xapic_id(apic) == apic->vcpu->vcpu_id)
> > +	/*
> > +	 * Deliberately truncate the vCPU ID when detecting a modified APIC ID
> > +	 * to avoid false positives if the vCPU ID, i.e. x2APIC ID, is a 32-bit
> > +	 * value.
> > +	 */
> > +	if (kvm_xapic_id(apic) == (u8)apic->vcpu->vcpu_id)
> >   		return;
> >   
> >   	kvm_set_apicv_inhibit(apic->vcpu->kvm, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);


