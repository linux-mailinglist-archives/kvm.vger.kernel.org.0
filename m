Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEE0014DB85
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 14:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbgA3N0Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 08:26:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:45770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727345AbgA3N0P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 08:26:15 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CF9B2082E;
        Thu, 30 Jan 2020 13:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580390774;
        bh=NYzjf0zBc57FKJJDgjapRNI+QmFi9nWATVOeClefQhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hTWZtgAxp7FMLlcdTrGI/LKfpXKipOUfJpGXB02hvdZ77W0WNUO2ADsSPPgQRrUv6
         KCAqdxCo+Yo9qxT9NRUmKLX6wRESDUWF3XJiHbhUiwK3n3mGOgcQzXO/gJD57zJmAG
         0ydZmR5Scq/GMzKHDIUZjTqoWBwrTu8cmogcgsgY=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1ix9pk-002BmW-Jg; Thu, 30 Jan 2020 13:26:12 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Beata Michalska <beata.michalska@linaro.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Haibin Wang <wanghaibin.wang@huawei.com>,
        James Morse <james.morse@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Shannon Zhao <shannon.zhao@linux.alibaba.com>,
        Steven Price <steven.price@arm.com>,
        Will Deacon <will@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 05/23] KVM: ARM: Call hyp_cpu_pm_exit at the right place
Date:   Thu, 30 Jan 2020 13:25:40 +0000
Message-Id: <20200130132558.10201-6-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200130132558.10201-1-maz@kernel.org>
References: <20200130132558.10201-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, drjones@redhat.com, andrew.murray@arm.com, beata.michalska@linaro.org, christoffer.dall@arm.com, eric.auger@redhat.com, gshan@redhat.com, wanghaibin.wang@huawei.com, james.morse@arm.com, broonie@kernel.org, mark.rutland@arm.com, rmk+kernel@armlinux.org.uk, shannon.zhao@linux.alibaba.com, steven.price@arm.com, will@kernel.org, yuehaibing@huawei.com, yuzenghui@huawei.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Shannon Zhao <shannon.zhao@linux.alibaba.com>

It doesn't needs to call hyp_cpu_pm_exit() in init_hyp_mode() when some
error occurs. hyp_cpu_pm_exit() only needs to be called in
kvm_arch_init() if init_subsystems() fails. So move hyp_cpu_pm_exit()
out from teardown_hyp_mode() and call it directly in kvm_arch_init().

Signed-off-by: Shannon Zhao <shannon.zhao@linux.alibaba.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/1575272531-3204-1-git-send-email-shannon.zhao@linux.alibaba.com
---
 virt/kvm/arm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 8de4daf25097..b5d57ed6443c 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1537,7 +1537,6 @@ static void teardown_hyp_mode(void)
 	free_hyp_pgds();
 	for_each_possible_cpu(cpu)
 		free_page(per_cpu(kvm_arm_hyp_stack_page, cpu));
-	hyp_cpu_pm_exit();
 }
 
 /**
@@ -1751,6 +1750,7 @@ int kvm_arch_init(void *opaque)
 	return 0;
 
 out_hyp:
+	hyp_cpu_pm_exit();
 	if (!in_hyp_mode)
 		teardown_hyp_mode();
 out_err:
-- 
2.20.1

