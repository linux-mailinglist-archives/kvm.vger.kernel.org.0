Return-Path: <kvm+bounces-42232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 37CC7A761B8
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 10:26:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC57D168F5E
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 08:26:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CEAC1E32D5;
	Mon, 31 Mar 2025 08:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="m3OGyhoJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298B215624D;
	Mon, 31 Mar 2025 08:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743409454; cv=none; b=NvxnjxFZkujXxJj4T043/f+JkekR4VRwz9E0GkdljnxIwA/FjUeBXcLxK+q/hKd4xNPy8Ri7EazyV2VlT0iWmfkoBXMQh06S7Faq+uowv+OA1yEANneonkU7dWT2ZhCkjaM25MnuWYh+KLpA7hL/7TCrMEtAvt7dN8KwZC56hGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743409454; c=relaxed/simple;
	bh=MlzZP2PcWDZrFa9hDnXv30fqYMM04NkLvN5K6Ig/4KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exGMydajc7kaCtwk5Oy+QFAR2wOShgW/Q1+m3uC+iWvj39z0eW1zMljZ9XrOVDf3cnDfY1034rtzFKEThammFXytTUs+jv5UVbUaNe4NL5wlOd9IOp8HJixs5tk/vvtOWUufC1pYoQ3tEQtgaJIuzUwhcbxOmdpOzMw0nqzvfsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=m3OGyhoJ; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 52V8Mp093171319
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 31 Mar 2025 01:23:16 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 52V8Mp093171319
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1743409398;
	bh=XaAm3SgdeuQpqxiLf3TgiBnvvEMb/sqRjazcaLW8DyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m3OGyhoJNr0Zsep5p1ViUs89IdqwpoEtbWuo2OsC8y9JAzzZbZXvjUjaRqzx5AUYK
	 lJcmsGoVuGakNOlQ489XYhpn7UoCG2qfRQMcP3vMYw+NnWAKYOXHRdzMSDVDxQLIJJ
	 kKOmdnvGQYVe7ioNqEmxq2m51haFE/snyyuHDZ7lhQTKPP3O+McTy73wS5FrEXpbEA
	 GSpcgMRq/tDS9ikpfmvoHA9qWJyh5e7k4bNtkTdyO72QoWkxhdrF5ZM+BjwqxGvb8o
	 Fxagag3lgbW6Apcxom4HGKuHb9Jh6FSWSc4zA4lH3CcX3khjRVDzEBBBmSENC1+wB9
	 70W8KGHT8R63g==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
        linux-edac@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        jgross@suse.com, andrew.cooper3@citrix.com, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        alexey.amakhalov@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        tony.luck@intel.com, pbonzini@redhat.com, vkuznets@redhat.com,
        seanjc@google.com, luto@kernel.org, boris.ostrovsky@oracle.com,
        kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com
Subject: [RFC PATCH v1 09/15] x86/opcode: Add immediate form MSR instructions to x86-opcode-map
Date: Mon, 31 Mar 2025 01:22:45 -0700
Message-ID: <20250331082251.3171276-10-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250331082251.3171276-1-xin@zytor.com>
References: <20250331082251.3171276-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the instruction opcodes used by the immediate form WRMSRNS/RDMSR
to x86-opcode-map.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/lib/x86-opcode-map.txt       | 5 +++--
 tools/arch/x86/lib/x86-opcode-map.txt | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index caedb3ef6688..e64f52321d6d 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -839,7 +839,7 @@ f1: MOVBE My,Gy | MOVBE Mw,Gw (66) | CRC32 Gd,Ey (F2) | CRC32 Gd,Ew (66&F2)
 f2: ANDN Gy,By,Ey (v)
 f3: Grp17 (1A)
 f5: BZHI Gy,Ey,By (v) | PEXT Gy,By,Ey (F3),(v) | PDEP Gy,By,Ey (F2),(v) | WRUSSD/Q My,Gy (66)
-f6: ADCX Gy,Ey (66) | ADOX Gy,Ey (F3) | MULX By,Gy,rDX,Ey (F2),(v) | WRSSD/Q My,Gy
+f6: ADCX Gy,Ey (66) | ADOX Gy,Ey (F3) | MULX By,Gy,rDX,Ey (F2),(v) | WRSSD/Q My,Gy | RDMSR Rq,Gq (F2),(11B) | WRMSRNS Gq,Rq (F3),(11B)
 f7: BEXTR Gy,Ey,By (v) | SHLX Gy,Ey,By (66),(v) | SARX Gy,Ey,By (F3),(v) | SHRX Gy,Ey,By (F2),(v)
 f8: MOVDIR64B Gv,Mdqq (66) | ENQCMD Gv,Mdqq (F2) | ENQCMDS Gv,Mdqq (F3) | URDMSR Rq,Gq (F2),(11B) | UWRMSR Gq,Rq (F3),(11B)
 f9: MOVDIRI My,Gy
