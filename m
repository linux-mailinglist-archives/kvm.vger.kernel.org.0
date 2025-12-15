Return-Path: <kvm+bounces-65984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AA2ACBEC8E
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 16:56:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 282943015E2D
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 15:56:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C32CC30CDBD;
	Mon, 15 Dec 2025 15:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aKpYS5eC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0457C265CA6
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 15:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765814151; cv=none; b=JMuC3Sd7y43drQOuorEPo8L9+AHNA/WIqyhCoiyKikYDcfivgVI3dmvEtg2x+4QUkudNq2VqIp/YjvrgdOGn7SRnMy9MkmruD9whZg08P9JuH1izRzXBXiUC320ICmCilHH22zmfwxL6997LhQJ/oTNW65HeXYjIZhR2pksVXzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765814151; c=relaxed/simple;
	bh=ayln4Fw+8UlRvvb+n2Kfq+LyehdpOH5myyhVGffmoAA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OFjZeFD5c1+RFr2Z06NP7knWz/EQ6A4Io8wx/dgaHV77MWiOcvkM6D5p692met4sDOdG4GUrXnbdHL3wgQNgajp4TXV4zDEWU6iUBuYWa54kn/oF1wwYRDudfdIHE34Velz1ZBRuqDuHHdHvqm8bAZLFSYisMFmftvZN3xmq5a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aKpYS5eC; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47799717212so30275095e9.3
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 07:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765814148; x=1766418948; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VGTJpqAtjnaQAGGRy8gsotmE8IXAZ0B2ScsPjP/ESd0=;
        b=aKpYS5eCkid2GleWxG0B1YqkQr7U3NZuxOrIK6/uCJzJT3OEr35hgqNIJhAR3pKj1a
         Vd7crnIxYxLQl0daeuK1iiLBXGpSFp14pON0chFt8AS0aXZ2UAVR53bAX/U14FQd6/gz
         gYf9pvWmzCJCLkTBygVctfeCu5KW76YH7suwzbxU5ckd3WAVozxTd3F8yqhy3u21Y4ms
         X5kcj0xfKRVfrISdWZJu89vQHxDGIB3m9Hu0e8TzivUjNT0nZ8qSUhAzQRBshSv4FtkK
         YAfNim3zVA/8vy/fILF5WOInPZMr2gCqJT0S2LZ7Gxy+giFw16+koLD6YtAmfqp51Pi2
         iyxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765814148; x=1766418948;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VGTJpqAtjnaQAGGRy8gsotmE8IXAZ0B2ScsPjP/ESd0=;
        b=vnoPeby/ApXtPsalj1FYaZCJtlUJ2SSdM4b9lv5YNaUroWviBSpw8Vs/FEyNHwDFwD
         /1xWqe9NTbTSvVNqLaD/1iqikbc2bLq4ejTiICnys3Cf4hcP65P65sFPM/Cxt73FC3Px
         IUhRer323dkxq0w3747Vz00PeQzFm/a5pJyw51/K3XiaIacRste693D6QLoFUHTvt7qp
         xI+eeaQPv+VyKEOgyTHkFjyqicLwlioburjQdfxWsN3EYBSywtZEvS+Fkik0NHLInqCy
         9WLSKS1uNyeVKkI6oHjk+wCsduHrLbZSrlbwK6e3ZG6XA0zNxIMeEhwA3CVhQVZcDgzc
         3rig==
X-Gm-Message-State: AOJu0Yyv+d3mgka4QVJWKqEjYxh3j6ZhgK/DG/UCQGcSIvP4MBWBfH2G
	wKq0L+L9E28mFqiwqyDsTipDr4Iqwt4BVIxepD+9IgR/o7pneyswtIujYeKvgxgfiK381SnW8Uh
	j04QQFP08O3cEZe81z3uiCEgCgjUeDBXMzx2JyMxKsDw0M8VdZrv4j0T64my2go4kDC6llOangi
	Mg3XmU//xb7LcW6Y/qD0ZNzSFf0xU=
X-Google-Smtp-Source: AGHT+IFu/CRJvcQstPKEoREXa/0twPeT8ivZ6zCy+WbZ9jQY7hKkhhHO0/GXQytwxU2TRpJWK8W7Jf62jQ==
X-Received: from wmbb8.prod.google.com ([2002:a05:600c:5888:b0:477:5a0f:1860])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a012:b0:479:3a88:de5e
 with SMTP id 5b1f17b1804b1-47a8f92029emr94229645e9.37.1765814147947; Mon, 15
 Dec 2025 07:55:47 -0800 (PST)
Date: Mon, 15 Dec 2025 15:55:41 +0000
In-Reply-To: <20251215155542.3195173-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251215155542.3195173-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215155542.3195173-5-tabba@google.com>
Subject: [PATCH v1 4/5] KVM: selftests: Move page_align() to shared header
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: tabba@google.com
Content-Type: text/plain; charset="UTF-8"

To avoid code duplication, move page_align() to the shared `kvm_util.h`
header file.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h    | 5 +++++
 tools/testing/selftests/kvm/lib/arm64/processor.c | 5 -----
 tools/testing/selftests/kvm/lib/riscv/processor.c | 5 -----
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 81f4355ff28a..dabbe4c3b93f 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -1258,6 +1258,11 @@ static inline int __vm_disable_nx_huge_pages(struct kvm_vm *vm)
 	return __vm_enable_cap(vm, KVM_CAP_VM_DISABLE_NX_HUGE_PAGES, 0);
 }
 
+static inline uint64_t page_align(struct kvm_vm *vm, uint64_t v)
+{
+	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
+}
+
 /*
  * Arch hook that is invoked via a constructor, i.e. before exeucting main(),
  * to allow for arch-specific setup that is common to all tests, e.g. computing
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 607a4e462984..143632917766 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -21,11 +21,6 @@
 
 static vm_vaddr_t exception_handlers;
 
-static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
-{
-	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
-}
-
 static uint64_t pgd_index(struct kvm_vm *vm, vm_vaddr_t gva)
 {
 	unsigned int shift = (vm->pgtable_levels - 1) * (vm->page_shift - 3) + vm->page_shift;
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index d5e8747b5e69..f8ff4bf938d9 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -26,11 +26,6 @@ bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext)
 	return !ret && !!value;
 }
 
-static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
-{
-	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
-}
-
 static uint64_t pte_addr(struct kvm_vm *vm, uint64_t entry)
 {
 	return ((entry & PGTBL_PTE_ADDR_MASK) >> PGTBL_PTE_ADDR_SHIFT) <<
-- 
2.52.0.239.gd5f0c6e74e-goog


