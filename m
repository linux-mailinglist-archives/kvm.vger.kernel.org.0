Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA6B303BC1
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 12:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405260AbhAZLgF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 06:36:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20242 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392509AbhAZLf6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 06:35:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611660872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L7832NLMKAy/RcXVz/j+3dnFc5pHVrcqYYEnyyLQrCk=;
        b=PGv7EMswpqfESR75wJf2psn08UHTW4MYh7wrqJqKBAQ3icx+TF5XDWIH9nJXpBqD7ZH8Tu
        SPQlsn2ukMbR+XFrVb8FkXlZ7NmFi5urpu4GogYTDc5YrTa/TAqZ+MPR+fQ9nr82qI752g
        BBFXN6PfcEoE1H0BhRZmL0TdVsNXCKQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-V1G9Xx0nOqKwRUmiCGTe1Q-1; Tue, 26 Jan 2021 06:34:30 -0500
X-MC-Unique: V1G9Xx0nOqKwRUmiCGTe1Q-1
Received: by mail-wr1-f70.google.com with SMTP id r5so6562875wrx.18
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 03:34:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L7832NLMKAy/RcXVz/j+3dnFc5pHVrcqYYEnyyLQrCk=;
        b=a62GS/Pa8Dq7+eqIeYpQDa1C1MyUJMY+5L+fVKjY2m/lt7JF+LzNLdFDE+zYzTU+oS
         5BSBfezUWgl02ejDNssHosIOUoq8qb+QjoopNw0y1Ru3+FNFnD7oPAo8v0X44d2uqltM
         3ItUXzq6BGC8qNTWqdQ7VZyXwcqtI8gTHFDIWDVoOcLnEbvwxGhk+xWouu+uZfP4JQLB
         MKdk6Nzp3SVsPymmxkDgM2EuQMPcVtId/leJDYPOt1DHO0dbj1N/cmuDm8HRs/6qSKF6
         C2Bj0AexlWdJY8E5JOPzoHyE0Xk7spni1roRF55WGIaoSY+To21yefqsJxo2fyZqz8wl
         TYMA==
X-Gm-Message-State: AOAM533Q/rqb+g51FS8KF6fx6DAowZ+c6bA/btzrXczBpfbM3UI/MFsH
        oWq7OvMcASMjr4J33OTPmtE+sY20whpXvAZndgOdUQDB0o4TAJJyRKZNdszEHuFEq5L5HJXfx8R
        rCWwBlSrLklq1
X-Received: by 2002:a1c:4b14:: with SMTP id y20mr4330109wma.6.1611660869224;
        Tue, 26 Jan 2021 03:34:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzI8Y1eI9CBUH+faCKXqBS3/o9NhYMNDfbacHl3bVp1lZ0gf5vw+ea3OLWjCpiHmfDTb0ooPg==
X-Received: by 2002:a1c:4b14:: with SMTP id y20mr4330085wma.6.1611660869070;
        Tue, 26 Jan 2021 03:34:29 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n4sm2474627wrt.47.2021.01.26.03.34.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 03:34:28 -0800 (PST)
Subject: Re: [PATCH v3 2/4] KVM: SVM: Add emulation support for #GP triggered
 by SVM instructions
To:     Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        mlevitsk@redhat.com, seanjc@google.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, luto@amacapital.net
References: <20210126081831.570253-1-wei.huang2@amd.com>
 <20210126081831.570253-3-wei.huang2@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <99e65d54-8d6b-b027-aa34-66e0e30b5e1f@redhat.com>
Date:   Tue, 26 Jan 2021 12:34:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210126081831.570253-3-wei.huang2@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/01/21 09:18, Wei Huang wrote:
> 
> @@ -288,6 +290,9 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>  		if (!(efer & EFER_SVME)) {
>  			svm_leave_nested(svm);
>  			svm_set_gif(svm, true);
> +			/* #GP intercept is still needed in vmware_backdoor */
> +			if (!enable_vmware_backdoor)
> +				clr_exception_intercept(svm, GP_VECTOR);
>  
>  			/*
>  			 * Free the nested guest state, unless we are in SMM.
> @@ -309,6 +314,10 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>  
>  	svm->vmcb->save.efer = efer | EFER_SVME;
>  	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
> +	/* Enable #GP interception for SVM instructions */
> +	if (svm_gp_erratum_intercept)
> +		set_exception_intercept(svm, GP_VECTOR);
> +
>  	return 0;
>  }
>  

This should be in the "if (!(efer & EFER_SVME)) else" branch.  I'll fix 
it up myself.

Paolo

