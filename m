Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD547B51E4
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 13:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236879AbjJBL6k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 07:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236843AbjJBL63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 07:58:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C28F8D7
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 04:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696247866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KOVqc9nE1wzSloZSIZglCt8Fd/e7Bb/HSk7V8DxF+zY=;
        b=NYzUfK/YwNVoJ574guj64m25GGKRJJ/vObZfC8YmJTkHdt55QEuHTn2sZLegHBxqFbNd5J
        Ke5mWxLRUYZwxABSCwaOpn2D7DnUaDu9AOftnt9BfpzGWtEtaIYnf2s8ZcrJ74Yf3x/wXf
        47FopIqFi+ThpgQXC7XEfeqQnruVI0I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-217-AAsvoonTPgymJCVqpBS66A-1; Mon, 02 Oct 2023 07:57:33 -0400
X-MC-Unique: AAsvoonTPgymJCVqpBS66A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5225F101B042;
        Mon,  2 Oct 2023 11:57:32 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.224.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 12BAE140E953;
        Mon,  2 Oct 2023 11:57:28 +0000 (UTC)
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
Subject: [PATCH v3 1/4] KVM: Add per vCPU flag specifying that a vCPU is loaded
Date:   Mon,  2 Oct 2023 14:57:20 +0300
Message-Id: <20231002115723.175344-2-mlevitsk@redhat.com>
In-Reply-To: <20231002115723.175344-1-mlevitsk@redhat.com>
References: <20231002115723.175344-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add vcpu->loaded boolean flag specifying that a vCPU is loaded.

Such flag can be useful in a vendor code (e.g AVIC) to make
decisions based on it.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index fb6c6109fdcad69..331432d86e44d51 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -379,6 +379,7 @@ struct kvm_vcpu {
 #endif
 	bool preempted;
 	bool ready;
+	bool loaded;
 	struct kvm_vcpu_arch arch;
 	struct kvm_vcpu_stat stat;
 	char stats_id[KVM_STATS_NAME_SIZE];
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 486800a7024b373..615f2a02b7cb97f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -214,6 +214,10 @@ void vcpu_load(struct kvm_vcpu *vcpu)
 	__this_cpu_write(kvm_running_vcpu, vcpu);
 	preempt_notifier_register(&vcpu->preempt_notifier);
 	kvm_arch_vcpu_load(vcpu, cpu);
+
+	/* Ensure that vcpu->cpu is visible before vcpu->loaded is set to true */
+	smp_wmb();
+	WRITE_ONCE(vcpu->loaded, true);
 	put_cpu();
 }
 EXPORT_SYMBOL_GPL(vcpu_load);
@@ -221,6 +225,12 @@ EXPORT_SYMBOL_GPL(vcpu_load);
 void vcpu_put(struct kvm_vcpu *vcpu)
 {
 	preempt_disable();
+	WRITE_ONCE(vcpu->loaded, false);
+	/*
+	 * Ensure that vcpu->loaded is set and visible,
+	 * before KVM actually unloads the vCPU.
+	 */
+	smp_wmb();
 	kvm_arch_vcpu_put(vcpu);
 	preempt_notifier_unregister(&vcpu->preempt_notifier);
 	__this_cpu_write(kvm_running_vcpu, NULL);
-- 
2.26.3

