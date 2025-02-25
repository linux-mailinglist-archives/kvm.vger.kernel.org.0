Return-Path: <kvm+bounces-39169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ADA72A44BC7
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 20:48:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC552420849
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 19:48:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1F0220D513;
	Tue, 25 Feb 2025 19:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WLRVPjjZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A971DC9BB
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 19:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740512877; cv=none; b=mSQCxVLLp1pTyim32Jb4u8ow7ae94LNRGRTcRutDjbyys7IHUriz3/D3lotsSosXaTjU3OnHhJ5U5kQX2Hw+I8L7jzKoik/3rojdeoJ8SHwYe8VAzvosjgxGo0qEEXG2k4EcX7ghi8kVKPie6U542V8g+qRSfcwTF9bx8ZetBPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740512877; c=relaxed/simple;
	bh=6qCdJz4B+2z2Px4qOVSRUC7in+OKQIKekBClkmwavY8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T1WQ20mRhqd+b/Fh9HRVjRkm/8KXfbGuZBRm84kU9UBOj+T+ZwAivJBLOx4gVvoti0qXTplbsP4nDjNSp1goZNeNmrlMz6WOFWJ0YuKev0KAWq2nchs0jRbGnZVm2pPNE7PUQmLakUWb9zxyWwS1WQVdWCQunkT/o0tEW+yUD1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WLRVPjjZ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc4fc93262so12866917a91.1
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 11:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740512875; x=1741117675; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y78W5TbVqCuEDrDaoAlNFzvev5wkePUo+u/A7Uw3WAs=;
        b=WLRVPjjZClktOnR3mVoK323+RasFm/ojvF0y1tfoNnRfxgHINq8ri4FRM5f9pyIoTX
         O+W4+vns4K5d3rqJMuuEtTUxALI71BFHd3vipi+dimdCl2kd8sOUdtm/WrPOQ6OH5NbT
         Vob8wyu7gWF1HRrINh5V0mpK343BytjEr2vL8oXVHH+Gnngkv2ZtHry9HVtxWiaRUB41
         wzklAaH7t2yRvrnd1XrTwzMNIkmmMqpYtlu/Fh2Dd58sF4qwpYC4Pf6ltjQ/GYo1I5e3
         PMbqcuG16GbBMYRkY1pRQs+dsc4jQJc8ibZnn8EiJmygJI9PLD8U/dq5+aBAnB8QLzLz
         y7qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740512875; x=1741117675;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y78W5TbVqCuEDrDaoAlNFzvev5wkePUo+u/A7Uw3WAs=;
        b=C8YrA3g3s4rVXSmeQxmFmgqTVzX19eZgRcv9djwogQuB9UPbwMbtc86MjCfgfvXlqp
         ORaImCekprn3jZBPl6B7J2xYyOBux1C4SoiQ7uS4UdRFkhOOa51gMWmYEIMK09gmAiOa
         JA+N2dBCYdkrTHMQwWWarc0ezaFMa1gXNM/L4B4xF2x4r/OdLQn+0QIN9HlhwVoB4vHJ
         O7xKQk1/DrRbXGbuZuc8dHsnz+h7GdwEKNKbtsQRf7Lls8dxvkI3RMt/u7XUWSk0bXet
         jOSh1FJ2u7tLJCiZqd5Dl9E0BZvUENkUqoQ9sMFJ+Wo0ahbD/9xdFyoAJzKtkxh6P7++
         lsEw==
X-Forwarded-Encrypted: i=1; AJvYcCUG2IPySLBR0nzSvHnIdan53MYDUCntalaODU3cmVVr4n7bRvjJFrx8bpqv3dzSxU89YhA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHDMAyao1Q3rvrKJ5HzN8pwLLgu04/EoGGEHTsWpl4TDJR37I7
	vDUrWfVL2l5lpcn8qW6y0P4hpyJQDjI9IDgfDffH4NdR/Od7Mfzf2/36i8TlHoLWEIkB39T2eOc
	pmQ==
X-Google-Smtp-Source: AGHT+IEEgLN5F1SoLE3ebL4WKG9OHMPRtlKdbeTcRThXQ9v7WzznZ0dUT9yEAWY750vCq7jSTBxQdPDCfQ8=
X-Received: from pjbqn3.prod.google.com ([2002:a17:90b:3d43:b0:2ea:5469:76c2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:524f:b0:2ee:b2fe:eeeb
 with SMTP id 98e67ed59e1d1-2fe7e36c761mr817940a91.22.1740512874967; Tue, 25
 Feb 2025 11:47:54 -0800 (PST)
Date: Tue, 25 Feb 2025 11:47:53 -0800
In-Reply-To: <20250219220826.2453186-2-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250219220826.2453186-1-yosry.ahmed@linux.dev> <20250219220826.2453186-2-yosry.ahmed@linux.dev>
Message-ID: <Z74eaeYm_EgHbmNn@google.com>
Subject: Re: [PATCH 1/6] x86/bugs: Move the X86_FEATURE_USE_IBPB check into callers
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 19, 2025, Yosry Ahmed wrote:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6c56d5235f0f3..729a8ee24037b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1478,7 +1478,8 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
>  		 * may switch the active VMCS multiple times).
>  		 */
>  		if (!buddy || WARN_ON_ONCE(buddy->vmcs != prev))
> -			indirect_branch_prediction_barrier();
> +			if (cpu_feature_enabled(X86_FEATURE_USE_IBPB))

Combine this into a single if-statement, to make it readable and because as-is
the outer if would need curly braces.

And since this check will stay around in the form of a static_branch, I vote to
check it first so that the checks on "buddy" are elided if vcpu_load_ibpb is disabled.
That'll mean the WARN_ON_ONCE() won't fire if we have a bug and someone is running
with mitigations disabled, but I'm a-ok with that.

