Return-Path: <kvm+bounces-27521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20434986A7F
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 03:36:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 490421C21AEC
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 01:36:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42BAF189509;
	Thu, 26 Sep 2024 01:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jdNQFy2N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77BD180021
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 01:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727314523; cv=none; b=JTHqhLSJIhqN6eDO0pyfiw5n5sqySQS5Yq+e9xgTTXKyLthcC738tWZ9qt1JcneUpUBNlCbzkLSDZopRarn7RZU1E9BpzUAlfJN7WaPk1HR30Cl02mSRSSx3XB/REoYekQZPD81GVE+9j0dWUSS3hIsyMErwPTk1szxOoHOCS0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727314523; c=relaxed/simple;
	bh=MSP16v22spRDZgdygkuPyo99YM6MsaYwZUFeeUwYgi0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=alGgkjuovq/EZhG+RqwtQ6MlKxbD/qUtemZmcZuEejdYcO13I2+plJ9LW38zMejBMoE30wMUgfuhgUAXe15+JAmNOLvzZiyPo2f0OLjYNgPDBTdOXGDLqqQm5fCxIhneFEipX6KPZEMD6ohkr8KOoeV19XrKWuZJXvfbAa4O2ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jdNQFy2N; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-690404fd230so9149297b3.3
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 18:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727314521; x=1727919321; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dAogBQT7i8/Ut4GrJolXC+/DUS73zZR+MbirDcTLTRg=;
        b=jdNQFy2NwTQ/OEl/hYfrxySWsR8l5S0fLcHy36u1gHEPeSSqeOIURi7gCyXgLwvZpc
         AQO1EgdhVH3Wyclw+tAf6dHCbiRyIfIkv8PSQUMww8F7cTGmOPQrYag7f3ktOutu/fG9
         Ka5UoTl5Ll9GXwft750H3YchpS0SzknkFW/yX71291unvDA/ifaiGSfi03T7dFhYlg7l
         6ydSFpeOKNqgE6lsec/GLG7e9oKL2XPyGQ+vPRpZErDtqYk6GWnjSAEUVgoCnnejuHm6
         D3Y9FWxHPs9CFnd7czVolKBHWenxIu/YR/fBx+Nn8dSyp8HrqhX34PgGc8fcyvzLphHZ
         L/dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727314521; x=1727919321;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dAogBQT7i8/Ut4GrJolXC+/DUS73zZR+MbirDcTLTRg=;
        b=vhEj4P6yxiSpjXrm95K9qbwiZd2AdS94AgG19+wH9zIn5R/zlX7rrEcDypnKYf2908
         Ws1XvyIVXaGII7mdAE7Jib4Pg7yxtFrgCpqUMIIeDrZ2i1DSBK1tZRNxb4FND6BKhO2v
         UZ4sJQHeZ/E0mS/66Mc6xnizi4Atjn/P4rHlVwbuSPSJZGEv7G0bpYZh7WI52iSLz0ZB
         7woHgxIp8bENh/aNFMZT6duNsgz3lR57/tI1PQL/GpWy88CSdvPSSd6CBCoi3pVYnuhw
         dibxPK+RtHA1BC3O16UGwWDCChlfDq2EJucZbewJ72xkpZMTzqrOT5Rq2Cs3IQ7GQ+Ek
         jpbw==
X-Forwarded-Encrypted: i=1; AJvYcCWCZfyFIFUESXTUEOorGj0lct1gYmWlYa+GbLBU53dCPiLBEulzPDz4Aqk2Mm/xz0GjeM0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxW21GgOEEQFH2JiAp6TqctFoxP5BsFKeQdeOKvDjKal/b6bJCF
	WXlqRB3F7fJz3fIcraQ2wyoD7V5uEYwYKyvksqYgNNtn83FTp3m8kLbRwL2DyDstMdCbqVUjE3a
	szoY9JJMG5s++tPIJAw==
X-Google-Smtp-Source: AGHT+IFQs3DNBWoE9LT9ciS2x6yC/841ISG2URP+wJo+4FsamoM+oSoqTqpMkGycanRDnHNwxgVEwB1O11ztgMfN
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:13d:fb22:ac12:a84b])
 (user=jthoughton job=sendgmr) by 2002:a05:6902:1782:b0:e11:7a38:8883 with
 SMTP id 3f1490d57ef6-e24d9613a90mr3400276.7.1727314520739; Wed, 25 Sep 2024
 18:35:20 -0700 (PDT)
Date: Thu, 26 Sep 2024 01:34:53 +0000
In-Reply-To: <20240926013506.860253-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240926013506.860253-1-jthoughton@google.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
Message-ID: <20240926013506.860253-6-jthoughton@google.com>
Subject: [PATCH v7 05/18] KVM: x86/mmu: Rearrange kvm_{test_,}age_gfn
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

Reorder the TDP MMU check to be first for both kvm_test_age_gfn and
kvm_age_gfn. For kvm_test_age_gfn, this allows us to completely avoid
needing to grab the MMU lock when the TDP MMU reports that the page is
young. Do the same for kvm_age_gfn merely for consistency.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 355a66c26517..03df592284ac 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1649,15 +1649,15 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
 
+	if (tdp_mmu_enabled)
+		young = kvm_tdp_mmu_age_gfn_range(kvm, range);
+
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
-		young = kvm_rmap_age_gfn_range(kvm, range, false);
+		young |= kvm_rmap_age_gfn_range(kvm, range, false);
 		write_unlock(&kvm->mmu_lock);
 	}
 
-	if (tdp_mmu_enabled)
-		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
-
 	return young;
 }
 
@@ -1665,15 +1665,15 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
 
-	if (kvm_memslots_have_rmaps(kvm)) {
+	if (tdp_mmu_enabled)
+		young = kvm_tdp_mmu_test_age_gfn(kvm, range);
+
+	if (!young && kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
-		young = kvm_rmap_age_gfn_range(kvm, range, true);
+		young |= kvm_rmap_age_gfn_range(kvm, range, true);
 		write_unlock(&kvm->mmu_lock);
 	}
 
-	if (tdp_mmu_enabled)
-		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
-
 	return young;
 }
 
-- 
2.46.0.792.g87dc391469-goog


