Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152563C757D
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 19:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbhGMRIc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 13:08:32 -0400
Received: from foss.arm.com ([217.140.110.172]:47582 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232724AbhGMRIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 13:08:31 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FD801FB;
        Tue, 13 Jul 2021 10:05:41 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E2BB23F7D8;
        Tue, 13 Jul 2021 10:05:39 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org, pierre.gondois@arm.com
Subject: [PATCH v3 kvmtool 1/4] Move fdt_irq_fn typedef to fdt.h
Date:   Tue, 13 Jul 2021 18:06:28 +0100
Message-Id: <20210713170631.155595-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210713170631.155595-1-alexandru.elisei@arm.com>
References: <20210713170631.155595-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The device tree code passes the function generate_irq_prop() to MMIO
devices to create the "interrupts" property. The typedef fdt_irq_fn is the
type used to pass the function to the device. It makes more sense for the
typedef to be in fdt.h with the rest of the device tree functions, so move
it there.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 hw/rtc.c          | 1 +
 include/kvm/fdt.h | 2 ++
 include/kvm/kvm.h | 1 -
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/hw/rtc.c b/hw/rtc.c
index aec31c52a85a..9b8785a869dd 100644
--- a/hw/rtc.c
+++ b/hw/rtc.c
@@ -1,5 +1,6 @@
 #include "kvm/rtc.h"
 
+#include "kvm/fdt.h"
 #include "kvm/ioport.h"
 #include "kvm/kvm.h"
 
diff --git a/include/kvm/fdt.h b/include/kvm/fdt.h
index 4e6157256482..060c37b947cc 100644
--- a/include/kvm/fdt.h
+++ b/include/kvm/fdt.h
@@ -25,6 +25,8 @@ enum irq_type {
 	IRQ_TYPE_LEVEL_MASK	= (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH),
 };
 
+typedef void (*fdt_irq_fn)(void *fdt, u8 irq, enum irq_type irq_type);
+
 extern char *fdt_stdout_path;
 
 /* Helper for the various bits of code that generate FDT nodes */
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 6c28afa3f0bb..56e9c8e347a0 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -44,7 +44,6 @@
 struct kvm_cpu;
 typedef void (*mmio_handler_fn)(struct kvm_cpu *vcpu, u64 addr, u8 *data,
 				u32 len, u8 is_write, void *ptr);
-typedef void (*fdt_irq_fn)(void *fdt, u8 irq, enum irq_type irq_type);
 
 enum {
 	KVM_VMSTATE_RUNNING,
-- 
2.32.0

