Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4573BE658
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 12:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhGGKbQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 06:31:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26690 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231137AbhGGKbQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 06:31:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625653715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R31OBQCGxDbFDo5h14oM1SM1akB7TTfct9Ykk8ny+hw=;
        b=Ai596GmZoNDyVLwrGi4xEWVDEoXiYziJnFKMaIAaPH220g/4KgPu1/QfoBn47vy5PQogVs
        +vR3TdBCAPYlemcPZjFPE3l1zktKcuDXaCC68fLyXHS0O4pbGIrkt2/xWcRb0iU/UHNGlF
        4AqNeY5i5lENiJ3sgIw9cFwblkOSiZw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-_fq_S3AuNgmH43JCikXP6Q-1; Wed, 07 Jul 2021 06:28:34 -0400
X-MC-Unique: _fq_S3AuNgmH43JCikXP6Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8376E100CCC0;
        Wed,  7 Jul 2021 10:28:33 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 143CD5D9D3;
        Wed,  7 Jul 2021 10:28:26 +0000 (UTC)
Message-ID: <0e00f5ecfcd8c01560abf872b648ae29999e8f01.camel@redhat.com>
Subject: Re: [PATCH 2/6] KVM: nSVM: Check that VM_HSAVE_PA MSR was set
 before VMRUN
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
Date:   Wed, 07 Jul 2021 13:28:25 +0300
In-Reply-To: <20210628104425.391276-3-vkuznets@redhat.com>
References: <20210628104425.391276-1-vkuznets@redhat.com>
         <20210628104425.391276-3-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-06-28 at 12:44 +0200, Vitaly Kuznetsov wrote:
> APM states that "The address written to the VM_HSAVE_PA MSR, which holds
> the address of the page used to save the host state on a VMRUN, must point
> to a hypervisor-owned page. If this check fails, the WRMSR will fail with
> a #GP(0) exception. Note that a value of 0 is not considered valid for the
> VM_HSAVE_PA MSR and a VMRUN that is attempted while the HSAVE_PA is 0 will
> fail with a #GP(0) exception."
> 
> svm_set_msr() already checks that the supplied address is valid, so only
> check for '0' is missing. Add it to nested_svm_vmrun().
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 21d03e3a5dfd..1c6b0698b52e 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -618,6 +618,11 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>  	struct kvm_host_map map;
>  	u64 vmcb12_gpa;
>  
> +	if (!svm->nested.hsave_msr) {
> +		kvm_inject_gp(vcpu, 0);
> +		return 1;
> +	}
> +
>  	if (is_smm(vcpu)) {
>  		kvm_queue_exception(vcpu, UD_VECTOR);
>  		return 1;

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

