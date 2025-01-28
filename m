Return-Path: <kvm+bounces-36715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 33D40A20313
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 02:54:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 749853A67D9
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 01:54:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D2581465B8;
	Tue, 28 Jan 2025 01:54:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp237.sjtu.edu.cn (smtp237.sjtu.edu.cn [202.120.2.237])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929BA1B59A;
	Tue, 28 Jan 2025 01:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.120.2.237
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738029249; cv=none; b=iYdzKtT7Db3Tat9KY43o8qNicaGwDkiLxwtBiH7ko6pvyqAhQtxEjm69O/o0HHrSSosMx7GppvTism0hvWVy/6IMsNPoeAMV2HiU9a7DaNnA/k3r6ix8oBZIBA04vYie6IjRRc2i+18DWu2F5Y1mbgCegGG9UfVFN0xzp2ILwPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738029249; c=relaxed/simple;
	bh=eCBV3SVc1IwYf3mw3kNVtvVULgUmL7UjKTvK5dSd58A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kdww3GkcOyNI1PV2sox2b8IHf0yZNBitRoWwaCCwPkKJzH/a7+uCW05N0PnI6LgGI1OesqumxoqLufERzvI37/n3jKdBv18JP60mR1tbJXML84euXe+bygXu9qkSG8X4NOlS0lgIE1kviwxlCsRUEgF0djeVoh1jRpxw/ZU6T9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn; spf=pass smtp.mailfrom=sjtu.edu.cn; arc=none smtp.client-ip=202.120.2.237
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sjtu.edu.cn
Received: from proxy189.sjtu.edu.cn (smtp189.sjtu.edu.cn [202.120.2.189])
	by smtp237.sjtu.edu.cn (Postfix) with ESMTPS id 8D68A7FD46;
	Tue, 28 Jan 2025 09:53:56 +0800 (CST)
Received: from localhost.localdomain (unknown [101.80.151.229])
	by proxy189.sjtu.edu.cn (Postfix) with ESMTPSA id 69D4C3FC501;
	Tue, 28 Jan 2025 09:53:47 +0800 (CST)
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
Subject: [PATCH v7 0/3] KVM: SVM: Flush cache only on CPUs running SEV guest
Date: Tue, 28 Jan 2025 09:53:42 +0800
Message-Id: <20250128015345.7929-1-szy0127@sjtu.edu.cn>
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
v6 -> v7:
- Fixed the writing oversight in sev_vcpu_load().

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


