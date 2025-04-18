Return-Path: <kvm+bounces-43606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB83FA9312E
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 06:25:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAE44440C10
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 04:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CF84267B61;
	Fri, 18 Apr 2025 04:24:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965871CD15
	for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 04:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744950293; cv=none; b=HVW9EgBLmCQm8NzZicKWVil7917efDJvreCLTJlYoYm397ci7PgpGYUVxr9IyYd50yMy9/1y3Dzmv63E3t+DOmXG8g8SsUYULKEHDjNUpnKoz51E4OVBW51rbcG5LVuLhJevJT141u/hjkLJIp/pgsykx6MoQ+6s5RZ7h1KNrQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744950293; c=relaxed/simple;
	bh=UcLzApWTlaZJZCVj5dnmGM9ilFck9GmUfJn9wymEXFM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dPWI62PmT2fupyfZG0phS7IPpblTW6b5KWVf17vuL8dwBsL4Lu9MBSaR7lX3OeTNv8sFmPDGwIaG5Ac9iZlClH7H6MCgyJV3yLNvttR/6I4Z4JLVwj3+Kgy/BJOEF10pMuT08t8yta9+peu024PsYyiEO1jgo6REnGL7n7oTP8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iie.ac.cn; spf=pass smtp.mailfrom=iie.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iie.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iie.ac.cn
Received: from localhost.localdomain (unknown [159.226.95.28])
	by APP-03 (Coremail) with SMTP id rQCowAAnzTkH1AFo0fa9CQ--.20162S2;
	Fri, 18 Apr 2025 12:24:41 +0800 (CST)
From: Chen Yufeng <chenyufeng@iie.ac.cn>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	chenyufeng@iie.ac.cn
Subject: [PATCH] kvm: potential NULL pointer dereference in kvm_vm_ioctl_create_vcpu()
Date: Fri, 18 Apr 2025 12:24:21 +0800
Message-ID: <20250418042421.1393-1-chenyufeng@iie.ac.cn>
X-Mailer: git-send-email 2.43.0.windows.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAAnzTkH1AFo0fa9CQ--.20162S2
X-Coremail-Antispam: 1UD129KBjvJXoWrZr17trW7CF1UCF18Xw13Arb_yoW8Jr4xpF
	43Gw40qws8Ja1Dt3y7Cw1kZr18tanIgas7CFyUZw45ZF12yFn5uFyfKr909ry7CrW0qa93
	try5X3WUu3W5Cw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUym14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1Y6r17MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUywZ7UUUUU=
X-CM-SenderInfo: xfkh05xxih0wo6llvhldfou0/1tbiDAcQEmgBm-fewQAAsT

A patch similar to commit 5593473a1e6c ("KVM: avoid NULL pointer
 dereference in kvm_dirty_ring_push").

If kvm_get_vcpu_by_id() or xa_insert() failed, kvm_vm_ioctl_create_vcpu() 
will call kvm_dirty_ring_free(), freeing ring->dirty_gfns and setting it 
to NULL. Then, it calls kvm_arch_vcpu_destroy(), which may call 
kvm_dirty_ring_push() in specific call stack under the same conditions as 
previous commit said. Finally, kvm_dirty_ring_push() will use 
ring->dirty_gfns, leading to a NULL pointer dereference.

Signed-off-by: Chen Yufeng <chenyufeng@iie.ac.cn>
---
 virt/kvm/kvm_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e85b33a92624..3c97e598d866 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4178,7 +4178,9 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	xa_erase(&kvm->vcpu_array, vcpu->vcpu_idx);
 unlock_vcpu_destroy:
 	mutex_unlock(&kvm->lock);
+	kvm_arch_vcpu_destroy(vcpu);
 	kvm_dirty_ring_free(&vcpu->dirty_ring);
+	goto vcpu_free_run_page;
 arch_vcpu_destroy:
 	kvm_arch_vcpu_destroy(vcpu);
 vcpu_free_run_page:
-- 
2.34.1


