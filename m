Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47CF218499
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 12:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgGHKDq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 06:03:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43599 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726196AbgGHKDp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 06:03:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594202623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ss9qJI2p1V/pw0FYJQ0mqsrCEJLHA4WfDlP5Y0PS6OI=;
        b=AIe8Pvkd9FWbxttuN58CyPpugB8Fa0Ing2m4WvFbpEgMmvTuvduz1siJAN5rlAGFVGIOKQ
        vRC2zPPi55I/A0CLgfDUSCQ/gO9Y+Sca2urUtPcVvhEAMgMZQQvR2yKq8Fw5wYFYObXOHg
        Rj1kFlDt0P/YtHDXRjXPpQt9Sf7Kkjc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-_viBK7_7N-a_wmTcAdINTg-1; Wed, 08 Jul 2020 06:03:42 -0400
X-MC-Unique: _viBK7_7N-a_wmTcAdINTg-1
Received: by mail-wr1-f72.google.com with SMTP id j16so46146826wrw.3
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 03:03:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ss9qJI2p1V/pw0FYJQ0mqsrCEJLHA4WfDlP5Y0PS6OI=;
        b=r6rGPFe+UTeG++4UlKlDWf6j2iPyr2TzUgMDN2XTv9khG1sJRCynugeb3+P7+U2RY6
         LOYwDl28UpIU3RHOPV2T2BoMJL54rfnR3ZrWqx9d5WAkD+RZc6R17V/D0lYDFqAmolzx
         ypbE/TBmHCktdt/e8I93KQLV+yWxzLwa8L565lfjySd+r9A0XH1GDXbHd3HGioLbmQf5
         ma85YUEcICT5mQXMsxSf1yjfLH9FchdAtN6JPgXHV0Ir4Fp/ne4glaPsbq4HmXSiTo9w
         DtIZLMs7GQp52dfhZVXXj18g9asrg2GZR4n4hZHrr/I7NZNNo50d5n7RMXf9KcHB+yCP
         +XcA==
X-Gm-Message-State: AOAM530RlPhmKvOI/B/1Ax2AY2k3qrVPHmm4H8ilWM7VbjBTMZaMR37X
        CptQzlZFHRIhpXyRFv/jz+WbglOj+8mj9Ly7aWQhztMaMy2HxhoF5CiW7lzxD4rZXGJZLgkvrcT
        AzBUgAq0T99s0
X-Received: by 2002:a7b:c394:: with SMTP id s20mr8972737wmj.31.1594202620755;
        Wed, 08 Jul 2020 03:03:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwFcLIb9RtyG4T93864hU8kWCUGyznaC5YGHlyxZABGmPDTAq4KMsLd5hZj8zjvZuWJZ2odYA==
X-Received: by 2002:a7b:c394:: with SMTP id s20mr8972722wmj.31.1594202620548;
        Wed, 08 Jul 2020 03:03:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id 1sm5116787wmf.21.2020.07.08.03.03.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 03:03:39 -0700 (PDT)
Subject: Re: [PATCH 2/3 v4] KVM: nSVM: Check that MBZ bits in CR3 and CR4 are
 not set on vmrun of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
References: <1594168797-29444-1-git-send-email-krish.sadhukhan@oracle.com>
 <1594168797-29444-3-git-send-email-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <699b4ea4-d8df-e098-8f5c-3abe8e4c138c@redhat.com>
Date:   Wed, 8 Jul 2020 12:03:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1594168797-29444-3-git-send-email-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/07/20 02:39, Krish Sadhukhan wrote:
> +extern int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
> +

This should be added in x86.h, not here.

> +static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb)
>  {
>  	if ((vmcb->save.efer & EFER_SVME) == 0)
>  		return false;
> @@ -231,6 +233,22 @@ static bool nested_vmcb_checks(struct vmcb *vmcb)
>  	    (vmcb->save.cr0 & X86_CR0_NW))
>  		return false;
>  
> +	if (!is_long_mode(&(svm->vcpu))) {
> +		if (vmcb->save.cr4 & X86_CR4_PAE) {
> +			if (vmcb->save.cr3 & MSR_CR3_LEGACY_PAE_RESERVED_MASK)
> +				return false;
> +		} else {
> +			if (vmcb->save.cr3 & MSR_CR3_LEGACY_RESERVED_MASK)
> +				return false;
> +		}
> +	} else {
> +		if ((vmcb->save.cr4 & X86_CR4_PAE) &&
> +		    (vmcb->save.cr3 & MSR_CR3_LONG_RESERVED_MASK))
> +			return false;
> +	}

is_long_mode here is wrong, as it refers to the host.

You need to do something like this:

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 385461496cf5..cbbab83f19cc 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -222,8 +222,9 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 	return true;
 }
 
-static bool nested_vmcb_checks(struct vmcb *vmcb)
+static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb)
 {
+	bool nested_vmcb_lma;
 	if ((vmcb->save.efer & EFER_SVME) == 0)
 		return false;
 
@@ -234,6 +237,27 @@ static bool nested_vmcb_checks(struct vmcb *vmcb)
 	if (!kvm_dr6_valid(vmcb->save.dr6) || !kvm_dr7_valid(vmcb->save.dr7))
 		return false;
 
+	nested_vmcb_lma = 
+	        (vmcb->save.efer & EFER_LME) &&
+                (vmcb->save.cr0 & X86_CR0_PG);
+
+	if (!nested_vmcb_lma) {
+		if (vmcb->save.cr4 & X86_CR4_PAE) {
+			if (vmcb->save.cr3 & MSR_CR3_LEGACY_PAE_RESERVED_MASK)
+				return false;
+		} else {
+			if (vmcb->save.cr3 & MSR_CR3_LEGACY_RESERVED_MASK)
+				return false;
+		}
+	} else {
+		if (!(vmcb->save.cr4 & X86_CR4_PAE) ||
+		    !(vmcb->save.cr0 & X86_CR0_PE) ||
+		    (vmcb->save.cr3 & MSR_CR3_LONG_RESERVED_MASK))
+			return false;
+	}
+	if (kvm_valid_cr4(&(svm->vcpu), vmcb->save.cr4))
+		return false;
+
 	return nested_vmcb_check_controls(&vmcb->control);
 }
 
which also takes care of other CR0/CR4 checks in the APM.

I'll test this a bit more and queue it.  Are you also going to add
more checks in svm_set_nested_state?

Paolo

