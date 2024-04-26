Return-Path: <kvm+bounces-16066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D38D8B3D9F
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 19:09:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D8A121F21BFC
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 17:09:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A94015B974;
	Fri, 26 Apr 2024 17:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uYmLCNzX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC561DA58
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 17:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714151341; cv=none; b=Zlfqltacl5Dk1idmOuBT4YMxIgOel6bm70uNeiZ9o0c2YYCPRwzRrww2N+bXW08Fv7cMwAGtsioyv+4NpQGC+ESuadkTai1rckzgF05hARpEMYzoeM8u/NlhKbBR8/TdjzqWWEtfPQYloYfj2igfX4ofQJIU9o9iVFC1QWOw+T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714151341; c=relaxed/simple;
	bh=/u+/VUHRstaeZlxjhr9IFqEbnV2hgYn2kTvggjqqTRc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gUiSYOUqtuZPRpXoHTnVGzn7ujx0hCrKL0lQT90y8KTrofA/mQSnfeFuYkuZeWBNXZEKiClDHui0UtFJO5bv163KXxuapGa+psFvlHqkItsrtxDBEAKATtrYiBPx5RpmxY+mC7o2SS1d9+ALLLDnKHt2+Zz0JRVo7nkn1Kt2a5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uYmLCNzX; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1e8fc91661fso23762055ad.1
        for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 10:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714151339; x=1714756139; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J0ICtEdh31VCqgmnJdIJar3kOHqlyDRMqt7YndTJd5M=;
        b=uYmLCNzXz7jBQBVK1opEhoIoSZX3z7jYkK9tW+bh/PH4qLIkXBidYzK4e8b1ldVKH3
         Cp0BJgR4Yc5n9zKhDftnOLgn6lxIymyuxHPCv0QSGtUbSSnwBMLlntSil8tinVzCkW4j
         DgMHbq/zX6fSmvdYN3jUy/hRTyWmODLtB4t9u3OPbpO7kYdoOd7oMtCbkocamIq0tA4+
         lVBTmtNCPWCaoEmNJX+mK/7i3Amg6iLxjVdsV9ZeTjUX2vVjOdbZJK3VoJ98mrukWqrW
         QIo8A8LmBlpZGcwc/YgmAVM2GujEs4luVNCbWNNyBCUxnCvISfjMj8LXrYBMr1DrwihA
         ygxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714151339; x=1714756139;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J0ICtEdh31VCqgmnJdIJar3kOHqlyDRMqt7YndTJd5M=;
        b=sk/shAMmUMuzPQQGs/D/DrKk73aUAFxOVQBO30XA33mCDi12lxmueKdxNFoRKE0x4p
         OyniPRY/FSYL05ekx5ZkLDvTuQaHf66IWYm5FZo9hkNdl8Jb7aDmjH68bPxAz0Mf6dwy
         C/SayvUkn+rwLEROwEkvVGANes0yrIWUzEw1VZJD9/CcjiBQKYmfvaXStyVYHDoE4Cpc
         UXgnTN/Gx06TCKXFKXZ96/PA1cn7A/BgwarJhcF3py0uOxJE2O022NGFM4lLbcdK0mMI
         0VqMmrultkamxMIWT9N5OQdkz1RpAAI1lGET1IEZELhE4pi/rWIUbj9oXJyNtK9HCa4l
         f5vg==
X-Forwarded-Encrypted: i=1; AJvYcCWF4KaPdGuYXoMa5bTLBMBgRslpwFJjX+8+3TzJBpCTfFD2v0/nqiZhIqRbdx3uXw5OMZhXm7YjVdw4k07wO7+uKC3x
X-Gm-Message-State: AOJu0YyETihzAmR0h9aDOQdbToOYFO+kRly9duS/SDxAYioyqf/ax7a0
	QmaN8q62PG/5LvCExqu3PHG4j6GbXmqaRLc+k+7Q4WzTAjNEWsEH/wFtaBt9kWMWJb1r8vwD/Su
	Elg==
X-Google-Smtp-Source: AGHT+IGN4vuhhXu6RHaKsQDssSGbwGUwHoIe3QpHFtYc97Yq/BzD4QZntnxHirq8V1PdJAs18Y57hXAU0Tg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4cd:b0:1e4:7bf1:52b with SMTP id
 o13-20020a170902d4cd00b001e47bf1052bmr697plg.7.1714151339477; Fri, 26 Apr
 2024 10:08:59 -0700 (PDT)
Date: Fri, 26 Apr 2024 10:08:57 -0700
In-Reply-To: <ZitrMAplXSCKrypD@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240425233951.3344485-1-seanjc@google.com> <20240425233951.3344485-3-seanjc@google.com>
 <ZitrMAplXSCKrypD@chao-email>
Message-ID: <ZivfqQysu2hXHHFG@google.com>
Subject: Re: [PATCH 2/4] KVM: x86: Register emergency virt callback in common
 code, via kvm_x86_ops
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 26, 2024, Chao Gao wrote:
> >diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> >index 502704596c83..afddfe3747dd 100644
> >--- a/arch/x86/kvm/vmx/x86_ops.h
> >+++ b/arch/x86/kvm/vmx/x86_ops.h
> >@@ -15,6 +15,7 @@ void vmx_hardware_unsetup(void);
> > int vmx_check_processor_compat(void);
> > int vmx_hardware_enable(void);
> > void vmx_hardware_disable(void);
> >+void vmx_emergency_disable(void);
> > int vmx_vm_init(struct kvm *kvm);
> > void vmx_vm_destroy(struct kvm *kvm);
> > int vmx_vcpu_precreate(struct kvm *kvm);
> >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >index e9ef1fa4b90b..12e88aa2cca2 100644
> >--- a/arch/x86/kvm/x86.c
> >+++ b/arch/x86/kvm/x86.c
> >@@ -9797,6 +9797,8 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
> > 
> > 	kvm_ops_update(ops);
> > 
> >+	cpu_emergency_register_virt_callback(kvm_x86_ops.emergency_disable);
> >+
> 
> vmx_emergency_disable() accesses loaded_vmcss_on_cpu but now it may be called
> before loaded_vmcss_on_cpu is initialized. This may be not a problem for now
> given the check for X86_CR4_VMXE  in vmx_emergency_disable(). But relying on
> that check is fragile. I think it is better to apply the patch below from Isaku
> before this patch.
> 
> https://lore.kernel.org/kvm/c1b7f0e5c2476f9f565acda5c1e746b8d181499b.1708933498.git.isaku.yamahata@intel.com/

Agreed, good eyeballs, and thanks for the reviews!

