Return-Path: <kvm+bounces-8506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAAEC84FFF1
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 23:30:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCFEA1C23ACC
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 22:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBC0639AC7;
	Fri,  9 Feb 2024 22:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4rSD36P0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C57438DF8
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 22:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707517749; cv=none; b=fN++0R9f9xZRaSgDyCya5wYtna1z5QSVYlPnqIX/P6IG391yqTJHpFExqKag8n3BXmu7v1FNIhhCkN9SL65VL6CZ3zIisv1F0QvyNjwGxNZ9vGtULyUX22y6g40rTDmFiWmzvqTpjLwe/8vgui5TzuJnyRljWFHxLYS4FbI3Ims=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707517749; c=relaxed/simple;
	bh=MzdZYOJ8bcmLxbBzxayTEgk/rh3FciY0A5qDjUGjyCw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ntacnGQiG1ekRnE3tf3O3EuNeIe2Xth6isdswpLtDLHWcAxWvc+sbv0PQlDvC/6Ok0ODH5faNl1GfUVptgiB5/IpjwhRW5hUOXYTJUketMjSgZHSPWV4HAzhC/p4KmsZXqYFgoUby2Xz57srYGvkWujcDTqYZD/oIo1kjfS0++Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4rSD36P0; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-604832bcbd0so33332147b3.0
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 14:29:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707517746; x=1708122546; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=a9w16DkYUKNtIq1BB7P1j7ef4bijSTE+8L2OPdx5r88=;
        b=4rSD36P0XAQFuAK/Nms2+vP/iKlh4jKw3co2K416l19tvRWVQfYeGHrwdHSTAhdK+V
         vGF9bF9x4tJqT2Fs/aqmNcVD0wXXTcDxm7laxOjZP7vNf3K/+EY/1JkAS/hEG8k2RgLa
         JHCZ9zLtIv7REH4uXprpSVNI0BoLlo6WxA/tQ7XEqSbQBBC7cyPybdbbWUkck9TiZv44
         h8Fz5VxXWXB4n9XVi+0mnMNelaXL/z2HNk60TcvyrGScblw4s2uLylza8BBd93AKCTQE
         4W/livcJRfn51On7TIWf2oyfMuCVPC6MIL7oUlONZAuCYCp+UsGJ3+qwPSTJ7NV+LLVy
         abhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707517746; x=1708122546;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a9w16DkYUKNtIq1BB7P1j7ef4bijSTE+8L2OPdx5r88=;
        b=FSXZqQi1zmlnOz4Z2MjxWXMGvbw+mNxfvhu3/01Jz6//MJgDZbcmBhHGfS8938JfnK
         lRSAecRqwSv3IHopUl5FTD9Mqmq+s8Dyt9cYsrooSpgnpmRp/atZ1gwAYmwNtsuT7kHK
         TUG86gRGrSqXsoLJL+0F1eCf2VQ8VR0DeEgwrxpPSUYgQBvc2x/ClcRICqAHhm3QjqJ3
         iRWIz3t78V4kfYFE8csxLaFIj5sy1trI5OpYnRl8hpigzqhMhvRzWE+e7xqt17SUs/bA
         +DtazqV8IeYHF7O7pKj/TC2plon8rvFLymVV1iYPnUhP6sLHMzlKh4THIZgI0D+L464H
         u/0g==
X-Gm-Message-State: AOJu0YzoMwT/M/OjwkVZefNV47nqtpSppLtCI4G7T+rkZ1CJmIDeQOgN
	MLmYG27Ub55krNL/BqxSxD2ihXZmu71GaRYU5dPlkrt4VNyAbveqLXAf1U0ahXIuc16ZYWYyp5s
	dJA==
X-Google-Smtp-Source: AGHT+IGt9DDAWDOXh5rWqR7Wdjp1ZBHAe0u2NWCLrJsGzRUa6H3IIUWBVD5SKU6jmY1bLJzmP6LW2pBAIEA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:ec9:b0:604:648:6dc0 with SMTP id
 cs9-20020a05690c0ec900b0060406486dc0mr161009ywb.10.1707517746491; Fri, 09 Feb
 2024 14:29:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Feb 2024 14:28:57 -0800
