Return-Path: <kvm+bounces-57423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FC9EB55499
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 18:24:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0ED0C5A6C53
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 16:24:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCD9531A57E;
	Fri, 12 Sep 2025 16:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Q43uttwW"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E18C28DC4;
	Fri, 12 Sep 2025 16:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757694245; cv=none; b=j9hv5q2iUZGMUzFuAdsIoZN2ES9gaj6G5ybrNEy6lSVCL4ztMjT/Wj94kw29ZQoeaJ0tj5LhQWYxs7s4oGL2Er81vS3Ac5BsNLHcXsDU/9IrLNOlEQCOdDZf7Gjy5+uA6N497j3TR1BYneQJkA8L+I7cPQbNCBVt95gStT9KECE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757694245; c=relaxed/simple;
	bh=uPjCX4B8cw30sYcQExQSofzpkbZlOFG5hXZ9CNzRQXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J0DTgfVUic4XjKwTRuDE6XtseNWhgG2c23Jt6kskZd64Fo3P1mQbRJPyZC8/P4VXqHQIeUW9jO/CHcODYyTcXu7XmY+h/EgyNh4suMxi5XQtrmcDlWXOVTS79gBQF5lh/iHraSaiBzRRA7my1A9P+ROnK1zvPvnXLlaPKhQv/0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Q43uttwW; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8E05D40E0140;
	Fri, 12 Sep 2025 16:24:00 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id TYN4J7NBkPFB; Fri, 12 Sep 2025 16:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1757694236; bh=IGge7ZwhDSttMjah3YorSfFyUb93UYgumDQzLyVgR0A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q43uttwWC/BcYefv5oql8MncCbf5H7cDkOk3bTd9wvQXzlchFJILLtzThBqRqBi7r
	 3OJZbVjZe0Yh80MwYl0XpCGg0guf/RfMEbD2mFqsFBR+IeQRRuOtq1R9d/3qYztvRF
	 gpzHuaH/GrgMWj2MCdeD+UfZ3KjUjpzCzeRTgmG0V81wqWbo0dLlPwK+q9/6hByN05
	 cAYT38I1XS1E2G0rINVM7D4V4eDVSHV63TWSGnz+LXih2Oqg7Pekjz/Oa3ESi1yzCR
	 wFVW5jdVAAIEIwIP3oRrIiTDdijSbCkgGNFtJDMu6Q1r0uNqkZQBacT3nXlkikyP7v
	 X1nxSJHne1UYPQHrmdyDr4rRSynIu8D5WGYZitSHZ/VVgnT5ms9EdGh2F3oHo7aptH
	 +HA9y3LDHB2G2Wc1d6X4oE1R99Bgw3gcZe30yjHiD3W52bVybR7mJXXcFto2GU4siv
	 uOaGzDMyzOSWietv1rENNpJgeyj1JA6FULKfYHDi11i92Zy03ttkUYL9jS+Azyr4eg
	 oMjiyMhXdj7TY6zUJDPENJtDWBo/VBs6tsLozxEliKyK4IYhIj7l+F+dDH050V7hu7
	 fg0t7SaJ3Lx0SLRkqEc9TpwaF0TjzbTaQV2kdqI+qiqiXMotyr8HtdB0Z9PmIZvMsi
	 6AW7CuASA5iKdHUTy1zs2WLc=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id D528840E00DE;
	Fri, 12 Sep 2025 16:23:35 +0000 (UTC)
Date: Fri, 12 Sep 2025 18:23:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, x86@kernel.org,
	Naveen rao <naveen.rao@amd.com>, Sairaj Kodilkar <sarunkod@amd.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Xin Li (Intel)" <xin@zytor.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [RFC PATCH v5 4/4] Documentation/x86/topology: Detail CPUID
 leaves used for topology enumeration
Message-ID: <20250912162328.GAaMRJADJyRGC_FgY0@fat_crate.local>
References: <20250901170418.4314-1-kprateek.nayak@amd.com>
 <20250901170418.4314-5-kprateek.nayak@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250901170418.4314-5-kprateek.nayak@amd.com>

