Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0FD229C9B
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbgGVQB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:01:57 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:38086 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729493AbgGVQBl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:41 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id B4A99305D76E;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id AB635305FFAA;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 23/34] KVM: x86: mmu: fix: update present_mask in spte_read_protect()
Date:   Wed, 22 Jul 2020 19:01:10 +0300
Message-Id: <20200722160121.9601-24-alazar@bitdefender.com>
In-Reply-To: <20200722160121.9601-1-alazar@bitdefender.com>
References: <20200722160121.9601-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ștefan Șicleru <ssicleru@bitdefender.com>

shadow_present_mask is not 0ull if #VE support is enabled.
If #VE support is enabled, shadow_present_mask is updated in
vmx_enable_tdp() with VMX_EPT_SUPPRESS_VE_BIT.

Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/mmu/mmu.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 810e22f41306..28ab4a1ba25a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1601,7 +1601,13 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
 static bool spte_read_protect(u64 *sptep)
 {
 	u64 spte = *sptep;
-	bool exec_only_supported = (shadow_present_mask == 0ull);
+	bool exec_only_supported;
+
+	if (kvm_ve_supported)
+		exec_only_supported =
+		    (shadow_present_mask == VMX_EPT_SUPPRESS_VE_BIT);
+	else
+		exec_only_supported = (shadow_present_mask == 0ull);
 
 	rmap_printk("rmap_read_protect: spte %p %llx\n", sptep, *sptep);
 
