Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213F525704D
	for <lists+kvm@lfdr.de>; Sun, 30 Aug 2020 21:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgH3Tvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Aug 2020 15:51:50 -0400
Received: from mail.skyhub.de ([5.9.137.197]:58460 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgH3Tvt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Aug 2020 15:51:49 -0400
Received: from zn.tnic (p200300ec2f2960001ce4724d13ad870d.dip0.t-ipconnect.de [IPv6:2003:ec:2f29:6000:1ce4:724d:13ad:870d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C728A1EC02F2
        for <kvm@vger.kernel.org>; Sun, 30 Aug 2020 21:51:47 +0200 (CEST)
Received: from deliver ([unix socket])
         by localhost (Cyrus v2.4.17-caldav-beta9-Debian-2.4.17+caldav~beta9-3) with LMTPA;
         Tue, 25 Aug 2020 02:54:03 +0200
X-Sieve: CMU Sieve 2.4
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPS id 7C4371EC0104
        for <bp@alien8.de>; Tue, 25 Aug 2020 02:54:02 +0200 (CEST)
IronPort-SDR: Qm41XyvUdsCSrQhNRf+47AbQL7sw3zCPIs8LOeNO3ui2mKLyVEdAN+WHtIyJUeTyEVlys75bzX
 r9wujGgZTM/A==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="240834166"
X-IronPort-AV: E=Sophos;i="5.76,350,1592895600"; 
   d="scan'208";a="240834166"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2020 17:54:01 -0700
IronPort-SDR: LLvBxzWhq25bkfXbFZVAzsoS6K+kmlkkiBeJ32HBDUnIVB596K7Tkalkp+Brgga3IuQliKmDeW
 WVSd/+KMtAuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,350,1592895600"; 
   d="scan'208";a="281351941"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.238.156.127])
  by fmsmga008.fm.intel.com with ESMTP; 24 Aug 2020 17:53:57 -0700
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        tony.luck@intel.com, dave.hansen@intel.com,
        kyung.min.park@intel.com, ricardo.neri-calderon@linux.intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        jpoimboe@redhat.com, ak@linux.intel.com, ravi.v.shankar@intel.com,
        Cathy Zhang <cathy.zhang@intel.com>
Subject: [PATCH v4 2/2] x86/kvm: Expose TSX Suspend Load Tracking feature
Date:   Tue, 25 Aug 2020 08:47:58 +0800
Message-Id: <1598316478-23337-3-git-send-email-cathy.zhang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1598316478-23337-1-git-send-email-cathy.zhang@intel.com>
References: <1598316478-23337-1-git-send-email-cathy.zhang@intel.com>
Authentication-Results: mail.skyhub.de;
        dmarc=pass (policy=none) header.from=intel.com;
        spf=pass (mail.skyhub.de: domain of cathy.zhang@intel.com designates 192.55.52.43 as permitted sender) smtp.mailfrom=cathy.zhang@intel.com
X-Spamd-Bar: ----------
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TSX suspend load tracking instruction is supported by
Intel processor, Sapphire Rapids. It aims to give a
way to choose which memory accesses do not need to be
tracked in the TSX read set. It's availability is indicated
as CPUID.(EAX=7,ECX=0):EDX[bit 16].

Expose TSX Suspend Load Address Tracking feature in KVM
CPUID, so KVM could pass this information to guests and
they can make use of this feature accordingly.

Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
Changes since v3:
 * Remove SERIALIZE part and refactor commit message..

Changes since v2:
 * Merge two patches into a single one. (Luck, Tony)
 * Add overview introduction for features. (Sean Christopherson)
 * Refactor commit message to explain why expose feature bits. (Luck, Tony)
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 3fd6eec..7456f9a 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -371,7 +371,7 @@ void kvm_set_cpu_caps(void)
 		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
 		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
-		F(SERIALIZE)
+		F(SERIALIZE) | F(TSXLDTRK)
 	);
 
 	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
-- 
1.8.3.1

