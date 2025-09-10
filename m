Return-Path: <kvm+bounces-57217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E85E1B51F75
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 19:50:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 26314188744B
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 17:50:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 473F53314BC;
	Wed, 10 Sep 2025 17:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="RnoOeNkX"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5936126F2B9;
	Wed, 10 Sep 2025 17:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757526587; cv=none; b=Q/Gty11fR3EpCqOd8PWDtlGY+6xAc+hS4VWoMmWCo9zfg5SAKYvT+N1xCRw80h5CqAD2rQe6zejUjQvGk0ReqKvTIrqVck26O1ow+lWxkZhT89RPMNsbXs9KmcdHBFSkgRj96FdszPbPpZlHJTFdEey+QeJG88pCPI6DPV9xyPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757526587; c=relaxed/simple;
	bh=dLfMem/gJ74K/UWSfWhVdu+W/hVXi4gguN2sLWl6kYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eQRIeskRu2rubfAO9N4MMgME49zADzgyK1hJvZiPLtBEWzmSBNdqxvgRGYNsGXqG6SD0QlrpZQjHZMOyMOEkTNrs8NbrXmmbKiK2sy+7jw4mupFzzyVBz+dxK7/GhFuaxYYI22rRTmAY+ywJeYCDBFD9ibQADkG6KbtpwF4ncfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=RnoOeNkX; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1FCDA40E01D2;
	Wed, 10 Sep 2025 17:49:42 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id zuxbaOo94TEC; Wed, 10 Sep 2025 17:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1757526577; bh=9nwBR9qcXVZ8qnaNuVGUBkIowxHV6fUU3npIWRXZiaI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RnoOeNkXuOCJgDLguBTAYCn1uQJqA48vH8U0d4/AvSL87fQoU/3zMbnmafSBbfqRp
	 yKKheegvIVPZq0qnb4TdDvMF0XWC383hAIV0FxGpjvCObnZINv/qmlBANOzYjtuyKk
	 k+HKCDx8Sq2vVJlN1+kSQWx5FKlh+ML/szumzTl6eAtn9A/dchMdmStSinLtBlyjRg
	 zCU075dVUI4n1GzzFHv/MJghZb2+3/1CwMczKrYpoFU29LyJs/ClRryBaLOcGmWy79
	 srAdqnmspsoxGA6OxSdrWw84YjryBLFP/yPmpMJqvnrfQdO4Y7SgYaBN6JI11ND/x3
	 HNPKpQkIpUSZO+pg9rd6EorvttCBN52ZnS4tQNclbM2R36epVEF9GHH5UKFracjB81
	 DO8V6wr/k3ZIMTxVKyptWwH5sDN7poyjlGM6KA82QgyaQfKM9yMJv456WJ8N/6dCOW
	 57znv0uXUvBP6bqdRN+XeHyd8kuXiV737OtCghoGswx0q62x2KQ/G0/RfnBq5GmhMq
	 Syi1cWMtkHHCLvv3nyIfZJiOYzXr5b6XT03bUCGZN7MkwmM1GRokkj1XFszbdTjYoD
	 PomoVBchmfEpjXevnAcVBFGm3IwvqaXBhd7F2LXr6mRmzNjMYHeqU42Ndub95FAMur
	 XxVw0kyohHqMPsVYWfwt+mKg=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 74AE240E00DD;
	Wed, 10 Sep 2025 17:49:17 +0000 (UTC)
Date: Wed, 10 Sep 2025 19:49:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, x86@kernel.org,
	Naveen rao <naveen.rao@amd.com>, Sairaj Kodilkar <sarunkod@amd.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Xin Li (Intel)" <xin@zytor.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH v5 3/4] x86/msr-index: Define AMD64_CPUID_FN_EXT MSR
Message-ID: <20250910174911.GDaMG6FwK_mBD32hqe@fat_crate.local>
References: <20250901170418.4314-1-kprateek.nayak@amd.com>
 <20250901170418.4314-4-kprateek.nayak@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250901170418.4314-4-kprateek.nayak@amd.com>

On Mon, Sep 01, 2025 at 05:04:17PM +0000, K Prateek Nayak wrote:
> Explicitly define the AMD64_CPUID_FN_EXT MSR used to toggle the extended
> features. Also define and use the bits necessary for an old TOPOEXT
> fixup on AMD Family 0x15 processors.
> 
> No functional changes intended.
> 
> Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
> ---
> Changelog v4..v5:
> 
> o No changes.
> ---
>  arch/x86/include/asm/msr-index.h   | 5 +++++
>  arch/x86/kernel/cpu/topology_amd.c | 7 ++++---
>  2 files changed, 9 insertions(+), 3 deletions(-)

Did some massaging:

Author: K Prateek Nayak <kprateek.nayak@amd.com>
Date:   Mon Sep 1 17:04:17 2025 +0000

    x86/cpu/topology: Define AMD64_CPUID_EXT_FEAT MSR
    
    Add defines for the 0xc001_1005 MSR (Core::X86::Msr::CPUID_ExtFeatures) used
    to toggle the extended CPUID features, instead of using naked numbers. Also
    define and use the bits necessary for an old TOPOEXT fixup on AMD Family 0x15
    processors.
    
    No functional changes intended.
    
      [ bp: Massage, rename MSR to adhere to the documentation name. ]
    
    Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
    Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
    Link: https://lore.kernel.org/20250901170418.4314-1-kprateek.nayak@amd.com

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index a0c1dbf5692b..22ac1a62549b 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -633,6 +633,11 @@
 #define MSR_AMD_PPIN			0xc00102f1
 #define MSR_AMD64_CPUID_FN_7		0xc0011002
 #define MSR_AMD64_CPUID_FN_1		0xc0011004
+
+#define MSR_AMD64_CPUID_EXT_FEAT	0xc0011005
+#define MSR_AMD64_CPUID_EXT_FEAT_TOPOEXT_BIT	54
+#define MSR_AMD64_CPUID_EXT_FEAT_TOPOEXT	BIT_ULL(MSR_AMD64_CPUID_EXT_FEAT_TOPOEXT_BIT)
+
 #define MSR_AMD64_LS_CFG		0xc0011020
 #define MSR_AMD64_DC_CFG		0xc0011022
 #define MSR_AMD64_TW_CFG		0xc0011023
diff --git a/arch/x86/kernel/cpu/topology_amd.c b/arch/x86/kernel/cpu/topology_amd.c
index 7ebd4a15c561..6ac097e13106 100644
--- a/arch/x86/kernel/cpu/topology_amd.c
+++ b/arch/x86/kernel/cpu/topology_amd.c
@@ -163,11 +163,12 @@ static void topoext_fixup(struct topo_scan *tscan)
 	    c->x86 != 0x15 || c->x86_model < 0x10 || c->x86_model > 0x6f)
 		return;
 
-	if (msr_set_bit(0xc0011005, 54) <= 0)
+	if (msr_set_bit(MSR_AMD64_CPUID_EXT_FEAT,
+			MSR_AMD64_CPUID_EXT_FEAT_TOPOEXT_BIT) <= 0)
 		return;
 
-	rdmsrq(0xc0011005, msrval);
-	if (msrval & BIT_64(54)) {
+	rdmsrq(MSR_AMD64_CPUID_EXT_FEAT, msrval);
+	if (msrval & MSR_AMD64_CPUID_EXT_FEAT_TOPOEXT) {
 		set_cpu_cap(c, X86_FEATURE_TOPOEXT);
 		pr_info_once(FW_INFO "CPU: Re-enabling disabled Topology Extensions Support.\n");
 	}

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

