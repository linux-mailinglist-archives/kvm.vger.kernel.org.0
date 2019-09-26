Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFADBFBC7
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbfIZXSi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:18:38 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:47831 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728924AbfIZXSh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:18:37 -0400
Received: by mail-qk1-f201.google.com with SMTP id y189so819729qkb.14
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=u7wms7r+9Uw3K98byh8e1nIf7jClvzwZJK4DCYsuOWs=;
        b=hQMEeARtS7m2tyjEcnwjGolTLGYDGgRW6YGgt4tN9iXnbREIABKj7hSIhoWMmjIEuH
         PKy4DEcpln7oVvUXLRQjcbhSwoBWl8yfjskUWarkRHThN7Nbv/8ZdWWsgbo0xdunUVsg
         EmY13pJ7iQmwfBPt9Cl+qdqtdbjJTA11ToDKlfBryGDbD5Bskq1uqg3lhULNV8fZaTnn
         neCYPUjW0OGVvMtVES97rL6EG43S7XVW2dGlv4jWM+v/EUMk3zbaWfvSFLceJlqjir+y
         SBJYpLhSeCfyk6Dp76tQ36SWSpWnidqEVPllkoM3hK1GASci/gciwGdd7+ryZXE+OpEi
         oQgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=u7wms7r+9Uw3K98byh8e1nIf7jClvzwZJK4DCYsuOWs=;
        b=Ysu3biM/nwR1Hn0nccCdVUi7UTngorO6BKS8mY5thqKeXI8ud8odEFgfi+hjZ7b0ZQ
         YFVV0fEtlYFV05FyFGwCe1xgPx2XbKBPCuWYnJCRCCfX1NJIF+ybLRRvX4PTNiHo4J4/
         BhverEaJatFb1VfCvFAlS19VWUtQZ6wWCDHDvIEZLnxqrI1Mli8KDRX12RjpcYwOkRWd
         HQb5MfOk0CwO31dZ/Ux8VYf1w2ni2mUIqEU5+1ARleW8w/g4NDblhJYIv8vu1dYdlZ+T
         nu0RSWS2tA4vlLlMLqiEnDy2IhMX8Yy/CR3E9AkEuul7e0EZME+HM2JcZUnhPYFf8fxl
         ER7g==
X-Gm-Message-State: APjAAAWDqAL/cuqwmpNl2itWoZ3ubW8ciRhwQIC0HTouzeAcu6iGKzlR
        /NzPM8bThIqeXZTOPoEI6DeKw4gmYDa7nLY5bxGLy2Jqba+HmTNdvWZPNBunvX+xnFDapXfxoRM
        4F/b80k1hvoNztEDwZrrsdQKG3/CxL//ellCAbXfW83OybPIHsV6JOsn4v/wu
X-Google-Smtp-Source: APXvYqzahzWsTxIn7OQmRfL+FE0xiEYyBoRHz2sC7TQTznm0XQTQzLHHr8VhT0ozV28mLEYsbfpRkX5u+I3D
X-Received: by 2002:a0c:b999:: with SMTP id v25mr5361221qvf.80.1569539915106;
 Thu, 26 Sep 2019 16:18:35 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:17:59 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-4-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 03/28] kvm: mmu: Zero page cache memory at allocation time
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Simplify use of the MMU page cache by allocating pages pre-zeroed. This
ensures that future code does not accidentally add non-zeroed memory to
the paging structure and moves the work of zeroing page page out from
under the MMU lock.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 7e5ab9c6e2b09..1ecd6d51c0ee0 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1037,7 +1037,7 @@ static int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache,
 	if (cache->nobjs >= min)
 		return 0;
 	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
-		page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
+		page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 		if (!page)
 			return cache->nobjs >= min ? 0 : -ENOMEM;
 		cache->objects[cache->nobjs++] = page;
@@ -2548,7 +2548,6 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		if (level > PT_PAGE_TABLE_LEVEL && need_sync)
 			flush |= kvm_sync_pages(vcpu, gfn, &invalid_list);
 	}
-	clear_page(sp->spt);
 	trace_kvm_mmu_get_page(sp, true);
 
 	kvm_mmu_flush_or_zap(vcpu, &invalid_list, false, flush);
-- 
2.23.0.444.g18eeb5a265-goog

