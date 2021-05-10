Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4ED377DB1
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhEJIJ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:09:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43420 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230050AbhEJIJ0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 04:09:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620634101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cbgsgg0fZcU1I+mnQQzyZz5vF48xBdx7km7JFxmZ8AY=;
        b=Uexn+TPFBvkdwaAl9biBbV7KVryz8l067iYvG9GTJBEQoEdHk5A3ng2tr/SHY4+a19bEWJ
        rMMH6UmvWdUzDyWyMxWAncEvEs76b4NPSjj1thr72BcOqQMEbiRuL3P7zWqMRxGmxme9DQ
        s/+8qB5zl16XBc6SWKq80kAWmJkF0+s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-BLUM4czXPL2sRLahOcWQwA-1; Mon, 10 May 2021 04:08:18 -0400
X-MC-Unique: BLUM4czXPL2sRLahOcWQwA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A974A6D24A;
        Mon, 10 May 2021 08:08:16 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C5E8D62680;
        Mon, 10 May 2021 08:08:13 +0000 (UTC)
Message-ID: <bc90b793ac351f9426710d354bf0c3621f36e763.camel@redhat.com>
Subject: Re: [PATCH 02/15] KVM: x86: Emulate RDPID only if RDTSCP is
 supported
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Date:   Mon, 10 May 2021 11:08:12 +0300
In-Reply-To: <20210504171734.1434054-3-seanjc@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
         <20210504171734.1434054-3-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-05-04 at 10:17 -0700, Sean Christopherson wrote:
> Do not advertise emulation support for RDPID if RDTSCP is unsupported.
> RDPID emulation subtly relies on MSR_TSC_AUX to exist in hardware, as
> both vmx_get_msr() and svm_get_msr() will return an error if the MSR is
> unsupported, i.e. ctxt->ops->get_msr() will fail and the emulator will
> inject a #UD.
> 
> Note, RDPID emulation also relies on RDTSCP being enabled in the guest,
> but this is a KVM bug and will eventually be fixed.
> 
> Fixes: fb6d4d340e05 ("KVM: x86: emulate RDPID")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index f765bf7a529c..c96f79c9fff2 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -637,7 +637,8 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
>  	case 7:
>  		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
>  		entry->eax = 0;
> -		entry->ecx = F(RDPID);
> +		if (kvm_cpu_cap_has(X86_FEATURE_RDTSCP))
> +			entry->ecx = F(RDPID);
>  		++array->nent;
>  	default:
>  		break;

Just to make sure that I understand this correctly:

This is what I know:

Both RDTSCP and RDPID are instructions that read IA32_TSC_AUX
(and RDTSCP also reads the TSC).

Both instructions have their own CPUID bits (X86_FEATURE_RDPID, X86_FEATURE_RDTSCP)
If either of these CPUID bits are present, IA32_TSC_AUX should be supported.


RDPID is a newer feature, thus I can at least for the sanity sake assume that
usually a CPU will either have neither of the features, have only RDTSCP,
and IA32_AUX, or have both RDSCP and RDPID.

If not supported in hardware KVM only emulates RDPID as I see.

Why btw? Performance wise guest that only wants the IA32_AUX in userspace,
is better to use RDTSCP and pay the penalty of saving/restoring of the
unwanted registers, than use RDPID with a vmexit.

My own guess for an answer to this question is that RDPID emulation is there
to aid migration from a host that does support RDPID to a host that doesn't.

Having said all that, assuming that we don't want to emulate the RDTSCP too,
when it is not supported, then this patch does make sense.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


