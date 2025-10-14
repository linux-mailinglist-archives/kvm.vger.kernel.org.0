Return-Path: <kvm+bounces-59959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5085EBD6E9B
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 03:11:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 67A674E8ACE
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 01:10:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D420E24DD1F;
	Tue, 14 Oct 2025 01:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="K/iZre5+"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F31620459A;
	Tue, 14 Oct 2025 01:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760404238; cv=none; b=SsIqE7PVwBzhYQTibbHywJr6Qf1/IRZi+kHEWkxdgSZH9A5nJKQhoTO1AhyVhz8/fs+vJUan57MDzlCVhSgJoggH0tmSnb4v7Yaoe1fBaACe9uKAT+l0u53GVRn0w1ZtpG2HxKQhkRGmF2fmUkUwA9GuG2LGF57nuuTvS481LO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760404238; c=relaxed/simple;
	bh=1cmCUMS7mG4f28VNM+CU4smnr2ARWXs2ei2X92Wc0Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdZwOJSjID6hIg3qTzei8VXpZAL7UmfeeeXRj5ipSIhO1eqjkDOhXjl9/hHC6AxM5wg+Ua/L+CjrBIjqyINR86jzyBoSxQUUbuZFGHBAvpN2mDKq7G/EFsl0WP1uQxWpKcgUGFVQNwnLQP6v81rnnV7hYZlNFAi2NQHTaAu+J2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=K/iZre5+; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59E19p1d1568441
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 13 Oct 2025 18:10:10 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59E19p1d1568441
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025092201; t=1760404210;
	bh=fXxLpy7MWKqs5wtbmtbBzXIJW+LafuV0UecNrrgbowE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/iZre5++7t6qKD3aL2gPA+3D8zE1hIWc3Fv4K41BIKxV3PiaPICffeXeolxogdW4
	 x0wy6A/rK+Gupq9l42bLT40D9rlUJ8LG1xy1VmxaONUFJ+33VqNFlxSnPXkw2EKt4o
	 Zw/5fgUA9X0Px7nHRK+jwlYv3b7lOy8U9uM3F+16KbG7cBeSut9e2V5+3Aipzbo+zU
	 bXdKoAGhCwoX+DuGtHxlbn9vJVfoOFrwFec5+ampdH01wKrNiGUB0FX85dMZOxQimz
	 ZVOC7y/pMyaATzqycbBqIojVAKjvlVE00iuCwth4QBgh5Xu2Idu78JfQqLbCr+TCKU
	 rK9c78kcWEA5w==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v8 16/21] KVM: x86: Advertise support for FRED
Date: Mon, 13 Oct 2025 18:09:45 -0700
Message-ID: <20251014010950.1568389-17-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251014010950.1568389-1-xin@zytor.com>
References: <20251014010950.1568389-1-xin@zytor.com>
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
index 52524e0ca97f..f4ff5ccbcf1e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1014,6 +1014,7 @@ void kvm_set_cpu_caps(void)
 		F(FSRS),
 		F(FSRC),
 		F(WRMSRNS),
+		X86_64_F(FRED),
 		X86_64_F(LKGS),
 		F(AMX_FP16),
 		F(AVX_IFMA),
-- 
2.51.0


