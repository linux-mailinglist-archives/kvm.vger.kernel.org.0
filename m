Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527054E6638
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 16:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351340AbiCXPnl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 11:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242256AbiCXPnk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 11:43:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 84DC4BE2C
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 08:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648136527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IMj4s22XC9mKB2LB6VUx9T2+5iAB0BQpdb6M6ZtJ8Ig=;
        b=iS41kU+OmJdvlay7wKHOn5R2X9zPcq7b4mEX5D4wJkapnM4SuRB3R5sBSqYXqW87mt1UeF
        V4ALBcEfuZtfuTi49uCIl0b/BqW/fErjXMwIECuPbn++omgsYr8cDm144vVc0gBqJZpGIB
        G/x1pqaMkb047Msims85HIpYW1AYFKc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-lTdNTWANPHmO0ftlTvow3w-1; Thu, 24 Mar 2022 11:42:04 -0400
X-MC-Unique: lTdNTWANPHmO0ftlTvow3w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF52E1066543;
        Thu, 24 Mar 2022 15:42:03 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B1C8758BABB;
        Thu, 24 Mar 2022 15:42:01 +0000 (UTC)
Message-ID: <9875fd216464cabcc14cbaa2df374b2b3dc937bb.camel@redhat.com>
Subject: Re: [RFCv2 PATCH 11/12] KVM: SVM: Do not throw warning when calling
 avic_vcpu_load on a running vcpu
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Thu, 24 Mar 2022 17:42:00 +0200
In-Reply-To: <20220308163926.563994-12-suravee.suthikulpanit@amd.com>
References: <20220308163926.563994-1-suravee.suthikulpanit@amd.com>
         <20220308163926.563994-12-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-03-08 at 10:39 -0600, Suravee Suthikulpanit wrote:
> Originalliy, this WARN_ON is designed to detect when calling
> avic_vcpu_load() on an already running vcpu in AVIC mode (i.e. the AVIC
> is_running bit is set).
> 
> However, for x2AVIC, the vCPU can switch from xAPIC to x2APIC mode while in
> running state, in which the avic_vcpu_load() will be called from
> svm_refresh_apicv_exec_ctrl().
> 
> Therefore, remove this warning since it is no longer appropriate.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/avic.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index b8d6bf6b6ed5..015888aad8fc 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -1038,7 +1038,6 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  		return;
>  
>  	entry = READ_ONCE(*(svm->avic_physical_id_cache));
> -	WARN_ON(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
>  
>  	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
>  	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

