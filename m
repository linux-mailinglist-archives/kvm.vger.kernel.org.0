Return-Path: <kvm+bounces-11947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B07987D726
	for <lists+kvm@lfdr.de>; Sat, 16 Mar 2024 00:06:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E371B1F22CBB
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 23:06:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E22805B20E;
	Fri, 15 Mar 2024 23:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ciUrS3yi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851F05A0F2
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 23:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710543953; cv=none; b=Puq4e8A/qp2n8cS9ph4/lJjxNXIcHVftu+FAm9OrYoVmApfnLXnjX4Ot+GaW1pi8RI1+BJeizXaQy0HT0OB77Hnj194h0YU9dBAxht2w77j7bJM58VZ++hbuaQ9gd4GhCbNQakDDL+rEikAhMGsTZfeZypclHBYbWZGQLuYWTkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710543953; c=relaxed/simple;
	bh=zALevsy+o6WoiT50ZSSg7EyHQ/7hii1b9a2RndIfQqY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nmqdzV73Zt8Upl4lvuEKwqbVJzFKxcM3hns/cjop6eNSYiZRsfMekHgOBwg72VfJ7NRdZV3zSjNXT+ze+sZIbXYwNsmONyTSAPeup1VyuQLa3Myvgh/wI4J2tF0P2G50V+oqueOhNCz0e6YCfJEegdhuQK5FnuZQ5VOf096Z0cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ciUrS3yi; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60cd073522cso40409527b3.1
        for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 16:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710543950; x=1711148750; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5v7s3VCD/BPCCGhMCnWgAFl+8Ao/7l2vN01DQs4HrL0=;
        b=ciUrS3yipLiNdiP791VLtUhjcRLI2sIwMoZQc/B+0uDDSET7ZQeoGNwG5NZrSX14/C
         w0yBvhCzD8qnVlTGVqP5+UO4v+TxXQhOcCTuSncCVzFKam3oLdtDkw/vmQhn1GkJYf/r
         WLobSEAz1UtnJQNswdaLWDaZNolkGEnBIFG3311QkdGh8khvCn2PZBlL4+iTJA9/Ns3G
         ppWSgUx/qdXl4IGasPp0UuhuMDiyVqO6fKYecIjWTpf6lrhLG5WdDbftwvCp06MjGTIY
         Psi9ftaNr2rj99kOnOldJNWCMxn9axy2OhabDYfMy1XYOW0boVXXYnE3pTniqfvxcsAd
         tojQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710543950; x=1711148750;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5v7s3VCD/BPCCGhMCnWgAFl+8Ao/7l2vN01DQs4HrL0=;
        b=MYHlQYYuruoBx3Kh9Sts0wT0MLye7z56JkRdoPI7KqW8grz4WRiVpHWzDz6K8wvDNu
         tS42+Htx4e6fg0wskEwgKM3W7qJ/WwE8Tf7t7woZ8Y9gixuMZM2L5liJpwq62Ji98ewD
         dsTynMSUiGZV4FDIa8li0HXwxc7czNC3gDX9Vfkq1XjOSaLBjc5mnQ8cHtULmYVct9+5
         VBcKtez56GpULiP+CVeTN4xvu4eMEtbRdk3Xv8UkrFOr3PUZ87xOLE1opFtB1tvsB2Dd
         fn4qUzalscy7+v0UvIGT95orza3Hw48zmO8akoO0o8687h7B+5ezHDu4D59WLYAG6qGq
         2jJA==
X-Forwarded-Encrypted: i=1; AJvYcCUwieekwxy9i3ixy4XGlzEHUqU1agLFYoqHewD2kbgk9VdCFdfn/cwMqC+2i9Ks+oHFot/SggcRwi5EhxAWRZ9/hLSf
X-Gm-Message-State: AOJu0Yx2DtlZ6wmvrLuQneng1DmAO5bJLe2i3Zr7RWvHCb9aWK92wiqe
	42w7V6dOy2UEZZ2vbyVVMeRrwNSa6P76gXEyFutLzWjhjdSewAVQ1mbEd1WIYy/UVuO3Bw6hTp0
	oK8gMshvj7Q==
X-Google-Smtp-Source: AGHT+IFntGQygsjXJXgkdvTYDs+81NQOnpgf6NpmaludXdFIGLiDkz0yYncTNz80iNi3n4Q4ghI/ivLkql7Dhw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:690c:6d09:b0:60f:c5ef:f6b7 with SMTP
 id iv9-20020a05690c6d0900b0060fc5eff6b7mr637180ywb.9.1710543950699; Fri, 15
 Mar 2024 16:05:50 -0700 (PDT)
Date: Fri, 15 Mar 2024 16:05:40 -0700
In-Reply-To: <20240315230541.1635322-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240315230541.1635322-1-dmatlack@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240315230541.1635322-4-dmatlack@google.com>
Subject: [PATCH 3/4] KVM: x86/mmu: Fix and clarify comments about clearing
 D-bit vs. write-protecting
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop the "If AD bits are enabled/disabled" verbiage from the comments
above kvm_tdp_mmu_clear_dirty_{slot,pt_masked}() since TDP MMU SPTEs may
need to be write-protected even when A/D bits are enabled. i.e. These
comments aren't technically correct.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 01192ac760f1..1e9b48b5f6e1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1544,11 +1544,9 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 }
 
 /*
- * Clear the dirty status of all the SPTEs mapping GFNs in the memslot. If
- * AD bits are enabled, this will involve clearing the dirty bit on each SPTE.
- * If AD bits are not enabled, this will require clearing the writable bit on
- * each SPTE. Returns true if an SPTE has been changed and the TLBs need to
- * be flushed.
+ * Clear the dirty status (D-bit or W-bit) of all the SPTEs mapping GFNs in the
+ * memslot. Returns true if an SPTE has been changed and the TLBs need to be
+ * flushed.
  */
 bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm,
 				  const struct kvm_memory_slot *slot)
@@ -1606,11 +1604,9 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 }
 
 /*
- * Clears the dirty status of all the 4k SPTEs mapping GFNs for which a bit is
- * set in mask, starting at gfn. The given memslot is expected to contain all
- * the GFNs represented by set bits in the mask. If AD bits are enabled,
- * clearing the dirty status will involve clearing the dirty bit on each SPTE
- * or, if AD bits are not enabled, clearing the writable bit on each SPTE.
+ * Clears the dirty status (D-bit or W-bit) of all the 4k SPTEs mapping GFNs for
+ * which a bit is set in mask, starting at gfn. The given memslot is expected to
+ * contain all the GFNs represented by set bits in the mask.
  */
 void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 				       struct kvm_memory_slot *slot,
-- 
2.44.0.291.gc1ea87d7ee-goog


