Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A42A1D0FF8
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 12:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730564AbgEMKie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 06:38:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727812AbgEMKid (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 06:38:33 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63E1B20673;
        Wed, 13 May 2020 10:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589366313;
        bh=cdyohDfzAVPN7ZxH8h6kx+enid172A/O+6QoKrrtYpc=;
        h=From:To:Cc:Subject:Date:From;
        b=RbMjCO9SXAqknjxiUGZwh8QO3U0+rOXlcjUgomVg6pkSSuRp8vMEuijB++gkwTiQm
         iUL8RdibNcRr/qeWWNALIs8RCT7HI6RFzeUdUhZPmllkrIjeux51bpCmNUXwdOGT3w
         y2ImlUqdypdvejXUQgWygyNP0o/w63XtgrmpBNIE=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jYomV-00BwQw-Kz; Wed, 13 May 2020 11:38:31 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        dbrazdil@google.com
Subject: [PATCH] KVM: arm64: Use cpus_have_final_cap for has_vhe()
Date:   Wed, 13 May 2020 11:38:28 +0100
Message-Id: <20200513103828.74580-1-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, dbrazdil@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

By the time we start using the has_vhe() helper, we have long
discovered whether we are running VHE or not. It thus makes
sense to use cpus_have_final_cap() instead of cpus_have_const_cap(),
which leads to a small text size reduction.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/virt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 61fd26752adc..5051b388c654 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -85,7 +85,7 @@ static inline bool is_kernel_in_hyp_mode(void)
 
 static __always_inline bool has_vhe(void)
 {
-	if (cpus_have_const_cap(ARM64_HAS_VIRT_HOST_EXTN))
+	if (cpus_have_final_cap(ARM64_HAS_VIRT_HOST_EXTN))
 		return true;
 
 	return false;
-- 
2.20.1

