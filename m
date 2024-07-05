Return-Path: <kvm+bounces-20976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 54CEA927F93
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 03:14:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF1AD1F227D2
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 01:14:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 848BC101CE;
	Fri,  5 Jul 2024 01:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KIpBx7qT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E832579
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 01:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720142045; cv=none; b=JkP1qKSisWL7Tf1bLj/vD4sDP30RQFSs2TIUYJnHufUVonOCHEYNupANmxHb3FEy0pCHQE+eAvqkO3kppTlwMyY+yScBs5xlrFzgK6T+5NfPQBplJkaG9sBtISGdhlKpHReRoylSWtFZdC1DLz0/N2UGfKq+U8mtOnarn4vtpF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720142045; c=relaxed/simple;
	bh=WSUYdgdvlbIjxgToRT9MdraNcveYiMlnCw77XKrXm/Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qs9n23ep6Y875ZmQrUo6d3PZzD5TaPt9dV05+K2tnSsFv9K8IRaV3HznA6SkgSBfqZmvOnyivFr4nuq2kD4hwtopOgVIrrDwa3WyoZPQ/AVkK+77DwK5pgaE1uj5UqOqQoKSlpvsJC7VMndQn5p/NtjxKoajGoXeL4nmBZ+b1Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KIpBx7qT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720142043;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FI6LHDXh1nqZUQ6s2eQuana3Xv1d8SYwPxqgJWCuIoM=;
	b=KIpBx7qT5Q5+dwXMrV0CeldzTMN8zPzMK1uN6Dz/nnKzyd/GJOGB00zfkrkElpGq40FNNU
	4NMsV6kSZ14zjpvPrnVTeQb2iUEtlX/zBHpZ9TuG7aiyGU763GhZXN0bOA0Sr5zY04RGdE
	joNw3CEKDm3bvyTGgsMmLR9ARCvpTEs=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-2mfZWqNGMqCcNY4XFMD8Pw-1; Thu, 04 Jul 2024 21:14:01 -0400
X-MC-Unique: 2mfZWqNGMqCcNY4XFMD8Pw-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-79d16df6a2bso127574885a.2
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 18:14:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720142041; x=1720746841;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FI6LHDXh1nqZUQ6s2eQuana3Xv1d8SYwPxqgJWCuIoM=;
        b=SGOeopHhPE8hE1GkVRMblUBnDHERwYTYWiLktjQHrKgQ5DR7Sf+4LtRIctBgCxw1/H
         Xp8GpzgUTjARbHZrLd0qrfdfEId8J0rBduu5/qrLF9jbNZJJ/gYhbwoOd9g5IXk8jBus
         wWqiedik62nAIEp5tnvd68G2gfXZiF1CZv1IAl7YZTfJpAhNBJukXD9dFQ2GH/2zGTsF
         FgKcD7gUrCdKrmtydXZl3ADTEAps2sA1fPatKvZUxIWaM64K1W8zowA/D/dYPrgwsXz8
         GSga/zvZYUy5p8nSi+tMRkCbYnhMKDc4sN7ZW6vrxT557Lnnlkq8g3iwcAN26QFYuZlP
         d8Uw==
X-Gm-Message-State: AOJu0YyqxeavlyqCj+B9SsxrZwFQ0JKrLT3mEb6YSZcE0V7myA0Ttlta
	tWnTk/hyKRKZTOzE5PdkMaCF6Tuu7kuh3HDIl77y9B9gYFrLfwutxSjLHAUX3t5hseGi5ygpNEk
	fR911d7JPRrAJ2qxYIYRWYlDD9JMJ1V6xHakfBJSsr8B+s/0aRw==
X-Received: by 2002:a05:620a:2117:b0:79e:f5ea:7e52 with SMTP id af79cd13be357-79ef5ea7fd8mr45391085a.34.1720142041459;
        Thu, 04 Jul 2024 18:14:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH6j4UHorXW0deXy8o9AEiZWLhXPfQZKfnFnVR3eLZS5oVcvb/cg8ctdvtdm12OyduvCzTNbA==
X-Received: by 2002:a05:620a:2117:b0:79e:f5ea:7e52 with SMTP id af79cd13be357-79ef5ea7fd8mr45389285a.34.1720142041086;
        Thu, 04 Jul 2024 18:14:01 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79d6926472asm724712785a.7.2024.07.04.18.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 18:14:00 -0700 (PDT)
Message-ID: <ccbed564392478b3a5bb51b650a102ca474ba7e0.camel@redhat.com>
Subject: Re: [PATCH v2 10/49] KVM: x86: Drop now-redundant MAXPHYADDR and
 GPA rsvd bits from vCPU creation
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 21:13:59 -0400
In-Reply-To: <20240517173926.965351-11-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-11-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-05-17 at 10:38 -0700, Sean Christopherson wrote:
> Drop the manual initialization of maxphyaddr and reserved_gpa_bits during
> vCPU creation now that kvm_arch_vcpu_create() unconditionally invokes
> kvm_vcpu_after_set_cpuid(), which handles all such CPUID caching.
> 
> None of the helpers between the existing code in kvm_arch_vcpu_create()
> and the call to kvm_vcpu_after_set_cpuid() consume maxphyaddr or
> reserved_gpa_bits (though auditing vmx_vcpu_create() and svm_vcpu_create()
> isn't exactly easy).  And even if that weren't the case, KVM _must_
> refresh any affected state during kvm_vcpu_after_set_cpuid(), e.g. to
> correctly handle KVM_SET_CPUID2.  In other words, this can't introduce a
> new bug, only expose an existing bug (of which there don't appear to be
> any).


IMHO the change is not as bulletproof as claimed:

If some code does access the uninitialized state (e.g vcpu->arch.maxphyaddr which
will be zero, I assume), in between these calls, then even though
later the correct CPUID will be set and should override the incorrect state set earlier, 
the problem *is* that the mentioned code will
have to deal with non architecturally possible value (e.g maxphyaddr == 0)
which might cause a bug in it.

Of course such code currently doesn't exist, so it works but
it can fail in the future.

How about we move the call to kvm_vcpu_after_set_cpuid upward? 

Best regards,
	Maxim Levitsky

> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2f6dda723005..bb34891d2f0a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12190,9 +12190,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  		goto free_emulate_ctxt;
>  	}
>  
> -	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
> -	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
> -
>  	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
>  
>  	kvm_async_pf_hash_reset(vcpu);



