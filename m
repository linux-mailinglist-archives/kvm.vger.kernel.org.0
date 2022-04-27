Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F5B512397
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 22:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235900AbiD0UJ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 16:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236010AbiD0UJF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 16:09:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F05783A5DD
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 13:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651089877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=89RuVlFWNENo513LfTx1J681fautsCwvIr9MnyyPgbQ=;
        b=OVXMqeJxiX/AL37/H2WLnWWD/EnO+HFQ1PbKmvmOiaeFEBUpO12VTkKp3N2XiHEQDbm1xh
        UGJSnEgqXLEiUTbi0w5BjY/zE+OP/DOwvEq3aU+WT3ojnCJr1fwidVG5s1qBja4G2laYAY
        fVb0OQ2gF62iRhjvYQ5EeEMGSZQgrI4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-210-UNDZGWhRO4GsZn6rKZitjg-1; Wed, 27 Apr 2022 16:04:31 -0400
X-MC-Unique: UNDZGWhRO4GsZn6rKZitjg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E063802809;
        Wed, 27 Apr 2022 20:04:30 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9AB0D9E89;
        Wed, 27 Apr 2022 20:04:23 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        intel-gfx@lists.freedesktop.org,
        Sean Christopherson <seanjc@google.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [RFC PATCH v3 10/19] KVM: x86: nSVM: implement AVIC's physid/logid table access helpers
Date:   Wed, 27 Apr 2022 23:03:05 +0300
Message-Id: <20220427200314.276673-11-mlevitsk@redhat.com>
In-Reply-To: <20220427200314.276673-1-mlevitsk@redhat.com>
References: <20220427200314.276673-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This implements a few helpers that help manipulate the AVIC's
physical and logical id table entries.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.h | 45 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6fcb164a6ee4a..dfca4c06e2071 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -628,6 +628,51 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu);
 void avic_ring_doorbell(struct kvm_vcpu *vcpu);
 unsigned long avic_vcpu_get_apicv_inhibit_reasons(struct kvm_vcpu *vcpu);
 
+#define INVALID_BACKING_PAGE	(~(u64)0)
+
+static inline u64 physid_entry_get_backing_table(u64 entry)
+{
+	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_VALID_MASK))
+		return INVALID_BACKING_PAGE;
+	return entry & AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK;
+}
+
+static inline int physid_entry_get_apicid(u64 entry)
+{
+	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_VALID_MASK))
+		return -1;
+	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
+		return -1;
+
+	return entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
+}
+
+static inline int logid_get_physid(u64 entry)
+{
+	if (!(entry & AVIC_LOGICAL_ID_ENTRY_VALID_BIT))
+		return -1;
+	return entry & AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK;
+}
+
+static inline void physid_entry_set_backing_table(u64 *entry, u64 value)
+{
+	*entry &= ~AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK;
+	*entry |= (AVIC_PHYSICAL_ID_ENTRY_VALID_MASK | value);
+}
+
+static inline void physid_entry_set_apicid(u64 *entry, int value)
+{
+	WARN_ON(!(*entry & AVIC_PHYSICAL_ID_ENTRY_VALID_MASK));
+
+	*entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
+
+	if (value == -1)
+		*entry &= ~(AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
+	else
+		*entry |= (AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK | value);
+}
+
+
 /* sev.c */
 
 #define GHCB_VERSION_MAX	1ULL
-- 
2.26.3

