Return-Path: <kvm+bounces-33907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82FA89F44C2
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 08:06:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1E7F163E42
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 07:06:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ACE91BA86C;
	Tue, 17 Dec 2024 07:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sang-engineering.com header.i=@sang-engineering.com header.b="WbsbE0dS"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zeus03.de (zeus03.de [194.117.254.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB64136A
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 07:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.117.254.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734419149; cv=none; b=NQAxsMPvatE+y5dfqp8Ll2yi/wS5aKROcFbiWDe919+8ipu/0dFegCF1oW8jSDV3aWsExmVflgLy8RH64CWOZbQIoAep06sublNGNsvpkpzDZfLp+lM88Z9zIhUZQ6IEBCWGhHDojEWeRYphejtWFUiNkcoCCTRlAnC+OBQ/wgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734419149; c=relaxed/simple;
	bh=Lc+1G97I0BqVNqRf6LskhslwoVcBSJs9pBY8LBR7Z2c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RyBntmaLNMI1s7GG6U3REUJzU2jln2x1zpOJgJ6Nh38YaXqPGb5wf6O0dQG8CitwdjeEz2R9UW9MqYnZzznuWGNZD9SYxVk5IA64BEEem8gUv1UAXJFLV/y4xQD5R7fFgO/j2wV9J0gt1jXwdnvbK4Z4z6TaiEPsprxMZrobDzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com; spf=pass smtp.mailfrom=sang-engineering.com; dkim=pass (2048-bit key) header.d=sang-engineering.com header.i=@sang-engineering.com header.b=WbsbE0dS; arc=none smtp.client-ip=194.117.254.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sang-engineering.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	sang-engineering.com; h=from:to:cc:subject:date:message-id
	:mime-version:content-transfer-encoding; s=k1; bh=Jj9YKc4JGlYKqi
	3wddfQwJLcdrMcblYlVMX/pwu+5lc=; b=WbsbE0dS60XRclWTgyahaYdum59udJ
	3I37tGUDge26GlzPPiaon2pR6pW9znL+3h/eDvN5gf3g5uFo41GSoQmaIRyUsI2K
	+YL6o6ct/VjYnz0VfHtfIiNg7IqqeLMgT+CHB5cwI6QX+6KOA8Dgj9IG7ZXEKhuR
	VOtA7xU7WaFUvvTamwoo1eI3VkKinYWTSf/hs1Fv+d2KmfVWT0dXDCutXPoOH43k
	nMPDpzmZdH/KjiJcM9w/PVuMZ5vrcGB4Lt2zG4n4+UHjYFGtLcsFUefHP8h6RLYL
	2dhtHe2QNKuhWWbU2jY4lfmohXyWBvwxWLUnK43fi4Vn8NLFC18c77bg==
Received: (qmail 3977771 invoked from network); 17 Dec 2024 08:05:41 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 17 Dec 2024 08:05:41 +0100
X-UD-Smtp-Session: l3s3148p1@pi7R7HEphL5ehhtS
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org
Subject: [PATCH] KVM: VMX: don't include '<linux/find.h>' directly
Date: Tue, 17 Dec 2024 08:05:40 +0100
Message-ID: <20241217070539.2433-2-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The header clearly states that it does not want to be included directly,
only via '<linux/bitmap.h>'. Replace the include accordingly.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 arch/x86/kvm/vmx/posted_intr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
index 1715d2ab07be..ad9116a99bcc 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -2,7 +2,7 @@
 #ifndef __KVM_X86_VMX_POSTED_INTR_H
 #define __KVM_X86_VMX_POSTED_INTR_H
 
-#include <linux/find.h>
+#include <linux/bitmap.h>
 #include <asm/posted_intr.h>
 
 void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu);
-- 
2.45.2


