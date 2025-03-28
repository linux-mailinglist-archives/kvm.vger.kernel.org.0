Return-Path: <kvm+bounces-42189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25B54A74EF7
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 18:14:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D3B7016EC3B
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 17:13:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02EE91DED5B;
	Fri, 28 Mar 2025 17:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="AvL8U329"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3A11DB13A;
	Fri, 28 Mar 2025 17:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743181994; cv=none; b=ejoNrNo6CXuATCvDlTpgGqfNies41FFCkOl0+nvWBsVa+lpJt5djA1ydbvBF5ttSkop8qlYB0N/vvGedvcTPQ6tefc2y8d/wp/FJsT64q1tB8fjDVOt2mCBX4e7jZg8KZj7PrXMf5klRi8iOG5RJU0S7jgyK85Gz626VeLdwPGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743181994; c=relaxed/simple;
	bh=J+EKMx8L3y9ngIXQz/Yb0B+zKi9x1lOW7gYtQTmf6EU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eheuxCYI/uMPx1rKNF7qucdijc8kHA9iIC0BO7i/RAc8n99sjoHQ2RlZdzEEra7f5Vid+TopharC/w3mDykly5sdtqgDkdvpkPp/QECbUB+DFpQnP84TlH51CEwnDcpoWmE41CGR/ui7E1GiTPB7qiw+uSo+zGgptzTlAXVzwws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=AvL8U329; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 52SHC6vl2029344
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 28 Mar 2025 10:12:27 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 52SHC6vl2029344
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1743181948;
	bh=qie2NTW9OuZdrsd4JgHYlbtUr6seGde2iSN+NuXmkfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AvL8U329vP+ctiqG4Ncse7OQtcTUNW6s0iPfTUROUQtrQojF5k4FmgErjXYQOHMtj
	 RCfNXCsM9ixdvCoX6fl2/1Zezodu6qlTkWJbUz9CHHRQu4gXQ69NhvlDA3uyFqVZ0M
	 zbef4822yVmG7AnSgfekBUpqxMs9FhrKPLTNIX3L6bi0sVMPw3qiPqlSR7ECJ2jGbH
	 8V+C41LvJPg9AoDGPvDQWjbiMmWoNHUg4DGKwj+gqtf7sGZSHkkdUkNXzPYOuDfHb8
	 blAseHk4GSEoXoQxbXPEuLBVQAC6yHMj2UHlyeNVt9tUwdj8o2HYaqZDOBYtbOzOvX
	 QSWIxwGCCyUkw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        andrew.cooper3@citrix.com, luto@kernel.org, peterz@infradead.org,
        chao.gao@intel.com, xin3.li@intel.com
Subject: [PATCH v4 15/19] KVM: x86: Allow FRED/LKGS to be advertised to guests
Date: Fri, 28 Mar 2025 10:12:01 -0700
Message-ID: <20250328171205.2029296-16-xin@zytor.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250328171205.2029296-1-xin@zytor.com>
References: <20250328171205.2029296-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Allow FRED/LKGS to be advertised to guests after changes required to
enable FRED in a KVM guest are in place.

LKGS is introduced with FRED to completely eliminate the need to swapgs
explicilty, because

1) FRED transitions ensure that an operating system can always operate
   with its own GS base address.

2) LKGS behaves like the MOV to GS instruction except that it loads
   the base address into the IA32_KERNEL_GS_BASE MSR instead of the
   GS segment’s descriptor cache, which is exactly what Linux kernel
   does to load a user level GS base.  Thus there is no need to SWAPGS
   away from the kernel GS base and an execution of SWAPGS causes #UD
   if FRED transitions are enabled.

A FRED CPU must enumerate LKGS.  When LKGS is not available, FRED must
not be enabled.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
---
 arch/x86/kvm/cpuid.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 5e4d4934c0d3..8f290273aee1 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -992,6 +992,8 @@ void kvm_set_cpu_caps(void)
 		F(FZRM),
 		F(FSRS),
 		F(FSRC),
+		F(FRED),
+		F(LKGS),
 		F(AMX_FP16),
 		F(AVX_IFMA),
 		F(LAM),
-- 
2.48.1


