Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF66753025B
	for <lists+kvm@lfdr.de>; Sun, 22 May 2022 12:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243714AbiEVKWW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 May 2022 06:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243752AbiEVKWS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 May 2022 06:22:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3AAFB36B7B
        for <kvm@vger.kernel.org>; Sun, 22 May 2022 03:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653214934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b/PRTGgzJSajLmASm1ImWykhYRAoLKce07yOgwd/E/o=;
        b=bxD9S+8Ur6WXZDt6qo+yC/YTL7TnYDBoxjvy79aXi9BYsA1PsXp9Li9ylCb23WEJKW57pe
        F7wCMkA0U8Sl681VDlC4joHIitUKpOoOZDX+Dh4U2pWq5c/TJV+P1jtTN1NZG6hIpsSSg6
        v6sHkeMq7y52ryZ9Xm3/yTXFxmp2mUA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-78527TvaMxCx363TuhOEMA-1; Sun, 22 May 2022 06:22:13 -0400
X-MC-Unique: 78527TvaMxCx363TuhOEMA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0ADC71C05AEF;
        Sun, 22 May 2022 10:22:12 +0000 (UTC)
Received: from starship (unknown [10.40.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7845340CFD00;
        Sun, 22 May 2022 10:22:06 +0000 (UTC)
Message-ID: <5ed0d0e5a88bbee2f95d794dbbeb1ad16789f319.camel@redhat.com>
Subject: Re: [RFC PATCH v3 04/19] KVM: x86: mmu: allow to enable write
 tracking externally
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
Date:   Sun, 22 May 2022 13:22:05 +0300
In-Reply-To: <YoZyWOh4NPA0uN5J@google.com>
References: <20220427200314.276673-1-mlevitsk@redhat.com>
         <20220427200314.276673-5-mlevitsk@redhat.com> <YoZyWOh4NPA0uN5J@google.com>
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

On Thu, 2022-05-19 at 16:37 +0000, Sean Christopherson wrote:
> On Wed, Apr 27, 2022, Maxim Levitsky wrote:
> > @@ -5753,6 +5752,10 @@ int kvm_mmu_init_vm(struct kvm *kvm)
> >  	node->track_write = kvm_mmu_pte_write;
> >  	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
> >  	kvm_page_track_register_notifier(kvm, node);
> 
> Can you add a patch to move this call to kvm_page_track_register_notifier() into
> mmu_enable_write_tracking(), and simultaneously add a WARN in the register path
> that page tracking is enabled?
> 
> Oh, actually, a better idea. Add an inner __kvm_page_track_register_notifier()
> that is not exported and thus used only by KVM, invoke mmu_enable_write_tracking()
> from the exported kvm_page_track_register_notifier(), and then do the above.
> That will require modifying KVMGT and KVM in a single patch, but that's ok.
> 
> That will avoid any possibility of an external user failing to enabling tracking
> before registering its notifier, and also avoids bikeshedding over what to do with
> the one-line wrapper to enable tracking.
> 

This is a good idea as well, especially looking at kvmgt and seeing that
it registers the page track notifier, when the vGPU is opened.

I'll do this in the next series.

Thanks for the review!

Best regards,
	Maxim Levitsky

