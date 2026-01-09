Return-Path: <kvm+bounces-67501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EB4C7D06FEE
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 04:31:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 84CB83021FAD
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 03:31:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B63151DED42;
	Fri,  9 Jan 2026 03:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q2qXBKwJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F8550094D
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 03:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767929465; cv=none; b=PNEUayqO9aHyLrYSvDF0St6kjK61NIbI4Q1ERiyYPIKIpcGbFLwT1j609htTNuaAvSi9y4cqWOhNiIcGxokYR9Fwv5EE/shh/L4rlrrMb2kgIOWzGBDmikiapcOmSiYIHkSscEzv+QH2LvziQxBA/bi5m+byHD1+iac920aedF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767929465; c=relaxed/simple;
	bh=XCytl15JB9tLzFruykXkpQafdQQE8tNCb3BUPbvDNRY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=G1QoXk7DAMZnpBF5GvjMvqq96NJZUWNXBV9PDhCH4omsHpwRhy8SKwHIdBqmvFXk2lSt85wD0XZxkoRrJBHsG31PAObJmG/37Q4TPv4keAdHHVcq+kwLBBa+vGf6VJxbLKfsPcIXfeMjvZIK6lNEPbWrHBM1q00TXUlayKHwBxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q2qXBKwJ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34ea5074935so4298309a91.0
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 19:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767929463; x=1768534263; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=csvFVV12IQv7EzEdDk9SoW1eLZ8D56TCKBIBWoYTpcY=;
        b=q2qXBKwJGBzJbXHrWEW/h3pDviOFAlt2jSKvFS13p5Qyu2kLBfKKnQI8228srK7JTw
         /++BdmxWPmJVucMZuxsVP/g/uGCt/P6cmksCRCG1vUDYGzOFcp1dFxGSxyf6wLainhl+
         eXwIEiBRm/nOmSqFIauy+/BZahRT1esdqIAxRxTdX22IUoTjC8A/oI65CZ2Gr/76J/Ew
         KTbzugsL20xyESPQEq00a4Q3vxSN5r3axsI/uEfrdUy8HsehXpJncsCfGZu+mIxWPsTQ
         wX0jn1aZIKD4sXGQXEgqFiRcDqJlhSIXCDKnkeVeU8isclGR9l1MpoIbwLmHmKXrKVPh
         1m4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767929463; x=1768534263;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=csvFVV12IQv7EzEdDk9SoW1eLZ8D56TCKBIBWoYTpcY=;
        b=t19FP62yUmVWGkktswHuJxROFXI00xADeD+Kf1Zi4yzwkjoV4VJIIW2pXDdDZ0QMxs
         IGuUzlDp5BM28MU1N+5+7y40yy1Vz5wqb8iLXpNKfGThw0+Kss33CrTtdK7aZbmlmeLm
         29A6OwjBEBOGrfIIF5xAQQU3z2dtITjyAZtHHcIRUhmuPZ8p1BnI4I6iVHBOhN32lAo+
         CMCKe9vQc+Y8IHwtU9thP7kQCUSa1QB7f3kiDplWfmMMUIon8x/tGsLCsHu+UFQ8Eg5V
         3AIxyci9wfAOUvL76J9JLLdLv2x4gheDXPsXsqHLoTv0DZ/0I4EmKNYOLKoDlDKHWoOY
         1L8g==
X-Gm-Message-State: AOJu0YwIpq/eWKYm8mDepIESN9p6i/VTWRZgnn9ApWYUPDnTRkpm0klB
	W4jloRUnpKi8y24rvVEGRSuY4EHWmwmGtvLXjiCl/DnZtbijWuRxArXTT/EBjbW/h2TwQaigvzi
	vHK1DzA==
X-Google-Smtp-Source: AGHT+IHxKqWCxj3uNO4FF0+YIr6XhgqfCCJlLzMbHLMbMBauomghnxSedlDwi8FJ2q4bP6FFQuyTAjpdgOw=
X-Received: from pjbmd22.prod.google.com ([2002:a17:90b:23d6:b0:34c:4048:b62b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ecc:b0:340:bb56:79de
 with SMTP id 98e67ed59e1d1-34f68cddd79mr8116276a91.30.1767929463236; Thu, 08
 Jan 2026 19:31:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  8 Jan 2026 19:30:59 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109033101.1005769-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: SVM: Drop SEV-ES DebugSwap module param
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"

Remove sev_es_debug_swap_enabled as it's no longer needed/useful, and
mark sev_supported_vmsa_features as read-only after init.

Sean Christopherson (2):
  KVM: SVM: Drop the module param to control SEV-ES DebugSwap
  KVM: SVM: Tag sev_supported_vmsa_features as read-only after init

 arch/x86/kvm/svm/sev.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)


base-commit: 9448598b22c50c8a5bb77a9103e2d49f134c9578
-- 
2.52.0.457.g6b5491de43-goog


