Return-Path: <kvm+bounces-56217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 962B1B3AEE8
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 02:09:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F13E583253
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 00:09:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D8F6236435;
	Fri, 29 Aug 2025 00:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="osvxEVSf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1593A222586
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 00:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756426004; cv=none; b=ajqLAMjn5O3UV0cxuP9Xi1NSmUEpHpc73jlPTv445aPSbr/srKQGPkl7L9pCud/Bz4i0j0lnJvtdyF9tzKOQ/iKHSjcnyjZtoKsFl9+5bJlvoVcSkegMB6/I2TnMgAULTdIdd6v9HcN2hOWknB/SYeZ2uHmukpZWCE41B39IxYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756426004; c=relaxed/simple;
	bh=902UVUZmCSPpi8X+dDv5xOlcB4XyEnFTmnxe/BF6V3o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qo3nReOA4AICu+d0Wzhhjn9WA0Ime7aaSxXMpsCr0isGXQN33HfGPVCJytpdyM8pf2xXQpZVDsCvscF9uTImvqMyOK6qmYwfNqrNctuXS/WzwQjXl29h9wjGzd4oRirHy7ec6Sau2C3kFyXGSf51JRXL1ZOq0Sc+ERExQriEL7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=osvxEVSf; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-77053dd5eecso2286942b3a.3
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 17:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756426002; x=1757030802; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=I8qRi06qGVaXga/Xlpn8ZvFudxvmpq5UoDX0cKOu9ig=;
        b=osvxEVSf/PKfE62dS8D7rWg+JomvMX7Tm8vM17OIhVXLOCegJ3FO0HxNK1kqgyBtoP
         JwN10rBUrHhWs1jtXMkzpLMwE/3xCrytbv5JGcNhggUOGkONzmvCbJScMIudkBq3QNfG
         gwozla2eWgr18PmeZfCxGG/yTlcZ44l6EHD4qPvhKVIGcaD7Ln1kOZUXkAt0FWtoI30Y
         Gx334suTFe9lcHSscY+06VjYKnvwqemXpvhBSI8Fm+UGnNQfHyGFaffEZdSn8pNfXuq6
         SQW30xbvud0OjH25urGpS6b+Dsz+MJ1+W5KKaBZ/w5dWoyu7Xbh9NIcvHkFqgPdlcymL
         Lfzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756426002; x=1757030802;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I8qRi06qGVaXga/Xlpn8ZvFudxvmpq5UoDX0cKOu9ig=;
        b=GbgVrrt7Q1uvEcy4Gu8AyQBSCYjwRS+i/gzMmLbI3e2o2rezMhsk+pRI253CU2maP5
         MhwubXPSfJOJL5JZxJobUVdyGXAimGv7seyJnFT4BcItbbVGVC3Tl6l2+OJFvSe5oJG4
         6mZdj7C0ZPHwqvUu1fMAJvJRWRjp4VSVF/7x1TxtGDubmv2Rzt2wR9pC0t6O15wP8tGL
         gOya8iD5x+bJq4aG6mnb7hxZVGMl8gogn7CVkwXssm4KJGKW/fGcxPHIW2ypmuakmoNb
         HOkAwlZRXUaUIyR4QlrOKG2vPYH/wDW8gTCmxMDxHeUFJR4Du0YZWby3+H6fekALrysb
         +H6w==
X-Gm-Message-State: AOJu0Yx25T2e9jsXBlVf8MfHFg1jAfWlLyGrDlWmVMNwpY+ON29nDAfx
	EtdhZ2vXJjTKAi+xjramKwLWGsaOOJD6+3VMtXo3LhRDe/QM6gAb4X8vegcKIMvFcmUkR58VRsG
	EvsdI+A==
X-Google-Smtp-Source: AGHT+IFg+0Lyt/ONHma24rkTg8rYgWVOQSWd8hCU5VIhmhLogULJMsRMy1cHwlhM00wbNXuZW4pEW5RvOgc=
X-Received: from pfbhg14.prod.google.com ([2002:a05:6a00:860e:b0:771:e396:a7fa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1a94:b0:771:e8be:8390
 with SMTP id d2e1a72fcca58-771e8be87b2mr21526977b3a.14.1756426002390; Thu, 28
 Aug 2025 17:06:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 28 Aug 2025 17:06:12 -0700
In-Reply-To: <20250829000618.351013-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250829000618.351013-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
Message-ID: <20250829000618.351013-13-seanjc@google.com>
Subject: [RFC PATCH v2 12/18] KVM: TDX: Bug the VM if extended the initial
 measurement fails
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

WARN and terminate the VM if TDH_MR_EXTEND fails, as extending the
measurement should fail if and only if there is a KVM bug, or if the S-EPT
mapping is invalid, and it should be impossibe for the S-EPT mappings to
be removed between kvm_tdp_mmu_map_private_pfn() and tdh_mr_extend().

Holding slots_lock prevents zaps due to memslot updates,
filemap_invalidate_lock() prevents zaps due to guest_memfd PUNCH_HOLE,
and all usage of kvm_zap_gfn_range() is mutually exclusive with S-EPT
entries that can be used for the initial image.  The call from sev.c is
obviously mutually exclusive, TDX disallows KVM_X86_QUIRK_IGNORE_GUEST_PAT
so same goes for kvm_noncoherent_dma_assignment_start_or_stop, and while
__kvm_set_or_clear_apicv_inhibit() can likely be tripped while building the
image, the APIC page has its own non-guest_memfd memslot and so can't be
used for the initial image, which means that too is mutually exclusive.

Opportunistically switch to "goto" to jump around the measurement code,
partly to make it clear that KVM needs to bail entirely if extending the
measurement fails, partly in anticipation of reworking how and when
TDH_MEM_PAGE_ADD is done.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 06dd2861eba7..bc92e87a1dbb 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3145,14 +3145,22 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 
 	KVM_BUG_ON(atomic64_dec_return(&kvm_tdx->nr_premapped) < 0, kvm);
 
-	if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
-		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
-			err = tdh_mr_extend(&kvm_tdx->td, gpa + i, &entry,
-					    &level_state);
-			if (err) {
-				ret = -EIO;
-				break;
-			}
+	if (!(arg->flags & KVM_TDX_MEASURE_MEMORY_REGION))
+		goto out;
+
+	/*
+	 * Note, MR.EXTEND can fail if the S-EPT mapping is somehow removed
+	 * between mapping the pfn and now, but slots_lock prevents memslot
+	 * updates, filemap_invalidate_lock() prevents guest_memfd updates,
+	 * mmu_notifier events can't reach S-EPT entries, and KVM's internal
+	 * zapping flows are mutually exclusive with S-EPT mappings.
+	 */
+	for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
+		err = tdh_mr_extend(&kvm_tdx->td, gpa + i, &entry, &level_state);
+		if (KVM_BUG_ON(err, kvm)) {
+			pr_tdx_error_2(TDH_MR_EXTEND, err, entry, level_state);
+			ret = -EIO;
+			goto out;
 		}
 	}
 
-- 
2.51.0.318.gd7df087d1a-goog


