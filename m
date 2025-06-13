Return-Path: <kvm+bounces-49519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 736D2AD9631
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 22:24:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEBA43BA370
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 20:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8164225B301;
	Fri, 13 Jun 2025 20:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IKnkoOsR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f201.google.com (mail-vk1-f201.google.com [209.85.221.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD21F252903
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 20:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749846203; cv=none; b=OWtv+nabZAlqCAaPnHNxiWOW9vCyiV3QwEDzFemzttxTyb1Vsh527YL+feBxoE3fdTDzHBIO3rZ06ku/3e3/g8nGCtcNtlf7WvowkdXEuY1ydbEG5oV0EwBTm+IJSlms9850J9WnxB562BUr4Yzh+shQsNo6y+A9LZZi+MPeCW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749846203; c=relaxed/simple;
	bh=FO11FlBpcoyN0qJCLIRan7Jv37YU92XK6pL5bj0fOKs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z35pOwDdreYXwCLGgkef1EdhWYhQqUT97MV+humhLGtvibQy0lPjRfDMKkSxjmGVXMVtgu9JMuVhJeZS8gWlEDv+aCUWkg820cKxklB6weJJvUkEUICdJVPlbLKfNMDeCB2FVxsXduwIsfQHYZDwzFh6MdrnR8lCjKLJPqlJRPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IKnkoOsR; arc=none smtp.client-ip=209.85.221.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vk1-f201.google.com with SMTP id 71dfb90a1353d-52f3b7d4f38so1956489e0c.3
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 13:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749846201; x=1750451001; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tns2KslAWsQR/nPQ6ZJXfp49qOYXLA43OUirDZfOqnE=;
        b=IKnkoOsRW6EMTN6YX7I1JSmTbe0FRtYlOe9986lS/NopW5YO82wU+yfQCI1ZV4uDmZ
         LeCeJc8tSzXCjT6PKrK3WLTwUelJIaUR9I5AYugc0dwY6eZcPkMDG5YR4VEZ3sDzM0kI
         nlAYvifP5aIamgt1lTCY8qVpj6EPDCUTpQaXBkPDog4+jk4bMy+LVg9N+Fl2Hg6+inzK
         BWTht2kVqGdWtctanaXGa1juITOWQWMXwe2j1eGCIDzrBn2yhJMV/WdIGERC3/KmjGRE
         7X0d9wKKcGEut+Uy8GzsNQ7eCMZO7Fyw2mqzaM0mbxwGutCljeyx3zsXUa3afGcSQfiJ
         fGtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749846201; x=1750451001;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tns2KslAWsQR/nPQ6ZJXfp49qOYXLA43OUirDZfOqnE=;
        b=cMc7lRDcUePmdpjhmxefdMnU7g3ZO/kD59XSEbtTRNhSp4IO5f4EWT2BMoVsoEvkQi
         CiG6khcDXUyKocmhhc3f8hW4H3hD1w9j6SW2wuuk7vFjJFrKYzr9ycXSuyGL8LUkizvr
         n3PX/h5iGXE9xxVhq1CzZME4wIPmIXd181Ca0RRA0JooVU1Xqly2/UP8YB3bz4GERq0X
         nROrYovITKmETkyq8tC8QthsyzlUYXOA/vz37gRj+NumlZUkTLIphYPsfmLsDY90XPx7
         QmadEMUGmD2Dpx/DF7Y/NMpgXGn3W1sLPwHI1/UYqUtQ6rxEGRl7gL7xcTXrsYlqzjvx
         n9tQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3aeD9uciVm7h1IDKwjs049DGycF700KGtUc6+mFfculzaV7cnzXTai+hIPRXrNoksS1Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBMykVOCaG1yyaos0q+7CB97yvUYknqqulkAq7b5IIX8W57MOl
	Wnw9ixM1LjjLrhwW1NQsMytHbBHV0tafV9tluLMhNYWXuA3sizc4Rr/Cycnw7mICd+NkRltC6AF
	1Av95le8SDQASEwdxF3simA==
X-Google-Smtp-Source: AGHT+IE2AQx+r5mFnTFXsLCm8eJaB2E2MRY6faMF06zh29GE98yh28la0+/4aThtedtzqMsKaDbt81D+v6hsHfy2
X-Received: from vkbfs14.prod.google.com ([2002:a05:6122:3b8e:b0:52f:ecd3:a2fe])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6122:2789:b0:526:2210:5b68 with SMTP id 71dfb90a1353d-531494ba560mr1299111e0c.4.1749846200807;
 Fri, 13 Jun 2025 13:23:20 -0700 (PDT)
Date: Fri, 13 Jun 2025 20:23:11 +0000
In-Reply-To: <20250613202315.2790592-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250613202315.2790592-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
Message-ID: <20250613202315.2790592-5-jthoughton@google.com>
Subject: [PATCH v4 4/7] KVM: x86/mmu: Only grab RCU lock for nx hugepage
 recovery for TDP MMU
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Vipin Sharma <vipinsh@google.com>, David Matlack <dmatlack@google.com>, 
	James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Now that we have separate paths for the TDP MMU, it is trivial to only
grab rcu_read_lock() for the TDP MMU case. We do not need to grab it
for the shadow MMU, as pages are not RCU-freed in that case.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 10ba328b664d7..51df92973d574 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7577,17 +7577,18 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm,
 	nx_huge_pages = &kvm->arch.possible_nx_huge_pages[mmu_type].pages;
 
 	rcu_idx = srcu_read_lock(&kvm->srcu);
-	if (is_tdp)
+	if (is_tdp) {
 		read_lock(&kvm->mmu_lock);
-	else
+		/*
+		 * Zapping TDP MMU shadow pages, including the remote TLB flush,
+		 * must be done under RCU protection, because the pages are
+		 * freed via RCU callback.
+		 */
+		rcu_read_lock();
+	} else {
 		write_lock(&kvm->mmu_lock);
+	}
 
-	/*
-	 * Zapping TDP MMU shadow pages, including the remote TLB flush, must
-	 * be done under RCU protection, because the pages are freed via RCU
-	 * callback.
-	 */
-	rcu_read_lock();
 
 	for ( ; to_zap; --to_zap) {
 		if (is_tdp)
@@ -7635,25 +7636,26 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm,
 
 		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
 			kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
-			rcu_read_unlock();
 
-			if (is_tdp)
+			if (is_tdp) {
+				rcu_read_unlock();
 				cond_resched_rwlock_read(&kvm->mmu_lock);
-			else
+				rcu_read_lock();
+			} else {
 				cond_resched_rwlock_write(&kvm->mmu_lock);
+			}
 
 			flush = false;
-			rcu_read_lock();
 		}
 	}
 	kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
 
-	rcu_read_unlock();
-
-	if (is_tdp)
+	if (is_tdp) {
+		rcu_read_unlock();
 		read_unlock(&kvm->mmu_lock);
-	else
+	} else {
 		write_unlock(&kvm->mmu_lock);
+	}
 	srcu_read_unlock(&kvm->srcu, rcu_idx);
 }
 
-- 
2.50.0.rc2.692.g299adb8693-goog


