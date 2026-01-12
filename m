Return-Path: <kvm+bounces-67739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A104D12C2D
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:25:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3BA5A3012E99
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 13:24:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D2673596FD;
	Mon, 12 Jan 2026 13:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="chvy+x43";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZLyDFvTl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2725D27602C
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 13:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768224240; cv=none; b=TWcaw/6UZPaoF2tJFxe2NRWLSxGd0/MBOLrYjjRRsIHuhCWef2W8CmfyMK4dR3i/MOoNPjBJREd0WFY4UXXMzRpYbG+qNOHobVV30DbGDZm2ZKoKflLH0xiXyuwLAH12fiT6T2JgwIXptDNTYaNeRlLcfYtw/McQlNhxU91fQJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768224240; c=relaxed/simple;
	bh=wVTwMdwXegb38P38ETHmrSkjOShm6lLr5m/wDYrFRnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dsxmWFLFyXxlaKK6QLMLMl9YoK1k03U5ZEmzvw0EjTOdmepb29+WVC8ch0inpho5VjhEVIR/l7l+JbYebXB2fTJd221nLnygkJcMiB+f67mAYT7ubHd3XDUakLnKGf/p/P+ycf9SAy+Q/EixZaD85czq4y56e6Te2x05OhAs5U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=chvy+x43; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZLyDFvTl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768224238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=APFw32lDHGb6vJ+fHAcwZMep7Yabt12YehNL48qlxeE=;
	b=chvy+x43U+fISDM/pQS0kH07dwd4Ik+bupte/yyQHVdhNs76vCP+FIGA0oxQhiH71ZmRDP
	dKyLRZTbm2tnE3DlwWK6OUVvU3oGAf4Vo2rcbgua04gpXRkMBK9nHhMF9ioDispo9Hb2RV
	0Nbt2JT/yGvPze3/q9poZL4uKM9rKN8=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-491-p2Ghj2KvM86V2nllhxh2Tg-1; Mon, 12 Jan 2026 08:23:56 -0500
X-MC-Unique: p2Ghj2KvM86V2nllhxh2Tg-1
X-Mimecast-MFC-AGG-ID: p2Ghj2KvM86V2nllhxh2Tg_1768224236
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c52ebdd2d43so2249663a12.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 05:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768224236; x=1768829036; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=APFw32lDHGb6vJ+fHAcwZMep7Yabt12YehNL48qlxeE=;
        b=ZLyDFvTlGCok6Dea4kgBpfJhVbLkLCSuT1enIKuFPQDKLJA4p45rzVIouuU7QeMGSB
         g1tPfn7rpRq/Q2LnlwEQsYWfdfxQ2FCdql8i3blUolwGhEz3ZY2TtQA3D7ivtpdTkDHv
         LhicU6SBL4A3BkWMXxfxECAV0iJj4DQyj9tRdEZzqTVtbf22xemcsVQ2OEKlhlUBYBAb
         MFzpanQAMtW3PIXk2V82OR27un4aPSlMUPMc1dwTbZjMOKfarqOEJhf8IV6FKZ/SbCbF
         kO7P3uzyRwHPOvOlqW/RqFnQ3C1eQsVrAYORKQ2ZJ5IoFtEI4unN2yi+NimJyVZeUzXz
         4wMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768224236; x=1768829036;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=APFw32lDHGb6vJ+fHAcwZMep7Yabt12YehNL48qlxeE=;
        b=d5qUR3W5iG5Zkvgt+es9YVVxenpYe41PEyIAPRGp01/X6fH2Uy9oWMLXqOPcTDFrJK
         9kbw2xuYi4494Ml9JfSavJbHnNRcIzmVnHfjUcgNNJxHHGwnluL1FfvswmsQQlgELQLE
         AFwd+krz/vFM3qEMJVaqv10lGeSTnTeOOoNRv68h1XlwGB5lDRmNzEsVGObcVTn2jixo
         tgpUERjQLYrlejSn1PLMZat8o8kGyinF9X0PQmtINDJ0QwpJGggiF7+3BVPS4SQtJYTB
         juKFaTr738iige6f46CFmt5y3+usdF0s+dPfFuEDNs7MDvXl3lBoxuOsdCmklvs4mRNJ
         uolA==
X-Forwarded-Encrypted: i=1; AJvYcCVh9yVsJ2VJTbC4EzY4pX4hIf1KOvh3e/+R+mdfkJXX4EoCu4TlZgaWJnqISPJuoCne9wI=@vger.kernel.org
X-Gm-Message-State: AOJu0YymPqrwXW0N3wMSR+5dipzjCphFY+rMhg2IB7r4qY6NNHDe/s/Z
	Es/LbU02AzwgYY18LTsXRL30uUG8lHdgd69NI7xGzeUmsPMdPt7Fd3BK6UaCan2df1Zxtaq3eLx
	cs3g/iF4cuID5hSB/oCeC+c/yKLbwxTU8hCizbcq8Wra1FlNzsRAgsg==
