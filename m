Return-Path: <kvm+bounces-48875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 103C5AD4354
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:55:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E7792189CCFD
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:55:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE58C266B46;
	Tue, 10 Jun 2025 19:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JnsteRt1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889A6265CDD
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749585275; cv=none; b=lVWQFw3J3uuDLvjnM/PTX9VfH5O+z1Z64A7k8j16LSYOBlpXPPGEcxH20l+40NfA1FyFyId2xPvqbYQlD6oUqf/fXmwrUGY15TKBM55kCORZRnxGdZ6sMiyAc1tBomJulixSn8dy01KltcrH1nFyko1Z9lCzl9vlbbFF6QWqfcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749585275; c=relaxed/simple;
	bh=KXh8vfPV3YWVsB4F287wY2xc9Ink/ibeJW+EsFosOdw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jCaDAlOpsPv07MgakXxIsNVLKL/2ZZttWbeeyYlg6vT/la502bowi3+TW9cn8J5V4bV9s6EBN/XyZKW+wuSQI1EIOFXwetyBSsS/+grVa64JGlYJg13VEWA8wSRFjILmyScy+Jas9pFA7xeXb5eKZFWDQmJrAUIG8kARRuIuzdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JnsteRt1; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b1442e039eeso3693280a12.0
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749585274; x=1750190074; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SEiqUm8ULlhKUF+FhOx9GTPWli4OWcEJWWo4S1ZFfwY=;
        b=JnsteRt1MNSoiQAJk72ke2SMYLx+LoQQ+qLZEbs2dwWHbFUa44UDlu6J/YnRjiW7G3
         xq55oKUTVdzwKLrrLVjyEdnFYfpN/N2vRX6LvdcvluMsKYun+H2RDpwevLnaiSjtLt9a
         dQIXrbsVvJ1uBOU/KTfArS0m3cNwEEUFfj8f63hN4SJJxJL8iGP0DVMubQi8kyrhSWq1
         wMwyIuY5SFErw+yk6EYD6zwWx04YtiyxmTNYEqWeHhKakNHZCqMldUB7AfLeXbxniuRQ
         KpF2l6m3Xi0I7EkceROGR+7boDGTbXlKF0GliaEION/DdxxD+g0wN4S51md83xnAFPvJ
         mpcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749585274; x=1750190074;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SEiqUm8ULlhKUF+FhOx9GTPWli4OWcEJWWo4S1ZFfwY=;
        b=hk6MvnJfxV3qidVbInjKXIahZWsv6XOjcPGHg76VSQr6MUWODU83foJfYSAgiC3FoK
         ykzYndPFSp5KoUNFmyKyLfUy2xLxvYqO/WLGy99gbW4hMA4Pv/xHEg/RqdAu4TALOU1P
         bLop4BCUAZBmBACquu2kRcF1LdzffXQudLF0xwqDNgP85sHnsewZz+HJznfKkK6K8jih
         yc4hzk9MCBcr9ZePXiHyqkImUFz65GXnx0gA7Axuz0ijXaHHdv2911bddwrvZ5v2vW7C
         ZoK4tfJBb/M1XvVFmT6Seg7Zo7S9eNjEDNrE4v5k98+AAR6CtBPMReFR6Qny6Bm9pKS4
         tGsA==
X-Gm-Message-State: AOJu0YzSNyvPm07mQXIXzWoRch5kj6jKaXDcl2rzhMgf+N8DwLtQ4X5k
	ubgiu36so7Y9zeMHidm6lNhbwb93R/87RpqU04xQZ9xyEVThpq1u+v1kKgXG6ZgYzcQae/kGaNP
	UjYlSQA==
X-Google-Smtp-Source: AGHT+IGVIcegpBmPYbY90bQ84zNVbfsyXngO/1PW5XVgH8Q5YhWY2YANB8C5/zgKRZA9Hw/NGUufWovgCwc=
X-Received: from pjm3.prod.google.com ([2002:a17:90b:2fc3:b0:313:2213:1f54])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3dc3:b0:311:ae39:3dad
 with SMTP id 98e67ed59e1d1-313af266d51mr953128a91.30.1749585273924; Tue, 10
 Jun 2025 12:54:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 12:54:10 -0700
In-Reply-To: <20250610195415.115404-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610195415.115404-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610195415.115404-10-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 09/14] x86/sev: Use VC_VECTOR from processor.h
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Sean Christopherson <seanjc@google.com>, Liam Merwick <liam.merwick@oracle.com>
Content-Type: text/plain; charset="UTF-8"

Use VC_VECTOR (defined in processor.h along with all other known vectors)
and drop the one-off SEV_ES_VC_HANDLER_VECTOR macro.

No functional change intended.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/amd_sev.c | 4 ++--
 lib/x86/amd_sev.h | 6 ------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index 66722141..6c0a66ac 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -111,9 +111,9 @@ efi_status_t setup_amd_sev_es(void)
 	 */
 	sidt(&idtr);
 	idt = (idt_entry_t *)idtr.base;
-	vc_handler_idt = idt[SEV_ES_VC_HANDLER_VECTOR];
+	vc_handler_idt = idt[VC_VECTOR];
 	vc_handler_idt.selector = KERNEL_CS;
-	boot_idt[SEV_ES_VC_HANDLER_VECTOR] = vc_handler_idt;
+	boot_idt[VC_VECTOR] = vc_handler_idt;
 
 	return EFI_SUCCESS;
 }
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index ed6e3385..ca7216d4 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -39,12 +39,6 @@
 bool amd_sev_enabled(void);
 efi_status_t setup_amd_sev(void);
 
-/*
- * AMD Programmer's Manual Volume 2
- *   - Section "#VC Exception"
- */
-#define SEV_ES_VC_HANDLER_VECTOR 29
-
 /*
  * AMD Programmer's Manual Volume 2
  *   - Section "GHCB"
-- 
2.50.0.rc0.642.g800a2b2222-goog


