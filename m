Return-Path: <kvm+bounces-43774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 954A9A9616B
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:27:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D82E83B2F73
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:27:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C4672641C3;
	Tue, 22 Apr 2025 08:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="b1z8Rlaq"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE3825DB05;
	Tue, 22 Apr 2025 08:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310235; cv=none; b=C9d7sIorKH1VIUj4jqfwjjxjXutbMCKl2cjdKYGW80wWShsyJ7c3GPWgUPt5AbpI9mhfMhUXgcjiQkd6E1qIq1psUQjs6H9+WP1pVfKlER+d+mE+V1pRSS5uv5p1M3OzifmXchuMvlZf+Z2D2DAvlZf85QGJpk8djCLkmDc4eb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310235; c=relaxed/simple;
	bh=k2E9rMwmXhEphBMdkBpaEAaRHW01tdOe4OgulWTNCpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giftLomzEuJQXz0wmjdiiPlgcC+8U6rbI3XivixTMGIK7Wton6yP6sl8/WaCf2kFUW0I2IJbRgdHPJbF47dsarWaKaNN1FxkVY/YBnw7LRv+M2WVh3btvPriV5CMhuzfShPUpJuASpnxAG2kCyNCn1t1YySQGZTCy/oXtX6rqY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=b1z8Rlaq; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53M8MG9G1954391
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 22 Apr 2025 01:22:24 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53M8MG9G1954391
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745310146;
	bh=IoPTRGWe2Y3cj4mu9rrTWSQjJVT8gGehrwqKDjIdcAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b1z8RlaqquIXeYBqIgAy+u/r/q47lKeO8pCBYXjerdwtNfjtGgxePxuKRH1G8q7Eg
	 3yr5aijpEOpIzQRR4VI95BAlBgsgxvAjMKpeoxc8AmYPQDI2WH7ESLigIPAoWSaJha
	 lTiBdiyZXvX61dgoYdVd4h8eAdxh5SIPVz3MC8rQW9bkPs5PakJ7J11JQ1LIEovXF5
	 OE/aPM5jxUO7eRx2T5+gGxwuzqRYYxNf0xIOCyXWR6eEAXQ6FBb9vzoj5U+Lt3CyAd
	 D4Pxs/8oSukBmPJ9BE/q/qb5j/rNcjBlzuv/7Iw8PZHjSubwTAJSuLzuPx2ys04J8n
	 xkcnr5QGmv2YA==
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
Subject: [RFC PATCH v2 02/34] x86/msr: Remove rdpmc()
Date: Tue, 22 Apr 2025 01:21:43 -0700
Message-ID: <20250422082216.1954310-3-xin@zytor.com>
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

rdpmc() is not used anywhere, remove it.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/include/asm/msr.h      | 7 -------
 arch/x86/include/asm/paravirt.h | 7 -------
 2 files changed, 14 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 2caa13830e11..e05466e486fc 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -234,13 +234,6 @@ static inline int rdmsrq_safe(u32 msr, u64 *p)
 	return err;
 }
 
-#define rdpmc(counter, low, high)			\
-do {							\
-	u64 _l = native_read_pmc((counter));		\
-	(low)  = (u32)_l;				\
-	(high) = (u32)(_l >> 32);			\
-} while (0)
-
 #define rdpmcl(counter, val) ((val) = native_read_pmc(counter))
 
 #endif	/* !CONFIG_PARAVIRT_XXL */
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 86a77528792d..c4dedb984735 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -244,13 +244,6 @@ static inline u64 paravirt_read_pmc(int counter)
 	return PVOP_CALL1(u64, cpu.read_pmc, counter);
 }
 
-#define rdpmc(counter, low, high)		\
-do {						\
-	u64 _l = paravirt_read_pmc(counter);	\
-	low = (u32)_l;				\
-	high = _l >> 32;			\
-} while (0)
-
 #define rdpmcl(counter, val) ((val) = paravirt_read_pmc(counter))
 
 static inline void paravirt_alloc_ldt(struct desc_struct *ldt, unsigned entries)
-- 
2.49.0


