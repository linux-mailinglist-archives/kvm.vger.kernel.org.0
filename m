Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 137A164784A
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 22:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiLHVyr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 16:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiLHVyg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 16:54:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9EF85D35
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 13:53:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670536420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ClogqEAHVhvU0Z+VDfOovmr4TOAyX8ejUw7oYGiECZg=;
        b=ivUUu8VcHnGwPZSRDsa8kvUErGzoRfk9h5bJrajn1PwYNTYjMKgSS93gox0G8322iS7nem
        sFyg596rlfOSyR5gdu9qaeyB1NEPsQkfFoh2nnVzSyAskud/XMCWxDNuHDHQ7fieC97UIc
        w312qbLeU+hwOVPDb9h11CleRjKYcoc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-SgQoKJ-9NyGKVRrCcNwxEw-1; Thu, 08 Dec 2022 16:53:38 -0500
X-MC-Unique: SgQoKJ-9NyGKVRrCcNwxEw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A4E086C042;
        Thu,  8 Dec 2022 21:53:38 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9953840C6EC3;
        Thu,  8 Dec 2022 21:53:36 +0000 (UTC)
Message-ID: <17812867e411fbe47b23a942784a9f6cbf251845.camel@redhat.com>
Subject: Re: [PATCH v4 07/32] KVM: x86: Don't inhibit APICv/AVIC if xAPIC ID
 mismatch is due to 32-bit ID
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Thu, 08 Dec 2022 23:53:35 +0200
In-Reply-To: <20221001005915.2041642-8-seanjc@google.com>
References: <20221001005915.2041642-1-seanjc@google.com>
         <20221001005915.2041642-8-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-10-01 at 00:58 +0000, Sean Christopherson wrote:
> Truncate the vcpu_id, a.k.a. x2APIC ID, to an 8-bit value when comparing
> it against the xAPIC ID to avoid false positives (sort of) on systems
> with >255 CPUs, i.e. with IDs that don't fit into a u8.  The intent of
> APIC_ID_MODIFIED is to inhibit APICv/AVIC when the xAPIC is changed from
> it's original value,
> 
> The mismatch isn't technically a false positive, as architecturally the
> xAPIC IDs do end up being aliased in this scenario, and neither APICv
> nor AVIC correctly handles IPI virtualization when there is aliasing.
> However, KVM already deliberately does not honor the aliasing behavior
> that results when an x2APIC ID gets truncated to an xAPIC ID.  I.e. the
> resulting APICv/AVIC behavior is aligned with KVM's existing behavior
> when KVM's x2APIC hotplug hack is effectively enabled.
> 
> If/when KVM provides a way to disable the hotplug hack, APICv/AVIC can
> piggyback whatever logic disables the optimized APIC map (which is what
> provides the hotplug hack), i.e. so that KVM's optimized map and APIC
> virtualization yield the same behavior.
> 
> For now, fix the immediate problem of APIC virtualization being disabled
> for large VMs, which is a much more pressing issue than ensuring KVM
> honors architectural behavior for APIC ID aliasing.
> 
> Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
> Reported-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/lapic.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 251856ba0750..2503f162eb95 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2078,7 +2078,12 @@ static void kvm_lapic_xapic_id_updated(struct kvm_lapic *apic)
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
>  
>  	kvm_set_apicv_inhibit(apic->vcpu->kvm, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

