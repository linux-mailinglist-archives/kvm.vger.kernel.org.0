Return-Path: <kvm+bounces-48807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B8EC4AD3E92
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:13:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CB0367AB3E8
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 16:12:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68E5C24293F;
	Tue, 10 Jun 2025 16:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VkYQlwcE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BED241CA3
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 16:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749571948; cv=none; b=R8Q8cEx2nPmvl278WN6vVb8Sn5IOoRJ+SDCAS14zVYTElj5NEV4DRsvuy8qZLIQMcO4GvzFq4ohrKOeBybOCmpDH56TviUXoNuGFPy7SgvJpiyJhNXqBvLDGRiwV8O4x4vE00ZUAc1w9deoiTEyB9K9yaiwXl53rynqmcLW80iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749571948; c=relaxed/simple;
	bh=5WJNEkDIjQQz2okt4KOF8T62rDFTSGAdY4cYKkBLKAM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P/PQAP9w6idSzxRdWckLGdDAS8otHkg5qgZC0NerovgCI+XPtBd4jU2FMTs8slOOjfW7BnEYMVGMyGZdajzQnmAzI752WZj6gN0K+f4eoabKxZ7dgPbU+rKJK6ogRZCEuG+qYGjL12q9A22krmciX1O4PsfUkV9O212njhLzu6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VkYQlwcE; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3132c1942a1so8078982a91.2
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 09:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749571946; x=1750176746; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tdst2AXEI4Imm1N+8aUcHMsoZp01dEp7fOzDZf0fTqo=;
        b=VkYQlwcE6Gabdm0Q7BNy4Sel4WedZgCTG3pCAIRXdkA6O0GwFNVvtEK8iaDfIxwcXg
         a5+6PWIHy0gUmcG8ljDl95pPZ/yQ2BxPskUxxla6hNVwau2tpkYZ+vEGsbaADSHv8KR/
         h6pxSBtXFv5OdeMyYuQC1oc3z15OLzEZ+QOwC3yEtkKgOL7eFFkb3jw1vcPNRMU8+Jmt
         m8SKqFeVit/Tj9pXGQ13MuFeXaO0djRyJFU5jgDmVclghlcGA4FR51z+PU0MiRUGKZ3e
         MQ+V+u1nUaEQuQ7/CoiBUB1SlO9+UFCWmXuY4U+ciU9JHKp6soH1uxPtjZJ6Ox7AbCGG
         Nv/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749571946; x=1750176746;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tdst2AXEI4Imm1N+8aUcHMsoZp01dEp7fOzDZf0fTqo=;
        b=L7xqZ7YxM5UU+xPZTGy5h6Z2knfElUa80M8PFHY8zYIdMje6VJZQ1K3m9YOaut9En+
         ZGpxTmJegEnDaQDxXrA+wc8iTx0/cxgDJCrfqvKPx2bzz39AtZAbluzbs6EWOMtQnbc8
         rH9LFs7XBVP9cs/2Z4vG5r6U0xcIrV2Weq7HkaLR5c06YXNtPxluzX+cNcImmak7izU4
         vZdVliAPlkPmY6I1K/vY1xlqLrUjGujAq1VloKWV8Jn4C+dWg2k6204L3LaBnhbSadrm
         f9wveAR2LgO43/3EUs36u5tXkLhoUJPqtitDc0hnYfGpejj7/ak5Njtim+K+uK1luWPW
         G3QQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlPy1I8VYT0a6Ubia73fw0vDI6OObuY5wX2xNOsOVgotYB2X47inoQk/sNZ2EENuKmc3w=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzBNC/POUfHv1FUT33aBWi50NB6LwlSuaf0hcLRE5Rdb+3e9A4
	zVB2TTGj/SedNg/N7q47oWPu3ck6ZRguT1YpywxQyfdrydBKJI2NDCI7IyvWFcPMPBhcBbZFQtX
	LUsTjtA==
