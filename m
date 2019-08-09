Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBE0F87F2C
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437152AbfHIQPG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:06 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53024 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437014AbfHIQPD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:03 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 80E2D305D357;
        Fri,  9 Aug 2019 19:01:29 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 9DD82305B7A1;
        Fri,  9 Aug 2019 19:01:28 +0300 (EEST)
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
Subject: [RFC PATCH v6 66/92] kvm: introspection: add custom input when single-stepping a vCPU
Date:   Fri,  9 Aug 2019 19:00:21 +0300
Message-Id: <20190809160047.8319-67-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The introspection tool can respond to a KVMI_EVENT_PF event with custom
input for the current instruction. This input is used to trick the guest
software into believing it has read certain data, in order to hide the
content of certain memory areas (eg. hide injected code from integrity
checkers). There are cases when this can happen while the vCPU has to
be single stepped, Either the current instruction is not supported by
the KVM emulator or the introspection tool requested single-stepping.

This patch saves the old data, write the custom input, start the single
stepping and restore the old data.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 virt/kvm/kvmi.c     | 119 ++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvmi_int.h |   3 ++
 2 files changed, 122 insertions(+)

diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index 3dfedf3ae739..06dc23f40ded 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -1618,6 +1618,116 @@ int kvmi_cmd_pause_vcpu(struct kvm_vcpu *vcpu, bool wait)
 	return 0;
 }
 
+static int write_custom_data_to_page(struct kvm_vcpu *vcpu, gva_t gva,
+					u8 *backup, size_t bytes)
+{
+	u8 *ptr_page, *ptr;
+	struct page *page;
+	gpa_t gpa;
+
+	gpa = kvm_mmu_gva_to_gpa_system(vcpu, gva, NULL);
+	if (gpa == UNMAPPED_GVA)
+		return -KVM_EINVAL;
+
+	ptr_page = get_page_ptr(vcpu->kvm, gpa, &page, true);
+	if (!ptr_page)
+		return -KVM_EINVAL;
+
+	ptr = ptr_page + (gpa & ~PAGE_MASK);
+
+	memcpy(backup, ptr, bytes);
+	use_custom_input(vcpu, gva, ptr, bytes);
+
+	put_page_ptr(ptr_page, page);
+
+	return 0;
+}
+
+static int write_custom_data(struct kvm_vcpu *vcpu)
+{
+	struct kvmi *ikvm = IKVM(vcpu->kvm);
+	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
+	size_t bytes = ivcpu->ctx_size;
+	gva_t gva = ivcpu->ctx_addr;
+	u8 *backup;
+
+	if (ikvm->ss_custom_size)
+		return 0;
+
+	if (!bytes)
+		return 0;
+
+	backup = ikvm->ss_custom_data;
+
+	while (bytes) {
+		size_t offset = gva & ~PAGE_MASK;
+		size_t chunk = min(bytes, PAGE_SIZE - offset);
+
+		if (write_custom_data_to_page(vcpu, gva, backup, chunk))
+			return -KVM_EINVAL;
+
+		bytes -= chunk;
+		backup += chunk;
+		gva += chunk;
+		ikvm->ss_custom_size += chunk;
+	}
+
+	return 0;
+}
+
+static int restore_backup_data_to_page(struct kvm_vcpu *vcpu, gva_t gva,
+					u8 *src, size_t bytes)
+{
+	u8 *ptr_page, *ptr;
+	struct page *page;
+	gpa_t gpa;
+
+	gpa = kvm_mmu_gva_to_gpa_system(vcpu, gva, NULL);
+	if (gpa == UNMAPPED_GVA)
+		return -KVM_EINVAL;
+
+	ptr_page = get_page_ptr(vcpu->kvm, gpa, &page, true);
+	if (!ptr_page)
+		return -KVM_EINVAL;
+
+	ptr = ptr_page + (gpa & ~PAGE_MASK);
+
+	memcpy(ptr, src, bytes);
+
+	put_page_ptr(ptr_page, page);
+
+	return 0;
+}
+
+static void restore_backup_data(struct kvm_vcpu *vcpu)
+{
+	struct kvmi *ikvm = IKVM(vcpu->kvm);
+	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
+	size_t bytes = ikvm->ss_custom_size;
+	gva_t gva = ivcpu->ctx_addr;
+	u8 *backup;
+
+	if (!bytes)
+		return;
+
+	backup = ikvm->ss_custom_data;
+
+	while (bytes) {
+		size_t offset = gva & ~PAGE_MASK;
+		size_t chunk = min(bytes, PAGE_SIZE - offset);
+
+		if (restore_backup_data_to_page(vcpu, gva, backup, chunk))
+			goto out;
+
+		bytes -= chunk;
+		backup += chunk;
+		gva += chunk;
+	}
+
+out:
+	ikvm->ss_custom_size = 0;
+}
+
 void kvmi_stop_ss(struct kvm_vcpu *vcpu)
 {
 	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
@@ -1642,6 +1752,8 @@ void kvmi_stop_ss(struct kvm_vcpu *vcpu)
 
 	ikvm->ss_level = 0;
 
+	restore_backup_data(vcpu);
+
 	kvmi_arch_stop_single_step(vcpu);
 
 	atomic_set(&ikvm->ss_active, false);
@@ -1676,6 +1788,7 @@ static bool kvmi_acquire_ss(struct kvm_vcpu *vcpu)
 						KVM_REQUEST_WAIT);
 
 	ivcpu->ss_owner = true;
+	ikvm->ss_custom_size = 0;
 
 	return true;
 }
@@ -1690,6 +1803,12 @@ static bool kvmi_run_ss(struct kvm_vcpu *vcpu, gpa_t gpa, u8 access)
 
 	kvmi_arch_start_single_step(vcpu);
 
+	err = write_custom_data(vcpu);
+	if (err) {
+		kvmi_err(ikvm, "writing custom data failed, err %d\n", err);
+		return false;
+	}
+
 	err = kvmi_get_gfn_access(ikvm, gfn, &old_access, &old_write_bitmap);
 	/* likely was removed from radix tree due to rwx */
 	if (err) {
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index 1550fe33ed48..5485529db06b 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -160,6 +160,9 @@ struct kvmi {
 		u8 old_access;
 		u32 old_write_bitmap;
 	} ss_context[SINGLE_STEP_MAX_DEPTH];
+	u8 ss_custom_data[KVMI_CTX_DATA_SIZE];
+	size_t ss_custom_size;
+	gpa_t ss_custom_addr;
 	u8 ss_level;
 	atomic_t ss_active;
 
