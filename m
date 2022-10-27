Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6EF60FCE2
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 18:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236692AbiJ0QTd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 12:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236571AbiJ0QTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 12:19:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E04196B6A
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 09:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666887536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W4jlslF5VNxKyOc4aJjoGknzZszIqLvBjQKfttjSBRM=;
        b=DDTtOA5w+u/8MpcA8VWe7aN83cHq7kqmTEtC+ZTd5ZmMJD4/nWVSnxY4S1RQ9/8oNvnmDV
        EctpbIsmYsNjfaiCNuWq/PUbce4hTR7gHZ//s5nbHIxrTtgXh0BArA/jCFNebLWb5FKhom
        Pu4QOAwA7vEyGjPKwHHv3rJ7X6qE5WA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-306-tkL1K6RmOhWJ2BYpozAGpg-1; Thu, 27 Oct 2022 12:18:52 -0400
X-MC-Unique: tkL1K6RmOhWJ2BYpozAGpg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F6F9811E67;
        Thu, 27 Oct 2022 16:18:52 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E6BE17593;
        Thu, 27 Oct 2022 16:18:52 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mhal@rbox.co, seanjc@google.com
Subject: [PATCH 12/16] KVM: Do not partially reinitialize gfn=>pfn cache during activation
Date:   Thu, 27 Oct 2022 12:18:45 -0400
Message-Id: <20221027161849.2989332-13-pbonzini@redhat.com>
In-Reply-To: <20221027161849.2989332-1-pbonzini@redhat.com>
References: <20221027161849.2989332-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Don't partially reinitialize a gfn=>pfn cache when activating the cache,
and instead assert that the cache is not valid during activation.  Bug
the VM if the assertion fails, as use-after-free and/or data corruption
is all but guaranteed if KVM ends up with a valid-but-inactive cache.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20221013211234.1318131-13-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/pfncache.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 62429b2a6389..06fcf03c2da6 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -347,6 +347,8 @@ void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm,
 	gpc->kvm = kvm;
 	gpc->vcpu = vcpu;
 	gpc->usage = usage;
+	gpc->pfn = KVM_PFN_ERR_FAULT;
+	gpc->uhva = KVM_HVA_ERR_BAD;
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_init);
 
@@ -355,10 +357,8 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
 	struct kvm *kvm = gpc->kvm;
 
 	if (!gpc->active) {
-		gpc->khva = NULL;
-		gpc->pfn = KVM_PFN_ERR_FAULT;
-		gpc->uhva = KVM_HVA_ERR_BAD;
-		gpc->valid = false;
+		if (KVM_BUG_ON(gpc->valid, kvm))
+			return -EIO;
 
 		spin_lock(&kvm->gpc_lock);
 		list_add(&gpc->list, &kvm->gpc_list);
-- 
2.31.1


