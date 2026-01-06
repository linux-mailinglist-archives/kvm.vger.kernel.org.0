Return-Path: <kvm+bounces-67106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D0F0CCF7823
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 10:24:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BE28D3041F72
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 09:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A185B3195FD;
	Tue,  6 Jan 2026 09:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1IAtTiKz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17480316184
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 09:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767691476; cv=none; b=gQCdy6D1S9JRZM2mRft1zLUl+Fo1epMtb8YC7yUlHiV4SrO4Xe+GvAIqi2LPM97xF7UmuSylViBWumUKaCUjtIHdEekbY9qcVXX/3DAhEdicgys3zNBaSfmd8wjPVZJGusTFHIqxFOStqkW+BJijcGoNFKvYbeDX6rfN9CPCHq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767691476; c=relaxed/simple;
	bh=U4Uc7cfFCbVrFYrK2pc/nN0q0fRyukpzVm5Md8fH1vI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ls4knhbxjZAIG1KJcnO4htmCklh19tzMjSJ4hJwWKtxGPt7hUEwsqiMFu/ct1817s//1bav9HcbpIsCEJOeWyfiafFH2fNUcuXHeoYrJ9BsNGSSM+lnoq8p49oXhHzf391kHI8a2Pexb9s49tU+nlnl8k8HR4S1H4sFq3y1oaI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1IAtTiKz; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4775f51ce36so8971455e9.1
        for <kvm@vger.kernel.org>; Tue, 06 Jan 2026 01:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767691470; x=1768296270; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GnwfbAHF0PCbdtqYfWOE4YUYyRoOfTU/WzuQ296CXfU=;
        b=1IAtTiKzS3q2h8BFdyaGmKALpN0qRDpuyQGV6Wipj6L6W+3AvV6g7OurQZoZU2O2OY
         W541xW2Lb8WL9/svlPDolhn1uEpLkBU5KNDhFHnluwCA59/yQpQqImeIzzv/yOKgqG50
         6eZoenD0SdVp8CChT1cgeCaMl89fyPLIREeE5WzPGVl3v0mxYVDShAqA3zoudJfEXF4t
         /9von5zU9Gpf7ZV8CYVmh1fXmJ36IhV2so78BZNkbvqFNIT2vKFkX27Fo5ItNxwLmzof
         yn2MmQZlMfZWlo2WS2i/3zQb4e2E/QPjzJQHgyANZV8gYn4hngsG1GhHlTxTTRM9YjjX
         55YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767691470; x=1768296270;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GnwfbAHF0PCbdtqYfWOE4YUYyRoOfTU/WzuQ296CXfU=;
        b=n7KoG293wcd9w5UJ3XAPyHIUjc62KruffmIM6bXB6CrBgusmFhnrV6Sdtx0gdIVQyw
         NHkViulAs5I3xTuRLn7tyxe0awEC04OTHevS45GqPFCv/xzvFZhQS38KBxk6HbQndmfD
         BliDvwXR0Q7uSgICp9x91H2gCvHhp7Rj1iu+IWZD8bJeZCa+R1xalfZy0K5h+EP0e9XP
         6gyAinb0huGMu6KSv80fxEW5xah6lTWA1aqGhG5uDDwDSI6N5Xt7ZAIyb7m6xllehbeF
         PMPbHzMf26NOlkPh1bcTg54avTv2tItu9aiLnyygt6K5oJwGhW3ZWUcUMBOngUhboSJh
         HLBg==
X-Gm-Message-State: AOJu0Yz7bylgHIFWTTDIXv+QSvw7HRly/ZsPKZoe4uEkmROMtTHdod0U
	M+ab+KT2dQW/O3WLQdFOSWXcLZAmuSzl7RGWJnb4XidY+3sm7B+Urk8a9yOEyVc5P4ahpxemIWl
	OyDOxe3CWw7IhsRI/KsPgvsz3iDFlDWMYKiO1gF8/EOcr5GIFymzGsxKxWlLkPReUYRyzVG8V7E
	eBGPyRpCC8vJqsr/RgXd9zVDsGv6I=
X-Google-Smtp-Source: AGHT+IFcux+MH2/SnWRN59yd/EeqV0PSeYuceHIifCar56w5WkrXGG2T9nSrUb58DNoCU0or4EnrLtHc9A==
X-Received: from wmbdn5.prod.google.com ([2002:a05:600c:6545:b0:477:9fac:c456])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a16:b0:477:58af:a91d
 with SMTP id 5b1f17b1804b1-47d7f06b874mr27945865e9.5.1767691470261; Tue, 06
 Jan 2026 01:24:30 -0800 (PST)
Date: Tue,  6 Jan 2026 09:24:24 +0000
In-Reply-To: <20260106092425.1529428-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106092425.1529428-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260106092425.1529428-5-tabba@google.com>
Subject: [PATCH v3 4/5] KVM: selftests: Move page_align() to shared header
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, 
	itaru.kitayama@fujitsu.com, andrew.jones@linux.dev, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

To avoid code duplication, move page_align() to the shared `kvm_util.h`
header file.

No functional change intended.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
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
2.52.0.351.gbe84eed79e-goog


