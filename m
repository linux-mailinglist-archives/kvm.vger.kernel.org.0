Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C1864786D
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 23:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiLHWAD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 17:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiLHV7d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 16:59:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73045D680
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 13:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670536714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xPAAUA61RkPgIRxAVZLilKlzO5WcCty+RQwwCBzT/E8=;
        b=NrPZj1uD8106PbDAZ0oLegpiQQb8SE8QbTDqTwbZQQuMCmSIBrSKITZ6viHHKZdfsow9dt
        riYNrjWhTOMOUy3ey4gefh8MchNm34xHaigV0ZUBxxKfdgynNL0WjNn68uXEgshox5aqFa
        L4ZZKjs9o5pyKK/ygkmfEdmXjj4jkWg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-tYr3ZWdkNfKTEgS5qa14Lw-1; Thu, 08 Dec 2022 16:58:27 -0500
X-MC-Unique: tYr3ZWdkNfKTEgS5qa14Lw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F06538041C6;
        Thu,  8 Dec 2022 21:58:27 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF013492B04;
        Thu,  8 Dec 2022 21:58:25 +0000 (UTC)
Message-ID: <6de0c4fd228055840648452bd5a3b4955f70d881.camel@redhat.com>
Subject: Re: [PATCH v4 24/32] KVM: x86: Inhibit APICv/AVIC if the optimized
 physical map is disabled
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Thu, 08 Dec 2022 23:58:24 +0200
In-Reply-To: <20221001005915.2041642-25-seanjc@google.com>
References: <20221001005915.2041642-1-seanjc@google.com>
         <20221001005915.2041642-25-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-10-01 at 00:59 +0000, Sean Christopherson wrote:
> Inhibit APICv/AVIC if the optimized physical map is disabled so that KVM
> KVM provides consistent APIC behavior if xAPIC IDs are aliased due to
> vcpu_id being truncated and the x2APIC hotplug hack isn't enabled.  If
> the hotplug hack is disabled, events that are emulated by KVM will follow
> architectural behavior (all matching vCPUs receive events, even if the
> "match" is due to truncation), whereas APICv and AVIC will deliver events
> only to the first matching vCPU, i.e. the vCPU that matches without
> truncation.
> 
> Note, the "extra" inhibit is needed because  KVM deliberately ignores
> mismatches due to truncation when applying the APIC_ID_MODIFIED inhibit
> so that large VMs (>255 vCPUs) can run with APICv/AVIC.
> 
> Fixes: TDB
Do you mean Trade & Development Bank of Mongolia ? ;-)


> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  6 ++++++
>  arch/x86/kvm/lapic.c            | 13 ++++++++++++-
>  arch/x86/kvm/svm/avic.c         |  1 +
>  arch/x86/kvm/vmx/vmx.c          |  1 +
>  4 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index ac28bbfbf0e3..171e38b94c89 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1104,6 +1104,12 @@ enum kvm_apicv_inhibit {
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
> index 340c2d3e781b..f6f328d36ae2 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -381,6 +381,16 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
>  		cluster[ldr] = apic;
>  	}
>  out:
> +	/*
> +	 * The optimized map is effectively KVM's internal version of APICv,
Nitpick: APICv/AVIC?
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
> @@ -2153,7 +2163,8 @@ static void kvm_lapic_xapic_id_updated(struct kvm_lapic *apic)
>  	/*
>  	 * Deliberately truncate the vCPU ID when detecting a modified APIC ID
>  	 * to avoid false positives if the vCPU ID, i.e. x2APIC ID, is a 32-bit
> -	 * value.
> +	 * value.  If the wrap/truncation results in unwatned aliasing, APICv
                                                       ^^ typo
> +	 * will be inhibited as part of updating KVM's optimized APIC maps.
>  	 */
>  	if (kvm_xapic_id(apic) == (u8)apic->vcpu->vcpu_id)
>  		return;
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index dd0e41d454a7..2908adc79ea6 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -965,6 +965,7 @@ bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
>  			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
>  			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
>  			  BIT(APICV_INHIBIT_REASON_SEV)      |
> +			  BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |
>  			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
>  			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |
>  			  BIT(APICV_INHIBIT_REASON_X2APIC);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 974d9a366d5d..5920166d7260 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7955,6 +7955,7 @@ static bool vmx_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
>  			  BIT(APICV_INHIBIT_REASON_ABSENT) |
>  			  BIT(APICV_INHIBIT_REASON_HYPERV) |
>  			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
> +			  BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |
>  			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
>  			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED);
>  


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky



