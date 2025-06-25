Return-Path: <kvm+bounces-50761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFF90AE9111
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 00:27:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BD0C5A3D97
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 22:26:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D4AB2F3C14;
	Wed, 25 Jun 2025 22:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zUK5YvSn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8C52F3646
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 22:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750890419; cv=none; b=KMzQath3TLBiGuGg8GzG6ApEaI/ixknbj0JnltGcaHfBqW+CvaOT0FQj9e30rSRTpR+/PwTXYX9tB0dYTNamri3jn7VH+xER89BkiVkueYpiJwT0L5S229MAF7lMIOmEsUVnYmuvERbAqDpogClTFsCDwyalwBVUXQxSJk1N44Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750890419; c=relaxed/simple;
	bh=rCEDy0fW8FC1f3pY+p+n2EHXqYOi6cxmqAfnynuar6M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dkx20yZdSp2j9b/uqIW0LnldnKUJ897MjQSxjYMUu9lBPQ5+bDZZY1qXZ4dgCPRixNaNr8VTeQTbIgHGRjEJFKGy41IGj54YhmKz9xshgCD+W7LpzegRPdfAF+Z5JQj2BS7SdkQpA1wcauLMBwkmEifJdwPRszT1VLpuGkLfk38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zUK5YvSn; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31315427249so240455a91.1
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 15:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750890417; x=1751495217; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kQ33NEAxiy6dGXROQPYsq2BeSkLqn3m7YnA3TQ3LWfQ=;
        b=zUK5YvSnJB3mEIntxl26CTphVH3KqsaoIdmeMkdG8LrEUz0a4vUrzWAM5anoeIWW+j
         4Ho57JxWhXCvn3D3klCBVQKGp5v+5V0WTKr+4wskhrXGJc3s+bLAwYxU8wscqNI+oquF
         Ma/t1wX+yV3YT2MRryfAqXBTg4B9WXY/MNSG3tDubknP8I8B7x/FnnMdhh51fu4bdt65
         msZ8kuqvFfd5denKmisx//r6wF7L+2qJ5gedmi2ia6Wk0d8xWoYb4PTBalgm5bR8u22H
         Kp9u93BQQuImZUNSatljyGfP1yHMOT1Ng/tLpOdtO5U/0KZ55gJJADQhIkQPaqxw6wRo
         RUiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750890417; x=1751495217;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kQ33NEAxiy6dGXROQPYsq2BeSkLqn3m7YnA3TQ3LWfQ=;
        b=Wi7TsCQE5VALdwKg/GVcBHQUiqI7fLG7hl9DutQXuNYsBZr/ONNEmFUksQRSrwfr57
         3QEzKqdkI1sn4svAPjPCqEyE6X+dANM+r8CiKEkv+jEXIxUw8DgjqsxWse6Mtnvl0yK0
         48ECqZPKMIx8nKEbj39+PVJDrRgQLD6LFnuA79MoSYtt9UX75shru/lox7fMTrylRtKu
         TskhoAE/XxeWZsnniC1eHdgsI8C9+IioHxNU+poYk62obTq0CCIkj9DtydPFVdlfZFbX
         zdM1oYH3KDp9B5dFrwgg7CwkEnTjPF4LnxoOqQmKISFPXrCEOlw0EPSg0B5hvjljJtFB
         EXSQ==
X-Gm-Message-State: AOJu0YxrCHePYE2RjqCstccLu9t2655We9kGeoC/r8Xf74S7eGbE89tH
	LDBlQaHBhzvUz67N01hq7HPHKEno2O3NBz9oloRFeO4IV4ltRLObUnhat8QPOfqKXKgSOExjJYG
	RyikJSA==
X-Google-Smtp-Source: AGHT+IHiQUpPpcCXNH4t8rkH6lkA4oXVg34reWFcVeyN+A0kZ6FPQXLgBh8hajKcmoG7/M9PHJB8uy+T1Vk=
X-Received: from pjbpv1.prod.google.com ([2002:a17:90b:3c81:b0:313:2d44:397b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c08:b0:313:2768:3f6b
 with SMTP id 98e67ed59e1d1-31615960decmr1752060a91.27.1750890417636; Wed, 25
 Jun 2025 15:26:57 -0700 (PDT)
Date: Wed, 25 Jun 2025 15:25:37 -0700
In-Reply-To: <20250523011756.3243624-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523011756.3243624-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <175088969830.721563.9184862048308832493.b4-ty@google.com>
Subject: Re: [PATCH 0/5] KVM: VMX: Fix MMIO Stale Data Mitigation
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Borislav Petkov <bp@alien8.de>, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 22 May 2025 18:17:51 -0700, Sean Christopherson wrote:
> Fix KVM's mitigation of the MMIO Stale Data bug, as the current approach
> doesn't actually detect whether or not a guest has access to MMIO.  E.g.
> KVM_DEV_VFIO_FILE_ADD is entirely optional, and obviously only covers VFIO
> devices, and so is a terrible heuristic for "can this vCPU access MMIO?"
> 
> To fix the flaw (hopefully), track whether or not a vCPU has access to MMIO
> based on the MMU it will run with.  KVM already detects host MMIO when
> installing PTEs in order to force host MMIO to UC (EPT bypasses MTRRs), so
> feeding that information into the MMU is rather straightforward.
> 
> [...]

Applied 1-3 to kvm-x86 mmio, and 4-5 to 'kvm-x86 no_assignment' (which is based
on 'irqs' and includes 'mmio' via a merge, to avoid having the mmio changes
depend on the IRQ overhaul).

[1/5] KVM: x86: Avoid calling kvm_is_mmio_pfn() when kvm_x86_ops.get_mt_mask is NULL
      https://github.com/kvm-x86/linux/commit/c126b46e6fa8
[2/5] KVM: x86/mmu: Locally cache whether a PFN is host MMIO when making a SPTE
      https://github.com/kvm-x86/linux/commit/ffe9d7966d01
[3/5] KVM: VMX: Apply MMIO Stale Data mitigation if KVM maps MMIO into the guest
      https://github.com/kvm-x86/linux/commit/83ebe7157483
[4/5] Revert "kvm: detect assigned device via irqbypass manager"
      https://github.com/kvm-x86/linux/commit/ff845e6a84c8
[5/5] VFIO: KVM: x86: Drop kvm_arch_{start,end}_assignment()
      https://github.com/kvm-x86/linux/commit/bbc13ae593e0

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

