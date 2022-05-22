Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C39E5302F6
	for <lists+kvm@lfdr.de>; Sun, 22 May 2022 14:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245270AbiEVMNR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 May 2022 08:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235275AbiEVMNN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 May 2022 08:13:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8F4BD38DBA
        for <kvm@vger.kernel.org>; Sun, 22 May 2022 05:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653221591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MgC5JNYrsgqgs2qTUiLYfjxLufYrNUR4cj0BHzuGBF0=;
        b=SVZ+lwn0wz92NhbVqQjWcZtXUD+/dIvq6npk8kQ44DM2uh6UW8L+j/urnMCGLloKBoZVQQ
        WcB3uIF1t08gfEBTpdclQAkMDAf2fu1TUqe6vlCukDkh1IEtJ78ZK4BPveMvq4B2SmVeFB
        5s4sukDxazeE6KhmZ1DM655akyH1aDE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-381-iLoXoZYkOo6_1bgTYeSohw-1; Sun, 22 May 2022 08:13:05 -0400
X-MC-Unique: iLoXoZYkOo6_1bgTYeSohw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A6EF801210;
        Sun, 22 May 2022 12:13:04 +0000 (UTC)
Received: from starship (unknown [10.40.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F17F40D2821;
        Sun, 22 May 2022 12:12:57 +0000 (UTC)
Message-ID: <f7ef15598cf350f8c5ec8d58c8e2eb51b48c48df.camel@redhat.com>
Subject: Re: [RFC PATCH v3 06/19] KVM: x86: mmu: add gfn_in_memslot helper
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Date:   Sun, 22 May 2022 15:12:56 +0300
In-Reply-To: <YoZzx6f1XBWL3i8F@google.com>
References: <20220427200314.276673-1-mlevitsk@redhat.com>
         <20220427200314.276673-7-mlevitsk@redhat.com> <YoZzx6f1XBWL3i8F@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-05-19 at 16:43 +0000, Sean Christopherson wrote:
> On Wed, Apr 27, 2022, Maxim Levitsky wrote:
> > This is a tiny refactoring, and can be useful to check
> > if a GPA/GFN is within a memslot a bit more cleanly.
> 
> This doesn't explain the actual motivation, which is to use the new helper from
> arch code.
I'll add this in the next version
> 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  include/linux/kvm_host.h | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 252ee4a61b58b..12e261559070b 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1580,6 +1580,13 @@ int kvm_request_irq_source_id(struct kvm *kvm);
> >  void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
> >  bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
> >  
> > +
> > +static inline bool gfn_in_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
> > +{
> > +	return (gfn >= slot->base_gfn && gfn < slot->base_gfn + slot->npages);
> > +}
> > +
> 
> Spurious newline.
> 
> > +
> >  /*
> >   * Returns a pointer to the memslot if it contains gfn.
> >   * Otherwise returns NULL.
> > @@ -1590,12 +1597,13 @@ try_get_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
> >  	if (!slot)
> >  		return NULL;
> >  
> > -	if (gfn >= slot->base_gfn && gfn < slot->base_gfn + slot->npages)
> > +	if (gfn_in_memslot(slot, gfn))
> >  		return slot;
> >  	else
> >  		return NULL;
> 
> At this point, maybe:

No objections.

Thanks for the review.

Best regards,
	Maxim Levitsky

> 
> 	if (!slot || !gfn_in_memslot(slot, gfn))
> 		return NULL;
> 
> 	return slot;
> 
> >  }
> >  
> > +
> >  /*
> >   * Returns a pointer to the memslot that contains gfn. Otherwise returns NULL.
> >   *
> > -- 
> > 2.26.3
> > 


