Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B78BADA61
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 15:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404947AbfIINtd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 09:49:33 -0400
Received: from foss.arm.com ([217.140.110.172]:50802 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404915AbfIINtc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 09:49:32 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 492301BB2;
        Mon,  9 Sep 2019 06:49:32 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 085343F59C;
        Mon,  9 Sep 2019 06:49:29 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 16/17] arm64: KVM: Device mappings should be execute-never
Date:   Mon,  9 Sep 2019 14:48:06 +0100
Message-Id: <20190909134807.27978-17-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190909134807.27978-1-maz@kernel.org>
References: <20190909134807.27978-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: James Morse <james.morse@arm.com>

Since commit 2f6ea23f63cca ("arm64: KVM: Avoid marking pages as XN in
Stage-2 if CTR_EL0.DIC is set"), KVM has stopped marking normal memory
as execute-never at stage2 when the system supports D->I Coherency at
the PoU. This avoids KVM taking a trap when the page is first executed,
in order to clean it to PoU.

The patch that added this change also wrapped PAGE_S2_DEVICE mappings
up in this too. The upshot is, if your CPU caches support DIC ...
you can execute devices.

Revert the PAGE_S2_DEVICE change so PTE_S2_XN is always used
directly.

Fixes: 2f6ea23f63cca ("arm64: KVM: Avoid marking pages as XN in Stage-2 if CTR_EL0.DIC is set")
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/pgtable-prot.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index 92d2e9f28f28..9a21b84536f2 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -77,7 +77,7 @@
 	})
 
 #define PAGE_S2			__pgprot(_PROT_DEFAULT | PAGE_S2_MEMATTR(NORMAL) | PTE_S2_RDONLY | PAGE_S2_XN)
-#define PAGE_S2_DEVICE		__pgprot(_PROT_DEFAULT | PAGE_S2_MEMATTR(DEVICE_nGnRE) | PTE_S2_RDONLY | PAGE_S2_XN)
+#define PAGE_S2_DEVICE		__pgprot(_PROT_DEFAULT | PAGE_S2_MEMATTR(DEVICE_nGnRE) | PTE_S2_RDONLY | PTE_S2_XN)
 
 #define PAGE_NONE		__pgprot(((_PAGE_DEFAULT) & ~PTE_VALID) | PTE_PROT_NONE | PTE_RDONLY | PTE_NG | PTE_PXN | PTE_UXN)
 #define PAGE_SHARED		__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG | PTE_PXN | PTE_UXN | PTE_WRITE)
-- 
2.20.1

