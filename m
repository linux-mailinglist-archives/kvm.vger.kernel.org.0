Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5131820ACF2
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 09:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgFZHXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 03:23:24 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24872 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725855AbgFZHXY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Jun 2020 03:23:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593156202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k5gcxusQzyzo3jSltVar2tBWqpPktP5b6qDTjVFvjTk=;
        b=GP57/3T6Wr5Yb9FgtTzT5wfjcBhEluOXLRdItJT9cu5iLcZjXemcgIphc9optQiMzkrGO3
        bG0FL7ZkMvUw8uh1N58tnVe/LGDgvfQWHHY3QKag4qime9qEmA8PHdV9sUnn+5ouHLZ/B7
        hkxXWt6/3U0NOxmWVbuDMYw47ChjwZ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-V9G5qmFIM82M1WqWRFUFRA-1; Fri, 26 Jun 2020 03:23:19 -0400
X-MC-Unique: V9G5qmFIM82M1WqWRFUFRA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0BE368015FB;
        Fri, 26 Jun 2020 07:23:18 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-35.ams2.redhat.com [10.36.113.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CEDF360C1D;
        Fri, 26 Jun 2020 07:23:08 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: [PATCH v5 01/21] pc: Support coldplugging of virtio-pmem-pci devices on all buses
Date:   Fri, 26 Jun 2020 09:22:28 +0200
Message-Id: <20200626072248.78761-2-david@redhat.com>
In-Reply-To: <20200626072248.78761-1-david@redhat.com>
References: <20200626072248.78761-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

E.g., with "pc-q35-4.2", trying to coldplug a virtio-pmem-pci devices
results in
    "virtio-pmem-pci not supported on this bus"

Reasons is, that the bus does not support hotplug and, therefore, does
not have a hotplug handler. Let's allow coldplugging virtio-pmem devices
on such buses. The hotplug order is only relevant for virtio-pmem-pci
when the guest is already alive and the device is visible before
memory_device_plug() wired up the memory device bits.

Hotplug attempts will still fail with:
    "Error: Bus 'pcie.0' does not support hotplugging"

Hotunplug attempts will still fail with:
    "Error: Bus 'pcie.0' does not support hotplugging"

Reported-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/i386/pc.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 803bd52ca4..2dfd69b973 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1643,13 +1643,13 @@ static void pc_virtio_pmem_pci_pre_plug(HotplugHandler *hotplug_dev,
     HotplugHandler *hotplug_dev2 = qdev_get_bus_hotplug_handler(dev);
     Error *local_err = NULL;
 
-    if (!hotplug_dev2) {
+    if (!hotplug_dev2 && dev->hotplugged) {
         /*
          * Without a bus hotplug handler, we cannot control the plug/unplug
-         * order. This should never be the case on x86, however better add
-         * a safety net.
+         * order. We should never reach this point when hotplugging on x86,
+         * however, better add a safety net.
          */
-        error_setg(errp, "virtio-pmem-pci not supported on this bus.");
+        error_setg(errp, "virtio-pmem-pci hotplug not supported on this bus.");
         return;
     }
     /*
@@ -1658,7 +1658,7 @@ static void pc_virtio_pmem_pci_pre_plug(HotplugHandler *hotplug_dev,
      */
     memory_device_pre_plug(MEMORY_DEVICE(dev), MACHINE(hotplug_dev), NULL,
                            &local_err);
-    if (!local_err) {
+    if (!local_err && hotplug_dev2) {
         hotplug_handler_pre_plug(hotplug_dev2, dev, &local_err);
     }
     error_propagate(errp, local_err);
@@ -1676,9 +1676,11 @@ static void pc_virtio_pmem_pci_plug(HotplugHandler *hotplug_dev,
      * device bits.
      */
     memory_device_plug(MEMORY_DEVICE(dev), MACHINE(hotplug_dev));
-    hotplug_handler_plug(hotplug_dev2, dev, &local_err);
-    if (local_err) {
-        memory_device_unplug(MEMORY_DEVICE(dev), MACHINE(hotplug_dev));
+    if (hotplug_dev2) {
+        hotplug_handler_plug(hotplug_dev2, dev, &local_err);
+        if (local_err) {
+            memory_device_unplug(MEMORY_DEVICE(dev), MACHINE(hotplug_dev));
+        }
     }
     error_propagate(errp, local_err);
 }
-- 
2.26.2

