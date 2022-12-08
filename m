Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0A864787F
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 23:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiLHWDw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 17:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbiLHWDZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 17:03:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA5E79C19
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 14:01:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670536870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W56nw/gVQin27dLjIPTk42vv2xQm3EpOtvU1wsvTbig=;
        b=TfOV7LIqtlZEyIt61IyASBtsYMqymteUudxdVvihCyW22Jl9WWDbm+vVxslbyKqplPf0rG
        ZxdIhENgNRqj4mSUB1+VqsnfsNJEkziOvGXwImFeTXV40eCxfUgPYMCJCjXq0STKWpIKwT
        EAL81e0DEo07ePBBCF94MseoYSmm1C0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-hDh6gXq-MZGItvwgjMpRbQ-1; Thu, 08 Dec 2022 17:01:07 -0500
X-MC-Unique: hDh6gXq-MZGItvwgjMpRbQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B136686C15F;
        Thu,  8 Dec 2022 22:01:06 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FADA40C6EC2;
        Thu,  8 Dec 2022 22:01:04 +0000 (UTC)
Message-ID: <85ae65b205612d7a65f3ebfb58c7e8205efe7cfa.camel@redhat.com>
Subject: Re: [PATCH v4 31/32] Revert "KVM: SVM: Do not throw warning when
 calling avic_vcpu_load on a running vcpu"
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Fri, 09 Dec 2022 00:01:04 +0200
In-Reply-To: <20221001005915.2041642-32-seanjc@google.com>
References: <20221001005915.2041642-1-seanjc@google.com>
         <20221001005915.2041642-32-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
> Turns out that some warnings exist for good reasons.  Restore the warning
> in avic_vcpu_load() that guards against calling avic_vcpu_load() on a
> running vCPU now that KVM avoids doing so when switching between x2APIC
> and xAPIC.  The entire point of the WARN is to highlight that KVM should
> not be reloading an AVIC.
> 
> Opportunistically convert the WARN_ON() to WARN_ON_ONCE() to avoid
> spamming the kernel if it does fire.
> 
> This reverts commit c0caeee65af3944b7b8abbf566e7cc1fae15c775.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 953b1fd14b6d..35b0ef877e53 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -1038,6 +1038,7 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  		return;
>  
>  	entry = READ_ONCE(*(svm->avic_physical_id_cache));
> +	WARN_ON_ONCE(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
>  
>  	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
>  	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky

