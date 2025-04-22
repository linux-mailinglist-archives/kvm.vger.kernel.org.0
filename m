Return-Path: <kvm+bounces-43781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5EC1A961CC
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:33:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB3CE17A679
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:30:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19EB126B2A3;
	Tue, 22 Apr 2025 08:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="JnM1tOMn"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E36266581;
	Tue, 22 Apr 2025 08:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310240; cv=none; b=Oius4/7wtBh4SlwqUSLmkTnkERay87x4tQPxshgFNW0On33MqrEkuzsdvk3sI0ZlJ2KO+ps9xqhiuXgqKExZQIACaCfWsWpd2yh7E3pSlCscN7cHE1wwL4udgmMbtk6NFY6SDDTq27zDb9zCYojFMhqgOPG98t7t8pq09Y/nSqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310240; c=relaxed/simple;
	bh=mXHs9XWSjNOs2MwMruMnotiL7mSYRgEHo8iZA6y9x1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ciG6NOQglkXH5+5j5am25d9HLz8pGuN8QkLSBV47so4lKWZePt5dWe3cPBj9/eDQiul8hKLSvqXP5iqDhjkJ1gn9w9e7jhL+BBuGEv2768gmTCwB7WUkHOPzieYhEVmsdUbHMI0HP5Jx3jGjS9pnfhCFseMHNNkfBhAvAItN3oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=JnM1tOMn; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53M8MG9M1954391
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 22 Apr 2025 01:22:36 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53M8MG9M1954391
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745310158;
	bh=ZDjz7zZ6jpSk7UYBX1f+/D6FpEpADYtgSJeGI0K8PfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JnM1tOMn1uOqwogaGDb5MA0EnSbBUePNLnpaO/hoa8wawH5peRy9eV+Mxx6gdUAsP
	 4J+kDIbBA+tj1HaAosm+HAGN3bs6BDN2tw/gvDOb3rz0QBzJKtmPhVFCU1gjPZARLN
	 cVFTJm2CNABewq6f0h4AUzPrxnKJY7GgDt4k+LmQnyeNf/IJcVPLHUmkr4KgzM4ddw
	 cpG5h9ajIgNj3NZXg8iZqKaJefvUYCb83TLTbKiVCSqsmym2tgrGB9O/MnG0tdrpqX
	 e49cOPxt2MjmuEMWTIfxUCvSYUho6LiyNa9c/tKoPjWL4drYZI2WdYQ+dXK3vNAiOJ
	 HJ3Be9VSRalww==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
        peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com
Subject: [RFC PATCH v2 08/34] x86/msr: Convert a native_wrmsr() use to native_wrmsrq()
Date: Tue, 22 Apr 2025 01:21:49 -0700
Message-ID: <20250422082216.1954310-9-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250422082216.1954310-1-xin@zytor.com>
References: <20250422082216.1954310-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert a native_wrmsr() use to native_wrmsrq() to zap meaningless type
conversions when a u64 MSR value is splitted into two u32.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/include/asm/sev-internal.h | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/sev-internal.h b/arch/x86/include/asm/sev-internal.h
index 73cb774c3639..9da509e52e11 100644
--- a/arch/x86/include/asm/sev-internal.h
+++ b/arch/x86/include/asm/sev-internal.h
@@ -101,12 +101,7 @@ static inline u64 sev_es_rd_ghcb_msr(void)
 
 static __always_inline void sev_es_wr_ghcb_msr(u64 val)
 {
-	u32 low, high;
-
-	low  = (u32)(val);
-	high = (u32)(val >> 32);
-
-	native_wrmsr(MSR_AMD64_SEV_ES_GHCB, low, high);
+	native_wrmsrq(MSR_AMD64_SEV_ES_GHCB, val);
 }
 
 enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
-- 
2.49.0


