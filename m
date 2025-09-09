Return-Path: <kvm+bounces-57139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7342AB50714
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 22:29:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47B993BDF6F
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 20:29:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AFED362086;
	Tue,  9 Sep 2025 20:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z7wUgZS8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5255D35CEDA
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 20:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757449722; cv=none; b=E9uTIDRxQ7v5S59vFGM0F8w62BIYxXCI2AYoKEvTxEiGct5Ui7zYwftKiKiORRmLjAvWYihBvg7eUAv521LK2IfgUEJCWPzkpLCbgstCO6pm/DEV9AHIy8YCJXCT8JJhBqi9JEx+aekD1JVWdnO1/utUMJ0/rkLKM3A0f46Az9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757449722; c=relaxed/simple;
	bh=uesFM1+MkFYhqTVfFaRpSNhPDaP6s1tVBFcYtshWXQ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ePywAnWZzZY441gKZN5iSES2+C7RHrBV2/0QXHlAovtOu6bcQjPjd2etFE+yvuh2v4X4nx3cACYmOeqQNHIFovjX0mk9Sg0L2UdEE12yQKdvTrrU3BlmYOdNNrR5M+B5QTTGh0q7/RDTadQ1K1tMy1W4PMlfAV45q1/3amEIbnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z7wUgZS8; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32b698861d8so5860823a91.2
        for <kvm@vger.kernel.org>; Tue, 09 Sep 2025 13:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757449720; x=1758054520; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VMcYZjELujYMlNUJYw4687AkNxPwf+pUCFf//dDPyoQ=;
        b=Z7wUgZS8w6muK/WkjnTz/HucNmRoESMpnkvxels+ns2l5GBftTFGZqyBTfDNnsYA/z
         sMlVwqxp3SUyw6cVewohwj1AnkL55UTxzy5Bh4lTse3lsnnfZvB8eQ0efYOfoscu3GmS
         L9oDBtWZkwCZDpg0JoE4KRWJtngexzo2vPYrJUFhmIvxqJ1khtZqqR7zajoefhLZQiDq
         Wd9aZ4R6k5kLvfZVk8oump2GNPTZiaAyPA7N2IHuX59CvA6GneW5i0qjR7XDKUdWqGnC
         4dlIkK1QidvR53BjDi0yVSToL3xOI2PSAcROsA1pTmB0rtnIpaJwBY78gjuromypKWSV
         4JDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757449720; x=1758054520;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VMcYZjELujYMlNUJYw4687AkNxPwf+pUCFf//dDPyoQ=;
        b=tpK+geD/Ol63/7D9pgud2oXxH5wlYHvo6/gFdzcQQRY99i8luvo5eIjsAIpiHGxRS4
         Mdso4UU9tRYB6a7vVIcCqD53epS/rNe02QWeI9xxH6hPRoChXkE/C5OlOKqQaFCiTDcj
         dmMmOh6EC0AJkee2tsB0Hyy5aKEc6rsn3TgHW1RAD1Njyw2KFEq01dAarQnFfvNT54KO
         nsGpvCo8bGG9yybB0rd36rDnBwmLGkRZlxyW5H+qLT9pluW9YGtpGi7dabYI1+DeNNAy
         S9nq4sPFlPstDZc/GWenxLderwbYehC8RE9mVi3B1DLKsx+SbTuCEoR2jhbWHLgqtg6x
         oWUQ==
X-Gm-Message-State: AOJu0YzUxSoFGY5LC8DvgOYibIOFAeupif0TMUXzdXdJst4VwOsBRe65
	ko/pziZYh9O+zZ24Cv95Xipqbi6dZSZ4pMA3/J8qOluuQh+I1SB8XE5bQew2Af218R+MH5gM8v2
	RwftS/Q==
X-Google-Smtp-Source: AGHT+IFBc+/15LTsqqJoc86kYHdS0+jzidyjkL/wyrFVCs4AAea75O4UJ8H3qPsHcOQvsjR0n0AGJWirWhU=
X-Received: from pjhu5.prod.google.com ([2002:a17:90a:5185:b0:32d:a0b1:2b03])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2fd0:b0:329:f535:6e3c
 with SMTP id 98e67ed59e1d1-32d43f9338cmr16979804a91.35.1757449720561; Tue, 09
 Sep 2025 13:28:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Sep 2025 13:28:32 -0700
In-Reply-To: <20250909202835.333554-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250909202835.333554-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909202835.333554-2-seanjc@google.com>
Subject: [PATCH 1/4] KVM: selftests: Add support for #DE exception fixup
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add support for handling #DE (divide error) exceptions in KVM selftests
so that the fastops test can verify KVM correctly handles #DE when
emulating DIV or IDIV on behalf of the guest.  Morph #DE to 0xff (i.e.
to -1) as a mostly-arbitrary vector to indicate #DE, so that '0' (the
real #DE vector) can still be used to indicate "no exception".

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86/processor.h | 6 ++++++
 tools/testing/selftests/kvm/lib/x86/processor.c     | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 2efb05c2f2fb..5142d1bf15a2 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1179,6 +1179,12 @@ struct idt_entry {
 void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 			void (*handler)(struct ex_regs *));
 
+/*
+ * Exception fixup morphs #DE to an arbitrary magic vector so that '0' can be
+ * used to signal "no expcetion".
+ */
+#define KVM_MAGIC_DE_VECTOR 0xff
+
 /* If a toddler were to say "abracadabra". */
 #define KVM_EXCEPTION_MAGIC 0xabacadabaULL
 
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index d4c19ac885a9..3b63c99f7b96 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -557,7 +557,7 @@ static bool kvm_fixup_exception(struct ex_regs *regs)
 		return false;
 
 	if (regs->vector == DE_VECTOR)
-		return false;
+		regs->vector = KVM_MAGIC_DE_VECTOR;
 
 	regs->rip = regs->r11;
 	regs->r9 = regs->vector;
-- 
2.51.0.384.g4c02a37b29-goog