On Mon, Sep 01, 2025 at 05:04:18PM +0000, K Prateek Nayak wrote:
> Add a new section describing the different CPUID leaves and fields used
> to parse topology on x86 systems.
> 
> Suggested-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
> ---
> Changelog v4..v5:
> 
> o Added a nte about the NODE_ID_MSR on AMD platforms.
> ---
>  Documentation/arch/x86/topology.rst | 198 ++++++++++++++++++++++++++++
>  1 file changed, 198 insertions(+)

Some trivial simplifications and cleanups ontop:

---

diff --git a/Documentation/arch/x86/topology.rst b/Documentation/arch/x86/topology.rst
index 4227eba65957..86bec8ac2c4d 100644
--- a/Documentation/arch/x86/topology.rst
+++ b/Documentation/arch/x86/topology.rst
@@ -143,76 +143,69 @@ Thread-related topology information in the kernel:
 
 System topology enumeration
 ===========================
+
 The topology on x86 systems can be discovered using a combination of vendor
-specific CPUID leaves introduced specifically to enumerate the processor
-topology and the cache hierarchy.
+specific CPUID leaves which enumerate the processor topology and the cache
+hierarchy.
 
 The CPUID leaves in their preferred order of parsing for each x86 vendor is as
 follows:
 
-1) AMD and Hygon
-
-   On AMD and Hygon platforms, the CPUID leaves that enumerate the processor
-   topology are as follows:
+1) AMD
 
    1) CPUID leaf 0x80000026 [Extended CPU Topology] (Core::X86::Cpuid::ExCpuTopology)
 
       The extended CPUID leaf 0x80000026 is the extension of the CPUID leaf 0xB
-      and provides the topology information of Core, Complex, CCD(Die), and
+      and provides the topology information of Core, Complex, CCD (Die), and
       Socket in each level.
 
-      The support for the leaf is expected to be discovered by checking if the
-      supported extended CPUID level is >= 0x80000026 and then checking if
-      `LogProcAtThisLevel` in `EBX[15:0]` at a particular level (starting from
-      0) is non-zero.
+      Support for the leaf is discovered by checking if the maximum extended
+      CPUID level is >= 0x80000026 and then checking if `LogProcAtThisLevel`
+      in `EBX[15:0]` at a particular level (starting from 0) is non-zero.
 
-      The `LevelType` in `ECX[15:8]` at the level provides the detail of the
-      topology domain that the level describes - Core, Complex, CCD(Die), or
-      the Socket.
+      The `LevelType` in `ECX[15:8]` at the level provides the topology domain
+      the level describes - Core, Complex, CCD(Die), or the Socket.
 
       The kernel uses the `CoreMaskWidth` from `EAX[4:0]` to discover the
-      number of bits that need to be right shifted from the
-      `ExtendedLocalApicId` in `EDX[31:0]` to get a unique Topology ID for
-      the topology level. CPUs with the same Topology ID share the resources
-      at that level.
+      number of bits that need to be right-shifted from `ExtendedLocalApicId`
+      in `EDX[31:0]` in order to get a unique Topology ID for the topology 
+      level. CPUs with the same Topology ID share the resources at that level.
 
-      CPUID leaf 0x80000026 also provides more information regarding the
-      power and efficiency rankings, and about the core type on AMD
-      processors with heterogeneous characteristics.
+      CPUID leaf 0x80000026 also provides more information regarding the power
+      and efficiency rankings, and about the core type on AMD processors with
+      heterogeneous characteristics.
 
       If CPUID leaf 0x80000026 is supported, further parsing is not required.
 
-
    2) CPUID leaf 0x0000000B [Extended Topology Enumeration] (Core::X86::Cpuid::ExtTopEnum)
 
       The extended CPUID leaf 0x0000000B is the predecessor on the extended
       CPUID leaf 0x80000026 and only describes the core, and the socket domains
       of the processor topology.
 
-      The support for the leaf is expected to be discovered by checking if the
-      supported CPUID level is >= 0xB and then checking if `EBX[31:0]` at a
-      particular level (starting from 0) is non-zero.
+      The support for the leaf is discovered by checking if the maximum supported
+      CPUID level is >= 0xB and then if `EBX[31:0]` at a particular level
+      (starting from 0) is non-zero.
 
