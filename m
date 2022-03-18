Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD0D4DD6BC
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 10:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbiCRJBw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 05:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232588AbiCRJBv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 05:01:51 -0400
Received: from nksmu.kylinos.cn (mailgw.kylinos.cn [123.150.8.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D671F83FD
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 02:00:33 -0700 (PDT)
X-UUID: 7bb2a2890f2c40558037bd93d8a7a975-20220318
X-UUID: 7bb2a2890f2c40558037bd93d8a7a975-20220318
Received: from cs2c.com.cn [(172.17.111.24)] by nksmu.kylinos.cn
        (envelope-from <liucong2@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 2097548885; Fri, 18 Mar 2022 16:59:17 +0800
X-ns-mid: postfix-62344A0A-6248848230
Received: from localhost.localdomain (unknown [172.20.12.219])
        by cs2c.com.cn (NSMail) with ESMTPA id 7EF983848652;
        Fri, 18 Mar 2022 08:59:54 +0000 (UTC)
From:   Cong Liu <liucong2@kylinos.cn>
To:     pbonzini@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org
Cc:     Cong Liu <liucong2@kylinos.cn>
Subject: [PATCH] kvm/arm64: Fix memory section did not set to kvm
Date:   Fri, 18 Mar 2022 16:59:31 +0800
Message-Id: <20220318085931.3899316-1-liucong2@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

on the arm64 platform, the PAGESIZE is 64k, the default qxl rom
bar size is 8k(QXL_ROM_SZ), in the case memory size less than
one page size, kvm_align_section return zero,  the memory section
did not commit kvm.

Signed-off-by: Cong Liu <liucong2@kylinos.cn>
---
 accel/kvm/kvm-all.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 27864dfaea..f57cab811b 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -318,6 +318,7 @@ static hwaddr kvm_align_section(MemoryRegionSection *section,
                                 hwaddr *start)
 {
     hwaddr size = int128_get64(section->size);
+    size = ROUND_UP(size, qemu_real_host_page_size);
     hwaddr delta, aligned;
 
     /* kvm works in page size chunks, but the function may be called
-- 
2.25.1

