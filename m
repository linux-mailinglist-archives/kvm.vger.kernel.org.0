Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A2E519E84
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 13:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349104AbiEDLx0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 07:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349090AbiEDLxZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 07:53:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 485911A063
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 04:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651664989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lKJAHoOloyDONNdaSYjDVBT2BKN9t8wZnDduhidYecg=;
        b=C/CwTbgoPgqVahxtEoPZ8bHdCJrfDqLzD0Go0oxF1oXzVSwpvy0CWV88AFX0U2ATUiprPL
        ZcvJ+urgYcUPLSvPkGAfp27N40XvM9Tip5BORLp6vcRG35o4zq3M4J+o4hd7ZfKzwRfw6M
        Z4n2omvoCMd4/HAK/X2iAWwN3AJqJYM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-512-iBXNNrykP5as9MJnw2wrMA-1; Wed, 04 May 2022 07:49:45 -0400
X-MC-Unique: iBXNNrykP5as9MJnw2wrMA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB7FB1C04B47;
        Wed,  4 May 2022 11:49:44 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A42EEC44AE2;
        Wed,  4 May 2022 11:49:42 +0000 (UTC)
Message-ID: <8be586dab3a80d96c88018a1919d01f2163b595d.camel@redhat.com>
Subject: Re: [PATCH v2 08/12] KVM: SVM: Update AVIC settings when changing
 APIC mode
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Wed, 04 May 2022 14:49:41 +0300
In-Reply-To: <8a0b27436239a97cc486d8460662febb6b155069.camel@redhat.com>
References: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
         <20220412115822.14351-9-suravee.suthikulpanit@amd.com>
         <abb93e2d73b7ada6cbabcd3ebbf7b38e4701ec57.camel@redhat.com>
         <9307c734-3473-0bdc-57be-c39e96bca4d8@amd.com>
         <24b74f5bd8810c7f79777ed6898baeaf47bfe3e3.camel@redhat.com>
         <3196873f-0047-3411-d434-56d96ca31298@amd.com>
         <8a0b27436239a97cc486d8460662febb6b155069.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-05-04 at 14:46 +0300, Maxim Levitsky wrote:
> On Tue, 2022-05-03 at 20:04 +0700, Suravee Suthikulpanit wrote:
> > Maxim,
> > 
> > On 5/3/22 12:13 AM, Maxim Levitsky wrote:
> > > > In the kvm/queue branch, I found a regression on nested SVM guest, where L2 guest cannot
> > > > launch. The bad commit is:
> > > > 
> > > > commit a4cfff3f0f8c07f1f7873a82bdeb3995807dac8c (bisect)
> > > > Merge: 42dcbe7d8bac 8d5678a76689
> > > > Author: Paolo Bonzini<pbonzini@redhat.com>
> > > > Date:   Fri Apr 8 12:43:40 2022 -0400
> > > > 
> > > >       Merge branch 'kvm-older-features' into HEAD
> > > > 
> > > >       Merge branch for features that did not make it into 5.18:
> > > > 
> > > >       * New ioctls to get/set TSC frequency for a whole VM
> > > > 
> > > >       * Allow userspace to opt out of hypercall patching
> > > > 
> > > >       Nested virtualization improvements for AMD:
> > > > 
> > > >       * Support for "nested nested" optimizations (nested vVMLOAD/VMSAVE,
> > > >         nested vGIF)
> > > > 
> > > >       * Allow AVIC to co-exist with a nested guest running
> > > > 
> > > >       * Fixes for LBR virtualizations when a nested guest is running,
> > > >         and nested LBR virtualization support
> > > > 
> > > >       * PAUSE filtering for nested hypervisors
> > > > 
> > > >       Guest support:
> > > > 
> > > >       * Decoupling of vcpu_is_preempted from PV spinlocks
> > > > 
> > > >       Signed-off-by: Paolo Bonzini<pbonzini@redhat.com>
> > > > 
> > > > I am still working on the bisect into the merge commits.
> > > > 
> > > > Regards,
> > > > Suravee
> > > > 
> > > What happens when the guest can't launch? It sure works for me for kvm/queue
> > > from yesterday.
> > > 
> > > I'll test again tomorrow.
> > 
> > I have bisected it to this commit:
> > 
> > commit 74fd41ed16fd71725e69e2cb90b755505326c2e6
> > Author: Maxim Levitsky <mlevitsk@redhat.com>
> > Date:   Tue Mar 22 19:40:47 2022 +0200
> > 
> >      KVM: x86: nSVM: support PAUSE filtering when L0 doesn't intercept PAUSE
> > 
> >      Expose the pause filtering and threshold in the guest CPUID
> >      and support PAUSE filtering when possible:
> > 
> >      - If the L0 doesn't intercept PAUSE (cpu_pm=on), then allow L1 to
> >        have full control over PAUSE filtering.
> > 
> >      - if the L1 doesn't intercept PAUSE, use host values and update
> >        the adaptive count/threshold even when running nested.
> > 
> >      - Otherwise always exit to L1; it is not really possible to merge
> >        the fields correctly.  It is expected that in this case, userspace
> >        will not enable this feature in the guest CPUID, to avoid having the
> >        guest update both fields pointlessly.
> > 
> >      Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> >      Message-Id: <20220322174050.241850-4-mlevitsk@redhat.com>
> >      Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > 
> > I can revert this one or specify pause_filter_count=0 pause_filter_thresh=0,
> > and then I can boot the L2 guest.
> > 
> > Regards,
> > Suravee
> > 
> 
> This is really wierd.
> 
> Could you share the qemu command line for L1 and L2 guest, and as much as possible
> info on what happens when you boot L2? I tested latest kvm/queue and I don't see
> any issues with booting nested guest.
> 
> Which hardware you test on? I test on Zen2 (3970X) mostly.
> 
> How many vCPUs L2 has? Could you do a kvm trace of the L2, from L1,
> to see what it does prior to hang?


Also assuming that you boot the L2 with -cpu host, could you not expose these two
features to it?

-cpu host,pause-filter=off,pfthreshold=off

Best regards,
	Maxim Levitsky


> 
> 
> Best regards,
> 	Maxim Levitsky
> 
> 


