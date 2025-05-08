Return-Path: <kvm+bounces-45884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 22D88AAFBD9
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:45:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 426301BC120F
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:45:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA6C11E4BE;
	Thu,  8 May 2025 13:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="g5KWfTrY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207C022C35E
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711902; cv=none; b=sl20Vt8RHY7l76XIPgxflDp0HUqMBytgzrM9G9J4Q0FWNXuxzFnRS7Z3v+gXVd1x8dBEg5gj3kwEI8/NvNMK+C/g6d/sOrzdSqMElJCcWBcMr0Ccte9PyYcDmZuut0B/rwrTDFvaCnDhNr4dIgf8J/D5ByvmtO+Rh17FZBo681k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711902; c=relaxed/simple;
	bh=i0KUlS9RDzenIxObbPgpaNO8jkvSgpXNWIr54ve6bBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M87ytAkS2ZNmvxJ3NuytJXgeVoJ9mKqTLdHEl2j1zzg6nwsgPYWh6Mo0R+s6Za7Z2s7lzVb6oguPeCZYh59jPitUvfrJOMO2n9uIi3i4AwAE89sQYesNXxGW5ZpmRUipRYdQnTKproTrjG6sEPHRn4YqINJ2fJzw4M4pr+62Iuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=g5KWfTrY; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-739525d4e12so961167b3a.3
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 06:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746711900; x=1747316700; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J0A/U1sPooJ/zOn+77YMR3kP+UO0nbbTuEYORNZS6uE=;
        b=g5KWfTrYEuwBcTV/3xuOuszqBujPb32sMJkgwoipSWLatmAwIbGx+UrbkV+XTXDs+Q
         lJ+Xl7Pm90pvP267IIk4SPe6RZLcVxeZqvXJyp2m9nzcHAUPnwZO8+X7HOQDq6cJmlqb
         pKT3KSCMHknW8BaxXcoPW1xgGUSNdPvdrXEOhlBPWFlis0PjMscLI2rMbnIOE0y1BJeT
         6EfjcE++YwKFKw1MYsAWjA44tPC6jvvx8O803bTQW2sTJRnrTPKuCes3u+FTKuurShVp
         11Nf79caXQSLWKJ3v3FeUlxhN0xuSx7YDRTlDxuMBMZzmTT6QcSZu2lxxb6K7fy41ozH
         bQFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711900; x=1747316700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J0A/U1sPooJ/zOn+77YMR3kP+UO0nbbTuEYORNZS6uE=;
        b=nH61sLsFhZEGKsgBADl5OqHllgpm7lpFQfgwM65hWA8Q+D1J0TYIUflLkQXInx0oxS
         +wwa6mV9b9Ka8+ICLiP0GUGXkYMs+7zH6Jn4xLw8uASaFimcRpSNSb/yOuY7x5lDUUYU
         MyRIPCXJ4TWpSxpdxOFrksk16sI3Nps+2tRsgCQsjN8FIqrrLhKHxEvNh1thrrgwi9Pc
         mzWIQBt2hdymqRzPXVn/UVOIJ/90tAy9vIjVNLfEbsNDKRqN8X7bVXZos9x6jihnbznE
         0CBn9DGY8po10BrPTRHjtlr5Qj9L+nErRkAlV2Moxfs+Bs2F2MYHJT+FVtATXfJ9lPo5
         tKCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWvkCR3/pCo6/YpugIDXn8PBneQLaR9nhQb04wvvHx18R+xaD8NTEASjGW1QljuqZYyLN4=@vger.kernel.org
X-Gm-Message-State: AOJu0YybKaDq2eRwIU7yCifCLnv9GirYOrMULhewVmTCRznd5yGrexX6
	ieZB9NTCkomuutAuRTjcD3cVAmKLSC5qShIsFYovd+/xT6NFnFFNufKac4aRINI=
