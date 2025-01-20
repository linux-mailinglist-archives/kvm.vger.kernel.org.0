Return-Path: <kvm+bounces-35998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DAF07A16C20
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 13:13:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 699E61883FC0
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 12:13:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00E461DFDBB;
	Mon, 20 Jan 2025 12:13:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp232.sjtu.edu.cn (smtp232.sjtu.edu.cn [202.120.2.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD941DF991;
	Mon, 20 Jan 2025 12:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.120.2.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737375188; cv=none; b=AhgyN2rg9tNLyvXkiDCC9q93+vFDsDT76xJmKLSU5OYnadSekuVZC2D5qmTvRmxn20MjJhCtluqM7YgkKJ3OFZUsCpcP4bjwrXufDLLcmCcC4JNal2mqUIDIQOoyYLxM/G7+m+P6XWuMeBxTlpcssbmUQof4JNDA0XlZ9vG/0e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737375188; c=relaxed/simple;
	bh=lVdD/FEo7tVC1lOCtPZEn16WKwTmzOS53Ne704/gQXo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FZD4C0lB2l6Xn6x0dW3DuHPr6yNcFrBeNeG49L1odK5iszgaS75wut/HOjAR2ufsL5AnjJtd8yli1yfuP3hGZwe4MOdJ40q7W3kNcsYfh4AO38+esyZneHSRdAqviJmVhhxMePFROY6lChZI0HMpd7dX8/0BiF2ovh3E6CxhCTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn; spf=pass smtp.mailfrom=sjtu.edu.cn; arc=none smtp.client-ip=202.120.2.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sjtu.edu.cn
Received: from proxy188.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
	by smtp232.sjtu.edu.cn (Postfix) with ESMTPS id 396221008CBDC;
	Mon, 20 Jan 2025 20:05:15 +0800 (CST)
Received: from broadband.. (unknown [202.120.40.80])
	by proxy188.sjtu.edu.cn (Postfix) with ESMTPSA id E702037C955;
	Mon, 20 Jan 2025 20:05:07 +0800 (CST)
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
Subject: [PATCH v5 0/3] KVM: SVM: Flush cache only on CPUs running SEV guest
Date: Mon, 20 Jan 2025 20:05:00 +0800
Message-Id: <20250120120503.470533-1-szy0127@sjtu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previous versions pointed out the problem of wbinvd_on_all_cpus() in SEV
and tried to maintain a cpumask to solve it. This version futher removes
unnecessary calls to wbinvd(). 

Although dirty_mask is not maintained perfectly and may lead to wbinvd on 
physical CPUs that are not running a SEV guest, it's still better than 
wbinvd_on_all_cpus(). And vcpu migration is designed to be solved in 
future work.

---
v4 -> v5:
- Added a commit to remove unnecessary calls to wbinvd().

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

 arch/x86/kvm/svm/sev.c | 45 +++++++++++++++++++++++++++++++++---------
 arch/x86/kvm/svm/svm.c |  2 ++
 arch/x86/kvm/svm/svm.h |  5 ++++-
 arch/x86/kvm/x86.c     |  9 +++++++--
 arch/x86/kvm/x86.h     |  1 +
 5 files changed, 50 insertions(+), 12 deletions(-)

-- 
2.34.1


