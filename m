Return-Path: <kvm+bounces-67502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CB6D0D06FEB
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 04:31:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8F043303A39C
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 03:31:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF5661925BC;
	Fri,  9 Jan 2026 03:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AE1xCXbs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576D3347C6
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 03:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767929469; cv=none; b=RzKp7uCJ7QNu2OhT6B9cJN10XWaaE3Zgy0fqjCceHIl0Qgf7UsP/gvPbk9St5dBtg9HiK4Yty0YogJUfCgn+ZVJnQibQYTL348nWxw8bl8WH1zSxmOSR29Ds3rrhg8L4/qGla4vPvPG9z3XnFCsNdJPk0lgP8PlflZpK+BC94U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767929469; c=relaxed/simple;
	bh=VQk4kuLqxT4b14/XgZB7ISx/GE32ATVfrNfCmSw6uUE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=czowM3rQXlytxJD2c3L8mcSr+B6YAc4pHcF4l5oKz8/xpI8SuJg6pOdYGdAMTCk4ZrFn6XKWGXqUae9ICDPmeeBmEy/1OdCIrA6gbDEER+xBX2MP+fWfrp3s6w9/z+BJhDz1/YJbJj7qzn54aVeCh6HboPgqPOlLr2DYp9yB18s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AE1xCXbs; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34e5a9de94bso7159370a91.0
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 19:31:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767929468; x=1768534268; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1CosggHBR0O1gxFtXIarEWoLXwsPD2jUMsMkTQvLSbE=;
        b=AE1xCXbsAyH5QM/QGLAPTzMWA7yIMcT9ZrKFg0RwCAWYH0EX+PHeF4ayvS6AqcI8dy
         Yg23qT/KNYHXryw/glUDvwhsU+MoHH31hZPcBLZ1/+jisaRWa/mvYYDcNmfnF94jrXNP
         +01kbOqi2w8zvczSbkr/sGpYbSQlBffuSRVDYxd/cpk/En90tugg+1te5gQR0zI2BujR
         E8uaxbQrPub0bNnTLARe4laxV6BMan6hOYOaqGmkUjNWwtbXc+xZpDmyeSb9PSqqNKsi
         2+I0+/zY92ACLTuVpVy4v6GCCzGOZLleYuN4Epe8PIdC43bG0sfjpmKsdOWMag9imKPU
         9EaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767929468; x=1768534268;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1CosggHBR0O1gxFtXIarEWoLXwsPD2jUMsMkTQvLSbE=;
        b=fWmQnrQnNQ5Ji6GqxzKUowm7TQeERmDYeYdU1JJZvpavKr9zPNWDKf0gnMfrmHzFju
         y+YgyTTMgVidzrx2TJ9v/shBVisQmn0zsYH3xdykcYSeT+1ovHFtYAsXfE4vX1hVIIYf
         Fpg8eDGNU4ifwVRgFwYNryvChKGtgHN5B6XMMxeNzZ1UHE12Fcibw2mPvun6Vr8ez7Ub
         6B+n2YIZ5XZ4lMhX8f21Zg/nuLQFbi4J1bqHmTApwiw7Agv0E7yws0bSew/f0RSicTOg
         jN2Zw4VuAabaqGsINA1+T7Rq7PZ5VABewJ6QB0OENGBvxe5WUihBuGBFW/bs5iioV/7Q
         9Rxg==
X-Gm-Message-State: AOJu0YzdcvUjOuHTpD96ThVV+CA9mXWIDItV3CwubPgRXYyYaq7/atxs
	WuTYCKbF2l/3xUqV/XjvkC5HJt19/X6zcZ2uUW4ifQ7yM+1CtZAThv44yYmne3x7TghrdbtqvBi
	Mhm4HNQ==
X-Google-Smtp-Source: AGHT+IGIYiBNKkOkGz6qEANHpd7Pim3Ibu+bG1/VliV/OvTCLYe+rexBq/JVo18CIsGFfmpH3LZ2dlF1+pY=
X-Received: from pjte19.prod.google.com ([2002:a17:90a:c213:b0:33b:51fe:1a73])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:560c:b0:32e:7bbc:bf13
 with SMTP id 98e67ed59e1d1-34f68d3b47bmr7418627a91.34.1767929467706; Thu, 08
 Jan 2026 19:31:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  8 Jan 2026 19:31:01 -0800
In-Reply-To: <20260109033101.1005769-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260109033101.1005769-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109033101.1005769-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: SVM: Tag sev_supported_vmsa_features as read-only
 after init
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"

Tag sev_supported_vmsa_features with __ro_after_init as it's configured by
sev_hardware_setup() and never written after initial configuration (and if
it were, that'd be a blatant bug).

Opportunistically relocate the variable out of the module params area now
that sev_es_debug_swap_enabled is gone (which largely motivated its
original location).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 9b92f0cccfe6..28150506b18c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -53,8 +53,6 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
 static bool sev_snp_enabled = true;
 module_param_named(sev_snp, sev_snp_enabled, bool, 0444);
 
-static u64 sev_supported_vmsa_features;
-
 static unsigned int nr_ciphertext_hiding_asids;
 module_param_named(ciphertext_hiding_asids, nr_ciphertext_hiding_asids, uint, 0444);
 
@@ -81,6 +79,8 @@ module_param_named(ciphertext_hiding_asids, nr_ciphertext_hiding_asids, uint, 04
 
 static u64 snp_supported_policy_bits __ro_after_init;
 
+static u64 sev_supported_vmsa_features __ro_after_init;
+
 #define INITIAL_VMSA_GPA 0xFFFFFFFFF000
 
 static u8 sev_enc_bit;
-- 
2.52.0.457.g6b5491de43-goog


