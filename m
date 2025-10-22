Return-Path: <kvm+bounces-60792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B9ABBF9A9E
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 04:00:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 62F304F73D1
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 01:59:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 380CD221F39;
	Wed, 22 Oct 2025 01:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o6AtbdMr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9F62153ED
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 01:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761098360; cv=none; b=qDeCISrVp0imeooukK3VYwriYC2VbcMPlvzOCuv7tjrOk5tn41XkAzP2BZVum/CN0FRW74TcX4F6+x5d9XXTTgGxXJgHA9i4kS34q9okK/lcMyBqqQrzTb+BFDduGW4h15dtBFV0RJ4bKE6mrgL2bJxPCw8wOIBO6y3xCdKG9+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761098360; c=relaxed/simple;
	bh=my6jM66k0jAykJ5fn34wUbuyUuTp5JVAwrDiOt+08OY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Jki8SoFvnHCamOSXCz8X/Q0LAigFwW7WV58UMY/oLBcu/m5LajMXxqEhAsiaxPG9E+TOB4LTbquiCWxDkF8ui1lb8/kp0ri41pN3KzeG0qQl4I2Bi6Bp8/71whN3dvpdXAjSVA9gNon4xa7dcdxb40GbfPzX8KCmJz+ZCk9Bh6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o6AtbdMr; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-471001b980eso38126175e9.1
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 18:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761098356; x=1761703156; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=my6jM66k0jAykJ5fn34wUbuyUuTp5JVAwrDiOt+08OY=;
        b=o6AtbdMrLdnbxec/1F7tftn4N5XSwSbRWgzpEdSo2QGkWGCPZHg0uSRhTBDZ89F2ut
         KICq3H0HYAMcgN/RGZlcyxhYFgwyxVYQ62J6CDlFpzt3UzY9e4FlhmXsbh8JCqIzvUzC
         p87oxadoXditrG0nJxOZJM4OA5Zq04XIN/7zgxEV4EqR1aR2ixAOZeKITq7YZfq9SzHq
         Lk7q6XsrZ58/WN0Q/olKvPkHB9KGmhTZaAzO629h9Z/cxaF9TQBb0/cYpE28M2Q4Lh7y
         tLpYv2gKQErc21x/rk9VthFtL9rW4cxj+0rE+arnVHnpKoOU8sYK3MkCDI/Pu7+il9ku
         7dWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761098356; x=1761703156;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=my6jM66k0jAykJ5fn34wUbuyUuTp5JVAwrDiOt+08OY=;
        b=Mhh5YB7lUoeogzb6KD1y0VzgWph28KgY4xGMCoP/ElPmSbp68XPfwyWoXUPa0h2mzb
         i4lepKQe+hrvGNOgPKaiDaCrVKGCmw/sxRA8dwyFuUSFZRpd91EmoNspSHX1mTEuxnmH
         wY0PfPQweenuDns4kLR4YCv1fSPvJiImnLtXkuHC66LtBoUBx1dAjcXBda51wehsv3qn
         Q2nglhG2vc1uViqA2Q0WhIh8SSzjUcFdl7AVS7CSjA4TrhcAcHAvNXsdBONOEtMlLZcB
         DSCJ7z3jSaSU9k3WqEufB+Arec/tPBmIbJhkouybyEPA5fLwinnklwH3tZHUrLMw9VkT
         OUqQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVdXnmI8fZVZJRGlyppPm2+NtCzO4J/erd+QRPgEyLivXq2aO6fYGKh2isPRkIPnHAmts=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3t+dhs7TJfRdDodQrVuuxXpJ5KrMvEQECtFtYGwuYLxDyxBWG
	4B3NUzI+eb7vpnXEB1eglhAO/YFZ2KToQH9g3ifUgAdhrqtNjmPh81RV1xG9Jio/mrg5JryCAIe
	UA4t3+k8tmFuSkw==
X-Google-Smtp-Source: AGHT+IE/oCQsMYzx1rex8dYGNDfqro8LN08+zz79um+90oggdhJzVWtC7CJMrU/PaQ7goXMXGcxJJ1VhAO14Vg==
X-Received: from wmor20.prod.google.com ([2002:a05:600c:4594:b0:45b:6337:ab6b])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a4c:b0:46e:37fc:def0 with SMTP id 5b1f17b1804b1-471178a23c5mr142886075e9.9.1761098356694;
 Tue, 21 Oct 2025 18:59:16 -0700 (PDT)
Date: Wed, 22 Oct 2025 01:59:16 +0000
In-Reply-To: <20251021231831.lofzy6frinusrd5s@desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016200417.97003-1-seanjc@google.com> <20251016200417.97003-2-seanjc@google.com>
 <20251021231831.lofzy6frinusrd5s@desk>
X-Mailer: aerc 0.21.0
Message-ID: <DDOH9JW22RZ9.3BMRT1XHHJAVL@google.com>
Subject: Re: [PATCH v3 1/4] KVM: VMX: Flush CPU buffers as needed if L1D cache
 flush is skipped
From: Brendan Jackman <jackmanb@google.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

On Tue Oct 21, 2025 at 11:18 PM UTC, Pawan Gupta wrote:
> On Thu, Oct 16, 2025 at 01:04:14PM -0700, Sean Christopherson wrote:
>> If the L1D flush for L1TF is conditionally enabled, flush CPU buffers to
>> mitigate MMIO Stale Data as needed if KVM skips the L1D flush, e.g.
>> because none of the "heavy" paths that trigger an L1D flush were tripped
>> since the last VM-Enter.
>>
>> Note, the flaw goes back to the introduction of the MDS mitigation.
>
> I don't think it is a flaw. If L1D flush was skipped because VMexit did not
> touch any interested data, then there shouldn't be any need to flush CPU
> buffers.
>
> Secondly, when L1D flush is skipped, flushing MDS affected buffers is of no
> use, because the data could still be extracted from L1D cache using L1TF.
> Isn't it?

This is assuming an equivalence between what L1TF and MMIO Stale Data
exploits can do, that isn't really captured in the code/documentation
IMO. This probably felt much more obvious when the vulns were new...

I dunno, in the end this definitely doesn't seem like a terrifying big
deal, I'm not saying the current behaviour is crazy or anything, it's
just slightly surprising and people with sophisticated opinions about
this might not be getting what they think they are out of the default
setup.

But I have no evidence that these sophisticated dissidents actually
exist, maybe just adding commentary about this rationale is more than
good enough here.

