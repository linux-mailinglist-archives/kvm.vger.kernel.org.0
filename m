Return-Path: <kvm+bounces-36606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 88AF3A1C784
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 12:37:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 017913A521F
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 11:37:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E504155330;
	Sun, 26 Jan 2025 11:37:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp237.sjtu.edu.cn (smtp237.sjtu.edu.cn [202.120.2.237])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427CA11CAF;
	Sun, 26 Jan 2025 11:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.120.2.237
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737891430; cv=none; b=JtTS475lUKRz0wXWnswgxPpPssI14thAN1Q3/tob9bEWp54DLuQK+b/y72fzROo1uQb5WkHd2M/ebcVoeScXQCAzXs7r4XHSWvGiqGYL6fihuWqCC8IGXwDCozRVPm4qaGT/JBHyq1u/gp+77lyIZgi1n0DjEudHdF6KfTDdZJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737891430; c=relaxed/simple;
	bh=SDOyuENl06wFxbyWCmY1N9MjjYCEX/mgqTJZG4vEgD8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cd687a/XwggYCpN6k3PQne4cZbBPK6dDvHpgIBL/XRYCNhTzhL+G7DeoBdrbuKR1Oys4t4Ly2AvmFIEl5Z7iixeJ1I5/spvaljbGhJpE84j+uO8s9nPNsQeZSewsEuIcQ0toylOYS/2dYFAk7ukgTmYd/dkFdyfGJ3Ll0AdP63o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn; spf=pass smtp.mailfrom=sjtu.edu.cn; arc=none smtp.client-ip=202.120.2.237
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sjtu.edu.cn
Received: from proxy189.sjtu.edu.cn (smtp189.sjtu.edu.cn [202.120.2.189])
	by smtp237.sjtu.edu.cn (Postfix) with ESMTPS id 9C9267FCDB;
	Sun, 26 Jan 2025 19:36:53 +0800 (CST)
Received: from localhost.localdomain (unknown [101.80.151.229])
	by proxy189.sjtu.edu.cn (Postfix) with ESMTPSA id 55BA03FC394;
	Sun, 26 Jan 2025 19:36:44 +0800 (CST)
From: Zheyun Shen <szy0127@sjtu.edu.cn>
To: thomas.lendacky@amd.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	kevinloughlin@google.com,
	mingo@redhat.com,
	bp@alien8.de
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zheyun Shen <szy0127@sjtu.edu.cn>
Subject: [PATCH v6 0/3] KVM: SVM: Flush cache only on CPUs running SEV guest
Date: Sun, 26 Jan 2025 19:36:37 +0800
Message-Id: <20250126113640.3426-1-szy0127@sjtu.edu.cn>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previous versions pointed out the problem of wbinvd_on_all_cpus() in SEV
and tried to maintain a cpumask to solve it. This version includes
further code cleanup.

Although dirty_mask is not maintained perfectly and may lead to wbinvd on 
physical CPUs that are not running a SEV guest, it's still better than 
wbinvd_on_all_cpus(). And vcpu migration is designed to be solved in 
future work.

---
v5 -> v6:
- Replaced sev_get_wbinvd_dirty_mask() with the helper function 
to_kvm_sev_info().

v4 -> v5:
- rebase to tip @ 15e2f65f2ecf .
- Added a commit to remove unnecessary calls to wbinvd().
- Changed some comments.

v3 -> v4:
- Added a wbinvd helper and export it to SEV.
- Changed the struct cpumask in kvm_sev_info into cpumask*, which should
be dynamically allocated and freed.
- Changed the time of recording the CPUs from pre_sev_run() to vcpu_load().
- Removed code of clearing the mask.

v2 -> v3:
- Replaced get_cpu() with parameter cpu in pre_sev_run().

v1 -> v2:
- Added sev_do_wbinvd() to wrap two operations.
- Used cpumask_test_and_clear_cpu() to avoid concurrent problems.
---

Zheyun Shen (3):
  KVM: x86: Add a wbinvd helper
  KVM: SVM: Remove wbinvd in sev_vm_destroy()
  KVM: SVM: Flush cache only on CPUs running SEV guest

 arch/x86/kvm/svm/sev.c | 36 +++++++++++++++++++++++++++---------
 arch/x86/kvm/svm/svm.c |  2 ++
 arch/x86/kvm/svm/svm.h |  5 ++++-
 arch/x86/kvm/x86.c     |  9 +++++++--
 arch/x86/kvm/x86.h     |  1 +
 5 files changed, 41 insertions(+), 12 deletions(-)

-- 
2.34.1


