Return-Path: <kvm+bounces-65657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E203CB3204
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 15:21:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BF2683079283
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 14:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3B04322C83;
	Wed, 10 Dec 2025 14:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CUcaOgp8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D133770FE
	for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 14:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765376421; cv=none; b=HeJcyfsFhjIHPDI8p5tKV/wzoD6HylnhdtdqX9+MS3J6SmahZrx5+KjDDK3qUG9NRyX26WHmsVYoNLG4pYAECa1xUr9En5UZWfMnJMgW9LWscZfEweK9veZD2mxrnj7wwLmqvVYiMnRiplbixMN44kdNHVRZ4DS9B83qjdY+gqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765376421; c=relaxed/simple;
	bh=73ZN5gVruYdPb08Z7qWkjqs7M3VqgYcIbZtj6Xjrz9c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qC4RAp2VWNeLirTnGBYJNaXI+VShulsw0asjungXN/bxb9lnW5YLXMzRtrWekIlQtg/930SlGTz9vjc7BPKX3yKux/I1GZHTQeQggz8whdvZjB+OLnPXzbXask5cTVa75YPqjMYFptknmreL3Gf1l+BZQyHEtaosAY6jIS9TdhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CUcaOgp8; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34943d156e4so17949124a91.3
        for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 06:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765376419; x=1765981219; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bR+OZ7ucbAcjgpsdh1BcVHBHgTugKNJ+Rip2j8+KG6Q=;
        b=CUcaOgp8o1dYfnV6loHJs1ge8NxGO7lTs4g0gKzmTt4SMvXBkd+czt6iFFyCxOKJdy
         5IAmCDKjuK71wXlOoBrgfAjq3pFUC6SDieWvkb9jxdVo0lp5nabVtY9ZqPYsApX+yuFV
         CRPOkYcL/ymiG3LVEmNtTtFdc3rYjKSYj+fh+vFWpE2gmDGLIkm7P9U6jT9DGIruZ7ij
         XCUmMaNnY8F1O2XLr6L4kvYiSr8QI8zoRfXwbJeLBHQNSJ9hN3xMN2AkyA3KWNiOW7bk
         b1+yR/KKzXvjzgEWyxvCFFeDdlBeYtXLcFfNSltTRH/J+19uEv37J9xNNpr+nISDtOmn
         PmLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765376419; x=1765981219;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bR+OZ7ucbAcjgpsdh1BcVHBHgTugKNJ+Rip2j8+KG6Q=;
        b=kX9MsxKycnfAs4pLFHbDaCVGFrmRPSy6ryWPTDc8FEtGUi4ryulH55/iJ/8wiAnLJ6
         O6S/Q6/qnfDIPVxAv1/Xk4G8R1h7FIwclWuF6vrk/oF0K36OAfv3pkVCnmyVquvRDzS0
         arXSe9jl4arQRRsE5mWoS+zfeJfRS4QNzUIcwts3SPAKJSfx9Vh2CO144Eh2ND2jOCQ3
         BtdFR8dJC4JA8RLpDsm6avdgLiyDgUsjoZXcGl/HwGGRnQFoFFBpnNE2LBpjDuneBexu
         Fp2i4uNpiTsX2HwlmJVayt4YvgXc6ZIjKcwRA3U09BnX6LXAb+qiJ7yySPPxMLcSde9J
         BcVw==
X-Forwarded-Encrypted: i=1; AJvYcCW1kQ0laM8wrYqzt7HNRNBGvtKR43jNPhzaHTxhbkRlH6Tx72wk3hXuAdAqpeC2A/sXNxI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxM4vU4fdlkXfwpYhQfpVIWocNzBQ5rLhsBwkLxDmyM2r28vigm
	uNgeyWECXTR6JZfauM0fe3a+o97cblgF/+q4JsdiuyEo78WWu745lYB6/XF/g8VC4hUIFQSSgYl
	f/XJjug==
X-Google-Smtp-Source: AGHT+IFgCI8qg86hbIJn6V9eCwSFHSrGKpYXFjELjD+yHzAQieQGee8BswD5GlPKq6wLYBeFr1bky6qissw=
X-Received: from pjbqc8.prod.google.com ([2002:a17:90b:2888:b0:342:8ef1:9719])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:38c1:b0:32d:a0f7:fa19
 with SMTP id 98e67ed59e1d1-34a7285c31fmr2992980a91.17.1765376418861; Wed, 10
 Dec 2025 06:20:18 -0800 (PST)
Date: Wed, 10 Dec 2025 06:20:17 -0800
In-Reply-To: <6939242dcfff1_20cb5100c3@dwillia2-mobl4.notmuch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206011054.494190-1-seanjc@google.com> <20251206011054.494190-3-seanjc@google.com>
 <69352b2239a33_1b2e100d2@dwillia2-mobl4.notmuch> <aTiAKG4TlKcZnJnn@google.com>
 <6939242dcfff1_20cb5100c3@dwillia2-mobl4.notmuch>
Message-ID: <aTmBobJJo_sFbre9@google.com>
Subject: Re: [PATCH v2 2/7] KVM: x86: Extract VMXON and EFER.SVME enablement
 to kernel
From: Sean Christopherson <seanjc@google.com>
To: dan.j.williams@intel.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Dec 10, 2025, dan.j.williams@intel.com wrote:
> Sean Christopherson wrote:
> > On Sat, Dec 06, 2025, dan.j.williams@intel.com wrote:
> > I don't think we need anything at this time.  INTEL_TDX_HOST depends on KVM_INTEL,
> > and so without a user that needs VMXON without KVM_INTEL, I think we're good as-is.
> > 
> >  config INTEL_TDX_HOST
> > 	bool "Intel Trust Domain Extensions (TDX) host support"
> > 	depends on CPU_SUP_INTEL
> > 	depends on X86_64
> > 	depends on KVM_INTEL
> 
> ...but INTEL_TDX_HOST, it turns out, does not have any functional
> dependencies on KVM_INTEL. At least, not since I last checked. Yes, it
> would be silly and result in dead code today to do a build with:
> 
> CONFIG_INTEL_TDX_HOST=y
> CONFIG_KVM_INTEL=n
> 
> However, when the TDX Connect support arrives you could have:
> 
> CONFIG_INTEL_TDX_HOST=y
> CONFIG_KVM_INTEL=n
> CONFIG_TDX_HOST_SERVICES=y
> 
> Where "TDX Host Services" is a driver for PCIe Link Encryption and TDX
> Module update. Whether such configuration freedom has any practical
> value is a separate question.
> 
> I am ok if the answer is, "wait until someone shows up who really wants
> PCIe Link Encryption without KVM".

Ya, that's my answer.  At the very least, wait until TDX_HOST_SERVICES comes
along.

