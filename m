Return-Path: <kvm+bounces-63206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 678E3C5D2F6
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 13:55:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B6146352D20
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 12:55:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E02C24503B;
	Fri, 14 Nov 2025 12:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sXI29/qw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1E42147E5
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 12:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763124913; cv=none; b=TssadFzAuOPhh3zCl7jLWgU2eM63DWFFkDEH5xVdY+Tlb4vkYEpVWSsne9BohvCHytbxcfq8R0TtM2AhdHzzLhaM/KdNUDYq9mcjHSWywEThIszoc92MUpxkwbB53aku6MbATtv0u09+ElxzSYa8boyhyXiztuhQHAtPixgjgS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763124913; c=relaxed/simple;
	bh=sySqVUk457bLkhWa1tebcUxVXEN11B88TtIPHU4/kCA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=phhuDvCkPdsRcBvK3fxSt9MD7Aif+4IjdfJuTxswlvKnMrVc1LgfuzJq85cN+I1qDFj8vNN2kXE1f03gCIS6cLqeyNnP9kVIziBBq2kqRjaqTccVSiqbbgVRjPYSzX6JqSQuMBRi+jhyLMZ5991rjEFj/BALaRGrPzyl85i7upw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sXI29/qw; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b73599315adso120117566b.2
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 04:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763124910; x=1763729710; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2HxCD0Qsgw0zxEHnyBGjV1RcHkNO4co8KVcOu35c6Ak=;
        b=sXI29/qw6RAfNMYnl56IGo1Ub/R2UXNbQO1TduF6XrGZxARpDplXkNp9nhUCjVHV3/
         kDtUQtgLQaCWKeyZoTSrex+QsqQxd/3z8H57j3Yzhvr52Rj4Hr04LioQ5ZjQfigqgAQE
         S2UixjlQylfxdhtHsWDvpuwQHRRXtrzJhzvGKOuHec297Dm4RV7WZkcuIZ2zFTNLQAoP
         DHEtfBu6f46Zj+6IEytXkE8D3pJtZF/L/WbzNIWFremtiB/5CDGso7ItZCo9XKvW/i7o
         cM2T7NLtB6hPpCIR1eQtwBHDmKQ+/7xU6Avpwq6dFRsPxL0EddHVsnXKrL7xtGI9LFy1
         4W9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763124910; x=1763729710;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2HxCD0Qsgw0zxEHnyBGjV1RcHkNO4co8KVcOu35c6Ak=;
        b=VRZBkwRA8fr+cnYjqYgsOvQBi5+couVTsN3Lj82Djh9bGh5FKbfcHA/LSPoK6YmvRV
         ljwtEnhMyuK2O6iEWv2do4NSSVVsCkO8AYXAEbsyXvLaaXVMzsrBR8Z10uBYntbNYexr
         3pXR+JDFGF7PSGsVTiuQmNphcL68uPhITJ4PFqdJIPwoygdCI1ZvGgrMlx+pY8P4pmh4
         cEKiSxxSKF7MAcMaUb3TQVbuI18gAol6Od3iyy1BCuXzwkuBp9pvhBkWdfhq0x4yaiqf
         NT2yupXIzMCxaz/1q9jc6BRHUy+n8bVcIeI0devId4ev4m0ZWuhaddeoTZVGv3M7zmYA
         CiSg==
X-Gm-Message-State: AOJu0Yxs/WxQByClYTYCyRTILc2kgXYFayEl5bAC+JDCYSmttc4ZNq5V
	gZPRkSJSiL1EfrTHOzuTgjulP87Zh0XI91h6TWCvn1cfR6tGcOEKJ6F7EjyAN91hF7LbESw+y6E
	NXXGzE7fkphkaNA==
X-Google-Smtp-Source: AGHT+IEYjPBWhz3rzNNbkakQj9ptp4kfVtNX/+ZocC5LUv3BmWKToHZPCwYhsFf7lsQT6XRasLB0eZNdlcjtJw==
X-Received: from ejctb22.prod.google.com ([2002:a17:907:8b96:b0:b72:41e4:7562])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:f299:b0:b73:6d2f:4bb8 with SMTP id a640c23a62f3a-b736d2f577bmr150843766b.2.1763124910000;
 Fri, 14 Nov 2025 04:55:10 -0800 (PST)
Date: Fri, 14 Nov 2025 12:55:09 +0000
In-Reply-To: <20251113233746.1703361-6-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113233746.1703361-1-seanjc@google.com> <20251113233746.1703361-6-seanjc@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DE8FM9N4GKKL.1ZXGVZA48O31X@google.com>
Subject: Re: [PATCH v5 5/9] KVM: VMX: Handle MMIO Stale Data in VM-Enter
 assembly via ALTERNATIVES_2
From: Brendan Jackman <jackmanb@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>
Cc: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

On Thu Nov 13, 2025 at 11:37 PM UTC, Sean Christopherson wrote:
> Rework the handling of the MMIO Stale Data mitigation to clear CPU buffers
> immediately prior to VM-Enter, i.e. in the same location that KVM emits a
> VERW for unconditional (at runtime) clearing.  Co-locating the code and
> using a single ALTERNATIVES_2 makes it more obvious how VMX mitigates the
> various vulnerabilities.
>
> Deliberately order the alternatives as:
>
>  0. Do nothing
>  1. Clear if vCPU can access MMIO
>  2. Clear always
>
> since the last alternative wins in ALTERNATIVES_2(), i.e. so that KVM will
> honor the strictest mitigation (always clear CPU buffers) if multiple
> mitigations are selected.  E.g. even if the kernel chooses to mitigate
> MMIO Stale Data via X86_FEATURE_CLEAR_CPU_BUF_VM_MMIO, another mitigation
> may enable X86_FEATURE_CLEAR_CPU_BUF_VM, and that other thing needs to win.
>
> Note, decoupling the MMIO mitigation from the L1TF mitigation also fixes
> a mostly-benign flaw where KVM wouldn't do any clearing/flushing if the
> L1TF mitigation is configured to conditionally flush the L1D, and the MMIO
> mitigation but not any other "clear CPU buffers" mitigation is enabled.
> For that specific scenario, KVM would skip clearing CPU buffers for the
> MMIO mitigation even though the kernel requested a clear on every VM-Enter.
>
> Note #2, the flaw goes back to the introduction of the MDS mitigation.  The
> MDS mitigation was inadvertently fixed by commit 43fb862de8f6 ("KVM/VMX:
> Move VERW closer to VMentry for MDS mitigation"), but previous kernels
> that flush CPU buffers in vmx_vcpu_enter_exit() are affected (though it's
> unlikely the flaw is meaningfully exploitable even older kernels).
>
> Fixes: 650b68a0622f ("x86/kvm/vmx: Add MDS protection when L1D Flush is not active")
> Suggested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Brendan Jackman <jackmanb@google.com>

