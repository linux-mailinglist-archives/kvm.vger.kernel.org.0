Return-Path: <kvm+bounces-14261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C64718A16E8
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 16:15:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5342FB28CFF
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 14:15:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0AD214D458;
	Thu, 11 Apr 2024 14:14:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp232.sjtu.edu.cn (smtp232.sjtu.edu.cn [202.120.2.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4066E8C09;
	Thu, 11 Apr 2024 14:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.120.2.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712844885; cv=none; b=Ng+7JYWcZEG4sh+6HYPZ95V+im7KzJ+mDAQ/ZKG1+Cll3b/Ifhb+KCQ1FNtpAKT+se+J9QiRQCM3FQG0HXy0cXOiakbU0+A+9g8lCb3WgrAnnUrC8fDeQ5PgrXduYnCDNDZHNUBQxu+RMy86F6/RAo1g38zdYXmlkadCfDnleQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712844885; c=relaxed/simple;
	bh=xpf0H03blykF5CArcxdABzc6r7Sy9bGouzzXvkc8kWk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fs81O+zBbJwc09yygQjAx/7NQZQfgBFijiGJ0mqsd+lAPIzL3FzaULEFD/qlnI2FVrWsfvmxIUEfxW41zB1pVBvovEC7rv2nflKsfxGggLgGe7bgKv5nl6p9dOrhSqHdVSaPkbSb6QV/OSWykWMn4f67mr8vGrwCS1/N+5HaPqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn; spf=pass smtp.mailfrom=sjtu.edu.cn; arc=none smtp.client-ip=202.120.2.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sjtu.edu.cn
Received: from proxy188.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
	by smtp232.sjtu.edu.cn (Postfix) with ESMTPS id 2E8FA1006BD9C;
	Thu, 11 Apr 2024 22:05:21 +0800 (CST)
Received: from broadband.ipads-lab.se.sjtu.edu.cn (unknown [202.120.40.82])
	by proxy188.sjtu.edu.cn (Postfix) with ESMTPSA id 9F54337C963;
	Thu, 11 Apr 2024 22:05:14 +0800 (CST)
From: Zheyun Shen <szy0127@sjtu.edu.cn>
To: thomas.lendacky@amd.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	tglx@linutronix.de
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zheyun Shen <szy0127@sjtu.edu.cn>
Subject: [PATCH v4 0/2] KVM: SVM: Flush cache only on CPUs running SEV guest
Date: Thu, 11 Apr 2024 22:04:43 +0800
Message-Id: <20240411140445.1038319-1-szy0127@sjtu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previous versions pointed out the problem of wbinvd_on_all_cpus() in SEV
and tried to maintain a cpumask to solve it. However, recording the CPU
to mask before VMRUN and clearing the mask after reclamation is not
correct. If the next reclamation happens before VMEXIT and VMRUN, lack 
of record may lead to miss one wbinvd on this CPU.

---
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

Zheyun Shen (2):
  KVM: x86: Add a wbinvd helper
  KVM: SVM: Flush cache only on CPUs running SEV guest

 arch/x86/kvm/svm/sev.c | 48 ++++++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/svm/svm.c |  2 ++
 arch/x86/kvm/svm/svm.h |  4 ++++
 arch/x86/kvm/x86.c     |  9 ++++++--
 arch/x86/kvm/x86.h     |  1 +
 5 files changed, 58 insertions(+), 6 deletions(-)

-- 
2.34.1


