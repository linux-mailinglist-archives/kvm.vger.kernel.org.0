Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E573E84B0
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 22:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbhHJUxe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 16:53:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30465 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233887AbhHJUxb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 16:53:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628628788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aLAddfVojiifFo+GvROj0e+TzI2OA7v/Ggomph5ZjKA=;
        b=KYziXZVjsh/CC+0nC1VR6EjKDyz5xbG/QinBBToSa7HM2Al6N1wEk9hzUww59W9L8ak1BI
        67Sc2Wgj6Lahbj6SV1kO4Wbsy2RusMMBW50o5hjmEBy6x+F4dB4lc/LUQQZXbBEh/47jXA
        YbE0n8kz4YIHT8yhoTVWcflAe2uY51s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-iaoaixOFPCi1LYR0r-5lhA-1; Tue, 10 Aug 2021 16:53:07 -0400
X-MC-Unique: iaoaixOFPCi1LYR0r-5lhA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4FEFE100CF6F;
        Tue, 10 Aug 2021 20:53:05 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C80C69CBA;
        Tue, 10 Aug 2021 20:53:01 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v4 02/16] KVM: x86/mmu: fix parameters to kvm_flush_remote_tlbs_with_address
Date:   Tue, 10 Aug 2021 23:52:37 +0300
Message-Id: <20210810205251.424103-3-mlevitsk@redhat.com>
In-Reply-To: <20210810205251.424103-1-mlevitsk@redhat.com>
References: <20210810205251.424103-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_flush_remote_tlbs_with_address expects (start gfn, number of pages),
and not (start gfn, end gfn)

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9e3839971844..3080e25c8a3a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5675,13 +5675,17 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 			}
 		}
 		if (flush)
-			kvm_flush_remote_tlbs_with_address(kvm, gfn_start, gfn_end);
+			kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
+							   gfn_end - gfn_start);
 	}
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
 			flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, gfn_start,
 							  gfn_end, flush);
+		if (flush)
+			kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
+							   gfn_end - gfn_start);
 	}
 
 	if (flush)
-- 
2.26.3

