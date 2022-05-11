Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0535232D1
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 14:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241974AbiEKMR7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 08:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242028AbiEKMRu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 08:17:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3880E506F1
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 05:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652271464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=skbETg0V9ztle8rerb+4K92+T6NFEIjseKb98Cse8og=;
        b=cpDVLdOaoehxvV4Bc+5SywR8BKR881fHMJywXfjFGaZnqYNUyOAGvuQKd9xN6F2QRYDNZi
        Y+z7W71LGkaCqYkmFv1plE/eQg5YzBTw4EkMI8WqtpTB/PVvi/TMrHdXXHj/XnRiJOJtbC
        Jt+V0OWDJIB4pPBvvfw2EcHhYHC0Ke4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-AH0IfOvKOOCjvgSu8HxyCw-1; Wed, 11 May 2022 08:17:39 -0400
X-MC-Unique: AH0IfOvKOOCjvgSu8HxyCw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7123D80B717;
        Wed, 11 May 2022 12:17:38 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2988E2026D6A;
        Wed, 11 May 2022 12:17:35 +0000 (UTC)
Message-ID: <e2558fe11676ee6954a19ffea66ac08f503e6da1.camel@redhat.com>
Subject: Re: [PATCH v3 28/34] KVM: selftests: nVMX: Allocate Hyper-V
 partition assist page
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 15:17:35 +0300
In-Reply-To: <20220414132013.1588929-29-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-29-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 15:20 +0200, Vitaly Kuznetsov wrote:
> In preparation to testing Hyper-V L2 TLB flush hypercalls, allocate
> so-called Partition assist page and link it to 'struct vmx_pages'.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  tools/testing/selftests/kvm/include/x86_64/vmx.h | 4 ++++
>  tools/testing/selftests/kvm/lib/x86_64/vmx.c     | 7 +++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
> index 583ceb0d1457..f99922ca8259 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
> @@ -567,6 +567,10 @@ struct vmx_pages {
>  	uint64_t enlightened_vmcs_gpa;
>  	void *enlightened_vmcs;
>  
> +	void *partition_assist_hva;
> +	uint64_t partition_assist_gpa;
> +	void *partition_assist;
> +
>  	void *eptp_hva;
>  	uint64_t eptp_gpa;
>  	void *eptp;
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> index d089d8b850b5..3db21e0e1a8f 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> @@ -124,6 +124,13 @@ vcpu_alloc_vmx(struct kvm_vm *vm, vm_vaddr_t *p_vmx_gva)
>  	vmx->enlightened_vmcs_gpa =
>  		addr_gva2gpa(vm, (uintptr_t)vmx->enlightened_vmcs);
>  
> +	/* Setup of a region of guest memory for the partition assist page. */
> +	vmx->partition_assist = (void *)vm_vaddr_alloc_page(vm);
> +	vmx->partition_assist_hva =
> +		addr_gva2hva(vm, (uintptr_t)vmx->partition_assist);
> +	vmx->partition_assist_gpa =
> +		addr_gva2gpa(vm, (uintptr_t)vmx->partition_assist);
> +
>  	*p_vmx_gva = vmx_gva;
>  	return vmx;
>  }


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

