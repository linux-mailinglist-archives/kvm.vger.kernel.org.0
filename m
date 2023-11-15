Return-Path: <kvm+bounces-1780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 927F37EBDE1
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:22:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B1BBF1C20A88
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:22:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CF4A9467;
	Wed, 15 Nov 2023 07:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ukj0Umih"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27069455
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:22:30 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044738E
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:22:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032948; x=1731568948;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ybBU+R7YwVFf4etkP8+whEMG+SQHg3fpTZZIj3O+/F0=;
  b=Ukj0UmihepW1/umrLEUajTP3kRbrmiXSNyrwIFqYiEQhZRdC7Y969fpV
   8ARyh2aByVmQrtuNQfRQT98PP986Tk0f/LTjV5NSyHsf8tW9naohDfuzk
   jaBX1Tte2JpbouSIwbq9WhtR79erbCIhdoJp/fdUdl7b0V3lhLuIM5I7r
   ViNhlnwu48zEBr9pJRNEkUqlGscGQXjkPGuaW/V5HoT+7s5fsXgITtplz
   kW2QyU8YzxlUjUqd/qhkYsJ5X6XcOvS8v8g3eU22e1RMUg4vGwXigQt0r
   5TWCdJFzDSR3YtZpXTSt8JmLEGk57vgROr7vRQYsJM/VepzlUpP2UrXnq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390623438"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390623438"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:22:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714800244"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714800244"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:22:22 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v3 52/70] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
Date: Wed, 15 Nov 2023 02:15:01 -0500
Message-Id: <20231115071519.2864957-53-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231115071519.2864957-1-xiaoyao.li@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

For GetQuote, delegate a request to Quote Generation Service.
Add property "quote-generation-socket" to tdx-guest, whihc is a property
of type SocketAddress to specify Quote Generation Service(QGS).

On request, connect to the QGS, read request buffer from shared guest
memory, send the request buffer to the server and store the response
into shared guest memory and notify TD guest by interrupt.

command line example:
  qemu-system-x86_64 \
    -object '{"qom-type":"tdx-guest","id":"tdx0","quote-generation-socket":{"type": "vsock", "cid":"2","port":"1234"}}' \
    -machine confidential-guest-support=tdx0

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Codeveloped-by: Chenyi Qiang <chenyi.qiang@intel.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v3:
- rename property "quote-generation-service" to "quote-generation-socket";
- change the type of "quote-generation-socket" from str to
  SocketAddress;
- squash next patch into this one;
---
 qapi/qom.json         |   5 +-
 target/i386/kvm/tdx.c | 430 ++++++++++++++++++++++++++++++++++++++++++
 target/i386/kvm/tdx.h |   6 +
 3 files changed, 440 insertions(+), 1 deletion(-)

diff --git a/qapi/qom.json b/qapi/qom.json
index fd99aa1ff8cc..cf36a1832ddd 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -894,13 +894,16 @@
 #
 # @mrownerconfig: base64 MROWNERCONFIG SHA384 digest
 #
+# @quote-generation-socket: socket address for Quote Generation Service(QGS)
+#
 # Since: 8.2
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
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 5fc5d857fb6f..54b38c031fb3 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -16,6 +16,7 @@
 #include "qemu/base64.h"
 #include "qemu/mmap-alloc.h"
 #include "qapi/error.h"
+#include "qapi/qapi-visit-sockets.h"
 #include "qom/object_interfaces.h"
 #include "standard-headers/asm-x86/kvm_para.h"
 #include "sysemu/kvm.h"
@@ -23,6 +24,8 @@
 #include "exec/address-spaces.h"
 #include "exec/ramblock.h"
 
+#include "exec/address-spaces.h"
+#include "hw/i386/apic_internal.h"
 #include "hw/i386/e820_memory_layout.h"
 #include "hw/i386/x86.h"
 #include "hw/i386/tdvf.h"
@@ -923,6 +926,29 @@ static void tdx_guest_set_mrownerconfig(Object *obj, const char *value, Error **
     tdx->mrconfigid = g_strdup(value);
 }
 
