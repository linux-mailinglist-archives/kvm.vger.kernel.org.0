Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E56211A69
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 05:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgGBDCe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 23:02:34 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:47170 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726363AbgGBDCd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 23:02:33 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5D59980D0011CC29CE6B;
        Thu,  2 Jul 2020 11:02:30 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.174.187.42) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Thu, 2 Jul 2020 11:02:22 +0800
From:   Jingyi Wang <wangjingyi11@huawei.com>
To:     <drjones@redhat.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>
CC:     <maz@kernel.org>, <wanghaibin.wang@huawei.com>,
        <yuzenghui@huawei.com>, <eric.auger@redhat.com>,
        <wangjingyi11@huawei.com>
Subject: [kvm-unit-tests PATCH v2 4/8] arm64: its: Handle its command queue wrapping
Date:   Thu, 2 Jul 2020 11:01:28 +0800
Message-ID: <20200702030132.20252-5-wangjingyi11@huawei.com>
X-Mailer: git-send-email 2.14.1.windows.1
In-Reply-To: <20200702030132.20252-1-wangjingyi11@huawei.com>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.42]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Because micro-bench may send a large number of ITS commands, we
should handle ITS command queue wrapping as kernel instead of just
failing the test.

Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
---
 lib/arm64/gic-v3-its-cmd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/arm64/gic-v3-its-cmd.c b/lib/arm64/gic-v3-its-cmd.c
index 2c208d1..34574f7 100644
--- a/lib/arm64/gic-v3-its-cmd.c
+++ b/lib/arm64/gic-v3-its-cmd.c
@@ -164,8 +164,9 @@ static struct its_cmd_block *its_allocate_entry(void)
 {
 	struct its_cmd_block *cmd;
 
-	assert((u64)its_data.cmd_write < (u64)its_data.cmd_base + SZ_64K);
 	cmd = its_data.cmd_write++;
+	if ((u64)its_data.cmd_write  == (u64)its_data.cmd_base + SZ_64K)
+		its_data.cmd_write = its_data.cmd_base;
 	return cmd;
 }
 
-- 
2.19.1