-      The `LevelType` in `ECX[15:8]` at the level provides the detail of the
-      topology domain that the level describes - Thread, or Processor (Socket).
+      The `LevelType` in `ECX[15:8]` at the level provides the topology domain
+      that the level describes - Thread, or Processor (Socket).
 
       The kernel uses the `CoreMaskWidth` from `EAX[4:0]` to discover the
-      number of bits that need to be right shifted from the
-      `ExtendedLocalApicId` in `EDX[31:0]` to get a unique Topology ID for
-      that topology level. CPUs sharing the Topology ID share the resources
-      at that level.
+      number of bits that need to be right-shifted from the `ExtendedLocalApicId`
+      in `EDX[31:0]` to get a unique Topology ID for that topology level. CPUs
+      sharing the Topology ID share the resources at that level.
 
       If CPUID leaf 0xB is supported, further parsing is not required.
 
 
    3) CPUID leaf 0x80000008 ECX [Size Identifiers] (Core::X86::Cpuid::SizeId)
 
-      If neither the CPUID leaf 0x80000026 or CPUID leaf 0xB is supported, the
-      number of CPUs on the package is detected using the Size Identifier leaf
+      If neither the CPUID leaf 0x80000026 nor 0xB is supported, the number of
+      CPUs on the package is detected using the Size Identifier leaf
       0x80000008 ECX.
 
-      The support for the leaf is expected to be discovered by checking if the
-      supported extended CPUID level is >= 0x80000008.
+      The support for the leaf is discovered by checking if the supported
+      extended CPUID level is >= 0x80000008.
 
       The shifts from the APIC ID for the Socket ID is calculated from the
       `ApicIdSize` field in `ECX[15:12]` if it is non-zero.
@@ -251,8 +244,8 @@ follows:
       `cu_id` (Compute Unit ID) to detect CPUs that share the compute units.
 
 
-   All AMD and Hygon processors that support the `TopologyExtensions` feature
-   stores the `NodeId` from the `ECX[7:0]` of CPUID leaf 0x8000001E
+   All AMD processors that support the `TopologyExtensions` feature store the
+   `NodeId` from the `ECX[7:0]` of CPUID leaf 0x8000001E 
    (Core::X86::Cpuid::NodeId) as the per-CPU `node_id`. On older processors,
    the `node_id` was discovered using MSR_FAM10H_NODE_ID MSR (MSR
    0x0xc001_100c). The presence of the NODE_ID MSR was detected by checking
@@ -271,13 +264,13 @@ follows:
       the topology information of Core, Module, Tile, Die, DieGrp, and Socket
       in each level.
 
-      The support for the leaf is expected to be discovered by checking if
-      the supported CPUID level is >= 0x1F and then `EBX[31:0]` at a
-      particular level (starting from 0) is non-zero.
+      The support for the leaf is discovered by checking if the supported
+      CPUID level is >= 0x1F and then `EBX[31:0]` at a particular level
+      (starting from 0) is non-zero.
 
-      The `Domain Type` in `ECX[15:8]` of the sub-leaf provides the detail of
-      the topology domain that the level describes - Core, Module, Tile, Die,
-      DieGrp, and Socket.
+      The `Domain Type` in `ECX[15:8]` of the sub-leaf provides the topology
+      domain that the level describes - Core, Module, Tile, Die, DieGrp, and
+      Socket.
 
       The kernel uses the value from `EAX[4:0]` to discover the number of
       bits that need to be right shifted from the `x2APIC ID` in `EDX[31:0]`
@@ -293,9 +286,9 @@ follows:
       Topology Enumeration Leaf 0x1F and only describes the core, and the
       socket domains of the processor topology.
 
-      The support for the leaf is expected to be discovered by checking if the
-      supported CPUID level is >= 0xB and then checking if `EBX[31:0]` at a
-      particular level (starting from 0) is non-zero.
+      The support for the leaf is iscovered by checking if the supported CPUID
+      level is >= 0xB and then checking if `EBX[31:0]` at a particular level
+      (starting from 0) is non-zero.
 
       CPUID leaf 0x0000000B shares the same layout as CPUID leaf 0x1F and
       should be enumerated in a similar manner.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