+static void tdx_guest_get_quote_generation(Object *obj, Visitor *v,
+                                            const char *name, void *opaque,
+                                            Error **errp)
+{
+    TdxGuest *tdx = TDX_GUEST(obj);
+
+    visit_type_SocketAddress(v, name, &tdx->quote_generation, errp);
+}
+
+static void tdx_guest_set_quote_generation(Object *obj, Visitor *v,
+                                           const char *name, void *opaque,
+                                           Error **errp)
+{
+    TdxGuest *tdx = TDX_GUEST(obj);
+    SocketAddress *sock = NULL;
+
+    if (!visit_type_SocketAddress(v, name, &sock, errp)) {
+        return;
+    }
+
+    tdx->quote_generation = sock;
+}
+
 /* tdx guest */
 OBJECT_DEFINE_TYPE_WITH_INTERFACES(TdxGuest,
                                    tdx_guest,
@@ -957,6 +983,12 @@ static void tdx_guest_init(Object *obj)
                             tdx_guest_get_mrownerconfig,
                             tdx_guest_set_mrownerconfig);
 
+    tdx->quote_generation = NULL;
+    object_property_add(obj, "quote-generation-socket", "SocketAddress",
+                            tdx_guest_get_quote_generation,
+                            tdx_guest_set_quote_generation,
+                            NULL, NULL);
+
     tdx->event_notify_interrupt = -1;
     tdx->event_notify_apic_id = -1;
 }
@@ -969,6 +1001,7 @@ static void tdx_guest_class_init(ObjectClass *oc, void *data)
 {
 }
 
+#define TDG_VP_VMCALL_GET_QUOTE                         0x10002ULL
 #define TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT      0x10004ULL
 
 #define TDG_VP_VMCALL_SUCCESS           0x0000000000000000ULL
