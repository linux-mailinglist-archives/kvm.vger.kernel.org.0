Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0247B2068
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 17:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbjI1PFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 11:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbjI1PFi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 11:05:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22791AA
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 08:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695913490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+K85/eS/kylNQpLV/CXk6IqQwJPNNCcpLU6igIUXkXY=;
        b=b0JeykC0bqeA72K6dN/iM3Sj1hM9kcTAyl9Oa7WjuENHmJZ8if/Lh/wadKhC+BvS4d9VqR
        4NCkJwDYKV+03VrdfqT0QavsiNCt7CmhWck6NTm92q6TB3fbhPJGwWk68LL5xVTfMKsWnm
        zPjYvvGtN512KJtVwMNq2LpPBuDF17w=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-DDx6aR3LPmeCIbUCa9SEdA-1; Thu, 28 Sep 2023 11:04:45 -0400
X-MC-Unique: DDx6aR3LPmeCIbUCa9SEdA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8DBD3C1ACEE;
        Thu, 28 Sep 2023 15:04:44 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.226.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E86A40C6E76;
        Thu, 28 Sep 2023 15:04:41 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 3/5] x86: KVM: SVM: refresh AVIC inhibition in svm_leave_nested()
Date:   Thu, 28 Sep 2023 18:04:26 +0300
Message-Id: <20230928150428.199929-4-mlevitsk@redhat.com>
In-Reply-To: <20230928150428.199929-1-mlevitsk@redhat.com>
References: <20230928150428.199929-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

svm_leave_nested() similar to a nested VM exit, get the vCPU out of nested
mode and thus should end the local inhibition of AVIC on this vCPU.

Failure to do so, can lead to hangs on guest reboot.

Raise the KVM_REQ_APICV_UPDATE request to refresh the AVIC state of the
current vCPU in this case.

Cc: stable@vger.kernel.org

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index dd496c9e5f91f28..3fea8c47679e689 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1253,6 +1253,9 @@ void svm_leave_nested(struct kvm_vcpu *vcpu)
 
 		nested_svm_uninit_mmu_context(vcpu);
 		vmcb_mark_all_dirty(svm->vmcb);
+
+		if (kvm_apicv_activated(vcpu->kvm))
+			kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
 	}
 
 	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
-- 
2.26.3

