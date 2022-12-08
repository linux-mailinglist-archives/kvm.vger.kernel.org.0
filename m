Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2540364786F
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 23:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiLHWAH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 17:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiLHV7e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 16:59:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977B483E95
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 13:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670536718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xbYtnGNhuMVVOzpuKFqup2aodqr2TMw0io3V2SWqw68=;
        b=JihBDxvQj9oFRVDNgnfN3a0xS08E3O+ou89WYv8pvGfN0uPtL6k0hsyD4lZ3SRA7xpz5EQ
        F69Ejc+omyb0tT0uWe13N7ATwfwAZXOBLuqoVPMFiRr7i6advQXjLHo7EsmE3cqIQnZFqL
        PVZUSXMNHjITZNArH2e23QulgXcjp7s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-142-rx8wQE4XPuKMxTioo7qcxg-1; Thu, 08 Dec 2022 16:58:37 -0500
X-MC-Unique: rx8wQE4XPuKMxTioo7qcxg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6291101A528;
        Thu,  8 Dec 2022 21:58:36 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 624EF17582;
        Thu,  8 Dec 2022 21:58:35 +0000 (UTC)
Message-ID: <b8862d5e5fb3b9d903ac9dcf9cc636524c7d20f4.camel@redhat.com>
Subject: Re: [PATCH v4 25/32] KVM: SVM: Inhibit AVIC if vCPUs are aliased in
 logical mode
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Thu, 08 Dec 2022 23:58:34 +0200
In-Reply-To: <20221001005915.2041642-26-seanjc@google.com>
References: <20221001005915.2041642-1-seanjc@google.com>
         <20221001005915.2041642-26-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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
> Inhibit SVM's AVIC if multiple vCPUs are aliased to the same logical ID.
> Architecturally, all CPUs whose logical ID matches the MDA are supposed
> to receive the interrupt; overwriting existing entries in AVIC's
> logical=>physical map can result in missed IPIs.
> 
> Fixes: 18f40c53e10f ("svm: Add VMEXIT handlers for AVIC")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 6 ++++++
>  arch/x86/kvm/lapic.c            | 5 +++++
>  arch/x86/kvm/svm/avic.c         | 3 ++-
>  3 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 171e38b94c89..4fd06965c773 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1159,6 +1159,12 @@ enum kvm_apicv_inhibit {
>  	 * APIC base.  For simplicity, this is sticky.
>  	 */
>  	APICV_INHIBIT_REASON_X2APIC,
> +
> +	/*
> +	 * AVIC is disabled because not all vCPUs with a valid LDR have a 1:1
> +	 * mapping between logical ID and vCPU.
> +	 */
> +	APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED,
>  };
>  
>  struct kvm_arch {
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index f6f328d36ae2..9b3af49d2524 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -391,6 +391,11 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
>  	else
>  		kvm_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED);
>  
> +	if (!new || new->logical_mode == KVM_APIC_MODE_MAP_DISABLED)
> +		kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED);
> +	else
> +		kvm_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED);
> +
>  	old = rcu_dereference_protected(kvm->arch.apic_map,
>  			lockdep_is_held(&kvm->arch.apic_map_lock));
>  	rcu_assign_pointer(kvm->arch.apic_map, new);
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 2908adc79ea6..27d5abc15a91 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -968,7 +968,8 @@ bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
>  			  BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |
>  			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
>  			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |
> -			  BIT(APICV_INHIBIT_REASON_X2APIC);
> +			  BIT(APICV_INHIBIT_REASON_X2APIC) |
> +			  BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED);
>  
>  	return supported & BIT(reason);
>  }

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

