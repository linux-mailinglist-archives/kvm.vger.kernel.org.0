Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5704D9DEC
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 15:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349385AbiCOOnW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 10:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348996AbiCOOnT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 10:43:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3FC375576C
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 07:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647355324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=66PttAMaDePnZpAaERjhmXYLkWYyqtV8i1H4LCrJWaI=;
        b=Nl4/wJQ+eWwchXxbTkJRnZD4Fsq5ZnpRxNA94ak5UZywtP57eXjKdFh8uA5OnXG6+Um/BS
        VIaYylin7YwYrVt42LkznsGu7ux1RsBrIR18j2CJaSxrn2acsC3Nn+jfofFKhJVpBZeSJe
        bsALjibuVCM9OfI16meLA3lLxDK63iI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-bImaF6H9O1Ses6NJBEAfng-1; Tue, 15 Mar 2022 10:42:01 -0400
X-MC-Unique: bImaF6H9O1Ses6NJBEAfng-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AAC6900208;
        Tue, 15 Mar 2022 14:42:00 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.36.112.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A0E3140B42BB;
        Tue, 15 Mar 2022 14:41:59 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id CCFCA21D1F5A; Tue, 15 Mar 2022 15:41:56 +0100 (CET)
From:   Markus Armbruster <armbru@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Christian Schoenebeck <qemu_oss@crudebyte.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>,
        Laurent Vivier <lvivier@redhat.com>,
        Amit Shah <amit@kernel.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Corey Minyard <cminyard@mvista.com>,
        Patrick Venture <venture@google.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Jean-Christophe Dubois <jcd@tribudubois.net>,
        Keith Busch <kbusch@kernel.org>,
        Klaus Jensen <its@irrelevant.dk>,
        Yuval Shaia <yuval.shaia.ml@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Magnus Damm <magnus.damm@gmail.com>,
        Fabien Chouteau <chouteau@adacore.com>,
        KONRAD Frederic <frederic.konrad@adacore.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Konstantin Kostiuk <kkostiuk@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        David Hildenbrand <david@redhat.com>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Eric Blake <eblake@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        John Snow <jsnow@redhat.com>, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, xen-devel@lists.xenproject.org,
        qemu-ppc@nongnu.org, qemu-block@nongnu.org, haxm-team@intel.com,
        qemu-s390x@nongnu.org
Subject: [PATCH v2 3/3] Use g_new() & friends where that makes obvious sense
Date:   Tue, 15 Mar 2022 15:41:56 +0100
Message-Id: <20220315144156.1595462-4-armbru@redhat.com>
In-Reply-To: <20220315144156.1595462-1-armbru@redhat.com>
References: <20220315144156.1595462-1-armbru@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_SBL_A autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

g_new(T, n) is neater than g_malloc(sizeof(T) * n).  It's also safer,
for two reasons.  One, it catches multiplication overflowing size_t.
Two, it returns T * rather than void *, which lets the compiler catch
more type errors.

This commit only touches allocations with size arguments of the form
sizeof(T).

Patch created mechanically with:

    $ spatch --in-place --sp-file scripts/coccinelle/use-g_new-etc.cocci \
	     --macro-file scripts/cocci-macro-file.h FILES...

Signed-off-by: Markus Armbruster <armbru@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Acked-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 include/qemu/timer.h                     |  2 +-
 accel/kvm/kvm-all.c                      |  6 ++--
 accel/tcg/tcg-accel-ops-mttcg.c          |  2 +-
 accel/tcg/tcg-accel-ops-rr.c             |  4 +--
 audio/audio.c                            |  4 +--
 audio/audio_legacy.c                     |  6 ++--
 audio/dsoundaudio.c                      |  2 +-
 audio/jackaudio.c                        |  6 ++--
 audio/paaudio.c                          |  4 +--
 backends/cryptodev.c                     |  2 +-
 contrib/vhost-user-gpu/vhost-user-gpu.c  |  2 +-
 cpus-common.c                            |  4 +--
 dump/dump.c                              |  2 +-
 hw/acpi/hmat.c                           |  2 +-
 hw/audio/intel-hda.c                     |  2 +-
 hw/char/parallel.c                       |  2 +-
 hw/char/riscv_htif.c                     |  2 +-
 hw/char/virtio-serial-bus.c              |  6 ++--
 hw/core/irq.c                            |  2 +-
 hw/core/reset.c                          |  2 +-
 hw/display/pxa2xx_lcd.c                  |  2 +-
 hw/display/tc6393xb.c                    |  2 +-
 hw/display/virtio-gpu.c                  |  4 +--
 hw/display/xenfb.c                       |  4 +--
 hw/dma/rc4030.c                          |  4 +--
 hw/i2c/core.c                            |  4 +--
 hw/i2c/i2c_mux_pca954x.c                 |  2 +-
 hw/i386/amd_iommu.c                      |  4 +--
 hw/i386/intel_iommu.c                    |  2 +-
 hw/i386/xen/xen-hvm.c                    | 10 +++---
 hw/i386/xen/xen-mapcache.c               | 14 ++++----
 hw/input/lasips2.c                       |  2 +-
 hw/input/pckbd.c                         |  2 +-
 hw/input/ps2.c                           |  4 +--
 hw/input/pxa2xx_keypad.c                 |  2 +-
 hw/input/tsc2005.c                       |  3 +-
 hw/intc/riscv_aclint.c                   |  6 ++--
 hw/intc/xics.c                           |  2 +-
 hw/m68k/virt.c                           |  2 +-
 hw/mips/mipssim.c                        |  2 +-
 hw/misc/applesmc.c                       |  2 +-
 hw/misc/imx6_src.c                       |  2 +-
 hw/misc/ivshmem.c                        |  4 +--
 hw/net/virtio-net.c                      |  4 +--
 hw/nvme/ns.c                             |  2 +-
 hw/pci-host/pnv_phb3.c                   |  2 +-
 hw/pci-host/pnv_phb4.c                   |  2 +-
 hw/pci/pcie_sriov.c                      |  2 +-
 hw/ppc/e500.c                            |  2 +-
 hw/ppc/ppc.c                             |  8 ++---
 hw/ppc/ppc405_boards.c                   |  4 +--
 hw/ppc/ppc405_uc.c                       | 18 +++++-----
 hw/ppc/ppc4xx_devs.c                     |  2 +-
 hw/ppc/ppc_booke.c                       |  4 +--
 hw/ppc/spapr.c                           |  2 +-
 hw/ppc/spapr_events.c                    |  2 +-
 hw/ppc/spapr_hcall.c                     |  2 +-
 hw/ppc/spapr_numa.c                      |  3 +-
 hw/rdma/vmw/pvrdma_dev_ring.c            |  2 +-
 hw/rdma/vmw/pvrdma_qp_ops.c              |  6 ++--
 hw/sh4/r2d.c                             |  4 +--
 hw/sh4/sh7750.c                          |  2 +-
 hw/sparc/leon3.c                         |  2 +-
 hw/sparc64/sparc64.c                     |  4 +--
 hw/timer/arm_timer.c                     |  2 +-
 hw/timer/slavio_timer.c                  |  2 +-
 hw/vfio/pci.c                            |  4 +--
 hw/vfio/platform.c                       |  4 +--
 hw/virtio/virtio-crypto.c                |  2 +-
 hw/virtio/virtio-iommu.c                 |  2 +-
 hw/virtio/virtio.c                       |  5 ++-
 hw/xtensa/xtfpga.c                       |  2 +-
 linux-user/syscall.c                     |  2 +-
 migration/dirtyrate.c                    |  4 +--
 migration/multifd-zlib.c                 |  4 +--
 migration/ram.c                          |  2 +-
 monitor/misc.c                           |  2 +-
 monitor/qmp-cmds.c                       |  2 +-
 qga/commands-win32.c                     |  8 ++---
 qga/commands.c                           |  2 +-
 qom/qom-qmp-cmds.c                       |  2 +-
 replay/replay-char.c                     |  4 +--
 replay/replay-events.c                   | 10 +++---
 softmmu/bootdevice.c                     |  4 +--
 softmmu/dma-helpers.c                    |  4 +--
 softmmu/memory_mapping.c                 |  2 +-
 target/i386/cpu-sysemu.c                 |  2 +-
 target/i386/hax/hax-accel-ops.c          |  4 +--
 target/i386/nvmm/nvmm-accel-ops.c        |  4 +--
 target/i386/whpx/whpx-accel-ops.c        |  4 +--
 target/i386/whpx/whpx-all.c              |  2 +-
 target/s390x/cpu-sysemu.c                |  2 +-
 tests/unit/test-hbitmap.c                |  2 +-
 tests/unit/test-qmp-cmds.c               | 14 ++++----
 tests/unit/test-qobject-output-visitor.c |  2 +-
 tests/unit/test-vmstate.c                | 42 ++++++++++++------------
 ui/vnc-enc-tight.c                       |  2 +-
 util/envlist.c                           |  2 +-
 util/hbitmap.c                           |  2 +-
 util/main-loop.c                         |  2 +-
 util/qemu-timer.c                        |  2 +-
 util/vfio-helpers.c                      |  4 +--
 102 files changed, 195 insertions(+), 200 deletions(-)

diff --git a/include/qemu/timer.h b/include/qemu/timer.h
index 88ef114689..ee071e07d1 100644
--- a/include/qemu/timer.h
+++ b/include/qemu/timer.h
@@ -520,7 +520,7 @@ static inline QEMUTimer *timer_new_full(QEMUTimerListGroup *timer_list_group,
                                         int scale, int attributes,
                                         QEMUTimerCB *cb, void *opaque)
 {
-    QEMUTimer *ts = g_malloc0(sizeof(QEMUTimer));
+    QEMUTimer *ts = g_new0(QEMUTimer, 1);
     timer_init_full(ts, timer_list_group, type, scale, attributes, cb, opaque);
     return ts;
 }
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 0e66ebb497..1510856a3b 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1646,7 +1646,7 @@ void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
 {
     int i;
 
-    kml->slots = g_malloc0(s->nr_slots * sizeof(KVMSlot));
+    kml->slots = g_new0(KVMSlot, s->nr_slots);
     kml->as_id = as_id;
 
     for (i = 0; i < s->nr_slots; i++) {
@@ -1941,7 +1941,7 @@ int kvm_irqchip_send_msi(KVMState *s, MSIMessage msg)
             return virq;
         }
 
-        route = g_malloc0(sizeof(KVMMSIRoute));
+        route = g_new0(KVMMSIRoute, 1);
         route->kroute.gsi = virq;
         route->kroute.type = KVM_IRQ_ROUTING_MSI;
         route->kroute.flags = 0;
@@ -3243,7 +3243,7 @@ int kvm_insert_breakpoint(CPUState *cpu, target_ulong addr,
             return 0;
         }
 
-        bp = g_malloc(sizeof(struct kvm_sw_breakpoint));
+        bp = g_new(struct kvm_sw_breakpoint, 1);
         bp->pc = addr;
         bp->use_count = 1;
         err = kvm_arch_insert_sw_breakpoint(cpu, bp);
diff --git a/accel/tcg/tcg-accel-ops-mttcg.c b/accel/tcg/tcg-accel-ops-mttcg.c
index dc421c8fd7..ea2b741deb 100644
--- a/accel/tcg/tcg-accel-ops-mttcg.c
+++ b/accel/tcg/tcg-accel-ops-mttcg.c
@@ -143,7 +143,7 @@ void mttcg_start_vcpu_thread(CPUState *cpu)
     g_assert(tcg_enabled());
     tcg_cpu_init_cflags(cpu, current_machine->smp.max_cpus > 1);
 
-    cpu->thread = g_malloc0(sizeof(QemuThread));
+    cpu->thread = g_new0(QemuThread, 1);
     cpu->halt_cond = g_malloc0(sizeof(QemuCond));
     qemu_cond_init(cpu->halt_cond);
 
diff --git a/accel/tcg/tcg-accel-ops-rr.c b/accel/tcg/tcg-accel-ops-rr.c
index a805fb6bdd..b287110766 100644
--- a/accel/tcg/tcg-accel-ops-rr.c
+++ b/accel/tcg/tcg-accel-ops-rr.c
@@ -280,8 +280,8 @@ void rr_start_vcpu_thread(CPUState *cpu)
     tcg_cpu_init_cflags(cpu, false);
 
     if (!single_tcg_cpu_thread) {
-        cpu->thread = g_malloc0(sizeof(QemuThread));
-        cpu->halt_cond = g_malloc0(sizeof(QemuCond));
+        cpu->thread = g_new0(QemuThread, 1);
+        cpu->halt_cond = g_new0(QemuCond, 1);
         qemu_cond_init(cpu->halt_cond);
 
         /* share a single thread for all cpus with TCG */
diff --git a/audio/audio.c b/audio/audio.c
index a88572e713..4c20a4bf58 100644
--- a/audio/audio.c
+++ b/audio/audio.c
@@ -1734,7 +1734,7 @@ static AudioState *audio_init(Audiodev *dev, const char *name)
         audio_validate_opts(dev, &error_abort);
     }
 
-    s = g_malloc0(sizeof(AudioState));
+    s = g_new0(AudioState, 1);
     s->dev = dev;
 
     QLIST_INIT (&s->hw_head_out);
@@ -2109,7 +2109,7 @@ void audio_parse_option(const char *opt)
 
     audio_validate_opts(dev, &error_fatal);
 
-    e = g_malloc0(sizeof(AudiodevListEntry));
+    e = g_new0(AudiodevListEntry, 1);
     e->dev = dev;
     QSIMPLEQ_INSERT_TAIL(&audiodevs, e, next);
 }
