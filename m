Return-Path: <kvm+bounces-62362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DC55C418DB
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 21:14:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 546463AF9E7
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 20:13:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AA8333C532;
	Fri,  7 Nov 2025 20:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jv8uKtNc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C72331A6E
	for <kvm@vger.kernel.org>; Fri,  7 Nov 2025 20:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762546329; cv=none; b=trN54TUOYd5589cRL1FPbPIHtBd3lw+nxvKhoK7TITrl1QthqBIBlsob6GtZvREgYVTw/yPcZgBQGW7gNcgqU4zrLGSkIwtcjT6zVez/iYFGGfaay+y7XI0ZH5iJQal2obsKOdRaFKoLQ3TIY4UyKBRrI24lqah5x0PXA6O1f7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762546329; c=relaxed/simple;
	bh=A9B2jBetxyTpijSN5qBDOVR7TSExvw4XrrMBpuNK3/E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZauOx5o5324QiWSehL57n4w9F5QjlsCS/e1yHbZlFqBXgHe58p6itfUSIXx/7Z2LDD49nh8Ga8TwRLtIUK0d+4DtXNU8VCt/EtLaKiBdbN0n92ZKTFVNbGKxKryd+48KzGMsI51MbqTVZqn90in/hpu6r4UDRS7ybACbbKliyNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jv8uKtNc; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-340c0604e3dso1480711a91.2
        for <kvm@vger.kernel.org>; Fri, 07 Nov 2025 12:12:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762546327; x=1763151127; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qKeLCCM6sdWIqGdgWzNkrGSaMg8DXqAf6MQfYLasg+w=;
        b=jv8uKtNcO9dLQzlZlsjVJOnH9E+U7ebI7kqJL259fNr3iIpl8Nc2q1FfsETnVsTEnQ
         tuIuZP5Twnwd3hWOox2tNgDIdDaxfqTY+LC1sE8hjO396lvpJv238r6na8ZtErldGGV3
         nrg+qZnYQ7QIz0mJaAqhQNKRIYs/knZoLwZ6YSmF8wGreEcPLADrYuUerpdiK2d+puBo
         ZUnvjrvECJajAi6CfFKeyG7mlZz8qR4HNndWkTnuNyo/5hln5VJdMnXeuBiwJH4XSOqx
         aUgXPLzjCTRGYncXW1nlidshokBUDX/wlJTJ10lzMCaWxwpDJe8MFAV7YlxtTvolxZ6R
         X7xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762546327; x=1763151127;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qKeLCCM6sdWIqGdgWzNkrGSaMg8DXqAf6MQfYLasg+w=;
        b=qvBqdcL9qWzf5f7I7hGBCxpX1AzNfOlGLJU6xnW2fdu2yQYrl9vmi9XrbNOjiGnWXg
         DblrLLmhVIyGBKTEBWbfJQEr/DAEnvlPbJP+Btnf6GHDmDCGAlNF0N3u3p3BSZiqTIAQ
         nz5YtrNebgSftMDiLoMCE41bWIihEaK6aORVDH9a10T8jP+N8s1iW5UMKSj4vCQZxg/t
         n5p5YL5m8glPDyLpNKHgpTB0pqL+utiahZvKe++IJ0JCfs9sv8TPctOX4dHuxDIXp8Tb
         TiimhONf3nNOXjeGHgdxB79UaJTr38bcCQJBGai14ZtETAMHQdGJotjmvA14ZY7ZHlTM
         ihnw==
X-Forwarded-Encrypted: i=1; AJvYcCVcT8aj6OHlrHGCzmzooPkbpGQYtDMWWF+hOG4jdbc4xOA4+Egp8TsaenEFCCCxSDACum0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw573XJyGkb6ghl3jM17GqhYB4XkE3UpqYfjUdgCFbsVwa5BNql
	yDUK4a8Ztge31vlMBcVweGaRQ248v3tLGVfujvG9KeNOJjPrDQjm1QifX1oZ/SouCPmaa7RvkCa
	phVbG/plX14Sivw==
X-Google-Smtp-Source: AGHT+IEMX81+3tMgOE6zuX67fA9qMfaXSo8kQxA665QBfG7436SzZBgAY0VnspsXWL8BWaeSJWhcyshGWiIDDA==
X-Received: from pjbgx24.prod.google.com ([2002:a17:90b:1258:b0:341:88c5:20ac])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1d0a:b0:340:e8e9:cc76 with SMTP id 98e67ed59e1d1-3436cb22a57mr496539a91.11.1762546326716;
 Fri, 07 Nov 2025 12:12:06 -0800 (PST)
Date: Fri,  7 Nov 2025 12:11:29 -0800
In-Reply-To: <20251107201151.3303170-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251107201151.3303170-1-jmattson@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251107201151.3303170-7-jmattson@google.com>
Subject: [RFC PATCH 6/6] KVM: x86: nSVM: Use cached VMCB12 g_pat in VMCB02
 when using NPT
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Alexander Graf <agraf@suse.de>, Joerg Roedel <joro@8bytes.org>, 
	Avi Kivity <avi@redhat.com>, 
	"=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>, David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

When nested paging is enabled in VMCB12, copy the (cached and
validated) VMCB12 g_pat to VMCB02.

Fixes: 15038e147247 ("KVM: SVM: obey guest PAT")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 43429399993c..21d8db10525d 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -605,8 +605,10 @@ void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm)
 	if (!svm->nested.vmcb02.ptr)
 		return;
 
-	/* FIXME: merge g_pat from vmcb01 and vmcb12.  */
-	svm->nested.vmcb02.ptr->save.g_pat = svm->vmcb01.ptr->save.g_pat;
+	if (nested_npt_enabled(svm))
+		svm->nested.vmcb02.ptr->save.g_pat = svm->nested.ctl.g_pat;
+	else
+		svm->nested.vmcb02.ptr->save.g_pat = svm->vmcb01.ptr->save.g_pat;
 }
 
 static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
-- 
2.51.2.1041.gc1ab5b90ca-goog


