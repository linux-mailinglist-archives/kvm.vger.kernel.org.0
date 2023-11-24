Return-Path: <kvm+bounces-2442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A7C07F7890
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 17:07:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 266D228160D
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 16:07:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8896333CDF;
	Fri, 24 Nov 2023 16:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z1OKq279"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52AB12B
	for <kvm@vger.kernel.org>; Fri, 24 Nov 2023 08:07:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700842061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8WiGZAsybGzCzu36x4lL8eXrNHVFYUcQQ91mXJAV7RI=;
	b=Z1OKq279ToEcMOOJ5W51sFHYSXXhUqSTjhebNxlaFR6ba2de2/cijkAWzf2o/mIvvOmTHM
	54C83PFDNmU6JDh45YEsQDHYgc+C8JIyF8uPsGZOLVY5DAouCFV2TfhUGT7+JIpLIEBUsu
	C5NSuqGp27K07RYqCcNWs6vI7/8iMcU=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-310-6mC_K8Y1Np2NjgCStewyBQ-1; Fri, 24 Nov 2023 11:07:39 -0500
X-MC-Unique: 6mC_K8Y1Np2NjgCStewyBQ-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-67a16e9eedbso7692396d6.0
        for <kvm@vger.kernel.org>; Fri, 24 Nov 2023 08:07:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700842059; x=1701446859;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8WiGZAsybGzCzu36x4lL8eXrNHVFYUcQQ91mXJAV7RI=;
        b=KVyFQ03+OAUUNDnquvzERJg5rI6U9Xth89WLlUXOgi6+jnHXU60hITMHcmOIdv9pe4
         QZ/L6kOMWOvyvuS66N9cgXYYhYyHFn2LZzGr57qgwIfps/1+GZmxb+/Xs0xcgXHM/DKY
         uIyghXFC/EcaKwjJjQkZn9+vFkx9Tl/WFpfEazNndNtF5UEQh6PQQVDzG8hHD7oL6hDT
         xeAzLMnInStv8t3FCj2vZdmBcwpezs8gNb/5hx6oDVskynRLe+nz8cIAuW3yRzdGoYWD
         FbE6/FUj2EX6gsdGJ2yXSge/RlSlzHX3qK+UQjGoo1Z8WKC97SbS9lBQJWq3JTOKfNuz
         ba+g==
X-Gm-Message-State: AOJu0YyUmNOPSR0px6swHQ6EZXVXuWUGqlkIX1KSXvPQP8wt/b1yp+4b
	9a/mgSxq1GzpwahIzryqCiFv6y7yx4kQA/+yF2gGnqhCKbHiEmtSI/ChTRxtoOu6IzAzc2VzlQn
	gD40iMisseCgk
X-Received: by 2002:a05:6214:419b:b0:66d:1100:7b81 with SMTP id ld27-20020a056214419b00b0066d11007b81mr4630217qvb.18.1700842059471;
        Fri, 24 Nov 2023 08:07:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGoEGtM0E8HfCBi2iR3GLxfUKzyZLwKwRYwCmX/US+5L/fv1k0GQdeDYkir4tHFRBVRom7dFg==
X-Received: by 2002:a05:6214:419b:b0:66d:1100:7b81 with SMTP id ld27-20020a056214419b00b0066d11007b81mr4630191qvb.18.1700842059230;
        Fri, 24 Nov 2023 08:07:39 -0800 (PST)
Received: from [10.32.181.74] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id p15-20020ad451cf000000b0067a1cf7737bsm333015qvq.130.2023.11.24.08.07.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Nov 2023 08:07:38 -0800 (PST)
Message-ID: <0c626505-a358-4d13-99e3-144356d136b3@redhat.com>
Date: Fri, 24 Nov 2023 17:07:36 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] KVM: x86: refactor req_immediate_exit logic
Content-Language: en-US
To: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
 Sean Christopherson <seanjc@google.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
 x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>
References: <20230928103640.78453-1-mlevitsk@redhat.com>
 <20230928103640.78453-2-mlevitsk@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20230928103640.78453-2-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/28/23 12:36, Maxim Levitsky wrote:
> @@ -4176,6 +4176,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>   	clgi();
>   	kvm_load_guest_xsave_state(vcpu);
>   
> +	if (vcpu->arch.req_immediate_exit)
> +		smp_send_reschedule(vcpu->cpu);
> +

This code is in a non-standard situation where IF=1 but interrupts are
effectively disabled.  Better something like:

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index beea99c8e8e0..3b945de2d880 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4148,8 +4148,11 @@ static __no_kcsan fastpath_t svm_vcpu_run(
  		 * is enough to force an immediate vmexit.
  		 */
  		disable_nmi_singlestep(svm);
+		vcpu->arch.req_immediate_exit = true;
+	}
+
+	if (vcpu->arch.req_immediate_exit)
  		smp_send_reschedule(vcpu->cpu);
-	}

  	pre_svm_run(vcpu);


Paolo


