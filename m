Return-Path: <kvm+bounces-68595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 66A6FD3C3C6
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 10:39:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C4AE566865D
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 09:17:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 574183D1CD2;
	Tue, 20 Jan 2026 09:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="TExkpRhP"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F8E3AA182;
	Tue, 20 Jan 2026 09:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768900570; cv=none; b=PELF5NM58h6YI/2n/rb48/uVIhQ79dZ4laVWsNw8/TsI4hyUwicPrAWMaA6hR3zB//T0bNxkLS0ojiP1a5bdx+8n8ly+ZjVGegC4I6twQPlzBEYM0/iOi5le13PU8gWUTK89ExDzR5xyBLuZXvad4Ziql1q4EC4OJP/Qir05y0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768900570; c=relaxed/simple;
	bh=m9yRsZxqZ72hs3JIeNkMtMnPukmK9ziztVXzSQGfZgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOhVWSbDL/unMyjnHzKKjmBlMt39wfkazO3PyOLjys4XGPAWR3NM1ae+j0aVYF9eKQBBNqi0YKwxEWWOOobMFxzovlxKOV4ONdlGQ6SZ1EH4Mqdka+VwdGN1sjE0Et2+tFrEOaOtUKf9f1pZ0J2O/5FISrBqiRlEx631MW/KOFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=TExkpRhP; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=9/
	37MfyB2vsEX90dMNuzNx9fIxgfnpHXIinZTsCQAo0=; b=TExkpRhPOkZ2uc64Sr
	4NRRJwM0phSWsPhIu3YHR5E8T3hd2cpqRDL0tsSDa5QQH5DbYiPnmKelnlRzskJX
	IZIt7tZCz3VtJ2wnM8mDZ7LP1B4bG2tll0RpHBRnaCe85Xd4H7tsCfeNig+Hd3nk
	osm1Hj29R7vcAbMdfnW5yjluQ=
Received: from 163.com (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wCn5zu4R29pIOfPGw--.26432S4;
	Tue, 20 Jan 2026 17:15:42 +0800 (CST)
From: Zhiquan Li <zhiquan_li@163.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	shuah@kernel.org
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhiquan_li@163.com
Subject: [PATCH 2/5] KVM: x86: selftests: Alter the hypercall instruction on Hygon
Date: Tue, 20 Jan 2026 17:14:45 +0800
Message-ID: <20260120091449.526798-3-zhiquan_li@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260120091449.526798-1-zhiquan_li@163.com>
References: <20260120091449.526798-1-zhiquan_li@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCn5zu4R29pIOfPGw--.26432S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7uryUuFyDuFykCryrZFyDAwb_yoW8Ar13p3
	WkJw1FkF1IqF1aya4xWw4kXr18GrZrWay0yws2yFZxAF17Jw1xXF47KF12kasxuFZ5Z3Zx
	Z3Z2va1Uur1UJwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zilfOOUUUUU=
X-CM-SenderInfo: 52kl13xdqbzxi6rwjhhfrp/xtbC6h43IGlvR77HTAAA3X

Hygon architecture uses VMMCALL as guest hypercall instruction, so
utilize the Hygon specific flag to avoid the test like "fix hypercall"
running into the wrong branches and using VMCALL, then causing failure.

Signed-off-by: Zhiquan Li <zhiquan_li@163.com>
---
 tools/testing/selftests/kvm/lib/x86/processor.c      | 3 ++-
 tools/testing/selftests/kvm/x86/fix_hypercall_test.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index bbd3336f22eb..64f9ecd2387d 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -1229,7 +1229,8 @@ const struct kvm_cpuid_entry2 *get_cpuid_entry(const struct kvm_cpuid2 *cpuid,
 		     "1: vmmcall\n\t"					\
 		     "2:"						\
 		     : "=a"(r)						\
-		     : [use_vmmcall] "r" (host_cpu_is_amd), inputs);	\
+		     : [use_vmmcall] "r"				\
+		     (host_cpu_is_amd || host_cpu_is_hygon), inputs);	\
 									\
 	r;								\
 })
diff --git a/tools/testing/selftests/kvm/x86/fix_hypercall_test.c b/tools/testing/selftests/kvm/x86/fix_hypercall_test.c
index 762628f7d4ba..0377ab5b1238 100644
--- a/tools/testing/selftests/kvm/x86/fix_hypercall_test.c
+++ b/tools/testing/selftests/kvm/x86/fix_hypercall_test.c
@@ -52,7 +52,7 @@ static void guest_main(void)
 	if (host_cpu_is_intel) {
 		native_hypercall_insn = vmx_vmcall;
 		other_hypercall_insn  = svm_vmmcall;
-	} else if (host_cpu_is_amd) {
+	} else if (host_cpu_is_amd || host_cpu_is_hygon) {
 		native_hypercall_insn = svm_vmmcall;
 		other_hypercall_insn  = vmx_vmcall;
 	} else {
-- 
2.43.0


