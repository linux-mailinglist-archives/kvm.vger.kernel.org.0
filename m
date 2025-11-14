Return-Path: <kvm+bounces-63260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id F2A96C5F479
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 21:52:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B4F6F4E0F48
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 20:51:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B132C2FC00D;
	Fri, 14 Nov 2025 20:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0cjR1tbC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695CD2FB0B5
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 20:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763153474; cv=none; b=MB4K1qbysAeLTsN8WwMcQ1t0DxsdJ6Tg0LxDd6BMS9bR72Zf8uPx7r74dvyAc8FXuZHptZh0S+bRUAlVLiGmQtuQ2yU034YnGEPHYL6Ge0HCB48xdSkvvX1hCqZVM8pxer7du2Slh4kxfIhlXKbVGOLjWj2StL9aqO+sxRmuNHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763153474; c=relaxed/simple;
	bh=cAHYEMPV5Ue3cDMq/9KzqyYxZs2JFAOGz0sZJKKOoyY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i3m//86gonr5ZqEEcfpr8uNWqJQSr+CCq0fAN/ynBgsYDSIxCtVTcwqTJakiQuYBkjBfaR4SwG/mwikpR0WxCWxIGgzYRJbizBZPcCz2Sw0bOs4StfaWQYzJotfmpRfywFWJqS7NO8FWpq0ElJ/HA9yCDWW4Bl/epBopIksLKB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0cjR1tbC; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3436d81a532so5260092a91.3
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 12:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763153473; x=1763758273; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xTK/gajImIIn6lJcu5soNjJIO8zc9G4q7tXRxQXjEkY=;
        b=0cjR1tbCUDT7triuhDaFQdCnnkIMxd1UxhWT86H/pmjtzhsZr7TzLH9im8iaRgmU8T
         iCvqQ8aox34vqyqlP2bvuGUuy54NbBgvL3e+vmRt9V6G5UjpmJo8jh2cL5/4nqXhQA9E
         phaZBt9/2zaq9WmQe9nfmpHefvUmjzYgDEVxf3p3d7yz5OPsZnZMzgt50F1TUb4WQYfo
         +0w5G9FY00mJfNE+CJ2Quws3JmPk7YUfa/YSB7k1spUKoo1G671SQP321Sohz6xjg427
         1B7lunS/zF1ZAfNr1rj1uN3x356OWUVY3mNQN2ZlXYVPmaSXgVbrbCazUsJA2IC5GUFf
         iXGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763153473; x=1763758273;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xTK/gajImIIn6lJcu5soNjJIO8zc9G4q7tXRxQXjEkY=;
        b=M6CqhwhuZPVrkdJiU4ot6WOmV4jNPW4kYqYppaOZNMNCx8jeIJMG5GgJd7bb2AIR+T
         5rOwGrbElYmVDIFsd0RfWvrnd8F/kg/Xvq31zE3xXYfFQHosLyDYb5eIpTcbjIxxE8PK
         d94Jt2RFPm4hU00Eo02DzrjJdfyGTlxLPDJQmsyh/48dip9O0AAEa/PdYf4FY4ZCnlWz
         jGwIhwtOur/gRkEbIpr0lQN4OFW62tqWSgVQX5T9oWejCk0F9aE0p+pfDOmawkxOyhXZ
         fApm+JmGjaFIbbs7mqDWP1QpctgWqJNRCbmECTDOCslmaGNzWvlvUzEuGZGhUd6H7RkZ
         4hmg==
X-Gm-Message-State: AOJu0YyW8CwM1nyhCHHYu4s6xGa3Sp3JLITPefoXYHhArs8NZArPCGgO
	bQaPxE0m8MLK6RQxcURUMoCMxREouipEiDGZ3Bt678nxwgScYoy9rHP10+SzInFjM4PE/V1uEQN
	G9jkoYA==
X-Google-Smtp-Source: AGHT+IGb/zBW1P0jE8VfFFwuKSurShzRBZv8A+buKVFkGbhszccPKogX3iDjCOzdf174EF4y4zIMWKXYu/c=
X-Received: from pjh8.prod.google.com ([2002:a17:90b:3f88:b0:340:d583:8694])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dc9:b0:340:29a1:1b0c
 with SMTP id 98e67ed59e1d1-343f9e93781mr5256898a91.7.1763153472629; Fri, 14
 Nov 2025 12:51:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Nov 2025 12:50:46 -0800
In-Reply-To: <20251114205100.1873640-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114205100.1873640-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114205100.1873640-5-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 04/18] x86: cet: Validate #CP error code
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>, Sean Christopherson <seanjc@google.com>
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
index c3ec0ad7..f896e3bd 100644
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


