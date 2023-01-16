Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8B566B684
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 05:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbjAPEGk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Jan 2023 23:06:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbjAPEGN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Jan 2023 23:06:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1627383FB
        for <kvm@vger.kernel.org>; Sun, 15 Jan 2023 20:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673841913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ohcJPZKvAgOpbS44T4QtlSyb+QSlTiMgmt0MSyKR4Gk=;
        b=gNzeWJcBgdsN7HXhFHpeGZq8KS6LU3t/a36esTB5PkUdhDLu42xCezXxjkK3nEgwo3W8lO
        8hTTbK6x7QdgKA7QE7OH+V8rAsO09zS5nNDJ6GvH1JaUWV88k1DjDjXGzLmQPUJGddzFnK
        2p7ecTXGdGOMUvLAn0MH1hZn4yV5S84=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-404-oZ03pT2jOM-OSGkw5ehlOg-1; Sun, 15 Jan 2023 23:05:08 -0500
X-MC-Unique: oZ03pT2jOM-OSGkw5ehlOg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61A6F3828883;
        Mon, 16 Jan 2023 04:05:07 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-98.bne.redhat.com [10.64.54.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DDB0492B05;
        Mon, 16 Jan 2023 04:05:00 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        corbet@lwn.net, james.morse@arm.com, suzuki.poulose@arm.com,
        oliver.upton@linux.dev, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org, ricarkol@google.com,
        eric.auger@redhat.com, yuzhe@nfschina.com, renzhengeek@gmail.com,
        ardb@kernel.org, peterx@redhat.com, seanjc@google.com,
        shan.gavin@gmail.com
Subject: [PATCH 4/4] KVM: Improve warning report in mark_page_dirty_in_slot()
Date:   Mon, 16 Jan 2023 12:04:05 +0800
Message-Id: <20230116040405.260935-5-gshan@redhat.com>
In-Reply-To: <20230116040405.260935-1-gshan@redhat.com>
References: <20230116040405.260935-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are two warning reports about the dirty ring in the function.
We have the wrong assumption that the dirty ring is always enabled when
CONFIG_HAVE_KVM_DIRTY_RING is selected. This leads to warning messages
about the dirty ring is reported even the dirty ring isn't enabled by
the user space. Actually, the expected behaviour is to report the
warning messages only when the dirty ring is enabled, instead of
being configured.

Fix it by enabling the checks and warning reports when the dirty ring
has been enabled by the user space.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 include/linux/kvm_dirty_ring.h |  5 +++++
 virt/kvm/kvm_main.c            | 25 ++++++++++++++-----------
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
index 4862c98d80d3..3fda0aa42858 100644
--- a/include/linux/kvm_dirty_ring.h
+++ b/include/linux/kvm_dirty_ring.h
@@ -42,6 +42,11 @@ static inline bool kvm_use_dirty_bitmap(struct kvm *kvm)
 	return true;
 }
 
+static inline bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)
+{
+	return false;
+}
+
 static inline int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring,
 				       int index, u32 size)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 90f538433916..a35c32bc84e1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3316,26 +3316,29 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 			     const struct kvm_memory_slot *memslot,
 		 	     gfn_t gfn)
 {
-	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+	struct kvm_vcpu *vcpu;
 	unsigned long rel_gfn;
 	u32 slot;
 
-#ifdef CONFIG_HAVE_KVM_DIRTY_RING
-	if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
-		return;
-
-	WARN_ON_ONCE(!vcpu && !kvm_arch_allow_write_without_running_vcpu(kvm));
-#endif
-
 	if (!memslot || !kvm_slot_dirty_track_enabled(memslot))
 		return;
 
 	rel_gfn = gfn - memslot->base_gfn;
 	slot = (memslot->as_id << 16) | memslot->id;
 
-	if (kvm->dirty_ring_size && vcpu)
-		kvm_dirty_ring_push(vcpu, slot, rel_gfn);
-	else if (memslot->dirty_bitmap)
+	if (kvm->dirty_ring_size) {
+		vcpu = kvm_get_running_vcpu();
+		if (vcpu) {
+			if (!WARN_ON_ONCE(vcpu->kvm != kvm))
+				kvm_dirty_ring_push(vcpu, slot, rel_gfn);
+
+			return;
+		}
+
+		WARN_ON_ONCE(!kvm_arch_allow_write_without_running_vcpu(kvm));
+	}
+
+	if (memslot->dirty_bitmap)
 		set_bit_le(rel_gfn, memslot->dirty_bitmap);
 }
 EXPORT_SYMBOL_GPL(mark_page_dirty_in_slot);
-- 
2.23.0

