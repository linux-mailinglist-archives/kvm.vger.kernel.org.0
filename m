Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4615B3579
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 12:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbiIIKpb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 06:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiIIKpT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 06:45:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A812E4F67B
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 03:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662720316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sP4vjAy5dPb317LaSVOvXhYqCo8CTxm9lVTHh2Rs0Uk=;
        b=HQD1xFk6ubBsMaPjOUGbs9OWMM7atEg7TWm+rX6X4hLnUntOYBmQofXpwiPnjtn5oq7lTO
        9+pxThslmdNlfSYBt0QqFck36ZGpASuOibPm3+SzJLUuzHMFyg/nPwpB4w/TBnIcmJHKWg
        pW76E9xerJdDI7GESgh5AewgmpWtSug=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-LRY8QVp1N3GagGCz9l-VOQ-1; Fri, 09 Sep 2022 06:45:10 -0400
X-MC-Unique: LRY8QVp1N3GagGCz9l-VOQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1BA451C05AE6;
        Fri,  9 Sep 2022 10:45:10 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC63140D282E;
        Fri,  9 Sep 2022 10:45:09 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [RFC PATCH 2/9] kvm.h: introduce KVM_SET_USER_MEMORY_REGION_LIST ioctl
Date:   Fri,  9 Sep 2022 06:44:59 -0400
Message-Id: <20220909104506.738478-3-eesposit@redhat.com>
In-Reply-To: <20220909104506.738478-1-eesposit@redhat.com>
References: <20220909104506.738478-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This IOCTL enables atomic update of multiple memslots.
The userspace application provides a kvm_userspace_memory_region_list
containing a list of entries, each representing a modification to be
performed to a memslot.

Requests with invalidate_slot == 1 are pre-processed, because they
are ther DELETE or MOVE, and therefore the memslot must be first
replaced with a copy marked as KVM_MEMSLOT_INVALID, and then replaced.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 include/uapi/linux/kvm.h | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a36e78710382..673496b91a25 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -103,6 +103,24 @@ struct kvm_userspace_memory_region {
 	__u64 userspace_addr; /* start of the userspace allocated memory */
 };
 
+/* for KVM_SET_USER_MEMORY_REGION_LIST */
+struct kvm_userspace_memory_region_entry {
+	__u32 slot;
+	__u32 flags;
+	__u64 guest_phys_addr;
+	__u64 memory_size; /* bytes */
+	__u64 userspace_addr; /* start of the userspace allocated memory */
+	__u8 invalidate_slot;
+	__u8 padding[31];
+};
+
+/* for KVM_SET_USER_MEMORY_REGION_LIST */
+struct kvm_userspace_memory_region_list {
+	__u32 nent;
+	__u32 flags;
+	struct kvm_userspace_memory_region_entry entries[0];
+};
+
 /*
  * The bit 0 ~ bit 15 of kvm_memory_region::flags are visible for userspace,
  * other bits are reserved for kvm internal use which are defined in
@@ -1444,7 +1462,8 @@ struct kvm_vfio_spapr_tce {
 					struct kvm_userspace_memory_region)
 #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
 #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
-
+#define KVM_SET_USER_MEMORY_REGION_LIST _IOW(KVMIO, 0x49, \
+					struct kvm_userspace_memory_region_list)
 /* enable ucontrol for s390 */
 struct kvm_s390_ucas_mapping {
 	__u64 user_addr;
-- 
2.31.1

