Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A46B4D7B68
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 18:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbfJOQ17 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 12:27:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51304 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727766AbfJOQ17 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 12:27:59 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8E843308FFB1;
        Tue, 15 Oct 2019 16:27:58 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-35.brq.redhat.com [10.40.204.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5656B19C58;
        Tue, 15 Oct 2019 16:27:46 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Aleksandar Markovic <amarkovic@wavecomp.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        xen-devel@lists.xenproject.org,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH 04/32] mc146818rtc: Move RTC_ISA_IRQ definition
Date:   Tue, 15 Oct 2019 18:26:37 +0200
Message-Id: <20191015162705.28087-5-philmd@redhat.com>
In-Reply-To: <20191015162705.28087-1-philmd@redhat.com>
References: <20191015162705.28087-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Tue, 15 Oct 2019 16:27:58 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Philippe Mathieu-Daudé <f4bug@amsat.org>

The ISA default number for the RTC devices is not related to its
registers neither. Move this definition to "hw/timer/mc146818rtc.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/hw/timer/mc146818rtc.h      | 2 ++
 include/hw/timer/mc146818rtc_regs.h | 2 --
 tests/rtc-test.c                    | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/hw/timer/mc146818rtc.h b/include/hw/timer/mc146818rtc.h
index 0f1c886e5b..17761cf6d9 100644
--- a/include/hw/timer/mc146818rtc.h
+++ b/include/hw/timer/mc146818rtc.h
@@ -39,6 +39,8 @@ typedef struct RTCState {
     QLIST_ENTRY(RTCState) link;
 } RTCState;
 
+#define RTC_ISA_IRQ 8
+
 ISADevice *mc146818_rtc_init(ISABus *bus, int base_year,
                              qemu_irq intercept_irq);
 void rtc_set_memory(ISADevice *dev, int addr, int val);
diff --git a/include/hw/timer/mc146818rtc_regs.h b/include/hw/timer/mc146818rtc_regs.h
index bfbb57e570..631f71cfd9 100644
--- a/include/hw/timer/mc146818rtc_regs.h
+++ b/include/hw/timer/mc146818rtc_regs.h
@@ -27,8 +27,6 @@
 
 #include "qemu/timer.h"
 
-#define RTC_ISA_IRQ 8
-
 #define RTC_SECONDS             0
 #define RTC_SECONDS_ALARM       1
 #define RTC_MINUTES             2
diff --git a/tests/rtc-test.c b/tests/rtc-test.c
index 6309b0ef6c..18f895690f 100644
--- a/tests/rtc-test.c
+++ b/tests/rtc-test.c
@@ -15,6 +15,7 @@
 
 #include "libqtest-single.h"
 #include "qemu/timer.h"
+#include "hw/timer/mc146818rtc.h"
 #include "hw/timer/mc146818rtc_regs.h"
 
 #define UIP_HOLD_LENGTH           (8 * NANOSECONDS_PER_SECOND / 32768)
-- 
2.21.0

