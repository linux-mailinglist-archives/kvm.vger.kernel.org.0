Return-Path: <kvm+bounces-53290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 203D2B0F9B9
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 19:56:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B0BB567538
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:56:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ECBE23C8A8;
	Wed, 23 Jul 2025 17:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="UFsrrf8u"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49137239E61;
	Wed, 23 Jul 2025 17:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753293265; cv=none; b=GaqSSbfC9F0L32oOXrhY+MU+dDozGg7smux0RIlTyjwuo4OX0sRRxAjUuRm775YEMAAdFwe3LHClVtzdt0388bFA3XfxRpp3kuRAim2OJxEDBzleol6WQivArJ8wN1zFyB16bsw6XJ/6/T7QEN6k/5buHYlHX0mfr3zgCCA4RUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753293265; c=relaxed/simple;
	bh=hHS4T4xizHF1v5opf01KtrsUhPUdZsbEgyf10Bk/Ppk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSFjMTEcCiFHLpvfEV/ceH8t70MggJ6888dW+9Gn+lXd94+GNEncOC+ydj6d8jLlJWJngkGWFqkF9p1W2VBno5mzvXfIWgXvG6k8YqnUFOhgO9mk7n8D7khgtIHbyblYUCPKYCA1JOh6/rtdof6cr2ofpB+S2Nn15QdSLrkmHlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=UFsrrf8u; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56NHrf081284522
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 23 Jul 2025 10:54:02 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56NHrf081284522
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1753293243;
	bh=dxRY8GwK+pkOBhljZWvpX9p8RnJIOV8DEDDL8qeM9LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UFsrrf8u83GGvS2vrmpFCTlwEw+oxXNe2eVKHxBC8IhMMhMKF/RtU7Ze8V6uagsMD
	 eiNJDPMBc9cvQjLAVdpQjoowUaN85+2oOrijcNH2IIbdG7Q21Gmojk9bDj1puhuMXl
	 84jAzmHdMQ56bc/WlLvO88/vgL4JxeJRQzb9EiW0LATgDy7kSRZWhjQBVjJI5BThq+
	 DpwYnTDwYTczFumBjBjzb1kf53wIRL8goH0X7VrnZq9HiIGFC+lQ/Ah/kGsMhaaphZ
	 2jokVGKpHtyEdUbZW9jl0fFFHJipDJt6BZIMnhKXPX9ThTRX7erytyRhojz9fWq3/j
	 k5sIXEKYN9KYg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v5 18/23] KVM: x86: Advertise support for FRED
Date: Wed, 23 Jul 2025 10:53:36 -0700
Message-ID: <20250723175341.1284463-19-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250723175341.1284463-1-xin@zytor.com>
References: <20250723175341.1284463-1-xin@zytor.com>
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
index e2836a255b16..d2dd6beb4376 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -979,6 +979,7 @@ void kvm_set_cpu_caps(void)
 		F(FSRS),
 		F(FSRC),
 		F(WRMSRNS),
+		X86_64_F(FRED),
 		X86_64_F(LKGS),
 		F(AMX_FP16),
 		F(AVX_IFMA),
-- 
2.50.1


