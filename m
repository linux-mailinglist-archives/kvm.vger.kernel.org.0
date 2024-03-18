Return-Path: <kvm+bounces-11992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D84587ECBA
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 16:54:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 587E7280FBB
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 15:54:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D11D53805;
	Mon, 18 Mar 2024 15:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C82Y/thw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3445A537E0
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 15:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710777249; cv=none; b=MjwKu1TVc7ZLRMWSngkn59MSHK71dFlmY4g9Hty3BOdtTLKcVfEWeQakFwOckrglBbXPUMbGG6CkhyJAjP21VSEhWd2S5XVkDcWGWVOzIfdapCPAwvU/97smkB8niFpsg2Wa2CxyMlcZ5HmwB3MuZZMgm9wbf1wqheTw95IWw1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710777249; c=relaxed/simple;
	bh=rUZQ/pONZoNKxKrv7NagW50n6RL2eVbGzbu8XwI0edM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGzd9hi6UTELcAQd2E+KZECEUq8okGtoWh7UxMInTYouQKk3hp9eQhlUXcAETY/lQEx3mriuHhBQgCgcL19XU+PTqX52aQUEx2xjO1PSrL+3+WJ8GOB180Rgt0dg7lSbusEZ7R+noZgcWr6hCgEYpczRywznTR/AZil0MEWSWno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C82Y/thw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710777247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=igcS/L5aoSdp/RqRXlSQ8qbrsN0mnzGNEZrfapLAc0g=;
	b=C82Y/thwAoTih+Hn0rq0FjjHJ/TyJ2xj3wzH3239qV2Nsiof53+Ev3loJBRQc0DL2GLvl8
	kj8xo4gbvnwYIWinWxTxO4OIN+85chcsIarWA8l3+Ej45s3fKe1KogK8iCF8lDdrl3wRTm
	j6V9bUXl4RARp5MwyVCfpPm9qZ2JSsI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-9gElzMerPqaRuWegFa0OUg-1; Mon, 18 Mar 2024 11:54:03 -0400
X-MC-Unique: 9gElzMerPqaRuWegFa0OUg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7AB55101A56C;
	Mon, 18 Mar 2024 15:54:03 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.254])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E4C03C20;
	Mon, 18 Mar 2024 15:54:03 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id A32E31800D61; Mon, 18 Mar 2024 16:53:36 +0100 (CET)
From: Gerd Hoffmann <kraxel@redhat.com>
To: qemu-devel@nongnu.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v4 2/2] target/i386: add guest-phys-bits cpu property
Date: Mon, 18 Mar 2024 16:53:36 +0100
Message-ID: <20240318155336.156197-3-kraxel@redhat.com>
In-Reply-To: <20240318155336.156197-1-kraxel@redhat.com>
References: <20240318155336.156197-1-kraxel@redhat.com>
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


