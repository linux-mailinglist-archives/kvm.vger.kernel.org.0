Return-Path: <kvm+bounces-11529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FE4F877E45
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 11:42:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A225AB21709
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 10:41:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1347539FEF;
	Mon, 11 Mar 2024 10:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fuo5BxoK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB1038DD8
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 10:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710153689; cv=none; b=odQ0cJAcsje9C4doubxZ8N2pyw+wtQaGL7VBGIEJAHlVmLBK124iyY41W3rWzne5fV7YtDMg4upRkmquj+ta+Ga7s/1GSUUb9jcQMAle7iDUCo7gC0JFGlJQ0vckCGLBgpcQXFVNbYANCHO7GTlbS9NBOLeGDRbmMCdV5rs4vGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710153689; c=relaxed/simple;
	bh=MSKDyAI0xCcsSThDCwZZVUd6rs3dtSQH0t2OgHt/rGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQcGnqQmtl78I7FaMyIJFqOXrdxHKS9xqn6x4mAg+Gum3sOgldxsw81ezkbFhQ4GJX6xFzxnKMHOIWJkKgIfu8JWwaxz4vQOddbojvEbaoHT2OTvKyhHdSXAL3AEwxxVnJ4xjfWoXlEhnYnT7jjVlQGg7fxYRzhhqMGLHOnR77Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fuo5BxoK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710153686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hlLFoX1P5jTKtS2weQZan201tuv3XXgj03SclaGMt18=;
	b=Fuo5BxoK+VgDM6TZ/0zVwoFFC2aHZX/tXLv/mFKD6X2NgjPSX5TdRNNDhUVKmaVAbylmys
	ZVnbd8+AQNXUfjks+FWqFqQ90c92ABrF5cwOdIKHn4Kq0XHid7jh/Jzf2NvFBB7PcEJR6M
	tGTadjgCuT7ZrRhNRiz1RmXh6R0c5Kg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-132-kXFcFobtOHuxPc7jyORB9Q-1; Mon,
 11 Mar 2024 06:41:21 -0400
X-MC-Unique: kXFcFobtOHuxPc7jyORB9Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C94131C02D26;
	Mon, 11 Mar 2024 10:41:20 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.160])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 85A3D8173;
	Mon, 11 Mar 2024 10:41:19 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 639251801A8E; Mon, 11 Mar 2024 11:41:18 +0100 (CET)
From: Gerd Hoffmann <kraxel@redhat.com>
To: kvm@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND 64-BIT))
Subject: [PATCH v3 1/2] kvm/cpuid: remove GuestPhysBits code.
Date: Mon, 11 Mar 2024 11:41:16 +0100
Message-ID: <20240311104118.284054-2-kraxel@redhat.com>
In-Reply-To: <20240311104118.284054-1-kraxel@redhat.com>
References: <20240311104118.284054-1-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

GuestPhysBits (cpuid leaf 80000008, eax[23:16]) is intended for software
use.  Physical CPUs do not set that field.  The current code which
propagates the host's GuestPhysBits to the guest's PhysBits does not
make sense.  Remove it.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 arch/x86/kvm/cpuid.c | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index adba49afb5fe..c638b5fb2144 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1221,26 +1221,22 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->eax = entry->ebx = entry->ecx = 0;
 		break;
 	case 0x80000008: {
-		unsigned g_phys_as = (entry->eax >> 16) & 0xff;
-		unsigned virt_as = max((entry->eax >> 8) & 0xff, 48U);
-		unsigned phys_as = entry->eax & 0xff;
+		unsigned int virt_as = max((entry->eax >> 8) & 0xff, 48U);
+		unsigned int phys_as;
 
-		/*
-		 * If TDP (NPT) is disabled use the adjusted host MAXPHYADDR as
-		 * the guest operates in the same PA space as the host, i.e.
-		 * reductions in MAXPHYADDR for memory encryption affect shadow
-		 * paging, too.
-		 *
-		 * If TDP is enabled but an explicit guest MAXPHYADDR is not
-		 * provided, use the raw bare metal MAXPHYADDR as reductions to
-		 * the HPAs do not affect GPAs.
-		 */
-		if (!tdp_enabled)
-			g_phys_as = boot_cpu_data.x86_phys_bits;
-		else if (!g_phys_as)
-			g_phys_as = phys_as;
+		if (!tdp_enabled) {
+			/*
+			 * If TDP (NPT) is disabled use the adjusted host
+			 * MAXPHYADDR as the guest operates in the same PA
+			 * space as the host, i.e.  reductions in MAXPHYADDR
+			 * for memory encryption affect shadow paging, too.
+			 */
+			phys_as = boot_cpu_data.x86_phys_bits;
+		} else {
+			phys_as = entry->eax & 0xff;
+		}
 
-		entry->eax = g_phys_as | (virt_as << 8);
+		entry->eax = phys_as | (virt_as << 8);
 		entry->ecx &= ~(GENMASK(31, 16) | GENMASK(11, 8));
 		entry->edx = 0;
 		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
-- 
2.44.0


