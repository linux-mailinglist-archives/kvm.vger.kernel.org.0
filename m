Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22CA5232D6
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 14:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242374AbiEKMSR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 08:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241942AbiEKMSM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 08:18:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E018051325
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 05:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652271472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GmA6q8NHctcH7NYPbs3482+F7yKLa2wa2JctRTVCpik=;
        b=OOYylsa9cUOBmxxJFlpkQ996dq/eOknjEa6DHVx1mbjsvaXcbt3Zdnb6fpCuqrruci2DUY
        /75GR3shtjiVsNVDN1ZO0JpZHdrKXP2tttVzoaulMrNLJjFHEu3yPYNmWslFZ7usTwF5vZ
        RUeAB+45VfQZBUG4iYAsEDTYx5yg3rQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-PIEiMDleNpaSTO1vz-LX1g-1; Wed, 11 May 2022 08:17:51 -0400
X-MC-Unique: PIEiMDleNpaSTO1vz-LX1g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BEDCD1010361;
        Wed, 11 May 2022 12:17:50 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D43D416388;
        Wed, 11 May 2022 12:17:48 +0000 (UTC)
Message-ID: <fcff5785d43c4defe60c42a15f324b7f7a17178f.camel@redhat.com>
Subject: Re: [PATCH v3 29/34] KVM: selftests: nSVM: Allocate Hyper-V
 partition assist and VP assist pages
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 15:17:47 +0300
In-Reply-To: <20220414132013.1588929-30-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-30-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 15:20 +0200, Vitaly Kuznetsov wrote:
> In preparation to testing Hyper-V L2 TLB flush hypercalls, allocate VP
> assist and Partition assist pages and link them to 'struct svm_test_data'.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  tools/testing/selftests/kvm/include/x86_64/svm_util.h | 10 ++++++++++
>  tools/testing/selftests/kvm/lib/x86_64/svm.c          | 10 ++++++++++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
> index a25aabd8f5e7..640859b58fd6 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
> @@ -34,6 +34,16 @@ struct svm_test_data {
>  	void *msr; /* gva */
>  	void *msr_hva;
>  	uint64_t msr_gpa;
> +
> +	/* Hyper-V VP assist page */
> +	void *vp_assist; /* gva */
> +	void *vp_assist_hva;
> +	uint64_t vp_assist_gpa;
> +
> +	/* Hyper-V Partition assist page */
> +	void *partition_assist; /* gva */
> +	void *partition_assist_hva;
> +	uint64_t partition_assist_gpa;
>  };
>  
>  struct svm_test_data *vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva);
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/svm.c b/tools/testing/selftests/kvm/lib/x86_64/svm.c
> index 736ee4a23df6..c284e8f87f5c 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/svm.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/svm.c
> @@ -48,6 +48,16 @@ vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva)
>  	svm->msr_gpa = addr_gva2gpa(vm, (uintptr_t)svm->msr);
>  	memset(svm->msr_hva, 0, getpagesize());
>  
> +	svm->vp_assist = (void *)vm_vaddr_alloc_page(vm);
> +	svm->vp_assist_hva = addr_gva2hva(vm, (uintptr_t)svm->vp_assist);
> +	svm->vp_assist_gpa = addr_gva2gpa(vm, (uintptr_t)svm->vp_assist);
> +	memset(svm->vp_assist_hva, 0, getpagesize());
> +
> +	svm->partition_assist = (void *)vm_vaddr_alloc_page(vm);
> +	svm->partition_assist_hva = addr_gva2hva(vm, (uintptr_t)svm->partition_assist);
> +	svm->partition_assist_gpa = addr_gva2gpa(vm, (uintptr_t)svm->partition_assist);
> +	memset(svm->partition_assist_hva, 0, getpagesize());
> +
>  	*p_svm_gva = svm_gva;
>  	return svm;
>  }

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