@@ -1014,7 +1014,7 @@ f1: CRC32 Gy,Ey (es) | CRC32 Gy,Ey (66),(es) | INVVPID Gy,Mdq (F3),(ev)
 f2: INVPCID Gy,Mdq (F3),(ev)
 f4: TZCNT Gv,Ev (es) | TZCNT Gv,Ev (66),(es)
 f5: LZCNT Gv,Ev (es) | LZCNT Gv,Ev (66),(es)
-f6: Grp3_1 Eb (1A),(ev)
+f6: Grp3_1 Eb (1A),(ev) | RDMSR Rq,Gq (F2),(11B),(ev) | WRMSRNS Gq,Rq (F3),(11B),(ev)
 f7: Grp3_2 Ev (1A),(es)
 f8: MOVDIR64B Gv,Mdqq (66),(ev) | ENQCMD Gv,Mdqq (F2),(ev) | ENQCMDS Gv,Mdqq (F3),(ev) | URDMSR Rq,Gq (F2),(11B),(ev) | UWRMSR Gq,Rq (F3),(11B),(ev)
 f9: MOVDIRI My,Gy (ev)
@@ -1103,6 +1103,7 @@ EndTable
 Table: VEX map 7
 Referrer:
 AVXcode: 7
+f6: RDMSR Rq,Id (F2),(v1),(11B) | WRMSRNS Id,Rq (F3),(v1),(11B)
 f8: URDMSR Rq,Id (F2),(v1),(11B) | UWRMSR Id,Rq (F3),(v1),(11B)
 EndTable
 
diff --git a/tools/arch/x86/lib/x86-opcode-map.txt b/tools/arch/x86/lib/x86-opcode-map.txt
index caedb3ef6688..e64f52321d6d 100644
--- a/tools/arch/x86/lib/x86-opcode-map.txt
+++ b/tools/arch/x86/lib/x86-opcode-map.txt
@@ -839,7 +839,7 @@ f1: MOVBE My,Gy | MOVBE Mw,Gw (66) | CRC32 Gd,Ey (F2) | CRC32 Gd,Ew (66&F2)
 f2: ANDN Gy,By,Ey (v)
 f3: Grp17 (1A)
 f5: BZHI Gy,Ey,By (v) | PEXT Gy,By,Ey (F3),(v) | PDEP Gy,By,Ey (F2),(v) | WRUSSD/Q My,Gy (66)
-f6: ADCX Gy,Ey (66) | ADOX Gy,Ey (F3) | MULX By,Gy,rDX,Ey (F2),(v) | WRSSD/Q My,Gy
+f6: ADCX Gy,Ey (66) | ADOX Gy,Ey (F3) | MULX By,Gy,rDX,Ey (F2),(v) | WRSSD/Q My,Gy | RDMSR Rq,Gq (F2),(11B) | WRMSRNS Gq,Rq (F3),(11B)
 f7: BEXTR Gy,Ey,By (v) | SHLX Gy,Ey,By (66),(v) | SARX Gy,Ey,By (F3),(v) | SHRX Gy,Ey,By (F2),(v)
 f8: MOVDIR64B Gv,Mdqq (66) | ENQCMD Gv,Mdqq (F2) | ENQCMDS Gv,Mdqq (F3) | URDMSR Rq,Gq (F2),(11B) | UWRMSR Gq,Rq (F3),(11B)
 f9: MOVDIRI My,Gy
@@ -1014,7 +1014,7 @@ f1: CRC32 Gy,Ey (es) | CRC32 Gy,Ey (66),(es) | INVVPID Gy,Mdq (F3),(ev)
 f2: INVPCID Gy,Mdq (F3),(ev)
 f4: TZCNT Gv,Ev (es) | TZCNT Gv,Ev (66),(es)
 f5: LZCNT Gv,Ev (es) | LZCNT Gv,Ev (66),(es)
-f6: Grp3_1 Eb (1A),(ev)
+f6: Grp3_1 Eb (1A),(ev) | RDMSR Rq,Gq (F2),(11B),(ev) | WRMSRNS Gq,Rq (F3),(11B),(ev)
 f7: Grp3_2 Ev (1A),(es)
 f8: MOVDIR64B Gv,Mdqq (66),(ev) | ENQCMD Gv,Mdqq (F2),(ev) | ENQCMDS Gv,Mdqq (F3),(ev) | URDMSR Rq,Gq (F2),(11B),(ev) | UWRMSR Gq,Rq (F3),(11B),(ev)
 f9: MOVDIRI My,Gy (ev)
@@ -1103,6 +1103,7 @@ EndTable
 Table: VEX map 7
 Referrer:
 AVXcode: 7
+f6: RDMSR Rq,Id (F2),(v1),(11B) | WRMSRNS Id,Rq (F3),(v1),(11B)
 f8: URDMSR Rq,Id (F2),(v1),(11B) | UWRMSR Id,Rq (F3),(v1),(11B)
 EndTable
 
-- 
2.49.0


