Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534EF517591
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 19:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385905AbiEBRQ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 13:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242903AbiEBRQy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 13:16:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E5A2C627B
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 10:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651511604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7vf4sT7dDfJ18mM5fdZ4gMEt5hbjvc3fPcu9zyp1RQg=;
        b=SbXe1IzoPfwVfTeixcF1YwtJxscXzJHV6uMGhJSyWeeRkNyamPbAvrXe84xfYPEWUYIW7O
        aH2Jum3Dvb9Kt9T6f76M13RXcVkBA+6+WeW2Bav7i5th3VpDXuvhs6YqCl2DACrJ0mbbu4
        fgTap0Xi8weOQmJ0BGacuAazHQ8+yFE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-277-KvGehVF_Pf2MdwaAFs1QEA-1; Mon, 02 May 2022 13:13:23 -0400
X-MC-Unique: KvGehVF_Pf2MdwaAFs1QEA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67CA7801210;
        Mon,  2 May 2022 17:13:22 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5216440E7F06;
        Mon,  2 May 2022 17:13:20 +0000 (UTC)
Message-ID: <24b74f5bd8810c7f79777ed6898baeaf47bfe3e3.camel@redhat.com>
Subject: Re: [PATCH v2 08/12] KVM: SVM: Update AVIC settings when changing
 APIC mode
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Mon, 02 May 2022 20:13:19 +0300
In-Reply-To: <9307c734-3473-0bdc-57be-c39e96bca4d8@amd.com>
References: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
         <20220412115822.14351-9-suravee.suthikulpanit@amd.com>
         <abb93e2d73b7ada6cbabcd3ebbf7b38e4701ec57.camel@redhat.com>
         <9307c734-3473-0bdc-57be-c39e96bca4d8@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-05-02 at 21:07 +0700, Suravee Suthikulpanit wrote:
> Maxim, Sean
> 
> On 4/18/22 7:55 PM, Maxim Levitsky wrote:
> > On Tue, 2022-04-12 at 06:58 -0500, Suravee Suthikulpanit wrote:
> > > When APIC mode is updated (e.g. disabled, xAPIC, or x2APIC),
> > > KVM needs to call kvm_vcpu_update_apicv() to update AVIC settings
> > > accordingly.
> > > 
> > > Signed-off-by: Suravee Suthikulpanit<suravee.suthikulpanit@amd.com>
> > > ---
> > >   arch/x86/kvm/svm/avic.c | 15 +++++++++++++++
> > >   arch/x86/kvm/svm/svm.c  |  1 +
> > >   2 files changed, 16 insertions(+)
> > > 
> > > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > > index 22ee1098e2a5..01392b8364f4 100644
> > > --- a/arch/x86/kvm/svm/avic.c
> > > +++ b/arch/x86/kvm/svm/avic.c
> > > @@ -616,6 +616,21 @@ void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
> > >   	avic_handle_ldr_update(vcpu);
> > >   }
> > >   
> > > +void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
> > > +{
> > > +	struct vcpu_svm *svm = to_svm(vcpu);
> > > +
> > > +	if (!lapic_in_kernel(vcpu) || (avic_mode == AVIC_MODE_NONE))
> > > +		return;
> > > +
> > > +	if (kvm_get_apic_mode(vcpu) == LAPIC_MODE_INVALID) {
> > > +		WARN_ONCE(true, "Invalid local APIC state (vcpu_id=%d)", vcpu->vcpu_id);
> > > +		return;
> > > +	}
> > > +
> > > +	kvm_vcpu_update_apicv(&svm->vcpu);
> > I think it makes sense to call avic_refresh_apicv_exec_ctrl directly here.
> >   
> > I am not sure that kvm_vcpu_update_apicv will even call it
> > because it has an optimization of doing nothing when inhibition status
> > didn't change.
> >   
> >   
> > Another semi-related note:
> >   
> > the current way the x2avic msrs are configured creates slight performance
> > problem for nesting:
> >   
> > The problem is that when entering a nested guest, AVIC on the current vCPU
> > is inhibited, but this is done only so that this vCPU*peers*  don't
> > try to use AVIC to send IPIs to it, so there is no need to update vmcb01
> > msr interception bitmap, and vmcb02 should have all these msrs intercepted always.
> > Same with returning to host.
> > 
> > It also should be checked that during nested entry, at least vmcb01 msr bitmap
> > is updated - TL;DR - please check that x2avic works when there is a nested guest running.
> 
> In the kvm/queue branch, I found a regression on nested SVM guest, where L2 guest cannot
> launch. The bad commit is:
> 
> commit a4cfff3f0f8c07f1f7873a82bdeb3995807dac8c (bisect)
> Merge: 42dcbe7d8bac 8d5678a76689
> Author: Paolo Bonzini <pbonzini@redhat.com>
> Date:   Fri Apr 8 12:43:40 2022 -0400
> 
>      Merge branch 'kvm-older-features' into HEAD
> 
>      Merge branch for features that did not make it into 5.18:
> 
>      * New ioctls to get/set TSC frequency for a whole VM
> 
>      * Allow userspace to opt out of hypercall patching
> 
>      Nested virtualization improvements for AMD:
> 
>      * Support for "nested nested" optimizations (nested vVMLOAD/VMSAVE,
>        nested vGIF)
> 
>      * Allow AVIC to co-exist with a nested guest running
> 
>      * Fixes for LBR virtualizations when a nested guest is running,
>        and nested LBR virtualization support
> 
>      * PAUSE filtering for nested hypervisors
> 
>      Guest support:
> 
>      * Decoupling of vcpu_is_preempted from PV spinlocks
> 
>      Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> I am still working on the bisect into the merge commits.
> 
> Regards,
> Suravee
> 

What happens when the guest can't launch? It sure works for me for kvm/queue
from yesterday.

I'll test again tomorrow.


Best regards,
	Maxim Levitsky

