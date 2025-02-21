Return-Path: <kvm+bounces-38836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C43AA3ED2D
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 08:18:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5828417E409
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 07:18:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44A6E1FF1D4;
	Fri, 21 Feb 2025 07:18:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.nfschina.com (unknown [42.101.60.213])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 48C698F6E;
	Fri, 21 Feb 2025 07:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=42.101.60.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740122304; cv=none; b=iZ7CZ/ChJP+YionuOf3Iwa14M/z8ucEFrjc7ozMDb0CR3w9yp5A6SHFbLBNxC/6kMcZLWD275FCvldD+DtO0DZzRhkCZNSh+W+HUlKG74hID39Ys+tiFfdDvteuqAmFp/zqiZLwVH6REfccf1VBG0eDIf8zJmwP5Fapm5RpWYpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740122304; c=relaxed/simple;
	bh=Z92IeH03E87WjMgNNGxUrtb6MDAucuDKaPVm85LC7wE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=QdUu91M5s9yxnfK3+Z3KHW5jXunrnSNYjGjBpP9j0hmv/NDESxOfUP4mW1xFGX233mza+7ZWBccFk2tltF3LHeMFPMlirwPch7KMLpEKntYDr6qU/nLKNyB+uy+IO+Jq0dLSxAeMwMnDmCZBH2YYOCHD/WmgItdvvfIrv7RcBXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com; spf=pass smtp.mailfrom=nfschina.com; arc=none smtp.client-ip=42.101.60.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nfschina.com
Received: from localhost.localdomain (unknown [180.167.10.98])
	by mail.nfschina.com (MailData Gateway V2.8.8) with ESMTPSA id 2F21360234D6D;
	Fri, 21 Feb 2025 15:18:08 +0800 (CST)
X-MD-Sfrom: suhui@nfschina.com
X-MD-SrcIP: 180.167.10.98
From: Su Hui <suhui@nfschina.com>
To: binbin.wu@linux.intel.com
Cc: Su Hui <suhui@nfschina.com>,
	seanjc@google.com,
	pbonzini@redhat.com,
	linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH] include/linux/log2.h: mark is_power_of_2() with __always_inline
Date: Fri, 21 Feb 2025 15:16:25 +0800
Message-Id: <20250221071624.1356899-1-suhui@nfschina.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When build kernel with randconfig, there is an error:

In function ‘kvm_is_cr4_bit_set’,inlined from
‘kvm_update_cpuid_runtime’ at arch/x86/kvm/cpuid.c:310:9:

include/linux/compiler_types.h:542:38: error: call to
‘__compiletime_assert_380’ declared with attribute error:
BUILD_BUG_ON failed: !is_power_of_2(cr4_bit).

'!is_power_of_2(X86_CR4_OSXSAVE)' is False, but gcc treats is_power_of_2()
as non-inline function and a compilation error happens. Fix this by marking
is_power_of_2() with __always_inline.

Signed-off-by: Su Hui <suhui@nfschina.com>
---
 include/linux/log2.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/log2.h b/include/linux/log2.h
index 9f30d087a128..1366cb688a6d 100644
--- a/include/linux/log2.h
+++ b/include/linux/log2.h
@@ -41,7 +41,7 @@ int __ilog2_u64(u64 n)
  * *not* considered a power of two.
  * Return: true if @n is a power of 2, otherwise false.
  */
-static inline __attribute__((const))
+static __always_inline __attribute__((const))
 bool is_power_of_2(unsigned long n)
 {
 	return (n != 0 && ((n & (n - 1)) == 0));
-- 
2.30.2