In-Reply-To: <20240209222858.396696-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240209222858.396696-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <20240209222858.396696-4-seanjc@google.com>
Subject: [PATCH v4 3/4] KVM: x86/mmu: Move slot checks from
 __kvm_faultin_pfn() to kvm_faultin_pfn()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Friedrich Weber <f.weber@proxmox.com>, 
	Kai Huang <kai.huang@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>, 
	Xu Yilun <yilun.xu@linux.intel.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	Michael Roth <michael.roth@amd.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Move the checks related to the validity of an access to a memslot from the
inner __kvm_faultin_pfn() to its sole caller, kvm_faultin_pfn().  This
allows emulating accesses to the APIC access page, which don't need to
resolve a pfn, even if there is a relevant in-progress mmu_notifier
invalidation.  Ditto for accesses to KVM internal memslots from L2, which
KVM also treats as emulated MMIO.

More importantly, this will allow for future cleanup by having the
"no memslot" case bail from kvm_faultin_pfn() very early on.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 62 ++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 50bfaa53f3f2..505fc7eef533 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4333,33 +4333,6 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	struct kvm_memory_slot *slot = fault->slot;
 	bool async;
 
-	/*
-	 * Retry the page fault if the gfn hit a memslot that is being deleted
-	 * or moved.  This ensures any existing SPTEs for the old memslot will
-	 * be zapped before KVM inserts a new MMIO SPTE for the gfn.
-	 */
-	if (slot && (slot->flags & KVM_MEMSLOT_INVALID))
-		return RET_PF_RETRY;
-
-	if (!kvm_is_visible_memslot(slot)) {
-		/* Don't expose private memslots to L2. */
-		if (is_guest_mode(vcpu)) {
-			fault->slot = NULL;
-			fault->pfn = KVM_PFN_NOSLOT;
-			fault->map_writable = false;
-			return RET_PF_CONTINUE;
-		}
-		/*
-		 * If the APIC access page exists but is disabled, go directly
-		 * to emulation without caching the MMIO access or creating a
-		 * MMIO SPTE.  That way the cache doesn't need to be purged
-		 * when the AVIC is re-enabled.
-		 */
-		if (slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT &&
-		    !kvm_apicv_activated(vcpu->kvm))
-			return RET_PF_EMULATE;
-	}
-
 	if (fault->is_private)
 		return kvm_faultin_pfn_private(vcpu, fault);
 
@@ -4406,6 +4379,37 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	smp_rmb();
 
+	if (!slot)
+		goto faultin_pfn;
+
+	/*
+	 * Retry the page fault if the gfn hit a memslot that is being deleted
+	 * or moved.  This ensures any existing SPTEs for the old memslot will
+	 * be zapped before KVM inserts a new MMIO SPTE for the gfn.
+	 */
+	if (slot->flags & KVM_MEMSLOT_INVALID)
+		return RET_PF_RETRY;
+
+	if (!kvm_is_visible_memslot(slot)) {
+		/* Don't expose KVM's internal memslots to L2. */
+		if (is_guest_mode(vcpu)) {
+			fault->slot = NULL;
+			fault->pfn = KVM_PFN_NOSLOT;
+			fault->map_writable = false;
+			return RET_PF_CONTINUE;
+		}
+
+		/*
+		 * If the APIC access page exists but is disabled, go directly
+		 * to emulation without caching the MMIO access or creating a
+		 * MMIO SPTE.  That way the cache doesn't need to be purged
+		 * when the AVIC is re-enabled.
+		 */
+		if (slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT &&
+		    !kvm_apicv_activated(vcpu->kvm))
+			return RET_PF_EMULATE;
+	}
+
 	/*
 	 * Check for a relevant mmu_notifier invalidation event before getting
 	 * the pfn from the primary MMU, and before acquiring mmu_lock.
@@ -4427,10 +4431,10 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	 * *guaranteed* to need to retry, i.e. waiting until mmu_lock is held
 	 * to detect retry guarantees the worst case latency for the vCPU.
 	 */
-	if (!slot &&
-	    mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn))
+	if (mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn))
 		return RET_PF_RETRY;
 
+faultin_pfn:
 	ret = __kvm_faultin_pfn(vcpu, fault);
 	if (ret != RET_PF_CONTINUE)
 		return ret;
-- 
2.43.0.687.g38aa6559b0-goog


