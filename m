Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A373D236E
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 14:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbhGVL7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 07:59:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37548 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231815AbhGVL7R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 07:59:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626957592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ykv5wmLf4ZccwydelwmDaJ14hxc/5bcYf6Q0csIyjtg=;
        b=XS4UeyA7eBuMs3aNP9cIB0HJBkeQVAJyIQOV0qJawmFEVkZftJkQrASRozX8nYblDMN5AS
        ts0f47rpPRTwWFJQsbnp/aPY0GYnrYcs3jNn2bhiKt6OE8Z2+JnYV9CLoW80NKdJ/tdBds
        E4gnK2SxT8p5QN8W/E9WmteNlTrUuxc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-d918l_wTNZmGfLz9gz7SAg-1; Thu, 22 Jul 2021 08:39:51 -0400
X-MC-Unique: d918l_wTNZmGfLz9gz7SAg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 762D28B0600;
        Thu, 22 Jul 2021 12:39:49 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EB3425C1C2;
        Thu, 22 Jul 2021 12:39:46 +0000 (UTC)
Message-ID: <e2aa50650b118b877d4fc10cd832bd1c05271f8b.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: Check the right feature bit for
 MSR_KVM_ASYNC_PF_ACK access
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Date:   Thu, 22 Jul 2021 15:39:45 +0300
In-Reply-To: <20210722123018.260035-1-vkuznets@redhat.com>
References: <20210722123018.260035-1-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-07-22 at 14:30 +0200, Vitaly Kuznetsov wrote:
> MSR_KVM_ASYNC_PF_ACK MSR is part of interrupt based asynchronous page fault
> interface and not the original (deprecated) KVM_FEATURE_ASYNC_PF. This is
> stated in Documentation/virt/kvm/msr.rst.
> 
> Fixes: 66570e966dd9 ("kvm: x86: only provide PV features if enabled in guest's CPUID")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d715ae9f9108..88ff7a1af198 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3406,7 +3406,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			return 1;
>  		break;
>  	case MSR_KVM_ASYNC_PF_ACK:
> -		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF))
> +		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT))
>  			return 1;
>  		if (data & 0x1) {
>  			vcpu->arch.apf.pageready_pending = false;
> @@ -3745,7 +3745,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		msr_info->data = vcpu->arch.apf.msr_int_val;
>  		break;
>  	case MSR_KVM_ASYNC_PF_ACK:
> -		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF))
> +		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT))
>  			return 1;
>  
>  		msr_info->data = 0;

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

