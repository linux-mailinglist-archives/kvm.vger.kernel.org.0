Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D58523186
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 13:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238387AbiEKLZb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 07:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237737AbiEKLYV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 07:24:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B1C5A238879
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 04:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652268232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WYzPUdllJHiO6z7MbzaY1Iv/t1q26wP/KgKTQCHuXX8=;
        b=Vy7L/phKNYO51U3x8N8iqTU4tu+7peG8lJR3W38TGGVYle8RE0IRUT+iS3xmAqDFEddLDG
        BKhOyNtVxxXU/FzT6l1TGSKW2J+BPLogtzcShGKEZ7I906Dv4sYHEoWpWugsENo6k/Dxbw
        70rmEtzgB+EdgSHbV+VJvbU1ambIfyE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-454-29AgfxXiMIWQv51BI7mNUg-1; Wed, 11 May 2022 07:23:48 -0400
X-MC-Unique: 29AgfxXiMIWQv51BI7mNUg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 589042999B3B;
        Wed, 11 May 2022 11:23:48 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1461B1121314;
        Wed, 11 May 2022 11:23:45 +0000 (UTC)
Message-ID: <0bb5edd5969ff792c6d99c12d1e1976180180a19.camel@redhat.com>
Subject: Re: [PATCH v3 06/34] KVM: x86: Prepare kvm_hv_flush_tlb() to handle
 L2's GPAs
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 14:23:44 +0300
In-Reply-To: <20220414132013.1588929-7-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-7-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 15:19 +0200, Vitaly Kuznetsov wrote:
> To handle L2 TLB flush requests, KVM needs to translate the specified
> L2 GPA to L1 GPA to read hypercall arguments from there.
> 
> No fucntional change as KVM doesn't handle VMCALL/VMMCALL from L2 yet.
   ^ typo
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 1a6f9628cee9..fc4bb0ead9fa 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -23,6 +23,7 @@
>  #include "ioapic.h"
>  #include "cpuid.h"
>  #include "hyperv.h"
> +#include "mmu.h"
>  #include "xen.h"
>  
>  #include <linux/cpu.h>
> @@ -1975,6 +1976,12 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  	 */
>  	BUILD_BUG_ON(KVM_HV_MAX_SPARSE_VCPU_SET_BITS > 64);
>  
> +	if (!hc->fast && is_guest_mode(vcpu)) {
> +		hc->ingpa = translate_nested_gpa(vcpu, hc->ingpa, 0, NULL);
> +		if (unlikely(hc->ingpa == UNMAPPED_GVA))
> +			return HV_STATUS_INVALID_HYPERCALL_INPUT;
> +	}
> +
>  	if (hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST ||
>  	    hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE) {
>  		if (hc->fast) {


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

