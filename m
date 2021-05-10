Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7541377DC1
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbhEJIPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:15:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28922 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230045AbhEJIPv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 04:15:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620634486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YzIlE0g/4U7xWXnQ0lyKGcEjcSAJhWnyeWZnCZ0Wzz4=;
        b=aTNRUloBh+2R5EW9MsyrmD9SOaEYdgmehPaS/5ZaOp+vTNZLevfDv1i4voDVYY0Hz0KRud
        Gm4EUAtfEpqcj7op3Ns2syDe4VInJMQPsD7K4BdiW9HZC70y0UDRLzddcPs7jnTJ3VnrEQ
        4LIAR03BTaAMeLhJtsJ97OlmTm1GHrk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-_0aJNn2oOaSeZL52oNUMWQ-1; Mon, 10 May 2021 04:14:45 -0400
X-MC-Unique: _0aJNn2oOaSeZL52oNUMWQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CD031008060;
        Mon, 10 May 2021 08:14:43 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75C8560E3A;
        Mon, 10 May 2021 08:14:40 +0000 (UTC)
Message-ID: <01c04a2335c913437b98e3ea874357689b097990.camel@redhat.com>
Subject: Re: [PATCH 04/15] KVM: x86: Move RDPID emulation intercept to its
 own enum
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Date:   Mon, 10 May 2021 11:14:39 +0300
In-Reply-To: <20210504171734.1434054-5-seanjc@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
         <20210504171734.1434054-5-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-05-04 at 10:17 -0700, Sean Christopherson wrote:
> Add a dedicated intercept enum for RDPID instead of piggybacking RDTSCP.
> Unlike VMX's ENABLE_RDTSCP, RDPID is not bound to SVM's RDTSCP intercept.
> 
> Fixes: fb6d4d340e05 ("KVM: x86: emulate RDPID")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/emulate.c     | 2 +-
>  arch/x86/kvm/kvm_emulate.h | 1 +
>  arch/x86/kvm/vmx/vmx.c     | 3 ++-
>  3 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index abd9a4db11a8..8fc71e70857d 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -4502,7 +4502,7 @@ static const struct opcode group8[] = {
>   * from the register case of group9.
>   */
>  static const struct gprefix pfx_0f_c7_7 = {
> -	N, N, N, II(DstMem | ModRM | Op3264 | EmulateOnUD, em_rdpid, rdtscp),
> +	N, N, N, II(DstMem | ModRM | Op3264 | EmulateOnUD, em_rdpid, rdpid),
>  };
>  
>  
> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> index 0d359115429a..f016838faedd 100644
> --- a/arch/x86/kvm/kvm_emulate.h
> +++ b/arch/x86/kvm/kvm_emulate.h
> @@ -468,6 +468,7 @@ enum x86_intercept {
>  	x86_intercept_clgi,
>  	x86_intercept_skinit,
>  	x86_intercept_rdtscp,
> +	x86_intercept_rdpid,
>  	x86_intercept_icebp,
>  	x86_intercept_wbinvd,
>  	x86_intercept_monitor,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 82404ee2520e..99591e523b47 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7437,8 +7437,9 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
>  	/*
>  	 * RDPID causes #UD if disabled through secondary execution controls.
>  	 * Because it is marked as EmulateOnUD, we need to intercept it here.
> +	 * Note, RDPID is hidden behind ENABLE_RDTSCP.
>  	 */
> -	case x86_intercept_rdtscp:
> +	case x86_intercept_rdpid:
Shoudn't this path still handle the x86_intercept_rdtscp as I described below,
or should we remove it from the SVM side as well?

>  		if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENABLE_RDTSCP)) {
>  			exception->vector = UD_VECTOR;
>  			exception->error_code_valid = false;

I have a maybe unrelated question that caught my eye:
I see this:

	DIP(SrcNone, rdtscp, check_rdtsc),

As far as I can see this means that if a nested guest executes
the rdtscp, and L1 intercepts it, then we will emulate the rdtscp by doing a nested
VM exit, but if we emulate a rdtscp for L1, we will fail since there is no .execute callback.

Is this intentional? As I understand it, at least in theory the emulator can be called
on any instruction due to things like lack of unrestricted guest, and/or emulating an
instruction on page fault (although the later is usually done by re-executing the instruction).

I know that the x86 emulator is far from being complete for such cases but I 
do wonder why rdtspc has different behavior in regard to nested and not nested case.

So this patch (since it removes the x86_intercept_rdtscp handling from the VMX),
should break the rdtscp emulation for the nested guest on VMX, although it is probably
not used anyway and should be removed.

Best regards,
	Maxim Levitsky


