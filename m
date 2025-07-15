Return-Path: <kvm+bounces-52408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33F4DB04D65
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 03:26:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 700533AA627
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 01:25:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0A351C1F0D;
	Tue, 15 Jul 2025 01:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="aklCDSxG"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9C52CCC5;
	Tue, 15 Jul 2025 01:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752542775; cv=none; b=mFDFKJOL4XE6R1G+1/7lfptD7xlKYUJjkOjPSjYZAaYNacOJpATreLKJByfm7RAmW3qicCXdto1DY+zqWJ7J1lzNLPOFCHmD85o0KgmPkfNVEgBMHDQ14+P6yGFGVueNKCnt6bcNnG5bKT6rBQ0rF+wcQHCBJpZDlaUt4/s1Z+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752542775; c=relaxed/simple;
	bh=54YgG5kcUjhb58Sk3gK5fsuHiGEcVtrw9WnbhTc9Sv0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C9hNJC+WIUcYfZlaPhfqJpovCUfNN/pn5B4+ljC776O1NnhOsbiD1P5k+hODqVZn8crjvyHnZDF+VwKMIARQ7yvmBlGtxhrixC9Y/BKwf6wOIrDSod68nDvzMe71BhuSvnKsovzaj9G0c6OdqnyO63Y5t0wNfGzlMHlU/wTVcVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=aklCDSxG; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56F1PHjP694439
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 14 Jul 2025 18:25:20 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56F1PHjP694439
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025062101; t=1752542721;
	bh=zBGfmUbqcIV/Cbwsil+J/QFtTwS/e/VTc4Ctqqsxlv4=;
	h=From:To:Cc:Subject:Date:From;
	b=aklCDSxGdWCfZ2nZGAVvctd7p6jmiA0pKXx762bg+ywsN+yW7yPe5aH2g83bd85gN
	 i7q6mrXDqk9+c+vC4uY5uzHnthQMxnUNTNZQH4n07sFto69J9UJcPXejYIRf+ume7Q
	 8lOmH6NSEd/E+v6w9td8xtDjS8YfY0K4wPqaejalrckjSzVrn0m5OdZ4d2cqbTcsPa
	 NIp7taEwNYUR0Bv+2P7oaXQJ/jr4M4v+SglUV2XDknWTHT0IzgjQ+ta9HWSVFSZ/lC
	 OVQuWaTJeKpvGb1Oa/d1+5ERA3uZOspFa/PHz+sVB5j970ieF9EyJauoLnZB6QC3Gk
	 M0BnuLBFIvaLg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com
Subject: [PATCH v1 1/1] KVM: VMX: Fix an indentation
Date: Mon, 14 Jul 2025 18:25:17 -0700
Message-ID: <20250715012517.694429-1-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix an indentation by replacing 8 spaces with a tab.

While at it, add empty lines before and after for better readability.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4953846cb30d..7b87496a249a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8623,7 +8623,9 @@ __init int vmx_hardware_setup(void)
 	 */
 	if (!static_cpu_has(X86_FEATURE_SELFSNOOP))
 		kvm_caps.supported_quirks &= ~KVM_X86_QUIRK_IGNORE_GUEST_PAT;
-       kvm_caps.inapplicable_quirks &= ~KVM_X86_QUIRK_IGNORE_GUEST_PAT;
+
+	kvm_caps.inapplicable_quirks &= ~KVM_X86_QUIRK_IGNORE_GUEST_PAT;
+
 	return r;
 }
 

base-commit: e4775f57ad51a5a7f1646ac058a3d00c8eec1e98
-- 
2.50.1


