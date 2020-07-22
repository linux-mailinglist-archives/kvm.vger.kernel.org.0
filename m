Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46CA229C94
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731151AbgGVQBt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:01:49 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37954 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728670AbgGVQBm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:42 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 47D28305D67A;
        Wed, 22 Jul 2020 19:01:33 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 3C8C2305FFA3;
        Wed, 22 Jul 2020 19:01:33 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 33/34] KVM: introspection: mask out non-rwx flags when reading/writing from/to the internal database
Date:   Wed, 22 Jul 2020 19:01:20 +0300
Message-Id: <20200722160121.9601-34-alazar@bitdefender.com>
In-Reply-To: <20200722160121.9601-1-alazar@bitdefender.com>
References: <20200722160121.9601-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is needed because the KVMI_VM_SET_PAGE_SVE command we will use
the same database to keep the suppress #VE bit requested by the
introspection tool.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 virt/kvm/introspection/kvmi.c | 36 ++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index f3bdef3c54e6..6bae2981cda7 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -23,9 +23,12 @@ static struct kmem_cache *msg_cache;
 static struct kmem_cache *job_cache;
 static struct kmem_cache *radix_cache;
 
-static const u8 full_access  =	KVMI_PAGE_ACCESS_R |
-				KVMI_PAGE_ACCESS_W |
-				KVMI_PAGE_ACCESS_X;
+static const u8 rwx_access = KVMI_PAGE_ACCESS_R |
+			     KVMI_PAGE_ACCESS_W |
+			     KVMI_PAGE_ACCESS_X;
+static const u8 full_access = KVMI_PAGE_ACCESS_R |
+			     KVMI_PAGE_ACCESS_W |
+			     KVMI_PAGE_ACCESS_X;
 
 void *kvmi_msg_alloc(void)
 {
@@ -1100,7 +1103,7 @@ static void kvmi_insert_mem_access(struct kvm *kvm, struct kvmi_mem_access *m,
 }
 
 static void kvmi_set_mem_access(struct kvm *kvm, struct kvmi_mem_access *m,
-				u16 view, bool *used)
+				u8 mask, u16 view, bool *used)
 {
 	struct kvm_introspection *kvmi = KVMI(kvm);
 	struct kvmi_mem_access *found;
@@ -1112,11 +1115,14 @@ static void kvmi_set_mem_access(struct kvm *kvm, struct kvmi_mem_access *m,
 
 	found = __kvmi_get_gfn_access(kvmi, m->gfn, view);
 	if (found) {
-		found->access = m->access;
+		found->access = (m->access & mask) | (found->access & ~mask);
 		kvmi_update_mem_access(kvm, found, view);
-	} else if (m->access != full_access) {
-		kvmi_insert_mem_access(kvm, m, view);
-		*used = true;
+	} else {
+		m->access |= full_access & ~mask;
+		if (m->access != full_access) {
+			kvmi_insert_mem_access(kvm, m, view);
+			*used = true;
+		}
 	}
 
 	write_unlock(&kvmi->access_tree_lock);
@@ -1141,7 +1147,7 @@ static int kvmi_set_gfn_access(struct kvm *kvm, gfn_t gfn, u8 access,
 	if (radix_tree_preload(GFP_KERNEL))
 		err = -KVM_ENOMEM;
 	else
-		kvmi_set_mem_access(kvm, m, view, &used);
+		kvmi_set_mem_access(kvm, m, rwx_access, view, &used);
 
 	radix_tree_preload_end();
 
@@ -1216,14 +1222,22 @@ static int kvmi_get_gfn_access(struct kvm_introspection *kvmi, const gfn_t gfn,
 			       u8 *access, u16 view)
 {
 	struct kvmi_mem_access *m;
+	u8 allowed = rwx_access;
+	bool restricted;
 
 	read_lock(&kvmi->access_tree_lock);
 	m = __kvmi_get_gfn_access(kvmi, gfn, view);
 	if (m)
-		*access = m->access;
+		allowed = m->access;
 	read_unlock(&kvmi->access_tree_lock);
 
-	return m ? 0 : -1;
+	restricted = (allowed & rwx_access) != rwx_access;
+
+	if (!restricted)
+		return -1;
+
+	*access = allowed;
+	return 0;
 }
 
 bool kvmi_restricted_page_access(struct kvm_introspection *kvmi, gpa_t gpa,
