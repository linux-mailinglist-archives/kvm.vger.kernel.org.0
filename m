Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F80A6DFF6E
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 22:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjDLUKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 16:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbjDLUKF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 16:10:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4B4659B
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 13:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681330156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=i5jrl4HyYmJIvlEgkd7txy7LdCkCR9JKfs0t6bJZ/6M=;
        b=SYaM8tLkRiOs69AW1BgYTcYSAb4q286UkJPvJ++HT/NmJoiiIuLKIyIiTt24FPNtmO56tW
        xwCyqwcmzqEjgChLbNF/KiQekS4WQYhvSa4JzhACDrNCGUVgVfhH59JdZWsa14yIkD/Xbs
        ZGMJx/asAOLJa4hRFwq91wTsaIGjxDM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-W2z4sEnHP32Z8O1eFz0J8g-1; Wed, 12 Apr 2023 16:09:14 -0400
X-MC-Unique: W2z4sEnHP32Z8O1eFz0J8g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F1E98996E8;
        Wed, 12 Apr 2023 20:09:14 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4745E40CF916;
        Wed, 12 Apr 2023 20:09:14 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vipinsh@google.com, bgardon@google.com, seanjc@google.com
Subject: [PATCH] selftests/kvm: touch all pages of args on each memstress iteration
Date:   Wed, 12 Apr 2023 16:09:13 -0400
Message-Id: <20230412200913.1570873-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Access the same memory addresses on each iteration of the memstress
guest code.  This ensures that the state of KVM's page tables
is the same after every iteration, including the pages that host the
guest page tables for args and vcpu_args.

This difference is visible on the dirty_log_page_splitting_test
on AMD machines.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/lib/memstress.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index 3632956c6bcf..df457452d146 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -65,6 +65,9 @@ void memstress_guest_code(uint32_t vcpu_idx)
 	GUEST_ASSERT(vcpu_args->vcpu_idx == vcpu_idx);
 
 	while (true) {
+		for (i = 0; i < sizeof(memstress_args); i += args->guest_page_size)
+			(void) *((volatile char *)args + i);
+
 		for (i = 0; i < pages; i++) {
 			if (args->random_access)
 				page = guest_random_u32(&rand_state) % pages;
-- 
2.39.1

