Return-Path: <kvm+bounces-51955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C6C4AFEC63
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:44:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE83E562B16
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:42:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B33BD2E889D;
	Wed,  9 Jul 2025 14:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FS2Pxq2w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D5C2E5B20
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 14:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752072093; cv=none; b=JD4pV01mR2zU4saeQ4VDqSUKHhOZo6xQGcn/ZnZF1mAAN9oFt9Vxl+FkPDuvtjyPyn1YDuoDk9QtoS219SpfqwKWUCAkVC+9kvYUSaK5FJ9X+0nStLq/kCCqtBVwfKMVB9isRr5E3YLPmx25kqzjfwBvUTWQzyD8kmPxV6MwGF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752072093; c=relaxed/simple;
	bh=zUxumM8TYtASQtxVbc0OxTZstf6esCItSZ1OBn+4Z0I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ITsJc7Eu6QQpxXzWUuJALRXRH1s3H/gAUK8SE2N3JaVNVpFkVUr82aPHH+Rq5mjMGYaCtV9eFvrGa/rSWSLnlmnSd/dS6fDblF53MgVNDeyOy8K3AnvZDHgcSj++M5Lbk13k0v9dQCzcODbd/eLmFnRTuaa9mey0nFHumdIMYyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FS2Pxq2w; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-315b60c19d4so19050a91.0
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 07:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752072092; x=1752676892; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CIXIgTU/d0DHVgdq3Al05Y23M2ENHaeJ4kUVB+5AwJQ=;
        b=FS2Pxq2wh6lJHbQ25wtLvZPi11ooIhBAMPMriKkkpoOO6/xb30TvqXj4ygYbOnFhmk
         aIJfAsXEOL6OyH7YvJc3V0/mj+nhRKOPtNs+NqvTCYOHozndEG32IcWpRHJFjUHuTxIx
         8eYXykLbXLqxdJaF1Vu4M9QJ9yerTY3h87lrUpW9/DpgK/N3zDE82+GdSwLSnFEI1jmG
         ovQxpn6+w6LalUoP8zavFnGqA6bSbwbCWIcXt50f+4nlEsls4Q9WY1SwYhCY7cNqHckP
         cRFJMrKn+shAGlyI55UvYi5TNrZRKrx/S8ApN7rrAA0KBCwcJ2DHxCzqGtjl+ALemzx1
         sWig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752072092; x=1752676892;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CIXIgTU/d0DHVgdq3Al05Y23M2ENHaeJ4kUVB+5AwJQ=;
        b=hwimjfqGuwCUURYdWJOuzK6n67IMSRmaOmXzfJ8tgDm9OnBxkf0/gRYY4lUrb3IC9n
         ZMa0Tf1dsttEO9ai/nLNGEnUEm1Eppo1ehonD2etWflo7iTpzLCBZRPMR+Fz5C4Wt2bn
         pAovpYuyjpHBQ7j2v8ZGaWA1lHJ4SPjNOmKhm4HXex9fU8rQeDuu02PO1VRmfHmPg/dM
         xHx7eioL07GSvip+HhxW4GdKTNnjZof/cFM+HCzyD6dm7b7M+6dAYcKGKi34mCdw0ZB4
         D/4QCOk4RWM/JsiOTuqnGkJIije4UuPOJXMXTXtr8opvODbZdy9s/cLKqpiJTFN28OEs
         vseA==
X-Forwarded-Encrypted: i=1; AJvYcCV0mw7ROrIPYEh1sjBE+68L/ohaH/HzQW89KaLgDYuKVNu1TF+HO8ep1SuNybZWWCniHGE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaW8hxRhPDH5M8/eXyGTOsb23jrLrKCBDj740D09vk4pLWQvPB
	cuAOUPiT4unl0aY42O+QG1Z/P2Iy/DtJcOR3GmLshvafiP/G0IQukM4dk0lxsWjSfgBBBQgAK38
	v4wnlHA==