X-Google-Smtp-Source: AGHT+IE71Jz/QhQNRZ8OzEh0DWxt/XrMZMCp0tDfjSa8QU6g08JvolhGnuLJkEQj3Yvonq7nqSu9ReSpHFU=
X-Received: from pjbrr16.prod.google.com ([2002:a17:90b:2b50:b0:311:f699:df0a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3887:b0:311:e9ac:f5ce
 with SMTP id 98e67ed59e1d1-313af23d84bmr171621a91.21.1749571946315; Tue, 10
 Jun 2025 09:12:26 -0700 (PDT)
Date: Tue, 10 Jun 2025 09:12:24 -0700
In-Reply-To: <cc3df866-9144-42f0-a24c-fbdcedd48315@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
 <20250429061004.205839-2-Neeraj.Upadhyay@amd.com> <aBDlVF4qXeUltuju@google.com>
 <cc3df866-9144-42f0-a24c-fbdcedd48315@amd.com>
Message-ID: <aEhZaMuipi2qePHX@google.com>
Subject: Re: [PATCH v5 01/20] KVM: x86: Move find_highest_vector() to a common header
From: Sean Christopherson <seanjc@google.com>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com, kvm@vger.kernel.org, 
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com, 
	francescolavra.fl@gmail.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 10, 2025, Neeraj Upadhyay wrote:
> On 4/29/2025 8:12 PM, Sean Christopherson wrote:
> > Please slot the below in.  And if there is any more code in this series that is
> > duplicating existing functionality, try to figure out a clean way to share code
> > instead of open coding yet another version.
> > 
> > --
> > From: Sean Christopherson <seanjc@google.com>
> > Date: Tue, 29 Apr 2025 07:30:47 -0700
> > Subject: [PATCH] x86/apic: KVM: Deduplicate APIC vector => register+bit math
> > 
> > Consolidate KVM's {REG,VEC}_POS() macros and lapic_vector_set_in_irr()'s
> > open coded equivalent logic in anticipation of the kernel gaining more
> > usage of vector => reg+bit lookups.
> > 
> > Use lapic_vector_set_in_irr()'s math as using divides for both the bit
> > number and register offset makes it easier to connect the dots, and for at
> > least one user, fixup_irqs(), "/ 32 * 0x10" generates ever so slightly
> > better code with gcc-14 (shaves a whole 3 bytes from the code stream):
> > 
> > ((v) >> 5) << 4:
> >   c1 ef 05           shr    $0x5,%edi
> >   c1 e7 04           shl    $0x4,%edi
> >   81 c7 00 02 00 00  add    $0x200,%edi
> > 
> > (v) / 32 * 0x10:
> >   c1 ef 05           shr    $0x5,%edi
> >   83 c7 20           add    $0x20,%edi
> >   c1 e7 04           shl    $0x4,%edi
> > 
> > Keep KVM's tersely named macros as "wrappers" to avoid unnecessary churn
> > in KVM, and because the shorter names yield more readable code overall in
> > KVM.
> > 
> > No functional change intended (clang-19 and gcc-14 generate bit-for-bit
> > identical code for all of kvm.ko).
> > 
> 
> With this change, I am observing difference in generated assembly for VEC_POS
> and REG_POS, as KVM code passes vector param with type "int" to these macros.
> Type casting "v" param of APIC_VECTOR_TO_BIT_NUMBER and APIC_VECTOR_TO_REG_OFFSET
> to "unsigned int" in the macro definition restores the original assembly. Can
> you have a look at this once? Below is the updated patch for this. Can you please
> share your feedback on this?

LGTM.

Ideally, KVM would probably pass around an "unsigned int", but some higher level
APIs in KVM use -1 to indicate an invalid vector (e.g. no IRQ pending), and mixing
and matching types would get a little weird and would require a decent amount of
churn.  So casting in the macro where it matters seems like the best option, at
least for now.

Thanks much for taking care of this!

