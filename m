Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66D31C0664
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 21:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgD3T3t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 15:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgD3T3t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 15:29:49 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8965C035494;
        Thu, 30 Apr 2020 12:29:48 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id t9so1233344pjw.0;
        Thu, 30 Apr 2020 12:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=S56vvjgUJgJIcs0iI3orpY7ejPb7V1V+KfOnIEgpemg=;
        b=oAOyVMbSFrTgrrXodp1aN7KVZh+59xE1YaGOAh56d1EC+I4gcm1UjNeI3p6/8+hOgz
         2i5s2bjByfGsW01ml/aHEdaRd6QMQb65ef4L1x3R+8Z0+tV6gA1tugOZkpG4hujd3F2r
         Uac4rrNRFI6dI2LsjxLXJEMUySVo8PN254L95aFVxbCN9Dg4IM81ws7Jkn7yhtZ4blTc
         fi8d6VgtOrxaL/fcC9qDPkwCkGFlncx/GTj6uDsN+gnU7fMsaJgz6t1xYsdW6feHEfUw
         ZWLFaCIYqIAtoUjGxBFLhY/4JIXbnLgCfZ9r7ZERjmZzVE7k+vVchNrCAoQRgXS/3200
         iBBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=S56vvjgUJgJIcs0iI3orpY7ejPb7V1V+KfOnIEgpemg=;
        b=LcZbhikXDV0hR4MnNepW6Mp/pKdmHfnsNpS1145Jdez5IS3Dj4SJYJ0xmXtbX04GOT
         /bMmL4G2xtCqdk+/s7LSbNHCQJWJFhcq7i6HQnjpdIK2qDBXTAh08r9HexVU6oLYssrg
         3VPWkO63qm02qWh4rIMCslJEjoS4+rLSBkfn2EY0jqxnEYAAeWWQXwTcClRmvny8rT3C
         AhORxarfsB5iC3Cw5Ie3OvwrhJfTMiNjKutiulouHw/SvXOLyLq6TKigbl8vC0+bgcG7
         qnXcOnqi5ruvGpMbtSmsrqIYJvKP5Du2Dv2zpRMwqL0Zw8sNULhpVhuuh0a8BNZh+9dw
         wLSw==
X-Gm-Message-State: AGi0PuZp9kup1fDlyTanCYU78Ep8PfjAo77Hb/MikJvmGon5XlGm47i6
        tLiarpY87Fob3ybPIiqRTg==
X-Google-Smtp-Source: APiQypJ7Vu9QFxwaGegbDs+zHeszCr6lN9AOoLWTdbcpuof9RCZcoh1RtagVlKoWgPy1jwwJ8NQDRg==
X-Received: by 2002:a17:902:261:: with SMTP id 88mr537590plc.308.1588274988360;
        Thu, 30 Apr 2020 12:29:48 -0700 (PDT)
Received: from localhost.localdomain ([2402:3a80:d32:dd79:dd81:b49d:fd6a:d165])
        by smtp.gmail.com with ESMTPSA id e4sm461038pge.45.2020.04.30.12.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 12:29:47 -0700 (PDT)
From:   madhuparnabhowmik10@gmail.com
To:     mingo@redhat.com, pbonzini@redhat.com, bp@alien8.de
Cc:     x86@kernel.org, bhelgaas@google.com,
        sean.j.christopherson@intel.com, cai@lca.pw, paulmck@kernel.org,
        joel@joelfernandes.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        frextrite@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH] x86: Fix RCU list usage to avoid false positive warnings
Date:   Fri,  1 May 2020 00:59:32 +0530
Message-Id: <20200430192932.13371-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

Use list_for_each_entry() instead of list_for_each_entry_rcu() whenever
spinlock or mutex is always held.
Otherwise, pass cond to list_for_each_entry_rcu().

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 arch/x86/kernel/nmi.c          | 2 +-
 arch/x86/kvm/irq_comm.c        | 3 ++-
 arch/x86/pci/mmconfig-shared.c | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 6407ea21fa1b..999dc6c134d2 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -195,7 +195,7 @@ void unregister_nmi_handler(unsigned int type, const char *name)
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
 
-	list_for_each_entry_rcu(n, &desc->head, list) {
+	list_for_each_entry(n, &desc->head, list) {
 		/*
 		 * the name passed in to describe the nmi handler
 		 * is used as the lookup key
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index c47d2acec529..5b88a648e079 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -258,7 +258,8 @@ void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
 	idx = srcu_read_lock(&kvm->irq_srcu);
 	gsi = kvm_irq_map_chip_pin(kvm, irqchip, pin);
 	if (gsi != -1)
-		hlist_for_each_entry_rcu(kimn, &kvm->arch.mask_notifier_list, link)
+		hlist_for_each_entry_rcu(kimn, &kvm->arch.mask_notifier_list, link,
+					srcu_read_lock_held(&kvm->irq_srcu))
 			if (kimn->irq == gsi)
 				kimn->func(kimn, mask);
 	srcu_read_unlock(&kvm->irq_srcu, idx);
diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 6fa42e9c4e6f..a096942690bd 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -797,7 +797,7 @@ int pci_mmconfig_delete(u16 seg, u8 start, u8 end)
 	struct pci_mmcfg_region *cfg;
 
 	mutex_lock(&pci_mmcfg_lock);
-	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list)
+	list_for_each_entry(cfg, &pci_mmcfg_list, list)
 		if (cfg->segment == seg && cfg->start_bus == start &&
 		    cfg->end_bus == end) {
 			list_del_rcu(&cfg->list);
-- 
2.17.1

