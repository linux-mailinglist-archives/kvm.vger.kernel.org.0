Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343FE52C121
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240743AbiERRPX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 13:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240730AbiERRPW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 13:15:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7FC3F20D4CB
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652894120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FxD9P4XnF1NnW2znaHobWArEduFPf/Vy60CUDQ3Fi/M=;
        b=LZMt6UQk57+fcWwWv11g+M+YHVqPX2hqC5aA5kI4C9y63yu0fMAEPap2F7/KgyS262mErJ
        sart+SZkXp995FLdRoaKmdId4vhtQWX6ZAXFIXnNq9Yaxj2BbTycFHtMxLAYVS9W9VUvdL
        cTgDK2vwU+y5UX6mB6JKmInKXMsM2Uc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-399-UGKIbxl-PHS4oIRfLhl59Q-1; Wed, 18 May 2022 13:15:14 -0400
X-MC-Unique: UGKIbxl-PHS4oIRfLhl59Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 639851801388;
        Wed, 18 May 2022 17:15:13 +0000 (UTC)
Received: from starship (unknown [10.40.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CDFC1C202D1;
        Wed, 18 May 2022 17:15:07 +0000 (UTC)
Message-ID: <d009abe5488440e8e7e990a027868f3d29577b44.camel@redhat.com>
Subject: Re: [RFC PATCH v3 02/19] KVM: x86: inhibit APICv/AVIC when the
 guest and/or host changes apic id/base from the defaults.
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
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
Date:   Wed, 18 May 2022 20:15:06 +0300
In-Reply-To: <YoUTMsnFS+bSED+5@google.com>
References: <20220427200314.276673-1-mlevitsk@redhat.com>
         <20220427200314.276673-3-mlevitsk@redhat.com>
         <20220518082811.GA8765@gao-cwp>
         <8c78939bf01a98554696add10e17b07631d97a28.camel@redhat.com>
         <YoUTMsnFS+bSED+5@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-05-18 at 15:39 +0000, Sean Christopherson wrote:
> On Wed, May 18, 2022, Maxim Levitsky wrote:
> > On Wed, 2022-05-18 at 16:28 +0800, Chao Gao wrote:
> > > > struct kvm_arch {
> > > > @@ -1258,6 +1260,7 @@ struct kvm_arch {
> > > > 	hpa_t	hv_root_tdp;
> > > > 	spinlock_t hv_root_tdp_lock;
> > > > #endif
> > > > +	bool apic_id_changed;
> > > 
> > > What's the value of this boolean? No one reads it.
> > 
> > I use it in later patches to kill the guest during nested VM entry 
> > if it attempts to use nested AVIC after any vCPU changed APIC ID.
> 
> Then the flag should be introduced in the later patch, because (a) it's dead code
> if that patch is never merged and (b) it's impossible to review this patch for
> correctness without seeing the usage, e.g. setting apic_id_changed isn't guarded
> with a lock and so the usage may or may not be susceptible to races.

I can't disagree with you on this, this was just somewhat a hack I wasn't sure
(and not yet 100% sure I will move forward with) so I cut this corner.

Thanks for the review!

Best regards,
	Maxim Levitsky

> 
> > > > +	apic->vcpu->kvm->arch.apic_id_changed = true;
> > > > +}
> > > > +


