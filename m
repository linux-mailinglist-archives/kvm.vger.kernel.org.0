Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22F1D9AB6A
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 11:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732692AbfHWJed (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 05:34:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40572 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730512AbfHWJec (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 05:34:32 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1437D2D0FCE
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 09:34:32 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id b135so2782124wmg.1
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 02:34:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=QreUaGjv9CTkutPAtfkHcI/YdY++8wYqEFh96/UbB4c=;
        b=fK8SL92fl8HXRW00H7KFBz/700UIhbDo7NDc/pZbipn9K/kCj8ebCnZ0KsnevQ7Z/z
         gzFgZeko6BIfneQoShYiK1jYIzu3fhC94C5Lt7tZjFB0IZ0pN/39kTYTn5iznStuGnpq
         TzRLtvAq0Omy34dR4mX1gnQZ6yY5yDum1w/JtICslekTfuz7P9qhQAJiBu6j9eRxNG1B
         mAwIwvV0hSiMri6nbo+I2OsxZ2M1Gs9OWLODi5Is/teB71+jdQLbD3stwSuQvBqjq2BJ
         RQYlo582w0VwvFEiuoBOulFiK0olURLC90jk3FKXDoDZXuvTHe372MEYNdHFFs+sF6Jt
         aM7A==
X-Gm-Message-State: APjAAAUOlE+utkgEA8FJ/hbIVs59sqOJEuIh/69Sfhrp9kCgLlzg1ApS
        jLaKVhzrVvr1hbqUTS8Io3Z9jdotw0COTfIjiM5AMTnXLjqwjeafdvYr6Hn28OhQIyf2BrbecB0
        KX9bY8uTqSJ1A
X-Received: by 2002:a05:600c:292:: with SMTP id 18mr4128441wmk.51.1566552870725;
        Fri, 23 Aug 2019 02:34:30 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz9X5S2AQSieJq5ssRPSF/b6ABaYvBQm4IqoXFqGxuS8qwxVjSSbMAiXqZKkrNBEM0ZG35lMQ==
X-Received: by 2002:a05:600c:292:: with SMTP id 18mr4128410wmk.51.1566552870478;
        Fri, 23 Aug 2019 02:34:30 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id o8sm5085455wma.1.2019.08.23.02.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2019 02:34:29 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [RESEND PATCH 04/13] KVM: x86: Drop EMULTYPE_NO_UD_ON_FAIL as a standalone type
In-Reply-To: <20190823010709.24879-5-sean.j.christopherson@intel.com>
References: <20190823010709.24879-1-sean.j.christopherson@intel.com> <20190823010709.24879-5-sean.j.christopherson@intel.com>
Date:   Fri, 23 Aug 2019 11:34:29 +0200
Message-ID: <874l28p6my.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> The "no #UD on fail" is used only in the VMWare case, and for the VMWare
> scenario it really means "#GP instead of #UD on fail".  Remove the flag
> in preparation for moving all fault injection into the emulation flow
> itself, which in turn will allow eliminating EMULATE_DONE and company.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 -
>  arch/x86/kvm/svm.c              | 3 +--
>  arch/x86/kvm/vmx/vmx.c          | 3 +--
>  arch/x86/kvm/x86.c              | 2 +-
>  4 files changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 44a5ce57a905..dd6bd9ed0839 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1318,7 +1318,6 @@ enum emulation_result {
>  #define EMULTYPE_TRAP_UD	    (1 << 1)
>  #define EMULTYPE_SKIP		    (1 << 2)
>  #define EMULTYPE_ALLOW_RETRY	    (1 << 3)
> -#define EMULTYPE_NO_UD_ON_FAIL	    (1 << 4)
>  #define EMULTYPE_VMWARE		    (1 << 5)
>  int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
>  int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 1f220a85514f..5a42f9c70014 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -2772,8 +2772,7 @@ static int gp_interception(struct vcpu_svm *svm)
>  
>  	WARN_ON_ONCE(!enable_vmware_backdoor);
>  
> -	er = kvm_emulate_instruction(vcpu,
> -		EMULTYPE_VMWARE | EMULTYPE_NO_UD_ON_FAIL);
> +	er = kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE);
>  	if (er == EMULATE_USER_EXIT)
>  		return 0;
>  	else if (er != EMULATE_DONE)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 18286e5b5983..6ecf773825e2 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4509,8 +4509,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>  
>  	if (!vmx->rmode.vm86_active && is_gp_fault(intr_info)) {
>  		WARN_ON_ONCE(!enable_vmware_backdoor);
> -		er = kvm_emulate_instruction(vcpu,
> -			EMULTYPE_VMWARE | EMULTYPE_NO_UD_ON_FAIL);
> +		er = kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE);
>  		if (er == EMULATE_USER_EXIT)
>  			return 0;
>  		else if (er != EMULATE_DONE)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fe847f8eb947..e0f0e14d8fac 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6210,7 +6210,7 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
>  	++vcpu->stat.insn_emulation_fail;
>  	trace_kvm_emulate_insn_failed(vcpu);
>  
> -	if (emulation_type & EMULTYPE_NO_UD_ON_FAIL)
> +	if (emulation_type & EMULTYPE_VMWARE)
>  		return EMULATE_FAIL;
>  
>  	kvm_queue_exception(vcpu, UD_VECTOR);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly
