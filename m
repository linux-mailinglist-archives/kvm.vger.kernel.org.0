Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF02F368EE8
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 10:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241568AbhDWIfy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 04:35:54 -0400
Received: from mail-m118208.qiye.163.com ([115.236.118.208]:50452 "EHLO
        mail-m118208.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241550AbhDWIfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 04:35:53 -0400
Received: from ubuntu.localdomain (unknown [36.152.145.182])
        by mail-m118208.qiye.163.com (Hmail) with ESMTPA id D00C1E0141;
        Fri, 23 Apr 2021 16:35:15 +0800 (CST)
From:   zhouchuangao <zhouchuangao@vivo.com>
To:     Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     zhouchuangao <zhouchuangao@vivo.com>
Subject: [PATCH] mips/kvm: Use BUG_ON instead of if condition followed by BUG
Date:   Fri, 23 Apr 2021 01:35:09 -0700
Message-Id: <1619166910-70744-1-git-send-email-zhouchuangao@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZQ0kZSlYdSUNJShodSE4ZTBlVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWUFZT0tIVUpKS0
        hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NBQ6ISo5LT8VOAxWOjYhS00d
        QhQaCkNVSlVKTUpCSk1NQkpNSE5NVTMWGhIXVQETFA4YEw4aFRwaFDsNEg0UVRgUFkVZV1kSC1lB
        WUhNVUpOSVVKT05VSkNJWVdZCAFZQUpMQks3Bg++
X-HM-Tid: 0a78fdde6dbf2c17kusnd00c1e0141
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

BUG_ON uses unlikely in if(), it can be optimized at compile time.

Usually, the condition in if() is not satisfied. In my opinion,
this can improve the efficiency of the multi-stage pipeline.

Signed-off-by: zhouchuangao <zhouchuangao@vivo.com>
---
 arch/mips/kvm/tlb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/mips/kvm/tlb.c b/arch/mips/kvm/tlb.c
index 1088114..a3b50d5 100644
--- a/arch/mips/kvm/tlb.c
+++ b/arch/mips/kvm/tlb.c
@@ -58,8 +58,7 @@ static int _kvm_mips_host_tlb_inv(unsigned long entryhi)
 	tlb_probe_hazard();
 	idx = read_c0_index();
 
-	if (idx >= current_cpu_data.tlbsize)
-		BUG();
+	BUG_ON(idx >= current_cpu_data.tlbsize);
 
 	if (idx >= 0) {
 		write_c0_entryhi(UNIQUE_ENTRYHI(idx));
-- 
2.7.4

