Return-Path: <kvm+bounces-51433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18D45AF7131
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:59:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12E774E54ED
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B231F2E3AE5;
	Thu,  3 Jul 2025 10:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VZ2QhoPq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B972E2F01
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540304; cv=none; b=Z0U8rWrNSktdCd1s++D3D7YGkuO4m1zEb5te+50NLY1X4S3igNXglQWtRDN2Pcz+7SpBkfDdunomlJ4+l8YAMU9+axhvDsO9IqXQ/gyGhMh+NeSHXMamHauJSyWUx7HH3JliATTU8dyJxl5VtcDk2V0sOG8OQ1dGux9EwPzrbs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540304; c=relaxed/simple;
	bh=Rvf7Lpd9zhXWLAuVQkTp/pmZ2syePE36cVh+z3tDbEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AxON4XoMkbnflxfDTxnfwiF9dyTyCLVWXQv1fvzz2M/Rgpha6DUiplfmXTJV/e1rUl2GFK5ZkUJOTYj0xahzZANCOQq9Ihl/s7Ol88Y2+haIJq4Vi3dGHgeymctnVyjviNOksJfi4FZRqB4HNleQlWFJKseWSsbDdUK6dhuHwPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VZ2QhoPq; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-450cf214200so45291975e9.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540301; x=1752145101; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=65bSiZBK1YYcXSsQqihiwVaoKns5se5K6zq/pnQZJmA=;
        b=VZ2QhoPqzdTpJOAmte5pqSQDq1P7Y+DZWbf7jRJLiGvwuc4Zcs/yaEOKdR+UONv6R1
         zfDgpCzxPNksT+6ldjd5o+kyveuVozC/fErRzYPHr2xQKk/NdYI5VhQ8hdKXEFyvJsla
         gXcBYtXBF1nsM25Lr08i7EqV/owyX3cAoo7LNJ5PWTn7kpQL2nIODFTZCNiKJnzvQ9O3
         IPAqlK790Sc+KKqPNXvkV7U0uArb/YSdPkA3FnjYt5az8s+02QcnTnc3gH+zcKSyyxiR
         dyvVZ874NWuqpGxSEw5JYiR8Vv8x1TozrzX5C3MjyG1sGsYajht4ZM0SHDUMyOmE+/nb
         4RBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540301; x=1752145101;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=65bSiZBK1YYcXSsQqihiwVaoKns5se5K6zq/pnQZJmA=;
        b=VN6PzpgvmPCDKn/vlKrYdEiIdrYcuzemp8M6YvxwywjObVsVEtwbGkWBsNwiKyttKJ
         HNMtUaAdeadDTOiq24gptZ8/I1b34jKEdxpQaqhgjAnyFrmgnfhRruxGMOvCTYa338am
         CPxXFN/1mp54GSCkjNDp4iTfpltunuL3aLkCsQHzdLE/v3Z+7TI1YxlKv5iaGaHcUe1y
         YNxXLSh6S5SGO2skdrPb3NHVviNfUHFiYJ/w8cDUveR85w1rMSR7/9TEt20hHG5ELkRj
         jmbYaWy7s+HC/gFjZeiiDXvwMYmYLFF/8k8WMYGfzpXyzbLuIFwL5LNTCxnZLT/RAljK
         lDbg==
X-Forwarded-Encrypted: i=1; AJvYcCUbZ0IfTvsZq2/sUF6vNXlNbGwGAVG7IVBPMmEeSzE5AiZGDNu7ck2Cj1m74mHO9R2Yxo0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFwMLSUm7dVg+Ur+sxlSyCz3MueGO7ihg+stvO9JMpcNZZ2Yco
	0wpkQD+ONCfy2d3vIJa3ZZhVe7f0e9mFW15cVy3Wz+azieXUKAhU3uEcntPjQEeU9Sw=
X-Gm-Gg: ASbGnctIk7tP03hwyov2y7q9agQKaOxGF6U83XNmGb/1qpD9zFuIVgbTeIrXn3Dgu5n
	Aa38czxXZp/DXyPDXAwvR0MPlrpCGHmy99IYH9JzRgny++xu+Ifm6MfCBdYTwJIJ9pfnxlLCgbi
	87Ov84rth+VLzkK3tFhpofmnzplt6Fg7LabYP5nsTI1Ak8oDls0tJJeBAWsorEKqCUk7JBfEleq
	TpnMF5OvsKcWiOPQTfSxqQJA29gco1939MWMM+fJJg/zl5P83QwmgycCUTFy2LP3dfhaU9avxwl
	93K+lcGTFWgZcyB2HGWAph3hBZhn7bn18U15T1h62SPSKAyrTkfJBCZpcXpJfYsab5WBy0MBNbj
	BG8+EA8WN8Xc=
X-Google-Smtp-Source: AGHT+IFnrXJdmwqfXVm57EvsTKQuyO3XMuVNe0870dybuwL8Cjih60IeaZAQMlXUOjIMVyzf3QlrkA==
X-Received: by 2002:a05:600c:8b73:b0:453:8bc7:5e53 with SMTP id 5b1f17b1804b1-454a9be89demr37655095e9.0.1751540301208;
        Thu, 03 Jul 2025 03:58:21 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9bcececsm23556015e9.23.2025.07.03.03.58.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:58:20 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	"Dr. David Alan Gilbert" <dave@treblig.org>
Subject: [PATCH v5 30/69] accel/system: Add 'info accel' on human monitor
Date: Thu,  3 Jul 2025 12:54:56 +0200
Message-ID: <20250703105540.67664-31-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

'info accel' dispatches to the AccelOpsClass::get_stats()
and get_vcpu_stats() handlers.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Acked-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 accel/accel-system.c |  8 ++++++++
 hmp-commands-info.hx | 12 ++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/accel/accel-system.c b/accel/accel-system.c
index 246ea55425f..6cdfe485c29 100644
--- a/accel/accel-system.c
+++ b/accel/accel-system.c
@@ -25,6 +25,8 @@
 
 #include "qemu/osdep.h"
 #include "qemu/accel.h"
+#include "qapi/qapi-commands-accelerator.h"
+#include "monitor/monitor.h"
 #include "hw/boards.h"
 #include "hw/core/cpu.h"
 #include "system/accel-ops.h"
@@ -112,11 +114,17 @@ void accel_init_ops_interfaces(AccelClass *ac)
     cpus_register_accel(ops);
 }
 
+static void accel_ops_class_init(ObjectClass *oc, const void *data)
+{
+    monitor_register_hmp_info_hrt("accel", qmp_x_accel_stats);
+}
+
 static const TypeInfo accel_ops_type_info = {
     .name = TYPE_ACCEL_OPS,
     .parent = TYPE_OBJECT,
     .abstract = true,
     .class_size = sizeof(AccelOpsClass),
+    .class_init = accel_ops_class_init,
 };
 
 static void accel_system_register_types(void)
diff --git a/hmp-commands-info.hx b/hmp-commands-info.hx
index d7979222752..6142f60e7b1 100644
--- a/hmp-commands-info.hx
+++ b/hmp-commands-info.hx
@@ -267,6 +267,18 @@ ERST
         .cmd        = hmp_info_sync_profile,
     },
 
+    {
+        .name       = "accel",
+        .args_type  = "",
+        .params     = "",
+        .help       = "show accelerator info",
+    },
+
+SRST
+  ``info accel``
+    Show accelerator info.
+ERST
+
 SRST
   ``info sync-profile [-m|-n]`` [*max*]
     Show synchronization profiling info, up to *max* entries (default: 10),
-- 
2.49.0