X-Gm-Gg: ASbGnctO13Twpi1hSVWYDORptkXvEUqzL2JKCr0oHy87XnIXLj4cv/8LUDTjdfdhdT6
	LJD9IyRWRB/sKOaleZ7Eei8UEnr2GxkGzGQuKwpv9anCo+ab1uWzvgwKChTlTVlr7/kUR0LKVOy
	1kJRmw/JL9R9dOXCO3IeSSI+AbvcdQo8b/rzs90qRMhqLf577wDihMgXo3CrH57STYwH5O9F+BF
	x9n0qFj9n2aAtkCoG7/roSeWVIalofVRbpGlUX5O4sx6HQ4IiT3XR9cxOMwHRF1MpypkBK1h5W4
	LhfKw13aqUorGoN1xQGRV6NdLNlSClgcK+d6PSbqxa06eGyLK0bNsTTbjg3qYEa6WFHhfAUUAqa
	UDgL0ZiArmmvheU4=
X-Google-Smtp-Source: AGHT+IFHbTrvwax7UWwh9Y73Xs5DKNO90bnJgGgnaR0eEfKH1whXMeCWqTRwEn5UTKj7+iIdniqr0Q==
X-Received: by 2002:a05:6a00:2791:b0:730:927c:d451 with SMTP id d2e1a72fcca58-7409cfd813dmr10943548b3a.20.1746711900247;
        Thu, 08 May 2025 06:45:00 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590a489asm13619132b3a.170.2025.05.08.06.44.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 May 2025 06:44:59 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Yi Liu <yi.l.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	qemu-riscv@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>,
	Amit Shah <amit@kernel.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Ani Sinha <anisinha@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Mark Cave-Ayland <mark.caveayland@nutanix.com>
Subject: [PATCH v4 24/27] hw/intc/ioapic: Remove IOAPICCommonState::version field
Date: Thu,  8 May 2025 15:35:47 +0200
Message-ID: <20250508133550.81391-25-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250508133550.81391-1-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The IOAPICCommonState::version integer was only set
in the hw_compat_2_7[] array, via the 'version=0x11'
property. We removed all machines using that array,
lets remove that property, simplify by only using the
default version (defined as IOAPIC_VER_DEF).

