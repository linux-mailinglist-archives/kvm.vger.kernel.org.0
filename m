Return-Path: <kvm+bounces-57965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CC01B82D52
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 05:55:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69BFF17E612
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 03:55:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C61E242D7C;
	Thu, 18 Sep 2025 03:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="W9RAvHvV"
X-Original-To: kvm@vger.kernel.org
Received: from out198-30.us.a.mail.aliyun.com (out198-30.us.a.mail.aliyun.com [47.90.198.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBB15680;
	Thu, 18 Sep 2025 03:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.198.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758167695; cv=none; b=UyW27wFkdQ2yAnKY0zId7w4GH+0gv63j5etapDJ6RiLR23Nm3pRYDEurdmnt4SduZ5YAlS0jYrssc9B+6/+p+Thcg1GZKx0PicTl7Vp4kajUgkCDuQ6Id485WfE8EuIoTO5a7SDslJSBsJdggzEmE5Pr5mIDL3Cka9uM9MFiJtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758167695; c=relaxed/simple;
	bh=alUYGA6GvFU0nR1WoHxLH4K/gUHxySZ4f64UAbwIu6U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KHk3W8oTIRhn+Wt7yWy4aNNDOgbh9kMahRTAjisOgsMl/sj+NDBAknaKRy1T59FrXxUKcBQ+92D6ydL1BVjruwzutwpFa9Mm8jJe0udTyVJOh2rkEodjg4Gt/GaWM3Tx7peboiiatA92REhOm+5c244JP19jz0+3sg/V79JGgt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=W9RAvHvV; arc=none smtp.client-ip=47.90.198.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1758167678; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=tRHDzYMehKJtnyqVrOz7oriZ6NEoN18vvwdHpqaGPwM=;
	b=W9RAvHvVKHG2Z0BaDKcF5/cPk8bdFkeR3+Y/ji/CJGjYoETSjt7zuqb4AbPjjrMywSpdQWvheS7iceZ+JZu7VAVpIMOy628MMd3WNufaGcuO3DeQfNOznMa35IY55l11bQHX4hWlVampBD7WmfMWsbTJw0ZkwaKEKngd+6vN41A=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.ehjHahQ_1758166737 cluster:ay29)
          by smtp.aliyun-inc.com;
          Thu, 18 Sep 2025 11:38:57 +0800
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
To: kvm@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: x86: Add helper to retrieve cached value of user return MSR
Date: Thu, 18 Sep 2025 11:38:50 +0800
Message-Id: <05a018a6997407080b3b7921ba692aa69a720f07.1758166596.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the user return MSR support, the cached value is always the hardware
value of the specific MSR. Therefore, add a helper to retrieve the
cached value, which can replace the need for RDMSR, for example, to
allow SEV-ES guests to restore the correct host hardware value without
using RDMSR.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/x86.c              | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cb86f3cca3e9..2cbb0f446a9b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2376,6 +2376,7 @@ int kvm_add_user_return_msr(u32 msr);
 int kvm_find_user_return_msr(u32 msr);
 int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
 void kvm_user_return_msr_update_cache(unsigned int index, u64 val);
+u64 kvm_get_user_return_msr_cache(unsigned int index);
 
 static inline bool kvm_is_supported_user_return_msr(u32 msr)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6d85fbafc679..88d26c86c3b2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -675,6 +675,14 @@ void kvm_user_return_msr_update_cache(unsigned int slot, u64 value)
 }
 EXPORT_SYMBOL_GPL(kvm_user_return_msr_update_cache);
 
+u64 kvm_get_user_return_msr_cache(unsigned int slot)
+{
+	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
+
+	return msrs->values[slot].curr;
+}
+EXPORT_SYMBOL_GPL(kvm_get_user_return_msr_cache);
+
 static void drop_user_return_notifiers(void)
 {
 	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);

base-commit: 603c090664d350b7fdaffbe8e6a6e43829938458
-- 
2.31.1


