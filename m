Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20A124CC645
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236229AbiCCTlG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:41:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236246AbiCCTkk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:40:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 002BE1A3636
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 11:39:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646336360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tBfpxfdS75xaV9F32q3gt0kX6x3EHKO3to4m06m9CBQ=;
        b=FcvoO1RnPuKVAQkVk8AJPhJdLM/O1Wt6CmdQp0CdgF/0quKelreL0z/nsw/oeawRo60qBl
        0Jr+kPWPHWHwtUTacY92ZnnDEpJzwYiTIXgZjjno1jBm9aiM6DXbe8Ol9/5XpA/W0uNAiF
        xa/eBmA+pJDt3iPYq2LD2HXbw1lEpt0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-0YmxRChDOFi917E33vE8sg-1; Thu, 03 Mar 2022 14:39:17 -0500
X-MC-Unique: 0YmxRChDOFi917E33vE8sg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6005E824FA8;
        Thu,  3 Mar 2022 19:39:15 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BC745FC22;
        Thu,  3 Mar 2022 19:39:14 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: [PATCH v4 24/30] KVM: x86/mmu: Zap defunct roots via asynchronous worker
Date:   Thu,  3 Mar 2022 14:38:36 -0500
Message-Id: <20220303193842.370645-25-pbonzini@redhat.com>
In-Reply-To: <20220303193842.370645-1-pbonzini@redhat.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Zap defunct roots, a.k.a. roots that have been invalidated after their
last reference was initially dropped, asynchronously via the system work
queue instead of forcing the work upon the unfortunate task that happened
to drop the last reference.

If a vCPU task drops the last reference, the vCPU is effectively blocked
by the host for the entire duration of the zap.  If the root being zapped
happens be fully populated with 4kb leaf SPTEs, e.g. due to dirty logging
being active, the zap can take several hundred seconds.  Unsurprisingly,
most guests are unhappy if a vCPU disappears for hundreds of seconds.

E.g. running a synthetic selftest that triggers a vCPU root zap with
~64tb of guest memory and 4kb SPTEs blocks the vCPU for 900+ seconds.
Offloading the zap to a worker drops the block time to <100ms.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Message-Id: <20220226001546.360188-23-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e24a1bff9218..2456f880508d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -170,13 +170,24 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	 */
 	if (!kvm_tdp_root_mark_invalid(root)) {
 		refcount_set(&root->tdp_mmu_root_count, 1);
-		tdp_mmu_zap_root(kvm, root, shared);
 
 		/*
-		 * Give back the reference that was added back above.  We now
+		 * If the struct kvm is alive, we might as well zap the root
+		 * in a worker.  The worker takes ownership of the reference we
+		 * just added to root and is flushed before the struct kvm dies.
+		 */
+		if (likely(refcount_read(&kvm->users_count))) {
+			tdp_mmu_schedule_zap_root(kvm, root);
+			return;
+		}
+
+		/*
+		 * The struct kvm is being destroyed, zap synchronously and give
+		 * back immediately the reference that was added above.  We now
 		 * know that the root is invalid, so go ahead and free it if
 		 * no one has taken a reference in the meanwhile.
 		 */
+		tdp_mmu_zap_root(kvm, root, shared);
 		if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
 			return;
 	}
-- 
2.31.1


