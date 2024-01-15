Return-Path: <kvm+bounces-6206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D131C82D577
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 10:02:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6FF6B1F21B2C
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 09:02:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCF60C2CE;
	Mon, 15 Jan 2024 09:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="SAOPBhxw"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E584428;
	Mon, 15 Jan 2024 09:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id AD92740E01B0;
	Mon, 15 Jan 2024 09:02:12 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id SUKdvpsWbZhK; Mon, 15 Jan 2024 09:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1705309330; bh=StldW18DJW9RHvhpFLIMw8/y8Xdlf7u+BI435bxm9gE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SAOPBhxwbXpACDVHP9Vgo+tBOgk6enmMbPub2YjCJOSM2Toof/rV7Tf6Q7KI0mS1g
	 ZEBocmEh81odQ2fQbDeCt9YY3bAHX7XPTnpw7Un7NF9qjc3oa1yXKaibzSuoQDj/x3
	 evyCIOERFXEiSoe5cyAhmDl1c1pRyM8HLcaLyzQMdOF72dHMjbbRjLv0doHYVPOaCh
	 hlygnPuXr/lh3jKPd04u9kqpmeR2RvvB11xD0OZbMX98qSlIrtzWdjd/EJwIPPXF/e
	 3B4uJK5neFbWsFBfVhuCn823FkTrBaGCd/C4SUl+MIBS8hD67NvSqMRUxA5BhQzE5Z
	 olACYu2A9zCwGqxAR/dxdJtbefC0pED2yvzcvoMizdVumW2bIrH2gaqeVecKt5LeEE
	 kvQxK5TJeeXq+Xc+DaFxh0DsavN4p3n6NNrZ2GYRoMMaOelAuNsYdoTKSLlPViMhxn
	 so7gePgLsENHGpjy+x/C1Wi41H+Rl5T+SVHS7jKFXTVmIhciNEDlSkcfMY61sFbJI/
	 o7VSoCVXWZv8qrKkhvxKf8e3Yh2FnNPraaEj7B872YIPUs96dShqtLXjHEgZWG9QqR
	 6jgVxJglFNO/ETzSN4Oz4a+qpYt6yB52z6q81wpRVsI+ElPGIVMbmNf/lhjYS9V2T+
	 oygAXEbBHHh/kshvJixLCzlI=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 008B940E01A9;
	Mon, 15 Jan 2024 09:01:31 +0000 (UTC)
Date: Mon, 15 Jan 2024 10:01:26 +0100
From: Borislav Petkov <bp@alien8.de>
To: Michael Roth <michael.roth@amd.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
	linux-mm@kvack.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
	rientjes@google.com, tobin@ibm.com, vbabka@suse.cz,
	kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v1 11/26] x86/sev: Invalidate pages from the direct map
 when adding them to the RMP table
Message-ID: <20240115090126.GEZaT0ZnSPIPsnUiyt@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-12-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231230161954.569267-12-michael.roth@amd.com>

On Sat, Dec 30, 2023 at 10:19:39AM -0600, Michael Roth wrote:
> +	/*
> +	 * If the kernel uses a 2MB directmap mapping to write to an address,
> +	 * and that 2MB range happens to contain a 4KB page that set to private
> +	 * in the RMP table, an RMP #PF will trigger and cause a host crash.

Also:

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 7d294d1a620b..2ad83e7fb2da 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -415,8 +415,9 @@ static int rmpupdate(u64 pfn, struct rmp_state *state)
 
 	/*
 	 * If the kernel uses a 2MB directmap mapping to write to an address,
-	 * and that 2MB range happens to contain a 4KB page that set to private
-	 * in the RMP table, an RMP #PF will trigger and cause a host crash.
+	 * and that 2MB range happens to contain a 4KB page that has been set
+	 * to private in the RMP table, an RMP #PF will trigger and cause a
+	 * host crash.
 	 *
 	 * Prevent this by removing pages from the directmap prior to setting
 	 * them as private in the RMP table.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

