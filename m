Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4DE595941
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 13:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbiHPLEU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 07:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232298AbiHPLDz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 07:03:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 07404B1FF
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 03:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660644780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cxOtHMeWpRKVHAmqRlfILA8ZLjrIx8Hld0hXMLuWU4c=;
        b=M1R9MNRLCbn8xLVdjsxzLZoLECOHeGOO+zeGgst+3a3rA+QfbeZz/3jKNggjmauG8+kqq3
        BOOZSL7Tc5XnUtCkvUCdzd3NYE2++LqoiHwMsRqdXxG/s+TEPGOflEMRqGOuIBS1GMbGaB
        Ms5CMPgUMkeqGqrEFT1eNVI5T3tAbhs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-364-a2SB4FsjMU2i5tzHHrcd0g-1; Tue, 16 Aug 2022 06:12:56 -0400
X-MC-Unique: a2SB4FsjMU2i5tzHHrcd0g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6387638164C7;
        Tue, 16 Aug 2022 10:12:56 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1EEE540D2827;
        Tue, 16 Aug 2022 10:12:56 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [RFC PATCH 1/2] softmmu/memory: add missing begin/commit callback calls
Date:   Tue, 16 Aug 2022 06:12:49 -0400
Message-Id: <20220816101250.1715523-2-eesposit@redhat.com>
In-Reply-To: <20220816101250.1715523-1-eesposit@redhat.com>
References: <20220816101250.1715523-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm listeners now need ->commit callback in order to actually send
the ioctl to the hypervisor. Therefore, add missing callers around
address_space_set_flatview(), which in turn calls
address_space_update_topology_pass() which calls ->region_* and
->log_* callbacks.

Using MEMORY_LISTENER_CALL_GLOBAL is a little bit an overkill,
but it is harmless, considering that other listeners that are not
invoked in address_space_update_topology_pass() won't do anything,
since they won't have anything to commit.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 softmmu/memory.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/softmmu/memory.c b/softmmu/memory.c
index 7ba2048836..1afd3f9703 100644
--- a/softmmu/memory.c
+++ b/softmmu/memory.c
@@ -1076,7 +1076,9 @@ static void address_space_update_topology(AddressSpace *as)
     if (!g_hash_table_lookup(flat_views, physmr)) {
         generate_memory_topology(physmr);
     }
+    MEMORY_LISTENER_CALL_GLOBAL(begin, Forward);
     address_space_set_flatview(as);
+    MEMORY_LISTENER_CALL_GLOBAL(commit, Forward);
 }
 
 void memory_region_transaction_begin(void)
-- 
2.31.1

