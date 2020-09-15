Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CABC26B291
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 00:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbgIOWtq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 18:49:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35769 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727463AbgIOPns (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Sep 2020 11:43:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600184618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dBKCOd9+T+S8SI4cU/LsZo01CTeAPSMyTVRBmW7srME=;
        b=ibCMuWkT3WldBVmLlv6qJIngthgeuu0EKCPoNjaiBiBk+rK4uOkLz2NniEqY/Vp+/DaIXL
        Zd5CONAaGdLllaP9Y4r4xdrSOhY82TyeXFR8D6lxR+yFrh97WJNw/ncukp52qn7ScBOT/n
        LThLWbP+wlNFss8uPgE1+nwMZW8vM3w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-tQ_kHQi8NGqrYTJRShL3BQ-1; Tue, 15 Sep 2020 11:43:35 -0400
X-MC-Unique: tQ_kHQi8NGqrYTJRShL3BQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 152D71022E19;
        Tue, 15 Sep 2020 15:43:16 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C543D19C4F;
        Tue, 15 Sep 2020 15:43:13 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Wei Huang <whuang2@amd.com>, linux-kernel@vger.kernel.org
Subject: [PATCH RFC 2/2] KVM: x86: bump KVM_MAX_CPUID_ENTRIES
Date:   Tue, 15 Sep 2020 17:43:06 +0200
Message-Id: <20200915154306.724953-3-vkuznets@redhat.com>
In-Reply-To: <20200915154306.724953-1-vkuznets@redhat.com>
References: <20200915154306.724953-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As vcpu->arch.cpuid_entries is now allocated dynamically, the only
remaining use for KVM_MAX_CPUID_ENTRIES is to check KVM_SET_CPUID/
KVM_SET_CPUID2 input for sanity. Since it was reported that the
current limit (80) is insufficient for some CPUs, bump
KVM_MAX_CPUID_ENTRIES and use an arbitrary value '256' as the new
limit.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0c5f2ca3e838..c1d942c9eb58 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -132,7 +132,7 @@ static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
 #define KVM_NUM_MMU_PAGES (1 << KVM_MMU_HASH_SHIFT)
 #define KVM_MIN_FREE_MMU_PAGES 5
 #define KVM_REFILL_PAGES 25
-#define KVM_MAX_CPUID_ENTRIES 80
+#define KVM_MAX_CPUID_ENTRIES 256
 #define KVM_NR_FIXED_MTRR_REGION 88
 #define KVM_NR_VAR_MTRR 8
 
-- 
2.25.4

