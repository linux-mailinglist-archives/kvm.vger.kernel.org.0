Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A32A229CB7
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbgGVQCS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:02:18 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:38038 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729217AbgGVQBj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:39 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 935A3305D769;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 894D8305FFA5;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 18/34] KVM: introspection: extend KVMI_VM_SET_PAGE_ACCESS with EPT view info
Date:   Wed, 22 Jul 2020 19:01:05 +0300
Message-Id: <20200722160121.9601-19-alazar@bitdefender.com>
In-Reply-To: <20200722160121.9601-1-alazar@bitdefender.com>
References: <20200722160121.9601-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ștefan Șicleru <ssicleru@bitdefender.com>

The introspection tool uses this command to set distinct access rights
on different EPT views.

Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst |  8 +++++---
 include/uapi/linux/kvmi.h       |  4 ++--
 virt/kvm/introspection/kvmi.c   | 10 ++++++++--
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index f4c60aba9b53..658c9df01469 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -1003,8 +1003,8 @@ to control events for any other register will fail with -KVM_EINVAL::
 
 	struct kvmi_vm_set_page_access {
 		__u16 count;
-		__u16 padding1;
-		__u32 padding2;
+		__u16 view;
+		__u32 padding;
 		struct kvmi_page_access_entry entries[0];
 	};
 
@@ -1026,7 +1026,7 @@ where::
 	struct kvmi_error_code
 
 Sets the access bits (rwx) for an array of ``count`` guest physical
-addresses.
+addresses, for the selected view.
 
 The valid access bits are::
 
@@ -1048,7 +1048,9 @@ In order to 'forget' an address, all three bits ('rwx') must be set.
 
 * -KVM_EINVAL - the specified access bits combination is invalid
 * -KVM_EINVAL - the padding is not zero
+* -KVM_EINVAL - the selected EPT view is invalid
 * -KVM_EINVAL - the message size is invalid
+* -KVM_EOPNOTSUPP - an EPT view was selected but the hardware doesn't support it
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 * -KVM_ENOMEM - there is not enough memory to add the page tracking structures
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index a72c536a2c80..505a865cd115 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -191,8 +191,8 @@ struct kvmi_page_access_entry {
 
 struct kvmi_vm_set_page_access {
 	__u16 count;
-	__u16 padding1;
-	__u32 padding2;
+	__u16 view;
+	__u32 padding;
 	struct kvmi_page_access_entry entries[0];
 };
 
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 737fe3c7a956..44b0092e304f 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -1187,14 +1187,20 @@ int kvmi_cmd_set_page_access(struct kvm_introspection *kvmi,
 	const struct kvmi_page_access_entry *end = req->entries + req->count;
 	int ec = 0;
 
-	if (req->padding1 || req->padding2)
+	if (req->padding)
 		return -KVM_EINVAL;
 
 	if (msg->size < struct_size(req, entries, req->count))
 		return -KVM_EINVAL;
 
+	if (!is_valid_view(req->view))
+		return -KVM_EINVAL;
+
+	if (req->view != 0 && !kvm_eptp_switching_supported)
+		return -KVM_EOPNOTSUPP;
+
 	for (; entry < end; entry++) {
-		int r = set_page_access_entry(kvmi, 0, entry);
+		int r = set_page_access_entry(kvmi, req->view, entry);
 
 		if (r && !ec)
 			ec = r;
