Return-Path: <kvm+bounces-55418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01CEFB30954
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 00:40:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 777E7A076CF
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:38:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C26B12EBDDC;
	Thu, 21 Aug 2025 22:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="l2gFnXGM"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670202EA726;
	Thu, 21 Aug 2025 22:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755815880; cv=none; b=B5P/Oqi5ya4OOr3a0eWcE7xTafDwnzSlC7+psaEkBSiicXWIOtIdQtpZS27N7U5Ev5aRRqk2SV/awHsStmP6ZqbQxvgiskNDg86lRDHZGonxo/P3Dsh/hBUvmzWUyKctgdyD7m592WoFAUSPhJHr+7UW61Iph2JAfnMUqoNRZJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755815880; c=relaxed/simple;
	bh=nxpDhmu9qUUfV1PcLgpfjaLreHEz74ZMGryk3SSvHA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cu/SWyhiH6/K7sLVd9/I2OmIaPqZkQanQy4wDMScTdEjHxwibP7+KpG2I1ceKv3doEU0dX7ZwBz3JekRuF7Upox30xVFZPxQXLGBv/oZnMvL69Er7yIwVYSRL2N4z6ouodHvRPGQXQZFr1o1u13ZmARFNQHabRt1NvhKKvxf26w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=l2gFnXGM; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57LMaUOd984441
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Thu, 21 Aug 2025 15:36:55 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57LMaUOd984441
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1755815816;
	bh=pjX/Yz0gDh3nBFAZZIwdvYGG+//NuZlC20NdWYQfMUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l2gFnXGMXmNZyDUQyBFFc/hquIN/SHRKnHS9NtjSOPUeGxFEPm+fgrJ4uocj2NqRq
	 /1ThZcgy0G4cj7993VNVyB5rgB/2O8iQcDpmjSAy5LubwgO9AfyQNghLQrin/Xepjg
	 3ERFur+6WyMa3x4iDoPCY+/ZVJP9fEqkUfzgt/SS3kLPxrgX6vwpTCyzGNOi5H3OeJ
	 SdTcoPk6heE5f7u31Asj0V9hs/Ejgld9Koh4snHEurNUQsM4xPDTlcR3575itYkhqE
	 tJ2qZKqiPG4aKRPK1+tzU+jPC2OPjTWvwHr4hjYzE/i2GMAGJilTzzjLsCrsKQ8jZP
	 3pSVV4NzdpdKQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v6 15/20] KVM: x86: Advertise support for FRED
Date: Thu, 21 Aug 2025 15:36:24 -0700
Message-ID: <20250821223630.984383-16-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821223630.984383-1-xin@zytor.com>
References: <20250821223630.984383-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Advertise support for FRED to userspace after changes required to enable
FRED in a KVM guest are in place.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---

Change in v5:
* Don't advertise FRED/LKGS together, LKGS can be advertised as an
  independent feature (Sean).
* Add TB from Xuelian Guo.
---
 arch/x86/kvm/cpuid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index ee05b876c656..1f15aad02c68 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -994,6 +994,7 @@ void kvm_set_cpu_caps(void)
 		F(FSRS),
 		F(FSRC),
 		F(WRMSRNS),
+		X86_64_F(FRED),
 		X86_64_F(LKGS),
 		F(AMX_FP16),
 		F(AVX_IFMA),
-- 
2.50.1


