Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D06555687A0
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 14:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbiGFMBI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 08:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233408AbiGFMBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 08:01:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6E5262983C
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 05:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657108856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QxoUQEd9T+5d75jxMjI+RMAFpSP159lEO1UAIvXOQUI=;
        b=HFpURHa8mpGUcGfj9KuZUAv8xZNQkAXMRLuwjJn+QLoLd9nP69NIJGM1a9VUzaF4nx7g2y
        u+P+7KSV0e5GqKaW+OWudC8qPtYgOYyX6C44L32DT7dSWTDaXxhUqzx88YsbzlDUXYmxjz
        2fJ74zPYG7SnaTBPwELdqb6M3Akk/28=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-kzt-C4n3OzG5Krm-U2CwNQ-1; Wed, 06 Jul 2022 08:00:53 -0400
X-MC-Unique: kzt-C4n3OzG5Krm-U2CwNQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7EBB294EDE0;
        Wed,  6 Jul 2022 12:00:52 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 57E0A1415117;
        Wed,  6 Jul 2022 12:00:50 +0000 (UTC)
Message-ID: <1b59bf16b21f2fd5cedc3e88e1c437185b48d48c.camel@redhat.com>
Subject: Re: [PATCH v2 10/21] KVM: VMX: Inject #PF on ENCLS as "emulated" #PF
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Wed, 06 Jul 2022 15:00:49 +0300
In-Reply-To: <20220614204730.3359543-11-seanjc@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <20220614204730.3359543-11-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-14 at 20:47 +0000, Sean Christopherson wrote:
> Treat #PFs that occur during emulation of ENCLS as, wait for it, emulated
> page faults.  Practically speaking, this is a glorified nop as the
> exception is never of the nested flavor, and it's extremely unlikely the
> guest is relying on the side effect of an implicit INVLPG on the faulting
> address.
> 
> Fixes: 70210c044b4e ("KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/sgx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
> index 35e7ec91ae86..966cfa228f2a 100644
> --- a/arch/x86/kvm/vmx/sgx.c
> +++ b/arch/x86/kvm/vmx/sgx.c
> @@ -129,7 +129,7 @@ static int sgx_inject_fault(struct kvm_vcpu *vcpu, gva_t gva, int trapnr)
>  		ex.address = gva;
>  		ex.error_code_valid = true;
>  		ex.nested_page_fault = false;
> -		kvm_inject_page_fault(vcpu, &ex);
> +		kvm_inject_emulated_page_fault(vcpu, &ex);
>  	} else {
>  		kvm_inject_gp(vcpu, 0);
>  	}

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

