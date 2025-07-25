Return-Path: <kvm+bounces-53489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 98137B12684
	for <lists+kvm@lfdr.de>; Sat, 26 Jul 2025 00:10:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BA84188C5C8
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 22:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49648266581;
	Fri, 25 Jul 2025 22:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G4fNtPxw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178C1256C9E
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 22:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753481258; cv=none; b=GN9/yxgH252V0512UBo46JkIINvP3ydnjTDWJQnb2F59HB6wh5JGPghWQ8zwioIuKxL+Hgs/e9HaJuCF/YZV13s/A58owWW1BPtH3ltis2fn41bS57Pw3pwAYvJ2x/ewjM9JZKSdPZ1vLo2m7AFzu1FL78qD1tPqjxIIJhglFNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753481258; c=relaxed/simple;
	bh=uU7dFxdk8Ga9xT5eBqeVvqC01BSeAFVKWhtGF0xmxlE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Cqyqyq12Uzm5XzyW/4ZqKANwmWBHUlJ6Yn3xnegy+hUIUhKkptc70G+Oo/NlNfTM85t2u8ZBRWYOXnoEkPOI6MCJ3Ck0+A6NV5JxBc5UQ0JF4G8HWyiV0Mw9T1klxG/3UcAmA58xTPbwUciJNwV0KoWAE/NVvOsa7HVbNHZhZFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G4fNtPxw; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-313fab41f4bso3932715a91.0
        for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 15:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753481254; x=1754086054; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GFNXAS8Lbcqvs86Isyi+mtcocLA1jl1GkLu5ycU1qo8=;
        b=G4fNtPxws40/miRC5LbQRuYMNbZ1e/jyOHr06rqPQaca/XDENo7RjEZaQ2DzEnoRg0
         8YlOwKjgpo0EJd38se13wYh5HJ4hrnF/Dmt8G9WdbjxYXabum2aJsOfHKW7Wqj3N6xqn
         sdo4ftfrQ2JOpIDV34masoMRik6jVj08E18Bj+bM6aHKJ7BZI3mVHUVyqUbNSubI5OYF
         rZNRoSMKOcSkaIiy1VzDmX4XN/vOmRQbhrYy0E0wPn/chadIC9ad8BwZwRgTeivWYF63
         tjGEfdkTQGqhIFLs5YGX1TIIfHMuLeyjhxf486HrswQmysBHpmyJVlEoZ0cVKYWNb6pD
         AudA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753481254; x=1754086054;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GFNXAS8Lbcqvs86Isyi+mtcocLA1jl1GkLu5ycU1qo8=;
        b=PCi5pVVkGqJy20EWh+FbdSkBTrzSpfM88QPLQIxe+9DO9VdNFh7KAxH1hYiP3epcrw
         58tvd9OOdFSd/FPEI2a94TqSO/f2MedExAxfJDAoxLFnupEnxdDqigupiITLyahPQjql
         uR7GHUZv3TGsHnec69wAvz3NMFxv4u0C0C5sUzLVdxXTxD19zCCM8JAir3fcT5LErFOZ
         ss+LoJnWoU0PolRd9/76j/pgTYFSaTe3atsAHyDKdNzT6PzE5pO0ld4ZTmrJSQxyJKT+
         aGgBDpBTodGtydLZ21V9i65GMvFxh4fBNSP4ooY47A6PMnatS0SrjluPjzDjp9x8G9de
         ic6w==
X-Gm-Message-State: AOJu0YxBhWRFQeNOgAwzkANvfp+fQRxr/K/MB27jz4mLkQ3CtGC93Myt
	t1zKseAQSvEdrOTEqzjtEIzR3+VSpqWL2nDbecdqYLPTlNdIofuwtPCSElWazedvQqT24QWM4Ry
	UTugZyA==
X-Google-Smtp-Source: AGHT+IGUDAxJPniiNHYT9xMmpU1vDZ+wO7K+rtWC0W4J92T07oUlAvwj2JBae6YfMFS5vFYDwTeLzMsPg0w=
X-Received: from pjbsv14.prod.google.com ([2002:a17:90b:538e:b0:31c:2fe4:33bc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3bc4:b0:308:7270:d6ea
 with SMTP id 98e67ed59e1d1-31e77a2483fmr4839394a91.30.1753481254391; Fri, 25
 Jul 2025 15:07:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 25 Jul 2025 15:07:10 -0700
In-Reply-To: <20250725220713.264711-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250725220713.264711-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250725220713.264711-11-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: SEV changes for 6.17
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Note!  This pull request is based on tags/x86_core_for_kvm from the tip tree.
Unless you merge that first (I don't think you'll do that?), merging this will
also suck in:

  4fdc3431e03b x86/lib: Add WBINVD and WBNOINVD helpers to target multiple CPUs
  07f99c3fbe6e x86/lib: Add WBNOINVD helper functions
  e638081751a2 x86/lib: Drop the unused return value from wbinvd_on_all_cpus()
  1d738dbb252f drm/gpu: Remove dead checks on wbinvd_on_all_cpus()'s return value

Holler if you want the full diff stat, or if you want me to handle dependencies
like this differently in the future.

The following changes since commit 4fdc3431e03b9c11803f399f91837fca487029a1:

  x86/lib: Add WBINVD and WBNOINVD helpers to target multiple CPUs (2025-07-10 13:30:17 +0200)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-sev-6.17

for you to fetch changes up to 6f38f8c574642a822f2e85f079fa29a49176c49c:

  KVM: SVM: Flush cache only on CPUs running SEV guest (2025-07-14 15:14:02 -0700)

----------------------------------------------------------------
KVM SEV cache maintenance changes for 6.17

 - Drop a superfluous WBINVD (on all CPUs!) when destroying a VM.

 - Use WBNOINVD instead of WBINVD when possible, for SEV cache maintenance,
   e.g. to minimize collateral damage when reclaiming memory from an SEV guest.

 - When reclaiming memory from an SEV guest, only do cache flushes on CPUs that
   have ever run a vCPU for the guest, i.e. don't flush the caches for CPUs
   that can't possibly have cache lines with dirty, encrypted data.

----------------------------------------------------------------
Kevin Loughlin (1):
      KVM: SEV: Prefer WBNOINVD over WBINVD for cache maintenance efficiency

Sean Christopherson (1):
      KVM: x86: Use wbinvd_on_cpu() instead of an open-coded equivalent

Zheyun Shen (2):
      KVM: SVM: Remove wbinvd in sev_vm_destroy()
      KVM: SVM: Flush cache only on CPUs running SEV guest

 arch/x86/kvm/svm/sev.c | 110 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------
 arch/x86/kvm/svm/svm.h |   1 +
 arch/x86/kvm/x86.c     |   8 +-------
 3 files changed, 84 insertions(+), 35 deletions(-)

