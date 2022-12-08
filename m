Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71258647876
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 23:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbiLHWBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 17:01:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiLHWBP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 17:01:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851989D89B
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 13:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670536791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d6m1N9dPVMIOl1njfySpbH3EXPSWD40/sanu2UwYJuo=;
        b=L8aUBwX3FjM3HEDLRm5blqz2VDamf5wjfQGoUIwJIPLLQ4RHn6NveiIBU2kd4+qfwrV0x7
        eJqKNxUFU4Th/H2TyS1rCEZrIMBztTwq7oYHngCzYFR6RWuAvo75BHKp+mxqoeL1LegaP4
        fo3r6gydVfq6piXyqoSvjQdR4B1cbB4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646--8hOO34SMZeeufhZ-mg6fw-1; Thu, 08 Dec 2022 16:59:46 -0500
X-MC-Unique: -8hOO34SMZeeufhZ-mg6fw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E2E248027FE;
        Thu,  8 Dec 2022 21:59:45 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5BD2917582;
        Thu,  8 Dec 2022 21:59:44 +0000 (UTC)
Message-ID: <474e619c7caf5322abfe27cb65bbae3f67ecfccf.camel@redhat.com>
Subject: Re: [PATCH v4 27/32] KVM: SVM: Update svm->ldr_reg cache even if
 LDR is "bad"
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Thu, 08 Dec 2022 23:59:43 +0200
In-Reply-To: <20221001005915.2041642-28-seanjc@google.com>
References: <20221001005915.2041642-1-seanjc@google.com>
         <20221001005915.2041642-28-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-10-01 at 00:59 +0000, Sean Christopherson wrote:
> Update SVM's cache of the LDR even if the new value is "bad".  Leaving
> stale information in the cache can result in KVM missing updates and/or
> invalidating the wrong entry, e.g. if avic_invalidate_logical_id_entry()
> is triggered after a different vCPU has "claimed" the old LDR.
> 
> Fixes: 18f40c53e10f ("svm: Add VMEXIT handlers for AVIC")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 2b640c73f447..4b6fc9d64f4d 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -539,23 +539,24 @@ static u32 *avic_get_logical_id_entry(struct kvm_vcpu *vcpu, u32 ldr, bool flat)
>  	return &logical_apic_id_table[index];
>  }
>  
> -static int avic_ldr_write(struct kvm_vcpu *vcpu, u8 g_physical_id, u32 ldr)
> +static void avic_ldr_write(struct kvm_vcpu *vcpu, u8 g_physical_id, u32 ldr)
>  {
>  	bool flat;
>  	u32 *entry, new_entry;
>  
> +	if (!ldr)
> +		return;
> +
The avic_get_logical_id_entry already returns NULL in this case, so I don't think
that this is needed.

>  	flat = kvm_lapic_get_reg(vcpu->arch.apic, APIC_DFR) == APIC_DFR_FLAT;
>  	entry = avic_get_logical_id_entry(vcpu, ldr, flat);
>  	if (!entry)
> -		return -EINVAL;
> +		return;
>  
>  	new_entry = READ_ONCE(*entry);
>  	new_entry &= ~AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK;
>  	new_entry |= (g_physical_id & AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK);
>  	new_entry |= AVIC_LOGICAL_ID_ENTRY_VALID_MASK;
>  	WRITE_ONCE(*entry, new_entry);
> -
> -	return 0;
>  }
>  
>  static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
> @@ -575,7 +576,6 @@ static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
>  
>  static void avic_handle_ldr_update(struct kvm_vcpu *vcpu)
>  {
> -	int ret = 0;
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	u32 ldr = kvm_lapic_get_reg(vcpu->arch.apic, APIC_LDR);
>  	u32 id = kvm_xapic_id(vcpu->arch.apic);
> @@ -589,11 +589,8 @@ static void avic_handle_ldr_update(struct kvm_vcpu *vcpu)
>  
>  	avic_invalidate_logical_id_entry(vcpu);
>  
> -	if (ldr)
> -		ret = avic_ldr_write(vcpu, id, ldr);
> -
> -	if (!ret)
> -		svm->ldr_reg = ldr;
> +	svm->ldr_reg = ldr;
> +	avic_ldr_write(vcpu, id, ldr);
>  }
>  
>  static void avic_handle_dfr_update(struct kvm_vcpu *vcpu)


With the nitpick fixed:

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky <mlevitsk@redhat.com>



