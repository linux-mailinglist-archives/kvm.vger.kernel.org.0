Return-Path: <kvm+bounces-41726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C9C7A6C471
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 21:45:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD271484B03
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 20:44:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3276E230BD6;
	Fri, 21 Mar 2025 20:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X3PjzLhS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D0C230277
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 20:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742589891; cv=none; b=DKUYc0hbmAQg8Fjn6ggUENI/sq6DpNvhnOOUGAhXD22bHSH89lebo6eZ75HrYt9URw8RdJDun3HAGWH+YUPXmgMIBx+Wlj/TuQDfY9YwkdcamrKiflNwFJrY5K5TE4m5Yvab4VpwNXQEw2DtD6bC31M13VnSnui41rgllKyWqL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742589891; c=relaxed/simple;
	bh=54tcRDgahcG66vhxHIRsWfMsMsPcgCWCIQX1MVxe0Nw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c9Hjlc6JjUPfeZtVcbTwBC/kv2o26zuu4Qev6j2DAWG+d+JUstFa1PAyAK5hcPTUMKtlhuv3bf1fKNB27KKwLzp5klFn0gGupEjg/plYW4y9jRU55g2cbd2lefSPpYkpmj0WGfkNbWkBkQDjlPLmm95XR6Jx18fQ/Pw2TnyzIYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X3PjzLhS; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-22412127fd7so28648145ad.0
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 13:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742589889; x=1743194689; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GEMU6p1y8XG7aTq5OrE99edboR3QeK6rt4oPFIwBxB0=;
        b=X3PjzLhSY/XeGFNVtQGVAPW9mC/+udcR/gtQGn8VK4Jh/+NqjBb5sMqRUlApSfzP/A
         Z98vLBspz/R3iLANvT0ogFM5RtCiq7mBSq5GlkhUm4qdqTeRfmIGloEVyN5NkjyhOIUM
         163VCTgOfOsudDMHVLn9N7WWZvJLjQ+3BbiCxLB4LE1OwuxmfVWhMgCDaQDQ17HWchQB
         C5D9simFVxgPJFg/jNypf1SCanWqdlIbIKwxt8ghBxBisDZO41jolkjN19RoE0VEwait
         L8WKh6/RSKOzbcAn4lVAZuLJuY+kt9ID4tcqMq6e0OE5AvbbyqmIXjkykNocqmIm8NKM
         tzew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742589889; x=1743194689;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GEMU6p1y8XG7aTq5OrE99edboR3QeK6rt4oPFIwBxB0=;
        b=k3SviowP559ensyF4k9CGXDygkEHVqfjcmKaT4psyplXxX/rzy7QoNEux0bV5w/5QG
         UF7iKsLX+AtK2c00Zd94m8KEIao7z+e8WmOES4yC5rj3+CGWEoIv5wLCJKipi0ATdqJi
         CzyoqDWq7MeaLyyvhxk9KN0duHOVw2L+HQ6mNrTxs6CGlND3XmLIHedAkWAeZFJCJJMB
         Sn0CtRsCIzjvP1sgAHD46msJHEy9N5PhJeOqurOvBx98SqMsZUbcW7TfTY0reUwszu5l
         HptiDLkrXeQvRW0rqDqo2ymTczm0MqfgQKUD4iLMEfVQaU8Fg0jtTHkXr3Y6hAytLsAh
         PF3g==
X-Forwarded-Encrypted: i=1; AJvYcCUu+zsf6uAiQS7kj9H68Dzn/r0qy0UnOIhJ7w6WTkwFDi5pM4wAS4TZ1TXPDtYHg47OajA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzI3JWWj3J+Zj/7Yf5TsHFvWE1kTTbhfZTplBFh8dD5hDMx5nSI
	Bm6x1Ef72oD4Z1oe25+qiQHEcsODOwFw6zBhg9jfFeyaAlMsYqLEFGLqWQ3z51T+15Kk/prVyFy
	HOQ==
X-Google-Smtp-Source: AGHT+IF09wFzorMUM4Gi7oaYBSS+7g0HTnWRlVNYWepX7kLirX/lzxgzzddN7SGhZH0LCUn3aRIezx8SRCU=
X-Received: from pjbsc7.prod.google.com ([2002:a17:90b:5107:b0:2ff:5fee:5e17])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c949:b0:220:da88:2009
 with SMTP id d9443c01a7336-22780e23fcfmr60355015ad.45.1742589889236; Fri, 21
 Mar 2025 13:44:49 -0700 (PDT)
Date: Fri, 21 Mar 2025 13:44:47 -0700
In-Reply-To: <Z9zHju4PIJ+eunli@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250320142022.766201-1-seanjc@google.com> <20250320142022.766201-4-seanjc@google.com>
 <Z9xXd5CoHh5Eo2TK@google.com> <Z9zHju4PIJ+eunli@intel.com>
Message-ID: <Z93Pv0HWYvq9Nz2h@google.com>
Subject: Re: [PATCH v2 3/3] KVM: x86: Add a module param to control and
 enumerate device posted IRQs
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="us-ascii"

On Fri, Mar 21, 2025, Chao Gao wrote:
> On Thu, Mar 20, 2025 at 10:59:19AM -0700, Sean Christopherson wrote:
> >@@ -9776,8 +9777,8 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
> >        if (r != 0)
> >                goto out_mmu_exit;
> > 
> >-       enable_device_posted_irqs &= enable_apicv &&
> >-                                    irq_remapping_cap(IRQ_POSTING_CAP);
> >+       enable_device_posted_irqs = allow_device_posted_irqs && enable_apicv &&
> >+                                   irq_remapping_cap(IRQ_POSTING_CAP);
> 
> Can we simply drop this ...
> 
> > 
> >        kvm_ops_update(ops);
> > 
> >@@ -14033,6 +14034,8 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_rmp_fault);
> > 
> > static int __init kvm_x86_init(void)
> > {
> >+       allow_device_posted_irqs = enable_device_posted_irqs;
> >+
> >        kvm_init_xstate_sizes();
> > 
> >        kvm_mmu_x86_module_init();
> >
> >
> >Option #2 is to shove the module param into vendor code, but leave the variable
> >in kvm.ko, like we do for enable_apicv.
> >
> >I'm leaning toward option #2, as it's more flexible, arguably more intuitive, and
> >doesn't prevent putting the logic in kvm_x86_vendor_init().
> >
> 
> and do
> 
> bool kvm_arch_has_irq_bypass(void)
> {
> 	return enable_device_posted_irqs && enable_apicv &&
> 	       irq_remapping_cap(IRQ_POSTING_CAP);
> }

That would avoid the vendor module issues, but it would result in
allow_device_posted_irqs not reflecting the state of KVM.  We could partially
address that by having the variable incorporate irq_remapping_cap(IRQ_POSTING_CAP)
but not enable_apicv, but that's still a bit funky.

Given that enable_apicv already has the "variable in kvm.ko, module param in
kvm-{amd,intel}.ko" behavior, and that I am planning on giving enable_ipiv the
same treatment (long story), my strong vote is to go with option #2 as it's the
most flexibile, most accurate, and consistent with existing knobs.

