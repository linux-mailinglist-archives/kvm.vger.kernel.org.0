Return-Path: <kvm+bounces-40119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1608CA4F510
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 04:04:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C82493AA043
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 03:03:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11FB51624D9;
	Wed,  5 Mar 2025 03:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c2yQUPNY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A7C469D
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 03:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741143838; cv=none; b=gFJUswDdqJYYzdZ/3YkAKEkJa2ybEeO4c0r5fNQwbKW1sGzX8FyKM/8JILMGuyVohuqgDsrmHY+n58KaH/K/tgK62XGvE1kiNnUigYYcZF7g5TRmRfaa+EOWRQ+DSoLGMbvbvL1XfWcW7TUZTlngqCx4fiZ8vUdEojk4DAduBAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741143838; c=relaxed/simple;
	bh=nn+0y2kYcsUE/C0FdPuZ6kFtGinNmIXAccAqcDhO/FY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gwP8U9gnyT5uktbOUWzYxdd6cLMBEM96BLEKRc7MgWNL4vFBeba5F2CSyZa1yyU6v8o7YWoWJlApEiuiUrlUbuMJOjp0ow8wcWckwZsF2HF6MZw+BzxrdvT97Uck2uO4OpW/1VaJ/q7KrGR/beh8uHN5xMebyERcOVd31vsEMgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c2yQUPNY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741143834;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CGRi7Z3LudnEjtGohkS2VoNjpmTFQ+f/IeaFzIY/u9Y=;
	b=c2yQUPNYrsAUjgIxEKeSrAgs+zGx2ICqEmrvroKKAwtDp6NBbSiaFOP529wjwom58fluXV
	hqmj8qPv7QfRXlsUykP1cWbRuKkbGuQfcffIiYuW6uYWGhhGCLEfLKaNv2q4N3kJ+zJFF1
	CbScDJwExVUux6NsjbcOD/LOTLRU6vY=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-kgv3zqUhNPmTqZpoqOR3BA-1; Tue, 04 Mar 2025 22:03:53 -0500
X-MC-Unique: kgv3zqUhNPmTqZpoqOR3BA-1
X-Mimecast-MFC-AGG-ID: kgv3zqUhNPmTqZpoqOR3BA_1741143832
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6e8c8641ad6so70244186d6.3
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 19:03:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741143832; x=1741748632;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CGRi7Z3LudnEjtGohkS2VoNjpmTFQ+f/IeaFzIY/u9Y=;
        b=euwVUo5ArG0lbr/0Q6kYnE0x0rajloq/pPSBNk/zawGELyixZIEYyBFYjpk3xbWEuK
         CBcC5u5FObVvC7i+aOkeZy8ombel05oimXhBjo+cO4DUX6dmAo306G6sHSSUJOmT89jT
         pZklXwaZ7zq9kfKWvIgyEhSsELcDb+WEo7WPvdzJlDeOR8EG00C8XwkqbGeHjpWZyWP2
         WOYbhUbQYR/AtOZwXfKl/QvT8n8mGst8JXbi0SUx4+VZjfcOuormV5BegxbV7+Wi8S/3
         WUaQfdHOUmMgCX4nxgQezwhcLQ7MnHt55sdOLjqNAGVQB2zCyLuZGEdqPJ3gQDR+z6JL
         k7vw==
X-Forwarded-Encrypted: i=1; AJvYcCWnaAYhJArJ86dvzfeCY7GZr++nhzlwdjQtIwlBoVFEznuMMz1wrL0AAQUefesXk1gnOCM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOstN3MygknkLjGGL3nZ8R0Z7d2pFm700/O6deDDpL9hEis8K1
	q135hIMlSdWysjrbDrPI2dmi2kTNw/sYyBEMCmcbizLqzpm01xtS2SQuJISv5NQLEXCx2IlpBlN
	hSvpham/yG3OJgH4v+p4b/MaXSBVlsYnpPFcKFADnnG4cwxxo9w==
X-Gm-Gg: ASbGncuhPgBuLny0Ru8HuKDqcmjhR+R120bHV4IjYMxUl/d+qadGV6+XuD0V5AFDcgi
	GItDY+HMQ2Blu0CRVFQS1aOYJE8FaMmOqUG17BMOmHQhLKPVY8E6kcN+Qasg41NI9R8/jpdWplL
	AyFkSqVb8PvkTAe5TI8J8vkNcZ1W2i6C0zPAjcD2Q5DpuKonxSMx84J1R1sWyk4dVBv7vAirf/w
	2ZqAP5HMwdTKGFf8j92JtHbBuTh88EI7ZIYoDBvwoY4MuOuB880coonvsJfh0L0i3lE+cyIVdj8
	5YYweU5YYvr4htM=
