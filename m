Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF4205A7B82
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 12:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiHaKko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 06:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiHaKkk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 06:40:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3478686C3B
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 03:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661942438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eY5LuG2wHGwxNQCbR+wrs6/M0fyvhRpWPUlG334Q3OU=;
        b=VsEyAUCL3yipe51FlE4U0S09XbzLXHVflwIJY9JgKOa5ApxuJhqN+KHYB8zWoLkpyFdWQO
        JN1E/9WW+87oWMNOJ1AyxdrkrlY38oZQOgyS2BsnkE1bxhmBNQL70a/ZZei+EtJgsVDS/X
        ibfnY2FmcAN+uCuxgr2gLS80eZe9NDU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-w06gCvOrOduQbFnOxFDzsg-1; Wed, 31 Aug 2022 06:40:34 -0400
X-MC-Unique: w06gCvOrOduQbFnOxFDzsg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CAE73800C3C;
        Wed, 31 Aug 2022 10:40:33 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 07B4A945D7;
        Wed, 31 Aug 2022 10:40:31 +0000 (UTC)
Message-ID: <06375b1fe988bee627f95b54b7d224adf8fe91ec.camel@redhat.com>
Subject: Re: [PATCH 18/19] KVM: SVM: Ignore writes to Remote Read Data on
 AVIC write traps
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 31 Aug 2022 13:40:30 +0300
In-Reply-To: <20220831003506.4117148-19-seanjc@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-19-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 00:35 +0000, Sean Christopherson wrote:
> Drop writes to APIC_RRR, a.k.a. Remote Read Data Register, on AVIC
> unaccelerated write traps.  The register is read-only and isn't emulated
> by KVM.  Sending the register through kvm_apic_write_nodecode() will
> result in screaming when x2APIC is enabled due to the unexpected failure
> to retrieve the MSR (KVM expects that only "legal" accesses will trap).

I wonder about ESR register as well (280H), KVM doesn't seem to support it either,
but allows 0 writes. Anyway:

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

> 
> Fixes: 4d1d7942e36a ("KVM: SVM: Introduce logic to (de)activate x2AVIC mode")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index dad5affe44c1..b2033a56010c 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -675,6 +675,9 @@ static int avic_unaccel_trap_write(struct kvm_vcpu *vcpu)
>  	case APIC_DFR:
>  		avic_handle_dfr_update(vcpu);
>  		break;
> +	case APIC_RRR:
> +		/* Ignore writes to Read Remote Data, it's read-only. */
> +		return 1;
>  	default:
>  		break;
>  	}


