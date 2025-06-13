Return-Path: <kvm+bounces-49335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A9C9BAD7F72
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 02:09:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B747D1892497
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 00:10:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5B2838DD1;
	Fri, 13 Jun 2025 00:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XXqa7ICU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704EB1B95B
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 00:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749773375; cv=none; b=e2lDBnvI4Pev5zbyvgJIOde700POecBNb7rL8ENis1bKHkL/hjzP9K0yOGecrnmuHp+9hpTOeevy/0AyFQMwBHntIMBw6kyF90lUybix3dmEhw0p0ZCeBHwSqqG4pN+uTN2M0aP/juaJAcVhTsfl6FL6RQhQziJ6YQqHIzCY2jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749773375; c=relaxed/simple;
	bh=/ktH2xactQn7a2Lngut9MGuVtpiPv0SdsqRt9Mm857k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A244OpjLIs9OhpccPhEpkUtP4ytkWTzuiZe44EPXKgE6ZhTsKiBKDh2tKOXhGy9Dwkj/gSrj4oupq6BePa7LH2VY4Qy1TmBDm3/6V4pejUnvubJGHTkq89uhOpEdRdWIqNzQFa33W1bCAclS9boEkyF07CAyQ1DeqYxqWjaytcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XXqa7ICU; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7394772635dso1168370b3a.0
        for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 17:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749773374; x=1750378174; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JjbKQe64dfg1fWMvIao4pEIryvItWqTHsDUghiEa5jk=;
        b=XXqa7ICU2K6RUBc9+LZnfZP1wbQywZiLUM2K7sXCBSH54KKr1iWi14GPTqAn6fW9Hn
         m309/otUnTvt2hI/hTm7EQPK8TQIIQVitQNCTcemQBs2pXgDpTAhvPRSXwliR35uyMxM
         FQ7SQW6mnXhJA0MyBMRlzYS92IosvF005nZIskQ9rgAJPPcJmRfuSBvH+sGQNfETeL90
         RrrVdBTwqB+2UIAg3cG3CNntka8bYVyoPr9J7ZuHpo9Sc7PLAD1ZL/HrGa0vlj0KAgWH
         tOMsA4RAENvZcq1y7sAYjRr9Yu8ULHb6+Y1EnjoJAVp5P8e1SHHcp0oG82V+PMl7j7wz
         iEEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749773374; x=1750378174;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JjbKQe64dfg1fWMvIao4pEIryvItWqTHsDUghiEa5jk=;
        b=tdEpcO+qAKClSN8jmxSWZeobtLpwE3iD1wKV8utHSXdKjdgZFQf4pEqXhtClU88RMX
         Ddxh7kQDHTCulP+yAv6d/Cc0lQCyOq6er0qmBsDaXteTygkNGb2/a2g/hFgHSEDI3z+v
         RHIOZGMLbyPOPomtBL2Na2UkT1SbGBiBK/mbgOgCv+MWtQ/XFQXNEql9t4ApNiP5rxHB
         MJ2bPkQ2oVaYJGxmoCyqT52lcMQdCzApIX9Ugk0GfciqCQzUOq2U2qfAcfsUfPk5vjs1
         rljuaCwJbAU7trVg7sf7d2YcDBm8IMz99EwoxzBPtwFjVI5uNcDVcaS0vREJmvdHm8pt
         Ozpw==
X-Forwarded-Encrypted: i=1; AJvYcCVBaDIb9qelvdpf6//7vB5Sl/FoV/jzUz5RtEMNiNfXf1TTE7Bg5HacVxB0gFl0aHxznGI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOHk43px8Nnz4Sl4XKrBrgDEQkDC53tU7hS4vcb+woOrGSgjxx
	sjCdHtq0QqwRIjVv4UPHBwcV9IuCfNSBjwZi2q9F9XBIFqp3eSzZXPtaeYIK4ROi8zErxDDyqGz
	6mTWaxg==
