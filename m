Return-Path: <kvm+bounces-15958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 592CA8B27F8
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 20:15:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BCC51C2163B
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 18:15:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74842152E15;
	Thu, 25 Apr 2024 18:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ktMJAweD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935DB15219E
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 18:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714068873; cv=none; b=uDPy5Kv15/TGxHztGT9LLajfHj/zjRxGZeP85vaDsgfZPl+gnhlBxhf03jofDy8s/6cMrPa/ehoN4wphld6sEcJBdv+kMwYd5JnoGqJQFTGOcC9UZJifLAZ4MBr+tZZSISL47dME2g5jdJs8I6Jpo+44XkXbM9UgJ3AJx1EzWRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714068873; c=relaxed/simple;
	bh=GoixATPRkeo59e28tmuFvVP3/afktWu/87EHx44xjSI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uiGPag8BsU/GJywqcm2jWdfCaA0MRDvjtD3i8Skxgw0ySUbRl6EcS3CGYMQU5Kf3+UJbIuVGc3LCMGvmYL0IJiT2kffNDYeCPfOk8S/BJpuOK4U3hdevf7dDwVx12Ezyp8gS9R8OVnDdhAK/AUb24w3YJWTdjgx95Gb9uRuVz3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ktMJAweD; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de45dba157dso2149997276.1
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 11:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714068870; x=1714673670; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LVg5nuhrtwhjBtsrJV2CSF5duP9EBWfXc7R02iwvnz8=;
        b=ktMJAweDPoYc7itWdEeY1kJk/uEageG8Hhg1pzu0wQxgl/lC4ewDnl3E8VfB73j+cc
         ClobG8/RIEXG3S9Ct5DBNPjyg3I9W4bTvMjdRIIyUjKaEvoe2fic4A0p4DH6XyrIi3RE
         xB5k4BXuTK45a+VqcmtKvvfa8LbU1a2fMpkikdLHLyxjGJjfUQXxy/5n6yEhj51Cu+m/
         M5Ndu2G4J+6a90xPWzEKd6rYm6hXMUibnXG2g1FR2+ZAKLkpYsMcT5+iQUslRlHJc2ce
         RSESEm/tVtFu2DIIbiRtF0kBnYSAZim/YHNbmvRFzVZYuWvW0phJA9GB3lcJ93D4Kd86
         Vd7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714068870; x=1714673670;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LVg5nuhrtwhjBtsrJV2CSF5duP9EBWfXc7R02iwvnz8=;
        b=nKp9Ux9ledK2BmjF+Z+uG4oLkeAjBJacj/SO69iJ+RYH51mm1QXSm1tlGwwVUNZhNG
         5s7FfkSTdQyrTHHWc347Mw5meOH2kUjPomYurBAf4ef8JGnZWZa5hLyzzDfigSIi7xhB
         5WXlWKtipBkjxb/RcdlkrMFZMsrScUv2PtGA8MyOQ6rhMt7uwelSFBGj25sOrFZ4zUk7
         dP73TUH1ruDy+SERL8i/74qMeL1Fo/SY2PVAbd0M4Hdtop0wFCnWiDB+Sh4GUvh5PZb6
         vG7mlA+2p/Avl47sE4OzcUzaUqEhoGasbFyvxuW71v6u+KlmPhivkMEkSmEzUqCyPAX7
         v/8Q==
X-Gm-Message-State: AOJu0YzkH62eQJc+a3K/2ZL7xgX2nSaNut9JPt3xHHI9uXPCdPQpD5W5
	6BPMVhtbtt7t6vcG6PzHldODU2bolx37mjMDHmt0GnYyT+CW6CedOfwzmkO1CfPaipdUY5PCFmY
	4rw==
X-Google-Smtp-Source: AGHT+IHCDwBc2r2TYqXQ9nf1YbD2mdDtQi6u0YYc4zNoU4v65TCevZQxfJIu9R7LSj/K/SiR1nBHzIwYJm4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:110e:b0:dcc:8927:7496 with SMTP id
 o14-20020a056902110e00b00dcc89277496mr52093ybu.5.1714068869932; Thu, 25 Apr
 2024 11:14:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 25 Apr 2024 11:14:14 -0700
In-Reply-To: <20240425181422.3250947-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240425181422.3250947-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240425181422.3250947-3-seanjc@google.com>
Subject: [PATCH 02/10] KVM: x86: Move MSR_TYPE_{R,W,RW} values from VMX to
 x86, as enums
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Weijiang Yang <weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Move VMX's MSR_TYPE_{R,W,RW} #defines to x86.h, as enums, so that they can
be used by common x86 code, e.g. instead of doing "bool write".

Opportunistically tweak the definitions to make it more obvious that the
values are bitmasks, not arbitrary ascending values.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.h | 4 ----
 arch/x86/kvm/x86.h     | 6 ++++++
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 90f9e4434646..243d2ab8f325 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -17,10 +17,6 @@
 #include "run_flags.h"
 #include "../mmu.h"
 
-#define MSR_TYPE_R	1
-#define MSR_TYPE_W	2
-#define MSR_TYPE_RW	3
-
 #define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index d80a4c6b5a38..a03829e9c6ac 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -497,6 +497,12 @@ int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva);
 bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 
+enum kvm_msr_access {
+	MSR_TYPE_R	= BIT(0),
+	MSR_TYPE_W	= BIT(1),
+	MSR_TYPE_RW	= MSR_TYPE_R | MSR_TYPE_W,
+};
+
 /*
  * Internal error codes that are used to indicate that MSR emulation encountered
  * an error that should result in #GP in the guest, unless userspace
-- 
2.44.0.769.g3c40516874-goog


