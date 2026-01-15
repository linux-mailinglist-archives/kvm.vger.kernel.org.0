Return-Path: <kvm+bounces-68268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 22E43D293D2
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 00:24:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5235B30C6850
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 23:22:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A030B33033C;
	Thu, 15 Jan 2026 23:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ar9iMgRm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DC431353E
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 23:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768519339; cv=none; b=KI4yao+q+2E4UcogFrYgkzwjSiAX5Xx7oSM5CQ59LSyGOwlsiMGlBVnKZP13+3g9p7YE66EvQGIRGQUaUEcyfbAdRlNuUEdmj4jKe+Yve+28DqjSf8U2SS1dj6urz/zRby4aptDNwmek3kZnKbUizeKFcLAU3WmVG4sCGWjc3uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768519339; c=relaxed/simple;
	bh=RW48TPdvb5xAKUsQXmeyEK97Shn/whfhWqOquQdudkY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DkbZ7iek0e8qSQHC1EExEipnR81h7Y7DyPuFWQXlp3zEgjMpxhZE9Z1SzhKgUa1GwG/xhjRCw14MQ0O6G4sstnhwJ8+3vYPrUBSsmHpe0d0Ap+FcbTCuhuyz/c8HqtyOyCqOhPHVH6LR152pRfSpdgv4H5Ld7n+MQI7H7R358RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ar9iMgRm; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a089575ab3so12338925ad.0
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 15:22:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768519335; x=1769124135; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hfgEug5UPVe3ZZ5958Qf800gsqyZ1Jrc8uLtmlr2csE=;
        b=Ar9iMgRmnrh1Wc8H6dATOsRGGYYYd4CVfdMM+XOTV5Pj+epYwDPzORfcL7rrW2bxdI
         rNKd8qq2ga+qFKLeGEe+Tp4RC7YZlyVly6sgw4jlHh44cCHpf3EcPvnpipIzqSlHFtba
         OnQ2DjogB9TmJo0w/zBxqE3cWU/QE/jOUqAnYEmEx8t/Jvpu1Io2TYAfLSdeLl0uDEYl
         asVxCSh5lE9eNw/C8EyX0T0HqRf+H6a9JXHdE6m5qEvTMmKaJVKT1k9W2wsdb61YdChU
         wbfUjZH1CtTznDkqi0ktroCQYi2eYfUDpGMipfGgwktIvOTFZiao7gjx1SVEAoz5xZcS
         skOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768519335; x=1769124135;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hfgEug5UPVe3ZZ5958Qf800gsqyZ1Jrc8uLtmlr2csE=;
        b=ZeeT/GzpHC8Fdne5ABXFlJr7wFwb1Tf4TKkuusdw+FTaz/1Uumusr39xW8Jv73+NDF
         HNiBitStmClD6CPa3rlTCtWecmU/MXOaAsUy2B/k2PIFJxpmMnXyouib+mlhTItGYWCE
         ys2gOmWN2q1LXp848+mdljIUcbR21bv2yfCpDpAFHntzOKr0y6j+HHCAoZjAIR0seYUe
         UjxfJ863pXKl1f6GkmNnl4SGAOcfRLBeKf6Y50L/ZhZlX5jJmsmFl8Fl9AhxZbfKL5oJ
         SiHVkit/nikUZ2pRngISISRjf0OWR3LAdBjlgQE+HFNfaY4zdmFKQmh3xBeWe17jF1mn
         Pl0g==
X-Forwarded-Encrypted: i=1; AJvYcCWxzQEKm+bNaXUgiaqNP2NLBabdc8NVG00TNMnux0JoWVSHu8pCQ+4g2/f9orHm+wYz3Xg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+oqux4HowOosf/vssNdZUWmYeWNHKb5cFIwCcJDYAqWzB9DYX
	JmDZ/Icghb57Tm0qX+/+pqBdp44M+MzNO7hF2iRtkf46EQpL1llf0oBVZRLou6HavUpA7z7eFga
	DREhd86zLTOzFjQ==
X-Received: from pleo7.prod.google.com ([2002:a17:903:2107:b0:29f:1738:99f3])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:22cb:b0:295:5da6:6011 with SMTP id d9443c01a7336-2a7174fa899mr10665615ad.11.1768519334810;
 Thu, 15 Jan 2026 15:22:14 -0800 (PST)
Date: Thu, 15 Jan 2026 15:21:41 -0800
In-Reply-To: <20260115232154.3021475-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260115232154.3021475-1-jmattson@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260115232154.3021475-3-jmattson@google.com>
Subject: [PATCH v2 2/8] KVM: x86: nSVM: Cache g_pat in vmcb_save_area_cached
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

To avoid TOCTTOU issues, all fields in the vmcb12 save area that are
subject to validation must be copied to svm->nested.save prior to
validation, since vmcb12 is writable by the guest. Add g_pat to this set in
preparation for validting it.

Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c | 2 ++
 arch/x86/kvm/svm/svm.h    | 1 +
 2 files changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index f295a41ec659..07a57a43fc3b 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -506,6 +506,8 @@ static void __nested_copy_vmcb_save_to_cache(struct vmcb_save_area_cached *to,
 
 	to->dr6 = from->dr6;
 	to->dr7 = from->dr7;
+
+	to->g_pat = from->g_pat;
 }
 
 void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7d28a739865f..39138378531e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -145,6 +145,7 @@ struct vmcb_save_area_cached {
 	u64 cr0;
 	u64 dr7;
 	u64 dr6;
+	u64 g_pat;
 };
 
 struct vmcb_ctrl_area_cached {
-- 
2.52.0.457.g6b5491de43-goog


