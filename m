Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453BB5BC382
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 09:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiISHcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 03:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiISHcQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 03:32:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0801A056
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 00:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663572734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AqD4TnlhePXL3CSt/e7eMOfrupnuHzb02HehU7b1Ap4=;
        b=GrKf+aQ4QFUKQJlQKEuB+bML3m41LEMimnIIC0ZiyMeE784nqGDN09xq6ULYuWLKab8hba
        F/wESH4ROGlrB9kQ0TDaf2KhgoSsH8gVLZHj/5rppKbUMC3OhjXFiyDdMTV015PS6x56Hv
        0zi4DvCbuExAibA3e2pXvMMMUEkEUJM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-W6HF5MMiMjSn977jQnfsiw-1; Mon, 19 Sep 2022 03:32:09 -0400
X-MC-Unique: W6HF5MMiMjSn977jQnfsiw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B3FA101A52A;
        Mon, 19 Sep 2022 07:32:09 +0000 (UTC)
Received: from starship (unknown [10.40.192.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B8EA1121314;
        Mon, 19 Sep 2022 07:32:07 +0000 (UTC)
Message-ID: <93df5f91adc31138640e3e7c5ab037b73b8af5ff.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: Un-inhibit APICv/AVIC when switching to
 x2APIC mode
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, jon.grimm@amd.com
Date:   Mon, 19 Sep 2022 10:32:06 +0300
In-Reply-To: <YyUOb5X8yO4BbYSf@google.com>
References: <20220909195442.7660-1-suravee.suthikulpanit@amd.com>
         <YyUOb5X8yO4BbYSf@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-09-17 at 00:01 +0000, Sean Christopherson wrote:
> On Fri, Sep 09, 2022, Suravee Suthikulpanit wrote:
> > Currently, kvm_lapic_xapic_id_updated() checks if the xAPIC ID in
> > the APIC_ID register differs from the vcpu ID. If so it inhibits
> > APICv/AVIC.
> > 
> > However, for vcpu 256 and above, the 8-bit xAPIC ID field in the APIC_ID
> > register cannot support 32-bit x2APIC ID causing the kvm_xapic_id()
> > to return invalid ID and fail the comparison with the vcpu ID.
> > This causes APICv/AVIC inhibition for VM with more than 256 vcpus
> > due to APIVC_INHIBIT_REASON_APIC_ID_MODIFIED.
> > 
> > In this case, when guest switch to x2APIC mode, KVM needs to clear
> > APIVC_INHIBIT_REASON_APIC_ID_MODIFIED.
> > 
> > Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
> > Cc: Maxim Levitsky <mlevitsk@redhat.com>
> > Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> > ---
> >  arch/x86/kvm/lapic.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 9dda989a1cf0..750d385b770e 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -374,6 +374,7 @@ static inline void kvm_apic_set_x2apic_id(struct kvm_lapic *apic, u32 id)
> >  	kvm_lapic_set_reg(apic, APIC_ID, id);
> >  	kvm_lapic_set_reg(apic, APIC_LDR, ldr);
> >  	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
> > +	kvm_clear_apicv_inhibit(apic->vcpu->kvm, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);
> 
> This isn't safe as it assumes the guest will switch _all_ vCPUs to x2APIC, e.g.
> if one vCPU switches to x2APIC before the others then weird things will happen.
> Part of me just wants to throw in the towel, but I think we have an easy out.
> 
> The other funky thing to consider is KVM's x2APIC hotplug hack, where KVM
> deliberately (and architecturally incorrectly) does not honor the aliasing behavior
> that results when an x2APIC ID gets truncated to an xAPIC ID.  When the hack is
> effectively enabled, KVM can actually ignore truncation because the resulting KVM
> behavior of IPIs only getting sent to the "first" vCPU is the same as APICv/AVIC
> behavior.  On the plus side, the existence of that godawful hack means it's extremely
> unlikely the aliasing will break anything that anyones cares about.
> 
> To restore APICv support for stable kernels on systems with >255 CPUs, which people
> do care about, it probably makes sense to split the fix into two patches.  An
> incomplete patch to ignore the truncation case that is easy to backport, and then
> a fix for the fix to inhibit APICv/AVIC when there is unwanted aliasing (piggybacking
> off my patch "KVM: x86: Honor architectural behavior for aliased 8-bit APIC IDs").
> We can even get clever and fixup the Fixes: tag when doing the final application
> so that there's a paper trail if someone wants to backport the full fix.
> 
> Compile tested only at this point and lacks changelogs, but my thought is to do:
> 
> From: Sean Christopherson <seanjc@google.com>
> Date: Fri, 16 Sep 2022 16:48:03 -0700
> Subject: [PATCH] KVM: x86: Don't inhibit APICv/AVIC if xAPIC ID mismatch is
>  due to 32-bit ID
> 
> Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
> Reported-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/lapic.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index adac6ca9b7dc..a02defa3f7b5 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2075,7 +2075,12 @@ static void kvm_lapic_xapic_id_updated(struct kvm_lapic *apic)
>  	if (KVM_BUG_ON(apic_x2apic_mode(apic), kvm))
>  		return;
>  
> -	if (kvm_xapic_id(apic) == apic->vcpu->vcpu_id)
> +	/*
> +	 * Deliberately truncate the vCPU ID when detecting a modified APIC ID
> +	 * to avoid false positives if the vCPU ID, i.e. x2APIC ID, is a 32-bit
> +	 * value.
> +	 */
> +	if (kvm_xapic_id(apic) == (u8)apic->vcpu->vcpu_id)
>  		return;

This is the fix I had in mind for this issue, I kept it on the backlog for too much time.
I also vote to do it this way.

Best regards,
	Maxim Levitsky


>  
>  	kvm_set_apicv_inhibit(apic->vcpu->kvm, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);
> 
> base-commit: 59afc619c353e67d087dc741bd828019985ffac6
> -- 
> 
> followed up by this later in the series:
> 
> From: Sean Christopherson <seanjc@google.com>
> Date: Fri, 16 Sep 2022 16:54:14 -0700
> Subject: [PATCH] KVM: x86: Inhibit APICv/AVIC if the optimized physical map is
>  disabled
> 
> Fixes: TDB
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  6 ++++++
>  arch/x86/kvm/lapic.c            | 13 ++++++++++++-
>  arch/x86/kvm/svm/avic.c         |  1 +
>  arch/x86/kvm/vmx/vmx.c          |  1 +
>  4 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 13dadc96d9ac..6953d1a61357 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1097,6 +1097,12 @@ enum kvm_apicv_inhibit {
>  	 */
>  	APICV_INHIBIT_REASON_BLOCKIRQ,
>  
> +	/*
> +	 * APICv is disabled because not all vCPUs have a 1:1 mapping between
> +	 * APIC ID and vCPU, _and_ KVM is not applying its x2APIC hotplug hack.
> +	 */
> +	APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED,
> +
>  	/*
>  	 * For simplicity, the APIC acceleration is inhibited
>  	 * first time either APIC ID or APIC base are changed by the guest
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 00c89ff740e5..e9ba17aa0710 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -381,6 +381,16 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
>  		cluster[ldr] = apic;
>  	}
>  out:
> +	/*
> +	 * The optimized map is effectively KVM's internal version of APICv,
> +	 * and all unwanted aliasing that results in disabling the optimized
> +	 * map also applies to APICv.
> +	 */
> +	if (!new)
> +		kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED);
> +	else
> +		kvm_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED);
> +
>  	old = rcu_dereference_protected(kvm->arch.apic_map,
>  			lockdep_is_held(&kvm->arch.apic_map_lock));
>  	rcu_assign_pointer(kvm->arch.apic_map, new);
> @@ -2150,7 +2160,8 @@ static void kvm_lapic_xapic_id_updated(struct kvm_lapic *apic)
>  	/*
>  	 * Deliberately truncate the vCPU ID when detecting a modified APIC ID
>  	 * to avoid false positives if the vCPU ID, i.e. x2APIC ID, is a 32-bit
> -	 * value.
> +	 * value.  If the wrap/truncation results in unwatned aliasing, APICv
> +	 * will be inhibited as part of updating KVM's optimized APIC maps.
>  	 */
>  	if (kvm_xapic_id(apic) == (u8)apic->vcpu->vcpu_id)
>  		return;
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 3400046ad0b4..a1eb4e9ed3eb 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -992,6 +992,7 @@ bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
>  			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
>  			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
>  			  BIT(APICV_INHIBIT_REASON_SEV)      |
> +			  BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |
>  			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
>  			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |
>  			  BIT(APICV_INHIBIT_REASON_X2APIC);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c9b49a09e6b5..414485d03ee7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7996,6 +7996,7 @@ static bool vmx_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
>  			  BIT(APICV_INHIBIT_REASON_ABSENT) |
>  			  BIT(APICV_INHIBIT_REASON_HYPERV) |
>  			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
> +			  BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |
>  			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
>  			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED);
>  
> 
> base-commit: c8ecd2ebbc283d377188ee6c94cf3f811a4ff501


