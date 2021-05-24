Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A66138E6B4
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 14:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbhEXMhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 08:37:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21225 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232881AbhEXMhJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 08:37:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621859741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sPrnPwttwogIYfGabVoozF1uNjPfxxPU01FzBy8sBWY=;
        b=eWM9aN/y0GxQFsZd6o6jZwX6ZbHsMXoJfJbLfqBaHy/SGhQrrGpXAB9NXxfeAVegbXcqRX
        JWiu1U7QdfF4+EotSPVu4ts2bv71mmiSpwvVL/ioeDgVqhQZArst596CCm/oGnZVavCVCU
        g40H9IcaPCsLLpYsKbIoHHU/UdKTNZ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-hrX9LCoaOJOCQ2hnLc7PFQ-1; Mon, 24 May 2021 08:35:39 -0400
X-MC-Unique: hrX9LCoaOJOCQ2hnLc7PFQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22181107ACE6;
        Mon, 24 May 2021 12:35:38 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7DE49679ED;
        Mon, 24 May 2021 12:35:31 +0000 (UTC)
Message-ID: <42df9cffffb3b29630ab9cc37b8b038397ce6d02.camel@redhat.com>
Subject: Re: [PATCH v2 6/7] KVM: nVMX: Request to sync eVMCS from VMCS12
 after migration
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Date:   Mon, 24 May 2021 15:35:30 +0300
In-Reply-To: <20210517135054.1914802-7-vkuznets@redhat.com>
References: <20210517135054.1914802-1-vkuznets@redhat.com>
         <20210517135054.1914802-7-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-05-17 at 15:50 +0200, Vitaly Kuznetsov wrote:
> VMCS12 is used to keep the authoritative state during nested state
> migration. In case 'need_vmcs12_to_shadow_sync' flag is set, we're
> in between L2->L1 vmexit and L1 guest run when actual sync to
> enlightened (or shadow) VMCS happens. Nested state, however, has
> no flag for 'need_vmcs12_to_shadow_sync' so vmx_set_nested_state()->
> set_current_vmptr() always sets it. Enlightened vmptrld path, however,
> doesn't have the quirk so some VMCS12 changes may not get properly
> reflected to eVMCS and L1 will see an incorrect state.
> 
> Note, during L2 execution or when need_vmcs12_to_shadow_sync is not
> set the change is effectively a nop: in the former case all changes
> will get reflected during the first L2->L1 vmexit and in the later
> case VMCS12 and eVMCS are already in sync (thanks to
> copy_enlightened_to_vmcs12() in vmx_get_nested_state()).
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 3bfbf991bf45..a0dedd413a23 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3127,6 +3127,12 @@ static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
>  		if (evmptrld_status == EVMPTRLD_VMFAIL ||
>  		    evmptrld_status == EVMPTRLD_ERROR)
>  			return false;
> +
> +		/*
> +		 * Post migration VMCS12 always provides the most actual
> +		 * information, copy it to eVMCS upon entry.
> +		 */
> +		vmx->nested.need_vmcs12_to_shadow_sync = true;

I noticed that bug too while reviewing the previous patches, 
wasted some time thinking about it :-(

This does look like a clean and correct way to fix this, unless
you adopt my suggestion to sync evmcs right away on nested vmexit
as I explained in my review of patch 3 of this series.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

>  	}
>  
>  	return true;




