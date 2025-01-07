Return-Path: <kvm+bounces-34656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7BCBA036FF
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 05:26:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1AF087A2375
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 04:26:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F30C519DF8B;
	Tue,  7 Jan 2025 04:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GuiObUEM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8700198E63
	for <kvm@vger.kernel.org>; Tue,  7 Jan 2025 04:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736223965; cv=none; b=Di9INZr+/C+TFe6Cy3qZbgRwJy4Pi4/YuFhcdaLhPI6zExy3aggFNr96u2E0Q/PVo7Oo59XydCI/11ONFY/ncNUzqsxh5qRLsLFs6E7uELeu5AdWgsYdvc0HgpCuuuXt35T3RKyIhzIN9HH0fVOf5ZdWOQg+J5V+hC9mtaDJEYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736223965; c=relaxed/simple;
	bh=8ueD4jWvDQYZmXFbiwtcz9JxzGlg99ZnxpkF4nuFXeQ=;
	h=Date:In-Reply-To:Message-Id:Mime-Version:References:Subject:From:
	 To:Cc:Content-Type; b=tBzeq2G9ilmkwk6EhgXLqx1eeUK9Q7iblf6xh7zXI7hYPk7ZDA7wQFzdefWjKCEpf9d4zo7P71lVNyXY+U4aAUkfrvVMYT0G4gaZqHcwZ45Mi0879XnatqR3XSWFG4jP1wS7FKGSlRk1TlqcoNgw/vOB7kPuhr/DbVzpAMQO/jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GuiObUEM; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e3988f71863so34182235276.0
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 20:26:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736223963; x=1736828763; darn=vger.kernel.org;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NA213tAcZh4I3DpXocCWo8NBOW1Vq5W1/tV9hgW9Pn8=;
        b=GuiObUEMuXhsqCtqJBvJCbY7GEz/yrUmWM+UudZcSei5x6T97n2Doujt2PTmjkPBpv
         G6mR71BBicIOVwbtn+6Xs2u5JVMIqBfVvO4jEDvNZL5oj+5QfVgF1Uw4mUK8marFjqt6
         VpjSAM8UL+00HrwEEWIenfWUEimV10v+VIuvHpOacifXfxOkMg3olsA+4Q+eOD+SOzpR
         Gh+f8RXKH5kialHV1IOEc6ZwFkP4q7pNhc4+4zvKLkzYxnw+3WOCS9AFW4Em5JKRyBMJ
         UoJ90W5vnV25QoUXcDRbuSyZq1djM35xhf/I7VTGoRl3x7cdTkWgD+hxnTpRhbrNLnUe
         Dh6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736223963; x=1736828763;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NA213tAcZh4I3DpXocCWo8NBOW1Vq5W1/tV9hgW9Pn8=;
        b=jZIhhs+pYiKJonDb7KFQsVOUzbX5aLqcdT2I6sOgWqUDHqKxgmXQSQwwUxF2KOHAf4
         8lKqLYU+BqdK+v3M+ixeVQFO1Fp5w5eBysMAfBS4AQp+xSRqt2/GyRATeMSyZ5MBokTL
         Ee56hZ2JjnIbfbQYh4rIL/TK1FAjU/9UA7f19MfvJkmRor0Gs/X/qzfrRVJ/ysQLkqfa
         CEgICg0bTr81HLSq3tUoDQPJw71q5t0+uOPiZpV0czW5+5FPqR/jG0r1qnJmlItZm943
         SvydKXQKmoo5I+sbCqB+nrUOIeJNrNQkzmGNgydql8qk2XejqDfoCa07BSandgbVTs+P
         SBWA==
X-Forwarded-Encrypted: i=1; AJvYcCWf62wb/iYwWW8ZdN138vD3IqJGq+P26lZPI3C7BnJnoeKGvDK3Qk0h0FvzatmrgT3TsT4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXx56/vn9YyeGZgRaSFyZXZ5fSOyTXjT1mQe0rom/sSKIlLIeI
	Ls5MQ28H9PEchcF9bxYT62R0dcgmZqbqO2ivxNIJVpaF8xldFyVQsAqTSlsRx/X28u+s3Y/xTRv
	T2yt0LVMVpg==
X-Google-Smtp-Source: AGHT+IGkMfbK8LFTyqa2WHNChhrC1EmxtYD81Q8wDfhlgq+6CGJjihWtDqxm7J7NyHBHnty4sQQAhU3Kr/hDiQ==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:66b9:6412:4213:e30a])
 (user=suleiman job=sendgmr) by 2002:a05:690c:201a:b0:6e3:f32:5fc8 with SMTP
 id 00721157ae682-6f3f80cd036mr1676287b3.1.1736223962893; Mon, 06 Jan 2025
 20:26:02 -0800 (PST)
Date: Tue,  7 Jan 2025 13:21:59 +0900
In-Reply-To: <20250107042202.2554063-1-suleiman@google.com>
Message-Id: <20250107042202.2554063-2-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250107042202.2554063-1-suleiman@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Subject: [PATCH v3 1/3] kvm: Introduce kvm_total_suspend_ns().
From: Suleiman Souhlal <suleiman@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssouhlal@freebsd.org, Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"

It returns the cumulative nanoseconds that the host has been suspended.
It is intended to be used for reporting host suspend time to the guest.

Change-Id: I8f644c9fbdb2c48d2c99dd9efaa5c85a83a14c2a
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      | 26 ++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 401439bb21e3e6..cf926168b30820 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2553,4 +2553,6 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 				    struct kvm_pre_fault_memory *range);
 #endif
 
+u64 kvm_total_suspend_ns(void);
+
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index de2c11dae23163..d5ae237df76d0d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -889,13 +889,39 @@ static int kvm_init_mmu_notifier(struct kvm *kvm)
 
 #endif /* CONFIG_KVM_GENERIC_MMU_NOTIFIER */
 
+static u64 last_suspend;
+static u64 total_suspend_ns;
+
+u64 kvm_total_suspend_ns(void)
+{
+	return total_suspend_ns;
+}
+
+
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
+static int kvm_pm_notifier(struct kvm *kvm, unsigned long state)
+{
+	switch (state) {
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
+		last_suspend = ktime_get_boottime_ns();
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
+		total_suspend_ns += ktime_get_boottime_ns() - last_suspend;
+	}
+
+	return NOTIFY_DONE;
+}
+
 static int kvm_pm_notifier_call(struct notifier_block *bl,
 				unsigned long state,
 				void *unused)
 {
 	struct kvm *kvm = container_of(bl, struct kvm, pm_notifier);
 
+	if (kvm_pm_notifier(kvm, state) != NOTIFY_DONE)
+		return NOTIFY_BAD;
+
 	return kvm_arch_pm_notifier(kvm, state);
 }
 
-- 
2.47.1.613.gc27f4b7a9f-goog


