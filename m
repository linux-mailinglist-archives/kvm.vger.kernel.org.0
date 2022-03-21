Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE7CE4E1F54
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 04:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344314AbiCUD3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Mar 2022 23:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344209AbiCUD3x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Mar 2022 23:29:53 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2D1F241FA8
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 20:28:27 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.48:58182.1398798744
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-36.111.64.85 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id 623BD280126;
        Mon, 21 Mar 2022 11:12:41 +0800 (CST)
X-189-SAVE-TO-SEND: wucy11@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id cef6c5c2e03143fa8cd9a09d2b252c43 for kvm@vger.kernel.org;
        Mon, 21 Mar 2022 11:12:46 CST
X-Transaction-ID: cef6c5c2e03143fa8cd9a09d2b252c43
X-Real-From: wucy11@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: wucy11@chinatelecom.cn
Message-ID: <78ba5059-5da0-8750-7663-d8e78e786523@chinatelecom.cn>
Date:   Mon, 21 Mar 2022 11:12:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From:   Chongyun Wu <wucy11@chinatelecom.cn>
Subject: [PATCH 1/5] kvm,memory: Optimize dirty page collection for dirty ring
To:     kvm@vger.kernel.org, qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        yubin1@chinatelecom.cn,
        "ligh10@chinatelecom.cn" <ligh10@chinatelecom.cn>,
        zhengwenm@chinatelecom.cn
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When log_sync_global of dirty ring is called, it will collect
dirty pages on all cpus, including all dirty pages on memslot,
so when memory_region_sync_dirty_bitmap collects dirty pages
from KVM, this interface needs to be called once, instead of
traversing every dirty page. Each memslot is called once,
which is meaningless and time-consuming. So only need to call
log_sync_global once in memory_region_sync_dirty_bitmap.

Signed-off-by: Chongyun Wu <wucy11@chinatelecom.cn>
---
  softmmu/memory.c | 6 ++++++
  1 file changed, 6 insertions(+)

diff --git a/softmmu/memory.c b/softmmu/memory.c
index 678dc62..30d7281 100644
--- a/softmmu/memory.c
+++ b/softmmu/memory.c
@@ -2184,6 +2184,12 @@ static void memory_region_sync_dirty_bitmap(MemoryRegion *mr)
               */
              listener->log_sync_global(listener);
              trace_memory_region_sync_dirty(mr ? mr->name : "(all)", 
listener->name, 1);
+            /*
+             * The log_sync_global of the dirty ring will collect the dirty
+             * pages of all memslots at one time, so there is no need to
+             * call log_sync_global once when traversing each memslot.
+             */
+            break;
          }
      }
  }
--
1.8.3.1

-- 
Best Regard,
Chongyun Wu