X-Received: by 2002:a05:6214:e47:b0:6e8:9394:cbbe with SMTP id 6a1803df08f44-6e8e6cfd54cmr27116356d6.20.1741143832609;
        Tue, 04 Mar 2025 19:03:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHbY725G3hV7UZl92cHpkhctuxiwjmRdm8JwvoGf1/DihEMV7V2E/2IiLMuI6rWwQ0Zrg6quA==
X-Received: by 2002:a05:6214:e47:b0:6e8:9394:cbbe with SMTP id 6a1803df08f44-6e8e6cfd54cmr27116096d6.20.1741143832269;
        Tue, 04 Mar 2025 19:03:52 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e8976da230sm74065666d6.112.2025.03.04.19.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 19:03:51 -0800 (PST)
Message-ID: <d070c0c136bd05a68492e81077303603deefb9af.camel@redhat.com>
Subject: Re: [RFC PATCH 12/13] KVM: nSVM: Service local TLB flushes before
 nested transitions
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 04 Mar 2025 22:03:51 -0500
In-Reply-To: <Z8Yq00wc_9_NRRkZ@google.com>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
	 <20250205182402.2147495-13-yosry.ahmed@linux.dev>
	 <540397690642d3aa7e77775a721ba5a62bbdc2ae.camel@redhat.com>
	 <Z8Yq00wc_9_NRRkZ@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2025-03-03 at 22:18 +0000, Yosry Ahmed wrote:
> On Fri, Feb 28, 2025 at 09:20:18PM -0500, Maxim Levitsky wrote:
> > On Wed, 2025-02-05 at 18:24 +0000, Yosry Ahmed wrote:
> > > KVM does not track TLB flush requests for L1 vs. L2. Hence, service
> > > local flush that target the current context before switching to a new
> > > one. Since ASIDs are tracked per-VMCB, service the flushes before every
> > > VMCB switch.
> > > 
> > > This is conceptually similar to how nVMX calls
> > > kvm_service_local_tlb_flush_requests() in
> > > nested_vmx_enter_non_root_mode() and nested_vmx_vmexit(), with the
> > > following differences:
> > > 
> > > 1. nVMX tracks the current VPID based on is_guest_mode(), so local TLB
> > >    flushes are serviced before enter_guest_mode() and
> > >    leave_guest_mode(). On the other hand, nSVM tracks the current ASID
> > >    based on the current VMCB, so the TLB flushes are serviced before an
> > >    VMCB switch.
> > > 
> > > 2. nVMX only enters and leaves guest mode in
> > >    nested_vmx_enter_non_root_mode() and nested_vmx_vmexit(). Other paths
> > >    like vmx_set_nested_state() and vmx_leave_nested() call into these
> > >    two functions. On the other hand, nSVM open codes the switch in
> > >    functions like svm_set_nested_state() and svm_leave_nested(), so
> > >    servicing the flush in svm_switch_svm() is probably most reliable.
> > > 
> > > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > ---
> > >  arch/x86/kvm/svm/svm.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > > 
> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > index 5e7b1c9bfa605..6daa7efa9262b 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -1421,6 +1421,12 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > >  
> > >  void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb)
> > >  {
> > > +	/*
> > > +	 * ASIDs are tracked per-VMCB. Perform any pending TLB flushes for the
> > > +	 * current VMCB before switching to a new one.
> > > +	 */
> > > +	kvm_service_local_tlb_flush_requests(&svm->vcpu);
> > > +
> > >  	svm->current_vmcb = target_vmcb;
> > >  	svm->vmcb = target_vmcb->ptr;
> > >  }
> > 
> > Note that another difference between SVM and VMX is that this code will only set tlb_ctl
> > in the current vmcb, the actual flush can happen much later, when we do VM entry with this vmcb,
> > e.g if we are now in L2, the flush will happen when we enter L2 again.
> 
> Right, but I think the internal implementation of the TLB flushes is not
> relevant in this specific instance. Do you think it would be useful to
> mention that here?

I am not sure to be honest, I just mentioned this because in theory there can be a difference,
in regard to the fact that we might think that we flushed the TLB while in fact we haven't yet.

I am trying my best to think about what hidden problems might lurk around and surface later.

Not directly related to the above, but I am thinking:
I really like the way SVM flush works because it ensures that redundant flushes don't cost anything.

I wonder if we can make VMX code emulate this,
by having an emulated 'tlb_control' field and then doing the flush (INVEPT) on VM entry.


Best regards,
	Maxim Levitsky

> 
> If we were to document the difference in TLB flush handling between VMX
> and SVM I think a better place would be at kvm_vcpu_flush_tlb_*(), or
> maybe in kvm_host.h where the vendor callbacks are defined? Not sure.
> 
> > I think that this is correct but I might be mistaken.
> > 
> > Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> Thanks!
> 



