Return-Path: <kvm+bounces-63028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 14EB5C58D34
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 17:46:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E1FFD4F2F0A
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 16:37:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4D0C361DDD;
	Thu, 13 Nov 2025 16:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IMD82bH3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CCE35A153
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763051352; cv=none; b=JJwN+vy7vGfKT1tcLoRK9LJar7GgkrUsIGebZgkpEm0IBnytIt7hCXTTDcc6TA9JTl3lXZTbvN3emHPy2zrCsTkLyoSuIUKZXMeYW+OnFH5JLKYqICjEEClOE6pcRPDpWkf7EmMfEE2kdTuSepc9uttG7jzGKopaFsCEo72MpKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763051352; c=relaxed/simple;
	bh=JPzSVp59ZCmlDUI9Beydu0hu21hddcAy+tsckcJKHLI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uswx50AhyXZtyqpO47MtsyvW5ymGmYUF/QAI6rwwgnQj1b0EGr3PsFyjP2QmpOtVZDlAbnoXeX9I+QPcz2NwlX3FgXyhhPCB1fa6Wbl9WoHbESjpAZf4cXHjGimEq8qYsfgpFMRDMAfqjJ7skmz5uagJy6sIED+zZ8PD1lfNHoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IMD82bH3; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-295fbc7d4abso9461595ad.1
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 08:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763051350; x=1763656150; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jggj5Ym/rIR7T7fXmMSGr1c+7mHxEtZV9zaRb5SwErk=;
        b=IMD82bH36oioDahCDvILysNXnaq2DaXCUir9392v2WbW5JU/mSoDjPJxuQtVRIqEOI
         Wa/1sLh0HExEjwlboyCy+asnYoim7mPOHygiSKJwYM3VcQNnh1kab909Iq46OcOge7/y
         1xX/d61/4DK0R9Xkh5+JIizyjIGb/3l8WpAJfZ1XiCU1si38JBz5VYHpVF0WsAwvlpBU
         vaJmLAmDRJsUP2dxfedczQxIgGU0EK3Cv5CmSPoMGK449FpcsjEHJ+6GzicPZsT6WD36
         scgxgSdd5tjtLjewp2KKUvUFkNtjqxrBVQgM+KgVln73bAsIM1DPrHm7byBlnYo6GsiF
         Ltng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763051350; x=1763656150;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jggj5Ym/rIR7T7fXmMSGr1c+7mHxEtZV9zaRb5SwErk=;
        b=aWD07qMoDhwW/a5YUL1RQ8Q5c4TgAin8Uj038PEPTMdgho031cVMwvWhjR8boAFMLi
         no3zB/T6VaXJF6ZJ2uadtZIkz+Rhm/Z9prA2tVSFyRC2qW8yguPVch4f5KsjkP4pt5Jl
         lhlqf5oqDcE9aSvHph+/cHC7TrkWhJ1dNRgp0211hKG4whahr8n5JBDzETCFzYFAPYT0
         0CO6x6qxOAmJaRYsMPFI8uIHMGrYjHnVcBlQndJ2iZwZercx0kZeYuAoL/VrnibEdvHt
         awi3bv5irlJE6iNt0R8J3LV/iQNcTHW4rOkWxwuoQCaf3DPdOVECOkhtUbB2+q+NKUow
         ilqQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5cUHQrkCAnlbDSxudjDmaDZIIWJmSCVKi1LDOol2cxn4HdjC8SgJNro8bBdHb/Idc/VQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxL7vIBebTYCdOUMntOIF60R7JlZO8PlROxI5UHA1ErIHt67ekl
	663Z+exk1xUpMnVR5WipemrHPUs6tJg6XjNb2VilCYjJBE6P9LLHDkTzoRuYvQVn+wcmlJqGoyF
	fOh/5AQ==
X-Google-Smtp-Source: AGHT+IGN4f1Z5MZfxK3TyPutsSVmoeFbSOAbtCMPNamHDfo8B2Hxzq7CUQshCWhzAT4nMU/PWEj7huMl4y8=
X-Received: from plbkj13.prod.google.com ([2002:a17:903:6cd:b0:268:cfa:6a80])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f683:b0:298:60d5:d27a
 with SMTP id d9443c01a7336-29860d5d2famr21044725ad.28.1763051350343; Thu, 13
 Nov 2025 08:29:10 -0800 (PST)
Date: Thu, 13 Nov 2025 08:29:08 -0800
In-Reply-To: <0d9e4840da85ae419b5f583c9dacee1588a509ba.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251112171630.3375-1-thorsten.blum@linux.dev>
 <4a2a74e01bfd31bc4bd7a672452c2d3d513c33db.camel@intel.com>
 <aRTtGQlywvaPmb8v@google.com> <0d9e4840da85ae419b5f583c9dacee1588a509ba.camel@intel.com>
Message-ID: <aRYHVHOex4zkyt5z@google.com>
Subject: Re: [PATCH RESEND] KVM: TDX: Use struct_size and simplify tdx_get_capabilities
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, 
	"thorsten.blum@linux.dev" <thorsten.blum@linux.dev>, "hpa@zytor.com" <hpa@zytor.com>, 
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kas@kernel.org" <kas@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 13, 2025, Rick P Edgecombe wrote:
> On Wed, 2025-11-12 at 12:24 -0800, Sean Christopherson wrote:
> > Your CI caught me just in time; I applied this locally last week, but haven't
> > fully pushed it to kvm-x86 yet. :-)
> 
> The TDX CI tracks some upstream branches. Is there one in kvm_x86 tree that
> would be useful? It's not foolproof enough to warrant sending out automated
> mails. But we monitor it and might notice TDX specific issues. Ideally we would
> not be chasing generic bugs in like scratch code not headed upstream or
> something.

Assuming you're tracking linux-next, I wouldn't bother adding kvm-x86 as kvm-x86/next
is fed into linux-next.  I do push to topic branches, e.g. kvm-x86/tdx, before
merging to kvm-x86/next, but at best you might "gain" a day or two, and the entire
reason I do "half" pushes is so that I can run everything through my testing
before "officially" publishing it to the world.

All in all, explicitly tracking anything kvm-x86 would likely be a net negative.

