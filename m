Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC663BE656
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 12:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhGGKa7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 06:30:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43607 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230354AbhGGKa6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 06:30:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625653698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JAsRKixLlFTQivPlmLOEdtQEKazkQp3XKv7519kNO+4=;
        b=V9l3AoEG/qcQLKbX19zIH9bkJbFzzISpzFHNwgHho8IAxj1ndyi58L5RwoIOYDxHMkiViF
        FNEaRuAcU3g2rS5qSQbdLAi+atccJF1NgZCGiNvM+MdwiQbhxHnsBQPhH2GKHbWUnMDG19
        qK16gfJVKbtAX9ryiKU7lF357BYbcX8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-z_zln7BkM3K_TwST-R7dMw-1; Wed, 07 Jul 2021 06:28:17 -0400
X-MC-Unique: z_zln7BkM3K_TwST-R7dMw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 660A1800C78;
        Wed,  7 Jul 2021 10:28:15 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA5C860C17;
        Wed,  7 Jul 2021 10:28:11 +0000 (UTC)
Message-ID: <595c45e8fb753556b2c01b25ac7052369c8357ac.camel@redhat.com>
Subject: Re: [PATCH 1/6] KVM: nSVM: Check the value written to
 MSR_VM_HSAVE_PA
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Cathy Avery <cavery@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date:   Wed, 07 Jul 2021 13:28:10 +0300
In-Reply-To: <20210628104425.391276-2-vkuznets@redhat.com>
References: <20210628104425.391276-1-vkuznets@redhat.com>
         <20210628104425.391276-2-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-06-28 at 12:44 +0200, Vitaly Kuznetsov wrote:
> APM states that #GP is raised upon write to MSR_VM_HSAVE_PA when
> the supplied address is not page-aligned or is outside of "maximum
> supported physical address for this implementation".
> page_address_valid() check seems suitable. Also, forcefully page-align
> the address when it's written from VMM.

Minor nitpick: I would have checked the host provided value as well,
just in case since there is no reason why it won't pass the same check, 
and fail if the value is not aligned. 

Other than that:
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/svm/svm.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 8834822c00cd..b6f85fd19f96 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2941,7 +2941,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  			svm_disable_lbrv(vcpu);
>  		break;
>  	case MSR_VM_HSAVE_PA:
> -		svm->nested.hsave_msr = data;
> +		if (!msr->host_initiated && !page_address_valid(vcpu, data))
> +			return 1;
> +
> +		svm->nested.hsave_msr = data & PAGE_MASK;
>  		break;
>  	case MSR_VM_CR:
>  		return svm_set_vm_cr(vcpu, data);


