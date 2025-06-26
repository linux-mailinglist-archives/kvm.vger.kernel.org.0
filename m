Return-Path: <kvm+bounces-50864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 66832AEA47F
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 19:36:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C96EC3A5DE6
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 17:36:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F90D2EE27F;
	Thu, 26 Jun 2025 17:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="Zoq/U/1M"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7212ED87B;
	Thu, 26 Jun 2025 17:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750959352; cv=none; b=jQjfhKz83GA1k8M0UTCqa/RaDyp2saXtiToauNiRijylVPszxH2Lx75gqD2yhtfmW4ksAoK8/nkKyWbzIALsLqtd8VjixzTazTvfkv6+hgbI/W5e2e9AmIoR7OSDs6ofeIlRmY+isp2V8iXOdj8AXaOXvH8zihWKwWKY7lmSUYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750959352; c=relaxed/simple;
	bh=QxmySzMm5F2mb1oFDc4DJIVjCFxXz8NUCIDz5HoBNgI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Mh+V+cZmjryTSsoivOgWPFztoWlKPFOe74nJf2gtH330bSS4nzHIbWd4nSIz3ks0gxHJX330kX1enoszGlBj0pb/4gnYzYVjl/fyq36/OqujKDMCXKc2Vn5bOlESjHJmxMYZ56VDQPdBKCLqPjtN0h1xqZ7xFblYBTP1YfV9B9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=Zoq/U/1M; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55QHZLtt2301098
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Thu, 26 Jun 2025 10:35:25 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55QHZLtt2301098
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025062101; t=1750959325;
	bh=ZogcO5ZU0ov9a1EziNd9docxZFFmVUMa3/b1ewzs0hM=;
	h=From:To:Cc:Subject:Date:From;
	b=Zoq/U/1Monvyj8sIkeTt7c1wJaY3RC2bBj/quFDLSl2WFq7D6b//0vh5aMyaKG9c9
	 gwSjutNCo/o51o+d7CINqE/vfO3JCuVJIvwZTAbuHq5B5N9iOvNlzcewJ1juSmLWET
	 Du7Fxl47SZBTSgEM2867kjHtb3yI49dZTtUWWIB7T+13crvRyTYGIATfpmdVAere59
	 whpT7KtU/bEsV1toABbK/+jrMeeKvdX1wHCFiskQ1WS9Z4rppHiE9kWLS8WQKJK/Kz
	 QOCzE1mnIzc85DbUhrKyLMNkt82Q0fg8u5OGjPgCTO1O6No/t2i/0x6sTzh3fTOogj
	 ZVMxMGwln2sUQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, chao.gao@intel.com
Subject: [PATCH v1 1/1] KVM: x86: Advertise support for LKGS
Date: Thu, 26 Jun 2025 10:35:21 -0700
Message-ID: <20250626173521.2301088-1-xin@zytor.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Advertise support for LKGS (load into IA32_KERNEL_GS_BASE) to userspace
if the instruction is supported by the underlying CPU.

LKGS is introduced with FRED to completely eliminate the need to swapgs
explicilty.  It behaves like the MOV to GS instruction except that it
loads the base address into the IA32_KERNEL_GS_BASE MSR instead of the
GS segment’s descriptor cache, which is exactly what Linux kernel does
to load a user level GS base.  Thus there is no need to SWAPGS away
from the kernel GS base.

LKGS is an independent CPU feature that works correctly in a KVM guest
without requiring explicit enablement.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/kvm/cpuid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b2d006756e02..bf4a43bd0a47 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -979,6 +979,7 @@ void kvm_set_cpu_caps(void)
 		F(FSRS),
 		F(FSRC),
 		F(WRMSRNS),
+		X86_64_F(LKGS),
 		F(AMX_FP16),
 		F(AVX_IFMA),
 		F(LAM),

base-commit: 05186d7a8e5b8a31be93728089c9c3fee4dab0a2
-- 
2.50.0


