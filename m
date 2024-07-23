Return-Path: <kvm+bounces-22124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A2E793A51B
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 19:43:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 555CEB221DC
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 17:43:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4895C158862;
	Tue, 23 Jul 2024 17:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W4N3Rwnm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD4915884A
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 17:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721756590; cv=none; b=C+xC73c5JfcIZHZ3pdGWKx9lUtvU3cW1eMCGRqYv7CRJoeLd3nKzgk6qpJnOUPq9UzhC1LKrmjn4ndDWu+TPN1lrESigpjcuoPpDAK5wQHzxTTtedKuQIo9mS3KxydzghzgekhaOassIKmKx3oEhVuoL9VpbW+l0JbwYqMpwzZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721756590; c=relaxed/simple;
	bh=4mdUalOlsy9P5vA/8RYcYPOEWoP6ivUf6tPlW9y5P7E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZjvhR03dRXqrtIlKB4ECFNSEKh1WFy5i/aYCqUQ6LVIJvFiwdWf/CzWdnJXzHaQ/26HZcDhLfZsIJbteBOW5l3ENhXJbeNObjCinnOf0LSGb+7ATD8GO3esS65ggj9q98NQ1t+Amc8F3iUaZ/NqXdMucfVaWOyWUycc/Y2EUpDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W4N3Rwnm; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e02b7adfb95so12142284276.2
        for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 10:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721756588; x=1722361388; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2Is3f4F92kT3CL4s+JNC6IxKgl0i62l2bDM3yWOWMdY=;
        b=W4N3RwnmA47CGQe29u8ZAaz+arAtAGMmkJAplCUYA+XmsJKP0fyKUGVKrUl4QaoP+K
         G4kVA8bJ8Izzz6KtcOALoYVB1A8/hY3aFdfetDhaNAfIha3wzGrvDoJg48tG6oZKbx0h
         pqdc95WKeUtYPS4S2mnCYJm+ldrcyC60mUJNIMoOVImMy6w4CaTZm3IDyV6PKe91DTiV
         yuvbx+DcxDic7bCuL3Ir39fsCsbBxiYdbMfJTZgwCtN4b7O5VLylLeqTMNkZW7VOxsz0
         iEbecO91T1MjAbzh7n/P3Cb2vcniZZhimFNKBG8NyRApNj9MeysoSOzBAjgqzHIg8eOJ
         IB9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721756588; x=1722361388;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Is3f4F92kT3CL4s+JNC6IxKgl0i62l2bDM3yWOWMdY=;
        b=PTX6LRN4ZKM8ApFH10l7FRLzzoZxM4aXUOu9NDlNmJrB+USIIGaBviarGmZw2oytHE
         4cLqAxc7OoqKlUw2mxby/IJFA9+49fZUJd8+gFo4pbrROXSxzA1avrEJ4f5WzTaxvJtI
         zfRIkRlXtKh1CG8ESHEvCdEuAqqFjIT4Opp8f/O7s4SNF4+tj9VuvZXYCV+FGhYlg3d6
         eGpVtjk/faeY+bnERrO1d1ZFbuYjRF2XVIudPVh8MD+OTf8bDZT/ckjqSw1MiAbp7TJR
         upFoey/NZx/tzYCYDR2qTThpQrdm16ndqJ0zKLTlGZMN2uEzCzwdI44HvlgRshM5IziG
         Vsgg==
X-Forwarded-Encrypted: i=1; AJvYcCVGG1MeFAFLOXTdj6VfGJX4Syx7V6VrTG49OO3rp4pUJ4tACoVr2dwvicQYJlmzpG+wKt9Fo8a3PbmErB37gZGFO/MP
X-Gm-Message-State: AOJu0YxvUs8CkEkrdY0hbr/dX88oML4W9yg5FdaBh6+K48vRN7C/j1Bd
	0kwnvSXt0ADOSO44dzlrynKR3g+aDLDMBt9ugnNM+OCwYJrDMCCuc1zOkGvMKDOUJtWdkNolPDZ
	OAQ==
X-Google-Smtp-Source: AGHT+IFvWTvkxh/8wZolKLout5nuIQllMTJ9nuOEEvuAnBECkmYcOlc8Uh4/6YEZ0e2ShXUyneM12WR04iA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1104:b0:e05:6532:166 with SMTP id
 3f1490d57ef6-e0b096929a7mr1239276.1.1721756587996; Tue, 23 Jul 2024 10:43:07
 -0700 (PDT)
