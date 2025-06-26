Return-Path: <kvm+bounces-50809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 049C4AE9705
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 09:42:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05AAE5A64DA
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 07:42:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D753254877;
	Thu, 26 Jun 2025 07:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="No4Rc7iQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C068E243946
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 07:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750923768; cv=none; b=MVDO0dR8ywO/FhGPrHDIm1qTThmc5ZHESiRHHBukCmEiZ3zTrrHNWkBa93JjO6XRI5jmQLWL5HAYdTwgkWPGpjRhBaHrv5l67VMph8Xn+dDueU0E8LY3OrhSz21JhfG2dTtVUa8LKuzoUYlyMeMcv2HWMrLUjeOxRZuipc1Zaio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750923768; c=relaxed/simple;
	bh=FXaCa+tlPWoLjJx5NUhwjyQ0U74JujZlcyBDv95KtCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2a3RXz+v1ysEGAhADC3dSwFU/MmJfHGQV4+pLhafgzFjgOk1xmhvd2zRGI0SGm4vu7WeoN60pizh/VxjMVJVVe4dJ3D1pDYpGHugGws1/nTV5u8RKYlYUrlEOOwqcfiAfB0CGyfMhJoDmHWtewIvaT91zOqOktpuXLzCSs6igo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=No4Rc7iQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750923765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fL7qUVN5s9wt/WVBO2x7YVy9mPLkePTH21hQ8X2erCQ=;
	b=No4Rc7iQBXb0WVUq8ZsYhwGZ5Q+a2hWaeTzu+zUYC5vlzzdqx9qiBL7S5w7fg/AC3ki5Te
	wHaV8jnYvKJw8OgHS/8hOEyyZDrvzzrB9/PeivA5nJuUXAm6t6iqwKdoSP34ISZ443HWDe
	cBbFx5pJZF2lr9vkyIIGPPdD3kHnItU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-502-2Z1v0pY_MgWABXH4M-XSow-1; Thu,
 26 Jun 2025 03:42:42 -0400
X-MC-Unique: 2Z1v0pY_MgWABXH4M-XSow-1
X-Mimecast-MFC-AGG-ID: 2Z1v0pY_MgWABXH4M-XSow_1750923760
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EDC78180028F;
	Thu, 26 Jun 2025 07:42:39 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.44.32.244])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D84BA194128F;
	Thu, 26 Jun 2025 07:42:38 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 4F4DE180038A; Thu, 26 Jun 2025 09:42:36 +0200 (CEST)
From: Gerd Hoffmann <kraxel@redhat.com>
To: linux-coco@lists.linux.dev,
	kvm@vger.kernel.org
Cc: Gerd Hoffmann <kraxel@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND 64-BIT))
Subject: [PATCH v3 1/2] x86/sev/vc: fix efi runtime instruction emulation
Date: Thu, 26 Jun 2025 09:42:34 +0200
Message-ID: <20250626074236.307848-2-kraxel@redhat.com>
In-Reply-To: <20250626074236.307848-1-kraxel@redhat.com>
References: <20250626074236.307848-1-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

In case efi_mm is active go use the userspace instruction decoder which
supports fetching instructions from active_mm.  This is needed to make
instruction emulation work for EFI runtime code, so it can use cpuid
and rdmsr.

EFI runtime code uses the cpuid instruction to gather information about
the environment it is running in, such as SEV being enabled or not, and
choose (if needed) the SEV code path for ioport access.

EFI runtime code uses the rdmsr instruction to get the location of the
CAA page (see SVSM spec, section 4.2 - "Post Boot").

The big picture behind this is that the kernel needs to be able to
properly handle #VC exceptions that come from EFI runtime services.
Since EFI runtime services have a special page table mapping for the EFI
virtual address space, the efi_mm context must be used when decoding
instructions during #VC handling.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 arch/x86/coco/sev/vc-handle.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/coco/sev/vc-handle.c b/arch/x86/coco/sev/vc-handle.c
index 0989d98da130..e498a8965939 100644
--- a/arch/x86/coco/sev/vc-handle.c
+++ b/arch/x86/coco/sev/vc-handle.c
@@ -17,6 +17,7 @@
 #include <linux/mm.h>
 #include <linux/io.h>
 #include <linux/psp-sev.h>
+#include <linux/efi.h>
 #include <uapi/linux/sev-guest.h>
 
 #include <asm/init.h>
@@ -178,9 +179,14 @@ static enum es_result __vc_decode_kern_insn(struct es_em_ctxt *ctxt)
 		return ES_OK;
 }
 
+/*
+ * User instruction decoding is also required for the EFI runtime. Even though
+ * EFI runtime is running in kernel mode, it uses special EFI virtual address
+ * mappings that require the use of efi_mm to properly address and decode.
+ */
 static enum es_result vc_decode_insn(struct es_em_ctxt *ctxt)
 {
-	if (user_mode(ctxt->regs))
+	if (user_mode(ctxt->regs) || current->active_mm == &efi_mm)
 		return __vc_decode_user_insn(ctxt);
 	else
 		return __vc_decode_kern_insn(ctxt);
-- 
2.50.0


