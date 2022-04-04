Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBA2C4F1257
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 11:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354841AbiDDJxB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 05:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354852AbiDDJw5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 05:52:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F92A3C48A
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 02:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649065860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eNn7OZer9rTtvos0scrbqStJB9ITAkgBId/kZt8wGqU=;
        b=gFPBFWS8FGqGF/nMm1/JV203d9RqkJX7KqXTR3mHPmuXVk3QFxG/zweIiGSf852VIBNZIA
        DHWWrN8nhhwlyKZzIXdTdFxncL9Z4Rs+bjm1fVgp/xwIk/71vpFMlj8Qssmqr/0PRZrlgs
        zo3PDk243DYILf+wTJvbv70tTTSZahY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-138-dALdLs2bMXycxz_RvAqKcg-1; Mon, 04 Apr 2022 05:50:57 -0400
X-MC-Unique: dALdLs2bMXycxz_RvAqKcg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FEE4811E83;
        Mon,  4 Apr 2022 09:50:56 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A1E95745E0;
        Mon,  4 Apr 2022 09:50:53 +0000 (UTC)
Message-ID: <837ad042dcbfc699c54434e9ed473e3b409546b0.camel@redhat.com>
Subject: Re: [PATCH 2/5] KVM: SVM: Downgrade BUG_ON() to WARN_ON() in
 svm_inject_irq()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jon Grimm <Jon.Grimm@amd.com>,
        David Kaplan <David.Kaplan@amd.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Liam Merwick <liam.merwick@oracle.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 04 Apr 2022 12:50:52 +0300
In-Reply-To: <3f8422d9185477148e53440a4c6d66acbf387f65.1646944472.git.maciej.szmigiero@oracle.com>
References: <cover.1646944472.git.maciej.szmigiero@oracle.com>
         <3f8422d9185477148e53440a4c6d66acbf387f65.1646944472.git.maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-03-10 at 22:38 +0100, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> There is no need to bring down the whole host just because there might be
> some issue with respect to guest GIF handling in KVM.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> ---
>  arch/x86/kvm/svm/svm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b069493ad5c7..1e5d904aeec3 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3322,7 +3322,7 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> -	BUG_ON(!(gif_set(svm)));
> +	WARN_ON(!gif_set(svm));
>  
>  	trace_kvm_inj_virq(vcpu->arch.interrupt.nr);
>  	++vcpu->stat.irq_injections;
> 
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

