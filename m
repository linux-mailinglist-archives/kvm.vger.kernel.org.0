Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC2252BBC4
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 16:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237389AbiERMoR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 08:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237431AbiERMni (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 08:43:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E2811A29D1
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 05:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652877419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZnwAbpuf8out8csgmDT/1EJa0Dp/wEa0FwZfSMt3EgU=;
        b=GOBErIXs3/zEA4CSTUtoeosDptFtxiIP/LJ77BE8owQzkfrBtCN/8aGV2sxglx5Q5wjQsj
        UgPoRlieYBs2p+1J0qvpvHolIT5MxW6mdpWHU3KeR8VgfqIxUkViEpVI9t8TPEJRzEaafs
        iShXf+Cz2JUFyvY1iDGB3PKg4nwX58g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-rJch5im4PDmw0Q0Y98zPcg-1; Wed, 18 May 2022 08:36:52 -0400
X-MC-Unique: rJch5im4PDmw0Q0Y98zPcg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC5BF398CA60;
        Wed, 18 May 2022 12:36:51 +0000 (UTC)
Received: from starship (unknown [10.40.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B23940CF8EE;
        Wed, 18 May 2022 12:36:45 +0000 (UTC)
Message-ID: <670fdf36585b1bf7c367cff4ab0653f4c7de8808.camel@redhat.com>
Subject: Re: [RFC PATCH v3 02/19] KVM: x86: inhibit APICv/AVIC when the
 guest and/or host changes apic id/base from the defaults.
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Chao Gao <chao.gao@intel.com>
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
        intel-gfx@lists.freedesktop.org,
        Sean Christopherson <seanjc@google.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Date:   Wed, 18 May 2022 15:36:44 +0300
In-Reply-To: <20220518115056.GA18087@gao-cwp>
References: <20220427200314.276673-1-mlevitsk@redhat.com>
         <20220427200314.276673-3-mlevitsk@redhat.com>
         <20220518082811.GA8765@gao-cwp>
         <8c78939bf01a98554696add10e17b07631d97a28.camel@redhat.com>
         <20220518115056.GA18087@gao-cwp>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-05-18 at 19:51 +0800, Chao Gao wrote:
> On Wed, May 18, 2022 at 12:50:27PM +0300, Maxim Levitsky wrote:
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
> > 
> > I mentioned this boolean in the commit description.
> > 
> > This boolean avoids the need to go over all vCPUs and checking
> > if they still have the initial apic id.
> 
> Do you want to kill the guest if APIC base got changed? If yes,
> you can check if APICV_INHIBIT_REASON_RO_SETTINGS is set and save
> the boolean.

Yep, I thrown in the apic base just because I can. It doesn't matter to 
my nested AVIC logic at all, but since it is also something that guests
don't change, I also don't care if this will lead to inhibit and
killing the guest if it attempts to use nested AVIC.

That boolean should have the same value as the APICV_INHIBIT_REASON_RO_SETTINGS
inhibit, so yes I can instead check if the inhibit is active.

I don't know if that is cleaner that this boolean though, individual
inhibit value is currently not something that anybody uses in logic.

Best regards,
	Maxim Levitsky


> 
> > In the future maybe we can introduce a more generic 'taint'
> > bitmap with various flags like that, indicating that the guest
> > did something unexpected.
> > 
> > BTW, the other option in regard to the nested AVIC is just to ignore this issue completely.
> > The code itself always uses vcpu_id's, thus regardless of when/how often the guest changes
> > its apic ids, my code would just use the initial APIC ID values consistently.
> > 
> > In this case I won't need this boolean.
> > 
> > > > };
> > > > 
> > > > struct kvm_vm_stat {
> > > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > > index 66b0eb0bda94e..8996675b3ef4c 100644
> > > > --- a/arch/x86/kvm/lapic.c
> > > > +++ b/arch/x86/kvm/lapic.c
> > > > @@ -2038,6 +2038,19 @@ static void apic_manage_nmi_watchdog(struct kvm_lapic *apic, u32 lvt0_val)
> > > > 	}
> > > > }
> > > > 
> > > > +static void kvm_lapic_check_initial_apic_id(struct kvm_lapic *apic)
> > > > +{
> > > > +	if (kvm_apic_has_initial_apic_id(apic))
> > > > +		return;
> > > > +
> > > > +	pr_warn_once("APIC ID change is unsupported by KVM");
> > > 
> > > It is misleading because changing xAPIC ID is supported by KVM; it just
> > > isn't compatible with APICv. Probably this pr_warn_once() should be
> > > removed.
> > 
> > Honestly since nobody uses this feature, I am not sure if to call this supported,
> > I am sure that KVM has more bugs in regard of using non standard APIC ID.
> > This warning might hopefuly make someone complain about it if this
> > feature is actually used somewhere.
> 
> Now I got you. It is fine to me.
> 


