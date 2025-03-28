Return-Path: <kvm+bounces-42204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72542A74F17
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 18:17:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D345816F2A8
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 17:16:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53B341F4179;
	Fri, 28 Mar 2025 17:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="Uhxe4C+V"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4F81E51F4;
	Fri, 28 Mar 2025 17:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743181999; cv=none; b=pILnULL6T+CH8YPDvmRDpZ258OOvvuti88ThYJ7GtHv3+kKsSICk8OpiFBP5PKchOLr87Ss6xN35MH0hdUolGK54o0TIdXBdaJlVS0ugrplqq306VpgLa2Gmbt+HosFLU9tlhiFzwAY/X1j6djNoEA5oWInDtIISlxryeOEEO5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743181999; c=relaxed/simple;
	bh=05S5aXGHh+c1z/f1P1kRRIsqJSjPN89APQt4mJYUABY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGDgKwbJyzApBwIYckQG9mkdR02XT7LdMnX7bTgZsXaoLy4BRUoinSK87hrYJyjLim0R0CjCu4Dd0Kur42WYiBuSyl6Cjw157PLxJnGk9RoVAx3LfwePd7PXPddTAzSptAj1L1qXErSxBipt3Ot27Oi3g6i/dLQKAqpTRVh8uhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=Uhxe4C+V; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 52SHC6va2029344
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 28 Mar 2025 10:12:17 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 52SHC6va2029344
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1743181938;
	bh=/4tX6ccTMOAoI9WvAyPzpCV9OFj9tKgHimPD+Eu2d8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uhxe4C+V9ZJK88ROy2+vKy9WXxgNJcOc4XuQhMjBIM62Gd5i1Ll4fkdgcQdd62IVM
	 afwIcQXZ07GVcr3L0Emya16j7jO/FuMRICRq9tXPMfsveVUc6GLHWfaRPRIuNZP3aZ
	 XccnxvdwnNjsarSwKet6c9anOkL0MIDBC5s72zbRqx7RUUbYjIwKWCDXaY4JIEWEgd
	 PaLIkgP5eFINTrSsOjI9NysxFkWyt8lbrQ61m6LOUgMa94cfdmTssZ/678ywRytLyh
	 5Burx/etGWTw1hMklt4K125YDVkH5g0Ye0ALogkZGcI4a8AwZrdF2AzhMn4WXqsEV5
	 UWoGn+DSo/udg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        andrew.cooper3@citrix.com, luto@kernel.org, peterz@infradead.org,
        chao.gao@intel.com, xin3.li@intel.com
Subject: [PATCH v4 04/19] x86/cea: Export per CPU array 'cea_exception_stacks' for KVM to use
Date: Fri, 28 Mar 2025 10:11:50 -0700
Message-ID: <20250328171205.2029296-5-xin@zytor.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250328171205.2029296-1-xin@zytor.com>
References: <20250328171205.2029296-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The per CPU array 'cea_exception_stacks' points to per CPU stacks
for #DB, NMI and #DF.  It is normally referenced via the #define:
__this_cpu_ist_top_va().

FRED introduced new fields in the host-state area of the VMCS for
stack levels 1->3 (HOST_IA32_FRED_RSP[123]), each respectively
corresponding to per CPU stacks for #DB, NMI and #DF.  KVM must
populate these each time a vCPU is loaded onto a CPU.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
---

Change in v4:
* Rewrite the change log and add comments to the export (Dave Hansen).
---
 arch/x86/mm/cpu_entry_area.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/mm/cpu_entry_area.c b/arch/x86/mm/cpu_entry_area.c
index 575f863f3c75..bc0d687de376 100644
--- a/arch/x86/mm/cpu_entry_area.c
+++ b/arch/x86/mm/cpu_entry_area.c
@@ -17,6 +17,13 @@ static DEFINE_PER_CPU_PAGE_ALIGNED(struct entry_stack_page, entry_stack_storage)
 #ifdef CONFIG_X86_64
 static DEFINE_PER_CPU_PAGE_ALIGNED(struct exception_stacks, exception_stacks);
 DEFINE_PER_CPU(struct cea_exception_stacks*, cea_exception_stacks);
+/*
+ * FRED introduced new fields in the host-state area of the VMCS for
+ * stack levels 1->3 (HOST_IA32_FRED_RSP[123]), each respectively
+ * corresponding to per CPU stacks for #DB, NMI and #DF.  KVM must
+ * populate these each time a vCPU is loaded onto a CPU.
+ */
+EXPORT_PER_CPU_SYMBOL(cea_exception_stacks);
 
 static DEFINE_PER_CPU_READ_MOSTLY(unsigned long, _cea_offset);
 
-- 
2.48.1


