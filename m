Return-Path: <kvm+bounces-50379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF6E2AE4909
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 17:44:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4810C1762E4
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 15:44:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A9F828DEF0;
	Mon, 23 Jun 2025 15:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="HkP3qsNN"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9749A277004;
	Mon, 23 Jun 2025 15:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750693479; cv=none; b=sCNjhqqgx5fXk+aEfLHbZmCbhfUzRLxgfUBvt2l3aVTjJUDB0jwplhC9ACONCV9RwE4TbzF7iP7RnZWW21/EzafRk3CI9vKty+OTdJ0Y9/z+X80myYRESyGiwmy4vvtupz/exBWWDJ66CtjQXiy3wyt24Bwc9q0r6Ory2vvFcJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750693479; c=relaxed/simple;
	bh=z6uWI1cuaie6yf/MtpZ0mP75H9G/PCflk8KuC0hKgJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LREGHo89d08xfGTkd6OLOl3KZFXJYH/AdDxcR0jBMQJF6UiXD9FiGcx7vfziNYD1H29mwdWAZiRVUTgo3triL/P4ilcIwiN1Q/V+NYTl2FTQGPaNKqf01tuU500KrpXltQ6BJAzWVvfSuHM2Kdd6cP9vbxxQuNjC5NEtxEt1o/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=HkP3qsNN; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 0428640E01A0;
	Mon, 23 Jun 2025 15:44:34 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id omm5Wp-Yq0vh; Mon, 23 Jun 2025 15:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1750693469; bh=wkp2duUgrbyHfHewe7CWhV6ocxmAcIGEYojd8cQElpo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HkP3qsNNiJJ+XYR1A5c/QlkUtdLVxxhFc+aWvHh4CZOQl82P6ET11X2ldr4GVjq1J
	 amx3yHCjgGarLNglQY5sbxuj18TEwaOKByX0/Fv1DEKBJlFpJlR7xXKXHDa0ndg+kD
	 YxSEfD3kkgFKTnOz907L0OBsKkEsofL5WBXpsMtyAdCNWiHp1K4/KVJLKHVQr73thD
	 zT7MycV+9igUBBNBR27W9ep0DLgYevdR45Feui+oKwPASluTc4MJxY26JtlJilfswK
	 Ywui0rTsgN5X0N84HIC+aM+Vhs4I1ExmEnQzGrF4f4KFu8Q7pMJdcTJ/hJpLgYDmiR
	 A1whvZj1hzEdGy7ihNLqfdfv5y5WL7taIedwUomsdfxtdJOf8DR8kMQgKw3EjxBvyU
	 +l1ad0o3ve0TP7ot/QNk4OVfk4dymv0RACGdYEIqX5ESZXkoJAkPLub/aQZksmW6wJ
	 pIB6tyE86co+3/ne0kIgJhdox2YU3xMkf9NKii+dBTpGX22HVc8Swkzj3/xUZgAxXM
	 Q0uJfsnbZz3+e7gl2AlPDRFcBhNrTs1S0NJhoY8LCvKzXnuWt4KY6DrnDi8iHl76Ys
	 jws/O0SLKY3+PIdfYQ7BiZlYuJbdrY6Yb6UWcU5ANwA3zWIU3+bAWQFaMadA70N/rT
	 gP1HkJXYX7+nAT4LuYRkC+zY=
Received: from zn.tnic (p57969c58.dip0.t-ipconnect.de [87.150.156.88])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 080B240E00CE;
	Mon, 23 Jun 2025 15:44:18 +0000 (UTC)
Date: Mon, 23 Jun 2025 17:44:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>, linux-coco@lists.linux.dev,
	kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] x86/sev/vc: fix efi runtime instruction emulation
Message-ID: <20250623154412.GHaFl2TJL0iGvy30JY@fat_crate.local>
References: <20250602105050.1535272-1-kraxel@redhat.com>
 <20250602105050.1535272-2-kraxel@redhat.com>
 <6b4b8924-c0a7-58ab-f282-93d019cd0b96@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6b4b8924-c0a7-58ab-f282-93d019cd0b96@amd.com>

I have this now:

From: Gerd Hoffmann <kraxel@redhat.com>
Date: Mon, 2 Jun 2025 12:50:48 +0200
Subject: [PATCH] x86/sev: Fix EFI runtime instruction emulation

In case efi_mm is active use the userspace instruction decoder which
supports fetching instructions from active_mm.  This is needed to make
instruction emulation work for EFI runtime code, so it can use CPUID and
RDMSR.

EFI runtime code uses the CPUID instruction to gather information about
the environment it is running in, such as SEV being enabled or not, and
choose (if needed) the SEV code path for ioport access.

EFI runtime code uses the RDMSR instruction to get the location of the
CAA page (see SVSM spec, section 4.2 - "Post Boot").

The big picture behind this is that the kernel needs to be able to
properly handle #VC exceptions that come from EFI runtime services.
Since EFI runtime services have a special page table mapping for the EFI
virtual address space, the efi_mm context must be used when decoding
instructions during #VC handling.

  [ bp: Massage and extend commit message with more backstory, add
    clarifying comment from Tom. ]

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/20250602105050.1535272-2-kraxel@redhat.com
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
2.43.0


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

