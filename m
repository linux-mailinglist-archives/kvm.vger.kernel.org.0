Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 290A9622E69
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 15:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiKIOxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 09:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiKIOw6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 09:52:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3343DCB
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 06:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668005521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jpp/9pge7de3/UIAxcnUFR66xYbdwFrFxuMBRDq7NmI=;
        b=iPbXFTp4W8y/x8KzoXn6bGypNjQF+0f1Klr80oSRmNZ0ISlw9N65cc/zyPJgoXldYlJwS1
        zcE5d5ddHtDpLA7PZhbEZtEW4S7kGW8SfPQM7YGpvlTuEfjYNYLzj1EEsCoVaDk3VLkelV
        GKqwrYpSL9EPe8hYTuU1gR7ThuomTeM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-Wjeba5JkNj2ug3nhd6IT8A-1; Wed, 09 Nov 2022 09:51:59 -0500
X-MC-Unique: Wjeba5JkNj2ug3nhd6IT8A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A99BF1C0BC9A;
        Wed,  9 Nov 2022 14:51:58 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81B79140EBF5;
        Wed,  9 Nov 2022 14:51:58 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     thomas.lendacky@amd.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 05/11] KVM: SVM: remove unused field from struct vcpu_svm
Date:   Wed,  9 Nov 2022 09:51:50 -0500
Message-Id: <20221109145156.84714-6-pbonzini@redhat.com>
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

The pointer to svm_cpu_data in struct vcpu_svm looks interesting from
the point of view of accessing it after vmexit, when the GSBASE is still
containing the guest value.  However, despite existing since the very
first commit of drivers/kvm/svm.c (commit 6aa8b732ca01, "[PATCH] kvm:
userspace interface", 2006-12-10), it was never set to anything.

Ignore the opportunity to fix a 16 year old "bug" and delete it; doing
things the "harder" way makes it possible to remove more old cruft.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7ff1879e73c5..626240707ba9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -209,7 +209,6 @@ struct vcpu_svm {
 	struct vmcb *vmcb;
 	struct kvm_vmcb_info vmcb01;
 	struct kvm_vmcb_info *current_vmcb;
-	struct svm_cpu_data *svm_data;
 	u32 asid;
 	u32 sysenter_esp_hi;
 	u32 sysenter_eip_hi;
-- 
2.31.1


