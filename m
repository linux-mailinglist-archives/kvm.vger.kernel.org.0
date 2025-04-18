Return-Path: <kvm+bounces-43663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B005A93813
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 15:45:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B77919E5350
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 13:45:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF51441C64;
	Fri, 18 Apr 2025 13:45:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77DF29A0
	for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 13:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744983915; cv=none; b=H+q+S9VxesgT5ybgDNqaHgtOcBR2blpGvEOSt1/06ydUMrbjkaml+3DB5tk/go810X7biBIdgYM+agKRC5kvxb/bRz3r0nXLYIyAysNJ3G3hedFcuBvqV5HxSz9jvh2BHqFO+y8pMNugt0Hs5Q+vr/tao3NMuwlPPpOllZnsJDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744983915; c=relaxed/simple;
	bh=eaYdj/zAC6YB0prFHSJ3DGQmAAMOIdtBvlc2Vneh/Ck=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g+FFIlNADirCOOcoe4HM/gXTu3nmivghl3NgyMLej35mAOWK6eWYMsBV0BXVLogMEsB/VdJcPlvQd20RTps70NTo5F/0GYfs6n9l2Cc4OmWcjNnsuP1NvuJ0s26fI+bPvfZHLqWDLO/CW0aesJUq67DF9XnOuYyX9ZuRYt4qdPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iie.ac.cn; spf=pass smtp.mailfrom=iie.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iie.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iie.ac.cn
Received: from localhost.localdomain (unknown [159.226.95.28])
	by APP-03 (Coremail) with SMTP id rQCowAD3mzhWVwJoQDHdCQ--.24362S2;
	Fri, 18 Apr 2025 21:44:56 +0800 (CST)
From: Chen Yufeng <chenyufeng@iie.ac.cn>
To: pbonzini@redhat.com
Cc: chenyufeng@iie.ac.cn,
	kvm@vger.kernel.org
Subject: [PATCH v2] kvm: potential NULL pointer dereference in kvm_vm_ioctl_create_vcpu()
Date: Fri, 18 Apr 2025 21:44:39 +0800
Message-ID: <20250418134440.379-1-chenyufeng@iie.ac.cn>
X-Mailer: git-send-email 2.43.0.windows.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAD3mzhWVwJoQDHdCQ--.24362S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Wry7CFWxGF47tF13WryDWrg_yoW8Xr15pF
	43Gw10qr45Jw1jy3y3G3s5ZryjganIgas7CFyjvws8ZF12yFn5ZF1Skr909r17urW8Xayf
	try5X3WUu3WUCw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyq14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAKI48J
	MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwV
	AFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUXVWUAwCIc40Y0x0EwIxGrwCI42IY6xIIjxv2
	0xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4
	v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AK
	xVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfU5WlkUUUUU
X-CM-SenderInfo: xfkh05xxih0wo6llvhldfou0/1tbiBwkQEmgCI3mOVQAAsn

A patch similar to commit 5593473a1e6c ("KVM: avoid NULL pointer
 dereference in kvm_dirty_ring_push").

If kvm_get_vcpu_by_id() or xa_insert() failed, kvm_vm_ioctl_create_vcpu() 
will call kvm_dirty_ring_free(), freeing ring->dirty_gfns and setting it 
to NULL. Then, it calls kvm_arch_vcpu_destroy(), which may call 
kvm_dirty_ring_push() in specific call stack under the same conditions as 
previous commit said. Finally, kvm_dirty_ring_push() will use 
ring->dirty_gfns, leading to a NULL pointer dereference.

v2:
 - fixed in better way by just moving the position of kvm_dirty_ring_free

v1: https://lore.kernel.org/kvm/596ce9b2-aa00-4bc5-ae20-451f3176d904@redhat.com

Signed-off-by: Chen Yufeng <chenyufeng@iie.ac.cn>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e85b33a92624..089efc4d01c6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4178,9 +4178,9 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	xa_erase(&kvm->vcpu_array, vcpu->vcpu_idx);
 unlock_vcpu_destroy:
 	mutex_unlock(&kvm->lock);
-	kvm_dirty_ring_free(&vcpu->dirty_ring);
 arch_vcpu_destroy:
 	kvm_arch_vcpu_destroy(vcpu);
+	kvm_dirty_ring_free(&vcpu->dirty_ring);
 vcpu_free_run_page:
 	free_page((unsigned long)vcpu->run);
 vcpu_free:
-- 
2.34.1


