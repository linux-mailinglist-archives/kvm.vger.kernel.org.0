Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C5B377D97
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhEJIEY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:04:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31986 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229852AbhEJIEY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 04:04:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620633799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yTnjHtJM9cM9/CNRU7MdS6zqnbDhW6KdwOPWG8fu3lE=;
        b=PP+bP8eREr/dB27Zku8Vn7Mzuli6KXgLcxylzDHilPaoBkzV4W4/KP7LlPEsg6CsNnne/B
        2tG4GN/hbNfTr5TZysAv9fxF9ylmA7sB3DVA3FszECfUvV9oUuXnKR5L8JiTqzru3iMZsa
        mHXrVaGFuiNfrxJodfM+g8El+ICG3Pk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-92GvdBxGNIm505JoPPZ2VA-1; Mon, 10 May 2021 04:03:18 -0400
X-MC-Unique: 92GvdBxGNIm505JoPPZ2VA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49C721006C81;
        Mon, 10 May 2021 08:03:16 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44EFE19C45;
        Mon, 10 May 2021 08:03:11 +0000 (UTC)
Message-ID: <666b1f0a597383bf0c838d9bfde5f07d6d0828c6.camel@redhat.com>
Subject: Re: [PATCH 01/15] KVM: VMX: Do not adverise RDPID if ENABLE_RDTSCP
 control is unsupported
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Date:   Mon, 10 May 2021 11:03:10 +0300
In-Reply-To: <20210504171734.1434054-2-seanjc@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
         <20210504171734.1434054-2-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-05-04 at 10:17 -0700, Sean Christopherson wrote:
> Clear KVM's RDPID capability if the ENABLE_RDTSCP secondary exec control is
> unsupported.  Despite being enumerated in a separate CPUID flag, RDPID is
> bundled under the same VMCS control as RDTSCP and will #UD in VMX non-root
> if ENABLE_RDTSCP is not enabled.
> 
> Fixes: 41cd02c6f7f6 ("kvm: x86: Expose RDPID in KVM_GET_SUPPORTED_CPUID")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 10b610fc7bbc..82404ee2520e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7377,9 +7377,11 @@ static __init void vmx_set_cpu_caps(void)
>  	if (!cpu_has_vmx_xsaves())
>  		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
>  
> -	/* CPUID 0x80000001 */
> -	if (!cpu_has_vmx_rdtscp())
> +	/* CPUID 0x80000001 and 0x7 (RDPID) */
> +	if (!cpu_has_vmx_rdtscp()) {
>  		kvm_cpu_cap_clear(X86_FEATURE_RDTSCP);
> +		kvm_cpu_cap_clear(X86_FEATURE_RDPID);
> +	}
>  
>  	if (cpu_has_vmx_waitpkg())
>  		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

