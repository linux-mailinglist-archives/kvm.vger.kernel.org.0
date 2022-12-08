Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A35647873
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 23:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiLHWAb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 17:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbiLHV7w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 16:59:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EEBF248E1
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 13:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670536730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZK2zc1GUTDAUYDhStvJ9Mc1rEg5HpwpV8Aw2yRZizkE=;
        b=S2qEtleLGq41Z7vZncVlX1Hh3yn4RyfjeTiiTe/g+8xrjmzuNgF3Oh43x2ht/646jXcKHU
        gnNg/hCmYBR4TaeNSs72Etwch/3t4/F0UCfwBu5ovizseVB8Qazlv954lahqK21gybHH6D
        Hf4ksMASVCEwL0MRsgEyfiO0oe86ibg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-wXLUoMrzNICRGGAhhcU7xQ-1; Thu, 08 Dec 2022 16:58:46 -0500
X-MC-Unique: wXLUoMrzNICRGGAhhcU7xQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6AEB23C0F220;
        Thu,  8 Dec 2022 21:58:45 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 07B50492B04;
        Thu,  8 Dec 2022 21:58:43 +0000 (UTC)
Message-ID: <0f403e5a9d9758dac90e6a1e3cda1a95e693cad8.camel@redhat.com>
Subject: Re: [PATCH v4 26/32] KVM: SVM: Always update local APIC on writes
 to logical dest register
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Thu, 08 Dec 2022 23:58:43 +0200
In-Reply-To: <20221001005915.2041642-27-seanjc@google.com>
References: <20221001005915.2041642-1-seanjc@google.com>
         <20221001005915.2041642-27-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
> Update the vCPU's local (virtual) APIC on LDR writes even if the write
> "fails".  The APIC needs to recalc the optimized logical map even if the
> LDR is invalid or zero, e.g. if the guest clears its LDR, the optimized
> map will be left as is and the vCPU will receive interrupts using its
> old LDR.
> 
> Fixes: 18f40c53e10f ("svm: Add VMEXIT handlers for AVIC")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 27d5abc15a91..2b640c73f447 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -573,7 +573,7 @@ static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
>  		clear_bit(AVIC_LOGICAL_ID_ENTRY_VALID_BIT, (unsigned long *)entry);
>  }
>  
> -static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
> +static void avic_handle_ldr_update(struct kvm_vcpu *vcpu)
>  {
>  	int ret = 0;
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -582,10 +582,10 @@ static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
>  
>  	/* AVIC does not support LDR update for x2APIC */
>  	if (apic_x2apic_mode(vcpu->arch.apic))
> -		return 0;
> +		return;
>  
>  	if (ldr == svm->ldr_reg)
> -		return 0;
> +		return;
>  
>  	avic_invalidate_logical_id_entry(vcpu);
>  
> @@ -594,8 +594,6 @@ static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
>  
>  	if (!ret)
>  		svm->ldr_reg = ldr;
> -
> -	return ret;
>  }
>  
>  static void avic_handle_dfr_update(struct kvm_vcpu *vcpu)
> @@ -617,8 +615,7 @@ static int avic_unaccel_trap_write(struct kvm_vcpu *vcpu)
>  
>  	switch (offset) {
>  	case APIC_LDR:
> -		if (avic_handle_ldr_update(vcpu))
> -			return 0;
> +		avic_handle_ldr_update(vcpu);
>  		break;
>  	case APIC_DFR:
>  		avic_handle_dfr_update(vcpu);


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

