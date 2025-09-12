Return-Path: <kvm+bounces-57474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AD9BB55A39
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:33:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B00D1D638C1
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:33:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DC0B28AB16;
	Fri, 12 Sep 2025 23:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wvyPZLhY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79AB289E30
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719463; cv=none; b=FlOmVVYD4/mSv6KIpxBlM46x3wjaCR/dg7NcIIgfn7pcFb+a2ciPqbetxNnD1z3dhsLwrc3lxaEwmYB/JHzWrTTnNBbxhHKci4NNgxyr2k4iePmeafmr+GPu2tpEu9nqEF/TwsLqeoMRaVvxbkVgJZmeQXIiRkakVTY839/QuWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719463; c=relaxed/simple;
	bh=ed/MzbF1y1avxTID6AP6DxCsceWdQmILphigoArAk0w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HwcLi0DrCYoDeyHQag1bf90XXeNYRmNr75swWOHH+Hr7McOtDT3aaPaET0532nJkGmkG7vDkRehptdmKPCISYtRxULtFYHk1JgGvXMjylE8PH2T5zbVWydy+UwsiQswuHdaCKPE4yKfgzBIFWbJ9dla84cmS18CZb35B8Jq1VBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wvyPZLhY; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-25bdf8126ceso45626115ad.3
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719461; x=1758324261; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=KsdT1O+ZcgN98Gnhy5HR6tDkPGI+1EFI9KM4O6i9nrU=;
        b=wvyPZLhY8HuF4E0cytQe1y0gAEX1yrHjlfEkxPuffCCmrGQLqzUlrX1BfHtWctf4uJ
         GXe3vfhofL/5oprDxsNiq+ugHoumns7GvzmD840z2XW8h0kA28eNrhEJvSNHLARSRwVT
         6wpV/UAXzHUMBwQhasL8gbfUR10OHmyJvyiadzokrG6mpMD/hxrn0ZMVIK+9B+LvDj8N
         xs41wrPy8OiDDd3NXshzJcYGEy1Tkz6B50sOj1KTYg2b0+roYmURzb+huarhOsJQaKQO
         HOKcBFY6Z8LDDiIoymSudVCjC32Q1R+Vbe5+gdPbXw4NwwBNHpzHBjzRpjVRPCysYgFl
         3TgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719461; x=1758324261;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KsdT1O+ZcgN98Gnhy5HR6tDkPGI+1EFI9KM4O6i9nrU=;
        b=VVOcW4YxLUscwF3b6+Tx2VudbFSooxSGtak2MZLpO3YOi7FA3Nc/DDPUPlNJKCV6ux
         JcuEax2T8pKFZATzog1trH70znC1mka02+nJmPqrFUd1lQP1/oIkAOY/ug3zjWKtVq1v
         UdNnad8Iy1Fx7I15tkhZ8qv9hRUDjN8AxB0u2MXd2yb4DzeEWwi1Xn2QVYdz3qnJA8tS
         hZIIWNYbnDU3NwcK0ln4tBRO5eiq0IJgOtdVqo7ZGCM+O6JNPeSJUDw5gq/GiQYhcQWP
         IS6IeqUUwRVENhrKW0OEPaw599QNwztlqEK8jJDzsMtdUyzbMZ5L7VMmZOvTIPLzAz2U
         Tq0g==
X-Gm-Message-State: AOJu0YzJpEWXpJptMhIvSKaSMJYd2DKI7rNFSHBo7ocA8xJU63WD+Gd0
	JvwkXyKNGKRxa1yPYgoFqMBaqR83V/K77lqp3cjg7hf0tkuiigpecespcz4ceiL53b5+G7GzMdv
	N5rGT4g==
X-Google-Smtp-Source: AGHT+IHbGZZ1h9nKu7SXm/xlanddL2SEeIpR7+u3oLOeRCfMGKdUZU3ia1PO0ZKO0TtOZ6bvKGOKSAasGww=
X-Received: from pjcc4.prod.google.com ([2002:a17:90b:5744:b0:32d:dbd4:5ce8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e84d:b0:25c:e2c:6678
 with SMTP id d9443c01a7336-25d241005a4mr58801885ad.5.1757719461173; Fri, 12
 Sep 2025 16:24:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:23:09 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-32-seanjc@google.com>
Subject: [PATCH v15 31/41] KVM: x86: Add human friendly formatting for #XM,
 and #VE
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Add XM_VECTOR and VE_VECTOR pretty-printing for
trace_kvm_inj_exception().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/trace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 57d79fd31df0..06da19b370c5 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -461,8 +461,8 @@ TRACE_EVENT(kvm_inj_virq,
 
 #define kvm_trace_sym_exc						\
 	EXS(DE), EXS(DB), EXS(BP), EXS(OF), EXS(BR), EXS(UD), EXS(NM),	\
-	EXS(DF), EXS(TS), EXS(NP), EXS(SS), EXS(GP), EXS(PF),		\
-	EXS(MF), EXS(AC), EXS(MC)
+	EXS(DF), EXS(TS), EXS(NP), EXS(SS), EXS(GP), EXS(PF), EXS(MF),	\
+	EXS(AC), EXS(MC), EXS(XM), EXS(VE)
 
 /*
  * Tracepoint for kvm interrupt injection:
-- 
2.51.0.384.g4c02a37b29-goog


