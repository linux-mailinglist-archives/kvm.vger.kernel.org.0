Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E321818F781
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 15:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgCWOvZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 10:51:25 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:25117 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725710AbgCWOvZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 10:51:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584975084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5hQzIwtp3bgtyhedyuAt37bjmJHfQ80rOAEIpq2q59s=;
        b=DtWQ1WChViEzBXmBkyO11LN9ssTwCcNkb8H7GtTFkpeuleFgKCkzB7ly0jZv/SiNdrzrJ9
        GJEj5cX3TxqtjYFhBiDKdr5BV7wl3h+Et/OLG0k60ofWRAt7YQYjv7XoHdyN6s4OUDilqb
        7Djn2Z2rhl2wZWZ7EDy7DElDUSHvgwQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-x2SVvJClOvCv27cVP6qJuw-1; Mon, 23 Mar 2020 10:51:22 -0400
X-MC-Unique: x2SVvJClOvCv27cVP6qJuw-1
Received: by mail-wr1-f71.google.com with SMTP id p2so7471706wrw.8
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 07:51:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=5hQzIwtp3bgtyhedyuAt37bjmJHfQ80rOAEIpq2q59s=;
        b=jn/pkSk3olf05fnr86AZ2DtlgI7zy1XMO3umfQi1ehz90o8l32SUFI6URjHR4wPw2I
         aQ5pQDQv4SJR2vVb5H+IvsH94t3J5RvqKhdg5yxs+DgBZFRe4B75AoCEhc14ZCr5yq19
         7O1Ei2EaRW/n8YgsQVlz/XqOpyvHC5TkCkqOSI03bpQRImFjVOU369qomv5PaY0bhkx5
         WIiLYT5mo+3K1fi/jClbocUHpissCh6TuGMm16hexon2wbNjButlB5kCkdwsGLz4BhUX
         hGKZqcV8Ax0gcTWw1QNz+iSdX0zJLySloROyUq8OmmZhJUulEN2fDYINQAGjOwxUVvD2
         xvKw==
X-Gm-Message-State: ANhLgQ3U760LnZzuR8mDj8DgQzsd54G6nCG4NpgZEwKFsntEtRYZpQjX
        ELZz0YEH75Doi8UYdPOOv8DAbgb+kaaqZxqzWDEGvZprDM96/zynBRK7vhDxZEj0KYfbsbwtboQ
        pSYrkZk23USvc
X-Received: by 2002:adf:97c1:: with SMTP id t1mr30336568wrb.365.1584975080141;
        Mon, 23 Mar 2020 07:51:20 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtv6CLGR/t9FJRgX3W/NJupPEZxVu8xP0RF001TVuZsrbyXW03jsERApw0prry/p+1nC0pqdg==
X-Received: by 2002:adf:97c1:: with SMTP id t1mr30336537wrb.365.1584975079843;
        Mon, 23 Mar 2020 07:51:19 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id t21sm9456865wmt.43.2020.03.23.07.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 07:51:19 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 02/37] KVM: nVMX: Validate the EPTP when emulating INVEPT(EXTENT_CONTEXT)
In-Reply-To: <20200320212833.3507-3-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com> <20200320212833.3507-3-sean.j.christopherson@intel.com>
Date:   Mon, 23 Mar 2020 15:51:17 +0100
Message-ID: <871rpj9lay.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Signal VM-Fail for the single-context variant of INVEPT if the specified
> EPTP is invalid.  Per the INEVPT pseudocode in Intel's SDM, it's subject
> to the standard EPT checks:
>
>   If VM entry with the "enable EPT" VM execution control set to 1 would
>   fail due to the EPTP value then VMfail(Invalid operand to INVEPT/INVVPID);
>
> Fixes: bfd0a56b90005 ("nEPT: Nested INVEPT")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 8578513907d7..f3774cef4fd4 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5156,8 +5156,12 @@ static int handle_invept(struct kvm_vcpu *vcpu)
>  	}
>  
>  	switch (type) {
> -	case VMX_EPT_EXTENT_GLOBAL:
>  	case VMX_EPT_EXTENT_CONTEXT:
> +		if (!nested_vmx_check_eptp(vcpu, operand.eptp))
> +			return nested_vmx_failValid(vcpu,
> +				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);

I was going to ask "and we don't seem to check that current nested VMPTR
is valid, how can we know that nested_vmx_failValid() is the right
VMfail() to use" but then I checked our nested_vmx_failValid() and there
is a fallback there:

	if (vmx->nested.current_vmptr == -1ull && !vmx->nested.hv_evmcs)
		return nested_vmx_failInvalid(vcpu);

so this is a non-issue. My question, however, transforms into "would it
make sense to introduce nested_vmx_fail() implementing the logic from
SDM:

VMfail(ErrorNumber):
	IF VMCS pointer is valid
		THEN VMfailValid(ErrorNumber);
	ELSE VMfailInvalid;
	FI;

to assist an innocent reader of the code?"

> +		fallthrough;
> +	case VMX_EPT_EXTENT_GLOBAL:
>  	/*
>  	 * TODO: Sync the necessary shadow EPT roots here, rather than
>  	 * at the next emulated VM-entry.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

