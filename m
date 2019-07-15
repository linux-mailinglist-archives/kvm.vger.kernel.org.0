Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE0369D36
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 23:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732142AbfGOVDY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 17:03:24 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:55063 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729640AbfGOVDY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 17:03:24 -0400
Received: by mail-pl1-f201.google.com with SMTP id u10so8892305plq.21
        for <kvm@vger.kernel.org>; Mon, 15 Jul 2019 14:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=cvoyIGPSrQUWqIEuuKMOXo653228JdXa/qBKKd4Pjr8=;
        b=GUIhXqeymAG5h/REV19Zc9Hc7RIL/G4OnuRMlvxC5xMzVPWBuyj9r3dAyRtJCyX/lJ
         9wK9n0SHaz2pRhzOGOZUlqAU7sLP0c7GBRdAsINSuUClmglwSWG8wVlamLcaMmEg0Ayr
         k/NOHzJXjAEQNkJ5cx3FQ0vmkXBl7ikk1xjqJ1ftxG4FLZZu648rHgiDGnRA7SF9DPbD
         mQzb3tHGanoNa7hHtGrId1vmponUfGJzndlhiCLg7Gw5mPb9uQj0R4i1C0k8o/gCwNGb
         kwcXmivW/SSvSsMJ2Wcd+G1jTlNtXZvQEkLzWDCzxB60nnUYzquCPg7n9267QxpAQaiS
         48+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=cvoyIGPSrQUWqIEuuKMOXo653228JdXa/qBKKd4Pjr8=;
        b=aRQ0AAbbQcErpIaeFGPlWmzTd2fTtO7DxnaMuedzzt8GVfq7r/VwQB0PYQWqlDIhH/
         pPOXQrZpI9hmI8RefJLfpbhMvQWUOu3isa/A7qJxvW0jD5mK4yJE8oeYefa/JrxKhaFD
         o6wm0hw0S9QxmGmyXDglkDBfh1/PvaCHQ0Cis6+46QcZ/7ubm6rvcuV7a0Wmd+MyT0lP
         kYyqGGsqEPsJD6zYY82A85pOZV+OsKZU+9ljyTI5kcsU+FQGZRrBQidBFya+LpsTi4CT
         dKf21GBpSGLowP77KN+ABB/jbUWW9xSG28UgCygv0v29lqW0xzSTTVmfo61eEuzRm3Am
         erZQ==
X-Gm-Message-State: APjAAAVKL+XuENTCg1OLRDGkPx0YSWms8kpnkSUwMOMyyLoq6MXE89dc
        zVXLuy1sbeAlWSX9Es0HUtgoa8JFPAfH2GOK
X-Google-Smtp-Source: APXvYqxUrIfVVd3v5TAZE55tK3ASVcHm4E5y5C3DH1WxvDn7Ld+4XjxnKQqtEa70BHLbwFpa9QMzc5rohUboAW8g
X-Received: by 2002:a63:6c7:: with SMTP id 190mr28615601pgg.7.1563224603352;
 Mon, 15 Jul 2019 14:03:23 -0700 (PDT)
Date:   Mon, 15 Jul 2019 14:03:16 -0700
Message-Id: <20190715210316.25569-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
Subject: [PATCH] KVM: CPUID: Add new features to the guest's CPUID
From:   Aaron Lewis <aaronlewis@google.com>
To:     jmattson@google.com, kvm@vger.kernel.org
Cc:     Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add features X86_FEATURE_FDP_EXCPTN_ONLY and X86_FEATURE_ZERO_FCS_FDS to the
mask for CPUID.(EAX=07H,ECX=0H):EBX.  Doing this will ensure the guest's CPUID
for these bits match the host, rather than the guest being blindly set to 0.

This is important as these are actually defeature bits, which means that
a 0 indicates the presence of a feature and a 1 indicates the absence of
a feature.  since these features cannot be emulated, kvm should not
claim the existence of a feature that isn't present on the host.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/cpuid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index ead681210306..64c3fad068e1 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -353,7 +353,8 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
 		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | f_mpx | F(RDSEED) |
 		F(ADX) | F(SMAP) | F(AVX512IFMA) | F(AVX512F) | F(AVX512PF) |
 		F(AVX512ER) | F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB) | F(AVX512DQ) |
-		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | f_intel_pt;
+		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | f_intel_pt |
+		F(FDP_EXCPTN_ONLY) | F(ZERO_FCS_FDS);
 
 	/* cpuid 7.0.ecx*/
 	const u32 kvm_cpuid_7_0_ecx_x86_features =
-- 
2.22.0.510.g264f2c817a-goog

