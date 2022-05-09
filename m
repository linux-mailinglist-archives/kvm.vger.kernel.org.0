Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5686951F9B6
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 12:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbiEIKYC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 06:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234187AbiEIKWn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 06:22:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8C2F312602
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 03:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652091526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/QPwJnuZ70Zhpy7RtoX+N5eDUlR9SN6vN0Pbo4IGuzI=;
        b=WRLsk1ozw+9u1TcxXutFIa4o4hINz45NL64mlnRU+/jjYV5PvERklYmUonmXWmDgAAzic2
        OoJocn0V3NUGitjmC0xLhPNnOkyB/hUskxugFomcJUOO9ntjKQePvA5TVgEjBZ+pgY1Y2R
        vp/xmWC1ZkBMICEnbsVzRNO6R2JdCkU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-sDfIAtb-PKi1nfbOIyKVzg-1; Mon, 09 May 2022 06:18:45 -0400
X-MC-Unique: sDfIAtb-PKi1nfbOIyKVzg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6DDFC857D00;
        Mon,  9 May 2022 10:18:44 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5939742D4C8;
        Mon,  9 May 2022 10:18:42 +0000 (UTC)
Message-ID: <b553737e9f7b587cd1ce598e276c1c9117fa2a98.camel@redhat.com>
Subject: Re: [PATCH v4 08/15] KVM: x86: Deactivate APICv on vCPU with APIC
 disabled
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Mon, 09 May 2022 13:18:41 +0300
In-Reply-To: <20220508023930.12881-9-suravee.suthikulpanit@amd.com>
References: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
         <20220508023930.12881-9-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-05-07 at 21:39 -0500, Suravee Suthikulpanit wrote:
> APICv should be deactivated on vCPU that has APIC disabled.
> Therefore, call kvm_vcpu_update_apicv() when changing
> APIC mode, and add additional check for APIC disable mode
> when determine APICV activation,
> 
> Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/lapic.c | 4 +++-
>  arch/x86/kvm/x86.c   | 4 +++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 8b8c4a905976..680824d7aa0d 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2346,8 +2346,10 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
>  	if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE))
>  		kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
>  
> -	if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE))
> +	if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE)) {
> +		kvm_vcpu_update_apicv(vcpu);
>  		static_call_cond(kvm_x86_set_virtual_apic_mode)(vcpu);

As futher optimization, we might even get rid of .set_virtual_apic_mode
and do all of this in kvm_vcpu_update_apicv.
But no need to this now.


> +	}
>  
>  	apic->base_address = apic->vcpu->arch.apic_base &
>  			     MSR_IA32_APICBASE_BASE;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8ee8c91fa762..77e49892dea1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9836,7 +9836,9 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
>  
>  	down_read(&vcpu->kvm->arch.apicv_update_lock);
>  
> -	activate = kvm_vcpu_apicv_activated(vcpu);
> +	/* Do not activate APICV when APIC is disabled */
> +	activate = kvm_vcpu_apicv_activated(vcpu) &&
> +		   (kvm_get_apic_mode(vcpu) != LAPIC_MODE_DISABLED);
>  
>  	if (vcpu->arch.apicv_active == activate)
>  		goto out;

Looks good!

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

