Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99707647854
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 22:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiLHVzg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 16:55:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiLHVzN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 16:55:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043529D8AC
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 13:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670536453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyNEnQgw7RSuFvb1RlQ4JF/KPojev3u805XMA8QKkBQ=;
        b=ggLw0B4KYnWyzSRgveVwqW0gQYdc2hklE+CVGvRyN59QqtxyLSM4ZDgto9O2ggKZGiY9Zw
        BVNSR3d9/Q/SRmhfpg+/NLa1Z+WMGFn1JEsVLZT3nEn4Q59FQavqDiMkigfOpF3fGM7m6V
        afaA4U4Rn7/TdJhTmGFbzSluNozCUKM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-484-6oHwU8hkPDer70OGzR4Qcg-1; Thu, 08 Dec 2022 16:54:09 -0500
X-MC-Unique: 6oHwU8hkPDer70OGzR4Qcg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 796E1101A528;
        Thu,  8 Dec 2022 21:54:08 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 12980492B04;
        Thu,  8 Dec 2022 21:54:06 +0000 (UTC)
Message-ID: <fa63b6182c37fec5f9836e039651e0c98c1f9f9f.camel@redhat.com>
Subject: Re: [PATCH v4 09/32] KVM: x86: Handle APICv updates for APIC "mode"
 changes via request
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Thu, 08 Dec 2022 23:54:06 +0200
In-Reply-To: <20221001005915.2041642-10-seanjc@google.com>
References: <20221001005915.2041642-1-seanjc@google.com>
         <20221001005915.2041642-10-seanjc@google.com>
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

On Sat, 2022-10-01 at 00:58 +0000, Sean Christopherson wrote:
> Use KVM_REQ_UPDATE_APICV to react to APIC "mode" changes, i.e. to handle
> the APIC being hardware enabled/disabled and/or x2APIC being toggled.
> There is no need to immediately update APICv state, the only requirement
> is that APICv be updating prior to the next VM-Enter.
> 
> Making a request will allow piggybacking KVM_REQ_UPDATE_APICV to "inhibit"
> the APICv memslot when x2APIC is enabled.  Doing that directly from
> kvm_lapic_set_base() isn't feasible as KVM's SRCU must not be held when
> modifying memslots (to avoid deadlock), and may or may not be held when
> kvm_lapic_set_base() is called, i.e. KVM can't do the right thing without
> tracking that is rightly buried behind CONFIG_PROVE_RCU=y.
> 
> Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/lapic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 2503f162eb95..316b61b56cca 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2401,7 +2401,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
>  		kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
>  
>  	if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE)) {
> -		kvm_vcpu_update_apicv(vcpu);
> +		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
>  		static_call_cond(kvm_x86_set_virtual_apic_mode)(vcpu);
>  	}
>  

Makes sense.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