X-Gm-Gg: AY/fxX7EBsEQDpOjRTls9arOvPwjaaItx4U2JjjeqTGJ8qa0h/4b6dBBBI5ollYrNaS
	h/EMj8NN8TzKhNSvJIVInnAQCkh4TP4ijHSjuJx/QGmdz3zSAsZnFMrIksk8gvtel7mvGwiCL1N
	CW+s9/2Wbwg0SgAOcWYEQvR6+EWdz2j4Wa0fMIk8eWDDQ02m2a2OjFnRv/mRt/7uLs1oDGSQL9q
	TaQCEMmM65D71HPvq74Dmuz8CS94K7ONdOO5F/fP/bVImonXoBMMvG0L+KIoWaWTiDl5IIRxLvF
	5Hof+QT73oL4wvOKzIAF5zjS6dYbdWuASspVRHHliGBc0yClmVYVjfw66PgBmmHrSmHsDd5szAk
	gTMid2vi8qpM/vowT2/AkOJcc0xYAfppvgWNS2yq2KqU=
X-Received: by 2002:a05:6a20:7d86:b0:334:9b5d:3876 with SMTP id adf61e73a8af0-3898f8f5751mr15608240637.4.1768224235812;
        Mon, 12 Jan 2026 05:23:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHdnnEq/+4QREmK7Kwrw2WpnnCo0brli7EYMdGC71kOXLi8N0UspIFsrwXTnchK1WCgIs9ahA==
X-Received: by 2002:a05:6a20:7d86:b0:334:9b5d:3876 with SMTP id adf61e73a8af0-3898f8f5751mr15608223637.4.1768224235424;
        Mon, 12 Jan 2026 05:23:55 -0800 (PST)
Received: from rhel9-box.lan ([110.227.88.119])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c4cc05cd87asm17544771a12.15.2026.01.12.05.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:23:55 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v2 11/32] kvm/i386: reload firmware for confidential guest reset
Date: Mon, 12 Jan 2026 18:52:24 +0530
Message-ID: <20260112132259.76855-12-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260112132259.76855-1-anisinha@redhat.com>
References: <20260112132259.76855-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When IGVM is not being used by the confidential guest, the guest firmware has
to be reloaded explictly again into memory. This is because, the memory into
which the firmware was loaded before reset was encrypted and is thus lost
upon reset. When IGVM is used, it is expected that the IGVM will contain the
guest firmware and the execution of the IGVM directives will set up the guest
firmware memory.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 4fedc621b8..46c4f9487b 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -51,6 +51,8 @@
 #include "qemu/config-file.h"
 #include "qemu/error-report.h"
 #include "qemu/memalign.h"
+#include "qemu/datadir.h"
+#include "hw/core/loader.h"
 #include "hw/i386/x86.h"
 #include "hw/i386/kvm/xen_evtchn.h"
 #include "hw/i386/pc.h"
@@ -3267,6 +3269,22 @@ static int kvm_vm_enable_energy_msrs(KVMState *s)
 
 static int xen_init_wrapper(MachineState *ms, KVMState *s);
 
+static void reload_bios_rom(X86MachineState *x86ms)
+{
+    int bios_size;
+    const char *bios_name;
+    char *filename;
+
+    bios_name = MACHINE(x86ms)->firmware ?: "bios.bin";
+    filename = qemu_find_file(QEMU_FILE_TYPE_BIOS, bios_name);
+
+    bios_size = get_bios_size(x86ms, bios_name, filename);
+
+    void *ptr = memory_region_get_ram_ptr(&x86ms->bios);
+    load_image_size(filename, ptr, bios_size);
+    x86_firmware_configure(0x100000000ULL - bios_size, ptr, bios_size);
+}
+
 int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)
 {
     Error *local_err = NULL;
@@ -3285,6 +3303,16 @@ int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)
             error_report_err(local_err);
             return ret;
         }
+        if (object_dynamic_cast(OBJECT(ms), TYPE_X86_MACHINE)) {
+            X86MachineState *x86ms = X86_MACHINE(ms);
+            /*
+             * If an IGVM file is specified then the firmware must be provided
+             * in the IGVM file.
+             */
+            if (!x86ms->igvm) {
+                reload_bios_rom(x86ms);
+            }
+        }
     }
 
     ret = kvm_vm_enable_exception_payload(s);
-- 
2.42.0


