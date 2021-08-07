Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968AC3E35A6
	for <lists+kvm@lfdr.de>; Sat,  7 Aug 2021 15:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbhHGNuO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Aug 2021 09:50:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35683 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232381AbhHGNuF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 7 Aug 2021 09:50:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628344187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MKhdNFgLFEgMzgHVvkxg3pFKvrJvy7U7lW1Yc3spwLQ=;
        b=eU5ft4Qgpk2g6dSLldCGJGBFRjVuxaAIf2z21MF1XkcWgdl/Z1H+7Ot7dLnx2JoSi1pijQ
        GmUacFhV9pfT6GQ4Gb5mQMf8vRaIoatxJyi/I4hmIGxZuk5bfm28cZEuBDbpsUhXjqdK89
        Ir4sIyJ36zNdqr2a4khYv4C/hO2mRSM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-A8hH60iSNRyRTbgIMNBH7A-1; Sat, 07 Aug 2021 09:49:44 -0400
X-MC-Unique: A8hH60iSNRyRTbgIMNBH7A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BD9C760C4;
        Sat,  7 Aug 2021 13:49:43 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8FFA31700F;
        Sat,  7 Aug 2021 13:49:42 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, David Matlack <dmatlack@google.com>,
        seanjc@google.com, peterx@redhat.com
Subject: [PATCH 02/16] KVM: x86: clamp host mapping level to max_level in kvm_mmu_max_mapping_level
Date:   Sat,  7 Aug 2021 09:49:22 -0400
Message-Id: <20210807134936.3083984-3-pbonzini@redhat.com>
In-Reply-To: <20210807134936.3083984-1-pbonzini@redhat.com>
References: <20210807134936.3083984-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch started as a way to make kvm_mmu_hugepage_adjust a bit simpler,
in preparation for switching it to struct kvm_page_fault, but it does
fix a microscopic bug in zapping collapsible PTEs.

If a large page size is disallowed but not all of them, kvm_mmu_max_mapping_level
will return the host mapping level and the small PTEs will be zapped up
to that level.  However, if e.g. 1GB are prohibited, we can still zap 4KB
mapping and preserve the 2MB ones.  This can happen for example when NX
huge pages are in use.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7477f340d318..5d4de39fe5a9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2868,6 +2868,7 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      kvm_pfn_t pfn, int max_level)
 {
 	struct kvm_lpage_info *linfo;
+	int host_level;
 
 	max_level = min(max_level, max_huge_page_level);
 	for ( ; max_level > PG_LEVEL_4K; max_level--) {
@@ -2879,7 +2880,8 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
-	return host_pfn_mapping_level(kvm, gfn, pfn, slot);
+	host_level = host_pfn_mapping_level(kvm, gfn, pfn, slot);
+	return min(host_level, max_level);
 }
 
 int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
@@ -2903,17 +2905,12 @@ int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 	if (!slot)
 		return PG_LEVEL_4K;
 
-	level = kvm_mmu_max_mapping_level(vcpu->kvm, slot, gfn, pfn, max_level);
-	if (level == PG_LEVEL_4K)
-		return level;
-
-	*req_level = level = min(level, max_level);
-
 	/*
 	 * Enforce the iTLB multihit workaround after capturing the requested
 	 * level, which will be used to do precise, accurate accounting.
 	 */
-	if (huge_page_disallowed)
+	*req_level = level = kvm_mmu_max_mapping_level(vcpu->kvm, slot, gfn, pfn, max_level);
+	if (level == PG_LEVEL_4K || huge_page_disallowed)
 		return PG_LEVEL_4K;
 
 	/*
-- 
2.27.0