X-Google-Smtp-Source: AGHT+IFDLY6OfylAhVLjR/Rwf8Wt3N0W8uox0MdBAD2RtWhU6riKyOdha2HLTDjSeTROfebQD4Ts1Q5RcMY=
X-Received: from pjbsk10.prod.google.com ([2002:a17:90b:2dca:b0:312:1af5:98c9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d89:b0:315:c77b:37d6
 with SMTP id 98e67ed59e1d1-31c3c2e27e6mr186837a91.23.1752072091506; Wed, 09
 Jul 2025 07:41:31 -0700 (PDT)
Date: Wed, 9 Jul 2025 07:41:30 -0700
In-Reply-To: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
Message-ID: <aG5_mowwoIogBSqH@google.com>
Subject: Re: [RFC PATCH v8 00/35] AMD: Add Secure AVIC Guest Support
From: Sean Christopherson <seanjc@google.com>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com, kvm@vger.kernel.org, 
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com, 
	kai.huang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 09, 2025, Neeraj Upadhyay wrote:
> Kishon Vijay Abraham I (2):
>   x86/sev: Initialize VGIF for secondary VCPUs for Secure AVIC
>   x86/sev: Enable NMI support for Secure AVIC
> 
> Neeraj Upadhyay (32):
>   KVM: x86: Open code setting/clearing of bits in the ISR
>   KVM: x86: Remove redundant parentheses around 'bitmap'
>   KVM: x86: Rename VEC_POS/REG_POS macro usages
>   KVM: x86: Change lapic regs base address to void pointer
>   KVM: x86: Rename find_highest_vector()
>   KVM: x86: Rename lapic get/set_reg() helpers
>   KVM: x86: Rename lapic get/set_reg64() helpers
>   KVM: x86: Rename lapic set/clear vector helpers
>   x86/apic: KVM: Move apic_find_highest_vector() to a common header
>   x86/apic: KVM: Move lapic get/set helpers to common code
>   x86/apic: KVM: Move lapic set/clear_vector() helpers to common code
>   x86/apic: KVM: Move apic_test)vector() to common code
>   x86/apic: Rename 'reg_off' to 'reg'
>   x86/apic: Unionize apic regs for 32bit/64bit access w/o type casting
>   x86/apic: Simplify bitwise operations on apic bitmap
>   x86/apic: Move apic_update_irq_cfg() calls to apic_update_vector()
>   x86/apic: Add new driver for Secure AVIC
>   x86/apic: Initialize Secure AVIC APIC backing page
>   x86/apic: Populate .read()/.write() callbacks of Secure AVIC driver
>   x86/apic: Initialize APIC ID for Secure AVIC
>   x86/apic: Add update_vector() callback for apic drivers
>   x86/apic: Add update_vector() callback for Secure AVIC
>   x86/apic: Add support to send IPI for Secure AVIC
>   x86/apic: Support LAPIC timer for Secure AVIC
>   x86/apic: Add support to send NMI IPI for Secure AVIC
>   x86/apic: Allow NMI to be injected from hypervisor for Secure AVIC
>   x86/apic: Read and write LVT* APIC registers from HV for SAVIC guests
>   x86/apic: Handle EOI writes for Secure AVIC guests
>   x86/apic: Add kexec support for Secure AVIC
>   x86/apic: Enable Secure AVIC in Control MSR
>   x86/sev: Prevent SECURE_AVIC_CONTROL MSR interception for Secure AVIC
>     guests
>   x86/sev: Indicate SEV-SNP guest supports Secure AVIC
> 
> Sean Christopherson (1):
>   x86/apic: KVM: Deduplicate APIC vector => register+bit math

Boris, do you anticipate taking this entire series for 6.17?  If not, I'd be more
than happy to grab all of the KVM => x86/apic renames and code movement for 6.17,
e.g. to avoid complications if a conflicting KVM change comes along.  I can throw
them in a dedicated topic branch so that you could ingest the dependency prior to
6.17-rc1 if necessary.

I.e. these:

  x86/apic: Rename 'reg_off' to 'reg'
  x86/apic: KVM: Move apic_test)vector() to common code
  x86/apic: KVM: Move lapic set/clear_vector() helpers to common code
  x86/apic: KVM: Move lapic get/set helpers to common code
  x86/apic: KVM: Move apic_find_highest_vector() to a common header
  KVM: x86: Rename lapic set/clear vector helpers
  KVM: x86: Rename lapic get/set_reg64() helpers
  KVM: x86: Rename lapic get/set_reg() helpers
  KVM: x86: Rename find_highest_vector()
  KVM: x86: Change lapic regs base address to void pointer
  KVM: x86: Rename VEC_POS/REG_POS macro usages
  x86/apic: KVM: Deduplicate APIC vector => register+bit math
  KVM: x86: Remove redundant parentheses around 'bitmap'
  KVM: x86: Open code setting/clearing of bits in the ISR

