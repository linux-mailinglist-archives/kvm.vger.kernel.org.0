Return-Path: <kvm+bounces-53098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 35555B0D3EF
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 09:54:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 754163ACC06
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 07:50:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D40A28DEE4;
	Tue, 22 Jul 2025 07:51:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from baidu.com (mx22.baidu.com [220.181.50.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B3628A1D0;
	Tue, 22 Jul 2025 07:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.50.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753170664; cv=none; b=ojTiIf5PE8NoYexMRDC3V8oC4vIKe8S8FgT0XVgIJtVdEWRiGgibJKf0odMTNDoh5kGnJ1FOPRGXNXCzLM4dyMGg6yMJRCwQEM7Z5Gkwt6pzY3KNcSUs/4HcuDMOcPeO0jrXmOf4d/e1rTvzTW6XdEIqOLKLvqp2uiPl3wXUetI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753170664; c=relaxed/simple;
	bh=mnkOXBOrzs06Jbo71/4JQf7EhWvlkGynEQoNFZrXMtY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=q47wOV0uOoPxORcZwtDf4bQIO4Y8K12q9F1tu3nwL1xTi0wEFBf7l7mHSrg30xn+Db3NxS5vXcWhh4CNXgc++tiNX23KJ0ULQeLrtIs/V3mMnNjJrsfJvJcCB2N6ze5OhjA2S6cOlVN3NxuGCOLAoGxYjQYGwt4kN8zXSWfB7z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=220.181.50.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: lirongqing <lirongqing@baidu.com>
To: <pbonzini@redhat.com>, <vkuznets@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] x86/kvm: Downgrade host poll messages to pr_debug_once()
Date: Tue, 22 Jul 2025 15:49:58 +0800
Message-ID: <20250722074958.2567-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjkjy-exc5.internal.baidu.com (172.31.50.49) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
X-FEAS-Client-IP: 172.31.50.47
X-FE-Policy-ID: 52:10:53:SYSTEM

From: Li RongQing <lirongqing@baidu.com>

The current host-side polling messages are misleading, as they will be
printed when the hypervisor intentionally disables polling (by providing
MWAIT to the guest) rather than due to version incompatibility. so
Downgrade to pr_debug_once() to prevent spurious log messages.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kernel/kvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 9cda79f..c5f96ee 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -1136,8 +1136,8 @@ static void kvm_enable_host_haltpoll(void *i)
 void arch_haltpoll_enable(unsigned int cpu)
 {
 	if (!kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL)) {
-		pr_err_once("host does not support poll control\n");
-		pr_err_once("host upgrade recommended\n");
+		pr_debug_once("host does not support poll control\n");
+		pr_debug_once("host upgrade recommended\n");
 		return;
 	}
 
-- 
2.9.4


