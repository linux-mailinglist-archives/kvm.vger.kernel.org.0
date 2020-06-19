Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D9320114E
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 17:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393798AbgFSPjy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 11:39:54 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42445 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2393653AbgFSPjx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 11:39:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592581192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y+5DkcNUxP1bFMVZ/Wx9pVXm5AvA2/umLhzGlXJcybs=;
        b=IRBrjBVEZ84OHM9HrV7fcUQNyb9shUbOllWret5JjvdbY8/SxNHm5u+vp3Z48lbY62JE5M
        tUQwBSj8HRg0dNG/gH3lyo2V+cBxdBomgyuL8sDyXzsEGZatfREImsHc/oTfIxLYmRITE5
        5rlBBGNsACSVIiR73i+8AhVAq0T8kM8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-4gCsF_yDMyyK1HfAJ6MBIA-1; Fri, 19 Jun 2020 11:39:48 -0400
X-MC-Unique: 4gCsF_yDMyyK1HfAJ6MBIA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 034AA10753F2;
        Fri, 19 Jun 2020 15:39:42 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7390760BF4;
        Fri, 19 Jun 2020 15:39:37 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, thomas.lendacky@amd.com,
        babu.moger@amd.com, Mohammed Gamal <mgamal@redhat.com>
Subject: [PATCH v2 02/11] KVM: x86: mmu: Move translate_gpa() to mmu.c
Date:   Fri, 19 Jun 2020 17:39:16 +0200
Message-Id: <20200619153925.79106-3-mgamal@redhat.com>
In-Reply-To: <20200619153925.79106-1-mgamal@redhat.com>
References: <20200619153925.79106-1-mgamal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Also no point of it being inline since it's always called through
function pointers. So remove that.

Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 6 ------
 arch/x86/kvm/mmu/mmu.c          | 6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f8998e97457f..bc0fb116cc5c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1551,12 +1551,6 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd, bool skip_tlb_flush,
 
 void kvm_configure_mmu(bool enable_tdp, int tdp_page_level);
 
-static inline gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
-				  struct x86_exception *exception)
-{
-	return gpa;
-}
-
 static inline struct kvm_mmu_page *page_header(hpa_t shadow_page)
 {
 	struct page *page = pfn_to_page(shadow_page >> PAGE_SHIFT);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fdd05c233308..ee113fc1f1bf 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -515,6 +515,12 @@ static bool check_mmio_spte(struct kvm_vcpu *vcpu, u64 spte)
 	return likely(kvm_gen == spte_gen);
 }
 
+static gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
+                                  struct x86_exception *exception)
+{
+        return gpa;
+}
+
 /*
  * Sets the shadow PTE masks used by the MMU.
  *
-- 
2.26.2

