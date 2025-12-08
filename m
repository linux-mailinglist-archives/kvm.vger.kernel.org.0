Return-Path: <kvm+bounces-65517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FDF5CAE5DC
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 23:51:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0CF223097049
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 22:51:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C425E2FDC5C;
	Mon,  8 Dec 2025 22:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tovEVNG1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2262BDC14
	for <kvm@vger.kernel.org>; Mon,  8 Dec 2025 22:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765234289; cv=none; b=AglO/W8qK+YMHzD0YubUMkIOfmoylZcdkw9AAOV19Z8pEvvWK6a36tfDoLudptQw3EZ5uHtrkDusRbYbtyBkDc9lKjtZsJ+QE1SmEIKrduPIGlNPAAIdpKNFbdPwRBhpzq5yh6O1QHDXReNiqGoCufeTp2324jRWT8I6svRPRYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765234289; c=relaxed/simple;
	bh=qjmDIUr7bv/8MlXiYHic60rQazzDSarrPtGhZ8cIUVU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KbYKThsvXYWYoJMGJkO9ToKhtl2F1S7wGbTUpFZ+96G8T0fuPIVJUWMewX0HbsfHexwxIK2ejdUmK3CYiB8lxOVSuC7rSkj0xnMTjMC+76lgr8+BoRNFnjSOmKU9Q6jaqXGDGOcnfaHhZu3qGPAtEoN8foTZ1g8ZX+GKZDpiY3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tovEVNG1; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2955f0b8895so49655755ad.0
        for <kvm@vger.kernel.org>; Mon, 08 Dec 2025 14:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765234287; x=1765839087; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bMAAjR6VSRUkIkVe3cxiUyYcIygwozSwS6Y8S/RiuY4=;
        b=tovEVNG1AMGbPzBg2bvlnfLW9h9wvrShRggwDnpEItmjcIEUL0zloNZa5gLONM+hcW
         AqIyk1yuwicjH5bAheTSFSyzOCatvoDGaeJ4Pv/ndRIjA8btphklF/IaA5MT5AxjEDTE
         chUod8ZeIbEoAjNcPRi1tIW8zUhmPneOyUVFZU3vnppn//BloULj5Dihb0noLepC1uof
         FUdXErh5yt9ePTBXSrABZOEgH0H0lyIAQxIsJ8IHXKxzn4UPmuI/pK0YU0WPiaVUlzaX
         q9f/miyRe2EjAJofRJh1fl/CjnyoyPIDi2uQidOKC3fKFTy9UTKJUI7Y3fg2hFdZeWR+
         qVKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765234287; x=1765839087;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bMAAjR6VSRUkIkVe3cxiUyYcIygwozSwS6Y8S/RiuY4=;
        b=a8y3MXAkoAeCRChbm07x/ljrPwnQ359u/NBTCtLn/bCWSDb+j7K2KKY5jQgmsfSdjT
         sOxMErtcidFyZ1fooZnJGF9Jv3KSpvONTh0JRhcm4JuEnnKy30Vrp7P6b3Sfv3gNlixH
         7Walbbknfc38kElXzvVJ90huhOo4UfEtM7lYGfs4EXn4HisYiiOOUHRtQWryf+qToc9x
         6KZuPQYa6tAbrw7+2V4n16ewwpzHFagMVpM4zBHCzH94V6674Sg2hYS7ytA2D1Dedzyi
         Umx+xZbfXMW/n5fZijvpDL3cqpP1T9AOZsi+0OMUufIyxj3LKfF3VCcbG8ZOIRVo0Mlc
         DqkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWdOlsonLbKEZHkm+cKDp+4QhmBp/WE6t20PUu5v5ix23HNKyBdAKwF3sZuOqps4wv1/QA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0kptUzi7gHErh6c3Xrd2KCVU+y877Q/utNLb2bxm5Q337jKY+
	X0KIGC+tA+vVWmesQEFGEMnXBSnqbafrQ0K9ScHwtzD78aBZTAmVGzNTWPL37I9qd011DBQh4CN
	dmbj6Iw==
X-Google-Smtp-Source: AGHT+IHY3/qn5h8d0ukv8qSmDKpwSSJQmHgReCnf0gw8vGmknvsoJJAz6bSiVI7oQ2P/wnp7Dg54VZ/fQYM=
X-Received: from pjaa15.prod.google.com ([2002:a17:90a:8f:b0:340:66e4:4269])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:28c8:b0:343:cfa1:c458
 with SMTP id 98e67ed59e1d1-34a45027d31mr887944a91.18.1765234287242; Mon, 08
 Dec 2025 14:51:27 -0800 (PST)
Date: Mon, 8 Dec 2025 14:51:25 -0800
In-Reply-To: <20251026201911.505204-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251026201911.505204-1-xin@zytor.com>
Message-ID: <aTdWbayU8BbR6eFu@google.com>
Subject: Re: [PATCH v9 00/22] Enable FRED with KVM VMX
From: Sean Christopherson <seanjc@google.com>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org, 
	peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com, 
	hch@infradead.org, sohil.mehta@intel.com
Content-Type: text/plain; charset="us-ascii"

On Sun, Oct 26, 2025, Xin Li (Intel) wrote:
> Xin Li (18):
>   KVM: VMX: Enable support for secondary VM exit controls
>   KVM: VMX: Initialize VM entry/exit FRED controls in vmcs_config
>   KVM: VMX: Disable FRED if FRED consistency checks fail
>   KVM: VMX: Initialize VMCS FRED fields
>   KVM: VMX: Set FRED MSR intercepts
>   KVM: VMX: Save/restore guest FRED RSP0
>   KVM: VMX: Add support for saving and restoring FRED MSRs
>   KVM: x86: Add a helper to detect if FRED is enabled for a vCPU
>   KVM: VMX: Virtualize FRED event_data
>   KVM: VMX: Virtualize FRED nested exception tracking
>   KVM: x86: Mark CR4.FRED as not reserved
>   KVM: VMX: Dump FRED context in dump_vmcs()
>   KVM: x86: Advertise support for FRED
>   KVM: nVMX: Enable support for secondary VM exit controls
>   KVM: nVMX: Handle FRED VMCS fields in nested VMX context
>   KVM: nVMX: Validate FRED-related VMCS fields
>   KVM: nVMX: Guard SHADOW_FIELD_R[OW] macros with VMX feature checks
>   KVM: nVMX: Enable VMX FRED controls
> 
> Xin Li (Intel) (4):

I'm guessing the two different "names" isn't intended?

>   x86/cea: Prefix event stack names with ESTACK_
>   x86/cea: Use array indexing to simplify exception stack access
>   x86/cea: Export __this_cpu_ist_top_va() to KVM
>   KVM: x86: Save/restore the nested flag of an exception

