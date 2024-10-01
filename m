Return-Path: <kvm+bounces-27736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 580DA98B36C
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:05:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E8F6EB24078
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 05:05:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 471F31BFDF7;
	Tue,  1 Oct 2024 05:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="d10jYEWK"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FDC1BC088;
	Tue,  1 Oct 2024 05:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727758940; cv=none; b=Dq0o2sXVhOY3Aej20hx/idDhG1DVonkBPMho8nhz6iJLuzqey/ZtOWTEzWMh7Bxpd1esduQHY10viundOC7c428F5scJ3lsD+yZxM2zSW1NBTEMOoFrkRU6TVlvgnKWa/Nwi3XHdMrJ/8HGwXlSVYK+xUYCmBeU937krQyhT3pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727758940; c=relaxed/simple;
	bh=bxMqGlquB+5/gFkcnWJ3tbk2bgaubHhBM76puYSzRNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kQ9IVeC+Govc7HnKgTfsDjf+IGEv7vYySEmcLh8K3Cdc+W1jJWyoviuM2vnDfqq0+cHiAOyYrKT+PHzRBJ6EqbrovOvN53aeX8FfMYouZXdJPi2Y0MekwEK7X+ku94D3O9xSJyzAoI51R1l/6vJIYS6i5FBm6v/zzYmrRX/1V6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=d10jYEWK; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49151A7i3643828
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 30 Sep 2024 22:01:34 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49151A7i3643828
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024091601; t=1727758895;
	bh=xQodHnfpAbPVaqx+NU+32uYAoWdUOl8JXZpStYObbcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d10jYEWKiY19fP0HluEjpDGx8Ishhc2Ytn5m9W8Ekr/Pvgp7NECsF44B0+FpVLT8w
	 tHwrfs1pRjZQNhJs/X3VCbOb9YNFAb/z+u1I02Dqy88/Aq/N3Ueb4Z6evC4eXmXH6e
	 GUYOTZY+QHHt/Mrpk4i1Eyowyxu/2j+jVUQxQaspneaV1hsKKYQmsro3dgg0VWe6rr
	 aFpBnQNHZNn0ceiIGZTso+80u8lSs31BoQ3dma3C5Fks/e274i1X5naSkuYQ90mRNR
	 2H+6iWoNRzI3ibHmDVt9RSves48yxe6tqVtOlt1e/Sn7ikbBPEgJBiFxB7kZ+MjIgF
	 rdpT4KPZRIfkQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, xin@zytor.com
Subject: [PATCH v3 19/27] KVM: x86: Allow FRED/LKGS to be advertised to guests
Date: Mon, 30 Sep 2024 22:01:02 -0700
Message-ID: <20241001050110.3643764-20-xin@zytor.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241001050110.3643764-1-xin@zytor.com>
References: <20241001050110.3643764-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Allow FRED/LKGS to be advertised to guests after changes required to
enable FRED in a KVM guest are in place.

LKGS is introduced with FRED to completely eliminate the need to swapgs
explicilty, because

1) FRED transitions ensure that an operating system can always operate
   with its own GS base address.

2) LKGS behaves like the MOV to GS instruction except that it loads
   the base address into the IA32_KERNEL_GS_BASE MSR instead of the
   GS segment’s descriptor cache, which is exactly what Linux kernel
   does to load a user level GS base.  Thus there is no need to SWAPGS
   away from the kernel GS base and an execution of SWAPGS causes #UD
   if FRED transitions are enabled.

A FRED CPU must enumerate LKGS.  When LKGS is not available, FRED must
not be enabled.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 41786b834b16..c55d150ece8d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -699,7 +699,7 @@ void kvm_set_cpu_caps(void)
 
 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
 		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
-		F(FZRM) | F(FSRS) | F(FSRC) |
+		F(FZRM) | F(FSRS) | F(FSRC) | F(FRED) | F(LKGS) |
 		F(AMX_FP16) | F(AVX_IFMA) | F(LAM)
 	);
 
-- 
2.46.2


