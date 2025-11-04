Return-Path: <kvm+bounces-61985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A48FC32110
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 17:31:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3C88034A39E
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 16:31:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED659333744;
	Tue,  4 Nov 2025 16:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qMcTzQ8d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6B333344B
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 16:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762273866; cv=none; b=qGAY5k4qiSihFjtg0WYscKwnkJZQ7qN9RVfHW0U8N6xr6Yc2GoNgN4MqHP6+EoTolUSfFzqezGrzh7ycWlXVmxaBVqI1LpaDdJca6ap4ppF1C7UaFJqcsSShhVxNSuLEK1xvCKvH96TTR5ABIiYQ401Mv2TJAgsF2rCrNmqZ85M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762273866; c=relaxed/simple;
	bh=A/yfd8jdGr+pFUR3XHiPL7+bb9IBKOGPpvRZdjY/3oU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZPFOxSnaAE/wT/V3jEVXveuCqn5JtOtde2KhdqSuNURbO3QnRZDqqkMu7WX+49dHmGGMfutB4sIUuh5aDYKtMYDfnBhTjiRQOg81fCTdQkm9n8wADgzzEuNmcOV4yyK2SMm9B3SMwCgo4vHnHDLdgGNr+vzNWCa0zAENm7iqzdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qMcTzQ8d; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33d75897745so13994598a91.0
        for <kvm@vger.kernel.org>; Tue, 04 Nov 2025 08:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762273864; x=1762878664; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U/Sb6f6VhAgw9tNbhfts2Rrb10ZloGtd+JKJI3B0aR8=;
        b=qMcTzQ8dbQOOoGx89ivQdY/FRhF8jCiXIk82bAKmg1SOwv9RFV3iX3MJJ6jhlYGJyL
         k+Y6Mfur1Z8gaAB6Vcr95T+iXKrfZDxLFeRtL+XOU+LFnMawfFrJ7i0hAT7M9W6RXIXL
         bxPDtKNsskkBfltuEze49wEJGjiUbVsVv3Trq4dck92aLrOAIiblEGPWUoArn99K/9Mp
         TpNf4PC+skflc85HxG/EU1yM/6O95z5yy51cY6NUlzSe+bsZXJpaZn97wwdYICjI2qoY
         O1nelEq93b0npTKpFWp2FTBxp1pXTEM3pdXmRrLo/qNSi9ke8F2aEy7Xn9J691woklit
         741A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762273864; x=1762878664;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U/Sb6f6VhAgw9tNbhfts2Rrb10ZloGtd+JKJI3B0aR8=;
        b=sAb2FNue58LAKwRUpAjayb2f39v5K/w3QmjZf7NWXCX0sAgKaKYWNId/IrInvVMWrA
         nAu1QzrzzvxriZbHjNgrdPESLOmvlE82YR/bOtHxJzaLLem8OtqfHlEElG83nB3bU/lH
         FOunNiCaiS4oYj9zG0HUvS403atOqtNCWAz8/ZYICp3w0RqxVwZzxNe4woj4o22G7iFk
         WAOTq31KusOqd5M7IaT3f2mChZ3LOO2AXrf7PWEKzqXmsLuZkTf1CNYxTBxRNPtmIPXd
         c18yk3D4+SVWJNQcp6QyGIxTI7IKRPO2FxgROUCXENHQrBV5emXorYJDJg0mb+Tsq+wX
         pxFA==
X-Forwarded-Encrypted: i=1; AJvYcCXc6yrHWNX5P88GX7pA6QeJTw0c9xdd3lROt7car4rTKqYvTnA6CGziYO00DGcRZAWXM+Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMGCJTtWwOU92crjO3uEEtQqnjlp0Rn3aT6nUi4shI14rcGt1O
	voLdxxPAjOcjtT3DXw9ERzA0QzCureEWfFv+sLZ/NnFKLLfbFkME2Qn2p6IacN2tWfUHZLCLZqe
	Rrm5Hrg==
X-Google-Smtp-Source: AGHT+IEdQIr4M4XGWf0zRZoQtdQw+taTREO4d8GsRuDyXslQHePyubkG85oVwJP7U4BBQL/hLY8JoYEzu04=
X-Received: from pjbbt5.prod.google.com ([2002:a17:90a:f005:b0:340:bd8e:458f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:17ca:b0:340:d569:d295
 with SMTP id 98e67ed59e1d1-340d569d470mr15274032a91.24.1762273863798; Tue, 04
 Nov 2025 08:31:03 -0800 (PST)
Date: Tue, 4 Nov 2025 08:31:02 -0800
In-Reply-To: <72503421-803c-4fa8-8e28-b0c793798c7c@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251103234435.0850400B@davehans-spike.ostc.intel.com>
 <20251103234437.A0532420@davehans-spike.ostc.intel.com> <72503421-803c-4fa8-8e28-b0c793798c7c@intel.com>
Message-ID: <aQoqRqb-vN5GxT-x@google.com>
Subject: Re: [v2][PATCH 1/2] x86/virt/tdx: Remove __user annotation from
 kernel pointer
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>, kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 04, 2025, Xiaoyao Li wrote:
> On 11/4/2025 7:44 AM, Dave Hansen wrote:
> > 
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> > 
> > Separate __user pointer variable declaration from kernel one.
> > 
> > There are two 'kvm_cpuid2' pointers involved here. There's an "input"
> > side: 'td_cpuid' which is a normal kernel pointer and an 'output'
> > side. The output here is userspace and there is an attempt at properly
> > annotating the variable with __user:
> > 
> > 	struct kvm_cpuid2 __user *output, *td_cpuid;
> > 
> > But, alas, this is wrong. The __user in the definition applies to both
> > 'output' and 'td_cpuid'. Sparse notices the address space mismatch and
> > will complain about it.
> > 
> > Fix it up by completely separating the two definitions so that it is
> > obviously correct without even having to know what the C syntax rules
> > even are.
> > 
> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Fixes: 488808e682e7 ("KVM: x86: Introduce KVM_TDX_GET_CPUID")
> > Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> 
> the prefix of the shortlog is still "x86/virt/tdx". I think Sean will change
> it to "KVM: TDX:", if it gets routed through KVM tree.

Ya, I'll fixup when applying.

