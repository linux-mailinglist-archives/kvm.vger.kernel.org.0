Return-Path: <kvm+bounces-61103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D969C0B230
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 21:22:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28B583B7500
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 20:21:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E93942FFDF3;
	Sun, 26 Oct 2025 20:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="gCYjF+GI"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B5D27056D;
	Sun, 26 Oct 2025 20:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761510029; cv=none; b=Srv+vs25QRNiDbbVBwy3oaj5JWYG4u00xodSlwmkwJMNkmU+XenWOxE2pJJ2qL15xbY1ty0lZ9GAhxi1VFVdzT0j8FNw5FJDQCOeuJY4J/UxRLzsr2etMaNqTAvyUjWNQiO09S7zfxr6+QAF/oQ0bBTeFi95QLqbdEy0YQaYz3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761510029; c=relaxed/simple;
	bh=7PwOA2L22RhU7Wfpb+LLiL1s44n+Quo7GOcgLxC7hqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzbTch1RvwGEiAUIcc1Pw4Ay6fqF986jj0qtD+Z9uQs597P0cRVyM/xLHLJH7AJqdomdjfApaCJheqkn8czd/l2XO7DCuUgg4ofiwMYbWIDMCT+Mrd0SkkhdzK3EEycK3B2d56cTL/MuwNFS1tsZnJMddRQvPYxUxY/YGdAt+pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=gCYjF+GI; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59QKJBkN505258
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sun, 26 Oct 2025 13:19:25 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59QKJBkN505258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1761509965;
	bh=mAJqAzOR6CadX8T1AE8gzgcquxHerGtrywt6QGPvQE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gCYjF+GIVss4rm1wXe6hHnO0Q18pUZvfgaRrzzaZT5RgalAjOlij8lX/vXqPw7YxD
	 weVC2Zh7syhBy2GF/ntoRxzcNZIfx4iHAapIMGaxFRXbYMgxqXB58WT34oDPXqBgjH
	 EERntFFsIUmq0Krx2vcc/M36XDbeF3eOJamvuYMABwDJ9nS1hbvfalfJf/6b8ac63g
	 pBoURs2qPS50yMZPWujqPiwoBp4LpkQLckhCuDuhZsahx1j2IENwKaf4r7LAyIBTXd
	 vyNRcahdhr3uA9ucr0OoifF9SCgK0itF1PNJjTLxO5LPpAkd7vXIYcLub2+B7ClsQT
	 jtDT6vLJ5f4UA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org, sohil.mehta@intel.com
Subject: [PATCH v9 06/22] x86/cea: Export __this_cpu_ist_top_va() to KVM
Date: Sun, 26 Oct 2025 13:18:54 -0700
Message-ID: <20251026201911.505204-7-xin@zytor.com>
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

Export __this_cpu_ist_top_va() to allow KVM to retrieve the per-CPU
exception stack top.

FRED introduced new fields in the host-state area of the VMCS for stack
levels 1->3 (HOST_IA32_FRED_RSP[123]), each respectively corresponding to
per-CPU exception stacks for #DB, NMI and #DF.  KVM must populate these
fields each time a vCPU is loaded onto a CPU.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/mm/cpu_entry_area.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/mm/cpu_entry_area.c b/arch/x86/mm/cpu_entry_area.c
index b3d90f9cfbb1..e507621d5c20 100644
--- a/arch/x86/mm/cpu_entry_area.c
+++ b/arch/x86/mm/cpu_entry_area.c
@@ -19,6 +19,11 @@ static DEFINE_PER_CPU_PAGE_ALIGNED(struct exception_stacks, exception_stacks);
 DEFINE_PER_CPU(struct cea_exception_stacks*, cea_exception_stacks);
 
 /*
+ * FRED introduced new fields in the host-state area of the VMCS for
+ * stack levels 1->3 (HOST_IA32_FRED_RSP[123]), each respectively
+ * corresponding to per CPU stacks for #DB, NMI and #DF.  KVM must
+ * populate these each time a vCPU is loaded onto a CPU.
+ *
  * Typically invoked by entry code, so must be noinstr.
  */
 noinstr unsigned long __this_cpu_ist_bottom_va(enum exception_stack_ordering stack)
@@ -36,6 +41,7 @@ noinstr unsigned long __this_cpu_ist_top_va(enum exception_stack_ordering stack)
 {
 	return __this_cpu_ist_bottom_va(stack) + EXCEPTION_STKSZ;
 }
+EXPORT_SYMBOL_FOR_MODULES(__this_cpu_ist_top_va, "kvm-intel");
 
 static DEFINE_PER_CPU_READ_MOSTLY(unsigned long, _cea_offset);
 
-- 
2.51.0


