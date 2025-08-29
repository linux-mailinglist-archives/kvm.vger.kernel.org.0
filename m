Return-Path: <kvm+bounces-56221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C2F7FB3AEF0
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 02:10:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 251AB3A5A02
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 00:10:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E548722B5A3;
	Fri, 29 Aug 2025 00:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qctSZMWs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EC7246BD7
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 00:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756426011; cv=none; b=c0INuxDmiDrNRzX11NnCa1amkE/ItAYagfPlCQ7LfT4dnO1pITV3pZokINWgp+EWt7cA/It1x4wcJscIDXVKB7p37CrY/fj7pgM7HBam8B5rzeQmp25nFKJM/ziJvnav2aXgURMF8IJqdicrMoc0iLIll47V33nU28Ly4M2nwUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756426011; c=relaxed/simple;
	bh=Tp7vZw/4x7cT5P0MVANvtyH0Aos8EMa3Yb5qw1+gtSY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KFOgYWj+Jd8We01o7Jr1CtUknqgE4n4WahM3q0hIDZtzzAouL8P8s3ZZrkrPZYhbQO8l8sFHrN3BHat4HPQH6wWGdRAuxH0wiBaUUpnO+8H+T7c2pgWhvtjuOlKLdHlI25exFyMnZYVvL/vV+BX8jVsOvwGXd2j0AJNTxuEfvCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qctSZMWs; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-772178f07f8so1238479b3a.1
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 17:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756426009; x=1757030809; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lGptiAZO7CmFsu6Op41QCgd3wduY0PZh1ZBQnGfhN3g=;
        b=qctSZMWszcdwOcWJ2u9i6YGxcZLzgIN/zYdVV6uBZvst+q8RCAyf7DvefMwwRTLNQo
         D8t8qMn/17YrT0xVoH6dVpbEQbXitGrvEhmyCN6dYY+kMHQkt+oR8BTzUE7+g5EG17no
         EmsOq9euS07LahNd1uLJRw+J2ZTO3Dodl7n1wOp3znSFiiysvA8ho97+jCVMf4d+ngkz
         3QWwJW0mxtwPkldtwQU9JTsbKGpgW4mvo3lWun51zZLXY+RhKzq4oWk24f98LLz8pM5F
         qAzNiiaH4PpLw/z0pqeEe+HAdn8V2uAUe6aiGVaFhObyRkKEeJ4ZF6wzK598ByJ2NipD
         uPvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756426009; x=1757030809;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lGptiAZO7CmFsu6Op41QCgd3wduY0PZh1ZBQnGfhN3g=;
        b=MREi/YzOd+qFWlUO6PgdhVFC08UPc0Qu200mUz9PzyPPy7m/eSGiFAQgIOAX5Yr9MQ
         rRlftXzu0f9oi5SftyEgyoHOtwCZbal4rB/AaHBR/LmORl5Sk+xIc2hV1aJTZVmHfW9m
         szBGEndsYrKPV3T5EZ4Q5jpjEjCjBFfQCizVyu/mvQCjt2cRvX7cSm5E4hpIzbXeQP64
         VcY+a/YFRs/pMAEozexO9q2rrBi5O0j+IVF6lGhGBeBwbV3Wp9q7JsvnQ6lSBs/fVlXj
         vjXDCDfgRXybmwi+xPr0pkqhVAz8mej0rFkWxRpIa3s8sNrOTS5Sil6CPxcDQH6cdNVC
         xhWA==
X-Gm-Message-State: AOJu0YxxlBwwkfhRXqaJ1+c6s6JayxBhLK1PPRwB7GR7N69V1+CrN7Uv
	xsehXEURKjCyvbqFmttaHQaCQBS+Cg0e0ws4iHUv7p/R1Oei7ywrHFKc0lm3ScEH32qVdBval6v
	7YhJCyw==
X-Google-Smtp-Source: AGHT+IGPnFjJJcAxcfWGqx+FCTkwrZqqa6fjukRalr0DOQARC9pSx1FQL9VEBdTmVjF2hDXjOKUOxbz2eFY=
X-Received: from pgbdp2.prod.google.com ([2002:a05:6a02:f02:b0:b42:da4:ef4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a109:b0:243:c315:5122
 with SMTP id adf61e73a8af0-243c3155335mr548500637.10.1756426008991; Thu, 28
 Aug 2025 17:06:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 28 Aug 2025 17:06:16 -0700
In-Reply-To: <20250829000618.351013-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250829000618.351013-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
Message-ID: <20250829000618.351013-17-seanjc@google.com>
Subject: [RFC PATCH v2 16/18] KVM: TDX: Derive error argument names from the
 local variable names
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

When printing SEAMCALL errors, use the name of the variable holding an
error parameter instead of the register from whence it came, so that flows
which use descriptive variable names will similarly print descriptive
error messages.

Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index df9b4496cd01..b73f260a55fd 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -41,14 +41,15 @@
 #define TDX_BUG_ON(__err, __fn, __kvm)				\
 	__TDX_BUG_ON(__err, #__fn, __kvm, "%s", "")
 
-#define TDX_BUG_ON_1(__err, __fn, __rcx, __kvm)			\
-	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx", __rcx)
+#define TDX_BUG_ON_1(__err, __fn, a1, __kvm)			\
+	__TDX_BUG_ON(__err, #__fn, __kvm, ", " #a1 " 0x%llx", a1)
 
-#define TDX_BUG_ON_2(__err, __fn, __rcx, __rdx, __kvm)		\
-	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx, rdx 0x%llx", __rcx, __rdx)
+#define TDX_BUG_ON_2(__err, __fn, a1, a2, __kvm)	\
+	__TDX_BUG_ON(__err, #__fn, __kvm, ", " #a1 " 0x%llx, " #a2 " 0x%llx", a1, a2)
 
-#define TDX_BUG_ON_3(__err, __fn, __rcx, __rdx, __r8, __kvm)	\
-	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx, rdx 0x%llx, r8 0x%llx", __rcx, __rdx, __r8)
+#define TDX_BUG_ON_3(__err, __fn, a1, a2, a3, __kvm)	\
+	__TDX_BUG_ON(__err, #__fn, __kvm, ", " #a1 " 0x%llx, " #a2 ", 0x%llx, " #a3 " 0x%llx", \
+		     a1, a2, a3)
 
 
 bool enable_tdx __ro_after_init;
-- 
2.51.0.318.gd7df087d1a-goog


