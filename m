Return-Path: <kvm+bounces-62241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 72853C3D6BB
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 21:51:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DDBDF18901E1
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 20:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5E7B301474;
	Thu,  6 Nov 2025 20:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VyTygHpK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9322FDC3E
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 20:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762462279; cv=none; b=VE9ce/ZPD3qUNywPIOqv2ueXai0qGxo0WFYe04c094tCNTaSq/16r1JH4U2y5sadvNR20QZ6imZY4gEV1FzR8GvL3yxFu1iJcPVyA4vggCzwWPibqq9pTct8dwDNq4VmWdDUo+2WmgRAOOcVrVnn+d6onIU1829c91W87oIl3ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762462279; c=relaxed/simple;
	bh=9bZDmMvVzwiwlqXRp0BdknQXlsthbCCiVzjJANmacLA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=sZWh0bRS1Spk5O9/4+ExAt+czlaY2JM2FKrQFQCq8xV2pO5cZSB8EDu+8Gyp6DS3/QE6EpfM+rsYuXWwPD7YsxkaRyJ4yGXx6BbeAdjmLzHMdTMkWNGG79hC6xoPutWtqBUTRyZBYKfZ66A+9mqewiyOg3mkMBCQ/xrRvi9/Ob4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VyTygHpK; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b62da7602a0so44412a12.2
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 12:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762462277; x=1763067077; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GLDIhCiQ05GV92LqMcFR+RJDcu8xOqS2F0M50i/xx/Q=;
        b=VyTygHpKGQFIw8WM9V68sJTFnL4RMZGGyER5a/iA/P3sTiVQrgbpgNgd6fmTuX6JHO
         +qY0sA6VogR/D7LMcqJ5rKKXZJNOMqQzy7abtLZ0ZRfuy8GDVDbOrcAAj49UZ9KOtJoG
         jDtLUgK7oEM13RLVRo0rkr4IGcUwdGKEUUN/4/LXEVUelVS4S/WBL4e0oYptJ+uvxh4r
         zcebFakWwkOr529xKm5hkGJmTbB89acKri7bsAmFunnlxslTNi6KpUPW8x2o5q9XOXu/
         64Jk7WLD5vGzE9lkBlIl0LPXOz5Ab+ouJX3VdrMo9Qni0jOpl0mHY5F4/qze5/2PjrtF
         T48g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762462277; x=1763067077;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GLDIhCiQ05GV92LqMcFR+RJDcu8xOqS2F0M50i/xx/Q=;
        b=cb3oQRLdROKyS0wgs2e/rcDtk3ZlCzq7RjwOab+bzw6L0JQvPaaRp1RDaxKIejwVyp
         EkHyUPZc66PTvTDSY0NMPhlzKFXGiZoyaV8m2qL3bf9EpF4zxN2s+QYMnViTI7YKFt1Z
         WU/7c7nuZwZCUe4WNmlc1O3j0Cbr8UJaYj7qnU9bC4EJTxE6dnsw/eF33P/p5EkJ/6P0
         UnaZWlxM8UZdHa4k3HqYrHSPZiRXj7ZO/gHITWez4gwapV1azMRemtqQywwv3HEQp6Mt
         WWOB8tzwedhX5cAlOrApqNWW/EmvnGcDuFLrU7rimxrQ25E7FSsndS//GKeDhcdHd1kw
         Wa/A==
X-Gm-Message-State: AOJu0YzDe+sPAoZaggh1UOB/FZfTLEeAGV+9lqFaVNbNbgqWOThyEBXB
	8ju+0G2ejdFbv1HH7WPC4LBGwRKjX6BtaVArbhkRTXIbWl/c9l5W6NgcMtzf22WeJJViBHEHyGw
	jh7alBA==
X-Google-Smtp-Source: AGHT+IHZEdByAK+1aX4lS1NCl/os7+UpRs7CdG6SVLSROmcI/XG9YFfQ5jGKETD2kB3mm1wOWAM3vGL3xw0=
X-Received: from plbiz5.prod.google.com ([2002:a17:902:ef85:b0:269:770b:9520])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:11d0:b0:295:bedb:8d7
 with SMTP id d9443c01a7336-297c04856e0mr9548435ad.48.1762462276681; Thu, 06
 Nov 2025 12:51:16 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  6 Nov 2025 12:51:14 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251106205114.218226-1-seanjc@google.com>
Subject: [PATCH] KVM: VMX: Make loaded_vmcs_clear() static in vmx.c
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Make loaded_vmcs_clear() local to vmx.c as there are no longer any
external callers.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 arch/x86/kvm/vmx/vmx.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 52cbc51dec28..6f374c815ce2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -752,7 +752,7 @@ static void __loaded_vmcs_clear(void *arg)
 	loaded_vmcs->launched = 0;
 }
 
-void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs)
+static void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs)
 {
 	int cpu = loaded_vmcs->cpu;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 6cb04a6afeef..bc3ed3145d7e 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -680,7 +680,6 @@ struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags);
 void free_vmcs(struct vmcs *vmcs);
 int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
 void free_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
-void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs);
 
 static inline struct vmcs *alloc_vmcs(bool shadow)
 {

base-commit: 31cb6bb71b1a1d92f8de6f396a9d12db6742e504
-- 
2.51.2.1041.gc1ab5b90ca-goog


