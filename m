Return-Path: <kvm+bounces-32011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A9399D1166
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 14:07:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B1EA2843C1
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 13:07:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D63BF1BBBCA;
	Mon, 18 Nov 2024 13:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="bZECRhYC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D201B85F0;
	Mon, 18 Nov 2024 13:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.48.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731935078; cv=none; b=MEvXS4vyGRLDObFnovJkbemdFH25PUMklfVyPJIapLYCJrvA4NxQPN2fk7ix8KvOTB+aL+kykFPCfehYc+d5zKE3FePO8MaVmbXlyPzvsEmTAdPBJi+nYsftjeiiGuXtC7jaKp2BSk5iflPnH/my/4/4X1P41EiCGjQ/sP1SRqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731935078; c=relaxed/simple;
	bh=n13NhvqjiFneogKbi1C94dKpbD7dUVi7WjsM+NBvQlQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=o/aInRorCXHLPkDpDiqt/nR9DdbFd5ZxbipqftV0j+0J03y+mEO3+Lr5i3Dlw0iC948UPZjEL3FVYuMZO6RVXEmVgjBgvtzBb+wI8kIMYkt6oIMr6GIxzqgf+m6t1B9SGvYB1iWq0UozkHHhbIfQuaTTV+sDYeosrZKVk+2ZLAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=bZECRhYC; arc=none smtp.client-ip=52.95.48.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1731935076; x=1763471076;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gOEkMewe8WJbkBBs7uFzinPK2/JG25Gq0vZUtD9UmC8=;
  b=bZECRhYCIlxW1PV+JL6322jFwS2ApAc5Vg8QOlgUDwM8h3RvhAYT9qgm
   6mOs3EWAirmq+cyD14azuTVmCVFVOcNxe9H8A+czLt2X/pjFvdYACvRHM
   dp+c5HrxlglkKVdBAP2/CE3xgJIN5NSs1MMBk6k+X+6TF1H8To72eRaAe
   k=;
X-IronPort-AV: E=Sophos;i="6.12,164,1728950400"; 
   d="scan'208";a="440827820"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.124.125.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2024 13:04:08 +0000
Received: from EX19MTAUWA002.ant.amazon.com [10.0.21.151:6012]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.43.2:2525] with esmtp (Farcaster)
 id 0c5aaa77-bd99-4459-b7f4-c9a75c06344d; Mon, 18 Nov 2024 13:04:07 +0000 (UTC)
X-Farcaster-Flow-ID: 0c5aaa77-bd99-4459-b7f4-c9a75c06344d
Received: from EX19D020UWA003.ant.amazon.com (10.13.138.254) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 18 Nov 2024 13:04:07 +0000
Received: from EX19MTAUWA001.ant.amazon.com (10.250.64.204) by
 EX19D020UWA003.ant.amazon.com (10.13.138.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 18 Nov 2024 13:04:06 +0000
Received: from email-imr-corp-prod-pdx-all-2b-dbd438cc.us-west-2.amazon.com
 (10.25.36.214) by mail-relay.amazon.com (10.250.64.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Mon, 18 Nov 2024 13:04:06 +0000
Received: from dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com (dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com [172.19.103.116])
	by email-imr-corp-prod-pdx-all-2b-dbd438cc.us-west-2.amazon.com (Postfix) with ESMTPS id 2B499A065B;
	Mon, 18 Nov 2024 13:04:04 +0000 (UTC)
From: Nikita Kalyazin <kalyazin@amazon.com>
To: <pbonzini@redhat.com>, <seanjc@google.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <david@redhat.com>, <peterx@redhat.com>, <oleg@redhat.com>,
	<vkuznets@redhat.com>, <gshan@redhat.com>, <graf@amazon.de>,
	<jgowans@amazon.com>, <roypat@amazon.co.uk>, <derekmn@amazon.com>,
	<nsaenz@amazon.es>, <xmarcalx@amazon.com>, <kalyazin@amazon.com>
Subject: [PATCH] KVM: x86: async_pf: check earlier if can deliver async pf
Date: Mon, 18 Nov 2024 13:04:03 +0000
Message-ID: <20241118130403.23184-1-kalyazin@amazon.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

On x86, async pagefault events can only be delivered if the page fault
was triggered by guest userspace, not kernel.  This is because
the guest may be in non-sleepable context and will not be able
to reschedule.

However existing implementation pays the following overhead even for the
kernel-originated faults, even though it is known in advance that they
cannot be processed asynchronously:
 - allocate async PF token
 - create and schedule an async work

This patch avoids the overhead above in case of kernel-originated faults
by moving the `kvm_can_deliver_async_pf` check from
`kvm_arch_async_page_not_present` to `__kvm_faultin_pfn`.

Note that the existing check `kvm_can_do_async_pf` already calls
`kvm_can_deliver_async_pf` internally, however it only does that if the
`kvm_hlt_in_guest` check is true, ie userspace requested KVM not to exit
on guest halts via `KVM_CAP_X86_DISABLE_EXITS`.  In that case the code
proceeds with the async fault processing with the following
justification in 1dfdb45ec510ba27e366878f97484e9c9e728902 ("KVM: x86:
clean up conditions for asynchronous page fault handling"):

"Even when asynchronous page fault is disabled, KVM does not want to pause
the host if a guest triggers a page fault; instead it will put it into
an artificial HLT state that allows running other host processes while
allowing interrupt delivery into the guest."

Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 ++-
 arch/x86/kvm/x86.c     | 5 ++---
 arch/x86/kvm/x86.h     | 2 ++
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 22e7ad235123..11d29d15b6cd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4369,7 +4369,8 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 			trace_kvm_async_pf_repeated_fault(fault->addr, fault->gfn);
 			kvm_make_request(KVM_REQ_APF_HALT, vcpu);
 			return RET_PF_RETRY;
-		} else if (kvm_arch_setup_async_pf(vcpu, fault)) {
+		} else if (kvm_can_deliver_async_pf(vcpu) &&
+			kvm_arch_setup_async_pf(vcpu, fault)) {
 			return RET_PF_RETRY;
 		}
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2e713480933a..8edae75b39f7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13355,7 +13355,7 @@ static inline bool apf_pageready_slot_free(struct kvm_vcpu *vcpu)
 	return !val;
 }
 
-static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
+bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
 {
 
 	if (!kvm_pv_async_pf_enabled(vcpu))
@@ -13406,8 +13406,7 @@ bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 	trace_kvm_async_pf_not_present(work->arch.token, work->cr2_or_gpa);
 	kvm_add_async_pf_gfn(vcpu, work->arch.gfn);
 
-	if (kvm_can_deliver_async_pf(vcpu) &&
-	    !apf_put_user_notpresent(vcpu)) {
+	if (!apf_put_user_notpresent(vcpu)) {
 		fault.vector = PF_VECTOR;
 		fault.error_code_valid = true;
 		fault.error_code = 0;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index ec623d23d13d..9647f41e5c49 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -387,6 +387,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
 fastpath_t handle_fastpath_hlt(struct kvm_vcpu *vcpu);
 
+bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu);
+
 extern struct kvm_caps kvm_caps;
 extern struct kvm_host_values kvm_host;
 

base-commit: d96c77bd4eeba469bddbbb14323d2191684da82a
-- 
2.40.1


