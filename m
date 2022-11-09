Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80740622E71
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 15:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbiKIOyH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 09:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbiKIOxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 09:53:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456601BE93
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 06:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668005522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JfGc94yDCYYRgk+7bcbb2irw9WkuzsZKJSFm7OF1c40=;
        b=AmKTiWJZ+chzy6wmimo+19+o99cyJDqqq3LnE5DhePgL1nwbcKGs2kGCuX9pj+fWNEouJl
        2PA2Vig3eGzpz5KCuWMfcuJ4se9K7Vic/rbbV/TlMOco8ZgQgDW2LGNrfTRQQ+u76k+d9f
        bgSP9jVZy/OJlo4Ey8DZFKFqpltZwew=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-AtTefpjtOQyA_deK8dOVHw-1; Wed, 09 Nov 2022 09:51:59 -0500
X-MC-Unique: AtTefpjtOQyA_deK8dOVHw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DAD062815213;
        Wed,  9 Nov 2022 14:51:58 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B25BF140EBF5;
        Wed,  9 Nov 2022 14:51:58 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     thomas.lendacky@amd.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 06/11] KVM: SVM: remove dead field from struct svm_cpu_data
Date:   Wed,  9 Nov 2022 09:51:51 -0500
Message-Id: <20221109145156.84714-7-pbonzini@redhat.com>
In-Reply-To: <20221109145156.84714-1-pbonzini@redhat.com>
References: <20221109145156.84714-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "cpu" field of struct svm_cpu_data has been write-only since commit
4b656b120249 ("KVM: SVM: force new asid on vcpu migration", 2009-08-05).
Remove it.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 1 -
 arch/x86/kvm/svm/svm.h | 2 --
 2 files changed, 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0c86c435c51f..0f873b298931 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -665,7 +665,6 @@ static int svm_cpu_init(int cpu)
 	sd = kzalloc(sizeof(struct svm_cpu_data), GFP_KERNEL);
 	if (!sd)
 		return ret;
-	sd->cpu = cpu;
 	sd->save_area = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (!sd->save_area)
 		goto free_cpu_data;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 626240707ba9..7540db9902a6 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -280,8 +280,6 @@ struct vcpu_svm {
 };
 
 struct svm_cpu_data {
-	int cpu;
-
 	u64 asid_generation;
 	u32 max_asid;
 	u32 next_asid;
-- 
2.31.1


