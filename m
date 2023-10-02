Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7577B51E2
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 13:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236873AbjJBL6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 07:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236844AbjJBL63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 07:58:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A187EE0
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 04:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696247861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ar0urwZ0bmfOZ0eV2FeowpE2tYaVs6PwEG08j6g7CC4=;
        b=Wa/ScDUVhNugkGhBb9vBP97WepTd40u4KA0Aqb4jcPiPCs34CtEC1wA7kFNosNRoce7kck
        xsraxy3Jg6k/1T2Q30B746DONT3RRXMmUD5x2mfVGHfr4zHJISzk7IZTaC+OqUeVxBtznS
        QbXkqO5m+SEfKLglNZjhQ0rhURroOZU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-eA8zi65nNnCoX1cK0Oq2uA-1; Mon, 02 Oct 2023 07:57:40 -0400
X-MC-Unique: eA8zi65nNnCoX1cK0Oq2uA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3B4285A5BA;
        Mon,  2 Oct 2023 11:57:39 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.224.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4471C140E950;
        Mon,  2 Oct 2023 11:57:36 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 3/4] x86: KVM: don't read physical ID table entry in avic_pi_update_irte()
Date:   Mon,  2 Oct 2023 14:57:22 +0300
Message-Id: <20231002115723.175344-4-mlevitsk@redhat.com>
In-Reply-To: <20231002115723.175344-1-mlevitsk@redhat.com>
References: <20231002115723.175344-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change AVIC's code to use vcpu->loaded and vcpu->cpu instead of reading
back the cpu and 'is_running' bit from the avic's physical id entry.

Once AVIC's IPI virtualization is made optional, the 'is_running'
bit might always be false regardless if a vCPU is running or not.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 4c75ca15999fcd4..bdab28005ad3405 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -791,7 +791,6 @@ static int svm_ir_list_add(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
 	int ret = 0;
 	unsigned long flags;
 	struct amd_svm_iommu_ir *ir;
-	u64 entry;
 
 	/**
 	 * In some cases, the existing irte is updated and re-set,
@@ -832,10 +831,11 @@ static int svm_ir_list_add(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
 	 * will update the pCPU info when the vCPU awkened and/or scheduled in.
 	 * See also avic_vcpu_load().
 	 */
-	entry = READ_ONCE(*(svm->avic_physical_id_cache));
-	if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
-		amd_iommu_update_ga(entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK,
-				    true, pi->ir_data);
+	if (READ_ONCE(svm->vcpu.loaded)) {
+		/* Ensure that the vcpu->loaded is read before the vcpu->cpu */
+		smp_rmb();
+		amd_iommu_update_ga(READ_ONCE(svm->vcpu.cpu), true, pi->ir_data);
+	}
 
 	list_add(&ir->node, &svm->ir_list);
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
-- 
2.26.3