For the record, this field was introduced in commit
20fd4b7b6d9 ("x86: ioapic: add support for explicit EOI"):

 >   Some old Linux kernels (upstream before v4.0), or any released RHEL
 >   kernels has problem in sending APIC EOI when IR is enabled.
 >   Meanwhile, many of them only support explicit EOI for IOAPIC, which
 >   is only introduced in IOAPIC version 0x20. This patch provide a way
 >   to boost QEMU IOAPIC to version 0x20, in order for QEMU to correctly
 >   receive EOI messages.
 >
 >   Without boosting IOAPIC version to 0x20, kernels before commit
 >   d32932d ("x86/irq: Convert IOAPIC to use hierarchical irqdomain
 >   interfaces") will have trouble enabling both IR and level-triggered
 >   interrupt devices (like e1000).
 >
 >   To upgrade IOAPIC to version 0x20, we need to specify:
 >
 >     -global ioapic.version=0x20
 >
 >   To be compatible with old systems, 0x11 will still be the default
 >   IOAPIC version. Here 0x11 and 0x20 are the only versions to be
 >   supported.
 >
 >   One thing to mention: this patch only applies to emulated IOAPIC. It
 >   does not affect kernel IOAPIC behavior.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
---
 hw/intc/ioapic_internal.h |  3 +--
 hw/intc/ioapic.c          | 18 ++----------------
 hw/intc/ioapic_common.c   |  2 +-
 3 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/hw/intc/ioapic_internal.h b/hw/intc/ioapic_internal.h
index 51205767f44..330ce195222 100644
--- a/hw/intc/ioapic_internal.h
+++ b/hw/intc/ioapic_internal.h
@@ -82,7 +82,7 @@
 #define IOAPIC_ID_MASK                  0xf
 
 #define IOAPIC_VER_ENTRIES_SHIFT        16
-
+#define IOAPIC_VER_DEF                  0x20
 
 #define TYPE_IOAPIC_COMMON "ioapic-common"
 OBJECT_DECLARE_TYPE(IOAPICCommonState, IOAPICCommonClass, IOAPIC_COMMON)
@@ -104,7 +104,6 @@ struct IOAPICCommonState {
     uint32_t irr;
     uint64_t ioredtbl[IOAPIC_NUM_PINS];
     Notifier machine_done;
-    uint8_t version;
     uint64_t irq_count[IOAPIC_NUM_PINS];
     int irq_level[IOAPIC_NUM_PINS];
     int irq_eoi[IOAPIC_NUM_PINS];
diff --git a/hw/intc/ioapic.c b/hw/intc/ioapic.c
index 133bef852d1..5cc97767d9d 100644
--- a/hw/intc/ioapic.c
+++ b/hw/intc/ioapic.c
@@ -315,7 +315,7 @@ ioapic_mem_read(void *opaque, hwaddr addr, unsigned int size)
             val = s->id << IOAPIC_ID_SHIFT;
             break;
         case IOAPIC_REG_VER:
-            val = s->version |
+            val = IOAPIC_VER_DEF |
                 ((IOAPIC_NUM_PINS - 1) << IOAPIC_VER_ENTRIES_SHIFT);
             break;
         default:
@@ -411,8 +411,7 @@ ioapic_mem_write(void *opaque, hwaddr addr, uint64_t val,
         }
         break;
     case IOAPIC_EOI:
-        /* Explicit EOI is only supported for IOAPIC version 0x20 */
-        if (size != 4 || s->version != 0x20) {
+        if (size != 4) {
             break;
         }
         ioapic_eoi_broadcast(val);
@@ -444,18 +443,10 @@ static void ioapic_machine_done_notify(Notifier *notifier, void *data)
 #endif
 }
 
-#define IOAPIC_VER_DEF 0x20
-
 static void ioapic_realize(DeviceState *dev, Error **errp)
 {
     IOAPICCommonState *s = IOAPIC_COMMON(dev);
 
-    if (s->version != 0x11 && s->version != 0x20) {
-        error_setg(errp, "IOAPIC only supports version 0x11 or 0x20 "
-                   "(default: 0x%x).", IOAPIC_VER_DEF);
-        return;
-    }
-
     memory_region_init_io(&s->io_memory, OBJECT(s), &ioapic_io_ops, s,
                           "ioapic", 0x1000);
 
@@ -476,10 +467,6 @@ static void ioapic_unrealize(DeviceState *dev)
     timer_free(s->delayed_ioapic_service_timer);
 }
 
-static const Property ioapic_properties[] = {
-    DEFINE_PROP_UINT8("version", IOAPICCommonState, version, IOAPIC_VER_DEF),
-};
-
 static void ioapic_class_init(ObjectClass *klass, const void *data)
 {
     IOAPICCommonClass *k = IOAPIC_COMMON_CLASS(klass);
@@ -493,7 +480,6 @@ static void ioapic_class_init(ObjectClass *klass, const void *data)
      */
     k->post_load = ioapic_update_kvm_routes;
     device_class_set_legacy_reset(dc, ioapic_reset_common);
-    device_class_set_props(dc, ioapic_properties);
 }
 
 static const TypeInfo ioapic_info = {
diff --git a/hw/intc/ioapic_common.c b/hw/intc/ioapic_common.c
index fce3486e519..8b3e2ba9384 100644
--- a/hw/intc/ioapic_common.c
+++ b/hw/intc/ioapic_common.c
@@ -83,7 +83,7 @@ static void ioapic_print_redtbl(GString *buf, IOAPICCommonState *s)
     int i;
 
     g_string_append_printf(buf, "ioapic0: ver=0x%x id=0x%02x sel=0x%02x",
-                           s->version, s->id, s->ioregsel);
+                           IOAPIC_VER_DEF, s->id, s->ioregsel);
     if (s->ioregsel) {
         g_string_append_printf(buf, " (redir[%u])\n",
                                (s->ioregsel - IOAPIC_REG_REDTBL_BASE) >> 1);
-- 
2.47.1


