Return-Path: <kvm+bounces-28425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 14ACD99871E
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 15:07:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C6D628188B
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 13:07:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50AF91C9B93;
	Thu, 10 Oct 2024 13:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ebY+oF0G"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015231C7B78
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 13:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728565623; cv=none; b=UrNL/XIRpvGvnLdoaK9TMQsgUZ+nQVJ5KNK/gmmSt/GLZARR+8w68xeUQHpQGd1GKyBwIlRUGwqLf8qFzb3OJ0NRtvSq++/lHEi4nKuFNfLb3+GbZ8Gy/ZDRY5VvkyqJqPfXtPMsFNrSBzpBC8J0ZIfveDqKUi7ty5jCMNvaK0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728565623; c=relaxed/simple;
	bh=HTl9HFpdB2/qe9PUDd7JdAXui/SzZDH+2S6ISMBA44w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KDz7fW1A6mD6ngPg49L81tbPu35slHz5dGyjhhwgkhYvjpvtG4Xfn2YsMxocI4r7ZgNzOGgi82VQqx2s5sHuP87NzuINUH6LhR55co11giBxoggO3aBnCAOp7ev34VgJBnJoVWUawhwZ77sTzkR49HRdZTXbWG0YVWTDWdOlw0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ebY+oF0G; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728565620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3S+oamyBTgQALvkkGGJvlMZ/KB7mDQf9V7pRgoE4S2Q=;
	b=ebY+oF0GrvY+vWtjuxsg9q+oVip3vyfzArvfFEuHd9srzRBKTw7X9T1R/mgHmQYdsoplDw
	Gpu1DQWSpSgQqlul99rzZT/xFN+WS8b7ERERjD2rC/UsEgYeDINbZySixfUfMH8X/EOKKf
	oR6uUfYx0RgfDMTBjgcLkTI4C+BqVQE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-RG8XvjvDNY2crALeT3k93Q-1; Thu, 10 Oct 2024 09:06:59 -0400
X-MC-Unique: RG8XvjvDNY2crALeT3k93Q-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a994dfbb8b9so71297166b.3
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 06:06:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728565618; x=1729170418;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3S+oamyBTgQALvkkGGJvlMZ/KB7mDQf9V7pRgoE4S2Q=;
        b=luXmIwg8Cn2XmkTIGV79Iz8zDvOxtDAoZyPhGMdeiPnOBvGWsl2/uhNyneiAAdwlBj
         As7eeoOr4//Sli+L6HKsfOB+FaPw8vanVyzpXwQiFsVsI3xnr5DqW2OPF8bivaxz7JIe
         Qg0q7sWFiYzFKAB5hyJJISutNerUtRiwuX9uGzptSTV1hFHfhYzOcBMcjeVVce8ZK2QD
         204DGfkjtYs9C1prr5IbHQPZzYlJhCCwRgR+8aVEUPZyU1CS7tZ1unjqmjf7QHDp2YMQ
         mvtocR02HNSA1K5icyZG+bOUjlOguAH3UIu0ZKVJOtD1AMCNjIAgdAhaZrQs6qCdF36e
         cZew==
X-Gm-Message-State: AOJu0YxcuTBXXVqWsA12N+VkvxMap6ygcGj9340CXaWcDdODpeIkHDIO
	WBciNtLIeKNNPf7XrP44j1tfvsWCn45kJoe3H3s/ba6Bs9RosujeRQ3Klv9oawP4q52e0E6nI57
	kXU/abDmxtiLckjr1Tun5cojvPsZ4VBDsPYNfSXxBd6IJz930nw==
X-Received: by 2002:a17:906:6a18:b0:a99:60da:9de0 with SMTP id a640c23a62f3a-a998d10e578mr618955266b.6.1728565618241;
        Thu, 10 Oct 2024 06:06:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGSubTy4g+6wssGJNWcbSS2UjbdGvWhuJrPmXEkhU6Di11h5GbfFkqgtAPEzoqIEZuRrMGUaw==
X-Received: by 2002:a17:906:6a18:b0:a99:60da:9de0 with SMTP id a640c23a62f3a-a998d10e578mr618951166b.6.1728565617799;
        Thu, 10 Oct 2024 06:06:57 -0700 (PDT)
Received: from [192.168.10.81] ([151.81.124.37])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a99a80f245csm85668666b.212.2024.10.10.06.06.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 06:06:57 -0700 (PDT)
Message-ID: <dade78b3-81b1-45fb-8833-479f508313ac@redhat.com>
Date: Thu, 10 Oct 2024 15:06:56 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/4] KVM: x86: Fix and harden reg caching from !TASK
 context
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Maxim Levitsky <mlevitsk@redhat.com>
References: <20241009175002.1118178-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20241009175002.1118178-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/24 19:49, Sean Christopherson wrote:
> Fix a (VMX only) bug reported by Maxim where KVM caches a stale SS.AR_BYTES
> when involuntary preemption schedules out a vCPU during vmx_vcpu_rest(), and
> ultimately clobbers the VMCS's SS.AR_BYTES if userspace does KVM_GET_SREGS
> => KVM_SET_SREGS, i.e. if userspace writes the stale value back into KVM.
> 
> v4, as this is a spiritual successor to Maxim's earlier series.
> 
> Patch 1 fixes the underlying problem by avoiding the cache in kvm_sched_out().

I think we want this one in stable?

Thanks,

Paolo

> Patch 2 fixes vmx_vcpu_reset() to invalidate the cache _after_ writing the
> VMCS, which also fixes the VMCS clobbering bug, but isn't as robust of a fix
> for KVM as a whole, e.g. any other flow that invalidates the cache too "early"
> would be susceptible to the bug, and on its own doesn't allow for the
> hardening in patch 3.
> 
> Patch 3 hardens KVM against using the register caches from !TASK context.
> Except for PMI callbacks, which are tightly bounded, i.e. can't run while
> KVM is modifying segment information, using the register caches from IRQ/NMI
> is unsafe.
> 
> Patch 4 is a tangentially related cleanup.
> 
> v3: https://lore.kernel.org/all/20240725175232.337266-1-mlevitsk@redhat.com
> 
> Maxim Levitsky (1):
>    KVM: VMX: reset the segment cache after segment init in
>      vmx_vcpu_reset()
> 
> Sean Christopherson (3):
>    KVM: x86: Bypass register cache when querying CPL from kvm_sched_out()
>    KVM: x86: Add lockdep-guarded asserts on register cache usage
>    KVM: x86: Use '0' for guest RIP if PMI encounters protected guest
>      state
> 
>   arch/x86/include/asm/kvm-x86-ops.h |  1 +
>   arch/x86/include/asm/kvm_host.h    |  1 +
>   arch/x86/kvm/kvm_cache_regs.h      | 17 +++++++++++++++++
>   arch/x86/kvm/svm/svm.c             |  1 +
>   arch/x86/kvm/vmx/main.c            |  1 +
>   arch/x86/kvm/vmx/vmx.c             | 29 +++++++++++++++++++++--------
>   arch/x86/kvm/vmx/vmx.h             |  1 +
>   arch/x86/kvm/x86.c                 | 15 ++++++++++++++-
>   8 files changed, 57 insertions(+), 9 deletions(-)
> 
> 
> base-commit: 8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b


