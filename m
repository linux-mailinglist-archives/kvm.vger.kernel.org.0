Return-Path: <kvm+bounces-44265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 07BB3A9C158
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 10:37:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 595BF4C1F4E
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 08:37:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47E4623C8AE;
	Fri, 25 Apr 2025 08:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="cA82jInR"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303A8233D88;
	Fri, 25 Apr 2025 08:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745570140; cv=none; b=S+Rbp87w9zyTSmK+CkHc9u1B87O6UGba+ps/wgdxSstjBLYl3f6cJfW0SyPtLvYNLvtAja4nfeZtrbBWLag3RZHJKGnDxMSyPXmTcQWMKwP/UHJzRp9DGbcpDz9RjAV45foBs9jDRqRVEC3Sr98MHi90uth0om9TMERWZLF2V98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745570140; c=relaxed/simple;
	bh=gZx2n843OdPdB1BGfKpg70GhjxL1zsFHF5UrTkAlJOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ye1/IDuycKfamHO172PhiVAyHorynyWGVayL18aeJ8Q36hEaE1L5xwapeN3zfDc2+B21NmrlyIpioyI9WOqIVfq9ZxMMd70MF4lr5LimXzSMJ1+j9LfaCtK8gtkK7qiYAIXn3gZr5V9TqneGaob8LLDCEVX/OZj+i6TjOwWIACU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=cA82jInR; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53P8Yg5Q2390085
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 25 Apr 2025 01:34:51 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53P8Yg5Q2390085
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745570093;
	bh=lNRi52fPuelCbqEpttWsWEMCSZtlZ0beyL7G7ad5WoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cA82jInRsydXIwm6m1XH1TkZYoK4mqKL9NBirr8sCUCj+XPqLN/CeEGAoiOSyyuRI
	 QdzTgWC1eF7uXuSSS5zTnBU4pLicou3MhJxxwhQ0NFlMmKq20cvYz5Yav1PoyNkayn
	 KgKYJZr5z4IHK8I9dsC9QY691QE5y3054zf0B6D/9Nh0g2dd24jiFcwT00q/Uc8L8m
	 E68o2mwpxEZX8CjJCyzCeaSRisGH61g0Njb+EtcPu/0Wr2HpIpxcjMwV/AJKqwrhjK
	 CatTGQb6lGQHqqJDVz+V8dcGz7WC1dbY1YZ9LdaSMsyYJl1UHPDrRZ5b3knqA1I/lN
	 SmcyUOUKSfGjQ==
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
        haiyangz@microsoft.com, decui@microsoft.com,
        dapeng1.mi@linux.intel.com
Subject: [PATCH v3 02/14] x86/msr: Remove rdpmc()
Date: Fri, 25 Apr 2025 01:34:25 -0700
Message-ID: <20250425083442.2390017-3-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250425083442.2390017-1-xin@zytor.com>
References: <20250425083442.2390017-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rdpmc() is not used anywhere, remove it.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
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


