Return-Path: <kvm+bounces-11734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9B1187A84E
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 14:27:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 080291C20BC6
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 13:27:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9568042069;
	Wed, 13 Mar 2024 13:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NlzWGRLw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5870B3F9E8
	for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 13:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710336449; cv=none; b=B0Lf/WqHYyeVmRax9IlCAE8Yha+0zoFU+2TivsHxP4l9qE5XB0ZEzLz9TmSOuuu89uHOYMv4CRpU8w3nO1EHPDreCBclPni/JtHFnHoJ36QydkVGJZORXslMPJaB828cR+fdlDUP9Vuv9iJCY18rPMEjDM19q3azvamZ7iQrpyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710336449; c=relaxed/simple;
	bh=rUZQ/pONZoNKxKrv7NagW50n6RL2eVbGzbu8XwI0edM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0bVEtfJstKrW5QTu+0lv7tvsDxJWor8xBkqSCoAq7t4qZzaQFjUPiUrgfN0t5KDX1qjAFFEX5pNHcxs6Y8ldoaheMC7l1GQqMd+THHzu21aeEaIXZtJM/ItN8MQY/3S5GV7OJECfGoXYN4eCPfPmjeh5AuKV5oaeSLPoK9slY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NlzWGRLw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710336447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=igcS/L5aoSdp/RqRXlSQ8qbrsN0mnzGNEZrfapLAc0g=;
	b=NlzWGRLwOPt88gEGYuEM1Kv4UF9UKb4NTmZwWDO8Pvgq3IflPJXw0HSKQRsC/XQRKXNpgF
	kpq0zNz43w83M7ETJYlAOX7u7mGVvgqIXBBjKnPviMj+0H18DuyoQpFGAmv4LRwe5UlkNs
	sU/4cg6735APz5Xo1/7yjPHLAb2/ctE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-n-x4ZdetNKW0BlS1svFm4A-1; Wed, 13 Mar 2024 09:27:23 -0400
X-MC-Unique: n-x4ZdetNKW0BlS1svFm4A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B65118003A1;
	Wed, 13 Mar 2024 13:27:23 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.160])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5020737F4;
	Wed, 13 Mar 2024 13:27:22 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id AA0851801A91; Wed, 13 Mar 2024 14:27:19 +0100 (CET)
From: Gerd Hoffmann <kraxel@redhat.com>
To: qemu-devel@nongnu.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v3 3/3] target/i386: add guest-phys-bits cpu property
Date: Wed, 13 Mar 2024 14:27:19 +0100
Message-ID: <20240313132719.939417-4-kraxel@redhat.com>
In-Reply-To: <20240313132719.939417-1-kraxel@redhat.com>
References: <20240313132719.939417-1-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

Allows to set guest-phys-bits (cpuid leaf 80000008, eax[23:16])
via -cpu $model,guest-phys-bits=$nr.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/cpu.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index c88c895a5b3e..e0d73b6ec654 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7380,6 +7380,14 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
         if (cpu->phys_bits == 0) {
             cpu->phys_bits = TCG_PHYS_ADDR_BITS;
         }
+        if (cpu->guest_phys_bits &&
+            (cpu->guest_phys_bits > cpu->phys_bits ||
+            cpu->guest_phys_bits < 32)) {
+            error_setg(errp, "guest-phys-bits should be between 32 and %u "
+                             " (but is %u)",
+                             cpu->phys_bits, cpu->guest_phys_bits);
+            return;
+        }
     } else {
         /* For 32 bit systems don't use the user set value, but keep
          * phys_bits consistent with what we tell the guest.
@@ -7388,6 +7396,10 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
             error_setg(errp, "phys-bits is not user-configurable in 32 bit");
             return;
         }
+        if (cpu->guest_phys_bits != 0) {
+            error_setg(errp, "guest-phys-bits is not user-configurable in 32 bit");
+            return;
+        }
 
         if (env->features[FEAT_1_EDX] & (CPUID_PSE36 | CPUID_PAE)) {
             cpu->phys_bits = 36;
@@ -7888,6 +7900,7 @@ static Property x86_cpu_properties[] = {
     DEFINE_PROP_BOOL("x-force-features", X86CPU, force_features, false),
     DEFINE_PROP_BOOL("kvm", X86CPU, expose_kvm, true),
     DEFINE_PROP_UINT32("phys-bits", X86CPU, phys_bits, 0),
+    DEFINE_PROP_UINT32("guest-phys-bits", X86CPU, guest_phys_bits, 0),
     DEFINE_PROP_BOOL("host-phys-bits", X86CPU, host_phys_bits, false),
     DEFINE_PROP_UINT8("host-phys-bits-limit", X86CPU, host_phys_bits_limit, 0),
     DEFINE_PROP_BOOL("fill-mtrr-mask", X86CPU, fill_mtrr_mask, true),
-- 
2.44.0


