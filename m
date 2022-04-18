Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0FC5054E2
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 15:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239629AbiDRNMc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 09:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243986AbiDRNKk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 09:10:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5628B39684
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 05:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650286218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rb4fPpjVJBt57bzKiDeFjoDPvn2xKg179ojAIvSnHfY=;
        b=WhdOVRRam0Tv9rWmHp2jvDZPQBfFBJhUV4ymeCy0hI0133h6yu+irMpnGpfgV3VO0rnr7F
        symi2oj1jcnU/uKUHf9dhXr7p/YhRFbgdUSJatiC6t6fifYn3MD9RnJ/ApwErzwf6lQRCt
        uRu7PbmqKY6RsE25fU5vynlchpdIVYQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-Gt6VQVJfNvyuupZvkCYwfg-1; Mon, 18 Apr 2022 08:50:17 -0400
X-MC-Unique: Gt6VQVJfNvyuupZvkCYwfg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85FC638149B4;
        Mon, 18 Apr 2022 12:50:16 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD5E82026D07;
        Mon, 18 Apr 2022 12:50:01 +0000 (UTC)
Message-ID: <e04e7ad7630d64a2d159ea80b0751f6d09f95514.camel@redhat.com>
Subject: Re: [PATCH 4/4] KVM: x86: Skip KVM_GUESTDBG_BLOCKIRQ APICv update
 if APICv is disabled
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gaoning Pan <pgn@zju.edu.cn>,
        Yongkang Jia <kangel@zju.edu.cn>
Date:   Mon, 18 Apr 2022 15:50:00 +0300
In-Reply-To: <20220416034249.2609491-5-seanjc@google.com>
References: <20220416034249.2609491-1-seanjc@google.com>
         <20220416034249.2609491-5-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-04-16 at 03:42 +0000, Sean Christopherson wrote:
> Skip the APICv inhibit update for KVM_GUESTDBG_BLOCKIRQ if APICv is
> disabled at the module level to avoid having to acquire the mutex and
> potentially process all vCPUs. The DISABLE inhibit will (barring bugs)
> never be lifted, so piling on more inhibits is unnecessary.
> 
> Fixes: cae72dcc3b21 ("KVM: x86: inhibit APICv when KVM_GUESTDBG_BLOCKIRQ active")
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 09a270cc1c8f..16c5fa7d165d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11048,6 +11048,9 @@ static void kvm_arch_vcpu_guestdbg_update_apicv_inhibit(struct kvm *kvm)
>  	struct kvm_vcpu *vcpu;
>  	unsigned long i;
>  
> +	if (!enable_apicv)
> +		return;
> +
>  	down_write(&kvm->arch.apicv_update_lock);
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm) {

Makes sense as a precation.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky

