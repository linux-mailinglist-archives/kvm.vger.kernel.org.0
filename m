Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDFBD6354A3
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 10:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237132AbiKWJJs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 04:09:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237153AbiKWJJo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 04:09:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1DF12D32
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 01:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669194523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WQbEhgs5qxc94Qred5pff5swxDYduz0Vj7Oft/jd7ac=;
        b=QIUKdFdWE7SeTqXirieO31+SW/5DHthJ9Y0CVjtN+EG6gyD+Z+xbOuR5hckbXYbfovQHu4
        c8nw2y/cdaiWTBM9ffwNKsD0pSfWkZVHMfrXLKoUNwKFRtGh2Wab1ADeZrM81CUFFmtlnG
        9cFrTcxjJS+qHrk+CMG0COe/aSDSc50=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-512-poHxTbQwPziHRPlq95zWVw-1; Wed, 23 Nov 2022 04:08:40 -0500
X-MC-Unique: poHxTbQwPziHRPlq95zWVw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62D52811E7A;
        Wed, 23 Nov 2022 09:08:40 +0000 (UTC)
Received: from thuth.com (unknown [10.39.193.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1487A1415114;
        Wed, 23 Nov 2022 09:08:37 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        "Collin L. Walling" <walling@linux.ibm.com>,
        Jason J Herne <jjherne@linux.ibm.com>
Subject: [PATCH] KVM: s390: vsie: Fix the initialization of the epoch extension (epdx) field
Date:   Wed, 23 Nov 2022 10:08:33 +0100
Message-Id: <20221123090833.292938-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We recently experienced some weird huge time jumps in nested guests when
rebooting them in certain cases. After adding some debug code to the epoch
handling in vsie.c (thanks to David Hildenbrand for the idea!), it was
obvious that the "epdx" field (the multi-epoch extension) did not get set
to 0xff in case the "epoch" field was negative.
Seems like the code misses to copy the value from the epdx field from
the guest to the shadow control block. By doing so, the weird time
jumps are gone in our scenarios.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=2140899
Fixes: 8fa1696ea781 ("KVM: s390: Multiple Epoch Facility support")
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 arch/s390/kvm/vsie.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 94138f8f0c1c..ace2541ababd 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -546,8 +546,10 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	if (test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_CEI))
 		scb_s->eca |= scb_o->eca & ECA_CEI;
 	/* Epoch Extension */
-	if (test_kvm_facility(vcpu->kvm, 139))
+	if (test_kvm_facility(vcpu->kvm, 139)) {
 		scb_s->ecd |= scb_o->ecd & ECD_MEF;
+		scb_s->epdx = scb_o->epdx;
+	}
 
 	/* etoken */
 	if (test_kvm_facility(vcpu->kvm, 156))
-- 
2.31.1

