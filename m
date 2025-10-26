Return-Path: <kvm+bounces-61110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB634C0B260
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 21:24:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 409C23B0430
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 20:22:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 934F0301026;
	Sun, 26 Oct 2025 20:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="Wc0QTjgv"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580C02FE566;
	Sun, 26 Oct 2025 20:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761510031; cv=none; b=bcj7/UR8fBBuP00zg4MXglD5QPWXRG6B+5A1VFhg1gX8cOfhSlgAd+yfd6OQSUlOQxw4H2VVV/cuSOaFmWkjjXsgQ+aTpwioUcw3FggFAHrOJO2sXT7mIaBFR2lyqvUP12/BlKpxfMCo4TAoI4qyYRKhtygN7K/I+C7dhPUKfoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761510031; c=relaxed/simple;
	bh=QFbjesLU6/4x2fV5wDJaSgO3HcI1agNqWN+ZFEnPcN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txpd7DsuuFJOXOM6nmXz0U4cvKI3mGdSy0XxYjueM0LFJJZPhyWmm0FMSMG0JQkL1igOfPHdCLYtapHMui8Bt9UtFqpeYlhu6DctIjLDJcA/nT1flHpYVPxWcKLQfyGr8VfS4Qq9YOKZzPbpgjG9BJhXMQtcNlHnMLKYvQH2D7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=Wc0QTjgv; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59QKJBkY505258
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sun, 26 Oct 2025 13:19:35 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59QKJBkY505258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1761509976;
	bh=UVXM0OsyA/ujAJTGh70nKk0R5cfalx0gkggROqCrgso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wc0QTjgvMabUVWdVdpaxCRgKzWIhCNbfuk5b96kGjXBkTIpukdNMUhpxgCs704Ceh
	 85eozNjLbHCdiY9CX6it6KnInT5CNuFjOc3vmkn9pXKVQZp4IXZ7xDCRviBcH3QWjk
	 Dp2G6MkF2GRthLpR1FAfB0fp2KTxGj2KOemSP8MUXP0DxAdTY4qDnPPuw4q//j7eG5
	 sW7SVxWmvxyAq3LELf+lpzhARfUDDcijWH/sVvYogFhzE65zpnpzgRMgcF0HlGkkkk
	 C7FNhey0K0ym1Yas797AY2/DdF8I2/PvzS3exGTDd5WXsC3CKn20CLRZaLlLhrKMWK
	 ih+hOTaKvFLpA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org, sohil.mehta@intel.com
Subject: [PATCH v9 17/22] KVM: x86: Advertise support for FRED
Date: Sun, 26 Oct 2025 13:19:05 -0700
Message-ID: <20251026201911.505204-18-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026201911.505204-1-xin@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
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
index d563a948318b..0bf97b8a3216 100644
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


