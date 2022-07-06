Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB56756881F
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 14:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbiGFMQc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 08:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233511AbiGFMQ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 08:16:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A56718390
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 05:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657109787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pCQdanV41Z2AnlO+nBFS2QF5nGx7EX2TDRux07LhMKc=;
        b=SrTjbFd7HEWqnz4Y+wybiFZqHNZndAD9gT5o/R8bz2J8BeGZJq0rwpN9AYPMetfMWytwAR
        3PZhfpb5OPK/Y07EVlg/osUwwrCbc0ZAcf23LPtYRTrDrzUIkDs3veCQyMBgiNcbmXcNPT
        5N+I2uB93lkrI/OVbegiy1426iGXJTw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-um9W2-pnM-KGxMcSr1nuwA-1; Wed, 06 Jul 2022 08:16:24 -0400
X-MC-Unique: um9W2-pnM-KGxMcSr1nuwA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFF55805BDB;
        Wed,  6 Jul 2022 12:16:23 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F8DD492C3B;
        Wed,  6 Jul 2022 12:16:21 +0000 (UTC)
Message-ID: <e02e6b72d1aabc2b09273557d53d486940436a8e.camel@redhat.com>
Subject: Re: [PATCH v2 18/21] KVM: x86: Treat pending TRIPLE_FAULT requests
 as pending exceptions
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Wed, 06 Jul 2022 15:16:20 +0300
In-Reply-To: <20220614204730.3359543-19-seanjc@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <20220614204730.3359543-19-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-14 at 20:47 +0000, Sean Christopherson wrote:
> Treat pending TRIPLE_FAULTS as pending exceptions.  A triple fault is an
> exception for all intents and purposes, it's just not tracked as such
> because there's no vector associated the exception.  E.g. if userspace
> were to set vcpu->request_interrupt_window while running L2 and L2 hit a
> triple fault, a triple fault nested VM-Exit should be synthesized to L1
> before exiting to userspace with KVM_EXIT_IRQ_WINDOW_OPEN.
> 
> Link: https://lore.kernel.org/all/YoVHAIGcFgJit1qp@google.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 3 ---
>  arch/x86/kvm/x86.h | 3 ++-
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 63ee79da50df..8e54a074b7ff 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12477,9 +12477,6 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
>         if (kvm_xen_has_pending_events(vcpu))
>                 return true;
>  
> -       if (kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu))
> -               return true;
> -
>         return false;
>  }
>  
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index eee259e387d3..078765287ec6 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -85,7 +85,8 @@ int kvm_check_nested_events(struct kvm_vcpu *vcpu);
>  static inline bool kvm_is_exception_pending(struct kvm_vcpu *vcpu)
>  {
>         return vcpu->arch.exception.pending ||
> -              vcpu->arch.exception_vmexit.pending;
> +              vcpu->arch.exception_vmexit.pending ||
> +              kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu);
>  }
>  
>  static inline void kvm_clear_exception_queue(struct kvm_vcpu *vcpu)


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

