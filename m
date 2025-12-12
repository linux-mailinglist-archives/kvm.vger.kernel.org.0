Return-Path: <kvm+bounces-65832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 16009CB90BE
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:07:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2E86630BA6C1
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:05:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E95831196C;
	Fri, 12 Dec 2025 15:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YZDT+SS4";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gnZVhB+A"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C6530FC1D
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765551902; cv=none; b=gVRyOeKbFt/XRRRfV/Ylt92Q4uXjVDCGCYmvvqoqIGLu8Cx34yjozNPDkweIiNAceKmKcbT2NInKASQuDcZWN/t5F1sWRyos/d2XWmlGWaGvT03ASO+LDz64VSbWdSYjToxBiyxBBjM7JS/D55T2zH9lfnl3N9Hf6sesqhivzwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765551902; c=relaxed/simple;
	bh=WdjI8HUDSfLlY9tp6bRDC6N1ge048F/C/DXcgKv0dtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smUfVLthngpfB/xk59BibAfwpbGGLTVcHB0xw+0v4q/DsGvVndBn+kKc4XY5o7Tz4iA3CGk2ZkMzVEMLabAxqkRMmybTeEaL2OHsiUTsl9xxJ2CVDqY8OI3gncl+dlAm+0AW7zyM5pLPbI9q2c2h6wnw4e/+RkCT1Zf6BnTx9RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YZDT+SS4; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gnZVhB+A; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765551899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=33QlZAhGXHGFDxYNTuc7M9dXD1Jmdy+6/iC4UFNG7jM=;
	b=YZDT+SS4B2Mk9Fd4B0QnFK1oNXOK10s1R3tXKiaQnLCUdX3u5OZ2gBBOywpyYs0ML4Kbu5
	LrFbaxwf2e+oscgo0xqj1pBKqfkJdtg0RYFT4jNwIG1/NZgpaf8Gpl2mvzswrfQDkCBldX
	vbMp+p1JrW8UwROoIt++BOYo2gWzYQo=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-389-sMKGpQREOPO1s5aEDkRCiw-1; Fri, 12 Dec 2025 10:04:56 -0500
X-MC-Unique: sMKGpQREOPO1s5aEDkRCiw-1
X-Mimecast-MFC-AGG-ID: sMKGpQREOPO1s5aEDkRCiw_1765551895
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-29da1ea0b97so28616425ad.3
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 07:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765551895; x=1766156695; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=33QlZAhGXHGFDxYNTuc7M9dXD1Jmdy+6/iC4UFNG7jM=;
        b=gnZVhB+ArWmTiCG9PQv/IVJeYJ61YC9RjwcxvXrDgf8jRl+xguLsY9j/8gYCCgHmPk
         Myg+EYqID6qIFo9mOhDQf59XgFo8V4/kgk84WKAaCAqX96hfUkVRia0dyXX304a06e+l
         6X9vrtyvUqLHOHVrMMV86Bv1QDkFfveNPFbdxT5wYl0kcjLyp077iWpIWF6xbpxld+oD
         PVNrKxaVOwRmJGkUFFcrlVJBqAhvwILy14Oh9TH9jKmxq7hBOtWVP0m3mvZrNTWCWcjn
         KonCOJ5d8Xyax6te/LITECngTR1C9xBolHyyuTEmthV6HDWLzGLHJQtx3o7Sivl/0vMd
         1c/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765551895; x=1766156695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=33QlZAhGXHGFDxYNTuc7M9dXD1Jmdy+6/iC4UFNG7jM=;
        b=Fjju/gSUR8s8husqrFR8w/vtpsBJrsKMbVBojzmEgwmDyuVdKNefqo1caqUX8/SZnI
         0kbeFHxS60DGdbyioH4TYAbJohM+OwORz8HE6z4mHL+F5wzugaBJ7GhU79F25+PUxr4B
         q6f6wDmC8AXx1qjLRja9CyCr+A+ff3JoznDgWHHL8LS3lffqY74/5WBQocfC7aJbKrnA
         b6YLgDjjWIhwvkwA4jCRHOWWrZ2ClaRhzBSNK6W4Nh6HBzZlsZy5aFd667YRXjIQ/hL6
         +H92oQE7BnW3hOAzwcs/omyBEmzIrpBKeOUTLsNcU9k1PEgGoA6Vf/2ay7H5P+YgsrTH
         /N/g==
