Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05F1504DF6
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 10:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237311AbiDRIkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 04:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237296AbiDRIks (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 04:40:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F1EC9193FC
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 01:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650271089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LdbvqaVaOQQPzji0XpZH7xN+F7oFT2JmFZMage+5BKI=;
        b=EoYM7o5jiwnanELXscUnlps3relb6MK7EYwySYo3tdQ11aSq0+pObTzxIKPtfYTiFq7w87
        c+XjzEYvNIa6+R2Dsoj/JLBspPM7evY3F2wWjKfCFq+HdLVWjAVy88pev07MPZOOED9zE0
        kRfH9X5PoSQHRu8xVUTRJStxH5eS5yA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-UeOd6_AiPpuzzfvLJa-NTw-1; Mon, 18 Apr 2022 04:38:06 -0400
X-MC-Unique: UeOd6_AiPpuzzfvLJa-NTw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45BA380005D;
        Mon, 18 Apr 2022 08:37:55 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89C71C5094E;
        Mon, 18 Apr 2022 08:37:49 +0000 (UTC)
Message-ID: <d2820bafeea6e908108bac863269a7ff7f519999.camel@redhat.com>
Subject: Re: [PATCH 1/4] KVM: x86: Tag APICv DISABLE inhibit, not ABSENT, if
 APICv is disabled
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gaoning Pan <pgn@zju.edu.cn>,
        Yongkang Jia <kangel@zju.edu.cn>
Date:   Mon, 18 Apr 2022 11:37:48 +0300
In-Reply-To: <20220416034249.2609491-2-seanjc@google.com>
References: <20220416034249.2609491-1-seanjc@google.com>
         <20220416034249.2609491-2-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-04-16 at 03:42 +0000, Sean Christopherson wrote:
> Set the DISABLE inhibit, not the ABSENT inhibit, if APICv is disabled via
> module param.  A recent refactoring to add a wrapper for setting/clearing
> inhibits unintentionally changed the flag, probably due to a copy+paste
> goof.
> 
> Fixes: 4f4c4a3ee53c ("KVM: x86: Trace all APICv inhibit changes and capture overall status")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ab336f7c82e4..753296902535 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9159,7 +9159,7 @@ static void kvm_apicv_init(struct kvm *kvm)
>  
>  	if (!enable_apicv)
>  		set_or_clear_apicv_inhibit(inhibits,
> -					   APICV_INHIBIT_REASON_ABSENT, true);
> +					   APICV_INHIBIT_REASON_DISABLE, true);
>  }
>  
>  static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)

So ABSENT means that userspace didn't enable, it and DISABLE means kernel module param disabled it.
I didn't follow patches that touched those but it feels like we can use a single inhibit reason for both,
or at least make better names for this. APICV_INHIBIT_REASON_ABSENT doesn't sound good to me.

Having said that, the patch is OK.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

