Return-Path: <kvm+bounces-53643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F35AB1504A
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 17:41:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 215AB18A4F21
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 15:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82DF12951CE;
	Tue, 29 Jul 2025 15:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JGQyaGNm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F7E2951A0
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 15:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753803545; cv=none; b=JiGuMLrYkp3nwBmNfUoDBtLuYU3/lMlC2ESYtXCSNOpPr6Iz+qv3kLrVlEDLTupN0RNxRC8p3VaoUYhdUvjeXGKWjDFLVYqzJLf+MHnDJQIUPBM7f99VopiOM4gkNVs9P37V02h21IampIkXZ4IB8gNT5di0+9l1hvqpfgixDrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753803545; c=relaxed/simple;
	bh=OfOL42eD9JTUc+4eGZAYldNVEOn18zoOKYFUTi9OmhY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=FEctBp9fcA8B0O5O1xUrdxL1BLgHLvU39C6BpAbwERVOtDgW3gWKNGaNy1YURtn6x0MJxe8JONhRrxY+5ocqMLiO7WFS0bpEngwjf7V64gMqy6y4lKpMSvifPIt+bv+3tif4wZF803/UN3t/hJDw95n6d9g/5CbC82d11YDzROk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JGQyaGNm; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31f3b65ce07so867344a91.1
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 08:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753803543; x=1754408343; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Glsh0iAv4o3uNk39nP/OoAS1uxmDAWFJSCvfZQY8U3w=;
        b=JGQyaGNm3fzX9r8HveAMNMyGM1Y8v90TYKyNm6RoQGeYx1pVL3pIAjrlb5Za/4iMG6
         y8VCW7iD464VUFx/wFJ9wx3lslCr87y1a8BU2BUTR/sJm0c+6Kpo2QMkvVSO2tT7h0uJ
         SqkpsuUd5aB9RF5+xQzP/va+FkUtjm9+AW0CH75P1kcMdMc4HfkqYcB76IY6P56W6Zg7
         FMfJodDfRnen80P7GFTdj0+pxTThmx6KJaiJ6E8XwcrUEeL1unF0KRqTgVnF3x+KQuNL
         cw5ktlfdMK/Fs/EMRXf4XZc0ZcOKtuejsmQPskUzCLX8jPMEkVYFPnuxwuuAiHm5YSfK
         sSNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753803543; x=1754408343;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Glsh0iAv4o3uNk39nP/OoAS1uxmDAWFJSCvfZQY8U3w=;
        b=GHfWQXXRs6uhaMX2CFzwVi/oJVYtNIQ+srLQmzEODho/tdSTOdhRfU4sMBsNssmJDu
         Ej04SMeYtP/yp3o1nwO2GfQhqWjT07ugiNO6vV0GhDMlLBV1vRp7qBXKzBrbBNqeWtLv
         eZ5AgmPDkuuY9hHCHH7xqh+oMAAIW6vEO5Xncro5WZdByZmz8Y564uXHvf5fXBHOSy+o
         bGIj7UmbOkRD2kxmJWACPBUetwI1uOiHbWZNYz8nEEFZE9T6tg/QRB0I1g6aEkGEEzoR
         RSkdnZvkZxM3q2Y9l0YHJQqNPIoEB9xMiccpyWGxBGo/uYoi3zKpfsZhTCYnpCxlIHhS
         vDuw==
X-Gm-Message-State: AOJu0YznpbcAx+K7BwbzSlg8u5wBKVqy/1yJ+qJyfL53NMOOTBH4MwaY
	4RoNGPDoYHd5BWlp72TXkY/eoBtISzr8OBxa30Mjqr/5VBcZoSg0IJuUWcRD9vVRRXJrUdFtJfW
	cYMpNYA==
X-Google-Smtp-Source: AGHT+IF+TXpdC+oVnYt+YHocSx/QqcMuplDXaRRM2xGX1W6yq4xq1t881NAizm2HIeClnrMQru1DE3cPUfk=
X-Received: from pjbsr11.prod.google.com ([2002:a17:90b:4e8b:b0:31e:cee1:4d04])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:240b:b0:31e:ebb6:6499
 with SMTP id 98e67ed59e1d1-31eebb6657emr9096042a91.24.1753803543611; Tue, 29
 Jul 2025 08:39:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 08:39:01 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.487.gc89ff58d15-goog
Message-ID: <20250729153901.564123-1-seanjc@google.com>
Subject: [PATCH] x86/kvm: Make kvm_async_pf_task_wake() a local static helper
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Make kvm_async_pf_task_wake() static and drop its export, as the symbol is
only referenced from within kvm.c.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_para.h | 2 --
 arch/x86/kernel/kvm.c           | 3 +--
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 57bc74e112f2..4a47c16e2df8 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -124,7 +124,6 @@ bool kvm_para_available(void);
 unsigned int kvm_arch_para_features(void);
 unsigned int kvm_arch_para_hints(void);
 void kvm_async_pf_task_wait_schedule(u32 token);
-void kvm_async_pf_task_wake(u32 token);
 u32 kvm_read_and_reset_apf_flags(void);
 bool __kvm_handle_async_pf(struct pt_regs *regs, u32 token);
 
@@ -148,7 +147,6 @@ static inline void kvm_spinlock_init(void)
 
 #else /* CONFIG_KVM_GUEST */
 #define kvm_async_pf_task_wait_schedule(T) do {} while(0)
-#define kvm_async_pf_task_wake(T) do {} while(0)
 
 static inline bool kvm_para_available(void)
 {
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 921c1c783bc1..180a8c146846 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -190,7 +190,7 @@ static void apf_task_wake_all(void)
 	}
 }
 
-void kvm_async_pf_task_wake(u32 token)
+static void kvm_async_pf_task_wake(u32 token)
 {
 	u32 key = hash_32(token, KVM_TASK_SLEEP_HASHBITS);
 	struct kvm_task_sleep_head *b = &async_pf_sleepers[key];
@@ -241,7 +241,6 @@ void kvm_async_pf_task_wake(u32 token)
 	/* A dummy token might be allocated and ultimately not used.  */
 	kfree(dummy);
 }
-EXPORT_SYMBOL_GPL(kvm_async_pf_task_wake);
 
 noinstr u32 kvm_read_and_reset_apf_flags(void)
 {

base-commit: 038d61fd642278bab63ee8ef722c50d10ab01e8f
-- 
2.50.1.487.gc89ff58d15-goog


