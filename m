Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 866D450FA4D
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 12:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348709AbiDZK0E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 06:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348793AbiDZKYa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 06:24:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C09AA41610
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 02:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650967027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nH/kzPacu74Tb0AxBpbIarW9EtUKtoQceiXEHD0vRjc=;
        b=Fb9ZUSWpxJ356CJveawotUMCQgtFS+vhJ66Uq3P45w69xkbSZiDtjlBRB2QhPZFay70Qm6
        gqFBAu3bA+hp7wrm5jkJLz9GvhqWeAhPCRFTMSZJwl2KK7hVa4Yz1IZBfUvFyPkj1fDaRe
        OCJPxAzjUbi+ch+ifU3hhzvvhzhS7Ko=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-0Pha0KxRPpu1hqTG0h6Cbg-1; Tue, 26 Apr 2022 05:57:02 -0400
X-MC-Unique: 0Pha0KxRPpu1hqTG0h6Cbg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C49618019E7;
        Tue, 26 Apr 2022 09:57:01 +0000 (UTC)
Received: from starship (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9890340D282C;
        Tue, 26 Apr 2022 09:56:58 +0000 (UTC)
Message-ID: <41b1e63ad6e45be019bbedc93bd18cfcb9475b06.camel@redhat.com>
Subject: Re: [PATCH v2 11/12] KVM: SVM: Do not inhibit APICv when x2APIC is
 present
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Tue, 26 Apr 2022 12:56:56 +0300
In-Reply-To: <b9ee5f62e904a690d7e2d8837ade8ece7e24a359.camel@redhat.com>
References: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
         <20220412115822.14351-12-suravee.suthikulpanit@amd.com>
         <3fd0aabb6288a5703760da854fd6b09a485a2d69.camel@redhat.com>
         <01460b72-1189-fef1-9718-816f2f658d42@amd.com>
         <b9ee5f62e904a690d7e2d8837ade8ece7e24a359.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-04-26 at 10:06 +0300, Maxim Levitsky wrote:
> On Tue, 2022-04-26 at 09:25 +0700, Suravee Suthikulpanit wrote:
> > Hi Maim,
> > 
> > On 4/19/22 8:29 PM, Maxim Levitsky wrote:
> > > On Tue, 2022-04-12 at 06:58 -0500, Suravee Suthikulpanit wrote:
> > > 
> > > Hi!
> > > 
> > > 
> > > I just got an idea, while writing a kvm selftest that would use AVIC,
> > > and finding out that selftest code uploads the '-host' cpuid right away
> > > which has x2apic enabled and that inhibits AVIC, and later clearing x2apic
> > > in the cpuid doesn't un-inhibit it.
> > >   
> > > That can be fixed in few ways but that got me thinking:
> > >   
> > > Why do we inhibit AVIC when the guest uses x2apic, even without X2AVIC?
> > > I think that if we didn't it would just work, and even work faster than
> > > pure software x2apic.
> > >   
> > > My thinking is:
> > >   
> > > - when a vcpu itself uses its x2apic, even if its avic is not inhibited,
> > > the guest will write x2apic msrs which kvm intercepts and will correctly emulate a proper x2apic.
> > >   
> > > - vcpu peers will also use x2apic msrs and again it will work correctly
> > > (even when there are more than 256 vcpus).
> > >   
> > > - and the host + iommu will still be able to use AVIC's doorbell to send interrupts to the guest
> > > and that doesn't need apic ids or anything, it should work just fine.
> > > 
> > > Also AVIC should have no issues scanning IRR and injecting interrupts on VM entry,
> > > x2apic mode doesn't matter for that.
> > >   
> > > AVIC mmio can still be though discovered by the guest which is technically against x86 spec
> > > (in x2apic mode, mmio supposed to not work) but that can be fixed easily by disabing
> > > the AVIC memslot if any of the vCPUs are in x2apic mode, or this can be ignored since
> > > it should not cause any issues.
> > > We seem to have a quirk for that KVM_X86_QUIRK_LAPIC_MMIO_HOLE.
> > >   
> > > On top of all this, removing this inhibit will also allow to test AVIC with guest
> > > which does have x2apic in the CPUID but doesn't use it (e.g kvm unit test, or
> > > linux booted with nox2apic, which is also nice IMHO)
> > >   
> > > What do you think?
> > 
> > This is actually a good idea!!! Let's call it hybrid-x2AVIC :)
> > 
> > I am working on prototype and test out the support for this, which will be introduced in V3.
> 
> Thanks! 
> 
> Best regards,
> 	Maxim Levitsky
> 
> > Regards,
> > Suravee
> > 

BTW, can I ask you to check something on the AMD side of things of AVIC?

I noticed that AMD's manual states that:

"Multiprocessor VM requirements. When running a VM which has multiple virtual CPUs, and the
VMM runs a virtual CPU on a core which had last run a different virtual CPU from the same VM,
regardless of the respective ASID values, care must be taken to flush the TLB on the VMRUN using a
TLB_CONTROL value of 3h. Failure to do so may result in stale mappings misdirecting virtual APIC
accesses to the previous virtual CPU's APIC backing page."

It it relevant to KVM? I don't fully understand why it was mentioned that ASID doesn't matter,
what makes it special about 'virtual CPU from the same VM' if ASID doesn't matter? 

Also, is this still relevant on modern AMD cpus, or was a workaround for some old CPU bug?

Best regards,
	Maxim Levitsky

