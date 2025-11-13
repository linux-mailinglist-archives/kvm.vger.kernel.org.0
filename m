Return-Path: <kvm+bounces-63090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 61269C5A864
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:23:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9EE4B351B04
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:22:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35CDD328277;
	Thu, 13 Nov 2025 23:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YV6YoEIM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AEC326952
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 23:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763076154; cv=none; b=HspmyzXn0tVnmMZ0HBzBYZ9hJH0t/gJCf9wnvgM8hTF3jblF/5sU/qoOlNofHGTLljn2z3U0NX2r3t0WJGPMm6rJxhnUBCG1qUa/UPkRdllGh7sO3onTXqkY/4f/IjQuTAHcHprDjevuavgPpR8BNW1uohcnxRoGuGr5EQpejyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763076154; c=relaxed/simple;
	bh=/VWlZDSuv9naY4NLxRhJm4wQD3LEcTOpEh4w9kEbqqA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=e5ZmY4iIrED5WFFX5UMH/VM5tlnwGnEMOqFlS/Hx3CN7z32fAhB5WOXLPs8F8rFqhOczS8nHrX/HIybiAr4X0DfkJWYXnaZCWve9FG08kYDhXXPikp+rO4Dohy/YV/oCRBc8Y0t9bKjM39TYWifiClCiTF7QqLNUkiZd1vVnNh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YV6YoEIM; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3438744f11bso1860009a91.2
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 15:22:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763076152; x=1763680952; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YqDQKKsD4NlY39DOQRuRFpStN8uevOuecrT0cTsshoA=;
        b=YV6YoEIMLiRoAG/KX/Wd0P0ThgCtsmTpruQb4OglV5BzuCSZv8n0DHNtWES+OJ5M3U
         IBxfF1bntrkzmU1cHA1lLKYyd6eOT9IgmavnB1Lvo+IjJEjhqM83WBz/p82kOIaZYbuf
         G6kR5/Gy9DKyx+98L4KjUrPNkmfHtM7Jjmzipe1pfQ0O1woQHvmmI2UMrtC2KSBZU19i
         NrIAsJL0MA3IfCudKndDLBxCn/p1k6PsAu/iY5s2lte8CAh/qdw2ulokPqxzcsTJD0GY
         yBbavNb1GFfoweNy2xGKR6FgypE6nkfyA+Ypot21BUpwvWiqRdEllQUGaUkMfWepZbZC
         BWDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763076152; x=1763680952;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YqDQKKsD4NlY39DOQRuRFpStN8uevOuecrT0cTsshoA=;
        b=NDlpFJCvQp3epRLbKcSA1H3wa71GhdW31y9rROTXZ21Y38PABPIa5wsXn5DlfPNLQ8
         Z7qkMgJL4e3k3PVawNtas87FqykVkOqcpz6gDI5fM4UIwsXDID5M+tz/vO/uB48wamn4
         8TPme+yhq1NnkxGgkIp5k69zfm6l/RHXXDK+dtKNiwtVa9CtMCqmRJ48yuAaePJ+2KQT
         dZ0+LZyD0YIlclPOmQMeCxpdntElW7F1raH7U09WStWv2yN6nRmZlQmGEtnmvdaeGgeO
         nEMSeNk45WCcdVScjZPBm2rLWuoFI6sIsCcV+0sJvylEfglppvqMAQ1jRH5Uozc1w2At
         1ZQg==
X-Gm-Message-State: AOJu0Yy0Sthlt429hVHQ6KgYJXlUgV0v2gnp47w5HpTZqKORM8O6uZbH
	/5PcktDki6jHSQmD+lvzbQBuO01P0H9UYc+pbXR4AP/wZcQT186R7rprvtUZb3ak8OU0wJNLzoY
	truXVKg==
X-Google-Smtp-Source: AGHT+IFjhnyoh8Yv2pXCQe5QRJjinRO2mbJ02VHtCtEcYlyDToK5jpB3wuTiT1o03A73h+aCsn94qEc9rKI=
X-Received: from pjbha6.prod.google.com ([2002:a17:90a:f3c6:b0:33b:dccb:b328])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e70d:b0:340:be4d:8980
 with SMTP id 98e67ed59e1d1-343f9eb615cmr890278a91.14.1763076152304; Thu, 13
 Nov 2025 15:22:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 15:22:29 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113232229.1698886-1-seanjc@google.com>
Subject: [PATCH] KVM: guest_memfd: Elaborate on how release() vs. get_pfn() is
 safe against UAF
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Add more context and information to the comment in kvm_gmem_release() that
explains why there's no synchronization on RCU _or_ kvm->srcu.  Point (b)
from commit 67b43038ce14 ("KVM: guest_memfd: Remove RCU-protected attribute
from slot->gmem.file")

      b) kvm->srcu ensures that kvm_gmem_unbind() and freeing of a memslot
         occur after the memslot is no longer visible to kvm_gmem_get_pfn().

is especially difficult to fully grok, particularly in light of commit
ae431059e75d ("KVM: guest_memfd: Remove bindings on memslot deletion when
gmem is dying"), which addressed a race between unbind() and release().

No functional change intended.

Cc: Yan Zhao <yan.y.zhao@intel.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/guest_memfd.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index fdaea3422c30..2e09d7ec0cfc 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -338,17 +338,25 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * dereferencing the slot for existing bindings needs to be protected
 	 * against memslot updates, specifically so that unbind doesn't race
 	 * and free the memslot (kvm_gmem_get_file() will return NULL).
-	 *
-	 * Since .release is called only when the reference count is zero,
-	 * after which file_ref_get() and get_file_active() fail,
-	 * kvm_gmem_get_pfn() cannot be using the file concurrently.
-	 * file_ref_put() provides a full barrier, and get_file_active() the
-	 * matching acquire barrier.
 	 */
 	mutex_lock(&kvm->slots_lock);
 
 	filemap_invalidate_lock(inode->i_mapping);
 
+	/*
+	 * Note!  synchronize_srcu() is _not_ needed after nullifying memslot
+	 * bindings as slot->gmem.file cannot be set back to a non-null value
+	 * without the memslot first being deleted.  I.e. this relies on the
+	 * synchronize_srcu_expedited() in kvm_swap_active_memslots() to ensure
+	 * kvm_gmem_get_pfn() (which runs with kvm->srcu held for read) can't
+	 * grab a reference to slot->gmem.file even if the struct file object
+	 * is reallocated.
+	 *
+	 * file_ref_put() provides a full barrier, and __get_file_rcu() the
+	 * matching acquire barrier, to ensure that kvm_gmem_get_file() (via
+	 * __get_file_rcu()) sees refcount==0 or fails the "file reloaded"
+	 * check (file != NULL due to nullifying the file pointer here).
+	 */
 	xa_for_each(&f->bindings, index, slot)
 		WRITE_ONCE(slot->gmem.file, NULL);
 

base-commit: 16ec4fb4ac95d878b879192d280db2baeec43272
-- 
2.52.0.rc1.455.g30608eb744-goog