@@ -977,6 +1010,400 @@ static void tdx_guest_class_init(ObjectClass *oc, void *data)
 #define TDG_VP_VMCALL_GPA_INUSE         0x8000000000000001ULL
 #define TDG_VP_VMCALL_ALIGN_ERROR       0x8000000000000002ULL
 
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
+static hwaddr tdx_shared_bit(X86CPU *cpu)
+{
+    return (cpu->phys_bits > 48) ? BIT_ULL(51) : BIT_ULL(47);
+}
+
+struct tdx_get_quote_task {
+    uint32_t apic_id;
+    hwaddr gpa;
+    uint64_t buf_len;
+    char *out_data;
+    uint64_t out_len;
+    struct tdx_get_quote_header hdr;
+    int event_notify_interrupt;
+    QIOChannelSocket *ioc;
+};
+
+struct x86_msi {
+    union {
+        struct {
+            uint32_t    reserved_0              : 2,
+                        dest_mode_logical       : 1,
+                        redirect_hint           : 1,
+                        reserved_1              : 1,
+                        virt_destid_8_14        : 7,
+                        destid_0_7              : 8,
+                        base_address            : 12;
+        } QEMU_PACKED x86_address_lo;
+        uint32_t address_lo;
+    };
+    union {
+        struct {
+            uint32_t    reserved        : 8,
+                        destid_8_31     : 24;
+        } QEMU_PACKED x86_address_hi;
+        uint32_t address_hi;
+    };
+    union {
+        struct {
+            uint32_t    vector                  : 8,
+                        delivery_mode           : 3,
+                        dest_mode_logical       : 1,
+                        reserved                : 2,
+                        active_low              : 1,
+                        is_level                : 1;
+        } QEMU_PACKED x86_data;
+        uint32_t data;
+    };
+};
+
+static void tdx_td_notify(struct tdx_get_quote_task *t)
+{
+    struct x86_msi x86_msi;
+    struct kvm_msi msi;
+    int ret;
+
+    /* It is optional for host VMM to interrupt TD. */
+    if(!(32 <= t->event_notify_interrupt && t->event_notify_interrupt <= 255))
+        return;
+
+    x86_msi = (struct x86_msi) {
+        .x86_address_lo  = {
+            .reserved_0 = 0,
+            .dest_mode_logical = 0,
+            .redirect_hint = 0,
+            .reserved_1 = 0,
+            .virt_destid_8_14 = 0,
+            .destid_0_7 = t->apic_id & 0xff,
+        },
+        .x86_address_hi = {
+            .reserved = 0,
+            .destid_8_31 = t->apic_id >> 8,
+        },
+        .x86_data = {
+            .vector = t->event_notify_interrupt,
+            .delivery_mode = APIC_DM_FIXED,
+            .dest_mode_logical = 0,
+            .reserved = 0,
+            .active_low = 0,
+            .is_level = 0,
+        },
+    };
+    msi = (struct kvm_msi) {
+        .address_lo = x86_msi.address_lo,
+        .address_hi = x86_msi.address_hi,
+        .data = x86_msi.data,
+        .flags = 0,
+        .devid = 0,
+    };
+    ret = kvm_vm_ioctl(kvm_state, KVM_SIGNAL_MSI, &msi);
+    if (ret < 0) {
+        /* In this case, no better way to tell it to guest.  Log it. */
+        error_report("TDX: injection %d failed, interrupt lost (%s).\n",
+                     t->event_notify_interrupt, strerror(-ret));
+    }
+}
+
+static void tdx_get_quote_read(void *opaque)
+{
+    struct tdx_get_quote_task *t = opaque;
+    ssize_t size = 0;
+    Error *err = NULL;
+    MachineState *ms;
+    TdxGuest *tdx;
+
+    while (true) {
+        char *buf;
+        size_t buf_size;
+
+        if (t->out_len < t->buf_len) {
+            buf = t->out_data + t->out_len;
+            buf_size = t->buf_len - t->out_len;
+        } else {
+            /*
+             * The received data is too large to fit in the shared GPA.
+             * Discard the received data and try to know the data size.
+             */
+            buf = t->out_data;
+            buf_size = t->buf_len;
+        }
+
+        size = qio_channel_read(QIO_CHANNEL(t->ioc), buf, buf_size, &err);
+        if (!size) {
+            break;
+        }
+
+        if (size < 0) {
+            if (size == QIO_CHANNEL_ERR_BLOCK) {
+                return;
+            } else {
+                break;
+            }
+        }
+        t->out_len += size;
+    }
+    /*
+     * If partial read successfully but return error at last, also treat it
+     * as failure.
+     */
+    if (size < 0) {
+        t->hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_QGS_UNAVAILABLE);
+        goto error;
+    }
+    if (t->out_len > 0 && t->out_len > t->buf_len) {
+        /*
+         * There is no specific error code defined for this case(E2BIG) at the
+         * moment.
+         * TODO: Once an error code for this case is defined in GHCI spec ,
+         * update the error code.
+         */
+        t->hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_ERROR);
+        t->hdr.out_len = cpu_to_le32(t->out_len);
+        goto error_hdr;
+    }
+
+    if (address_space_write(
+            &address_space_memory, t->gpa + sizeof(t->hdr),
+            MEMTXATTRS_UNSPECIFIED, t->out_data, t->out_len) != MEMTX_OK) {
+        goto error;
+    }
+    /*
+     * Even if out_len == 0, it's a success.  It's up to the QGS-client contract
+     * how to interpret the zero-sized message as return message.
+     */
+    t->hdr.out_len = cpu_to_le32(t->out_len);
+    t->hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_SUCCESS);
+
+error:
+    if (t->hdr.error_code != cpu_to_le64(TDX_VP_GET_QUOTE_SUCCESS)) {
+        t->hdr.out_len = cpu_to_le32(0);
+    }
+error_hdr:
+    if (address_space_write(
+            &address_space_memory, t->gpa,
+            MEMTXATTRS_UNSPECIFIED, &t->hdr, sizeof(t->hdr)) != MEMTX_OK) {
+        error_report("TDX: failed to update GetQuote header.");
+    }
+    tdx_td_notify(t);
+
+    qemu_set_fd_handler(t->ioc->fd, NULL, NULL, NULL);
+    qio_channel_close(QIO_CHANNEL(t->ioc), &err);
+    object_unref(OBJECT(t->ioc));
+    g_free(t->out_data);
+    g_free(t);
+
+    /* Maintain the number of in-flight requests. */
+    ms = MACHINE(qdev_get_machine());
+    tdx = TDX_GUEST(ms->cgs);
+    qemu_mutex_lock(&tdx->lock);
+    tdx->quote_generation_num--;
+    qemu_mutex_unlock(&tdx->lock);
+}
+
+/*
+ * TODO: If QGS doesn't reply for long time, make it an error and interrupt
+ * guest.
+ */
+static void tdx_handle_get_quote_connected(QIOTask *task, gpointer opaque)
+{
+    struct tdx_get_quote_task *t = opaque;
+    Error *err = NULL;
+    char *in_data = NULL;
+    MachineState *ms;
+    TdxGuest *tdx;
+
+    t->hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_ERROR);
+    if (qio_task_propagate_error(task, NULL)) {
+        t->hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_QGS_UNAVAILABLE);
+        goto error;
+    }
+
+    in_data = g_malloc(le32_to_cpu(t->hdr.in_len));
+    if (!in_data) {
+        goto error;
+    }
+
+    if (address_space_read(&address_space_memory, t->gpa + sizeof(t->hdr),
+                           MEMTXATTRS_UNSPECIFIED, in_data,
+                           le32_to_cpu(t->hdr.in_len)) != MEMTX_OK) {
+        goto error;
+    }
+
+    qio_channel_set_blocking(QIO_CHANNEL(t->ioc), false, NULL);
+
+    if (qio_channel_write_all(QIO_CHANNEL(t->ioc), in_data,
+                              le32_to_cpu(t->hdr.in_len), &err) ||
+        err) {
+        t->hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_QGS_UNAVAILABLE);
+        goto error;
+    }
+
+    g_free(in_data);
+    qemu_set_fd_handler(t->ioc->fd, tdx_get_quote_read, NULL, t);
+
+    return;
+error:
+    t->hdr.out_len = cpu_to_le32(0);
+
+    if (address_space_write(
+            &address_space_memory, t->gpa,
+            MEMTXATTRS_UNSPECIFIED, &t->hdr, sizeof(t->hdr)) != MEMTX_OK) {
+        error_report("TDX: failed to update GetQuote header.\n");
+    }
+    tdx_td_notify(t);
+
+    qio_channel_close(QIO_CHANNEL(t->ioc), &err);
+    object_unref(OBJECT(t->ioc));
+    g_free(t);
+    g_free(in_data);
+
+    /* Maintain the number of in-flight requests. */
+    ms = MACHINE(qdev_get_machine());
+    tdx = TDX_GUEST(ms->cgs);
+    qemu_mutex_lock(&tdx->lock);
+    tdx->quote_generation_num--;
+    qemu_mutex_unlock(&tdx->lock);
+    return;
+}
+
+static void tdx_handle_get_quote(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
+{
+    hwaddr gpa = vmcall->in_r12;
+    uint64_t buf_len = vmcall->in_r13;
+    struct tdx_get_quote_header hdr;
+    MachineState *ms;
+    TdxGuest *tdx;
+    QIOChannelSocket *ioc;
+    struct tdx_get_quote_task *t;
+
+    vmcall->status_code = TDG_VP_VMCALL_INVALID_OPERAND;
+
+    /* GPA must be shared. */
+    if (!(gpa & tdx_shared_bit(cpu))) {
+        return;
+    }
+    gpa &= ~tdx_shared_bit(cpu);
+
+    if (!QEMU_IS_ALIGNED(gpa, 4096) || !QEMU_IS_ALIGNED(buf_len, 4096)) {
+        vmcall->status_code = TDG_VP_VMCALL_ALIGN_ERROR;
+        return;
+    }
+    if (buf_len == 0) {
+        return;
+    }
+
+    if (address_space_read(&address_space_memory, gpa, MEMTXATTRS_UNSPECIFIED,
+                           &hdr, sizeof(hdr)) != MEMTX_OK) {
+        return;
+    }
+    if (le64_to_cpu(hdr.structure_version) != TDX_GET_QUOTE_STRUCTURE_VERSION) {
+        return;
+    }
+    /*
+     * Paranoid: Guest should clear error_code and out_len to avoid information
+     * leak.  Enforce it.  The initial value of them doesn't matter for qemu to
+     * process the request.
+     */
+    if (le64_to_cpu(hdr.error_code) != TDX_VP_GET_QUOTE_SUCCESS ||
+        le32_to_cpu(hdr.out_len) != 0) {
+        return;
+    }
+
+    /* Only safe-guard check to avoid too large buffer size. */
+    if (buf_len > TDX_GET_QUOTE_MAX_BUF_LEN ||
+        le32_to_cpu(hdr.in_len) > TDX_GET_QUOTE_MAX_BUF_LEN ||
+        le32_to_cpu(hdr.in_len) > buf_len) {
+        return;
+    }
+
+    /* Mark the buffer in-flight. */
+    hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_IN_FLIGHT);
+    if (address_space_write(&address_space_memory, gpa, MEMTXATTRS_UNSPECIFIED,
+                            &hdr, sizeof(hdr)) != MEMTX_OK) {
+        return;
+    }
+
+    ms = MACHINE(qdev_get_machine());
+    tdx = TDX_GUEST(ms->cgs);
+    ioc = qio_channel_socket_new();
+
+    t = g_malloc(sizeof(*t));
+    t->apic_id = tdx->event_notify_apic_id;
+    t->gpa = gpa;
+    t->buf_len = buf_len;
+    t->out_data = g_malloc(t->buf_len);
+    t->out_len = 0;
+    t->hdr = hdr;
+    t->ioc = ioc;
+
+    qemu_mutex_lock(&tdx->lock);
+    if (!tdx->quote_generation ||
+        /* Prevent too many in-flight get-quote request. */
+        tdx->quote_generation_num >= TDX_MAX_GET_QUOTE_REQUEST) {
+        qemu_mutex_unlock(&tdx->lock);
+        vmcall->status_code = TDG_VP_VMCALL_RETRY;
+        object_unref(OBJECT(ioc));
+        g_free(t->out_data);
+        g_free(t);
+        return;
+    }
+    tdx->quote_generation_num++;
+    t->event_notify_interrupt = tdx->event_notify_interrupt;
+    qio_channel_socket_connect_async(
+        ioc, tdx->quote_generation, tdx_handle_get_quote_connected, t, NULL,
+        NULL);
+    qemu_mutex_unlock(&tdx->lock);
+
+    vmcall->status_code = TDG_VP_VMCALL_SUCCESS;
+}
+
 static void tdx_handle_setup_event_notify_interrupt(X86CPU *cpu,
                                                     struct kvm_tdx_vmcall *vmcall)
 {
@@ -1005,6 +1432,9 @@ static void tdx_handle_vmcall(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
     }
 
     switch (vmcall->subfunction) {
+    case TDG_VP_VMCALL_GET_QUOTE:
+        tdx_handle_get_quote(cpu, vmcall);
+        break;
     case TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT:
         tdx_handle_setup_event_notify_interrupt(cpu, vmcall);
         break;
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index 4a8d67cc9fdb..4a989805493e 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -5,8 +5,10 @@
 #include CONFIG_DEVICES /* CONFIG_TDX */
 #endif
 
+#include <linux/kvm.h>
 #include "exec/confidential-guest-support.h"
 #include "hw/i386/tdvf.h"
+#include "io/channel-socket.h"
 #include "sysemu/kvm.h"
 
 #define TYPE_TDX_GUEST "tdx-guest"
@@ -47,6 +49,10 @@ typedef struct TdxGuest {
     /* runtime state */
     int event_notify_interrupt;
     uint32_t event_notify_apic_id;
+
+    /* GetQuote */
+    int quote_generation_num;
+    SocketAddress *quote_generation;
 } TdxGuest;
 
 #ifdef CONFIG_TDX
-- 
2.34.1


