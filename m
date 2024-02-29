Return-Path: <kvm+bounces-10405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CACDC86C118
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:44:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 812AC28286B
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 977A644C9C;
	Thu, 29 Feb 2024 06:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BrInTwyY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD41C44C7A
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188979; cv=none; b=WwPCQQGoHA5OOI1eveJPo5b4zHZLfjmsNJf3HbKjd5ogEKeKPQ1rrMIsCxzn8XGIXnxmkOkqKJm8Npf1iS4R7GCHxXceYmChdjCm3y+fSt/VSFcjyUYsA0++fyWjThz8oVQihkr0o8qCBM71s4foizBGlc+XLDL35kDeHo35aMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188979; c=relaxed/simple;
	bh=ir5qCBVNzMjM9W4/ONMYBB+Cj7Gw0bPUNrXMYuCYFUk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gE8w+NP6bRHl6F/sZLk/8JKkizZSpSBTraJ4ChI6e9wt6xetUBQZwzZHzQCEwvF6uiuevW2dF5P6+8tj4/dCqnVHVuy3MAi6PKsodB8OnBXN9bKAzB9EtYcOjH7aP7tx9NoiwHP4qqnmmD0TdJysYORQNHFH7xoiFKkCNDQ05eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BrInTwyY; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709188977; x=1740724977;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ir5qCBVNzMjM9W4/ONMYBB+Cj7Gw0bPUNrXMYuCYFUk=;
  b=BrInTwyYrAA/ZOTQs7L1/mD+RVFcM19yvDOKHxkvTy/8PaG92u/JWBfl
   ZzExoR07y328Hu1TBpsHEmslDrnyZt5zj7yjFDU41iYjgE+gWIPb9K3fR
   ADab782sVrPfkgdio90toKffbaGDxulVUZihcMA3KAEU4X7Sxf84Cv34y
   /ZZiYWFymZx6tKxxrCKJAqlLgbV2oWSCxhkgIGRxDmNxfzBegv1o3qvIt
   IUh6RfZgfGPsuJlmobpePXJlhPE0eIfW4vtPcwp3R1g3IGmmnr2JNfC9U
   gnISWziCyKa94nl0s/Y/HVnkJKq03JOBbqHY3F3QTdl1+EGN2AoN2ijkn
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3803107"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3803107"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:42:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8076098"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:42:50 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Michael Roth <michael.roth@amd.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	xiaoyao.li@intel.com
Subject: [PATCH v5 49/65] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
Date: Thu, 29 Feb 2024 01:37:10 -0500
Message-Id: <20240229063726.610065-50-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240229063726.610065-1-xiaoyao.li@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add property "quote-generation-socket" to tdx-guest, which is a property
of type SocketAddress to specify Quote Generation Service(QGS).

On request of GetQuote, it connects to the QGS socket, read request
data from shared guest memory, send the request data to the QGS,
and store the response into shared guest memory, at last notify
TD guest by interrupt.

command line example:
  qemu-system-x86_64 \
    -object '{"qom-type":"tdx-guest","id":"tdx0","quote-generation-socket":{"type": "vsock", "cid":"1","port":"1234"}}' \
    -machine confidential-guest-support=tdx0

Note, above example uses vsock type socket because the QGS we used
implements the vsock socket. It can be other types, like UNIX socket,
which depends on the implementation of QGS.

To avoid no response from QGS server, setup a timer for the transaction.
If timeout, make it an error and interrupt guest. Define the threshold of
time to 30s at present, maybe change to other value if not appropriate.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Codeveloped-by: Chenyi Qiang <chenyi.qiang@intel.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
Codeveloped-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v5:
- add more decription of quote-generation-socket property;

Changes in v4:
- merge next patch "i386/tdx: setup a timer for the qio channel";

Changes in v3:
- rename property "quote-generation-service" to "quote-generation-socket";
- change the type of "quote-generation-socket" from str to
  SocketAddress;