X-Google-Smtp-Source: AGHT+IEvfSNx2MTIGs9zRZWnO+a9xVhIHUWPkCsnktSUFR08Nvt4dHmTB1CxMd7JQI0Vq45VV1vpNv+gKmY=
X-Received: from pgbbo5.prod.google.com ([2002:a05:6a02:385:b0:b2f:63c8:753d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:8093:b0:21a:e091:ac25
 with SMTP id adf61e73a8af0-21fac8e62b3mr872991637.6.1749773373878; Thu, 12
 Jun 2025 17:09:33 -0700 (PDT)
Date: Thu, 12 Jun 2025 17:09:32 -0700
In-Reply-To: <02ee52259c7c6b342d9c6ddf303fbf27004bf4ef.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611001018.2179964-1-xiaoyao.li@intel.com>
 <aEnGjQE3AmPB3wxk@google.com> <aErGKAHKA1VENLK0@yzhao56-desk.sh.intel.com> <02ee52259c7c6b342d9c6ddf303fbf27004bf4ef.camel@intel.com>
Message-ID: <aEtsPEnQTRBoJYtw@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Embed direct bits into gpa for KVM_PRE_FAULT_MEMORY
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Yan Y Zhao <yan.y.zhao@intel.com>, Kai Huang <kai.huang@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2025, Rick P Edgecombe wrote:
> On Thu, 2025-06-12 at 20:20 +0800, Yan Zhao wrote:
> > What about passing is is_private instead?=C2=A0=20
> >=20
> > static inline bool kvm_is_mirror_fault(struct kvm *kvm, bool is_private=
)
> > {
> > =C2=A0	return kvm_has_mirrored_tdp(kvm) && is_private;
> > }
> >=20
> > tdp_mmu_get_root_for_fault() and kvm_tdp_mmu_gpa_is_mapped() can pass i=
n
> > faul->is_private or is_private directly, leaving the parsing of error_c=
ode &
> > PFERR_PRIVATE_ACCESS only in kvm_mmu_do_page_fault().
>=20
> General question about the existing code...
>=20
> Why do we have the error code bits separated out into bools in struct
> kvm_page_fault? It transitions between:
> 1. Native exit info (exit qualification, AMD error code, etc)

This step should be obvious :-)

> 2. Synthetic error codes
> 3. struct kvm_page_fault bools *and* synthetic error code.

A few reasons.

 a. The error_code is used in other paths, e.g. see the PFERR_IMPLICIT_ACCE=
SS
    usage in emulator_write_std(), and the @access parameter from FNAME(gva=
_to_gpa)
    to FNAME(walk_addr_generic) (which is why FNAME(walk_addr) takes a sani=
tized
    "access", a.k.a. error code, instead of e.g. kvm_page_fault.
 b. Keeping the entire error code allowed adding kvm_page_fault without hav=
ing
    to churn *everything*.
 c. Preserving the entire error code simplifies the handoff to async #PF.
 d. Unpacking error_code into bools makes downstream code much cleaner, e.g=
.
    page_fault_can_be_fast() is a good example.
 e. Waiting until kvm_mmu_do_page_fault() to fill kvm_page_fault deduplicat=
es a
    _lot_ of boilerplate, and allows for many fields to be "const".
 f. I really, really want to make (most of) kvm_page_fault a structure that=
's
    common to all architectures, at which point tracking e.g. exec, read, w=
rite,
    etc. using bool is pretty much the only sane option.

> Why don't we go right to struct kvm_page_fault bools? Or just leave the
> synthetic error code in struct kvm_page_fault and refer to it? Having bot=
h in
> struct kvm_page_fault seems wrong, at least.

I actually like it.  It's like having both the raw and decoded information =
for
CPUID or RDMSR output.  All of the relevant fields are "const", so there's =
very
little chance of the state becoming out of sync.

I suppose an alternative would be to create union+bitfield overlay, but tha=
t
wouldn't work if/when pieces of kvm_page_fault are shared with other archit=
ectures,
and even without that angle in play, I think I actually prefer manually fil=
ling
bools.

