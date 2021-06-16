Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D823AA06F
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 17:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235518AbhFPP5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 11:57:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30322 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234754AbhFPPxb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Jun 2021 11:53:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623858679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Qd1Zh0zHMPKxeDxDRV+UTGvygr4iY6Q7mRYXQ+zyWWE=;
        b=InnjbCPQP8lEzhBeycjDaHFIoPukxBPV3X3kYDyf1s2AMP0T7gZEd0Jc3KnXqsGGYO5ClR
        Ej5sBsFzEY2G1764AoHzcUDv0j3vnjwwAf6lHtrlEgqCd/za5/XRh6Wj49JzdJMf9JMnUg
        DFTFMbywItJrwCjYAHNECLqK269wYSM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-8t83nTQoN7SIoMNN5VuXkw-1; Wed, 16 Jun 2021 11:50:43 -0400
X-MC-Unique: 8t83nTQoN7SIoMNN5VuXkw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A88A236260;
        Wed, 16 Jun 2021 15:50:41 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C20D60C03;
        Wed, 16 Jun 2021 15:50:33 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH] KVM: x86: fix 32 bit build
Date:   Wed, 16 Jun 2021 18:50:32 +0300
Message-Id: <20210616155032.1117176-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that kvm->stat.nx_lpage_splits is 64 bit, use DIV_ROUND_UP_ULL
when doing division.

Fixes: 7ee093d4f3f5 ("KVM: switch per-VM stats to u64")
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 720ceb0a1f5c..97372225f183 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6054,7 +6054,7 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 	write_lock(&kvm->mmu_lock);
 
 	ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
-	to_zap = ratio ? DIV_ROUND_UP(kvm->stat.nx_lpage_splits, ratio) : 0;
+	to_zap = ratio ? DIV_ROUND_UP_ULL(kvm->stat.nx_lpage_splits, ratio) : 0;
 	for ( ; to_zap; --to_zap) {
 		if (list_empty(&kvm->arch.lpage_disallowed_mmu_pages))
 			break;
-- 
2.26.3

