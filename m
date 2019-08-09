Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9AE587F3B
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437207AbfHIQPM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:12 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52908 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437119AbfHIQPI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:08 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id DC82D305D345;
        Fri,  9 Aug 2019 19:01:15 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 7EF77305B7A1;
        Fri,  9 Aug 2019 19:01:14 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v6 44/92] kvm: introspection: extend the internal database of tracked pages with write_bitmap info
Date:   Fri,  9 Aug 2019 18:59:59 +0300
Message-Id: <20190809160047.8319-45-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will allow us to use the subpage protection feature.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 virt/kvm/kvmi.c     | 46 +++++++++++++++++++++++++++++++++++++--------
 virt/kvm/kvmi_int.h |  1 +
 2 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index 4a9a4430a460..e18dfffa25ac 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -32,6 +32,7 @@ static void kvmi_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
 static const u8 full_access  =	KVMI_PAGE_ACCESS_R |
 				KVMI_PAGE_ACCESS_W |
 				KVMI_PAGE_ACCESS_X;
+static const u32 default_write_access_bitmap;
 
 void *kvmi_msg_alloc(void)
 {
@@ -57,23 +58,32 @@ static struct kvmi_mem_access *__kvmi_get_gfn_access(struct kvmi *ikvm,
 	return radix_tree_lookup(&ikvm->access_tree, gfn);
 }
 
+/*
+ * TODO: intercept any SPP change made on pages present in our radix tree.
+ *
+ * bitmap must have the same value as the corresponding SPPT entry.
+ */
 static int kvmi_get_gfn_access(struct kvmi *ikvm, const gfn_t gfn,
-			       u8 *access)
+			       u8 *access, u32 *write_bitmap)
 {
 	struct kvmi_mem_access *m;
 
+	*write_bitmap = default_write_access_bitmap;
 	*access = full_access;
 
 	read_lock(&ikvm->access_tree_lock);
 	m = __kvmi_get_gfn_access(ikvm, gfn);
-	if (m)
+	if (m) {
 		*access = m->access;
+		*write_bitmap = m->write_bitmap;
+	}
 	read_unlock(&ikvm->access_tree_lock);
 
 	return m ? 0 : -1;
 }
 
-static int kvmi_set_gfn_access(struct kvm *kvm, gfn_t gfn, u8 access)
+static int kvmi_set_gfn_access(struct kvm *kvm, gfn_t gfn, u8 access,
+			       u32 write_bitmap)
 {
 	struct kvmi_mem_access *m;
 	struct kvmi_mem_access *__m;
@@ -87,6 +97,7 @@ static int kvmi_set_gfn_access(struct kvm *kvm, gfn_t gfn, u8 access)
 
 	m->gfn = gfn;
 	m->access = access;
+	m->write_bitmap = write_bitmap;
 
 	if (radix_tree_preload(GFP_KERNEL)) {
 		err = -KVM_ENOMEM;
@@ -100,6 +111,7 @@ static int kvmi_set_gfn_access(struct kvm *kvm, gfn_t gfn, u8 access)
 	__m = __kvmi_get_gfn_access(ikvm, gfn);
 	if (__m) {
 		__m->access = access;
+		__m->write_bitmap = write_bitmap;
 		kvmi_arch_update_page_tracking(kvm, NULL, __m);
 		if (access == full_access) {
 			radix_tree_delete(&ikvm->access_tree, gfn);
@@ -124,12 +136,22 @@ static int kvmi_set_gfn_access(struct kvm *kvm, gfn_t gfn, u8 access)
 	return err;
 }
 
+static bool spp_access_allowed(gpa_t gpa, unsigned long bitmap)
+{
+	u32 off = (gpa & ~PAGE_MASK);
+	u32 spp = off / 128;
+
+	return test_bit(spp, &bitmap);
+}
+
 static bool kvmi_restricted_access(struct kvmi *ikvm, gpa_t gpa, u8 access)
 {
+	u32 allowed_bitmap;
 	u8 allowed_access;
 	int err;
 
-	err = kvmi_get_gfn_access(ikvm, gpa_to_gfn(gpa), &allowed_access);
+	err = kvmi_get_gfn_access(ikvm, gpa_to_gfn(gpa), &allowed_access,
+				  &allowed_bitmap);
 
 	if (err)
 		return false;
@@ -138,8 +160,14 @@ static bool kvmi_restricted_access(struct kvmi *ikvm, gpa_t gpa, u8 access)
 	 * We want to be notified only for violations involving access
 	 * bits that we've specifically cleared
 	 */
-	if ((~allowed_access) & access)
+	if ((~allowed_access) & access) {
+		bool write_access = (access & KVMI_PAGE_ACCESS_W);
+
+		if (write_access && spp_access_allowed(gpa, allowed_bitmap))
+			return false;
+
 		return true;
+	}
 
 	return false;
 }
@@ -1126,8 +1154,9 @@ void kvmi_handle_requests(struct kvm_vcpu *vcpu)
 int kvmi_cmd_get_page_access(struct kvmi *ikvm, u64 gpa, u8 *access)
 {
 	gfn_t gfn = gpa_to_gfn(gpa);
+	u32 ignored_write_bitmap;
 
-	kvmi_get_gfn_access(ikvm, gfn, access);
+	kvmi_get_gfn_access(ikvm, gfn, access, &ignored_write_bitmap);
 
 	return 0;
 }
@@ -1136,10 +1165,11 @@ int kvmi_cmd_set_page_access(struct kvmi *ikvm, u64 gpa, u8 access)
 {
 	gfn_t gfn = gpa_to_gfn(gpa);
 	u8 ignored_access;
+	u32 write_bitmap;
 
-	kvmi_get_gfn_access(ikvm, gfn, &ignored_access);
+	kvmi_get_gfn_access(ikvm, gfn, &ignored_access, &write_bitmap);
 
-	return kvmi_set_gfn_access(ikvm->kvm, gfn, access);
+	return kvmi_set_gfn_access(ikvm->kvm, gfn, access, write_bitmap);
 }
 
 int kvmi_cmd_control_events(struct kvm_vcpu *vcpu, unsigned int event_id,
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index 3f0c7a03b4a1..d9a10a3b7082 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -141,6 +141,7 @@ struct kvmi {
 struct kvmi_mem_access {
 	gfn_t gfn;
 	u8 access;
+	u32 write_bitmap;
 	struct kvmi_arch_mem_access arch;
 };
 
