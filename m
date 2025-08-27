Return-Path: <kvm+bounces-55810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 46208B375D9
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 02:07:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 718CE7B5D52
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 00:06:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 951D82080C8;
	Wed, 27 Aug 2025 00:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dh2rTJU1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA091EBFF7
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 00:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253138; cv=none; b=SbF/3sPnh1kzJZC2fS0pRp/qVCO/vP/khOJyR8HdvR/XYM/E5fQ6r4KR6Uvltt6thxOMD5b2563HilHUwKmpq3SfuxMn/sv8mKCaGaXm+bT6+3usZM2FDBxkoFFZDFYUcuq47/CuilAK6KFeI7leAAXWl6hleQCwVK0WWK3F98Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253138; c=relaxed/simple;
	bh=cgh6/e79pQdff589nly0B6miSmkxJA//Fc6O2nZJY1g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CxAq178wNkaImybWLZEGT+EAQpBuzDwUpps/fjbkGPMYSC9VDzdz/V073Nmzq6Sv/c9ZZjedS8QtoyuYK6vWEvJcUWZGdygbJS6tPMlXbU9VOW3C/BdRUZi3hDa9EH/SSaQ6DVf2oQDoi73nKgtzxY9c1J8afqbK/zEuoVMMPBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dh2rTJU1; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-76e2e60221fso11563640b3a.0
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 17:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756253137; x=1756857937; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kxivBTbX+1L8x6FgLUJwK+IMOnrahcSlQkCprtoKV5A=;
        b=dh2rTJU1rwnFbKX7vu6fffcPBs7E1CGLjiI5TLdtsgVzLP7OHif98Qr7Qv0CZHjn0S
         Omcbr0JAk7HCEFud1j4Q0qQWH+U1kYplCTerRP0zt83ksEy6cnQB1OcCgs5OA+INbDwL
         tFuzvSXfxTm17iTxamH/bGijEcQptJVxAF9dEmzqPK5bZAVVRBzkk3H95uixjnhBD0zS
         aAI/7XrrFZIzKL5n6M2hM6baWyWrs9v52NaYIY29hOhO3PSCz8xl0+r/rubKttNYpf5/
         lAUgSitVIOzGkOgZiMncPjLd0TwFt9Qpb21qvu/1RhvHVI7e/vNN2btzPLq6m1cvjZAf
         uz9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756253137; x=1756857937;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kxivBTbX+1L8x6FgLUJwK+IMOnrahcSlQkCprtoKV5A=;
        b=Xfvl5Lgkytp7CjTOPhA4z7c1VlEqs/1Z48i97ejD25jC8+r0/xcoyH3tY+rgnahASM
         5y6e5VVeQJsiaRmjDD29qzCMOVk7QB7dwbhK5sGKSSQj54q1sEzzMSK/gc2xaE8k8PMq
         zzYano7uppzan/HnMxZP6MoPQqgHvDgcCuJa+pU+zJX5nA8ceDvHvK8e/ED9fHVWtB4Y
         CxWRTwy419fvuIBQ7nz5jeaoEaG2o7SwIZ/fN0cqdzcxi1JXPU1fT8uUUalQwKe2ME1T
         2pNTCYFdfGeFZgvVxId5fefJnXkMkLN6p73H22WuDDDTrH2nnHokFOD9Ul6gYMXWDaSg
         1VTw==
X-Gm-Message-State: AOJu0YxNiQVmv8ssvVvxG2Iuw9HMRnS7+J/J2iBeceOjR9YkBjYFdcBj
	6gbn2Sh+W4Vr3nriaX0fo2961iJEKoxXMwFP5Vc6Cpr6D41n/tPGJjPedBWu8yvXr2ioWjALBcW
	8ydTkXw==
X-Google-Smtp-Source: AGHT+IElpbbj7l6TR7thNKCOV4cKqhiJ6QBqeV2KiinUHBKeSxeiHU6PvhisiF8I8bOv3pG+ItNWx/S7ZiY=
X-Received: from pfbci15.prod.google.com ([2002:a05:6a00:28cf:b0:771:e903:279d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4c81:b0:770:57c0:1fd5
 with SMTP id d2e1a72fcca58-77057c02170mr11433268b3a.11.1756253136555; Tue, 26
 Aug 2025 17:05:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 26 Aug 2025 17:05:17 -0700
In-Reply-To: <20250827000522.4022426-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827000522.4022426-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.268.g9569e192d0-goog
Message-ID: <20250827000522.4022426-8-seanjc@google.com>
Subject: [RFC PATCH 07/12] KVM: TDX: Avoid a double-KVM_BUG_ON() in tdx_sept_zap_private_spte()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"

Return -EIO immediately from tdx_sept_zap_private_spte() if the number of
to-be-added pages underflows, so that the following "KVM_BUG_ON(err, kvm)"
isn't also triggered.  Isolating the check from the "is premap error"
if-statement will also allow adding a lockdep assertion that premap errors
are encountered if and only if slots_lock is held.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ef4ffcad131f..88079e2d45fb 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1773,8 +1773,10 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 		err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
 		tdx_no_vcpus_enter_stop(kvm);
 	}
-	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level) &&
-	    !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm)) {
+	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level)) {
+		if (KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm))
+			return -EIO;
+
 		atomic64_dec(&kvm_tdx->nr_premapped);
 		return 0;
 	}
-- 
2.51.0.268.g9569e192d0-goog


