Return-Path: <kvm+bounces-32782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B1819DF07C
	for <lists+kvm@lfdr.de>; Sat, 30 Nov 2024 14:27:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19895B21376
	for <lists+kvm@lfdr.de>; Sat, 30 Nov 2024 13:27:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7103119A281;
	Sat, 30 Nov 2024 13:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="QM1uTdQy"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121AC42AA4;
	Sat, 30 Nov 2024 13:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732973261; cv=none; b=jUzvONVUwelRYsFS1rnpbR192u8dv8ghxSF7MUJPaGEQ+AlY4nPW3HgsbYGZMT09AMzQH8C5Lqoi4y6KycmCom8ZUatFgxbkkZOVA8cMkqYvXPYQAjHqf9gGcD3Q6ns6AwCu6O29pnlJDceBQHNNH1Y8jhpetbh+od8ETjWHaeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732973261; c=relaxed/simple;
	bh=4Ed0nz5m12QW8u8SRV5ZWuoAH3uPzVjZw1PS/ibNFrE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=a2TQzOYrQ3L1taPrCmoWA99JSBQsHI9w+xB173DTYuErQULnb61vYXUNclLi7MGPPJu+Zk73HLlhdhBu1FHp5yqctDYykX38XS9VEhD3ioSsHojssbnw0XJhyDuhEkJfUxFtMCkVG2tsSjVHUX+iGHD1vIjZSMp6d/w8SMmSqIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=QM1uTdQy; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:1814:0:640:37e9:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id A641C60F59;
	Sat, 30 Nov 2024 16:27:26 +0300 (MSK)
Received: from kniv-nix.yandex-team.ru (unknown [2a02:6b8:b081:11::1:15])
	by mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id ARcU322IZa60-pmXXibCX;
	Sat, 30 Nov 2024 16:27:25 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1732973245;
	bh=+eyGxWAtd/f4CQXvN7ri9iNKbNFEua2Am/b4Jgy2ocI=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=QM1uTdQyFu4dvuEOKwVOPMYy+L0FH5C3D+1JGz/m2sJh8eyEaP6yAB/hvt+OkMwIO
	 QgSH9ML0iTelIawlsx0KJmMj37gXFJU4Oq+PaDiK7j6rlWoDWYLOKnNcoaNPLBnRPw
	 UZs03AiWUbKOXwgfBrk5TPCEg0XgL7WA1y6kc+oY=
Authentication-Results: mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
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
Subject: [PATCH 6.6] KVM: x86/mmu: Ensure that kvm_release_pfn_clean() takes exact pfn from kvm_faultin_pfn()
Date: Sat, 30 Nov 2024 16:27:02 +0300
Message-Id: <20241130132702.1974626-1-kniv@yandex-team.ru>
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

To solve this preserve faultin pfn in separate kvm_page_fault
field and pass it in kvm_release_pfn_clean(). Patch tested for all
mentioned guest memory backends with tdp_mmu={0,1}.

No bug in upstream as it was solved fundamentally by
commit 8dd861cc07e2 ("KVM: x86/mmu: Put refcounted pages instead of blindly releasing pfns")
and related patch series.

Link: https://nvdimm.docs.kernel.org/2mib_fs_dax.html
Fixes: 2f6305dd5676 ("KVM: MMU: change kvm_tdp_mmu_map() arguments to kvm_page_fault")
Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
---
 arch/x86/kvm/mmu/mmu.c          | 5 +++--
 arch/x86/kvm/mmu/mmu_internal.h | 2 ++
 arch/x86/kvm/mmu/paging_tmpl.h  | 2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 294775b7383b..2105f3bc2e59 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4321,6 +4321,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	smp_rmb();
 
 	ret = __kvm_faultin_pfn(vcpu, fault);
+	fault->faultin_pfn = fault->pfn;
 	if (ret != RET_PF_CONTINUE)
 		return ret;
 
@@ -4398,7 +4399,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
+	kvm_release_pfn_clean(fault->faultin_pfn);
 	return r;
 }
 
@@ -4474,7 +4475,7 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
 
 out_unlock:
 	read_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
+	kvm_release_pfn_clean(fault->faultin_pfn);
 	return r;
 }
 #endif
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index decc1f153669..a016b51f9c62 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -236,6 +236,8 @@ struct kvm_page_fault {
 	/* Outputs of kvm_faultin_pfn.  */
 	unsigned long mmu_seq;
 	kvm_pfn_t pfn;
+	/* pfn copy for kvm_release_pfn_clean(), constant after kvm_faultin_pfn() */
+	kvm_pfn_t faultin_pfn;
 	hva_t hva;
 	bool map_writable;
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index c85255073f67..b945dde6e3be 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -848,7 +848,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
+	kvm_release_pfn_clean(fault->faultin_pfn);
 	return r;
 }
 
-- 
2.34.1


