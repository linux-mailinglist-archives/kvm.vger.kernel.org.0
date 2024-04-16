Return-Path: <kvm+bounces-14850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 362038A7403
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 20:59:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E0BE11F22A0E
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 18:59:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFFAD137753;
	Tue, 16 Apr 2024 18:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CyDO0Kc/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DA113777B
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 18:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713293993; cv=none; b=C/1l008g2iB8bqiSk+e1+Kk8yOLwOwfAJCPLejoTsiER+95M5aCKvrXGWzOULxp8/5jRmUQvPCRhdoHaV6usFkMfwcre5lHREN2siFREma+MGCxvaW60lzcJ58HIvKjvyob3Qp3HUShQ+zk5iRHuiqBMPhktRnd00BFnL2E4Oe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713293993; c=relaxed/simple;
	bh=qZVw8qXVkxP9KjkLMsyOLdkX3pLPXSoFzN/nxJ37BW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZI74MgDbMv/O5Gw5busF6x7rAkjbFBOTVZYr1KWoYNd+4V4fBfYjrhtePka98MWCA0X/D8Xh/t+lWVFXEPJRDzrRoS3knE44NKO0g/ng98szzq5jhwq/gOgCtgrdSKBnHmurUIscX0AIu1rPpSpXHm0ge75hc3zdL1Wijjc6t2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CyDO0Kc/; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a51b008b3aeso590413866b.3
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 11:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713293990; x=1713898790; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+xDdgtYhdKYRWfSSiojdSyo8J+LTMwwnUVOciC/4kns=;
        b=CyDO0Kc/QxTOuVOrdGK3cxPRlpyF1EilvXt/bGU8yuUtbNFLSdHohkRiqVq+OK/s2Q
         MClZP7AamVHAJdaFdoVeZn7w5dyr/Co7hBMEw9uB4+mmMMLEeTTOwL2w7DG7ga11R46z
         q3hAknSJwmznO7NvYrQXAP+/xi6ecKU+E+Ll3LfyQAoB9sWSR5b6qu2eKLceO3W3ta8X
         r6S898nk3ryzOtKTOSyZrLdIkLxFt0n4EdqX+jPE99cK1JkFVcHw9KCzKC2mgRlyiK/Q
         OsQl7QjgohdKx3Cgpe08ybcnk9HyhLmwnY23M2LvPB7jlgANbo4TKZXIPp8S/9JtGyX9
         B1HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713293990; x=1713898790;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+xDdgtYhdKYRWfSSiojdSyo8J+LTMwwnUVOciC/4kns=;
        b=WPu9S7sqaPPF1vm8Q5wfGDJxILx/+nGKR5eEyytwP/ylPIBOMqayGeEc2B8s40P6lY
         RLFWiHjIgHb4GlvOeKwd0C8FgkEq5BUIKgRaiBA862LK+QvLqtZ8JPk6S7zmQkKD8v6I
         Z0umP2tl3SXj0zOcmMG4NsZtT6BQnUsyrGtYDsjKx6SKTHLEVMsW1PI5XFxk3iuov3xW
         45jdficdD3xp3O0C4kaKjSz9ELNWwCP+N/yNOQdgxDiTH7eS7wPyXhA0JIRDlM75744W
         udq7b2ezIouP9bvmLfJ0KqdyT25Z66krr+V3kUsBFS86OclvZR8sBWO/Iji1/A6opVcj
         2Atg==
X-Forwarded-Encrypted: i=1; AJvYcCXdtaL9aE396jLZDcs7OYFHTkxTzxFq1d89f+xw0NRjha2qtuo3YugRHnHUdeMZzVQ51rI//c0dmc8q5xdwr5PjDbPT
X-Gm-Message-State: AOJu0YzPCX4pg4QMyOL/X06tH6qhO12RGmHl8UBuIcxSU8L2Jxfm52ev
	JBor/lVu/EcDsqNnpAKdUS7lM6AnjsIiuy/gMlnF5z93zs7xIsj1yd9SKNakkcdoX026zgaZid/
	7
X-Google-Smtp-Source: AGHT+IEDNy9nz2o8/rgG8dWOKTg8TwpSrw8fZ0OTvZcdzdz1ruK9kl5BqonIaZQSNdgaf9AzfUmw8A==
X-Received: by 2002:a17:907:9803:b0:a51:d204:d69e with SMTP id ji3-20020a170907980300b00a51d204d69emr12935641ejc.7.1713293989842;
        Tue, 16 Apr 2024 11:59:49 -0700 (PDT)
Received: from m1x-phil.lan ([176.176.155.61])
        by smtp.gmail.com with ESMTPSA id gc21-20020a170906c8d500b00a53e0db2f29sm2313701ejb.182.2024.04.16.11.59.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Apr 2024 11:59:49 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Thomas Huth <thuth@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	qemu-riscv@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	devel@lists.libvirt.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: [PATCH v4 01/22] hw/i386/pc: Deprecate 2.4 to 2.12 pc-i440fx machines
Date: Tue, 16 Apr 2024 20:59:17 +0200
Message-ID: <20240416185939.37984-2-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240416185939.37984-1-philmd@linaro.org>
References: <20240416185939.37984-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Similarly to the commit c7437f0ddb "docs/about: Mark the
old pc-i440fx-2.0 - 2.3 machine types as deprecated",
deprecate the 2.4 to 2.12 machines.

Suggested-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 docs/about/deprecated.rst | 4 ++--
 hw/i386/pc_piix.c         | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/docs/about/deprecated.rst b/docs/about/deprecated.rst
index 7b548519b5..47234da329 100644
--- a/docs/about/deprecated.rst
+++ b/docs/about/deprecated.rst
@@ -219,8 +219,8 @@ deprecated; use the new name ``dtb-randomness`` instead. The new name
 better reflects the way this property affects all random data within
 the device tree blob, not just the ``kaslr-seed`` node.
 
-``pc-i440fx-2.0`` up to ``pc-i440fx-2.3`` (since 8.2)
-'''''''''''''''''''''''''''''''''''''''''''''''''''''
+``pc-i440fx-2.0`` up to ``pc-i440fx-2.3`` (since 8.2) and ``pc-i440fx-2.4`` up to ``pc-i440fx-2.12`` (since 9.1)
+''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 
 These old machine types are quite neglected nowadays and thus might have
 various pitfalls with regards to live migration. Use a newer machine type
diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
index 18ba076609..817d99c0ce 100644
--- a/hw/i386/pc_piix.c
+++ b/hw/i386/pc_piix.c
@@ -727,6 +727,7 @@ DEFINE_I440FX_MACHINE(v3_0, "pc-i440fx-3.0", NULL,
 static void pc_i440fx_2_12_machine_options(MachineClass *m)
 {
     pc_i440fx_3_0_machine_options(m);
+    m->deprecation_reason = "old and unattended - use a newer version instead";
     compat_props_add(m->compat_props, hw_compat_2_12, hw_compat_2_12_len);
     compat_props_add(m->compat_props, pc_compat_2_12, pc_compat_2_12_len);
 }
@@ -832,7 +833,6 @@ static void pc_i440fx_2_3_machine_options(MachineClass *m)
 {
     pc_i440fx_2_4_machine_options(m);
     m->hw_version = "2.3.0";
-    m->deprecation_reason = "old and unattended - use a newer version instead";
     compat_props_add(m->compat_props, hw_compat_2_3, hw_compat_2_3_len);
     compat_props_add(m->compat_props, pc_compat_2_3, pc_compat_2_3_len);
 }
-- 
2.41.0


