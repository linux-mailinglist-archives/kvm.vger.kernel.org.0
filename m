Return-Path: <kvm+bounces-51935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3814BAFEB49
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:09:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A06765C308A
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:02:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8FFC2E7196;
	Wed,  9 Jul 2025 13:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IzOVu1vH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B5C2E6D1E
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 13:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752069338; cv=none; b=Psi+oySh/jx8fnEjjpk0Xn2e40DU1Yfy4gNL2rXTa0UH8ERc0HPV253va6NsGNlW9U+WkUw1zn9vhg5YpUf60sUVE4kc+LAEWI3TjGhqqltytnYh1gZ9+3m010rYQLg8C2+Ri6tL1swvgqdxkvPmDq6nTdMn3xGbMLQnt5ld3WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752069338; c=relaxed/simple;
	bh=0h9vbjsgJ4KM4kpziRTulPuUJGQOT13eleRpBAru710=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A8sVCIauD08divPigKi+EL5jKoBBtZPPGidR7VaYDJuK9Pl6pQYvR+6tf1rw/GKWq55JKXPLX6hnTzpj/G8b4gstUvvYLFwSiIh25lnTFz7JotBAdgVeImzu1nSUiigFWCaP+gsHgWUFQStXEXvqdD/nNE8n/9IASMXunspAD/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IzOVu1vH; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3138f5e8ff5so5587402a91.3
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 06:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752069336; x=1752674136; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hB2pq64+EiT3q+LG5n2vE09OllB22A/8i32Rf86ziks=;
        b=IzOVu1vHAiZQEW1SK9aITiCIGPOggzl8NHWRVQJBgoLcGSg2u/0on9W2TcDLu6JHny
         Ugz1GTUMT2tGgQkTI3WJXqTCzVXvsRdVAxrObAnSaMhd3EuRXcWzffk+1eRMuZnrflg0
         ATpR7ptMUXiAil3evEELHgLyEEn68SCHZFUsK9zV43w6C5QwBWkO+UV+9Jw9HoZnObYM
         8QdAj8VdML8ieYhklbw9GfwqSFBfHsQX5Ef4ADBG0f2MRElJ5Xkxpu78AxA76NEad84e
         v6OLA75Wu9vSZHwFiBdDMJyzs7+Cm3wFCtms3jO96QwWZcw9NsLmA915hMd+rRDxq7pK
         b8+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752069337; x=1752674137;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hB2pq64+EiT3q+LG5n2vE09OllB22A/8i32Rf86ziks=;
        b=j19YUC009yukzzdTHzTFFcvCKBKhcT/pl3W229Bdu8y5ULqYYlValdnC6qkY0r6JU2
         VI2iQ5v7naJDO+pmC7v48OPuQEMHVkaUejDg76BJou0SIZN/a1CmlyvHAuk/EGHIzQWd
         oD6ZexncGSmr45N4QKfg3G11sxrYHxV4SlgAMl5KEmK+MDiM8DhvGiBzynw4vNXVHURU
         j+n1cgJ87LH+phwaMjIIdrLpFIEWc/wmB+MLwVeVspLJJMxDVD15q9msaRvowxrDj8w/
         yPc2yi90Y6c2GANy6aKG3wKrvYMkDVnVLKVB3TIyJ0YpIYfZwkaO54UlRjZtd3XD0d3J
         /FOg==
X-Forwarded-Encrypted: i=1; AJvYcCWpSBBrL7r2X6REDmI4/Ejv4l0ACuWEJo0cjG5S/8gC79s0UfrRoOjt4xjUnjL7yyR0Y1o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAFF/+i2kpVV4lLXOOKsqqZpW3FFbql4C2XLN0BmY3KPobCkb6
	lNwoPY6xPpfI/eh3DIfkGY5vAxBNQwb962/VsKDZFqkYQ02CnGhHfjRXmrFo/XkoD04ZPnbPFYY
	5F4GEoQ==
X-Google-Smtp-Source: AGHT+IEoqYqG05CCJJatVWyMPh8LvhP8g90wNpXynV+lVfyOqsEL9Ixv2ihGPj+7dKMNBozMlFC5A8s1AoU=
X-Received: from pjbta13.prod.google.com ([2002:a17:90b:4ecd:b0:311:ea2a:3919])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5345:b0:31a:bc78:7fe1
 with SMTP id 98e67ed59e1d1-31c3c2d4748mr6038a91.18.1752069336491; Wed, 09 Jul
 2025 06:55:36 -0700 (PDT)
Date: Wed, 9 Jul 2025 06:55:35 -0700
In-Reply-To: <aG4ph7gNK4o3+04i@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1752038725.git.kai.huang@intel.com> <1eaa9ba08d383a7db785491a9bdf667e780a76cc.1752038726.git.kai.huang@intel.com>
 <aG4ph7gNK4o3+04i@intel.com>
Message-ID: <aG501qKTDjmcLEyV@google.com>
Subject: Re: [PATCH 2/2] KVM: x86: Reject KVM_SET_TSC_KHZ VM ioctl when vCPU
 has been created
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Kai Huang <kai.huang@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	thomas.lendacky@amd.com, nikunj@amd.com, bp@alien8.de, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, rick.p.edgecombe@intel.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 09, 2025, Chao Gao wrote:
> On Wed, Jul 09, 2025 at 05:38:00PM +1200, Kai Huang wrote:
> >Reject the KVM_SET_TSC_KHZ VM ioctl when there's vCPU has already been
> >created.
> >
> >The VM scope KVM_SET_TSC_KHZ ioctl is used to set up the default TSC
> >frequency that all subsequent created vCPUs use.  It is only intended to
> >be called before any vCPU is created.  Allowing it to be called after
> >that only results in confusion but nothing good.
> >
> >Note this is an ABI change.  But currently in Qemu (the de facto
> >userspace VMM) only TDX uses this VM ioctl, and it is only called once
> >before creating any vCPU, therefore the risk of breaking userspace is
> >pretty low.
> >
> >Suggested-by: Sean Christopherson <seanjc@google.com>
> >Signed-off-by: Kai Huang <kai.huang@intel.com>
> >---
> > arch/x86/kvm/x86.c | 4 ++++
> > 1 file changed, 4 insertions(+)
> >
> >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >index 699ca5e74bba..e5e55d549468 100644
> >--- a/arch/x86/kvm/x86.c
> >+++ b/arch/x86/kvm/x86.c
> >@@ -7194,6 +7194,10 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
> > 		u32 user_tsc_khz;
> > 
> > 		r = -EINVAL;
> >+
> >+		if (kvm->created_vcpus)
> >+			goto out;
> >+
> 
> shouldn't kvm->lock be held?

Yep.

