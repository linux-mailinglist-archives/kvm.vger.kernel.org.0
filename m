Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C430263DF3
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 09:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730330AbgIJHEb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 03:04:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25256 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729785AbgIJHCA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 03:02:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599721309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r7XFBGUbtmw6+pIarSdnNbYpBrhpwFO1Rb8y52JScyA=;
        b=Z0anJKUzy98tbG3zE6rlyz2pZQqlcr3zzPG3m3XqN6rE/j/D9SIufKP9kzBnQHmoZhaxxR
        q2Kqrhf6ls598MYrYaD4iaHxbe1smdymRKzXEc0wYnTtbI4ARu9gA2R5605v0xLHKkKEgB
        yGF+x2bN/3ulzh9jZErZepFB4RU3D2w=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-fAjze9xnPOSUUjQN-20sXg-1; Thu, 10 Sep 2020 03:01:48 -0400
X-MC-Unique: fAjze9xnPOSUUjQN-20sXg-1
Received: by mail-wr1-f70.google.com with SMTP id l17so1869425wrw.11
        for <kvm@vger.kernel.org>; Thu, 10 Sep 2020 00:01:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r7XFBGUbtmw6+pIarSdnNbYpBrhpwFO1Rb8y52JScyA=;
        b=t+8BsDG4SLV2SEYCkSLxINEaTTXWS8J1RsWSBgsl87OqtHbBX6ASHbhS6yWB+P54mY
         Xl98dIYV/JpwIrAVVZPtsy4LMMRowV4XntJvUHpVCDeElHEfPxL5uwJo538oKEvuqXya
         1xYh8WwD1csSYk6nExYiM0M3DEqVuYYCBvVpBcOKUNkkvtKMOuHm9KJ3VjkfkaGbLtDO
         THFtK3npMEIj4Mid2t8renwdg2WYX+X+OuZNbazaMbru6E8Vrsam0/0EzGvSHPnCA3Gh
         U8chysMIn47f5o7p1nSgAyF9tQccLTuNFIITN5k4eMfygRv3tUh4dvcuvhgyP4sbSiyv
         J/7g==
X-Gm-Message-State: AOAM532XeK8T4QQnzuliPvdXfB22VQaB7U10lL7RVVeYscU9SHHLSvje
        8/Cq6/ETc9YMhT6X9uHllGZxRtXOnJhoADwWzQNNPEeWrKEBhfqkuw0fEw8gJx65dtj378b6DPW
        UivjfdvPuVc3v
X-Received: by 2002:a7b:ce17:: with SMTP id m23mr6726983wmc.98.1599721306103;
        Thu, 10 Sep 2020 00:01:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy7BwDX40M9FcvmDDKL7Sv5M5flTDXcgcHzKzgkmRdWZC6SYh+Ne8NxJgQ8zHZWT11W+dNcDQ==
X-Received: by 2002:a7b:ce17:: with SMTP id m23mr6726926wmc.98.1599721305563;
        Thu, 10 Sep 2020 00:01:45 -0700 (PDT)
Received: from x1w.redhat.com (65.red-83-57-170.dynamicip.rima-tde.net. [83.57.170.65])
        by smtp.gmail.com with ESMTPSA id z7sm7666348wrw.93.2020.09.10.00.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 00:01:44 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jason Wang <jasowang@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        qemu-trivial@nongnu.org, Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Joel Stanley <joel@jms.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 2/6] hw/core/stream: Rename StreamSlave as StreamSink
Date:   Thu, 10 Sep 2020 09:01:27 +0200
Message-Id: <20200910070131.435543-3-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200910070131.435543-1-philmd@redhat.com>
References: <20200910070131.435543-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to use inclusive terminology, rename 'slave stream'
as 'sink stream'.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/hw/ssi/xilinx_spips.h |  2 +-
 include/hw/stream.h           | 46 +++++++++++++++++------------------
 hw/core/stream.c              | 20 +++++++--------
 hw/dma/xilinx_axidma.c        | 32 ++++++++++++------------
 hw/net/xilinx_axienet.c       | 20 +++++++--------
 hw/ssi/xilinx_spips.c         |  2 +-
 6 files changed, 61 insertions(+), 61 deletions(-)

