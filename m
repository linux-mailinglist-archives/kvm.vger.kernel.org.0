Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 972151705C6
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 18:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgBZRNm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 12:13:42 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48590 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726614AbgBZRNm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Feb 2020 12:13:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582737221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fqZFM5WybXIvQpsE6lMDlBCaWfGorF8koi4lLfvGmOg=;
        b=QmlbHnqcdK3Lh//aa9gjsmhf1AvXFlsT0vRJ488uLLcZ2wlHbpw5u6G5JE7tugTzROcm53
        0GrUybuHplFnxNasTvfHAzZIw7ThQ8ECFx1JJvZU4p2MkvLGP/dJn3ih43flnCzTP+pL2B
        6lOFDygGd1Hk0Y49/ONmPbkwCsHQV9Y=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-zhx-PmYlOiCdcXfO_WV4ZA-1; Wed, 26 Feb 2020 12:13:39 -0500
X-MC-Unique: zhx-PmYlOiCdcXfO_WV4ZA-1
Received: by mail-wr1-f70.google.com with SMTP id o9so36076wrw.14
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 09:13:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=fqZFM5WybXIvQpsE6lMDlBCaWfGorF8koi4lLfvGmOg=;
        b=oe6rfJiyjFSS+ynz3hUWAczWkQuVtslRYQW4hdeLuqxC/xs5d+oj6u/0QG6gqBw4zD
         qjg69mrl2HdTtW1cWqb5wos6x8i4hGGmB3kMEEgQNM2Ypac2iJshSsqfqBakLwHanhFj
         ZG2T3C3OZocZwYwGOTYIMiiGGJbckGMWLLUPjDeNBmdpzoXb0VTvkwGN2NTsvTF+BRbs
         z1dLI7G1aTJc8dPjh9nvwk3HcPoTMcmNg8ppLqeG4kf+GrOkGmdwP7lJdHZGwfe+QkJ9
         kFzfL9i3ahtZRdv+ty81LQStDCxq0PG6KupjwN1MFS9XLMc+ziI1Vvmp2rQNVMX4g9uC
         cT4g==
X-Gm-Message-State: APjAAAVZzFVnb/5eyGttPeuH4NqW4VmAYKFgUqT94FWf2dKeVqJsRrxN
        GkRO/AMPfqpDHmS2xBkl8vvfQe8QLBVcUqPw0ZOfQaTvWTrC81fRXVlV8LteKgihEb3w/AKq6R6
        FqYtBcQXtlisn
X-Received: by 2002:adf:80cb:: with SMTP id 69mr6274379wrl.320.1582737218631;
        Wed, 26 Feb 2020 09:13:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqxdQ3flDUJS3yOciIAFWcmCDmYkKBelGFeV/kFIBn5FjKHz6HuPhGD9HWhgO281p32eDfwCNA==
X-Received: by 2002:adf:80cb:: with SMTP id 69mr6274361wrl.320.1582737218383;
        Wed, 26 Feb 2020 09:13:38 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id x12sm3765817wmc.20.2020.02.26.09.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 09:13:37 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/13] KVM: x86: Refactor init_emulate_ctxt() to explicitly take context
In-Reply-To: <20200218232953.5724-8-sean.j.christopherson@intel.com>
References: <20200218232953.5724-1-sean.j.christopherson@intel.com> <20200218232953.5724-8-sean.j.christopherson@intel.com>
Date:   Wed, 26 Feb 2020 18:13:37 +0100
Message-ID: <87zhd5i85a.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Explicitly pass the emulation context when initializing said context in
> preparation of dynamically allocation the emulation context.

"The said said context" :-)

>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/x86.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 69d3dd64d90c..0e67f90db9a6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6414,9 +6414,9 @@ static bool inject_emulated_exception(struct x86_emulate_ctxt *ctxt)
>  	return false;
>  }
>  
> -static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
> +static void init_emulate_ctxt(struct x86_emulate_ctxt *ctxt)
>  {
> -	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
> +	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
>  	int cs_db, cs_l;
>  
>  	kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
> @@ -6443,7 +6443,7 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
>  	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
>  	int ret;
>  
> -	init_emulate_ctxt(vcpu);
> +	init_emulate_ctxt(ctxt);
>  
>  	ctxt->op_bytes = 2;
>  	ctxt->ad_bytes = 2;
> @@ -6770,7 +6770,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	kvm_clear_exception_queue(vcpu);
>  
>  	if (!(emulation_type & EMULTYPE_NO_DECODE)) {
> -		init_emulate_ctxt(vcpu);
> +		init_emulate_ctxt(ctxt);
>  
>  		/*
>  		 * We will reenter on the same instruction since
> @@ -8943,7 +8943,7 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
>  	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
>  	int ret;
>  
> -	init_emulate_ctxt(vcpu);
> +	init_emulate_ctxt(ctxt);
>  
>  	ret = emulator_task_switch(ctxt, tss_selector, idt_index, reason,
>  				   has_error_code, error_code);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

