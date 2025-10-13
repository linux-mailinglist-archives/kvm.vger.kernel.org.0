Return-Path: <kvm+bounces-59929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95A59BD59AB
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 19:52:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFAFC40035C
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 17:50:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 001462D0275;
	Mon, 13 Oct 2025 17:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aYDoKku+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965BD2522BE
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 17:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760377763; cv=none; b=URKzISJQkL8j7Gss/hDkN/rc3nReojKsbzHhW5PaTWYH8l3PFYbhT+KHDto1ucGCF0KrmhILvxgewPhwKWEt/Hr2JRNYDtPBOoMn4NfJCR2GRfrjOEIk9largOsGzAfLuqV3ctrTks7weSTAJqst/BJGe1DeFD3x9SnBQVjZwXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760377763; c=relaxed/simple;
	bh=YpOrvarDsgX+BoUcJp30a+73+gS1d+gCoNWkzrol2Qg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DYr9/krVIvx4nsgo3Jlq4I5KhhaHW+AO3dyoHnbXN177LM7Q93b+L9g423ePNu/xO7czW4zuQEv9U547eOhrnYLrdSNcwcJwRdgIPsaE7E6+Rwb99S9/ytZUDq2nGppt/5ICX2gAsoTstmCCHPT0lc0k0q5LYfof9Ou4VcIbh/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aYDoKku+; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eb18b5500so13418971a91.2
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 10:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760377761; x=1760982561; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LukZPy5/CZdWHCV/h7XbMjLCjzkVUD5w5QgJZZyHQqI=;
        b=aYDoKku+jZmKnk4if5dd0rTv1LX6iyEHKcnXuhcklX0LO3cjxUAHj2zZtyNHt6FECE
         BxSWWTK525BaO8xEefXbJBsKIfytOgSgbDrpNbJNYewtaKuJW5/lEY+RYHQzBmsknE6T
         LoLerJ/sAMKCpppWLtEJ78nVmgy6t6LkJGox8mYmlhN+6y7bbsFxdIIPr4HO3TJZUvyV
         0VLfoEBBpFrflboIxp/xioT1BSfEhLUsJdSQ+hkUOeP5ItaKuI7GJXh6Tr2VS9kPPyj1
         MmjpbIG+0ZxIuwSscsw63MQyfcg1Ps/QF4cocMjazgH8x/d4ylthOtNcF43Jr/bjk+5Q
         2T1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760377761; x=1760982561;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LukZPy5/CZdWHCV/h7XbMjLCjzkVUD5w5QgJZZyHQqI=;
        b=KxjUA+p4H0Twe3XSKFbHBrfsJrQD2RzteitmDzH4lt4PDngYWJADWbvIbxtwgSe8kg
         bgV1Fd1k94NMESsKuPcjxTmQ1uW557OegW2FetMwkkxkDikiWziWDfD/+3+Y+9gBvkxW
         XhX64DIMO/EtqU8uKArOOQ2U5kukkBGanxbyoSS8CPzMo11nDranljSjcj6JyYXT1pbT
         CS+o4YaJjwLsiqr9uULNIJHDQpl6PsB1OlkM3ukDWw38T2Cu4EDBY0QvQyLLTfEDora9
         YzLR9kAUt8IcFdqR2YX7KWq9WtaCsovP4j4+CewUTTlwqEB7I/NXBjs0d064bBxZPnCH
         s2OQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKVRB8OR9WMd7dAT2NfKnYNlsRLJXQlRAe//+xYpEwfL+LEtPwkuoXc43fY4tEb9mznaE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwW4U47EWXF8e7F1x8plZlaYTFHCTQ5XITzv3KMvFWRAsFgPLjT
	rxZu61gWCl0Zsd3bpif7Jcx3At1Su4s74MSdnuyoDFIBHxtxVk6gmdg7FOJ/vlG6ao5TQ/ZsFPc
	4F29Gdw==
X-Google-Smtp-Source: AGHT+IEHWN8e42GwQBxFY89j15A3l2TcV+QryJNJewInavabM7dzmeX+taQwOLPmxj1PdL/WYv3lcA396qk=
X-Received: from pjbfr8.prod.google.com ([2002:a17:90a:e2c8:b0:32d:57a8:8ae6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b50:b0:32d:a0f7:fa19
 with SMTP id 98e67ed59e1d1-33b51375940mr33870345a91.17.1760377760845; Mon, 13
 Oct 2025 10:49:20 -0700 (PDT)
Date: Mon, 13 Oct 2025 10:49:19 -0700
In-Reply-To: <aOz8gHzmZ8PdsgNw@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251010220403.987927-1-seanjc@google.com> <20251010220403.987927-3-seanjc@google.com>
 <aOz8gHzmZ8PdsgNw@intel.com>
Message-ID: <aO07n_1LYtY8Oio6@google.com>
Subject: Re: [RFC PATCH 2/4] KVM: x86: Extract VMXON and EFER.SVME enablement
 to kernel
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"Kirill A. Shutemov" <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Dan Williams <dan.j.williams@intel.com>, Xin Li <xin@zytor.com>, 
	Kai Huang <kai.huang@intel.com>, Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 13, 2025, Chao Gao wrote:
> >+void __init x86_virt_init(void)
> >+{
> >+	cpu_emergency_virt_cb *vmx_cb = NULL, *svm_cb = NULL;
> >+
> >+	if (x86_virt_is_vmx())
> >+		vmx_cb = x86_vmx_init();
> >+
> >+	if (x86_virt_is_svm())
> >+		svm_cb = x86_svm_init();
> >+
> >+	if (!vmx_cb && !svm_cb)
> >+		return;
> >+
> >+	if (WARN_ON_ONCE(vmx_cb && svm_cb))
> >+		return;
> >+
> >+	cpu_emergency_register_virt_callback(vmx_cb ? : svm_cb);
> 
> To be consistent with x86_virt_{get,put}_cpu(), perhaps we can have a common
> emergency callback and let reboot.c call it directly, with the common callback
> routing to svm/vmx code according to the hardware type.

Oh, yeah, that's a much better idea, especially if x86_virt_init() runs
unconditionally during boot (as proposed).  cpu_emergency_disable_virtualization()
can be dropped entirely (it'd just be a one-line wrapper).