diff --git a/include/hw/ssi/xilinx_spips.h b/include/hw/ssi/xilinx_spips.h
index 6a39b55a7bd..fde8a3ebda6 100644
--- a/include/hw/ssi/xilinx_spips.h
+++ b/include/hw/ssi/xilinx_spips.h
@@ -97,7 +97,7 @@ typedef struct {
 typedef struct {
     XilinxQSPIPS parent_obj;
 
-    StreamSlave *dma;
+    StreamSink *dma;
     int gqspi_irqline;
 
     uint32_t regs[XLNX_ZYNQMP_SPIPS_R_MAX];
diff --git a/include/hw/stream.h b/include/hw/stream.h
index ed09e83683d..8ca161991ca 100644
--- a/include/hw/stream.h
+++ b/include/hw/stream.h
@@ -3,52 +3,52 @@
 
 #include "qom/object.h"
 
-/* stream slave. Used until qdev provides a generic way.  */
-#define TYPE_STREAM_SLAVE "stream-slave"
+/* stream sink. Used until qdev provides a generic way.  */
+#define TYPE_STREAM_SINK "stream-slave"
 
-#define STREAM_SLAVE_CLASS(klass) \
-     OBJECT_CLASS_CHECK(StreamSlaveClass, (klass), TYPE_STREAM_SLAVE)
-#define STREAM_SLAVE_GET_CLASS(obj) \
-    OBJECT_GET_CLASS(StreamSlaveClass, (obj), TYPE_STREAM_SLAVE)
-#define STREAM_SLAVE(obj) \
-     INTERFACE_CHECK(StreamSlave, (obj), TYPE_STREAM_SLAVE)
+#define STREAM_SINK_CLASS(klass) \
+     OBJECT_CLASS_CHECK(StreamSinkClass, (klass), TYPE_STREAM_SINK)
+#define STREAM_SINK_GET_CLASS(obj) \
+    OBJECT_GET_CLASS(StreamSinkClass, (obj), TYPE_STREAM_SINK)
+#define STREAM_SINK(obj) \
+     INTERFACE_CHECK(StreamSink, (obj), TYPE_STREAM_SINK)
 
-typedef struct StreamSlave StreamSlave;
+typedef struct StreamSink StreamSink;
 
 typedef void (*StreamCanPushNotifyFn)(void *opaque);
 
-typedef struct StreamSlaveClass {
+typedef struct StreamSinkClass {
     InterfaceClass parent;
     /**
-     * can push - determine if a stream slave is capable of accepting at least
+     * can push - determine if a stream sink is capable of accepting at least
      * one byte of data. Returns false if cannot accept. If not implemented, the
-     * slave is assumed to always be capable of receiving.
-     * @notify: Optional callback that the slave will call when the slave is
+     * sink is assumed to always be capable of receiving.
+     * @notify: Optional callback that the sink will call when the sink is
      * capable of receiving again. Only called if false is returned.
      * @notify_opaque: opaque data to pass to notify call.
      */
-    bool (*can_push)(StreamSlave *obj, StreamCanPushNotifyFn notify,
+    bool (*can_push)(StreamSink *obj, StreamCanPushNotifyFn notify,
                      void *notify_opaque);
     /**
-     * push - push data to a Stream slave. The number of bytes pushed is
-     * returned. If the slave short returns, the master must wait before trying
-     * again, the slave may continue to just return 0 waiting for the vm time to
+     * push - push data to a Stream sink. The number of bytes pushed is
+     * returned. If the sink short returns, the master must wait before trying
+     * again, the sink may continue to just return 0 waiting for the vm time to
      * advance. The can_push() function can be used to trap the point in time
-     * where the slave is ready to receive again, otherwise polling on a QEMU
+     * where the sink is ready to receive again, otherwise polling on a QEMU
      * timer will work.
-     * @obj: Stream slave to push to
+     * @obj: Stream sink to push to
      * @buf: Data to write
      * @len: Maximum number of bytes to write
      * @eop: End of packet flag
      */
-    size_t (*push)(StreamSlave *obj, unsigned char *buf, size_t len, bool eop);
-} StreamSlaveClass;
+    size_t (*push)(StreamSink *obj, unsigned char *buf, size_t len, bool eop);
+} StreamSinkClass;
 
 size_t
-stream_push(StreamSlave *sink, uint8_t *buf, size_t len, bool eop);
+stream_push(StreamSink *sink, uint8_t *buf, size_t len, bool eop);
 
 bool
-stream_can_push(StreamSlave *sink, StreamCanPushNotifyFn notify,
+stream_can_push(StreamSink *sink, StreamCanPushNotifyFn notify,
                 void *notify_opaque);
 
 
diff --git a/hw/core/stream.c b/hw/core/stream.c
index a65ad1208d8..19477d0f2df 100644
--- a/hw/core/stream.c
+++ b/hw/core/stream.c
@@ -3,32 +3,32 @@
 #include "qemu/module.h"
 
 size_t
-stream_push(StreamSlave *sink, uint8_t *buf, size_t len, bool eop)
+stream_push(StreamSink *sink, uint8_t *buf, size_t len, bool eop)
 {
-    StreamSlaveClass *k =  STREAM_SLAVE_GET_CLASS(sink);
+    StreamSinkClass *k =  STREAM_SINK_GET_CLASS(sink);
 
     return k->push(sink, buf, len, eop);
 }
 
 bool
-stream_can_push(StreamSlave *sink, StreamCanPushNotifyFn notify,
+stream_can_push(StreamSink *sink, StreamCanPushNotifyFn notify,
                 void *notify_opaque)
 {
-    StreamSlaveClass *k =  STREAM_SLAVE_GET_CLASS(sink);
+    StreamSinkClass *k =  STREAM_SINK_GET_CLASS(sink);
 
     return k->can_push ? k->can_push(sink, notify, notify_opaque) : true;
 }
 
-static const TypeInfo stream_slave_info = {
-    .name          = TYPE_STREAM_SLAVE,
+static const TypeInfo stream_sink_info = {
+    .name          = TYPE_STREAM_SINK,
     .parent        = TYPE_INTERFACE,
-    .class_size = sizeof(StreamSlaveClass),
+    .class_size = sizeof(StreamSinkClass),
 };
 
 
-static void stream_slave_register_types(void)
+static void stream_sink_register_types(void)
 {
-    type_register_static(&stream_slave_info);
+    type_register_static(&stream_sink_info);
 }
 
-type_init(stream_slave_register_types)
+type_init(stream_sink_register_types)
diff --git a/hw/dma/xilinx_axidma.c b/hw/dma/xilinx_axidma.c
index a4812e480a0..cf12a852ea1 100644
--- a/hw/dma/xilinx_axidma.c
+++ b/hw/dma/xilinx_axidma.c
@@ -131,8 +131,8 @@ struct XilinxAXIDMA {
     AddressSpace as;
 
     uint32_t freqhz;
-    StreamSlave *tx_data_dev;
-    StreamSlave *tx_control_dev;
+    StreamSink *tx_data_dev;
+    StreamSink *tx_control_dev;
     XilinxAXIDMAStreamSlave rx_data_dev;
     XilinxAXIDMAStreamSlave rx_control_dev;
 
@@ -264,8 +264,8 @@ static void stream_complete(struct Stream *s)
     ptimer_transaction_commit(s->ptimer);
 }
 
-static void stream_process_mem2s(struct Stream *s, StreamSlave *tx_data_dev,
-                                 StreamSlave *tx_control_dev)
+static void stream_process_mem2s(struct Stream *s, StreamSink *tx_data_dev,
+                                 StreamSink *tx_control_dev)
 {
     uint32_t prev_d;
     uint32_t txlen;
@@ -387,7 +387,7 @@ static void xilinx_axidma_reset(DeviceState *dev)
 }
 
 static size_t
-xilinx_axidma_control_stream_push(StreamSlave *obj, unsigned char *buf,
+xilinx_axidma_control_stream_push(StreamSink *obj, unsigned char *buf,
                                   size_t len, bool eop)
 {
     XilinxAXIDMAStreamSlave *cs = XILINX_AXI_DMA_CONTROL_STREAM(obj);
@@ -403,7 +403,7 @@ xilinx_axidma_control_stream_push(StreamSlave *obj, unsigned char *buf,
 }
 
 static bool
-xilinx_axidma_data_stream_can_push(StreamSlave *obj,
+xilinx_axidma_data_stream_can_push(StreamSink *obj,
                                    StreamCanPushNotifyFn notify,
                                    void *notify_opaque)
 {
@@ -420,7 +420,7 @@ xilinx_axidma_data_stream_can_push(StreamSlave *obj,
 }
 
 static size_t
-xilinx_axidma_data_stream_push(StreamSlave *obj, unsigned char *buf, size_t len,
+xilinx_axidma_data_stream_push(StreamSink *obj, unsigned char *buf, size_t len,
                                bool eop)
 {
     XilinxAXIDMAStreamSlave *ds = XILINX_AXI_DMA_DATA_STREAM(obj);
@@ -591,9 +591,9 @@ static void xilinx_axidma_init(Object *obj)
 static Property axidma_properties[] = {
     DEFINE_PROP_UINT32("freqhz", XilinxAXIDMA, freqhz, 50000000),
     DEFINE_PROP_LINK("axistream-connected", XilinxAXIDMA,
-                     tx_data_dev, TYPE_STREAM_SLAVE, StreamSlave *),
+                     tx_data_dev, TYPE_STREAM_SINK, StreamSink *),
     DEFINE_PROP_LINK("axistream-control-connected", XilinxAXIDMA,
-                     tx_control_dev, TYPE_STREAM_SLAVE, StreamSlave *),
+                     tx_control_dev, TYPE_STREAM_SINK, StreamSink *),
     DEFINE_PROP_END_OF_LIST(),
 };
 
@@ -606,21 +606,21 @@ static void axidma_class_init(ObjectClass *klass, void *data)
     device_class_set_props(dc, axidma_properties);
 }
 
-static StreamSlaveClass xilinx_axidma_data_stream_class = {
+static StreamSinkClass xilinx_axidma_data_stream_class = {
     .push = xilinx_axidma_data_stream_push,
     .can_push = xilinx_axidma_data_stream_can_push,
 };
 
-static StreamSlaveClass xilinx_axidma_control_stream_class = {
+static StreamSinkClass xilinx_axidma_control_stream_class = {
     .push = xilinx_axidma_control_stream_push,
 };
 
 static void xilinx_axidma_stream_class_init(ObjectClass *klass, void *data)
 {
-    StreamSlaveClass *ssc = STREAM_SLAVE_CLASS(klass);
+    StreamSinkClass *ssc = STREAM_SINK_CLASS(klass);
 
-    ssc->push = ((StreamSlaveClass *)data)->push;
-    ssc->can_push = ((StreamSlaveClass *)data)->can_push;
+    ssc->push = ((StreamSinkClass *)data)->push;
+    ssc->can_push = ((StreamSinkClass *)data)->can_push;
 }
 
 static const TypeInfo axidma_info = {
@@ -638,7 +638,7 @@ static const TypeInfo xilinx_axidma_data_stream_info = {
     .class_init    = xilinx_axidma_stream_class_init,
     .class_data    = &xilinx_axidma_data_stream_class,
     .interfaces = (InterfaceInfo[]) {
-        { TYPE_STREAM_SLAVE },
+        { TYPE_STREAM_SINK },
         { }
     }
 };
@@ -650,7 +650,7 @@ static const TypeInfo xilinx_axidma_control_stream_info = {
     .class_init    = xilinx_axidma_stream_class_init,
     .class_data    = &xilinx_axidma_control_stream_class,
     .interfaces = (InterfaceInfo[]) {
-        { TYPE_STREAM_SLAVE },
+        { TYPE_STREAM_SINK },
         { }
     }
 };
diff --git a/hw/net/xilinx_axienet.c b/hw/net/xilinx_axienet.c
index 2e89f236b4a..0c4ac727207 100644
--- a/hw/net/xilinx_axienet.c
+++ b/hw/net/xilinx_axienet.c
@@ -323,8 +323,8 @@ struct XilinxAXIEnet {
     SysBusDevice busdev;
     MemoryRegion iomem;
     qemu_irq irq;
-    StreamSlave *tx_data_dev;
-    StreamSlave *tx_control_dev;
+    StreamSink *tx_data_dev;
+    StreamSink *tx_control_dev;
     XilinxAXIEnetStreamSlave rx_data_dev;
     XilinxAXIEnetStreamSlave rx_control_dev;
     NICState *nic;
@@ -855,7 +855,7 @@ static ssize_t eth_rx(NetClientState *nc, const uint8_t *buf, size_t size)
 }
 
 static size_t
-xilinx_axienet_control_stream_push(StreamSlave *obj, uint8_t *buf, size_t len,
+xilinx_axienet_control_stream_push(StreamSink *obj, uint8_t *buf, size_t len,
                                    bool eop)
 {
     int i;
@@ -877,7 +877,7 @@ xilinx_axienet_control_stream_push(StreamSlave *obj, uint8_t *buf, size_t len,
 }
 
 static size_t
-xilinx_axienet_data_stream_push(StreamSlave *obj, uint8_t *buf, size_t size,
+xilinx_axienet_data_stream_push(StreamSink *obj, uint8_t *buf, size_t size,
                                 bool eop)
 {
     XilinxAXIEnetStreamSlave *ds = XILINX_AXI_ENET_DATA_STREAM(obj);
@@ -1005,9 +1005,9 @@ static Property xilinx_enet_properties[] = {
     DEFINE_PROP_UINT32("txmem", XilinxAXIEnet, c_txmem, 0x1000),
     DEFINE_NIC_PROPERTIES(XilinxAXIEnet, conf),
     DEFINE_PROP_LINK("axistream-connected", XilinxAXIEnet,
-                     tx_data_dev, TYPE_STREAM_SLAVE, StreamSlave *),
+                     tx_data_dev, TYPE_STREAM_SINK, StreamSink *),
     DEFINE_PROP_LINK("axistream-control-connected", XilinxAXIEnet,
-                     tx_control_dev, TYPE_STREAM_SLAVE, StreamSlave *),
+                     tx_control_dev, TYPE_STREAM_SINK, StreamSink *),
     DEFINE_PROP_END_OF_LIST(),
 };
 
@@ -1023,14 +1023,14 @@ static void xilinx_enet_class_init(ObjectClass *klass, void *data)
 static void xilinx_enet_control_stream_class_init(ObjectClass *klass,
                                                   void *data)
 {
-    StreamSlaveClass *ssc = STREAM_SLAVE_CLASS(klass);
+    StreamSinkClass *ssc = STREAM_SINK_CLASS(klass);
 
     ssc->push = xilinx_axienet_control_stream_push;
 }
 
 static void xilinx_enet_data_stream_class_init(ObjectClass *klass, void *data)
 {
-    StreamSlaveClass *ssc = STREAM_SLAVE_CLASS(klass);
+    StreamSinkClass *ssc = STREAM_SINK_CLASS(klass);
 
     ssc->push = xilinx_axienet_data_stream_push;
 }
@@ -1049,7 +1049,7 @@ static const TypeInfo xilinx_enet_data_stream_info = {
     .instance_size = sizeof(struct XilinxAXIEnetStreamSlave),
     .class_init    = xilinx_enet_data_stream_class_init,
     .interfaces = (InterfaceInfo[]) {
-            { TYPE_STREAM_SLAVE },
+            { TYPE_STREAM_SINK },
             { }
     }
 };
@@ -1060,7 +1060,7 @@ static const TypeInfo xilinx_enet_control_stream_info = {
     .instance_size = sizeof(struct XilinxAXIEnetStreamSlave),
     .class_init    = xilinx_enet_control_stream_class_init,
     .interfaces = (InterfaceInfo[]) {
-            { TYPE_STREAM_SLAVE },
+            { TYPE_STREAM_SINK },
             { }
     }
 };
diff --git a/hw/ssi/xilinx_spips.c b/hw/ssi/xilinx_spips.c
index b9371dbf8d7..6109ba55107 100644
--- a/hw/ssi/xilinx_spips.c
+++ b/hw/ssi/xilinx_spips.c
@@ -1353,7 +1353,7 @@ static void xlnx_zynqmp_qspips_init(Object *obj)
 {
     XlnxZynqMPQSPIPS *rq = XLNX_ZYNQMP_QSPIPS(obj);
 
-    object_property_add_link(obj, "stream-connected-dma", TYPE_STREAM_SLAVE,
+    object_property_add_link(obj, "stream-connected-dma", TYPE_STREAM_SINK,
                              (Object **)&rq->dma,
                              object_property_allow_set_link,
                              OBJ_PROP_LINK_STRONG);
-- 
2.26.2

