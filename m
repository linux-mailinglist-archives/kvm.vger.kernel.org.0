Return-Path: <kvm+bounces-65911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B5A8CBA190
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 01:15:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8694030ACE84
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 00:14:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 857B019755B;
	Sat, 13 Dec 2025 00:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lrkcOu5w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAD9155389
	for <kvm@vger.kernel.org>; Sat, 13 Dec 2025 00:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765584894; cv=none; b=No2h20c8SkCP9zV4KWMtSfyGar2sTKLS0Zecy+LVwnc3+sItT8RxaPwzalf+3O/XR+eUl6ybUi8CoG2DkgGhBzB3CyGMpEK7kajvkcLA21+LhVOziawXCXHYwQrv5DUeUGkvMqcgUt3HocukmCbGbePxhRCsGJk5hCljAlAnn9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765584894; c=relaxed/simple;
	bh=64HLfHNEWTJh4SEkK+tIry6ZVjADsS79XpX4JD1NJlg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K9Z0QEvhv9DuCitwg9/E+H6ak3ZhPm4xlEmQoeas4KBF8Nnd2gYOlDR1B6Dn2kpzYN265hopGZKHkcxDv+WVVDXDDFTyakI/sISpec+Kz95g+j4lryXKz5BbsiDHdrz7lzcJF4cSTf8aNkuVX+Zs1SmMxzhxwv5br2vq15noBTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--marcmorcos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lrkcOu5w; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--marcmorcos.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-bc09a8454b9so3411607a12.1
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 16:14:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765584892; x=1766189692; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a9byHUhq171lB8iBLQB0kPeEXv2KRtdFiOEay6iUm0M=;
        b=lrkcOu5w+qMRzCeAsspWMywHdP1LLiwF+NovIX7PgJHEE8+HXqkiSofZ/eFlP48wVA
         l22S5Z75+iBA3K/VeHUsg6eNsTa0/Vf0Md3w/lDGW1bsV6MVl62f+/jRw3OoIC66g+7/
         1eE/wqwLtiOaOPaY+ygkddSV5g5/soe3sQOqsCvSeqKAIEZDuq8xk0byoZsqqQ7mnQks
         lHAi/XDC2gTv1MbpZVRhKTTjhdFI5EFsR29wff9Vl8Rm0ZGPycr9fMwQf+cfCVEtacHA
         NmBM37FkAp4VpuTD5OgZ11h49uyQRIUkUBaVOQ9L4ESyEiJ3HZjxsBQbnHNuM89E4q2q
         O4Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765584892; x=1766189692;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a9byHUhq171lB8iBLQB0kPeEXv2KRtdFiOEay6iUm0M=;
        b=ILTUMkrlUsaiFHHB63fLTWT8UOCdqMtosOdQXZL/t2Y02AwXW2GVkNDBRt28OiI5J7
         Z2ZrZTJRK5j5eIQE+uoAwJt4DzazdOb3/l34anM2l3BG3xNrAUO8FXatDVA8ZkiyC9ay
         qU3BfT/eeHS6Baf38kgp+hZBvgT67kZ5iTiapG72EgBJ8CNEeqjU9mO7d3XRkLyopXlj
         JeNt8vEBhZDJbAuejpDWrjRE06/cU0KTvkadwuKU9lGj81UlCl08pWQg3l6/4aXZsiFQ
         AMCkm1A2zg5Jpun7P2Jn8agG0UdMEOLD6a0S90jGF8Zs85u4TOZx6zQUkPmuANf1TNkj
         zBvA==
X-Forwarded-Encrypted: i=1; AJvYcCWaiVn3Fq8pDA/3qsXkrlQTkz343/cVH5RRIR7xeILqHmEGfO5txSsjEKjtUzPxRye0fr8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyE37O1o/b1PN19yglmpilaYxBElpJDAB79cJM+n/LbbOswfDj6
	0TfAXPI5iDG1wrfN/sDIbRtpXJULQVUmBB1ZHvNhT+aHYo5ti+j/fhjikDtFPj+LtLT/v11evy8
	LFIssXF/cdJvL6I0bmMCBRw==
X-Google-Smtp-Source: AGHT+IGcin5hyq+n2qr2rmLGMVgo9UOC9nitcjENNrPSfYURQhY4WzARb8mesPEMZ3bMottnA8mjRAjvdj3DTytt
X-Received: from dyx19.prod.google.com ([2002:a05:693c:8213:b0:2a4:6ffc:87c9])
 (user=marcmorcos job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:8283:b0:2a4:4bce:309c with SMTP id 5a478bee46e88-2ac3025c82emr2257346eec.22.1765584892396;
 Fri, 12 Dec 2025 16:14:52 -0800 (PST)
Date: Sat, 13 Dec 2025 00:14:40 +0000
In-Reply-To: <20251213001443.2041258-1-marcmorcos@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251213001443.2041258-1-marcmorcos@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251213001443.2041258-2-marcmorcos@google.com>
Subject: [PATCH 1/4] apic: Resize APICBASE
From: Marc Morcos <marcmorcos@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, 
	Eduardo Habkost <eduardo@habkost.net>, "Dr . David Alan Gilbert" <dave@treblig.org>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, 
	Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org, Marc Morcos <marcmorcos@google.com>
Content-Type: text/plain; charset="UTF-8"

 APICBASE is 36-bits wide, so this commit resizes it to hold the full data.

Signed-off-by: Marc Morcos <marcmorcos@google.com>
---
 hw/intc/apic_common.c           | 4 ++--
 include/hw/i386/apic_internal.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/hw/intc/apic_common.c b/hw/intc/apic_common.c
index ec9e978b0b..1e9aba2e48 100644
--- a/hw/intc/apic_common.c
+++ b/hw/intc/apic_common.c
@@ -233,7 +233,7 @@ static void apic_reset_common(DeviceState *dev)
 {
     APICCommonState *s = APIC_COMMON(dev);
     APICCommonClass *info = APIC_COMMON_GET_CLASS(s);
-    uint32_t bsp;
+    uint64_t bsp;
 
     bsp = s->apicbase & MSR_IA32_APICBASE_BSP;
     s->apicbase = APIC_DEFAULT_ADDRESS | bsp | MSR_IA32_APICBASE_ENABLE;
@@ -363,7 +363,7 @@ static const VMStateDescription vmstate_apic_common = {
     .post_load = apic_dispatch_post_load,
     .priority = MIG_PRI_APIC,
     .fields = (const VMStateField[]) {
-        VMSTATE_UINT32(apicbase, APICCommonState),
+        VMSTATE_UINT64(apicbase, APICCommonState),
         VMSTATE_UINT8(id, APICCommonState),
         VMSTATE_UINT8(arb_id, APICCommonState),
         VMSTATE_UINT8(tpr, APICCommonState),
diff --git a/include/hw/i386/apic_internal.h b/include/hw/i386/apic_internal.h
index 4a62fdceb4..c7ee65ce1d 100644
--- a/include/hw/i386/apic_internal.h
+++ b/include/hw/i386/apic_internal.h
@@ -158,7 +158,7 @@ struct APICCommonState {
 
     MemoryRegion io_memory;
     X86CPU *cpu;
-    uint32_t apicbase;
+    uint64_t apicbase;
     uint8_t id; /* legacy APIC ID */
     uint32_t initial_apic_id;
     uint8_t version;
-- 
2.52.0.239.gd5f0c6e74e-goog