X-Forwarded-Encrypted: i=1; AJvYcCXxXUamwqUdu5dpfO68ikV7rb9//VvhOSWQZ91s/C+QNseX/l7svp4uEd/nG+s5VwE3r6U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTQumHm9luGv6Fxk+oZTjKcW37/uZKZ8RmwcVPbIC8SF02lCgf
	K5hBeebPBMHBMk4Ra6E38eXOYKC5YKq4PcLJhzMxbU7lxjVnE04O1UnpKcM8tT4LNbefMJou5zQ
	1GOgcjtyhfFVK8kR5A4gOECdF+VO4tV9sJ5uyacHmRvrD47r7T10axg==
X-Gm-Gg: AY/fxX5IolDgyIiahVCH7ptRv4s+Qbf08J42aQ+b+pMo5v2+r60WFuEDBk8ZwH/tSqX
	z6ad2QbQGXa3cBqI4+0tjNgN5fnlMhfS7GLjekgjKUxFh91tUzuH6qhmStYiA4ki3G6ozikkz4V
	3ks4Ov/fXnyZX2p+K2ncVIIiMrxVN2dMqU/0rY0o5KPG3NTgbE822aFYxIHyVdbw+fKmby8VEd8
	W+MlNfzXBYkZg929RIvih17zhzhA29UtSIsYHVYtD+XfO6zt9xV0JVFUXNWvjUwJz7WGZfDSPVy
	zSTGjFuR6gxqk/RMG1MQ4hyoGnYPOB6OqGhzV9yHY2Po7QJ1XFHfjdSM/Br5YhyqK6Nj2OTPPjq
	Wv8OjFdlspqfPTSc+v/dPtvJsVnpxGtz/s2OWRZ9pwUg=
X-Received: by 2002:a17:903:1aa8:b0:29e:9387:f2b7 with SMTP id d9443c01a7336-29f23de5f93mr22685825ad.11.1765551895138;
        Fri, 12 Dec 2025 07:04:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGmliy17NoT9CiscMYxPRgRHMqJ1Rk/M5PpK27wtcCKth2RCOVldpTXTYQq/2I2N1+rv1xg1g==
X-Received: by 2002:a17:903:1aa8:b0:29e:9387:f2b7 with SMTP id d9443c01a7336-29f23de5f93mr22685435ad.11.1765551894711;
        Fri, 12 Dec 2025 07:04:54 -0800 (PST)
Received: from rhel9-box.lan ([122.172.173.62])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29ee9d38ad1sm57046655ad.29.2025.12.12.07.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 07:04:54 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: vkuznets@redhat.com,
	kraxel@redhat.com,
	qemu-devel@nongnu.org,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH v1 09/28] kvm/i386: reload firmware for confidential guest reset
Date: Fri, 12 Dec 2025 20:33:37 +0530
Message-ID: <20251212150359.548787-10-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20251212150359.548787-1-anisinha@redhat.com>
References: <20251212150359.548787-1-anisinha@redhat.com>
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
index e971f5f8c4..199a224dbf 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -50,6 +50,8 @@
 #include "qemu/config-file.h"
 #include "qemu/error-report.h"
 #include "qemu/memalign.h"
+#include "qemu/datadir.h"
+#include "hw/loader.h"
 #include "hw/i386/x86.h"
 #include "hw/i386/kvm/xen_evtchn.h"
 #include "hw/i386/pc.h"
@@ -3254,6 +3256,22 @@ static int kvm_vm_enable_energy_msrs(KVMState *s)
 
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
@@ -3272,6 +3290,16 @@ int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)
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


