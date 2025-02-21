Return-Path: <kvm+bounces-38895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A4918A4013C
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 21:42:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E1FF919C15CD
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 20:42:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C915252913;
	Fri, 21 Feb 2025 20:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="welx4YZo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B19D200121
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 20:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740170513; cv=none; b=nD+bWxlm1PeadzoEq3B6GfutJQrPk/jOXryFRR/IMY33yms6a9/TCVz6EITUCBtWCk/19hNlT6Ws/fEyRFyRuFwxgcoolnLdHVpL3Y2sJWvmEIaDzDkA5BKVe/ge3Zwd83ZtCpnO08ZXkFYMzvjMDOuoNNe3NEYR6TabDlXpfw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740170513; c=relaxed/simple;
	bh=urfiMq1bP4DE9wMHBO9LDwTvgrApZhu6pKADbI+ebjU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fTTHzR8KEx5oZZc29TXEhSkPBCvP6AmEhaEcn+G1XUbNv8xlCNMwbdyeRsigDKTIS3CrAOfgi2Onefd1B41/+26lSO13l4kK7k+5zWUoE69AwDWifp+MQoFEGwjEIBoIDEgiNtG/1b95zWpnN9iHseoxcTK4z8wId653s0CQBbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=welx4YZo; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f81a0d0a18so5461289a91.3
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 12:41:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740170512; x=1740775312; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6wkIfjVGZC2QCXFAHwEmS85HsRqkEDTy+JMmoaxWQvs=;
        b=welx4YZot4bZw6EMCn9tddnjWQufN51gPRic5YC/xw3w6FGN4hd6bc2wKF7+R8Hsxr
         +VFxWAv7i61aQCOwe6Fg2RqYTelG1GZMWzmQ2L9h35IeiyRARZ+t7FS/Dz1inyITKvWe
         70COH/Gb43zRpm+T8rAkzOxMh4FDI4AAZy1Q2AYTNVgybXByQDJY2GfAdsZYjaKC8Lvh
         K7N/Ks9kPYBcNMN/6C8Hk42z715nZjm60chbOxQidFxgshtbzdTQ5vP5asvBIrWAEnCy
         Ns8gLY5RQbTTm4Xe33Kqg2Ffij+HnefQRhVoe+pqmVKouWRbov0uCmBzEKlrX8ryp26h
         Q2Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740170512; x=1740775312;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6wkIfjVGZC2QCXFAHwEmS85HsRqkEDTy+JMmoaxWQvs=;
        b=vqC8N1eTb0RgJ/jsJFlAVBzvE8SMUx9398muk69sOgawV33BDX6eVVLaloaWXPzcgX
         UauBuNhMcXcxIRPLjSd4CQPakkfi7iImn9tCaJXkp4dfvfry+zCWVte2OgPHhoJmW2uT
         KcwHn55S+WMbXiGqmpxXk7dzpwoyrrxErr8W/+YEeJshX6QfvQ7fUiih+vHJTKMvMcrA
         1CNYgmJEbp8dI0GPO/c9lbPe8rPbGk1TWJ9F1M9N8zj6libUJB0UWS3V+SGyFVe1L08n
         DLVKKe4pqEKggQFv3Uaw0bp+OUaa1gWYKF5hCCjs11LFiD4fObXmT8YmFSbMVQXDc/f8
         WyfA==
X-Gm-Message-State: AOJu0YxpMAOnN77flUj+ac35hHJH8Nj+BQ8c9Rd2OjOPteDS+Fs51Sdk
	CNG79eW1MoNm9JFNb3fYOsIVFnKRgsjJsyxroNQMiVrLwMUd3lnnZLCz7x8FWLDiTjKtyNBdmFb
	GwQ==
X-Google-Smtp-Source: AGHT+IHgzHULLdb0a7Kk1S9WZJjNfreTPTxOZoKydoyvimYdNlk+h1ytUQ2Nn3beZnPUDNKJnMZNIrNHM58=
X-Received: from pjyp8.prod.google.com ([2002:a17:90a:e708:b0:2fc:d2ac:1724])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e45:b0:2ee:b6c5:1def
 with SMTP id 98e67ed59e1d1-2fce78abc26mr7134986a91.8.1740170511750; Fri, 21
 Feb 2025 12:41:51 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Feb 2025 12:41:47 -0800
In-Reply-To: <20250221204148.2171418-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250221204148.2171418-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250221204148.2171418-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 1/2] x86: Include libcflat.h in atomic.h for
 u64 typedef
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Include libcflat.h in x86's atomic.h to pick up the u64 typedef, which is
used to define atomic64_t.  The missing include results in build errors if
a test includes atomic.h without (or before) libcflat.h.

  lib/x86/atomic.h:162:1: error: unknown type name =E2=80=98u64=E2=80=99
  162 | u64 atomic64_cmpxchg(atomic64_t *v, u64 old, u64 new);

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/atomic.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/x86/atomic.h b/lib/x86/atomic.h
index 13e734bb..3c7a89eb 100644
--- a/lib/x86/atomic.h
+++ b/lib/x86/atomic.h
@@ -3,6 +3,8 @@
=20
 #include "asm-generic/atomic.h"
=20
+#include "libcflat.h"
+
 typedef struct {
 	volatile int counter;
 } atomic_t;
--=20
2.48.1.601.g30ceb7b040-goog


