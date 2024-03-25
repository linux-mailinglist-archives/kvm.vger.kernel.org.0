Return-Path: <kvm+bounces-12590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F85C88A9A3
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 17:39:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8227F1C61255
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 16:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F57314D2B2;
	Mon, 25 Mar 2024 14:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HXJEK8IE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDD314D2A7
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 14:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711378061; cv=none; b=BC2tgEGH1MXcGrLfXwtZoF9dKQyoXsS93szUF1XNHhht98HNjKf6Y18qOU7nbAY6Ie5h9rcKsntUmabkOI+IKk8jZA8BO2qslfgrEBtAMrFbr+ptxlCeuxOXU+35omg4r1uhhXsZMNLQA06+Hzjn91gbSMa3ANfMDbZFzMl9s4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711378061; c=relaxed/simple;
	bh=GTmM8vLVnfDJNCDlIZTuXHQn6avz5v/tLGQoeLNr+EE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pdnrUu8gocima0AH33JP9McY396phcWmvgjpnTzJGumlqklWBuk4ky12PLJtFVwHODLsgYUzmf34sIW46zyA8w9IIy64Ju84pJWKlR1cpYSy1wDWiXmWmYE2lNHBr3nUmwB4xkqMnSjSaUl2o2pIfJHqHkNsoVCr5msYYc2Gao4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HXJEK8IE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711378059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DsJzNPnYlAzllKzELoC8ajG8VB6UCIrLwt5d6+Usjys=;
	b=HXJEK8IEvDflafCBM+Kth2QcSdulio0SwAqWjd9UTBTPDQ2bJSq7gaT3kfGYT1UFAei0ER
	KKQCQtPuXSqiVqAXG/bPU9S57j4oBKIvl7o3CyrEt32Mec6H5AdqPcXUjQWBN48cR+MBxn
	aWYil7kl4e35xH/LFl5mrFYmQla7qHk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-403-XMZUEqHON_e8BDus4gvrKg-1; Mon,
 25 Mar 2024 10:47:36 -0400
X-MC-Unique: XMZUEqHON_e8BDus4gvrKg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60FDB2800E8F;
	Mon, 25 Mar 2024 14:47:36 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.158])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 05EA51121306;
	Mon, 25 Mar 2024 14:47:36 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 9AB551801CDC; Mon, 25 Mar 2024 15:47:25 +0100 (CET)
From: Gerd Hoffmann <kraxel@redhat.com>
To: qemu-devel@nongnu.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v5 2/2] target/i386: add guest-phys-bits cpu property
Date: Mon, 25 Mar 2024 15:47:24 +0100
Message-ID: <20240325144725.1089192-3-kraxel@redhat.com>
In-Reply-To: <20240325144725.1089192-1-kraxel@redhat.com>
References: <20240325144725.1089192-1-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Allows to set guest-phys-bits (cpuid leaf 80000008, eax[23:16])
via -cpu $model,guest-phys-bits=$nr.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/cpu.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 3b7bd506baf1..79bea83b7b1c 100644
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


