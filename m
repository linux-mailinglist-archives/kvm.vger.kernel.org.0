Return-Path: <kvm+bounces-63131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 17EEEC5AB9C
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:13:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 49BB4353A70
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:13:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 648C822127E;
	Fri, 14 Nov 2025 00:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="reYcJrhe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB6120F08C
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763079191; cv=none; b=YQOWmSeKiLeeRx9KwuCR9n8tFq5gMdEBxHO93/86309nMLAmmbvdbTbRFlx/m3Rcp8oMf1/uG7P1SxXYlVIpmFKjpFsZlQq50b3wL4g92i5sj8iWXuwaBEj84dmqIAlmvLfLqeNgENR3Zb28IzjY6ZC/V+YVLUNSmsQ6lk9biyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763079191; c=relaxed/simple;
	bh=MAk8y+gtQTrxhH3LcXBH86mYdGq1s9/k7ZB8dWktOxo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DUW0m3jyFyVcYfneybKgpxaEvt5VdJNTDFgfUq1KC8oifQFTiyiI4QGsAa8t/GHRY2dMdbQgBy0wBJOkjA132OhOc+G5fnXW4ru9h9/70ykSNi1JZlEVCWTsXPinO6Lwouz3RfBcNzxsjurn7/KVzu0krZ0e1cNNwPbP+8hjRzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=reYcJrhe; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7a432101881so2554330b3a.0
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763079189; x=1763683989; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=20w0wSRi6nuY11bnVrIiaoX3b7W/7OkuX2j3VH3XSds=;
        b=reYcJrhekeckNnOwT5mQ7AfaP0m+6QrOa7Hjzgp9bC8/ZD/wKEB1wx6IZIf8v7fJjk
         nGEYnaBJh6ZU5zwNzvtdCwpUk6U1fyzEIU0ftsgS3NnBvtmn7vhPe+6lJAmKBkHLY8KH
         FZv/M3+JXbvfvbNezqVYqn2ZhEnefhqq3VrG8fRDCNjYIX+iIsuHexRQHRMHCtLgzT83
         0HwDKhz9D8eEwZNtfxWzVEn6UvsyD4qmg4dHhBvuwdDP44d/MoZKyAcp3V2DEcPa8kf3
         foz6aHHJXhoCmRtHbL6gRiLUkJFVnqd0nQWPDB1ctlyZJY0dc2rW/Rsw5c+f/AICCsjk
         VjMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763079189; x=1763683989;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=20w0wSRi6nuY11bnVrIiaoX3b7W/7OkuX2j3VH3XSds=;
        b=fSGqUjnG4bWZTMoFGtNslSjm/wAl8fzFZrBBa8Ue7p88El/bvmvbes3t74KHahsBmS
         hREvg4UmAhcf8gtUXwUASu7XpA8V3JL/rH+S3piFgaQF3j2OaIRioZBwisahI22bBLXz
         pSuQsUXaYG9CwJfocHo4FIUndJRu2eTN1ZURrqIhrslgrpTkvJ4tf/IBpj1hysVM0ehm
         dUIC1XmYDHAv4ingIFIkSLTNrpiDxaxmn1dw89yMg1JTei2bIRpYTnDzipg1WPCz6j1E
         sbJYhKnk6j8TPAIuqAxDhvSefW+02+AhrneWnjJNhISJj0tq/A6d8YEu9ursdOJshSbO
         U6jg==
X-Gm-Message-State: AOJu0YzNH5w/Hal8eGXOmx5/lkdPPpRevdrGIo16eveXzRyl+yQ4dy6r
	XG5ZWS8Ksn8DZ5ErVs9GwSY2t+voaU0uWGibvnqsQouCKhHVoOCRt5M4KOjJg3/0upOyZhNfPuh
	uEm7fzg==
X-Google-Smtp-Source: AGHT+IEJ2zN1ODdO+hzxghH3spGFPsf9crgVwVAdHt6mHn/6W3oGTufEuTGk/oM7CYnixgPwqgZxXq/Z0uU=
X-Received: from pgc28.prod.google.com ([2002:a05:6a02:2f9c:b0:bac:a20:5f18])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:ed14:20b0:343:3d3c:4685
 with SMTP id adf61e73a8af0-35bae215308mr1143985637.18.1763079189530; Thu, 13
 Nov 2025 16:13:09 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 16:12:46 -0800
In-Reply-To: <20251114001258.1717007-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114001258.1717007-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114001258.1717007-6-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 05/17] x86: cet: Validate #CP error code
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="UTF-8"

From: Chao Gao <chao.gao@intel.com>

The #CP exceptions include an error code that provides additional
information about how the exception occurred. Previously, CET tests simply
printed these error codes without validation.

Enhance the CET tests to validate the #CP error code.

This requires the run_in_user() infrastructure to catch the exception
vector, error code, and rflags, similar to what check_exception_table()
does.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/usermode.c | 4 ++++
 x86/cet.c          | 4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
index f4ba0af4..69dd64ff 100644
--- a/lib/x86/usermode.c
+++ b/lib/x86/usermode.c
@@ -23,6 +23,10 @@ static void restore_exec_to_jmpbuf(void)
 
 static void restore_exec_to_jmpbuf_exception_handler(struct ex_regs *regs)
 {
+	this_cpu_write_exception_vector(regs->vector);
+	this_cpu_write_exception_rflags_rf((regs->rflags >> 16) & 1);
+	this_cpu_write_exception_error_code(regs->error_code);
+
 	/* longjmp must happen after iret, so do not do it now.  */
 	regs->rip = (unsigned long)&restore_exec_to_jmpbuf;
 	regs->cs = KERNEL_CS;
diff --git a/x86/cet.c b/x86/cet.c
index 7635fe34..0452851d 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -94,13 +94,13 @@ int main(int ac, char **av)
 
 	printf("Unit test for CET user mode...\n");
 	run_in_user((usermode_func)cet_shstk_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
-	report(rvc, "Shadow-stack protection test.");
+	report(rvc && exception_error_code() == 1, "Shadow-stack protection test.");
 
 	/* Enable indirect-branch tracking */
 	wrmsr(MSR_IA32_U_CET, ENABLE_IBT_BIT);
 
 	run_in_user((usermode_func)cet_ibt_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
-	report(rvc, "Indirect-branch tracking test.");
+	report(rvc && exception_error_code() == 3, "Indirect-branch tracking test.");
 
 	write_cr4(read_cr4() & ~X86_CR4_CET);
 	wrmsr(MSR_IA32_U_CET, 0);
-- 
2.52.0.rc1.455.g30608eb744-goog


