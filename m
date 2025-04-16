Return-Path: <kvm+bounces-43439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FC9EA904BA
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 15:48:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4EE69188C41D
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 13:48:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57A0D20767E;
	Wed, 16 Apr 2025 13:44:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDBC1DE4CA
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 13:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744811073; cv=none; b=lWVqQZep0t9r6QhctontFDvxSVQfSLPf5cJztfWf3LVyE34oCXVG6nizQPOAaSwg8OdJ8pGLCFulCxPtDwu3Q6183TV0pMzqYoyMguq8fqZZY7mDNwJFkR5XujjkubwMgwIcH+I/dlK7fVcOIJdpsnuNI5j+LfyC8b3cQgLbQjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744811073; c=relaxed/simple;
	bh=IC3advjk3xHp7EJnY4XpggVm8Uowi0VulroBe8wf+UQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cwRBecnhJ8XwRQq18uk8jTVJ/1Fpxbf1XrVZtZ58UPimYlSw0nMYxx0rtBF4zLcH92gy1bJiV/R/THnThzZhsqXgn6gDJN60/GFcGZFg8qcLdu4a9j022O9vRW8Mo2yIX3q9v4RSHttB2aZkPLkkKL9cKVso5Duk1ip9kda0F7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iie.ac.cn; spf=pass smtp.mailfrom=iie.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iie.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iie.ac.cn
Received: from localhost.localdomain (unknown [159.226.95.28])
	by APP-01 (Coremail) with SMTP id qwCowACHMQIatP9niEZKCQ--.14330S2;
	Wed, 16 Apr 2025 21:43:57 +0800 (CST)
From: Chen Yufeng <chenyufeng@iie.ac.cn>
To: seanjc@google.com
Cc: pbonzini@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	kvm@vger.kernel.org,
	chenyufeng@iie.ac.cn
Subject: [PATCH] kvm: x86: Don't report guest userspace emulation error to userspace in kvm_task_switch()
Date: Wed, 16 Apr 2025 21:43:25 +0800
Message-ID: <20250416134326.1342-1-chenyufeng@iie.ac.cn>
X-Mailer: git-send-email 2.43.0.windows.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowACHMQIatP9niEZKCQ--.14330S2
X-Coremail-Antispam: 1UD129KBjvJXoW7uFWfAF4fCFyrWF4Uur15Jwb_yoW8Gry5pr
	Z2k3s3ur1kJasYyayDKFWfWwn8Za4kGrnrGryDGay0qw45KasxXr4I93y5JF1fZws3Xa1f
	XF95XF1fCF1DAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9j14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxa
	n2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
	AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
	17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
	IF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4l
	IxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvf
	C2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: xfkh05xxih0wo6llvhldfou0/1tbiBgwOEmf-gV+fbAAAsj

This patch prevents that emulation failures which result from emulating
task switch for an L2-Guest results in being reported to userspace.

Without this patch a malicious L2-Guest would be able to kill the L1 by 
triggering a race-condition between an vmexit and the task switch emulator.

This patch is smiliar to commit fc3a9157d314 ("KVM: X86: Don't report L2 
emulation failures to user-space")

Fixes: 1051778f6e1e ("KVM: x86: Handle emulation failure directly in kvm_task_switch()")

Signed-off-by: Chen Yufeng <chenyufeng@iie.ac.cn>
---
 arch/x86/kvm/x86.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3712dde0bf9d..b22be88196ed 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11874,9 +11874,11 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 	 */
 	if (ret || vcpu->mmio_needed) {
 		vcpu->mmio_needed = false;
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
+		if (!is_guest_mode(vcpu)) {
+			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+			vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
+			vcpu->run->internal.ndata = 0;
+		}
 		return 0;
 	}
 
-- 
2.34.1


