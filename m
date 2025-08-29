Return-Path: <kvm+bounces-56334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A7CA2B3BF5B
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 17:34:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B7451CC0FDD
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 15:34:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20695334366;
	Fri, 29 Aug 2025 15:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="Cy3Q4YwC"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9302E2EF3;
	Fri, 29 Aug 2025 15:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756481590; cv=none; b=j579cpf+BKlojkB7HMffUH5vHCH4mpZtHA2LKWc+VxSEA1xVduAcNy8fCgURW8uKEx9+b1mcLLoqYXZjGLsoygS5vH94zWA5ljMAyNN4jLOY82KQCOHq3t/lvTLli/JFL04S7JMFex+hcO218MHuleea2zDeYzL0sJ1B0Sp8sdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756481590; c=relaxed/simple;
	bh=dGIU0Te0b2UjpQBN0ljD4w2cmQFMKr3KMP0Hw1YgLEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IALrX15h+4foYLZ8lPGj6KHWv+YIxSE118dDIsd20ChPUMq3r8pouWV3N8NOeTCjaIgnxIjaP5Syno184P6D1zqudwIWptcby5dOoqO2X2ywgn0825kjFXif20sVy+Qq9TN7Y9bg5j8pSCAKxoKBnf7Vo0gWEVRNtWME2Pa2+68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=Cy3Q4YwC; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57TFVo4M2871953
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 29 Aug 2025 08:32:26 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57TFVo4M2871953
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1756481547;
	bh=x5APr7DYSSBSefCejuZvINp7dxvm6yF/POGDlz0O8VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cy3Q4YwCmYdnx/jj15y7roWwaZCLUO5kdVgjTh557G3JM3LR2Gqw15uLG4L8ccjdh
	 zSVpWR6QvkJXwk3tXe+EZ3PVrhe9Hns3o3DQ0ouEKCfUg+VzDBl2tIEeDuaiAR2V8P
	 CGH6cZM9CF91R0Yz2KuM6wKvj1zJCVV1agtCLxe+V/bQMbn5228dmXLgCHORrvjOCO
	 kxf7RMeEZ6jVavq6EOUUEN78qrQl1192AU13nbwTO08iEbFqaO6vs1jIrvBYhZbNIV
	 SpVBVSO90nEPR2qL6kDBTXEtSeEEq+P2Z/6CYfg+m6F04BgrREJfXgiWjPC/RfxKEI
	 pVqmMzLoDsRbg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v7 16/21] KVM: x86: Advertise support for FRED
Date: Fri, 29 Aug 2025 08:31:44 -0700
Message-ID: <20250829153149.2871901-17-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829153149.2871901-1-xin@zytor.com>
References: <20250829153149.2871901-1-xin@zytor.com>
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
2.51.0


