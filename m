Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E401E5FE9E2
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 09:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiJNHzu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 03:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiJNHzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 03:55:48 -0400
Received: from out0-140.mail.aliyun.com (out0-140.mail.aliyun.com [140.205.0.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B2617FD51;
        Fri, 14 Oct 2022 00:55:46 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047209;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---.Pc1XjxL_1665734112;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.Pc1XjxL_1665734112)
          by smtp.aliyun-inc.com;
          Fri, 14 Oct 2022 15:55:12 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Peter Xu <peterx@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Reduce refcount if single_open() fails in kvm_mmu_rmaps_stat_open()
Date:   Fri, 14 Oct 2022 15:55:11 +0800
Message-Id: <a75900413bb8b1e556be690e9588a0f92e946a30.1665733883.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refcount is increased before calling single_open() in
kvm_mmu_rmaps_stat_open(), If single_open() fails, refcount should be
restored, otherwise the vm couldn't be destroyed.

Fixes: 3bcd0662d66fd ("KVM: X86: Introduce mmu_rmaps_stat per-vm debugfs file")
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/debugfs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index cfed36aba2f7..412ed1b341fa 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -162,7 +162,12 @@ static int kvm_mmu_rmaps_stat_open(struct inode *inode, struct file *file)
 	if (!kvm_get_kvm_safe(kvm))
 		return -ENOENT;
 
-	return single_open(file, kvm_mmu_rmaps_stat_show, kvm);
+	if (single_open(file, kvm_mmu_rmaps_stat_show, kvm)) {
+		kvm_put_kvm(kvm);
+		return -ENOMEM;
+	}
+
+	return 0;
 }
 
 static int kvm_mmu_rmaps_stat_release(struct inode *inode, struct file *file)
-- 
2.31.1

