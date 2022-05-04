Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB262519FB0
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 14:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349759AbiEDMmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 08:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237088AbiEDMmA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 08:42:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DACA03153B
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 05:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651667904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ms3vBOzjdykqtqTIylMUH3d5wQ67nCMPvsMGcNx/MSY=;
        b=O6rl8LUIxy/W+VJFwQqWr33YNYdebC8SXRDCAWXWfRZQ3W3X6qKC4o60k1qdrPzZtzWqeo
        veoOnY5vr7CkbmlkNQeB5A+Xy+5GTTLLttIBJfWCONNujCEJ8iatRpYrcXFAFWngbTvf2/
        oQlEoVA63QQs+0ezFod0nzhQih/tKiY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-bCngVF--NPapvpRhhg5BgQ-1; Wed, 04 May 2022 08:38:15 -0400
X-MC-Unique: bCngVF--NPapvpRhhg5BgQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE96E85A5BC;
        Wed,  4 May 2022 12:38:14 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5A36469A4E;
        Wed,  4 May 2022 12:38:12 +0000 (UTC)
Message-ID: <8dd1c5cc4944145364bc1d16ced8ce0314be0ff5.camel@redhat.com>
Subject: Re: [PATCH v2 08/12] KVM: SVM: Update AVIC settings when changing
 APIC mode
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Wed, 04 May 2022 15:38:11 +0300
In-Reply-To: <8be586dab3a80d96c88018a1919d01f2163b595d.camel@redhat.com>
References: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
         <20220412115822.14351-9-suravee.suthikulpanit@amd.com>
         <abb93e2d73b7ada6cbabcd3ebbf7b38e4701ec57.camel@redhat.com>
         <9307c734-3473-0bdc-57be-c39e96bca4d8@amd.com>
         <24b74f5bd8810c7f79777ed6898baeaf47bfe3e3.camel@redhat.com>
         <3196873f-0047-3411-d434-56d96ca31298@amd.com>
         <8a0b27436239a97cc486d8460662febb6b155069.camel@redhat.com>
         <8be586dab3a80d96c88018a1919d01f2163b595d.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-05-04 at 14:49 +0300, Maxim Levitsky wrote:
> On Wed, 2022-05-04 at 14:46 +0300, Maxim Levitsky wrote:
> > On Tue, 2022-05-03 at 20:04 +0700, Suravee Suthikulpanit wrote:
> > > Maxim,
> > > 
> > > On 5/3/22 12:13 AM, Maxim Levitsky wrote:
> > > > > In the kvm/queue branch, I found a regression on nested SVM guest, where L2 guest cannot
> > > > > launch. The bad commit is:
> > > > > 
> > > > > commit a4cfff3f0f8c07f1f7873a82bdeb3995807dac8c (bisect)
> > > > > Merge: 42dcbe7d8bac 8d5678a76689
> > > > > Author: Paolo Bonzini<pbonzini@redhat.com>
> > > > > Date:   Fri Apr 8 12:43:40 2022 -0400
> > > > > 
> > > > >       Merge branch 'kvm-older-features' into HEAD
> > > > > 
> > > > >       Merge branch for features that did not make it into 5.18:
> > > > > 
> > > > >       * New ioctls to get/set TSC frequency for a whole VM
> > > > > 
> > > > >       * Allow userspace to opt out of hypercall patching
> > > > > 
> > > > >       Nested virtualization improvements for AMD:
> > > > > 
> > > > >       * Support for "nested nested" optimizations (nested vVMLOAD/VMSAVE,
> > > > >         nested vGIF)
> > > > > 
> > > > >       * Allow AVIC to co-exist with a nested guest running
> > > > > 
> > > > >       * Fixes for LBR virtualizations when a nested guest is running,
> > > > >         and nested LBR virtualization support
> > > > > 
> > > > >       * PAUSE filtering for nested hypervisors
> > > > > 
> > > > >       Guest support:
> > > > > 
> > > > >       * Decoupling of vcpu_is_preempted from PV spinlocks
> > > > > 
> > > > >       Signed-off-by: Paolo Bonzini<pbonzini@redhat.com>
> > > > > 
> > > > > I am still working on the bisect into the merge commits.
> > > > > 
> > > > > Regards,
> > > > > Suravee
> > > > > 
> > > > What happens when the guest can't launch? It sure works for me for kvm/queue
> > > > from yesterday.
> > > > 
> > > > I'll test again tomorrow.
> > > 
> > > I have bisected it to this commit:
> > > 
> > > commit 74fd41ed16fd71725e69e2cb90b755505326c2e6
> > > Author: Maxim Levitsky <mlevitsk@redhat.com>
> > > Date:   Tue Mar 22 19:40:47 2022 +0200
> > > 
> > >      KVM: x86: nSVM: support PAUSE filtering when L0 doesn't intercept PAUSE
> > > 
> > >      Expose the pause filtering and threshold in the guest CPUID
> > >      and support PAUSE filtering when possible:
> > > 
> > >      - If the L0 doesn't intercept PAUSE (cpu_pm=on), then allow L1 to
> > >        have full control over PAUSE filtering.
> > > 
> > >      - if the L1 doesn't intercept PAUSE, use host values and update
> > >        the adaptive count/threshold even when running nested.
> > > 
> > >      - Otherwise always exit to L1; it is not really possible to merge
> > >        the fields correctly.  It is expected that in this case, userspace
> > >        will not enable this feature in the guest CPUID, to avoid having the
> > >        guest update both fields pointlessly.
> > > 
> > >      Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > >      Message-Id: <20220322174050.241850-4-mlevitsk@redhat.com>
> > >      Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > 
> > > I can revert this one or specify pause_filter_count=0 pause_filter_thresh=0,
> > > and then I can boot the L2 guest.

Another question? Where does it help to set this? In L0 kernel or in L1 kernel?

Best regards,
	Maxim Levitsky

> > > 
> > > Regards,
> > > Suravee
> > > 
> > 
> > This is really wierd.
> > 
> > Could you share the qemu command line for L1 and L2 guest, and as much as possible
> > info on what happens when you boot L2? I tested latest kvm/queue and I don't see
> > any issues with booting nested guest.
> > 
> > Which hardware you test on? I test on Zen2 (3970X) mostly.
> > 
> > How many vCPUs L2 has? Could you do a kvm trace of the L2, from L1,
> > to see what it does prior to hang?
> 
> Also assuming that you boot the L2 with -cpu host, could you not expose these two
> features to it?
> 
> -cpu host,pause-filter=off,pfthreshold=off
> 
> Best regards,
> 	Maxim Levitsky
> 
> 
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 
> > 