Date: Tue, 23 Jul 2024 10:43:00 -0700
In-Reply-To: <Zp/C5IlwfzC5DCsl@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240720000138.3027780-1-seanjc@google.com> <20240720000138.3027780-7-seanjc@google.com>
 <Zp/C5IlwfzC5DCsl@chao-email>
Message-ID: <Zp_rpCjJmEiFU4BI@google.com>
Subject: Re: [PATCH 6/6] KVM: nVMX: Detect nested posted interrupt NV at
 nested VM-Exit injection
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Zeng Guang <guang.zeng@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 23, 2024, Chao Gao wrote:
> On Fri, Jul 19, 2024 at 05:01:38PM -0700, Sean Christopherson wrote:
> >When synthensizing a nested VM-Exit due to an external interrupt, pend a
> >nested posted interrupt if the external interrupt vector matches L2's PI
> >notification vector, i.e. if the interrupt is a PI notification for L2.
> >This fixes a bug where KVM will incorrectly inject VM-Exit instead of
> >processing nested posted interrupt when IPI virtualization is enabled.
> >
> >Per the SDM, detection of the notification vector doesn't occur until the
> >interrupt is acknowledge and deliver to the CPU core.
> >
> >  If the external-interrupt exiting VM-execution control is 1, any unmasked
> >  external interrupt causes a VM exit (see Section 26.2). If the "process
> >  posted interrupts" VM-execution control is also 1, this behavior is
> >  changed and the processor handles an external interrupt as follows:
> >
> >    1. The local APIC is acknowledged; this provides the processor core
> >       with an interrupt vector, called here the physical vector.
> >    2. If the physical vector equals the posted-interrupt notification
> >       vector, the logical processor continues to the next step. Otherwise,
> >       a VM exit occurs as it would normally due to an external interrupt;
> >       the vector is saved in the VM-exit interruption-information field.
> >
> >For the most part, KVM has avoided problems because a PI NV for L2 that
> >arrives will L2 is active will be processed by hardware, and KVM checks
> >for a pending notification vector during nested VM-Enter.
> 
> With this series in place, I wonder if we can remove the check for a pending
> notification vector during nested VM-Enter.
> 
> 	/* Emulate processing of posted interrupts on VM-Enter. */
> 	if (nested_cpu_has_posted_intr(vmcs12) &&
> 	    kvm_apic_has_interrupt(vcpu) == vmx->nested.posted_intr_nv) {
> 		vmx->nested.pi_pending = true;
> 		kvm_make_request(KVM_REQ_EVENT, vcpu);
> 		kvm_apic_clear_irr(vcpu, vmx->nested.posted_intr_nv);
> 	}
> 
> I believe the check is arguably incorrect because:
> 
> 1. nested_vmx_run() may set pi_pending and clear the IRR bit of the notification
> vector, but this doesn't guarantee that vmx_complete_nested_posted_interrupt()
> will be called later in vmx_check_nested_events(). This could lead to partial
> posted interrupt processing, where the IRR bit is cleared but PIR isn't copied
> into VIRR. This might confuse L1 since, from L1's perspective, posted interrupt
> processing should be atomic. Per the SDM, the logical processor performs
> posted-interrupt processing "in an uninterruptible manner".

vmx_deliver_nested_posted_interrupt() is also broken in this regard.  I don't see
a sane way to handle that though, at least not without completely losing the value
of posted interrupts.  Ooh, maybe we could call vmx_complete_nested_posted_interrupt()
from nested_vmx_vmexit()?  That is a little scary, but probably worth trying?

> 2. The check doesn't respect event priority. For example, if a higher-priority
> event (preemption timer exit or NMI-window exit) causes an immediate nested
> VM-exit, the notification vector should remain pending after the nested VM-exit.

Ah, right, because block_nested_events would be true due to the pending nested
VM-Enter, which would ensure KVM enters L2 and trips NMI/IRQ window exiting.

The downside is that removing that code would regress performance for the more
common case (no NMI/IRQ window), as KVM would need to complete the nested
VM-Enter before consuming the IRQ, i.e. would need to do a VM-Enter and force a
VM-Exit.  But as you say, that's the architecturally correct behavior.