diff --git a/audio/audio_legacy.c b/audio/audio_legacy.c
index 0fe827b057..595949f52c 100644
--- a/audio/audio_legacy.c
+++ b/audio/audio_legacy.c
@@ -328,8 +328,8 @@ static void handle_per_direction(
 
 static AudiodevListEntry *legacy_opt(const char *drvname)
 {
-    AudiodevListEntry *e = g_malloc0(sizeof(AudiodevListEntry));
-    e->dev = g_malloc0(sizeof(Audiodev));
+    AudiodevListEntry *e = g_new0(AudiodevListEntry, 1);
+    e->dev = g_new0(Audiodev, 1);
     e->dev->id = g_strdup(drvname);
     e->dev->driver = qapi_enum_parse(
         &AudiodevDriver_lookup, drvname, -1, &error_abort);
@@ -508,7 +508,7 @@ static void lv_free(Visitor *v)
 
 static Visitor *legacy_visitor_new(void)
 {
-    LegacyPrintVisitor *lv = g_malloc0(sizeof(LegacyPrintVisitor));
+    LegacyPrintVisitor *lv = g_new0(LegacyPrintVisitor, 1);
 
     lv->visitor.start_struct = lv_start_struct;
     lv->visitor.end_struct = lv_end_struct;
diff --git a/audio/dsoundaudio.c b/audio/dsoundaudio.c
index 231f3e65b3..2b41db217e 100644
--- a/audio/dsoundaudio.c
+++ b/audio/dsoundaudio.c
@@ -623,7 +623,7 @@ static void *dsound_audio_init(Audiodev *dev)
 {
     int err;
     HRESULT hr;
-    dsound *s = g_malloc0(sizeof(dsound));
+    dsound *s = g_new0(dsound, 1);
     AudiodevDsoundOptions *dso;
 
     assert(dev->driver == AUDIODEV_DRIVER_DSOUND);
diff --git a/audio/jackaudio.c b/audio/jackaudio.c
index bf757250b5..5bdf3d7a78 100644
--- a/audio/jackaudio.c
+++ b/audio/jackaudio.c
@@ -97,9 +97,9 @@ static void qjack_buffer_create(QJackBuffer *buffer, int channels, int frames)
     buffer->used     = 0;
     buffer->rptr     = 0;
     buffer->wptr     = 0;
-    buffer->data     = g_malloc(channels * sizeof(float *));
+    buffer->data     = g_new(float *, channels);
     for (int i = 0; i < channels; ++i) {
-        buffer->data[i] = g_malloc(frames * sizeof(float));
+        buffer->data[i] = g_new(float, frames);
     }
 }
 
@@ -453,7 +453,7 @@ static int qjack_client_init(QJackClient *c)
     jack_on_shutdown(c->client, qjack_shutdown, c);
 
     /* allocate and register the ports */
-    c->port = g_malloc(sizeof(jack_port_t *) * c->nchannels);
+    c->port = g_new(jack_port_t *, c->nchannels);
     for (int i = 0; i < c->nchannels; ++i) {
 
         char port_name[16];
diff --git a/audio/paaudio.c b/audio/paaudio.c
index a53ed85e0b..ed4f4376c4 100644
--- a/audio/paaudio.c
+++ b/audio/paaudio.c
@@ -760,7 +760,7 @@ static int qpa_validate_per_direction_opts(Audiodev *dev,
 /* common */
 static void *qpa_conn_init(const char *server)
 {
-    PAConnection *c = g_malloc0(sizeof(PAConnection));
+    PAConnection *c = g_new0(PAConnection, 1);
     QTAILQ_INSERT_TAIL(&pa_conns, c, list);
 
     c->mainloop = pa_threaded_mainloop_new();
@@ -849,7 +849,7 @@ static void *qpa_audio_init(Audiodev *dev)
         return NULL;
     }
 
-    g = g_malloc0(sizeof(paaudio));
+    g = g_new0(paaudio, 1);
     server = popts->has_server ? popts->server : NULL;
 
     g->dev = dev;
diff --git a/backends/cryptodev.c b/backends/cryptodev.c
index bf52476166..2b105e433c 100644
--- a/backends/cryptodev.c
+++ b/backends/cryptodev.c
@@ -39,7 +39,7 @@ cryptodev_backend_new_client(const char *model,
 {
     CryptoDevBackendClient *cc;
 
-    cc = g_malloc0(sizeof(CryptoDevBackendClient));
+    cc = g_new0(CryptoDevBackendClient, 1);
     cc->model = g_strdup(model);
     if (name) {
         cc->name = g_strdup(name);
diff --git a/contrib/vhost-user-gpu/vhost-user-gpu.c b/contrib/vhost-user-gpu/vhost-user-gpu.c
index 611360e6b4..bfb8d93cf8 100644
--- a/contrib/vhost-user-gpu/vhost-user-gpu.c
+++ b/contrib/vhost-user-gpu/vhost-user-gpu.c
@@ -455,7 +455,7 @@ vg_create_mapping_iov(VuGpu *g,
         return -1;
     }
 
-    *iov = g_malloc0(sizeof(struct iovec) * ab->nr_entries);
+    *iov = g_new0(struct iovec, ab->nr_entries);
     for (i = 0; i < ab->nr_entries; i++) {
         uint64_t len = ents[i].length;
         (*iov)[i].iov_len = ents[i].length;
diff --git a/cpus-common.c b/cpus-common.c
index 6e73d3e58d..db459b41ce 100644
--- a/cpus-common.c
+++ b/cpus-common.c
@@ -160,7 +160,7 @@ void async_run_on_cpu(CPUState *cpu, run_on_cpu_func func, run_on_cpu_data data)
 {
     struct qemu_work_item *wi;
 
-    wi = g_malloc0(sizeof(struct qemu_work_item));
+    wi = g_new0(struct qemu_work_item, 1);
     wi->func = func;
     wi->data = data;
     wi->free = true;
@@ -305,7 +305,7 @@ void async_safe_run_on_cpu(CPUState *cpu, run_on_cpu_func func,
 {
     struct qemu_work_item *wi;
 
-    wi = g_malloc0(sizeof(struct qemu_work_item));
+    wi = g_new0(struct qemu_work_item, 1);
     wi->func = func;
     wi->data = data;
     wi->free = true;
diff --git a/dump/dump.c b/dump/dump.c
index a84d8b1598..f57ed76fa7 100644
--- a/dump/dump.c
+++ b/dump/dump.c
@@ -2041,7 +2041,7 @@ void qmp_dump_guest_memory(bool paging, const char *file,
 DumpGuestMemoryCapability *qmp_query_dump_guest_memory_capability(Error **errp)
 {
     DumpGuestMemoryCapability *cap =
-                                  g_malloc0(sizeof(DumpGuestMemoryCapability));
+                                  g_new0(DumpGuestMemoryCapability, 1);
     DumpGuestMemoryFormatList **tail = &cap->formats;
 
     /* elf is always available */
diff --git a/hw/acpi/hmat.c b/hw/acpi/hmat.c
index 6913ebf730..3a6d51282a 100644
--- a/hw/acpi/hmat.c
+++ b/hw/acpi/hmat.c
@@ -128,7 +128,7 @@ static void build_hmat_lb(GArray *table_data, HMAT_LB_Info *hmat_lb,
     }
 
     /* Latency or Bandwidth Entries */
-    entry_list = g_malloc0(num_initiator * num_target * sizeof(uint16_t));
+    entry_list = g_new0(uint16_t, num_initiator * num_target);
     for (i = 0; i < hmat_lb->list->len; i++) {
         lb_data = &g_array_index(hmat_lb->list, HMAT_LB_Data, i);
         index = lb_data->initiator * num_target + lb_data->target;
diff --git a/hw/audio/intel-hda.c b/hw/audio/intel-hda.c
index 5f8a878f20..686fb94d5c 100644
--- a/hw/audio/intel-hda.c
+++ b/hw/audio/intel-hda.c
@@ -473,7 +473,7 @@ static void intel_hda_parse_bdl(IntelHDAState *d, IntelHDAStream *st)
     addr = intel_hda_addr(st->bdlp_lbase, st->bdlp_ubase);
     st->bentries = st->lvi +1;
     g_free(st->bpl);
-    st->bpl = g_malloc(sizeof(bpl) * st->bentries);
+    st->bpl = g_new(bpl, st->bentries);
     for (i = 0; i < st->bentries; i++, addr += 16) {
         pci_dma_read(&d->pci, addr, buf, 16);
         st->bpl[i].addr  = le64_to_cpu(*(uint64_t *)buf);
diff --git a/hw/char/parallel.c b/hw/char/parallel.c
index adb9bd9be3..f735a6cd7f 100644
--- a/hw/char/parallel.c
+++ b/hw/char/parallel.c
@@ -622,7 +622,7 @@ bool parallel_mm_init(MemoryRegion *address_space,
 {
     ParallelState *s;
 
-    s = g_malloc0(sizeof(ParallelState));
+    s = g_new0(ParallelState, 1);
     s->irq = irq;
     qemu_chr_fe_init(&s->chr, chr, &error_abort);
     s->it_shift = it_shift;
diff --git a/hw/char/riscv_htif.c b/hw/char/riscv_htif.c
index 729edbf968..6577f0e640 100644
--- a/hw/char/riscv_htif.c
+++ b/hw/char/riscv_htif.c
@@ -248,7 +248,7 @@ HTIFState *htif_mm_init(MemoryRegion *address_space, MemoryRegion *main_mem,
     tohost_offset = tohost_addr - base;
     fromhost_offset = fromhost_addr - base;
 
-    HTIFState *s = g_malloc0(sizeof(HTIFState));
+    HTIFState *s = g_new0(HTIFState, 1);
     s->address_space = address_space;
     s->main_mem = main_mem;
     s->main_mem_ram_ptr = memory_region_get_ram_ptr(main_mem);
diff --git a/hw/char/virtio-serial-bus.c b/hw/char/virtio-serial-bus.c
index f01ec2137c..6048d408b8 100644
--- a/hw/char/virtio-serial-bus.c
+++ b/hw/char/virtio-serial-bus.c
@@ -1055,10 +1055,8 @@ static void virtio_serial_device_realize(DeviceState *dev, Error **errp)
     QTAILQ_INIT(&vser->ports);
 
     vser->bus.max_nr_ports = vser->serial.max_virtserial_ports;
-    vser->ivqs = g_malloc(vser->serial.max_virtserial_ports
-                          * sizeof(VirtQueue *));
-    vser->ovqs = g_malloc(vser->serial.max_virtserial_ports
-                          * sizeof(VirtQueue *));
+    vser->ivqs = g_new(VirtQueue *, vser->serial.max_virtserial_ports);
+    vser->ovqs = g_new(VirtQueue *, vser->serial.max_virtserial_ports);
 
     /* Add a queue for host to guest transfers for port 0 (backward compat) */
     vser->ivqs[0] = virtio_add_queue(vdev, 128, handle_input);
diff --git a/hw/core/irq.c b/hw/core/irq.c
index 8a9cbdd556..741219277b 100644
--- a/hw/core/irq.c
+++ b/hw/core/irq.c
@@ -115,7 +115,7 @@ static void qemu_splitirq(void *opaque, int line, int level)
 
 qemu_irq qemu_irq_split(qemu_irq irq1, qemu_irq irq2)
 {
-    qemu_irq *s = g_malloc0(2 * sizeof(qemu_irq));
+    qemu_irq *s = g_new0(qemu_irq, 2);
     s[0] = irq1;
     s[1] = irq2;
     return qemu_allocate_irq(qemu_splitirq, s, 0);
diff --git a/hw/core/reset.c b/hw/core/reset.c
index 9c477f2bf5..36be82c491 100644
--- a/hw/core/reset.c
+++ b/hw/core/reset.c
@@ -40,7 +40,7 @@ static QTAILQ_HEAD(, QEMUResetEntry) reset_handlers =
 
 void qemu_register_reset(QEMUResetHandler *func, void *opaque)
 {
-    QEMUResetEntry *re = g_malloc0(sizeof(QEMUResetEntry));
+    QEMUResetEntry *re = g_new0(QEMUResetEntry, 1);
 
     re->func = func;
     re->opaque = opaque;
diff --git a/hw/display/pxa2xx_lcd.c b/hw/display/pxa2xx_lcd.c
index 2887ce496b..0f06ed6e9f 100644
--- a/hw/display/pxa2xx_lcd.c
+++ b/hw/display/pxa2xx_lcd.c
@@ -1427,7 +1427,7 @@ PXA2xxLCDState *pxa2xx_lcdc_init(MemoryRegion *sysmem,
 {
     PXA2xxLCDState *s;
 
-    s = (PXA2xxLCDState *) g_malloc0(sizeof(PXA2xxLCDState));
+    s = g_new0(PXA2xxLCDState, 1);
     s->invalidated = 1;
     s->irq = irq;
     s->sysmem = sysmem;
diff --git a/hw/display/tc6393xb.c b/hw/display/tc6393xb.c
index 1f28223c7b..c7beba453b 100644
--- a/hw/display/tc6393xb.c
+++ b/hw/display/tc6393xb.c
@@ -540,7 +540,7 @@ TC6393xbState *tc6393xb_init(MemoryRegion *sysmem, uint32_t base, qemu_irq irq)
         },
     };
 
-    s = (TC6393xbState *) g_malloc0(sizeof(TC6393xbState));
+    s = g_new0(TC6393xbState, 1);
     s->irq = irq;
     s->gpio_in = qemu_allocate_irqs(tc6393xb_gpio_set, s, TC6393XB_GPIOS);
 
diff --git a/hw/display/virtio-gpu.c b/hw/display/virtio-gpu.c
index c6dc818988..529b5246b2 100644
--- a/hw/display/virtio-gpu.c
+++ b/hw/display/virtio-gpu.c
@@ -831,9 +831,9 @@ int virtio_gpu_create_mapping_iov(VirtIOGPU *g,
             }
 
             if (!(v % 16)) {
-                *iov = g_realloc(*iov, sizeof(struct iovec) * (v + 16));
+                *iov = g_renew(struct iovec, *iov, v + 16);
                 if (addr) {
-                    *addr = g_realloc(*addr, sizeof(uint64_t) * (v + 16));
+                    *addr = g_renew(uint64_t, *addr, v + 16);
                 }
             }
             (*iov)[v].iov_base = map;
diff --git a/hw/display/xenfb.c b/hw/display/xenfb.c
index 838260b6ad..cea10fe3c7 100644
--- a/hw/display/xenfb.c
+++ b/hw/display/xenfb.c
@@ -496,8 +496,8 @@ static int xenfb_map_fb(struct XenFB *xenfb)
     n_fbdirs = xenfb->fbpages * mode / 8;
     n_fbdirs = DIV_ROUND_UP(n_fbdirs, XC_PAGE_SIZE);
 
-    pgmfns = g_malloc0(sizeof(xen_pfn_t) * n_fbdirs);
-    fbmfns = g_malloc0(sizeof(xen_pfn_t) * xenfb->fbpages);
+    pgmfns = g_new0(xen_pfn_t, n_fbdirs);
+    fbmfns = g_new0(xen_pfn_t, xenfb->fbpages);
 
     xenfb_copy_mfns(mode, n_fbdirs, pgmfns, pd);
     map = xenforeignmemory_map(xen_fmem, xenfb->c.xendev.dom,
diff --git a/hw/dma/rc4030.c b/hw/dma/rc4030.c
index e4d2f1725b..aa1d323a36 100644
--- a/hw/dma/rc4030.c
+++ b/hw/dma/rc4030.c
@@ -646,8 +646,8 @@ static rc4030_dma *rc4030_allocate_dmas(void *opaque, int n)
     struct rc4030DMAState *p;
     int i;
 
-    s = (rc4030_dma *)g_new0(rc4030_dma, n);
-    p = (struct rc4030DMAState *)g_new0(struct rc4030DMAState, n);
+    s = g_new0(rc4030_dma, n);
+    p = g_new0(struct rc4030DMAState, n);
     for (i = 0; i < n; i++) {
         p->opaque = opaque;
         p->n = i;
diff --git a/hw/i2c/core.c b/hw/i2c/core.c
index 0e7d2763b9..d0cb2d32fa 100644
--- a/hw/i2c/core.c
+++ b/hw/i2c/core.c
@@ -274,7 +274,7 @@ static int i2c_slave_post_load(void *opaque, int version_id)
     bus = I2C_BUS(qdev_get_parent_bus(DEVICE(dev)));
     if ((bus->saved_address == dev->address) ||
         (bus->saved_address == I2C_BROADCAST)) {
-        node = g_malloc(sizeof(struct I2CNode));
+        node = g_new(struct I2CNode, 1);
         node->elt = dev;
         QLIST_INSERT_HEAD(&bus->current_devs, node, next);
     }
@@ -319,7 +319,7 @@ static bool i2c_slave_match(I2CSlave *candidate, uint8_t address,
                             bool broadcast, I2CNodeList *current_devs)
 {
     if ((candidate->address == address) || (broadcast)) {
-        I2CNode *node = g_malloc(sizeof(struct I2CNode));
+        I2CNode *node = g_new(struct I2CNode, 1);
         node->elt = candidate;
         QLIST_INSERT_HEAD(current_devs, node, next);
         return true;
diff --git a/hw/i2c/i2c_mux_pca954x.c b/hw/i2c/i2c_mux_pca954x.c
index a9517b612a..3945de795c 100644
--- a/hw/i2c/i2c_mux_pca954x.c
+++ b/hw/i2c/i2c_mux_pca954x.c
@@ -71,7 +71,7 @@ static bool pca954x_match(I2CSlave *candidate, uint8_t address,
 
     /* They are talking to the mux itself (or all devices enabled). */
     if ((candidate->address == address) || broadcast) {
-        I2CNode *node = g_malloc(sizeof(struct I2CNode));
+        I2CNode *node = g_new(struct I2CNode, 1);
         node->elt = candidate;
         QLIST_INSERT_HEAD(current_devs, node, next);
         if (!broadcast) {
diff --git a/hw/i386/amd_iommu.c b/hw/i386/amd_iommu.c
index 4d13d8e697..9dd9b0ecf2 100644
--- a/hw/i386/amd_iommu.c
+++ b/hw/i386/amd_iommu.c
@@ -1405,7 +1405,7 @@ static AddressSpace *amdvi_host_dma_iommu(PCIBus *bus, void *opaque, int devfn)
 
     /* allocate memory during the first run */
     if (!iommu_as) {
-        iommu_as = g_malloc0(sizeof(AMDVIAddressSpace *) * PCI_DEVFN_MAX);
+        iommu_as = g_new0(AMDVIAddressSpace *, PCI_DEVFN_MAX);
         s->address_spaces[bus_num] = iommu_as;
     }
 
@@ -1413,7 +1413,7 @@ static AddressSpace *amdvi_host_dma_iommu(PCIBus *bus, void *opaque, int devfn)
     if (!iommu_as[devfn]) {
         snprintf(name, sizeof(name), "amd_iommu_devfn_%d", devfn);
 
-        iommu_as[devfn] = g_malloc0(sizeof(AMDVIAddressSpace));
+        iommu_as[devfn] = g_new0(AMDVIAddressSpace, 1);
         iommu_as[devfn]->bus_num = (uint8_t)bus_num;
         iommu_as[devfn]->devfn = (uint8_t)devfn;
         iommu_as[devfn]->iommu_state = s;
diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 32471a44cb..c64aa81a83 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -3416,7 +3416,7 @@ VTDAddressSpace *vtd_find_add_as(IntelIOMMUState *s, PCIBus *bus, int devfn)
     if (!vtd_dev_as) {
         snprintf(name, sizeof(name), "vtd-%02x.%x", PCI_SLOT(devfn),
                  PCI_FUNC(devfn));
-        vtd_bus->dev_as[devfn] = vtd_dev_as = g_malloc0(sizeof(VTDAddressSpace));
+        vtd_bus->dev_as[devfn] = vtd_dev_as = g_new0(VTDAddressSpace, 1);
 
         vtd_dev_as->bus = bus;
         vtd_dev_as->devfn = (uint8_t)devfn;
diff --git a/hw/i386/xen/xen-hvm.c b/hw/i386/xen/xen-hvm.c
index cf8e500514..0731f70410 100644
--- a/hw/i386/xen/xen-hvm.c
+++ b/hw/i386/xen/xen-hvm.c
@@ -396,7 +396,7 @@ go_physmap:
 
     mr_name = memory_region_name(mr);
 
-    physmap = g_malloc(sizeof(XenPhysmap));
+    physmap = g_new(XenPhysmap, 1);
 
     physmap->start_addr = start_addr;
     physmap->size = size;
@@ -1281,7 +1281,7 @@ static void xen_read_physmap(XenIOState *state)
         return;
 
     for (i = 0; i < num; i++) {
-        physmap = g_malloc(sizeof (XenPhysmap));
+        physmap = g_new(XenPhysmap, 1);
         physmap->phys_offset = strtoull(entries[i], NULL, 16);
         snprintf(path, sizeof(path),
                 "/local/domain/0/device-model/%d/physmap/%s/start_addr",
@@ -1410,7 +1410,7 @@ void xen_hvm_init_pc(PCMachineState *pcms, MemoryRegion **ram_memory)
     xen_pfn_t ioreq_pfn;
     XenIOState *state;
 
-    state = g_malloc0(sizeof (XenIOState));
+    state = g_new0(XenIOState, 1);
 
     state->xce_handle = xenevtchn_open(NULL, 0);
     if (state->xce_handle == NULL) {
@@ -1463,7 +1463,7 @@ void xen_hvm_init_pc(PCMachineState *pcms, MemoryRegion **ram_memory)
     }
 
     /* Note: cpus is empty at this point in init */
-    state->cpu_by_vcpu_id = g_malloc0(max_cpus * sizeof(CPUState *));
+    state->cpu_by_vcpu_id = g_new0(CPUState *, max_cpus);
 
     rc = xen_set_ioreq_server_state(xen_domid, state->ioservid, true);
     if (rc < 0) {
@@ -1472,7 +1472,7 @@ void xen_hvm_init_pc(PCMachineState *pcms, MemoryRegion **ram_memory)
         goto err;
     }
 
-    state->ioreq_local_port = g_malloc0(max_cpus * sizeof (evtchn_port_t));
+    state->ioreq_local_port = g_new0(evtchn_port_t, max_cpus);
 
     /* FIXME: how about if we overflow the page here? */
     for (i = 0; i < max_cpus; i++) {
diff --git a/hw/i386/xen/xen-mapcache.c b/hw/i386/xen/xen-mapcache.c
index f2ef977963..a2f93096e7 100644
--- a/hw/i386/xen/xen-mapcache.c
+++ b/hw/i386/xen/xen-mapcache.c
@@ -108,7 +108,7 @@ void xen_map_cache_init(phys_offset_to_gaddr_t f, void *opaque)
     unsigned long size;
     struct rlimit rlimit_as;
 
-    mapcache = g_malloc0(sizeof (MapCache));
+    mapcache = g_new0(MapCache, 1);
 
     mapcache->phys_offset_to_gaddr = f;
     mapcache->opaque = opaque;
@@ -164,8 +164,8 @@ static void xen_remap_bucket(MapCacheEntry *entry,
 
     trace_xen_remap_bucket(address_index);
 
-    pfns = g_malloc0(nb_pfn * sizeof (xen_pfn_t));
-    err = g_malloc0(nb_pfn * sizeof (int));
+    pfns = g_new0(xen_pfn_t, nb_pfn);
+    err = g_new0(int, nb_pfn);
 
     if (entry->vaddr_base != NULL) {
         if (!(entry->flags & XEN_MAPCACHE_ENTRY_DUMMY)) {
@@ -231,8 +231,8 @@ static void xen_remap_bucket(MapCacheEntry *entry,
     entry->vaddr_base = vaddr_base;
     entry->paddr_index = address_index;
     entry->size = size;
-    entry->valid_mapping = (unsigned long *) g_malloc0(sizeof(unsigned long) *
-            BITS_TO_LONGS(size >> XC_PAGE_SHIFT));
+    entry->valid_mapping = g_new0(unsigned long,
+                                  BITS_TO_LONGS(size >> XC_PAGE_SHIFT));
 
     if (dummy) {
         entry->flags |= XEN_MAPCACHE_ENTRY_DUMMY;
@@ -319,7 +319,7 @@ tryagain:
         pentry = free_pentry;
     }
     if (!entry) {
-        entry = g_malloc0(sizeof (MapCacheEntry));
+        entry = g_new0(MapCacheEntry, 1);
         pentry->next = entry;
         xen_remap_bucket(entry, NULL, cache_size, address_index, dummy);
     } else if (!entry->lock) {
@@ -353,7 +353,7 @@ tryagain:
 
     mapcache->last_entry = entry;
     if (lock) {
-        MapCacheRev *reventry = g_malloc0(sizeof(MapCacheRev));
+        MapCacheRev *reventry = g_new0(MapCacheRev, 1);
         entry->lock++;
         if (entry->lock == 0) {
             fprintf(stderr,
diff --git a/hw/input/lasips2.c b/hw/input/lasips2.c
index 68d741d342..94f18be4cd 100644
--- a/hw/input/lasips2.c
+++ b/hw/input/lasips2.c
@@ -266,7 +266,7 @@ void lasips2_init(MemoryRegion *address_space,
 {
     LASIPS2State *s;
 
-    s = g_malloc0(sizeof(LASIPS2State));
+    s = g_new0(LASIPS2State, 1);
 
     s->irq = irq;
     s->mouse.id = 1;
diff --git a/hw/input/pckbd.c b/hw/input/pckbd.c
index 1773db0d25..4efdf75620 100644
--- a/hw/input/pckbd.c
+++ b/hw/input/pckbd.c
@@ -649,7 +649,7 @@ void i8042_mm_init(qemu_irq kbd_irq, qemu_irq mouse_irq,
                    MemoryRegion *region, ram_addr_t size,
                    hwaddr mask)
 {
-    KBDState *s = g_malloc0(sizeof(KBDState));
+    KBDState *s = g_new0(KBDState, 1);
 
     s->irq_kbd = kbd_irq;
     s->irq_mouse = mouse_irq;
diff --git a/hw/input/ps2.c b/hw/input/ps2.c
index 6236711e1b..c16df1de7a 100644
--- a/hw/input/ps2.c
+++ b/hw/input/ps2.c
@@ -1226,7 +1226,7 @@ static QemuInputHandler ps2_keyboard_handler = {
 
 void *ps2_kbd_init(void (*update_irq)(void *, int), void *update_arg)
 {
-    PS2KbdState *s = (PS2KbdState *)g_malloc0(sizeof(PS2KbdState));
+    PS2KbdState *s = g_new0(PS2KbdState, 1);
 
     trace_ps2_kbd_init(s);
     s->common.update_irq = update_irq;
@@ -1248,7 +1248,7 @@ static QemuInputHandler ps2_mouse_handler = {
 
 void *ps2_mouse_init(void (*update_irq)(void *, int), void *update_arg)
 {
-    PS2MouseState *s = (PS2MouseState *)g_malloc0(sizeof(PS2MouseState));
+    PS2MouseState *s = g_new0(PS2MouseState, 1);
 
     trace_ps2_mouse_init(s);
     s->common.update_irq = update_irq;
diff --git a/hw/input/pxa2xx_keypad.c b/hw/input/pxa2xx_keypad.c
index 7f2f739fb3..3dd03e8c9f 100644
--- a/hw/input/pxa2xx_keypad.c
+++ b/hw/input/pxa2xx_keypad.c
@@ -306,7 +306,7 @@ PXA2xxKeyPadState *pxa27x_keypad_init(MemoryRegion *sysmem,
 {
     PXA2xxKeyPadState *s;
 
-    s = (PXA2xxKeyPadState *) g_malloc0(sizeof(PXA2xxKeyPadState));
+    s = g_new0(PXA2xxKeyPadState, 1);
     s->irq = irq;
 
     memory_region_init_io(&s->iomem, NULL, &pxa2xx_keypad_ops, s,
diff --git a/hw/input/tsc2005.c b/hw/input/tsc2005.c
index 55d61cc843..14698ce109 100644
--- a/hw/input/tsc2005.c
+++ b/hw/input/tsc2005.c
@@ -489,8 +489,7 @@ void *tsc2005_init(qemu_irq pintdav)
 {
     TSC2005State *s;
 
-    s = (TSC2005State *)
-            g_malloc0(sizeof(TSC2005State));
+    s = g_new0(TSC2005State, 1);
     s->x = 400;
     s->y = 240;
     s->pressure = false;
diff --git a/hw/intc/riscv_aclint.c b/hw/intc/riscv_aclint.c
index f1a5d3d284..e43b050e92 100644
--- a/hw/intc/riscv_aclint.c
+++ b/hw/intc/riscv_aclint.c
@@ -235,7 +235,7 @@ static void riscv_aclint_mtimer_realize(DeviceState *dev, Error **errp)
                           s, TYPE_RISCV_ACLINT_MTIMER, s->aperture_size);
     sysbus_init_mmio(SYS_BUS_DEVICE(dev), &s->mmio);
 
-    s->timer_irqs = g_malloc(sizeof(qemu_irq) * s->num_harts);
+    s->timer_irqs = g_new(qemu_irq, s->num_harts);
     qdev_init_gpio_out(dev, s->timer_irqs, s->num_harts);
 
     /* Claim timer interrupt bits */
@@ -292,7 +292,7 @@ DeviceState *riscv_aclint_mtimer_create(hwaddr addr, hwaddr size,
         RISCVCPU *rvcpu = RISCV_CPU(cpu);
         CPURISCVState *env = cpu ? cpu->env_ptr : NULL;
         riscv_aclint_mtimer_callback *cb =
-            g_malloc0(sizeof(riscv_aclint_mtimer_callback));
+            g_new0(riscv_aclint_mtimer_callback, 1);
 
         if (!env) {
             g_free(cb);
@@ -393,7 +393,7 @@ static void riscv_aclint_swi_realize(DeviceState *dev, Error **errp)
                           TYPE_RISCV_ACLINT_SWI, RISCV_ACLINT_SWI_SIZE);
     sysbus_init_mmio(SYS_BUS_DEVICE(dev), &swi->mmio);
 
-    swi->soft_irqs = g_malloc(sizeof(qemu_irq) * swi->num_harts);
+    swi->soft_irqs = g_new(qemu_irq, swi->num_harts);
     qdev_init_gpio_out(dev, swi->soft_irqs, swi->num_harts);
 
     /* Claim software interrupt bits */
diff --git a/hw/intc/xics.c b/hw/intc/xics.c
index 48a835eab7..24e67020db 100644
--- a/hw/intc/xics.c
+++ b/hw/intc/xics.c
@@ -604,7 +604,7 @@ static void ics_realize(DeviceState *dev, Error **errp)
         error_setg(errp, "Number of interrupts needs to be greater 0");
         return;
     }
-    ics->irqs = g_malloc0(ics->nr_irqs * sizeof(ICSIRQState));
+    ics->irqs = g_new0(ICSIRQState, ics->nr_irqs);
 
     qemu_register_reset(ics_reset_handler, ics);
 }
diff --git a/hw/m68k/virt.c b/hw/m68k/virt.c
index bbaf630bbf..8e630282e0 100644
--- a/hw/m68k/virt.c
+++ b/hw/m68k/virt.c
@@ -132,7 +132,7 @@ static void virt_init(MachineState *machine)
         exit(1);
     }
 
-    reset_info = g_malloc0(sizeof(ResetInfo));
+    reset_info = g_new0(ResetInfo, 1);
 
     /* init CPUs */
     cpu = M68K_CPU(cpu_create(machine->cpu_type));
diff --git a/hw/mips/mipssim.c b/hw/mips/mipssim.c
index 2325e7e05a..27a46bd538 100644
--- a/hw/mips/mipssim.c
+++ b/hw/mips/mipssim.c
@@ -162,7 +162,7 @@ mips_mipssim_init(MachineState *machine)
     cpu = mips_cpu_create_with_clock(machine->cpu_type, cpuclk);
     env = &cpu->env;
 
-    reset_info = g_malloc0(sizeof(ResetData));
+    reset_info = g_new0(ResetData, 1);
     reset_info->cpu = cpu;
     reset_info->vector = env->active_tc.PC;
     qemu_register_reset(main_cpu_reset, reset_info);
diff --git a/hw/misc/applesmc.c b/hw/misc/applesmc.c
index 1b9acaf1d3..81cd6b6423 100644
--- a/hw/misc/applesmc.c
+++ b/hw/misc/applesmc.c
@@ -253,7 +253,7 @@ static void applesmc_add_key(AppleSMCState *s, const char *key,
 {
     struct AppleSMCData *def;
 
-    def = g_malloc0(sizeof(struct AppleSMCData));
+    def = g_new0(struct AppleSMCData, 1);
     def->key = key;
     def->len = len;
     def->data = data;
diff --git a/hw/misc/imx6_src.c b/hw/misc/imx6_src.c
index 79f4375911..7b0e968804 100644
--- a/hw/misc/imx6_src.c
+++ b/hw/misc/imx6_src.c
@@ -151,7 +151,7 @@ static void imx6_defer_clear_reset_bit(int cpuid,
         return;
     }
 
-    ri = g_malloc(sizeof(struct SRCSCRResetInfo));
+    ri = g_new(struct SRCSCRResetInfo, 1);
     ri->s = s;
     ri->reset_bit = reset_shift;
 
diff --git a/hw/misc/ivshmem.c b/hw/misc/ivshmem.c
index 299837e5c1..b54778ada5 100644
--- a/hw/misc/ivshmem.c
+++ b/hw/misc/ivshmem.c
@@ -411,7 +411,7 @@ static void resize_peers(IVShmemState *s, int nb_peers)
     assert(nb_peers > old_nb_peers);
     IVSHMEM_DPRINTF("bumping storage to %d peers\n", nb_peers);
 
-    s->peers = g_realloc(s->peers, nb_peers * sizeof(Peer));
+    s->peers = g_renew(Peer, s->peers, nb_peers);
     s->nb_peers = nb_peers;
 
     for (i = old_nb_peers; i < nb_peers; i++) {
@@ -728,7 +728,7 @@ static void ivshmem_reset(DeviceState *d)
 static int ivshmem_setup_interrupts(IVShmemState *s, Error **errp)
 {
     /* allocate QEMU callback data for receiving interrupts */
-    s->msi_vectors = g_malloc0(s->vectors * sizeof(MSIVector));
+    s->msi_vectors = g_new0(MSIVector, s->vectors);
 
     if (ivshmem_has_feature(s, IVSHMEM_MSI)) {
         if (msix_init_exclusive_bar(PCI_DEVICE(s), s->vectors, 1, errp)) {
diff --git a/hw/net/virtio-net.c b/hw/net/virtio-net.c
index b02a0632df..bd121103f3 100644
--- a/hw/net/virtio-net.c
+++ b/hw/net/virtio-net.c
@@ -1994,7 +1994,7 @@ static void virtio_net_rsc_cache_buf(VirtioNetRscChain *chain,
     VirtioNetRscSeg *seg;
 
     hdr_len = chain->n->guest_hdr_len;
-    seg = g_malloc(sizeof(VirtioNetRscSeg));
+    seg = g_new(VirtioNetRscSeg, 1);
     seg->buf = g_malloc(hdr_len + sizeof(struct eth_header)
         + sizeof(struct ip6_header) + VIRTIO_NET_MAX_TCP_PAYLOAD);
     memcpy(seg->buf, buf, size);
@@ -3442,7 +3442,7 @@ static void virtio_net_device_realize(DeviceState *dev, Error **errp)
         virtio_cleanup(vdev);
         return;
     }
-    n->vqs = g_malloc0(sizeof(VirtIONetQueue) * n->max_queue_pairs);
+    n->vqs = g_new0(VirtIONetQueue, n->max_queue_pairs);
     n->curr_queue_pairs = 1;
     n->tx_timeout = n->net_conf.txtimer;
 
diff --git a/hw/nvme/ns.c b/hw/nvme/ns.c
index 8a3613d9ab..324f53ea0c 100644
--- a/hw/nvme/ns.c
+++ b/hw/nvme/ns.c
@@ -268,7 +268,7 @@ static void nvme_ns_init_zoned(NvmeNamespace *ns)
 
     nvme_ns_zoned_init_state(ns);
 
-    id_ns_z = g_malloc0(sizeof(NvmeIdNsZoned));
+    id_ns_z = g_new0(NvmeIdNsZoned, 1);
 
     /* MAR/MOR are zeroes-based, FFFFFFFFFh means no limit */
     id_ns_z->mar = cpu_to_le32(ns->params.max_active_zones - 1);
diff --git a/hw/pci-host/pnv_phb3.c b/hw/pci-host/pnv_phb3.c
index aafd46b635..ac6fe48975 100644
--- a/hw/pci-host/pnv_phb3.c
+++ b/hw/pci-host/pnv_phb3.c
@@ -946,7 +946,7 @@ static AddressSpace *pnv_phb3_dma_iommu(PCIBus *bus, void *opaque, int devfn)
     }
 
     if (ds == NULL) {
-        ds = g_malloc0(sizeof(PnvPhb3DMASpace));
+        ds = g_new0(PnvPhb3DMASpace, 1);
         ds->bus = bus;
         ds->devfn = devfn;
         ds->pe_num = PHB_INVALID_PE;
diff --git a/hw/pci-host/pnv_phb4.c b/hw/pci-host/pnv_phb4.c
index b5b384e9ee..d0d1612e1e 100644
--- a/hw/pci-host/pnv_phb4.c
+++ b/hw/pci-host/pnv_phb4.c
@@ -1466,7 +1466,7 @@ static AddressSpace *pnv_phb4_dma_iommu(PCIBus *bus, void *opaque, int devfn)
     ds = pnv_phb4_dma_find(phb, bus, devfn);
 
     if (ds == NULL) {
-        ds = g_malloc0(sizeof(PnvPhb4DMASpace));
+        ds = g_new0(PnvPhb4DMASpace, 1);
         ds->bus = bus;
         ds->devfn = devfn;
         ds->pe_num = PHB_INVALID_PE;
diff --git a/hw/pci/pcie_sriov.c b/hw/pci/pcie_sriov.c
index 87abad6ac8..8e3faf1f59 100644
--- a/hw/pci/pcie_sriov.c
+++ b/hw/pci/pcie_sriov.c
@@ -177,7 +177,7 @@ static void register_vfs(PCIDevice *dev)
     assert(sriov_cap > 0);
     num_vfs = pci_get_word(dev->config + sriov_cap + PCI_SRIOV_NUM_VF);
 
-    dev->exp.sriov_pf.vf = g_malloc(sizeof(PCIDevice *) * num_vfs);
+    dev->exp.sriov_pf.vf = g_new(PCIDevice *, num_vfs);
     assert(dev->exp.sriov_pf.vf);
 
     trace_sriov_register_vfs(dev->name, PCI_SLOT(dev->devfn),
diff --git a/hw/ppc/e500.c b/hw/ppc/e500.c
index 960e7efcd3..c7e6767f91 100644
--- a/hw/ppc/e500.c
+++ b/hw/ppc/e500.c
@@ -899,7 +899,7 @@ void ppce500_init(MachineState *machine)
         if (!i) {
             /* Primary CPU */
             struct boot_info *boot_info;
-            boot_info = g_malloc0(sizeof(struct boot_info));
+            boot_info = g_new0(struct boot_info, 1);
             qemu_register_reset(ppce500_cpu_reset, cpu);
             env->load_info = boot_info;
         } else {
diff --git a/hw/ppc/ppc.c b/hw/ppc/ppc.c
index 9e99625ea9..faa02d6710 100644
--- a/hw/ppc/ppc.c
+++ b/hw/ppc/ppc.c
@@ -1063,7 +1063,7 @@ clk_setup_cb cpu_ppc_tb_init (CPUPPCState *env, uint32_t freq)
     PowerPCCPU *cpu = env_archcpu(env);
     ppc_tb_t *tb_env;
 
-    tb_env = g_malloc0(sizeof(ppc_tb_t));
+    tb_env = g_new0(ppc_tb_t, 1);
     env->tb_env = tb_env;
     tb_env->flags = PPC_DECR_UNDERFLOW_TRIGGERED;
     if (is_book3s_arch2x(env)) {
@@ -1338,8 +1338,8 @@ clk_setup_cb ppc_40x_timers_init (CPUPPCState *env, uint32_t freq,
 
     trace_ppc40x_timers_init(freq);
 
-    tb_env = g_malloc0(sizeof(ppc_tb_t));
-    ppc40x_timer = g_malloc0(sizeof(ppc40x_timer_t));
+    tb_env = g_new0(ppc_tb_t, 1);
+    ppc40x_timer = g_new0(ppc40x_timer_t, 1);
 
     env->tb_env = tb_env;
     tb_env->flags = PPC_DECR_UNDERFLOW_TRIGGERED;
@@ -1447,7 +1447,7 @@ int ppc_dcr_init (CPUPPCState *env, int (*read_error)(int dcrn),
 {
     ppc_dcr_t *dcr_env;
 
-    dcr_env = g_malloc0(sizeof(ppc_dcr_t));
+    dcr_env = g_new0(ppc_dcr_t, 1);
     dcr_env->read_error = read_error;
     dcr_env->write_error = write_error;
     env->dcr_env = dcr_env;
diff --git a/hw/ppc/ppc405_boards.c b/hw/ppc/ppc405_boards.c
index 3ae2b36373..7e1a4ac955 100644
--- a/hw/ppc/ppc405_boards.c
+++ b/hw/ppc/ppc405_boards.c
@@ -130,7 +130,7 @@ static void ref405ep_fpga_init(MemoryRegion *sysmem, uint32_t base)
     ref405ep_fpga_t *fpga;
     MemoryRegion *fpga_memory = g_new(MemoryRegion, 1);
 
-    fpga = g_malloc0(sizeof(ref405ep_fpga_t));
+    fpga = g_new0(ref405ep_fpga_t, 1);
     memory_region_init_io(fpga_memory, NULL, &ref405ep_fpga_ops, fpga,
                           "fpga", 0x00000100);
     memory_region_add_subregion(sysmem, base, fpga_memory);
@@ -431,7 +431,7 @@ static void taihu_cpld_init(MemoryRegion *sysmem, uint32_t base)
     taihu_cpld_t *cpld;
     MemoryRegion *cpld_memory = g_new(MemoryRegion, 1);
 
-    cpld = g_malloc0(sizeof(taihu_cpld_t));
+    cpld = g_new0(taihu_cpld_t, 1);
     memory_region_init_io(cpld_memory, NULL, &taihu_cpld_ops, cpld, "cpld", 0x100);
     memory_region_add_subregion(sysmem, base, cpld_memory);
     qemu_register_reset(&taihu_cpld_reset, cpld);
diff --git a/hw/ppc/ppc405_uc.c b/hw/ppc/ppc405_uc.c
index 8aacd275a6..36c8ba6f3c 100644
--- a/hw/ppc/ppc405_uc.c
+++ b/hw/ppc/ppc405_uc.c
@@ -215,7 +215,7 @@ void ppc4xx_plb_init(CPUPPCState *env)
 {
     ppc4xx_plb_t *plb;
 
-    plb = g_malloc0(sizeof(ppc4xx_plb_t));
+    plb = g_new0(ppc4xx_plb_t, 1);
     ppc_dcr_register(env, PLB3A0_ACR, plb, &dcr_read_plb, &dcr_write_plb);
     ppc_dcr_register(env, PLB4A0_ACR, plb, &dcr_read_plb, &dcr_write_plb);
     ppc_dcr_register(env, PLB0_ACR, plb, &dcr_read_plb, &dcr_write_plb);
@@ -300,7 +300,7 @@ static void ppc4xx_pob_init(CPUPPCState *env)
 {
     ppc4xx_pob_t *pob;
 
-    pob = g_malloc0(sizeof(ppc4xx_pob_t));
+    pob = g_new0(ppc4xx_pob_t, 1);
     ppc_dcr_register(env, POB0_BEAR, pob, &dcr_read_pob, &dcr_write_pob);
     ppc_dcr_register(env, POB0_BESR0, pob, &dcr_read_pob, &dcr_write_pob);
     ppc_dcr_register(env, POB0_BESR1, pob, &dcr_read_pob, &dcr_write_pob);
@@ -380,7 +380,7 @@ static void ppc4xx_opba_init(hwaddr base)
 
     trace_opba_init(base);
 
-    opba = g_malloc0(sizeof(ppc4xx_opba_t));
+    opba = g_new0(ppc4xx_opba_t, 1);
     memory_region_init_io(&opba->io, NULL, &opba_ops, opba, "opba", 0x002);
     memory_region_add_subregion(get_system_memory(), base, &opba->io);
     qemu_register_reset(ppc4xx_opba_reset, opba);
@@ -575,7 +575,7 @@ void ppc405_ebc_init(CPUPPCState *env)
 {
     ppc4xx_ebc_t *ebc;
 
-    ebc = g_malloc0(sizeof(ppc4xx_ebc_t));
+    ebc = g_new0(ppc4xx_ebc_t, 1);
     qemu_register_reset(&ebc_reset, ebc);
     ppc_dcr_register(env, EBC0_CFGADDR,
                      ebc, &dcr_read_ebc, &dcr_write_ebc);
@@ -658,7 +658,7 @@ static void ppc405_dma_init(CPUPPCState *env, qemu_irq irqs[4])
 {
     ppc405_dma_t *dma;
 
-    dma = g_malloc0(sizeof(ppc405_dma_t));
+    dma = g_new0(ppc405_dma_t, 1);
     memcpy(dma->irqs, irqs, 4 * sizeof(qemu_irq));
     qemu_register_reset(&ppc405_dma_reset, dma);
     ppc_dcr_register(env, DMA0_CR0,
@@ -757,7 +757,7 @@ static void ppc405_gpio_init(hwaddr base)
 
     trace_ppc405_gpio_init(base);
 
-    gpio = g_malloc0(sizeof(ppc405_gpio_t));
+    gpio = g_new0(ppc405_gpio_t, 1);
     memory_region_init_io(&gpio->io, NULL, &ppc405_gpio_ops, gpio, "pgio", 0x038);
     memory_region_add_subregion(get_system_memory(), base, &gpio->io);
     qemu_register_reset(&ppc405_gpio_reset, gpio);
@@ -906,7 +906,7 @@ static void ppc405_ocm_init(CPUPPCState *env)
 {
     ppc405_ocm_t *ocm;
 
-    ocm = g_malloc0(sizeof(ppc405_ocm_t));
+    ocm = g_new0(ppc405_ocm_t, 1);
     /* XXX: Size is 4096 or 0x04000000 */
     memory_region_init_ram(&ocm->isarc_ram, NULL, "ppc405.ocm", 4 * KiB,
                            &error_fatal);
@@ -1148,7 +1148,7 @@ static void ppc4xx_gpt_init(hwaddr base, qemu_irq irqs[5])
 
     trace_ppc4xx_gpt_init(base);
 
-    gpt = g_malloc0(sizeof(ppc4xx_gpt_t));
+    gpt = g_new0(ppc4xx_gpt_t, 1);
     for (i = 0; i < 5; i++) {
         gpt->irqs[i] = irqs[i];
     }
@@ -1399,7 +1399,7 @@ static void ppc405ep_cpc_init (CPUPPCState *env, clk_setup_t clk_setup[8],
 {
     ppc405ep_cpc_t *cpc;
 
-    cpc = g_malloc0(sizeof(ppc405ep_cpc_t));
+    cpc = g_new0(ppc405ep_cpc_t, 1);
     memcpy(cpc->clk_setup, clk_setup,
            PPC405EP_CLK_NB * sizeof(clk_setup_t));
     cpc->jtagid = 0x20267049;
diff --git a/hw/ppc/ppc4xx_devs.c b/hw/ppc/ppc4xx_devs.c
index e7d82ae501..737c0896b4 100644
--- a/hw/ppc/ppc4xx_devs.c
+++ b/hw/ppc/ppc4xx_devs.c
@@ -389,7 +389,7 @@ void ppc4xx_sdram_init (CPUPPCState *env, qemu_irq irq, int nbanks,
 {
     ppc4xx_sdram_t *sdram;
 
-    sdram = g_malloc0(sizeof(ppc4xx_sdram_t));
+    sdram = g_new0(ppc4xx_sdram_t, 1);
     sdram->irq = irq;
     sdram->nbanks = nbanks;
     sdram->ram_memories = ram_memories;
diff --git a/hw/ppc/ppc_booke.c b/hw/ppc/ppc_booke.c
index 10b643861f..ca22da196a 100644
--- a/hw/ppc/ppc_booke.c
+++ b/hw/ppc/ppc_booke.c
@@ -337,8 +337,8 @@ void ppc_booke_timers_init(PowerPCCPU *cpu, uint32_t freq, uint32_t flags)
     booke_timer_t *booke_timer;
     int ret = 0;
 
-    tb_env      = g_malloc0(sizeof(ppc_tb_t));
-    booke_timer = g_malloc0(sizeof(booke_timer_t));
+    tb_env      = g_new0(ppc_tb_t, 1);
+    booke_timer = g_new0(booke_timer_t, 1);
 
     cpu->env.tb_env = tb_env;
     tb_env->flags = flags | PPC_TIMER_BOOKE | PPC_DECR_ZERO_TRIGGERED;
diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index 953fc65fa8..a4372ba189 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -3601,7 +3601,7 @@ static SpaprDimmState *spapr_pending_dimm_unplugs_add(SpaprMachineState *spapr,
      */
     ds = spapr_pending_dimm_unplugs_find(spapr, dimm);
     if (!ds) {
-        ds = g_malloc0(sizeof(SpaprDimmState));
+        ds = g_new0(SpaprDimmState, 1);
         ds->nr_lmbs = nr_lmbs;
         ds->dimm = dimm;
         QTAILQ_INSERT_HEAD(&spapr->pending_dimm_unplugs, ds, next);
diff --git a/hw/ppc/spapr_events.c b/hw/ppc/spapr_events.c
index 630e86282c..4508e40814 100644
--- a/hw/ppc/spapr_events.c
+++ b/hw/ppc/spapr_events.c
@@ -594,7 +594,7 @@ static void spapr_hotplug_req_event(uint8_t hp_id, uint8_t hp_action,
     struct rtas_event_log_v6_hp *hp;
 
     entry = g_new(SpaprEventLogEntry, 1);
-    new_hp = g_malloc0(sizeof(struct hp_extended_log));
+    new_hp = g_new0(struct hp_extended_log, 1);
     entry->extended_log = new_hp;
 
     v6hdr = &new_hp->v6hdr;
diff --git a/hw/ppc/spapr_hcall.c b/hw/ppc/spapr_hcall.c
index f008290787..7c8bb76f99 100644
--- a/hw/ppc/spapr_hcall.c
+++ b/hw/ppc/spapr_hcall.c
@@ -1596,7 +1596,7 @@ static target_ulong h_enter_nested(PowerPCCPU *cpu,
         return H_PARAMETER;
     }
 
-    spapr_cpu->nested_host_state = g_try_malloc(sizeof(CPUPPCState));
+    spapr_cpu->nested_host_state = g_try_new(CPUPPCState, 1);
     if (!spapr_cpu->nested_host_state) {
         return H_NO_MEM;
     }
diff --git a/hw/ppc/spapr_numa.c b/hw/ppc/spapr_numa.c
index 4f93bdefec..d7c0e212ba 100644
--- a/hw/ppc/spapr_numa.c
+++ b/hw/ppc/spapr_numa.c
@@ -436,8 +436,7 @@ int spapr_numa_write_assoc_lookup_arrays(SpaprMachineState *spapr, void *fdt,
     int i;
 
     /* ibm,associativity-lookup-arrays */
-    int_buf = g_malloc0((nr_nodes * max_distance_ref_points + 2) *
-                        sizeof(uint32_t));
+    int_buf = g_new0(uint32_t, nr_nodes * max_distance_ref_points + 2);
     cur_index = int_buf;
     int_buf[0] = cpu_to_be32(nr_nodes);
      /* Number of entries per associativity list */
diff --git a/hw/rdma/vmw/pvrdma_dev_ring.c b/hw/rdma/vmw/pvrdma_dev_ring.c
index 42130667a7..598e6adc5e 100644
--- a/hw/rdma/vmw/pvrdma_dev_ring.c
+++ b/hw/rdma/vmw/pvrdma_dev_ring.c
@@ -41,7 +41,7 @@ int pvrdma_ring_init(PvrdmaRing *ring, const char *name, PCIDevice *dev,
     qatomic_set(&ring->ring_state->cons_head, 0);
     */
     ring->npages = npages;
-    ring->pages = g_malloc0(npages * sizeof(void *));
+    ring->pages = g_new0(void *, npages);
 
     for (i = 0; i < npages; i++) {
         if (!tbl[i]) {
diff --git a/hw/rdma/vmw/pvrdma_qp_ops.c b/hw/rdma/vmw/pvrdma_qp_ops.c
index 8050287a6c..bd7cbf2bdf 100644
--- a/hw/rdma/vmw/pvrdma_qp_ops.c
+++ b/hw/rdma/vmw/pvrdma_qp_ops.c
@@ -154,7 +154,7 @@ void pvrdma_qp_send(PVRDMADev *dev, uint32_t qp_handle)
         CompHandlerCtx *comp_ctx;
 
         /* Prepare CQE */
-        comp_ctx = g_malloc(sizeof(CompHandlerCtx));
+        comp_ctx = g_new(CompHandlerCtx, 1);
         comp_ctx->dev = dev;
         comp_ctx->cq_handle = qp->send_cq_handle;
         comp_ctx->cqe.wr_id = wqe->hdr.wr_id;
@@ -217,7 +217,7 @@ void pvrdma_qp_recv(PVRDMADev *dev, uint32_t qp_handle)
         CompHandlerCtx *comp_ctx;
 
         /* Prepare CQE */
-        comp_ctx = g_malloc(sizeof(CompHandlerCtx));
+        comp_ctx = g_new(CompHandlerCtx, 1);
         comp_ctx->dev = dev;
         comp_ctx->cq_handle = qp->recv_cq_handle;
         comp_ctx->cqe.wr_id = wqe->hdr.wr_id;
@@ -259,7 +259,7 @@ void pvrdma_srq_recv(PVRDMADev *dev, uint32_t srq_handle)
         CompHandlerCtx *comp_ctx;
 
         /* Prepare CQE */
-        comp_ctx = g_malloc(sizeof(CompHandlerCtx));
+        comp_ctx = g_new(CompHandlerCtx, 1);
         comp_ctx->dev = dev;
         comp_ctx->cq_handle = srq->recv_cq_handle;
         comp_ctx->cqe.wr_id = wqe->hdr.wr_id;
diff --git a/hw/sh4/r2d.c b/hw/sh4/r2d.c
index 72759413f3..39fc4f19d9 100644
--- a/hw/sh4/r2d.c
+++ b/hw/sh4/r2d.c
@@ -190,7 +190,7 @@ static qemu_irq *r2d_fpga_init(MemoryRegion *sysmem,
 {
     r2d_fpga_t *s;
 
-    s = g_malloc0(sizeof(r2d_fpga_t));
+    s = g_new0(r2d_fpga_t, 1);
 
     s->irl = irl;
 
@@ -248,7 +248,7 @@ static void r2d_init(MachineState *machine)
     cpu = SUPERH_CPU(cpu_create(machine->cpu_type));
     env = &cpu->env;
 
-    reset_info = g_malloc0(sizeof(ResetData));
+    reset_info = g_new0(ResetData, 1);
     reset_info->cpu = cpu;
     reset_info->vector = env->pc;
     qemu_register_reset(main_cpu_reset, reset_info);
diff --git a/hw/sh4/sh7750.c b/hw/sh4/sh7750.c
index 43dfb6497b..c77792d150 100644
--- a/hw/sh4/sh7750.c
+++ b/hw/sh4/sh7750.c
@@ -770,7 +770,7 @@ SH7750State *sh7750_init(SuperHCPU *cpu, MemoryRegion *sysmem)
     SysBusDevice *sb;
     MemoryRegion *mr, *alias;
 
-    s = g_malloc0(sizeof(SH7750State));
+    s = g_new0(SH7750State, 1);
     s->cpu = cpu;
     s->periph_freq = 60000000; /* 60MHz */
     memory_region_init_io(&s->iomem, NULL, &sh7750_mem_ops, s,
diff --git a/hw/sparc/leon3.c b/hw/sparc/leon3.c
index 7b4dec1721..a9f2496827 100644
--- a/hw/sparc/leon3.c
+++ b/hw/sparc/leon3.c
@@ -241,7 +241,7 @@ static void leon3_generic_hw_init(MachineState *machine)
     cpu_sparc_set_id(env, 0);
 
     /* Reset data */
-    reset_info        = g_malloc0(sizeof(ResetData));
+    reset_info        = g_new0(ResetData, 1);
     reset_info->cpu   = cpu;
     reset_info->sp    = LEON3_RAM_OFFSET + ram_size;
     qemu_register_reset(main_cpu_reset, reset_info);
diff --git a/hw/sparc64/sparc64.c b/hw/sparc64/sparc64.c
index 8654e955eb..72f0849f50 100644
--- a/hw/sparc64/sparc64.c
+++ b/hw/sparc64/sparc64.c
@@ -81,7 +81,7 @@ static CPUTimer *cpu_timer_create(const char *name, SPARCCPU *cpu,
                                   QEMUBHFunc *cb, uint32_t frequency,
                                   uint64_t disabled_mask, uint64_t npt_mask)
 {
-    CPUTimer *timer = g_malloc0(sizeof(CPUTimer));
+    CPUTimer *timer = g_new0(CPUTimer, 1);
 
     timer->name = name;
     timer->frequency = frequency;
@@ -288,7 +288,7 @@ SPARCCPU *sparc64_cpu_devinit(const char *cpu_type, uint64_t prom_addr)
                                     hstick_frequency, TICK_INT_DIS,
                                     TICK_NPT_MASK);
 
-    reset_info = g_malloc0(sizeof(ResetData));
+    reset_info = g_new0(ResetData, 1);
     reset_info->cpu = cpu;
     reset_info->prom_addr = prom_addr;
     qemu_register_reset(main_cpu_reset, reset_info);
diff --git a/hw/timer/arm_timer.c b/hw/timer/arm_timer.c
index 15caff0e41..84cf2726bb 100644
--- a/hw/timer/arm_timer.c
+++ b/hw/timer/arm_timer.c
@@ -176,7 +176,7 @@ static arm_timer_state *arm_timer_init(uint32_t freq)
 {
     arm_timer_state *s;
 
-    s = (arm_timer_state *)g_malloc0(sizeof(arm_timer_state));
+    s = g_new0(arm_timer_state, 1);
     s->freq = freq;
     s->control = TIMER_CTRL_IE;
 
diff --git a/hw/timer/slavio_timer.c b/hw/timer/slavio_timer.c
index 03e33fc592..90fdce4c44 100644
--- a/hw/timer/slavio_timer.c
+++ b/hw/timer/slavio_timer.c
@@ -400,7 +400,7 @@ static void slavio_timer_init(Object *obj)
         uint64_t size;
         char timer_name[20];
 
-        tc = g_malloc0(sizeof(TimerContext));
+        tc = g_new0(TimerContext, 1);
         tc->s = s;
         tc->timer_index = i;
 
diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 7b45353ce2..436b5cbcb1 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -1529,8 +1529,8 @@ static int vfio_msix_setup(VFIOPCIDevice *vdev, int pos, Error **errp)
     int ret;
     Error *err = NULL;
 
-    vdev->msix->pending = g_malloc0(BITS_TO_LONGS(vdev->msix->entries) *
-                                    sizeof(unsigned long));
+    vdev->msix->pending = g_new0(unsigned long,
+                                 BITS_TO_LONGS(vdev->msix->entries));
     ret = msix_init(&vdev->pdev, vdev->msix->entries,
                     vdev->bars[vdev->msix->table_bar].mr,
                     vdev->msix->table_bar, vdev->msix->table_offset,
diff --git a/hw/vfio/platform.c b/hw/vfio/platform.c
index f8f08a0f36..5af73f9287 100644
--- a/hw/vfio/platform.c
+++ b/hw/vfio/platform.c
@@ -71,7 +71,7 @@ static VFIOINTp *vfio_init_intp(VFIODevice *vbasedev,
     sysbus_init_irq(sbdev, &intp->qemuirq);
 
     /* Get an eventfd for trigger */
-    intp->interrupt = g_malloc0(sizeof(EventNotifier));
+    intp->interrupt = g_new0(EventNotifier, 1);
     ret = event_notifier_init(intp->interrupt, 0);
     if (ret) {
         g_free(intp->interrupt);
@@ -82,7 +82,7 @@ static VFIOINTp *vfio_init_intp(VFIODevice *vbasedev,
     }
     if (vfio_irq_is_automasked(intp)) {
         /* Get an eventfd for resample/unmask */
-        intp->unmask = g_malloc0(sizeof(EventNotifier));
+        intp->unmask = g_new0(EventNotifier, 1);
         ret = event_notifier_init(intp->unmask, 0);
         if (ret) {
             g_free(intp->interrupt);
diff --git a/hw/virtio/virtio-crypto.c b/hw/virtio/virtio-crypto.c
index 54f9bbb789..dcd80b904d 100644
--- a/hw/virtio/virtio-crypto.c
+++ b/hw/virtio/virtio-crypto.c
@@ -812,7 +812,7 @@ static void virtio_crypto_device_realize(DeviceState *dev, Error **errp)
 
     virtio_init(vdev, "virtio-crypto", VIRTIO_ID_CRYPTO, vcrypto->config_size);
     vcrypto->curr_queues = 1;
-    vcrypto->vqs = g_malloc0(sizeof(VirtIOCryptoQueue) * vcrypto->max_queues);
+    vcrypto->vqs = g_new0(VirtIOCryptoQueue, vcrypto->max_queues);
     for (i = 0; i < vcrypto->max_queues; i++) {
         vcrypto->vqs[i].dataq =
                  virtio_add_queue(vdev, 1024, virtio_crypto_handle_dataq_bh);
diff --git a/hw/virtio/virtio-iommu.c b/hw/virtio/virtio-iommu.c
index 239fe97b12..664cbd9583 100644
--- a/hw/virtio/virtio-iommu.c
+++ b/hw/virtio/virtio-iommu.c
@@ -316,7 +316,7 @@ static AddressSpace *virtio_iommu_find_add_as(PCIBus *bus, void *opaque,
         char *name = g_strdup_printf("%s-%d-%d",
                                      TYPE_VIRTIO_IOMMU_MEMORY_REGION,
                                      mr_index++, devfn);
-        sdev = sbus->pbdev[devfn] = g_malloc0(sizeof(IOMMUDevice));
+        sdev = sbus->pbdev[devfn] = g_new0(IOMMUDevice, 1);
 
         sdev->viommu = s;
         sdev->bus = bus;
diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index 9e8f51dfb0..32b1859391 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -2380,8 +2380,7 @@ VirtQueue *virtio_add_queue(VirtIODevice *vdev, int queue_size,
     vdev->vq[i].vring.num_default = queue_size;
     vdev->vq[i].vring.align = VIRTIO_PCI_VRING_ALIGN;
     vdev->vq[i].handle_output = handle_output;
-    vdev->vq[i].used_elems = g_malloc0(sizeof(VirtQueueElement) *
-                                       queue_size);
+    vdev->vq[i].used_elems = g_new0(VirtQueueElement, queue_size);
 
     return &vdev->vq[i];
 }
@@ -3228,7 +3227,7 @@ void virtio_init(VirtIODevice *vdev, const char *name,
     qatomic_set(&vdev->isr, 0);
     vdev->queue_sel = 0;
     vdev->config_vector = VIRTIO_NO_VECTOR;
-    vdev->vq = g_malloc0(sizeof(VirtQueue) * VIRTIO_QUEUE_MAX);
+    vdev->vq = g_new0(VirtQueue, VIRTIO_QUEUE_MAX);
     vdev->vm_running = runstate_is_running();
     vdev->broken = false;
     for (i = 0; i < VIRTIO_QUEUE_MAX; i++) {
diff --git a/hw/xtensa/xtfpga.c b/hw/xtensa/xtfpga.c
index 17f087b395..c1e004e882 100644
--- a/hw/xtensa/xtfpga.c
+++ b/hw/xtensa/xtfpga.c
@@ -126,7 +126,7 @@ static const MemoryRegionOps xtfpga_fpga_ops = {
 static XtfpgaFpgaState *xtfpga_fpga_init(MemoryRegion *address_space,
                                          hwaddr base, uint32_t freq)
 {
-    XtfpgaFpgaState *s = g_malloc(sizeof(XtfpgaFpgaState));
+    XtfpgaFpgaState *s = g_new(XtfpgaFpgaState, 1);
 
     memory_region_init_io(&s->iomem, NULL, &xtfpga_fpga_ops, s,
                           "xtfpga.fpga", 0x10000);
diff --git a/linux-user/syscall.c b/linux-user/syscall.c
index b9b18a7eaf..75ed71eb46 100644
--- a/linux-user/syscall.c
+++ b/linux-user/syscall.c
@@ -5076,7 +5076,7 @@ do_ioctl_usbdevfs_submiturb(const IOCTLEntry *ie, uint8_t *buf_temp,
     target_size = thunk_type_size(arg_type, THUNK_TARGET);
 
     /* construct host copy of urb and metadata */
-    lurb = g_try_malloc0(sizeof(struct live_urb));
+    lurb = g_try_new0(struct live_urb, 1);
     if (!lurb) {
         return -TARGET_ENOMEM;
     }
diff --git a/migration/dirtyrate.c b/migration/dirtyrate.c
index d65e744af9..aace12a787 100644
--- a/migration/dirtyrate.c
+++ b/migration/dirtyrate.c
@@ -91,7 +91,7 @@ static struct DirtyRateInfo *query_dirty_rate_info(void)
 {
     int i;
     int64_t dirty_rate = DirtyStat.dirty_rate;
-    struct DirtyRateInfo *info = g_malloc0(sizeof(DirtyRateInfo));
+    struct DirtyRateInfo *info = g_new0(DirtyRateInfo, 1);
     DirtyRateVcpuList *head = NULL, **tail = &head;
 
     info->status = CalculatingState;
@@ -112,7 +112,7 @@ static struct DirtyRateInfo *query_dirty_rate_info(void)
             info->sample_pages = 0;
             info->has_vcpu_dirty_rate = true;
             for (i = 0; i < DirtyStat.dirty_ring.nvcpu; i++) {
-                DirtyRateVcpu *rate = g_malloc0(sizeof(DirtyRateVcpu));
+                DirtyRateVcpu *rate = g_new0(DirtyRateVcpu, 1);
                 rate->id = DirtyStat.dirty_ring.rates[i].id;
                 rate->dirty_rate = DirtyStat.dirty_ring.rates[i].dirty_rate;
                 QAPI_LIST_APPEND(tail, rate);
diff --git a/migration/multifd-zlib.c b/migration/multifd-zlib.c
index aba1c88a0c..3a7ae44485 100644
--- a/migration/multifd-zlib.c
+++ b/migration/multifd-zlib.c
@@ -43,7 +43,7 @@ struct zlib_data {
  */
 static int zlib_send_setup(MultiFDSendParams *p, Error **errp)
 {
-    struct zlib_data *z = g_malloc0(sizeof(struct zlib_data));
+    struct zlib_data *z = g_new0(struct zlib_data, 1);
     z_stream *zs = &z->zs;
 
     zs->zalloc = Z_NULL;
@@ -164,7 +164,7 @@ static int zlib_send_prepare(MultiFDSendParams *p, Error **errp)
  */
 static int zlib_recv_setup(MultiFDRecvParams *p, Error **errp)
 {
-    struct zlib_data *z = g_malloc0(sizeof(struct zlib_data));
+    struct zlib_data *z = g_new0(struct zlib_data, 1);
     z_stream *zs = &z->zs;
 
     p->data = z;
diff --git a/migration/ram.c b/migration/ram.c
index 170e522a1f..3532f64ecb 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -2059,7 +2059,7 @@ int ram_save_queue_pages(const char *rbname, ram_addr_t start, ram_addr_t len)
     }
 
     struct RAMSrcPageRequest *new_entry =
-        g_malloc0(sizeof(struct RAMSrcPageRequest));
+        g_new0(struct RAMSrcPageRequest, 1);
     new_entry->rb = ramblock;
     new_entry->offset = start;
     new_entry->len = len;
diff --git a/monitor/misc.c b/monitor/misc.c
index b1839cb8ee..a756dbd6db 100644
--- a/monitor/misc.c
+++ b/monitor/misc.c
@@ -1028,7 +1028,7 @@ void qmp_getfd(const char *fdname, Error **errp)
         return;
     }
 
-    monfd = g_malloc0(sizeof(mon_fd_t));
+    monfd = g_new0(mon_fd_t, 1);
     monfd->name = g_strdup(fdname);
     monfd->fd = fd;
 
diff --git a/monitor/qmp-cmds.c b/monitor/qmp-cmds.c
index ad82c275c4..0b04855ce8 100644
--- a/monitor/qmp-cmds.c
+++ b/monitor/qmp-cmds.c
@@ -318,7 +318,7 @@ ACPIOSTInfoList *qmp_query_acpi_ospm_status(Error **errp)
 
 MemoryInfo *qmp_query_memory_size_summary(Error **errp)
 {
-    MemoryInfo *mem_info = g_malloc0(sizeof(MemoryInfo));
+    MemoryInfo *mem_info = g_new0(MemoryInfo, 1);
     MachineState *ms = MACHINE(qdev_get_machine());
 
     mem_info->base_memory = ms->ram_size;
diff --git a/qga/commands-win32.c b/qga/commands-win32.c
index 4fbbad793f..3c428213db 100644
--- a/qga/commands-win32.c
+++ b/qga/commands-win32.c
@@ -949,7 +949,7 @@ static GuestDiskAddressList *build_guest_disk_info(char *guid, Error **errp)
         } else if (last_err == ERROR_INVALID_FUNCTION) {
             /* Possibly CD-ROM or a shared drive. Try to pass the volume */
             g_debug("volume not on disk");
-            disk = g_malloc0(sizeof(GuestDiskAddress));
+            disk = g_new0(GuestDiskAddress, 1);
             disk->has_dev = true;
             disk->dev = g_strdup(name);
             get_single_disk_info(0xffffffff, disk, &local_err);
@@ -972,7 +972,7 @@ static GuestDiskAddressList *build_guest_disk_info(char *guid, Error **errp)
 
     /* Go through each extent */
     for (i = 0; i < extents->NumberOfDiskExtents; i++) {
-        disk = g_malloc0(sizeof(GuestDiskAddress));
+        disk = g_new0(GuestDiskAddress, 1);
 
         /* Disk numbers directly correspond to numbers used in UNCs
          *
@@ -1076,7 +1076,7 @@ GuestDiskInfoList *qmp_guest_get_disks(Error **errp)
             sdn.DeviceNumber);
 
         g_debug("  number: %lu", sdn.DeviceNumber);
-        address = g_malloc0(sizeof(GuestDiskAddress));
+        address = g_new0(GuestDiskAddress, 1);
         address->has_dev = true;
         address->dev = g_strdup(disk->name);
         get_single_disk_info(sdn.DeviceNumber, address, &local_err);
@@ -1368,7 +1368,7 @@ qmp_guest_fstrim(bool has_minimum, int64_t minimum, Error **errp)
             continue;
         }
 
-        uc_path = g_malloc(sizeof(WCHAR) * char_count);
+        uc_path = g_new(WCHAR, char_count);
         if (!GetVolumePathNamesForVolumeNameW(guid, uc_path, char_count,
                                               &char_count) || !*uc_path) {
             /* strange, but this condition could be faced even with size == 2 */
diff --git a/qga/commands.c b/qga/commands.c
index 80501e4a73..72e6022207 100644
--- a/qga/commands.c
+++ b/qga/commands.c
@@ -244,7 +244,7 @@ static char **guest_exec_get_args(const strList *entry, bool log)
 
     str = g_malloc(str_size);
     *str = 0;
-    args = g_malloc(count * sizeof(char *));
+    args = g_new(char *, count);
     for (it = entry; it != NULL; it = it->next) {
         args[i++] = it->value;
         pstrcat(str, str_size, it->value);
diff --git a/qom/qom-qmp-cmds.c b/qom/qom-qmp-cmds.c
index 2d6f41ecc7..2e63a4c184 100644
--- a/qom/qom-qmp-cmds.c
+++ b/qom/qom-qmp-cmds.c
@@ -49,7 +49,7 @@ ObjectPropertyInfoList *qmp_qom_list(const char *path, Error **errp)
 
     object_property_iter_init(&iter, obj);
     while ((prop = object_property_iter_next(&iter))) {
-        ObjectPropertyInfo *value = g_malloc0(sizeof(ObjectPropertyInfo));
+        ObjectPropertyInfo *value = g_new0(ObjectPropertyInfo, 1);
 
         QAPI_LIST_PREPEND(props, value);
 
diff --git a/replay/replay-char.c b/replay/replay-char.c
index dc0002367e..d2025948cf 100644
--- a/replay/replay-char.c
+++ b/replay/replay-char.c
@@ -50,7 +50,7 @@ void replay_register_char_driver(Chardev *chr)
 
 void replay_chr_be_write(Chardev *s, uint8_t *buf, int len)
 {
-    CharEvent *event = g_malloc0(sizeof(CharEvent));
+    CharEvent *event = g_new0(CharEvent, 1);
 
     event->id = find_char_driver(s);
     if (event->id < 0) {
@@ -85,7 +85,7 @@ void replay_event_char_read_save(void *opaque)
 
 void *replay_event_char_read_load(void)
 {
-    CharEvent *event = g_malloc0(sizeof(CharEvent));
+    CharEvent *event = g_new0(CharEvent, 1);
 
     event->id = replay_get_byte();
     replay_get_array_alloc(&event->buf, &event->len);
diff --git a/replay/replay-events.c b/replay/replay-events.c
index 15983dd250..ac47c89834 100644
--- a/replay/replay-events.c
+++ b/replay/replay-events.c
@@ -119,7 +119,7 @@ void replay_add_event(ReplayAsyncEventKind event_kind,
         return;
     }
 
-    Event *event = g_malloc0(sizeof(Event));
+    Event *event = g_new0(Event, 1);
     event->event_kind = event_kind;
     event->opaque = opaque;
     event->opaque2 = opaque2;
@@ -243,17 +243,17 @@ static Event *replay_read_event(int checkpoint)
         }
         break;
     case REPLAY_ASYNC_EVENT_INPUT:
-        event = g_malloc0(sizeof(Event));
+        event = g_new0(Event, 1);
         event->event_kind = replay_state.read_event_kind;
         event->opaque = replay_read_input_event();
         return event;
     case REPLAY_ASYNC_EVENT_INPUT_SYNC:
-        event = g_malloc0(sizeof(Event));
+        event = g_new0(Event, 1);
         event->event_kind = replay_state.read_event_kind;
         event->opaque = 0;
         return event;
     case REPLAY_ASYNC_EVENT_CHAR_READ:
-        event = g_malloc0(sizeof(Event));
+        event = g_new0(Event, 1);
         event->event_kind = replay_state.read_event_kind;
         event->opaque = replay_event_char_read_load();
         return event;
@@ -263,7 +263,7 @@ static Event *replay_read_event(int checkpoint)
         }
         break;
     case REPLAY_ASYNC_EVENT_NET:
-        event = g_malloc0(sizeof(Event));
+        event = g_new0(Event, 1);
         event->event_kind = replay_state.read_event_kind;
         event->opaque = replay_event_net_load();
         return event;
diff --git a/softmmu/bootdevice.c b/softmmu/bootdevice.c
index add4e3d2d1..c0713bfa9f 100644
--- a/softmmu/bootdevice.c
+++ b/softmmu/bootdevice.c
@@ -166,7 +166,7 @@ void add_boot_device_path(int32_t bootindex, DeviceState *dev,
 
     del_boot_device_path(dev, suffix);
 
-    node = g_malloc0(sizeof(FWBootEntry));
+    node = g_new0(FWBootEntry, 1);
     node->bootindex = bootindex;
     node->suffix = g_strdup(suffix);
     node->dev = dev;
@@ -367,7 +367,7 @@ void add_boot_device_lchs(DeviceState *dev, const char *suffix,
 
     assert(dev != NULL || suffix != NULL);
 
-    node = g_malloc0(sizeof(FWLCHSEntry));
+    node = g_new0(FWLCHSEntry, 1);
     node->suffix = g_strdup(suffix);
     node->dev = dev;
     node->lcyls = lcyls;
diff --git a/softmmu/dma-helpers.c b/softmmu/dma-helpers.c
index 160095e4ba..7820fec54c 100644
--- a/softmmu/dma-helpers.c
+++ b/softmmu/dma-helpers.c
@@ -29,7 +29,7 @@ MemTxResult dma_memory_set(AddressSpace *as, dma_addr_t addr,
 void qemu_sglist_init(QEMUSGList *qsg, DeviceState *dev, int alloc_hint,
                       AddressSpace *as)
 {
-    qsg->sg = g_malloc(alloc_hint * sizeof(ScatterGatherEntry));
+    qsg->sg = g_new(ScatterGatherEntry, alloc_hint);
     qsg->nsg = 0;
     qsg->nalloc = alloc_hint;
     qsg->size = 0;
@@ -42,7 +42,7 @@ void qemu_sglist_add(QEMUSGList *qsg, dma_addr_t base, dma_addr_t len)
 {
     if (qsg->nsg == qsg->nalloc) {
         qsg->nalloc = 2 * qsg->nalloc + 1;
-        qsg->sg = g_realloc(qsg->sg, qsg->nalloc * sizeof(ScatterGatherEntry));
+        qsg->sg = g_renew(ScatterGatherEntry, qsg->sg, qsg->nalloc);
     }
     qsg->sg[qsg->nsg].base = base;
     qsg->sg[qsg->nsg].len = len;
diff --git a/softmmu/memory_mapping.c b/softmmu/memory_mapping.c
index 8320165ea2..f6f0a829fd 100644
--- a/softmmu/memory_mapping.c
+++ b/softmmu/memory_mapping.c
@@ -42,7 +42,7 @@ static void create_new_memory_mapping(MemoryMappingList *list,
 {
     MemoryMapping *memory_mapping;
 
-    memory_mapping = g_malloc(sizeof(MemoryMapping));
+    memory_mapping = g_new(MemoryMapping, 1);
     memory_mapping->phys_addr = phys_addr;
     memory_mapping->virt_addr = virt_addr;
     memory_mapping->length = length;
diff --git a/target/i386/cpu-sysemu.c b/target/i386/cpu-sysemu.c
index 37b7c562f5..e254d8ba10 100644
--- a/target/i386/cpu-sysemu.c
+++ b/target/i386/cpu-sysemu.c
@@ -313,7 +313,7 @@ GuestPanicInformation *x86_cpu_get_crash_info(CPUState *cs)
     GuestPanicInformation *panic_info = NULL;
 
     if (hyperv_feat_enabled(cpu, HYPERV_FEAT_CRASH)) {
-        panic_info = g_malloc0(sizeof(GuestPanicInformation));
+        panic_info = g_new0(GuestPanicInformation, 1);
 
         panic_info->type = GUEST_PANIC_INFORMATION_TYPE_HYPER_V;
 
diff --git a/target/i386/hax/hax-accel-ops.c b/target/i386/hax/hax-accel-ops.c
index 136630e9b2..18114fe34d 100644
--- a/target/i386/hax/hax-accel-ops.c
+++ b/target/i386/hax/hax-accel-ops.c
@@ -61,8 +61,8 @@ static void hax_start_vcpu_thread(CPUState *cpu)
 {
     char thread_name[VCPU_THREAD_NAME_SIZE];
 
-    cpu->thread = g_malloc0(sizeof(QemuThread));
-    cpu->halt_cond = g_malloc0(sizeof(QemuCond));
+    cpu->thread = g_new0(QemuThread, 1);
+    cpu->halt_cond = g_new0(QemuCond, 1);
     qemu_cond_init(cpu->halt_cond);
 
     snprintf(thread_name, VCPU_THREAD_NAME_SIZE, "CPU %d/HAX",
diff --git a/target/i386/nvmm/nvmm-accel-ops.c b/target/i386/nvmm/nvmm-accel-ops.c
index f788f75289..6c46101ac1 100644
--- a/target/i386/nvmm/nvmm-accel-ops.c
+++ b/target/i386/nvmm/nvmm-accel-ops.c
@@ -64,8 +64,8 @@ static void nvmm_start_vcpu_thread(CPUState *cpu)
 {
     char thread_name[VCPU_THREAD_NAME_SIZE];
 
-    cpu->thread = g_malloc0(sizeof(QemuThread));
-    cpu->halt_cond = g_malloc0(sizeof(QemuCond));
+    cpu->thread = g_new0(QemuThread, 1);
+    cpu->halt_cond = g_new0(QemuCond, 1);
     qemu_cond_init(cpu->halt_cond);
     snprintf(thread_name, VCPU_THREAD_NAME_SIZE, "CPU %d/NVMM",
              cpu->cpu_index);
diff --git a/target/i386/whpx/whpx-accel-ops.c b/target/i386/whpx/whpx-accel-ops.c
index 1d30e4e2ed..dd2a9f7657 100644
--- a/target/i386/whpx/whpx-accel-ops.c
+++ b/target/i386/whpx/whpx-accel-ops.c
@@ -64,8 +64,8 @@ static void whpx_start_vcpu_thread(CPUState *cpu)
 {
     char thread_name[VCPU_THREAD_NAME_SIZE];
 
-    cpu->thread = g_malloc0(sizeof(QemuThread));
-    cpu->halt_cond = g_malloc0(sizeof(QemuCond));
+    cpu->thread = g_new0(QemuThread, 1);
+    cpu->halt_cond = g_new0(QemuCond, 1);
     qemu_cond_init(cpu->halt_cond);
     snprintf(thread_name, VCPU_THREAD_NAME_SIZE, "CPU %d/WHPX",
              cpu->cpu_index);
diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index c7e25abf42..9fd287e5d4 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -1354,7 +1354,7 @@ int whpx_init_vcpu(CPUState *cpu)
         }
     }
 
-    vcpu = g_malloc0(sizeof(struct whpx_vcpu));
+    vcpu = g_new0(struct whpx_vcpu, 1);
 
     if (!vcpu) {
         error_report("WHPX: Failed to allocte VCPU context.");
diff --git a/target/s390x/cpu-sysemu.c b/target/s390x/cpu-sysemu.c
index 5471e01ee8..948e4bd3e0 100644
--- a/target/s390x/cpu-sysemu.c
+++ b/target/s390x/cpu-sysemu.c
@@ -76,7 +76,7 @@ static GuestPanicInformation *s390_cpu_get_crash_info(CPUState *cs)
     S390CPU *cpu = S390_CPU(cs);
 
     cpu_synchronize_state(cs);
-    panic_info = g_malloc0(sizeof(GuestPanicInformation));
+    panic_info = g_new0(GuestPanicInformation, 1);
 
     panic_info->type = GUEST_PANIC_INFORMATION_TYPE_S390;
     panic_info->u.s390.core = cpu->env.core_id;
diff --git a/tests/unit/test-hbitmap.c b/tests/unit/test-hbitmap.c
index b6726cf76b..a4fe067917 100644
--- a/tests/unit/test-hbitmap.c
+++ b/tests/unit/test-hbitmap.c
@@ -113,7 +113,7 @@ static void hbitmap_test_truncate_impl(TestHBitmapData *data,
 
     n = hbitmap_test_array_size(size);
     m = hbitmap_test_array_size(data->old_size);
-    data->bits = g_realloc(data->bits, sizeof(unsigned long) * n);
+    data->bits = g_renew(unsigned long, data->bits, n);
     if (n > m) {
         memset(&data->bits[m], 0x00, sizeof(unsigned long) * (n - m));
     }
diff --git a/tests/unit/test-qmp-cmds.c b/tests/unit/test-qmp-cmds.c
index faa858624a..6085c09995 100644
--- a/tests/unit/test-qmp-cmds.c
+++ b/tests/unit/test-qmp-cmds.c
@@ -82,8 +82,8 @@ UserDefTwo *qmp_user_def_cmd2(UserDefOne *ud1a,
                               Error **errp)
 {
     UserDefTwo *ret;
-    UserDefOne *ud1c = g_malloc0(sizeof(UserDefOne));
-    UserDefOne *ud1d = g_malloc0(sizeof(UserDefOne));
+    UserDefOne *ud1c = g_new0(UserDefOne, 1);
+    UserDefOne *ud1d = g_new0(UserDefOne, 1);
 
     ud1c->string = strdup(ud1a->string);
     ud1c->integer = ud1a->integer;
@@ -344,23 +344,23 @@ static void test_dealloc_types(void)
     UserDefOne *ud1test, *ud1a, *ud1b;
     UserDefOneList *ud1list;
 
-    ud1test = g_malloc0(sizeof(UserDefOne));
+    ud1test = g_new0(UserDefOne, 1);
     ud1test->integer = 42;
     ud1test->string = g_strdup("hi there 42");
 
     qapi_free_UserDefOne(ud1test);
 
-    ud1a = g_malloc0(sizeof(UserDefOne));
+    ud1a = g_new0(UserDefOne, 1);
     ud1a->integer = 43;
     ud1a->string = g_strdup("hi there 43");
 
-    ud1b = g_malloc0(sizeof(UserDefOne));
+    ud1b = g_new0(UserDefOne, 1);
     ud1b->integer = 44;
     ud1b->string = g_strdup("hi there 44");
 
-    ud1list = g_malloc0(sizeof(UserDefOneList));
+    ud1list = g_new0(UserDefOneList, 1);
     ud1list->value = ud1a;
-    ud1list->next = g_malloc0(sizeof(UserDefOneList));
+    ud1list->next = g_new0(UserDefOneList, 1);
     ud1list->next->value = ud1b;
 
     qapi_free_UserDefOneList(ud1list);
diff --git a/tests/unit/test-qobject-output-visitor.c b/tests/unit/test-qobject-output-visitor.c
index 34d67a439a..6af4c33eec 100644
--- a/tests/unit/test-qobject-output-visitor.c
+++ b/tests/unit/test-qobject-output-visitor.c
@@ -338,7 +338,7 @@ static void test_visitor_out_union_flat(TestOutputVisitorData *data,
 {
     QDict *qdict;
 
-    UserDefFlatUnion *tmp = g_malloc0(sizeof(UserDefFlatUnion));
+    UserDefFlatUnion *tmp = g_new0(UserDefFlatUnion, 1);
     tmp->enum1 = ENUM_ONE_VALUE1;
     tmp->string = g_strdup("str");
     tmp->integer = 41;
diff --git a/tests/unit/test-vmstate.c b/tests/unit/test-vmstate.c
index 4688c03ea7..6a417bb102 100644
--- a/tests/unit/test-vmstate.c
+++ b/tests/unit/test-vmstate.c
@@ -1002,22 +1002,22 @@ static TestGTreeDomain *create_first_domain(void)
     TestGTreeMapping *map_a, *map_b;
     TestGTreeInterval *a, *b;
 
-    domain = g_malloc0(sizeof(TestGTreeDomain));
+    domain = g_new0(TestGTreeDomain, 1);
     domain->id = 6;
 
-    a = g_malloc0(sizeof(TestGTreeInterval));
+    a = g_new0(TestGTreeInterval, 1);
     a->low = 0x1000;
     a->high = 0x1FFF;
 
-    b = g_malloc0(sizeof(TestGTreeInterval));
+    b = g_new0(TestGTreeInterval, 1);
     b->low = 0x4000;
     b->high = 0x4FFF;
 
-    map_a = g_malloc0(sizeof(TestGTreeMapping));
+    map_a = g_new0(TestGTreeMapping, 1);
     map_a->phys_addr = 0xa000;
     map_a->flags = 1;
 
-    map_b = g_malloc0(sizeof(TestGTreeMapping));
+    map_b = g_new0(TestGTreeMapping, 1);
     map_b->phys_addr = 0xe0000;
     map_b->flags = 2;
 
@@ -1120,7 +1120,7 @@ static void diff_iommu(TestGTreeIOMMU *iommu1, TestGTreeIOMMU *iommu2)
 
 static void test_gtree_load_domain(void)
 {
-    TestGTreeDomain *dest_domain = g_malloc0(sizeof(TestGTreeDomain));
+    TestGTreeDomain *dest_domain = g_new0(TestGTreeDomain, 1);
     TestGTreeDomain *orig_domain = create_first_domain();
     QEMUFile *fload, *fsave;
     char eof;
@@ -1185,7 +1185,7 @@ uint8_t iommu_dump[] = {
 
 static TestGTreeIOMMU *create_iommu(void)
 {
-    TestGTreeIOMMU *iommu = g_malloc0(sizeof(TestGTreeIOMMU));
+    TestGTreeIOMMU *iommu = g_new0(TestGTreeIOMMU, 1);
     TestGTreeDomain *first_domain = create_first_domain();
     TestGTreeDomain *second_domain;
     TestGTreeMapping *map_c;
@@ -1196,7 +1196,7 @@ static TestGTreeIOMMU *create_iommu(void)
                                      NULL,
                                      destroy_domain);
 
-    second_domain = g_malloc0(sizeof(TestGTreeDomain));
+    second_domain = g_new0(TestGTreeDomain, 1);
     second_domain->id = 5;
     second_domain->mappings = g_tree_new_full((GCompareDataFunc)interval_cmp,
                                               NULL,
@@ -1206,11 +1206,11 @@ static TestGTreeIOMMU *create_iommu(void)
     g_tree_insert(iommu->domains, GUINT_TO_POINTER(6), first_domain);
     g_tree_insert(iommu->domains, (gpointer)0x0000000000000005, second_domain);
 
-    c = g_malloc0(sizeof(TestGTreeInterval));
+    c = g_new0(TestGTreeInterval, 1);
     c->low = 0x1000000;
     c->high = 0x1FFFFFF;
 
-    map_c = g_malloc0(sizeof(TestGTreeMapping));
+    map_c = g_new0(TestGTreeMapping, 1);
     map_c->phys_addr = 0xF000000;
     map_c->flags = 0x3;
 
@@ -1235,7 +1235,7 @@ static void test_gtree_save_iommu(void)
 
 static void test_gtree_load_iommu(void)
 {
-    TestGTreeIOMMU *dest_iommu = g_malloc0(sizeof(TestGTreeIOMMU));
+    TestGTreeIOMMU *dest_iommu = g_new0(TestGTreeIOMMU, 1);
     TestGTreeIOMMU *orig_iommu = create_iommu();
     QEMUFile *fsave, *fload;
     char eof;
@@ -1274,11 +1274,11 @@ static uint8_t qlist_dump[] = {
 
 static TestQListContainer *alloc_container(void)
 {
-    TestQListElement *a = g_malloc(sizeof(TestQListElement));
-    TestQListElement *b = g_malloc(sizeof(TestQListElement));
-    TestQListElement *c = g_malloc(sizeof(TestQListElement));
-    TestQListElement *d = g_malloc(sizeof(TestQListElement));
-    TestQListContainer *container = g_malloc(sizeof(TestQListContainer));
+    TestQListElement *a = g_new(TestQListElement, 1);
+    TestQListElement *b = g_new(TestQListElement, 1);
+    TestQListElement *c = g_new(TestQListElement, 1);
+    TestQListElement *d = g_new(TestQListElement, 1);
+    TestQListContainer *container = g_new(TestQListContainer, 1);
 
     a->id = 0x0a;
     b->id = 0x0b00;
@@ -1332,11 +1332,11 @@ static void manipulate_container(TestQListContainer *c)
      TestQListElement *prev = NULL, *iter = QLIST_FIRST(&c->list);
      TestQListElement *elem;
 
-     elem = g_malloc(sizeof(TestQListElement));
+     elem = g_new(TestQListElement, 1);
      elem->id = 0x12;
      QLIST_INSERT_AFTER(iter, elem, next);
 
-     elem = g_malloc(sizeof(TestQListElement));
+     elem = g_new(TestQListElement, 1);
      elem->id = 0x13;
      QLIST_INSERT_HEAD(&c->list, elem, next);
 
@@ -1345,11 +1345,11 @@ static void manipulate_container(TestQListContainer *c)
         iter = QLIST_NEXT(iter, next);
      }
 
-     elem = g_malloc(sizeof(TestQListElement));
+     elem = g_new(TestQListElement, 1);
      elem->id = 0x14;
      QLIST_INSERT_BEFORE(prev, elem, next);
 
-     elem = g_malloc(sizeof(TestQListElement));
+     elem = g_new(TestQListElement, 1);
      elem->id = 0x15;
      QLIST_INSERT_AFTER(prev, elem, next);
 
@@ -1370,7 +1370,7 @@ static void test_load_qlist(void)
 {
     QEMUFile *fsave, *fload;
     TestQListContainer *orig_container = alloc_container();
-    TestQListContainer *dest_container = g_malloc0(sizeof(TestQListContainer));
+    TestQListContainer *dest_container = g_new0(TestQListContainer, 1);
     char eof;
 
     QLIST_INIT(&dest_container->list);
diff --git a/ui/vnc-enc-tight.c b/ui/vnc-enc-tight.c
index cebd35841a..7b86a4713d 100644
--- a/ui/vnc-enc-tight.c
+++ b/ui/vnc-enc-tight.c
@@ -1477,7 +1477,7 @@ static int send_sub_rect(VncState *vs, int x, int y, int w, int h)
 #endif
 
     if (!color_count_palette) {
-        color_count_palette = g_malloc(sizeof(VncPalette));
+        color_count_palette = g_new(VncPalette, 1);
         vnc_tight_cleanup_notifier.notify = vnc_tight_cleanup;
         qemu_thread_atexit_add(&vnc_tight_cleanup_notifier);
     }
diff --git a/util/envlist.c b/util/envlist.c
index 2bcc13f094..ab5553498a 100644
--- a/util/envlist.c
+++ b/util/envlist.c
@@ -217,7 +217,7 @@ envlist_to_environ(const envlist_t *envlist, size_t *count)
 	struct envlist_entry *entry;
 	char **env, **penv;
 
-	penv = env = g_malloc((envlist->el_count + 1) * sizeof(char *));
+	penv = env = g_new(char *, envlist->el_count + 1);
 
 	for (entry = envlist->el_entries.lh_first; entry != NULL;
 	    entry = entry->ev_link.le_next) {
diff --git a/util/hbitmap.c b/util/hbitmap.c
index dd0501d9a7..ea989e1f0e 100644
--- a/util/hbitmap.c
+++ b/util/hbitmap.c
@@ -862,7 +862,7 @@ void hbitmap_truncate(HBitmap *hb, uint64_t size)
         }
         old = hb->sizes[i];
         hb->sizes[i] = size;
-        hb->levels[i] = g_realloc(hb->levels[i], size * sizeof(unsigned long));
+        hb->levels[i] = g_renew(unsigned long, hb->levels[i], size);
         if (!shrink) {
             memset(&hb->levels[i][old], 0x00,
                    (size - old) * sizeof(*hb->levels[i]));
diff --git a/util/main-loop.c b/util/main-loop.c
index 4d5a5b9943..b7b0ce4ca0 100644
--- a/util/main-loop.c
+++ b/util/main-loop.c
@@ -273,7 +273,7 @@ static PollingEntry *first_polling_entry;
 int qemu_add_polling_cb(PollingFunc *func, void *opaque)
 {
     PollingEntry **ppe, *pe;
-    pe = g_malloc0(sizeof(PollingEntry));
+    pe = g_new0(PollingEntry, 1);
     pe->func = func;
     pe->opaque = opaque;
     for(ppe = &first_polling_entry; *ppe != NULL; ppe = &(*ppe)->next);
diff --git a/util/qemu-timer.c b/util/qemu-timer.c
index f36c75e594..a670a57881 100644
--- a/util/qemu-timer.c
+++ b/util/qemu-timer.c
@@ -100,7 +100,7 @@ QEMUTimerList *timerlist_new(QEMUClockType type,
     QEMUTimerList *timer_list;
     QEMUClock *clock = qemu_clock_ptr(type);
 
-    timer_list = g_malloc0(sizeof(QEMUTimerList));
+    timer_list = g_new0(QEMUTimerList, 1);
     qemu_event_init(&timer_list->timers_done_ev, true);
     timer_list->clock = clock;
     timer_list->notify_cb = cb;
diff --git a/util/vfio-helpers.c b/util/vfio-helpers.c
index 00a80431a0..b037d5faa5 100644
--- a/util/vfio-helpers.c
+++ b/util/vfio-helpers.c
@@ -279,8 +279,8 @@ static void collect_usable_iova_ranges(QEMUVFIOState *s, void *buf)
     s->nb_iova_ranges = cap_iova_range->nr_iovas;
     if (s->nb_iova_ranges > 1) {
         s->usable_iova_ranges =
-            g_realloc(s->usable_iova_ranges,
-                      s->nb_iova_ranges * sizeof(struct IOVARange));
+            g_renew(struct IOVARange, s->usable_iova_ranges,
+                    s->nb_iova_ranges);
     }
 
     for (i = 0; i < s->nb_iova_ranges; i++) {
-- 
2.35.1

