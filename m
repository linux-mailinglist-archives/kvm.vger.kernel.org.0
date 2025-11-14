Return-Path: <kvm+bounces-63204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id CCF31C5D26C
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 13:41:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 2831234EF02
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 12:36:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D12F81D416E;
	Fri, 14 Nov 2025 12:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZI3vMx+H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768741BD9D0
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 12:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763123766; cv=none; b=T/OOtI+OFCry76TC18lrjtvyo0uuzcT9J/EZELT00HF92/3aTyo5PC33LbMpblE2lqsF613ldHCKs392/ebpbh3QsPxInQ5mWhBvPsyY6G1OYnBHvdLGoMv0cMES5gzXoBDmxvTUEUxUddPQXUz2ndi18joPGBeF1OI6M5bLfgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763123766; c=relaxed/simple;
	bh=pb+XJxf3HXvKaX5z4y1PCaJW1hWXAgYv2XerDSO3e10=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SVgAwP+zu+rljDaI7uydWVX6izct0VTa/UDUJb7UQWyCicgEsZppAAfXu9Sh2PAGe3vZTOPSHssxcCxwy4Q1dEwDNosShuUNy+J+LTAtDKseQ8nRh3FLLQYImrbg/eQhZ3P7k5ztTBzjoXBJTev4FeMZgVkjRmCkaUXERtT3pUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZI3vMx+H; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b72a95dc686so155159566b.3
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 04:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763123763; x=1763728563; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p0aEtq9fpAAc1Rcq48X2i8Zfvwd7K0ErmVrQAGMecdw=;
        b=ZI3vMx+HwdxTECifPDmDxIQgiaAB34o3VTdvM4Z1CZnFkPBZJ32HaSVT0swyORzZQw
         p2XroeoRhMd5kavaQTeNVIZGtW1SZPL8uFl9jpK4zLYjZ/GXwVjEcKR66CaDxNuqXngC
         Hv32BFeljUyZM98iLsxUmaGTiDp79aKXPq32ueWiAPutZQzZKXeoeqQW5dZm3ww++LiV
         E1KVWEcwxRX7WtpOrhgLAzxCUcB5MJTQ9am8fhTKl+ikaYdiFJMjglVGGP2HyFyqRUN6
         7o6B3J1HWeRjI/zOlS4fgJi0E0bcNdJLx5wX48taxSSsuWJbowGHucU4M7zQlKjNl0yE
         M+vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763123763; x=1763728563;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p0aEtq9fpAAc1Rcq48X2i8Zfvwd7K0ErmVrQAGMecdw=;
        b=DPfTfpDh8VcVMbTTbueh4+bAu9gnOLWuuQgEHKsbh/la37eHbSVSIHxkK4NGzuf866
         iWbYE6+Twpz/AfP+2SXPsmn7TxN4QmToMMdWWqMFZQzLRTmcTX69v+a6vCYvJ+GJDRg1
         LOXqrNmu0I/3U/Fq/ZY6r5louV/O4XV9yV/fXIpQ4jWqu2ajVLD95SF6nUyC9YgfUpT6
         I8MAAPtfJUYnJlAVi6fhDbTnxxtgpThx8yN83h/eqv7FqZhHTtgrBevsoepltB6MWwJQ
         7vm6GBFl9y17ytc5RJY18MFXf4+TuJj1keKsZTy9CeRM1P/33Cmg6lFYlv4cH2RuR61C
         B+6g==
X-Gm-Message-State: AOJu0YzKCL8znScBiEOTu11enRualVIIx8qJ1ntu17JdpSU1giXc/WVq
	gqC8MBd7Fb863C12/A0pS+vLNJjiL9DXbY+A8/Dnbi1BWHbxahTWI/92qmEEpDqMojI+aq7kyZ1
	2XVb98idaRIRnUQ==
X-Google-Smtp-Source: AGHT+IG3C7rwSOYPAJ/6aX/rxgkbjZav3E88HPyJ7byhfiu/KauLJOfo21yD5QgFI0fjQOUkM5395YPmlFWjzQ==
X-Received: from ejckp14.prod.google.com ([2002:a17:907:998e:b0:b73:737b:c33c])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:338d:b0:b72:58b6:b263 with SMTP id a640c23a62f3a-b7367961de5mr198500666b.60.1763123762691;
 Fri, 14 Nov 2025 04:36:02 -0800 (PST)
Date: Fri, 14 Nov 2025 12:36:01 +0000
In-Reply-To: <20251113233746.1703361-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113233746.1703361-1-seanjc@google.com> <20251113233746.1703361-2-seanjc@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DE8F7MGETJP2.K6A8JKD8LV4A@google.com>
Subject: Re: [PATCH v5 1/9] KVM: VMX: Use on-stack copy of @flags in __vmx_vcpu_run()
From: Brendan Jackman <jackmanb@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>
Cc: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

On Thu Nov 13, 2025 at 11:37 PM UTC, Sean Christopherson wrote:
> When testing for VMLAUNCH vs. VMRESUME, use the copy of @flags from the
> stack instead of first moving it to EBX, and then propagating
> VMX_RUN_VMRESUME to RFLAGS.CF (because RBX is clobbered with the guest
> value prior to the conditional branch to VMLAUNCH).  Stashing information
> in RFLAGS is gross, especially with the writer and reader being bifurcated
> by yet more gnarly assembly code.
>
> Opportunistically drop the SHIFT macros as they existed purely to allow
> the VM-Enter flow to use Bit Test.
>
> Suggested-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Brendan Jackman <jackmanb@google.com>