- squash next patch into this one;
---
 qapi/qom.json                         |   8 +-
 target/i386/kvm/meson.build           |   2 +-
 target/i386/kvm/tdx-quote-generator.c | 170 ++++++++++++++++++++
 target/i386/kvm/tdx-quote-generator.h |  95 +++++++++++
 target/i386/kvm/tdx.c                 | 216 ++++++++++++++++++++++++++
 target/i386/kvm/tdx.h                 |   6 +
 6 files changed, 495 insertions(+), 2 deletions(-)
 create mode 100644 target/i386/kvm/tdx-quote-generator.c
 create mode 100644 target/i386/kvm/tdx-quote-generator.h

diff --git a/qapi/qom.json b/qapi/qom.json
index cac875349a3a..7b26b0a0d3aa 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -917,13 +917,19 @@
 #     (base64 encoded SHA384 digest). (A default value 0 of SHA384 is
 #     used when absent).
 #
+# @quote-generation-socket: socket address for Quote Generation
+#     Service (QGS).  QGS is a daemon running on the host.  User in
+#     TD guest cannot get TD quoting for attestation if QGS is not
+#     provided.  So admin should always provide it.
+#
 # Since: 9.0
 ##
 { 'struct': 'TdxGuestProperties',
   'data': { '*sept-ve-disable': 'bool',
             '*mrconfigid': 'str',
             '*mrowner': 'str',
-            '*mrownerconfig': 'str' } }
+            '*mrownerconfig': 'str',
+            '*quote-generation-socket': 'SocketAddress' } }
 
 ##
 # @ThreadContextProperties:
diff --git a/target/i386/kvm/meson.build b/target/i386/kvm/meson.build
index 460c5f8f85f3..d38b8e8e5fca 100644
--- a/target/i386/kvm/meson.build
+++ b/target/i386/kvm/meson.build
@@ -7,7 +7,7 @@ i386_kvm_ss.add(files(
 
 i386_kvm_ss.add(when: 'CONFIG_XEN_EMU', if_true: files('xen-emu.c'))
 
-i386_kvm_ss.add(when: 'CONFIG_TDX', if_true: files('tdx.c'), if_false: files('tdx-stub.c'))
+i386_kvm_ss.add(when: 'CONFIG_TDX', if_true: files('tdx.c', 'tdx-quote-generator.c'), if_false: files('tdx-stub.c'))
 
 i386_system_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'), if_false: files('hyperv-stub.c'))
 
diff --git a/target/i386/kvm/tdx-quote-generator.c b/target/i386/kvm/tdx-quote-generator.c
new file mode 100644
index 000000000000..057ad09e7e95
--- /dev/null
+++ b/target/i386/kvm/tdx-quote-generator.c
@@ -0,0 +1,170 @@
+/*
+ * QEMU TDX support
+ *
+ * Copyright Intel
+ *
+ * Author:
+ *      Xiaoyao Li <xiaoyao.li@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or later.
+ * See the COPYING file in the top-level directory
+ *
+ */
+
+#include "qemu/osdep.h"
+#include "qemu/error-report.h"
+#include "qapi/error.h"
+#include "qapi/qapi-visit-sockets.h"
+
+#include "tdx-quote-generator.h"
+
+typedef struct TdxQuoteGeneratorClass {
+    DeviceClass parent_class;
+} TdxQuoteGeneratorClass;
+
+OBJECT_DEFINE_TYPE(TdxQuoteGenerator, tdx_quote_generator, TDX_QUOTE_GENERATOR, OBJECT)
+
+static void tdx_quote_generator_finalize(Object *obj)
+{
+}
+
+static void tdx_quote_generator_class_init(ObjectClass *oc, void *data)
+{
+}
+
+static void tdx_quote_generator_init(Object *obj)
+{
+}
+
+static void tdx_generate_quote_cleanup(struct tdx_generate_quote_task *task)
+{
+    timer_del(&task->timer);
+
+    g_source_remove(task->watch);
+    qio_channel_close(QIO_CHANNEL(task->sioc), NULL);
+    object_unref(OBJECT(task->sioc));
+
+    /* Maintain the number of in-flight requests. */
+    qemu_mutex_lock(&task->quote_gen->lock);
+    task->quote_gen->num--;
+    qemu_mutex_unlock(&task->quote_gen->lock);
+
+    task->completion(task);
+}
+
+static gboolean tdx_get_quote_read(QIOChannel *ioc, GIOCondition condition,
+                                   gpointer opaque)
+{
+    struct tdx_generate_quote_task *task = opaque;
+    Error *err = NULL;
+    int ret;
+
+    ret = qio_channel_read(ioc, task->receive_buf + task->receive_buf_received,
+                           task->payload_len - task->receive_buf_received, &err);
+    if (ret < 0) {
+        if (ret ==  QIO_CHANNEL_ERR_BLOCK) {
+            return G_SOURCE_CONTINUE;
+        } else {
+            error_report_err(err);
+            task->status_code = TDX_VP_GET_QUOTE_ERROR;
+            goto end;
+        }
+    }
+
+    task->receive_buf_received += ret;
+    if (ret == 0 || task->receive_buf_received == task->payload_len) {
+        task->status_code = TDX_VP_GET_QUOTE_SUCCESS;
+        goto end;
+    }
+
+    return G_SOURCE_CONTINUE;
+
+end:
+    tdx_generate_quote_cleanup(task);
+    return G_SOURCE_REMOVE;
+}
+
+static gboolean tdx_send_report(QIOChannel *ioc, GIOCondition condition,
+                                gpointer opaque)
+{
+    struct tdx_generate_quote_task *task = opaque;
+    Error *err = NULL;
+    int ret;
+
+    ret = qio_channel_write(ioc, task->send_data + task->send_data_sent,
+                            task->send_data_size - task->send_data_sent, &err);
+    if (ret < 0) {
+        if (ret == QIO_CHANNEL_ERR_BLOCK) {
+            ret = 0;
+        } else {
+            error_report_err(err);
+            task->status_code = TDX_VP_GET_QUOTE_ERROR;
+            tdx_generate_quote_cleanup(task);
+            goto end;
+        }
+    }
+    task->send_data_sent += ret;
+
+    if (task->send_data_sent == task->send_data_size) {
+        task->watch = qio_channel_add_watch(QIO_CHANNEL(task->sioc), G_IO_IN,
+                                            tdx_get_quote_read, task, NULL);
+        goto end;
+    }
+
+    return G_SOURCE_CONTINUE;
+
+end:
+    return G_SOURCE_REMOVE;
+}
+
+static void tdx_quote_generator_connected(QIOTask *qio_task, gpointer opaque)
+{
+    struct tdx_generate_quote_task *task = opaque;
+    Error *err = NULL;
+    int ret;
+
+    ret = qio_task_propagate_error(qio_task, &err);
+    if (ret) {
+        error_report_err(err);
+        task->status_code = TDX_VP_GET_QUOTE_QGS_UNAVAILABLE;
+        tdx_generate_quote_cleanup(task);
+        return;
+    }
+
+    task->watch = qio_channel_add_watch(QIO_CHANNEL(task->sioc), G_IO_OUT,
+                                        tdx_send_report, task, NULL);
+}
+
+#define TRANSACTION_TIMEOUT 30000
+
+static void getquote_expired(void *opaque)
+{
+    struct tdx_generate_quote_task *task = opaque;
+
+    task->status_code = TDX_VP_GET_QUOTE_ERROR;
+    tdx_generate_quote_cleanup(task);
+}
+
+static void setup_get_quote_timer(struct tdx_generate_quote_task *task)
+{
+    int64_t time;
+
+    timer_init_ms(&task->timer, QEMU_CLOCK_VIRTUAL, getquote_expired, task);
+    time = qemu_clock_get_ms(QEMU_CLOCK_VIRTUAL);
+    timer_mod(&task->timer, time + TRANSACTION_TIMEOUT);
+}
+
+void tdx_generate_quote(struct tdx_generate_quote_task *task)
+{
+    struct TdxQuoteGenerator *quote_gen = task->quote_gen;
+    QIOChannelSocket *sioc;
+
+    sioc = qio_channel_socket_new();
+    task->sioc = sioc;
+
+    setup_get_quote_timer(task);
+
+    qio_channel_socket_connect_async(sioc, quote_gen->socket,
+                                     tdx_quote_generator_connected, task,
+                                     NULL, NULL);
+}
diff --git a/target/i386/kvm/tdx-quote-generator.h b/target/i386/kvm/tdx-quote-generator.h
new file mode 100644
index 000000000000..54899d44aa6f
--- /dev/null
+++ b/target/i386/kvm/tdx-quote-generator.h
@@ -0,0 +1,95 @@
+#ifndef QEMU_I386_TDX_QUOTE_GENERATOR_H
+#define QEMU_I386_TDX_QUOTE_GENERATOR_H
+
+#include "qom/object_interfaces.h"
+#include "io/channel-socket.h"
+#include "exec/hwaddr.h"
+
+/* tdx quote generation */
+struct TdxQuoteGenerator {
+    Object parent_obj;
+
+    int num;
+    SocketAddress *socket;
+
+    QemuMutex lock;
+};
+
+#define TYPE_TDX_QUOTE_GENERATOR "tdx-quote-generator"
+
+OBJECT_DECLARE_SIMPLE_TYPE(TdxQuoteGenerator, TDX_QUOTE_GENERATOR)
+
+
+#define TDX_GET_QUOTE_STRUCTURE_VERSION 1ULL
+
+#define TDX_VP_GET_QUOTE_SUCCESS                0ULL
+#define TDX_VP_GET_QUOTE_IN_FLIGHT              (-1ULL)
+#define TDX_VP_GET_QUOTE_ERROR                  0x8000000000000000ULL
+#define TDX_VP_GET_QUOTE_QGS_UNAVAILABLE        0x8000000000000001ULL
+
+/* Limit to avoid resource starvation. */
+#define TDX_GET_QUOTE_MAX_BUF_LEN       (128 * 1024)
+#define TDX_MAX_GET_QUOTE_REQUEST       16
+
+#define TDX_GET_QUOTE_HDR_SIZE          24
+
+/* Format of pages shared with guest. */
+struct tdx_get_quote_header {
+    /* Format version: must be 1 in little endian. */
+    uint64_t structure_version;
+
+    /*
+     * GetQuote status code in little endian:
+     *   Guest must set error_code to 0 to avoid information leak.
+     *   Qemu sets this before interrupting guest.
+     */
+    uint64_t error_code;
+
+    /*
+     * in-message size in little endian: The message will follow this header.
+     * The in-message will be send to QGS.
+     */
+    uint32_t in_len;
+
+    /*
+     * out-message size in little endian:
+     * On request, out_len must be zero to avoid information leak.
+     * On return, message size from QGS. Qemu overwrites this field.
+     * The message will follows this header.  The in-message is overwritten.
+     */
+    uint32_t out_len;
+
+    /*
+     * Message buffer follows.
+     * Guest sets message that will be send to QGS.  If out_len > in_len, guest
+     * should zero remaining buffer to avoid information leak.
+     * Qemu overwrites this buffer with a message returned from QGS.
+     */
+};
+
+struct tdx_generate_quote_task {
+    hwaddr buf_gpa;
+    hwaddr payload_gpa;
+    uint64_t payload_len;
+
+    char *send_data;
+    uint64_t send_data_size;
+    uint64_t send_data_sent;
+
+    char *receive_buf;
+    uint64_t receive_buf_received;
+
+    uint64_t status_code;
+    struct tdx_get_quote_header hdr;
+
+    QIOChannelSocket *sioc;
+    guint watch;
+    QEMUTimer timer;
+    struct TdxQuoteGenerator *quote_gen;
+
+    void (*completion)(struct tdx_generate_quote_task *task);
+};
+
+void tdx_generate_quote(struct tdx_generate_quote_task *task);
+
+#endif /* QEMU_I386_TDX_QUOTE_GENERATOR_H */
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 49f94d9d46f4..7dfda507cc8c 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -16,18 +16,23 @@
 #include "qemu/base64.h"
 #include "qemu/mmap-alloc.h"
 #include "qapi/error.h"
+#include "qapi/qapi-visit-sockets.h"
 #include "qom/object_interfaces.h"
 #include "standard-headers/asm-x86/kvm_para.h"
 #include "sysemu/kvm.h"
 #include "sysemu/sysemu.h"
 #include "exec/ramblock.h"
 
+#include "hw/i386/apic_internal.h"
+#include "hw/i386/apic-msidef.h"
 #include "hw/i386/e820_memory_layout.h"
 #include "hw/i386/x86.h"
 #include "hw/i386/tdvf.h"
 #include "hw/i386/tdvf-hob.h"
+#include "hw/pci/msi.h"
 #include "kvm_i386.h"
 #include "tdx.h"
+#include "tdx-quote-generator.h"
 #include "../cpu-internal.h"
 
 #define TDX_SUPPORTED_KVM_FEATURES  ((1U << KVM_FEATURE_NOP_IO_DELAY) | \
@@ -866,6 +871,175 @@ int tdx_parse_tdvf(void *flash_ptr, int size)
     return tdvf_parse_metadata(&tdx_guest->tdvf, flash_ptr, size);
 }
 
+static void tdx_inject_interrupt(uint32_t apicid, uint32_t vector)
+{
+    int ret;
+
+    if (vector < 32 || vector > 255) {
+        return;
+    }
+
+    MSIMessage msg = {
+        .address = ((apicid & 0xff) << MSI_ADDR_DEST_ID_SHIFT) |
+                   (((uint64_t)apicid & 0xffffff00) << 32),
+        .data = vector | (APIC_DM_FIXED << MSI_DATA_DELIVERY_MODE_SHIFT),
+    };
+
+    ret = kvm_irqchip_send_msi(kvm_state, msg);
+    if (ret < 0) {
+        /* In this case, no better way to tell it to guest.  Log it. */
+        error_report("TDX: injection %d failed, interrupt lost (%s).\n",
+                     vector, strerror(-ret));
+    }
+}
+
+static hwaddr tdx_shared_bit(X86CPU *cpu)
+{
+    return (cpu->phys_bits > 48) ? BIT_ULL(51) : BIT_ULL(47);
+}
+
+static void tdx_get_quote_completion(struct tdx_generate_quote_task *task)
+{
+    int ret;
+
+    if (task->status_code == TDX_VP_GET_QUOTE_SUCCESS) {
+        ret = address_space_write(&address_space_memory, task->payload_gpa,
+                                  MEMTXATTRS_UNSPECIFIED, task->receive_buf,
+                                  task->receive_buf_received);
+        if (ret != MEMTX_OK) {
+            error_report("TDX: get-quote: failed to write quote data.\n");
+        } else {
+            task->hdr.out_len = cpu_to_le64(task->receive_buf_received);
+        }
+    }
+    task->hdr.error_code = cpu_to_le32(task->status_code);
+
+    /* Publish the response contents before marking this request completed. */
+    smp_wmb();
+    ret = address_space_write(&address_space_memory, task->buf_gpa,
+                              MEMTXATTRS_UNSPECIFIED, &task->hdr,
+                              TDX_GET_QUOTE_HDR_SIZE);
+    if (ret != MEMTX_OK) {
+        error_report("TDX: get-quote: failed to update GetQuote header.");
+    }
+
+    tdx_inject_interrupt(tdx_guest->event_notify_apicid,
+                         tdx_guest->event_notify_vector);
+
+    g_free(task->send_data);
+    g_free(task->receive_buf);
+    g_free(task);
+}
+
+static int tdx_handle_get_quote(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
+{
+    struct tdx_generate_quote_task *task;
+    struct tdx_get_quote_header hdr;
+    hwaddr buf_gpa = vmcall->in_r12;
+    uint64_t buf_len = vmcall->in_r13;
+
+    QEMU_BUILD_BUG_ON(sizeof(struct tdx_get_quote_header) != TDX_GET_QUOTE_HDR_SIZE);
+
+    vmcall->status_code = TDG_VP_VMCALL_INVALID_OPERAND;
+
+    if (buf_len == 0) {
+        return 0;
+    }
+
+    /* GPA must be shared. */
+    if (!(buf_gpa & tdx_shared_bit(cpu))) {
+        return 0;
+    }
+    buf_gpa &= ~tdx_shared_bit(cpu);
+
+    if (!QEMU_IS_ALIGNED(buf_gpa, 4096) || !QEMU_IS_ALIGNED(buf_len, 4096)) {
+        vmcall->status_code = TDG_VP_VMCALL_ALIGN_ERROR;
+        return 0;
+    }
+
+    if (address_space_read(&address_space_memory, buf_gpa, MEMTXATTRS_UNSPECIFIED,
+                           &hdr, TDX_GET_QUOTE_HDR_SIZE) != MEMTX_OK) {
+        error_report("TDX: get-quote: failed to read GetQuote header.\n");
+        return -1;
+    }
+
+    if (le64_to_cpu(hdr.structure_version) != TDX_GET_QUOTE_STRUCTURE_VERSION) {
+        return 0;
+    }
+
+    /*
+     * Paranoid: Guest should clear error_code and out_len to avoid information
+     * leak.  Enforce it.  The initial value of them doesn't matter for qemu to
+     * process the request.
+     */
+    if (le64_to_cpu(hdr.error_code) != TDX_VP_GET_QUOTE_SUCCESS ||
+        le32_to_cpu(hdr.out_len) != 0) {
+        return 0;
+    }
+
+    /* Only safe-guard check to avoid too large buffer size. */
+    if (buf_len > TDX_GET_QUOTE_MAX_BUF_LEN ||
+        le32_to_cpu(hdr.in_len) > buf_len - TDX_GET_QUOTE_HDR_SIZE) {
+        return 0;
+    }
+
+    vmcall->status_code = TDG_VP_VMCALL_SUCCESS;
+    if (!tdx_guest->quote_generator) {
+        hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_QGS_UNAVAILABLE);
+        if (address_space_write(&address_space_memory, buf_gpa,
+                                MEMTXATTRS_UNSPECIFIED,
+                                &hdr, TDX_GET_QUOTE_HDR_SIZE) != MEMTX_OK) {
+            error_report("TDX: failed to update GetQuote header.\n");
+            return -1;
+        }
+        return 0;
+    }
+
+    qemu_mutex_lock(&tdx_guest->quote_generator->lock);
+    if (tdx_guest->quote_generator->num >= TDX_MAX_GET_QUOTE_REQUEST) {
+        qemu_mutex_unlock(&tdx_guest->quote_generator->lock);
+        vmcall->status_code = TDG_VP_VMCALL_RETRY;
+        return 0;
+    }
+    tdx_guest->quote_generator->num++;
+    qemu_mutex_unlock(&tdx_guest->quote_generator->lock);
+
+    /* Mark the buffer in-flight. */
+    hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_IN_FLIGHT);
+    if (address_space_write(&address_space_memory, buf_gpa,
+                            MEMTXATTRS_UNSPECIFIED,
+                            &hdr, TDX_GET_QUOTE_HDR_SIZE) != MEMTX_OK) {
+        error_report("TDX: failed to update GetQuote header.\n");
+        return -1;
+    }
+
+    task = g_malloc(sizeof(*task));
+    task->buf_gpa = buf_gpa;
+    task->payload_gpa = buf_gpa + TDX_GET_QUOTE_HDR_SIZE;
+    task->payload_len = buf_len - TDX_GET_QUOTE_HDR_SIZE;
+    task->hdr = hdr;
+    task->quote_gen = tdx_guest->quote_generator;
+    task->completion = tdx_get_quote_completion;
+
+    task->send_data_size = le32_to_cpu(hdr.in_len);
+    task->send_data = g_malloc(task->send_data_size);
+    task->send_data_sent = 0;
+
+    if (address_space_read(&address_space_memory, task->payload_gpa,
+                           MEMTXATTRS_UNSPECIFIED, task->send_data,
+                           task->send_data_size) != MEMTX_OK) {
+        g_free(task->send_data);
+        return -1;
+    }
+
+    task->receive_buf = g_malloc0(task->payload_len);
+    task->receive_buf_received = 0;
+
+    tdx_generate_quote(task);
+
+    return 0;
+}
+
 static int tdx_handle_setup_event_notify_interrupt(X86CPU *cpu,
                                                    struct kvm_tdx_vmcall *vmcall)
 {
@@ -896,6 +1070,8 @@ static int tdx_handle_vmcall(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
     }
 
     switch (vmcall->subfunction) {
+    case TDG_VP_VMCALL_GET_QUOTE:
+        return tdx_handle_get_quote(cpu, vmcall);
     case TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT:
         return tdx_handle_setup_event_notify_interrupt(cpu, vmcall);
     default:
@@ -979,6 +1155,40 @@ static void tdx_guest_set_mrownerconfig(Object *obj, const char *value, Error **
     tdx->mrownerconfig = g_strdup(value);
 }
 
+static void tdx_guest_get_quote_generation(Object *obj, Visitor *v,
+                                            const char *name, void *opaque,
+                                            Error **errp)
+{
+    TdxGuest *tdx = TDX_GUEST(obj);
+
+    visit_type_SocketAddress(v, name, &tdx->quote_generator->socket, errp);
+}
+
+static void tdx_guest_set_quote_generation(Object *obj, Visitor *v,
+                                           const char *name, void *opaque,
+                                           Error **errp)
+{
+    TdxGuest *tdx = TDX_GUEST(obj);
+    SocketAddress *sock = NULL;
+    Object *qg_obj;
+    TdxQuoteGenerator *quote_generator;
+
+    if (!visit_type_SocketAddress(v, name, &sock, errp)) {
+        return;
+    }
+
+    if (tdx->quote_generator) {
+        object_unref(tdx->quote_generator);
+    }
+
+    qg_obj = object_new(TYPE_TDX_QUOTE_GENERATOR);
+    quote_generator = TDX_QUOTE_GENERATOR(qg_obj);
+    quote_generator->socket = sock;
+    qemu_mutex_init(&quote_generator->lock);
+
+    tdx->quote_generator = quote_generator;
+}
+
 /* tdx guest */
 OBJECT_DEFINE_TYPE_WITH_INTERFACES(TdxGuest,
                                    tdx_guest,
@@ -1007,6 +1217,12 @@ static void tdx_guest_init(Object *obj)
                             tdx_guest_get_mrownerconfig,
                             tdx_guest_set_mrownerconfig);
 
+    tdx->quote_generator = NULL;
+    object_property_add(obj, "quote-generation-socket", "SocketAddress",
+                            tdx_guest_get_quote_generation,
+                            tdx_guest_set_quote_generation,
+                            NULL, NULL);
+
     tdx->event_notify_vector = -1;
     tdx->event_notify_apicid = -1;
 }
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index b3d4462fe718..b7ce793d6037 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -9,6 +9,8 @@
 #include "hw/i386/tdvf.h"
 #include "sysemu/kvm.h"
 
+#include "tdx-quote-generator.h"
+
 #define TYPE_TDX_GUEST "tdx-guest"
 #define TDX_GUEST(obj)  OBJECT_CHECK(TdxGuest, (obj), TYPE_TDX_GUEST)
 
@@ -16,6 +18,7 @@ typedef struct TdxGuestClass {
     ConfidentialGuestSupportClass parent_class;
 } TdxGuestClass;
 
+#define TDG_VP_VMCALL_GET_QUOTE                         0x10002ULL
 #define TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT      0x10004ULL
 
 #define TDG_VP_VMCALL_SUCCESS           0x0000000000000000ULL
@@ -55,6 +58,9 @@ typedef struct TdxGuest {
     /* runtime state */
     uint32_t event_notify_vector;
     uint32_t event_notify_apicid;
+
+    /* GetQuote */
+    TdxQuoteGenerator *quote_generator;
 } TdxGuest;
 
 #ifdef CONFIG_TDX
-- 
2.34.1


