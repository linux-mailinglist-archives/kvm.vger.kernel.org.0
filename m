Return-Path: <kvm+bounces-63109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE364C5AA68
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:40:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49F113AD22E
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD41E32E6AD;
	Thu, 13 Nov 2025 23:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CM8oshXT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5408C32C95A
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 23:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763077076; cv=none; b=kAPRRk0wK3/0AJMPLIpfsDRpQfrGCDYVxwqZ0GCG56cQjHHxxEi6iemhPOH7vc2jnnSvKiayr8LZO/dUVVDr03sq847V1w9q2Sueil14HzZWPiqHi9EcPQrRSNOvYttQBrer8jzW3MXxEmgOKABHYXklyN/5/blQZ5H3WdAA8QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763077076; c=relaxed/simple;
	bh=9/ZEG9qS0v5yHmDM5mNncrn+pJi6DDL3CwwPd50ORBk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dQYhLp/k8HDgctyv+MpeuQ1nqtaqmySur4WZTOhTuuAn/nKyCbS1gWGpB5hkOwln4158M7DYUB28kNmJKXo1qLKaGd30dfNECsdP9eQArsuvZTWDtn3S0CRtRxU729jTjuPgGu4Bq3dKlsTAhaW7U9nZZGcr+kn/oF4X+deEDpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CM8oshXT; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-297fbfb4e53so26638935ad.1
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 15:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763077074; x=1763681874; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jX3Feop83q2z4Q+hCWNf+/7P2WvpoKPC/BxcXVensJI=;
        b=CM8oshXTrd4XHk/baxaU0GMqOxQlqdrluN59AhGsW1YbkYpMx6pa0n2F8RK7UtYr3m
         /EWY8ba/0bv76djwtHkonpKPqJHDcf6dTRMgkcvqj0tX6VnnTFV2/paAHY+xBf95WmoX
         2Xu75IlTklSzYmYrucrJ2flo67fJLIZf5Qf0DxTg8oE64XTYBWwlPLcSV+2H+szuRdkH
         qxQo9dOimE8WXzI30bLZTzMlHMmDAVwLxYqzb3SOKgL4uWkC339LC6S72Xg/whzWGvVW
         MA7fEIZa6va2Ugy5zyGEtRl8k2s+K+R7M9Cp1fIFLV/VhC6C1CZj7sPHvHNsO/XfqIOX
         Cs8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763077074; x=1763681874;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jX3Feop83q2z4Q+hCWNf+/7P2WvpoKPC/BxcXVensJI=;
        b=Tam3aRKpVBgkvazzSnVEVPPAq3TR2G7byoS/eQO3S7QdrPK30FKKd0uyus5AmijpHr
         h8lWDnssHfiuFDHwL0IwbrEZCgtPpiOzWIa8tLuMOGVMzdmIApEYenPIGXAxJ+xEv939
         rxMyFktrNtfnmiQN/dcjxPY0axlo4HNMymeRvs1F4sQ4NXrlbPNqLtwu3+XCYiTKn8Uw
         fCrk7IGjOQ59PZqMAgSzDm0cPIdjlesEdFVe5aiHVSYkzC7AIDH0B/wuDkfxz0FW/1G2
         nKVPxGeQXiwUeKZtuxsJqvI2PmvWi8L3ABNnzKoO37GKsFIBNHku2ys6d8zu0TgG4Spf
         gllQ==
X-Gm-Message-State: AOJu0YzIlCt9o05VuNR5Hzo657Ct/dx6wETrga/Vq/xjjdRnAYkDHsn7
	Yhc28CA0IMKvC4L/yYWhFBkYLPfXnno2tECN6z9kRfv4D0d0lETxoqFcucx1dstSDK9aZzB3zta
	6E0UAQg==
X-Google-Smtp-Source: AGHT+IHJOzZDPILzi8nste2JY0ljSD09D7AMJE4IfZRr7nMUO63lLcqgpVvpjyngQFZ2bq/QcuhX1dI5i0Q=
X-Received: from plrq24.prod.google.com ([2002:a17:902:b118:b0:298:a8:6ab2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:b0d:b0:295:70cc:8ec4
 with SMTP id d9443c01a7336-2986a74b360mr8908115ad.51.1763077073730; Thu, 13
 Nov 2025 15:37:53 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 15:37:40 -0800
In-Reply-To: <20251113233746.1703361-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113233746.1703361-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113233746.1703361-4-seanjc@google.com>
Subject: [PATCH v5 3/9] x86/bugs: Decouple ALTERNATIVE usage from VERW macro definition
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

Decouple the use of ALTERNATIVE from the encoding of VERW to clear CPU
buffers so that KVM can use ALTERNATIVE_2 to handle "always clear buffers"
and "clear if guest can access host MMIO" in a single statement.

No functional change intended.

Reviewed-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/nospec-branch.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 08ed5a2e46a5..8b4885a1b2ef 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -308,24 +308,24 @@
  * CFLAGS.ZF.
  * Note: Only the memory operand variant of VERW clears the CPU buffers.
  */
-.macro __CLEAR_CPU_BUFFERS feature
 #ifdef CONFIG_X86_64
-	ALTERNATIVE "", "verw x86_verw_sel(%rip)", \feature
+#define VERW	verw x86_verw_sel(%rip)
 #else
-	/*
-	 * In 32bit mode, the memory operand must be a %cs reference. The data
-	 * segments may not be usable (vm86 mode), and the stack segment may not
-	 * be flat (ESPFIX32).
-	 */
-	ALTERNATIVE "", "verw %cs:x86_verw_sel", \feature
+/*
+ * In 32bit mode, the memory operand must be a %cs reference. The data segments
+ * may not be usable (vm86 mode), and the stack segment may not be flat (ESPFIX32).
+ */
+#define VERW	verw %cs:x86_verw_sel
 #endif
-.endm
 
+#define __CLEAR_CPU_BUFFERS	__stringify(VERW)
+
+/* If necessary, emit VERW on exit-to-userspace to clear CPU buffers. */
 #define CLEAR_CPU_BUFFERS \
-	__CLEAR_CPU_BUFFERS X86_FEATURE_CLEAR_CPU_BUF
+	ALTERNATIVE "", __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF
 
 #define VM_CLEAR_CPU_BUFFERS \
-	__CLEAR_CPU_BUFFERS X86_FEATURE_CLEAR_CPU_BUF_VM
+	ALTERNATIVE "", __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF_VM
 
 #ifdef CONFIG_X86_64
 .macro CLEAR_BRANCH_HISTORY
-- 
2.52.0.rc1.455.g30608eb744-goog


