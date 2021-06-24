Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B936B3B3565
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 20:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbhFXSQX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 14:16:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37721 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232533AbhFXSQV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 14:16:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624558442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qCTE+G8btEQabyXMZ8pmtQF1JICGOfEU2RElhMZ1+8k=;
        b=awq9vvNm6mB561KjdmbgR0hB3ZIFFYbIvwXxMZeRPtq5WjYwPF3+L5AbOZ6vzqBtJjHn1b
        ac/9psa7oSMG2JRodv+6tO7PELIShOi5DxDkTtiPuohDoClOS9WTHF75zl+aFRjxCbzjKB
        mI3Ok9F/RcE+kLcYwIn/V0hxEPeBLXY=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-djXlzPYGPkSRDTOvKZnZCA-1; Thu, 24 Jun 2021 14:14:01 -0400
X-MC-Unique: djXlzPYGPkSRDTOvKZnZCA-1
Received: by mail-qv1-f71.google.com with SMTP id q10-20020a056214018ab029027751ec9742so7910488qvr.7
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 11:14:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qCTE+G8btEQabyXMZ8pmtQF1JICGOfEU2RElhMZ1+8k=;
        b=M3OEmhjRkqjl81BMn8QYkHcIPgN/FDuuh/0X2IzcbJ2fX2ym7NJcL1z6/IzkzD5pW0
         2e8YuuRYE2cpLq2qheck95s2SyRasnTByrNFT1lA86y5SUzYWTiiEhcvgkWoC2dbJVXl
         LxMD2CANzrcN4axAiPrVyvklfp8GoFQtYNFRZy+oskjFHDrj2h5uvOzPkGBWRRkJRVbF
         6e9ms2gFRDSl91RAv+w21lujAmnv5s0pufVmXuWynW4eOtlJipV7BtCdB5XuWqww4xx2
         TE5sUXADQyhUbicnJcwjdKtSBZmzhJn+rUgK1xFAGEHCxImv6lsWp1S6mhRj4yNCzX4i
         2wZA==
X-Gm-Message-State: AOAM532FpCxRVWcz81GJwdRYiPwesuaOvWDmLhc7yOvHQvZB3lcSLts4
        1c42HII+YIYjirVOJRBiqE3osHqv6skthR5omIGBoGfWCQwN2oo9VfJxkGHy08A0zoVE+4tCkOJ
        ua3PZWUTKUaJW5SndRuZgoScrxy22yhT/Xonp7m0Um9SMVP9JPjKcp5cCJT/Nug==
X-Received: by 2002:a05:620a:484:: with SMTP id 4mr6994638qkr.437.1624558440054;
        Thu, 24 Jun 2021 11:14:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0LKAndulLpSV+fntL9ldHDDtswfF5CXYy8ioMeUBK1qfG/kGRqlgzLDVV9hZuBaru2K3QPw==
X-Received: by 2002:a05:620a:484:: with SMTP id 4mr6994614qkr.437.1624558439818;
        Thu, 24 Jun 2021 11:13:59 -0700 (PDT)
Received: from t490s.redhat.com (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id b7sm2529301qti.21.2021.06.24.11.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 11:13:59 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, peterx@redhat.com,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 1/9] KVM: X86: Add per-vm stat for max rmap list size
Date:   Thu, 24 Jun 2021 14:13:48 -0400
Message-Id: <20210624181356.10235-2-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210624181356.10235-1-peterx@redhat.com>
References: <20210624181356.10235-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new statistic max_mmu_rmap_size, which stores the maximum size of rmap
for the vm.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/mmu/mmu.c          | 2 ++
 arch/x86/kvm/x86.c              | 1 +
 3 files changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 55efbacfc244..937bc8021f7a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1138,6 +1138,7 @@ struct kvm_vm_stat {
 	ulong lpages;
 	ulong nx_lpage_splits;
 	ulong max_mmu_page_hash_collisions;
+	ulong max_mmu_rmap_size;
 };
 
 struct kvm_vcpu_stat {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5e60b00e8e50..6dd338738118 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2602,6 +2602,8 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if (is_shadow_present_pte(*sptep)) {
 		if (!was_rmapped) {
 			rmap_count = rmap_add(vcpu, sptep, gfn);
+			if (rmap_count > vcpu->kvm->stat.max_mmu_rmap_size)
+				vcpu->kvm->stat.max_mmu_rmap_size = rmap_count;
 			if (rmap_count > RMAP_RECYCLE_THRESHOLD)
 				rmap_recycle(vcpu, sptep, gfn);
 		}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bbc4e04e67ad..4aa3cc6ae5d4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -257,6 +257,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VM_STAT("largepages", lpages, .mode = 0444),
 	VM_STAT("nx_largepages_splitted", nx_lpage_splits, .mode = 0444),
 	VM_STAT("max_mmu_page_hash_collisions", max_mmu_page_hash_collisions),
+	VM_STAT("max_mmu_rmap_size", max_mmu_rmap_size),
 	{ NULL }
 };
 
-- 
2.31.1

