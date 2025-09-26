Return-Path: <kvm+bounces-58869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B0DABA3F4D
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 15:52:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50A7F1C010D0
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 13:52:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A113B1A3A80;
	Fri, 26 Sep 2025 13:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="iYM5KcYW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440632EB85A
	for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 13:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758894724; cv=none; b=gGzXY67nDUWwlbW2v+Q8vJdTnVvM2L7NFcQOGxhuHctqRgvETcTrH4Nf6FpdTjIF12FUT68UMokkYooz14EtTNJ3C19ihkJNqBFkLD0rFDKeOl7PK0oYa00riFsogbclUeEqqhfW7HwY0zb51whjFCcLaC944RBNxyBI1DCU0Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758894724; c=relaxed/simple;
	bh=1/AcT3Bc5vPs/LPilkpfToUOPoo+e1GCVcKYXLiJ3/0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nW8ltGFVlcYrft4I89EsDScuXHkyBOdtdrDwY2Do1CrIXX806EvCgz74LoTsj3qQUW4aFvIDtoAN+RAMVgSTW9+l8UR0SVJaJjVPwgyWcZScg4piyUUJ66pT1RHWTu/4fyzRykRNLZiJwuKPuvw2ccaK6c8QvELcixWIxUVZQF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=iYM5KcYW; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-77dedf198d4so2817963b3a.0
        for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 06:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1758894722; x=1759499522; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=k7jp8yLZxEobbpETqyfchAwVX2BSGTy6SZoafcKNw1g=;
        b=iYM5KcYWq1rw95VdkS3Grtnvv+decUgb5KXAijwT86y5yfJeSFXUBgVz72Yx20BaOg
         TPk0dv0NgW0odF65Rrh1vUNcofyVNM2m35tx0Y9lvOj7pGgnR+cfpIY6gDzPi9QTUXsq
         osmhIVlM0a0AEan7xRml9Jl6qwAw+P2GkJt6E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758894722; x=1759499522;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k7jp8yLZxEobbpETqyfchAwVX2BSGTy6SZoafcKNw1g=;
        b=ACaeZfwHi1OVZ8ToICw/Wr5zToqDAoBlzGcD+P7Yv8RIIvk7zvVESmfr1psPpL6HyZ
         1h3FZo8F9/KGskqpi0f8q6lDBWmaxRAVqlBfjhUH70sm6bBJUh3Tt9lR2Mf1XIMhhsua
         J/benIdC4fsmcGPPjpKZCHQp80NUvZZ8c/LrLo7sPfSMZ2+0jZsU8Y865lP/5NW5yVW5
         JPL6X6Iyj6PEjINPVbfZ0QpsG2gGJhfc76TkAFuMgVc1PnpD7uixpMy7XVDtO9kASoKz
         41M1JMEFlL/EpUzFSIBTPoAVEkvA2bN4d0OxEcqGuqChiSLxjYqJuLHaadAwnHj7ecS3
         uGmw==
X-Gm-Message-State: AOJu0YwXVSTBzQMyH4nRyHODVd9jb20d+EOYn2l+66PjE2knMDvjwIzl
	2SlGGJfsibEMe5AJu94JfnAn5y+DoOGgbNrPAITqWeBMYYm91odgJRuRNYJY4r5rRa4p83u9PPC
	cwG9MtaFT
X-Gm-Gg: ASbGncv8yumdgIXdA8zEOraBHbqH0BUuCUpHYu2yKmm4nDuQ7lrNPB0Bif1TOIfiTAJ
	Qm5+jtN8C8rKH5f62cT//ud+fX2Q6JW6/CaQUjiY1H0lgRqLFudgsxoqSBDExj5OHMbgrwctcMY
	+mRxqfB4OqQFDvXNTOvpiLnM73/3HuiBYtoCGGw3frYCryl3M3PrrxMGnmsNFoPpRnpLNUUrHNL
	AyvwMvnMNYM5gj0e70sPANOEREZfUX/6mwn7/hJspeD4rhKjRfhf2rx3bKoEfvUpK5oMCEtpJNv
	5YiyaMHK/CqiaOwfKl57aAq5mpjF6phc+v5SL4qOoUezsa7DDQwlFiaTxCpHZBuxb7/eOeZ/pZ3
	RWCtM6zXQcCHhyTvO9D341A==
X-Google-Smtp-Source: AGHT+IHkScieu2EQ5+BzeIwXjQ+6+pWTvDLXaL7ksD8U1FVF/quB9UFR7FpLBLPhA3BlkAgBp75jfQ==
X-Received: by 2002:a17:90a:be0b:b0:332:8133:b377 with SMTP id 98e67ed59e1d1-3342a280378mr8184201a91.15.1758894722418;
        Fri, 26 Sep 2025 06:52:02 -0700 (PDT)
Received: from dmaluka1.corp.google.com ([2a00:79e0:a:200:f83f:a8ff:c4f3:beb])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-334352935d3sm2657143a91.3.2025.09.26.06.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 06:52:02 -0700 (PDT)
From: Dmytro Maluka <dmaluka@chromium.org>
To: kvm@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org,
	Grzegorz Jaszczyk <jaszczyk@google.com>,
	Vineeth Pillai <vineethrp@google.com>,
	Tomasz Nowicki <tnowicki@google.com>,
	Chuanxiao Dong <chuanxiao.dong@intel.com>,
	Dmytro Maluka <dmaluka@chromium.org>
Subject: [PATCH] KVM: x86/mmu: Skip MMIO SPTE invalidation if enable_mmio_caching=0
Date: Fri, 26 Sep 2025 15:51:39 +0200
Message-ID: <20250926135139.1597781-1-dmaluka@chromium.org>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If MMIO caching is disabled, there are no MMIO SPTEs to invalidate, so
the costly zapping of all pages is unnecessary even in the unlikely case
when the MMIO generation number has wrapped.

Signed-off-by: Dmytro Maluka <dmaluka@chromium.org>
---
 arch/x86/kvm/mmu/mmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6e838cb6c9e1..bad613e8fa95 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7339,6 +7339,9 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
 {
 	WARN_ON_ONCE(gen & KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS);
 
+	if (!enable_mmio_caching)
+		return;
+
 	gen &= MMIO_SPTE_GEN_MASK;
 
 	/*
-- 
2.51.0.536.g15c5d4f767-goog


