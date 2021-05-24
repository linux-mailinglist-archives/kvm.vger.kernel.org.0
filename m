Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A3438E68C
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 14:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbhEXM3Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 08:29:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34932 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232466AbhEXM3X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 08:29:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621859275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C8s6UDLBaEnzmoK9897pWdX9cQMuXTxerOMmbOPM/G0=;
        b=PgdrcY+pCYAEnLdFJmy7PuVqoBi/RsWVyKsqgjSHFJNZiX+Dq47MRRJAQBohQ91WZk8rhl
        D8lLpVzilXSIy9zordwKB7g9g++qmDBKJ9LQ4dztzHm5u/NwSzkkU31bHGDGzftlIYCn+1
        fMjOiPKAM/HC+Z9vd3T+vfZpCqY4YiQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-l9NzareUNteq_FyHRipiwQ-1; Mon, 24 May 2021 08:27:51 -0400
X-MC-Unique: l9NzareUNteq_FyHRipiwQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C90B107ACE8;
        Mon, 24 May 2021 12:27:50 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B8F377F1E;
        Mon, 24 May 2021 12:27:48 +0000 (UTC)
Message-ID: <03eb61e5365566ea2abcb54896263f88e1fcaf92.camel@redhat.com>
Subject: Re: [PATCH v2 4/7] KVM: nVMX: Force enlightened VMCS sync from
 nested_vmx_failValid()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Date:   Mon, 24 May 2021 15:27:47 +0300
In-Reply-To: <20210517135054.1914802-5-vkuznets@redhat.com>
References: <20210517135054.1914802-1-vkuznets@redhat.com>
         <20210517135054.1914802-5-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-05-17 at 15:50 +0200, Vitaly Kuznetsov wrote:
> 'need_vmcs12_to_shadow_sync' is used for both shadow and enlightened
> VMCS sync when we exit to L1. The comment in nested_vmx_failValid()
> validly states why shadow vmcs sync can be omitted but this doesn't
> apply to enlightened VMCS as it 'shadows' all VMCS12 fields.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index ec476f64df73..eb2d25a93356 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -194,9 +194,13 @@ static int nested_vmx_failValid(struct kvm_vcpu *vcpu,
>  			| X86_EFLAGS_ZF);
>  	get_vmcs12(vcpu)->vm_instruction_error = vm_instruction_error;
>  	/*
> -	 * We don't need to force a shadow sync because
> -	 * VM_INSTRUCTION_ERROR is not shadowed
> +	 * We don't need to force sync to shadow VMCS because
> +	 * VM_INSTRUCTION_ERROR is not shadowed. Enlightened VMCS 'shadows' all
> +	 * fields and thus must be synced.
>  	 */
> +	if (nested_evmcs_is_used(to_vmx(vcpu)))
> +		to_vmx(vcpu)->nested.need_vmcs12_to_shadow_sync = true;

Cool, this is a bug that I noticed too while reviewing
previous patches in this series.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

> +
>  	return kvm_skip_emulated_instruction(vcpu);
>  }
>  


