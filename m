Return-Path: <kvm+bounces-33253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1423C9E8440
	for <lists+kvm@lfdr.de>; Sun,  8 Dec 2024 09:40:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BBE9318849F5
	for <lists+kvm@lfdr.de>; Sun,  8 Dec 2024 08:40:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F81513D276;
	Sun,  8 Dec 2024 08:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="XHgnNO7e"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE7013E028;
	Sun,  8 Dec 2024 08:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733647217; cv=none; b=hHRhH4kz6x+Fe/JrxpnObHGXtYYwEFj/upOIeocLlBa2oVN8MfS10gKNHSwA6FkTozGKUIMJ0jUu5j3DJJUrgxe9ueV4ekL5R9ULCS9aKhGmnNzDTZ0AupCVtWNNc44c+0VnBurFWfVo3eW5KS63PTb1TqZmpwaidUxQPQmzs8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733647217; c=relaxed/simple;
	bh=YDhTqJs7cdVyrsOqWw6VKLHpME/TC6wse3uJLjtYGJE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FBR9WaTEpU3yuEM/rc+QqYaF7sMhWK7jWNUDer45hPL7kek/mIGo8FDaesjlHQuSSuz90emn2TwekLToovxOUa2lrsWuso8D5F2fs4vk0U75IH7MdhrkXpPRG5pU3j36zLY3eYc7jwGAzBTSx0kCylSy90/3d/SiO7hRmtWyz68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=XHgnNO7e; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:3b05:0:640:71ba:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id A261960B61;
	Sun,  8 Dec 2024 11:37:59 +0300 (MSK)
Received: from kniv-nix.yandex-team.ru (unknown [2a02:6b8:b081:b71b::1:31])
	by mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id kbfFIq1Iga60-lp6MeZLk;
	Sun, 08 Dec 2024 11:37:59 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1733647079;
	bh=rVWwTNiyChLEkKx04wxCVkuEEVv9xSBQtvkQfDjGKS0=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=XHgnNO7e2lqHMtghLiu9enBKvwagJsgpjRxlxXreYxry4O3vVmNb/U3hk1pFSxTQt
	 9LnfHv/7DXYkKmlh/PxagquOseWpLT0cMDX1uNLVLoMHlaqgQTR3Q0vgFazNTW2cby
	 Oy8DRCHlJz5ookOhfuIg9obHGFRqYpSo7+Mg3GqY=
Authentication-Results: mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Nikolay Kuratov <kniv@yandex-team.ru>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@lst.de>,
	Nikolay Kuratov <kniv@yandex-team.ru>
Subject: [PATCH v2 6.1] KVM: x86/mmu: Ensure that kvm_release_pfn_clean() takes exact pfn from kvm_faultin_pfn()
Date: Sun,  8 Dec 2024 11:37:43 +0300
Message-Id: <20241208083743.77295-1-kniv@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since 5.16 and prior to 6.13 KVM can't be used with FSDAX
guest memory (PMD pages). To reproduce the issue you need to reserve
guest memory with `memmap=` cmdline, create and mount FS in DAX mode
(tested both XFS and ext4), see doc link below. ndctl command for test:
ndctl create-namespace -v -e namespace1.0 --map=dev --mode=fsdax -a 2M
Then pass memory object to qemu like:
-m 8G -object memory-backend-file,id=ram0,size=8G,\
mem-path=/mnt/pmem/guestmem,share=on,prealloc=on,dump=off,align=2097152 \
-numa node,memdev=ram0,cpus=0-1
QEMU fails to run guest with error: kvm run failed Bad address
and there are two warnings in dmesg:
WARN_ON_ONCE(!page_count(page)) in kvm_is_zone_device_page() and
WARN_ON_ONCE(folio_ref_count(folio) <= 0) in try_grab_folio() (v6.6.63)

It looks like in the past assumption was made that pfn won't change from
faultin_pfn() to release_pfn_clean(), e.g. see
commit 4cd071d13c5c ("KVM: x86/mmu: Move calls to thp_adjust() down a level")
But kvm_page_fault structure made pfn part of mutable state, so
now release_pfn_clean() can take hugepage-adjusted pfn.
And it works for all cases (/dev/shm, hugetlb, devdax) except fsdax.
Apparently in fsdax mode faultin-pfn and adjusted-pfn may refer to
different folios, so we're getting get_page/put_page imbalance.

To solve this preserve faultin pfn in separate local variable
and pass it in kvm_release_pfn_clean().

Patch tested for all mentioned guest memory backends with tdp_mmu={0,1}.

No bug in upstream as it was solved fundamentally by
commit 8dd861cc07e2 ("KVM: x86/mmu: Put refcounted pages instead of blindly releasing pfns")
and related patch series.

Link: https://nvdimm.docs.kernel.org/2mib_fs_dax.html
Fixes: 2f6305dd5676 ("KVM: MMU: change kvm_tdp_mmu_map() arguments to kvm_page_fault")
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
---
v1 -> v2:
 * Instead of new struct field prefer local variable to snapshot faultin pfn
 as suggested by Sean Christopherson. 
 * Tested patch for 6.1 and 6.12

 arch/x86/kvm/mmu/mmu.c         | 5 ++++-
 arch/x86/kvm/mmu/paging_tmpl.h | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 13134954e24d..d392022dcb89 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4245,6 +4245,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
 
 	unsigned long mmu_seq;
+	kvm_pfn_t orig_pfn;
 	int r;
 
 	fault->gfn = fault->addr >> PAGE_SHIFT;
@@ -4272,6 +4273,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (r != RET_PF_CONTINUE)
 		return r;
 
+	orig_pfn = fault->pfn;
+
 	r = RET_PF_RETRY;
 
 	if (is_tdp_mmu_fault)
@@ -4296,7 +4299,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		read_unlock(&vcpu->kvm->mmu_lock);
 	else
 		write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
+	kvm_release_pfn_clean(orig_pfn);
 	return r;
 }
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 1f4f5e703f13..685560a45bf6 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -790,6 +790,7 @@ FNAME(is_self_change_mapping)(struct kvm_vcpu *vcpu,
 static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct guest_walker walker;
+	kvm_pfn_t orig_pfn;
 	int r;
 	unsigned long mmu_seq;
 	bool is_self_change_mapping;
@@ -868,6 +869,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 			walker.pte_access &= ~ACC_EXEC_MASK;
 	}
 
+	orig_pfn = fault->pfn;
+
 	r = RET_PF_RETRY;
 	write_lock(&vcpu->kvm->mmu_lock);
 
@@ -881,7 +884,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
+	kvm_release_pfn_clean(orig_pfn);
 	return r;
 }
 
-- 
2.34.1


