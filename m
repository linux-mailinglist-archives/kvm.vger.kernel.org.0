Return-Path: <kvm+bounces-48440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D5D60ACE469
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 20:36:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CD7EB7A9886
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 18:35:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EC0520B7F9;
	Wed,  4 Jun 2025 18:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DooLaaYS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C25B204C07
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 18:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749062195; cv=none; b=QpnzP/y40z2p0EAAMEL4+Dhd/CaAt63QGPhV+PwNCuUSY5oWZzhPFsQD9WY847Xj++KQf89dTO0o4vB5suxkVRkYkgMOQ+j+ic28OhLZpFe8slZbZNQ5xjvD60uZWfGyNtRFNn+KqZ3AoqlbeaO9WUAqRgfq2iPED4sLqVWD7x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749062195; c=relaxed/simple;
	bh=w30rr179gDRsC90dDQ84C9uBik2D8XMQe0+RrOCdPCI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Xw7puVYPkJFUAJ6CIn3LOZTzEl0E6+AuF/5wbDNdlpKzjaNjGMof6sP/QHEk8YH1at9HHBIDk4zfN7zSEKRSAkI1yD1TZC45Cm5Rwp/kMwGvSkGlen6XtLGzYn2doqEf0TdlT/lWZJL9dSkPTBCN6P/Yp6A2++StUvYKd8k4lg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DooLaaYS; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311d067b3faso256509a91.1
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 11:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749062192; x=1749666992; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CWITSRfO2aiPoza7d5N/RWblV28laeIbU7nWh1aV0Pg=;
        b=DooLaaYSxxLZHLhr4sltLnAlToo2MNVYNvEB/IEdYHFJwwUv3EksisLyEVjCXGtKWW
         5ihtlmB9ZkoIac9dafvwOw7/e0UJ0larvz18eeNYDQVnXSKCHFrpiM3r0c9BTEx0Qmo4
         q6wSOXhils1cr7q30WXiF9SLBrmH9gfQMYnILQsYvjmmkSsAVcEg7yGdfnCk4N+GENY/
         iGDXhieZz3GWEl0RAPXqfCTV9DT/6kFQuK1KNiUhJYp7FP7Yygs8Vvh1U/Q8j2x5Jgyt
         s2P9hIJfElomlvONeQfmgQB0me9CGKCZ7wk/WqsEr396Gyatn4UwBMmbPEHni/gCy0eP
         3w+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749062192; x=1749666992;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CWITSRfO2aiPoza7d5N/RWblV28laeIbU7nWh1aV0Pg=;
        b=rNygToOcGf++d9URTbzVnMiwxxz8BswrjVSxb4AoLrHKUK4X730vYREdKqeL+S5bJI
         FEG2QpRNSUFbbRyCFKImJVHXxW6APIU2KzJ8OLWnev1KtAIrUjf0U+hdu/dSipfpDWgX
         bmTSQqRT/1i5f6EvaneLDoKKDSpzbNppeHsIuurpoXaeV/xyszbGrPGxnz5wXmkoKCd5
         HSScaOARa+h/77E0vQSUU7+UfGJVBiFZDAGvdMLzV+Rm8NRhBF1MjuaN4mztsXLclKze
         dKh5djJCn5Ygvi9lfouTW6F3SyRT+vp63sKCcaMAiFMiVdvfEuDtTHqzvBmX/7Gru4Lr
         UUPA==
X-Gm-Message-State: AOJu0Yx7G44rl4djbU4Xh3mDZmplfdH3SDXzJ3nAxykRmlel1OfWU4ZN
	3gSHsgwWLrJ1qwvtUc0eEDExq/0fDCXTfA9qw+8objQ3Sxx1puIF0/9pRCiPAG/mOUSK8DxyMcM
	u7xjcTg==
X-Google-Smtp-Source: AGHT+IHfGgt5KClCq+I0emII1jzfYSKkV/aeQqIbjYzY2qkA+qzCtoZ8Obz5wNXHfai0QtbLLa65vM8nK+Y=
X-Received: from pjbpt1.prod.google.com ([2002:a17:90b:3d01:b0:312:1af5:98c9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:6fe4:b0:313:1a8c:c2c6
 with SMTP id 98e67ed59e1d1-3131a8cc3aamr3065603a91.16.1749062191823; Wed, 04
 Jun 2025 11:36:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  4 Jun 2025 11:36:21 -0700
In-Reply-To: <20250604183623.283300-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250604183623.283300-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1266.g31b7d2e469-goog
Message-ID: <20250604183623.283300-5-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 4/6] x86: Load IDT on BSP as part of setup_idt()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Load the IDT on the BSP as part of setup_idt(), to guarantee that the IDT
is loaded when setup_idt() runs (currently, the EFI boot path loads the
IDT _after_ setup_idt().  This will allow probing for forced emulation,
which requires being able to handle a #UD, during setup_idt().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/desc.c  | 2 ++
 lib/x86/setup.c | 1 -
 x86/cstart.S    | 1 -
 x86/cstart64.S  | 1 -
 4 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index bf6c62bc..5748f900 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -309,6 +309,8 @@ void setup_idt(void)
                 set_idt_entry(i, idt_handlers[i], 0);
                 handle_exception(i, check_exception_table);
 	}
+
+	load_idt();
 }
 
 void load_idt(void)
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index b4b7fec0..122f0af3 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -345,7 +345,6 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	setup_gdt_tss();
 	setup_segments64();
 	setup_idt();
-	load_idt();
 	/*
 	 * Load GS.base with the per-vCPU data.  This must be done after
 	 * loading the IDT as reading the APIC ID may #VC when running
diff --git a/x86/cstart.S b/x86/cstart.S
index 0229627a..8fb7bdef 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -109,7 +109,6 @@ ap_start32:
 
 start32:
 	setup_tr_and_percpu
-	call load_idt
 	call setup_idt
 	call reset_apic
 	call save_id
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 9c1adad9..3e332c88 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -105,7 +105,6 @@ gdt32_end:
 
 .code64
 start64:
-	call load_idt
 	call setup_idt
 	load_tss
 	call reset_apic
-- 
2.49.0.1266.g31b7d2e469-goog


