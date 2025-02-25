Return-Path: <kvm+bounces-39123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4752A444A3
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 16:42:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 963178600C5
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 15:41:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE51A15852E;
	Tue, 25 Feb 2025 15:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lvpEHwrX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A096E14AD0D
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 15:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740498077; cv=none; b=X9KbbDxqAPCCs+DJW5IvUHuNIbEGR8GMrXq9R13gwo6KOW0DMR5p8KMK1l3dA8xrFr9i45HmWIxvycLNSq/JeKh/qBQHBGW3jyTzbQ/dmeOCpr9gAd7vjYjRq63OJjEFJpapxWCge9zO9+KSp7OHNCEq9sVXWsH6HIGvWYfKlAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740498077; c=relaxed/simple;
	bh=h0k6Bw8oebc5YQIbZ75hirrCib3mxXfTLg5zcaiUPQU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ezeq8L2k8CcahKqsVzDXTSS/eL9lrrQXMwXM9OkbkL/iXvY6CxTJtI2vcykKHcJRFXRD4ZV51a+9YWrKjQiZxuxe2Mbznk/q+modkYiq3HNadCwQPe8aw4V3mMnzPZxs/UpUV33MEcDfBKUrpdU9ktnTHZOMTaoMzA2pGeAvFJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lvpEHwrX; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc1a70935fso12005518a91.1
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 07:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740498075; x=1741102875; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9gith30kTBfPn10AwyFeCKv7JIoJKUJTfhcaJAgn5H8=;
        b=lvpEHwrXZMafR5bjJMMb/R0J7wbSws4Ye2WMk1fS+rUsdeN7iGm8r7jJsWa+4G+xoU
         Sz5T5bjLekDkQtOPdVnzZSHB96XbjTGvPeuQOv0BkT9rg3A2RejXPFEHNzp5zKaGhZEE
         ai+QMEI0cNmJwsv7CcO7O9wMkLRTBt9TCVAFqt9DibPPwcadBut8WasGHIZAejgbEiv1
         eQ2z10bP+q9CDsnLIoPnS2VwmEwIQ5HxaW+s2TD/YvXzk+94xLq70MyfJmeL4R6/l/Vf
         qRd64KdU5RGPoXUkqEXVzeF5bvhWqWHqTZFyF4IH0ohtDAvkmXo9oLsLxssjMFTlIPz8
         ABDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740498075; x=1741102875;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9gith30kTBfPn10AwyFeCKv7JIoJKUJTfhcaJAgn5H8=;
        b=UvOFU9kTyW+Qt1I1EpxmDwb2yZtCY36/9KOmUX/im5XhVMnfMe7M6IYb9u6B6SB7qE
         TTNz8E1QKPbP0aBL42c5tP9qQwiS+0l26sbcpXQmeFE5MER3CyW25rlWsakQq4dTkfJn
         7C6ucu0HVsI4vgpdO5h/SfJXy3mUW8uDk/Jy8YyP6Ohn2ZHwjLT63fEv4SphRR3pgNHD
         PGMn9etKs6qLWGfA6DovALiViXbYL/kLJ3aerIn069MVbq00/gfr5iUZ1QBREUNq8rrF
         9pMBpcpRkf2TQKdAPibDjt4oNPRnnt6eYas7pHVogBgCtfAG8A+ZARb+pStKmWc+Gy6B
         94ww==
X-Gm-Message-State: AOJu0YyZO/MQAU2rbCpESCg9hgqDfDGcJRIhpvuSVocntCeWCyDiHbSB
	u771v+vTNPeM/8iK0ZiLhqq93RJ95TM9YqJ4hiopcZ/ixfUKs1Y3ggUk1OkSArtyooCIleLunV8
	a3Q==
X-Google-Smtp-Source: AGHT+IGZkp+roO0TVp3rz40ka6O9p/N9EvFel5/ggMinuedWjO6jtk5+r13X1rdCPxFnx16CfV0N9Na/IiI=
X-Received: from pjbpv16.prod.google.com ([2002:a17:90b:3c90:b0:2fc:11a0:c53f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e4f:b0:2f1:3355:4a8f
 with SMTP id 98e67ed59e1d1-2fe68ac94a8mr5754618a91.4.1740498074970; Tue, 25
 Feb 2025 07:41:14 -0800 (PST)
Date: Tue, 25 Feb 2025 07:41:13 -0800
In-Reply-To: <20241001050110.3643764-21-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241001050110.3643764-1-xin@zytor.com> <20241001050110.3643764-21-xin@zytor.com>
Message-ID: <Z73kmRwZFJJAVkiZ@google.com>
Subject: Re: [PATCH v3 20/27] KVM: x86: Allow WRMSRNS to be advertised to guests
From: Sean Christopherson <seanjc@google.com>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org, 
	peterz@infradead.org, andrew.cooper3@citrix.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 30, 2024, Xin Li (Intel) wrote:
> From: Xin Li <xin3.li@intel.com>
> 
> Allow WRMSRNS to be advertised to guests.

The shortlog and this sentence are incorrect.  Assuming there are no controls for
WRMSRNS, then KVM isn't allowing anything.  Userspace can advertise WRMSRNS support
whenever it wants, and the guest can cleanly execute WRMSRNS regardless of whether
or not it's advertised in CPUID.  KVM is simply advertising support to userspace.

> WRMSRNS behaves exactly like WRMSR with the only difference being

Nope, not the only difference.

  WRMSR and WRMSRNS use the same basic exit reason (see Appendix C). For WRMSR,
  the exit qualification is 0, while for WRMSRNS it is 1.

And the whole reaosn I went spelunking was to verify that WRMSRNS honors all MSR
exiting controls and generates the same exits.  That information needs to be
explicitly stated.

I'll rewrite the shortlog and changelog when applying.

