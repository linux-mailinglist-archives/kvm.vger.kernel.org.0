Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5AE21B7F8
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 16:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgGJOMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 10:12:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40652 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728284AbgGJOMa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 10:12:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594390349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VOceSolOcCnL8nnokzwJbOsFELxGoSPw4yCTbFrccdo=;
        b=OgkSC8/bZB5e3rUGG0hmHQmeqq5nLGMzCV5tCZY131cdB9QwxLT/fDkMM3J5ZebH7Ssglo
        cF1foNbJV+S35QrVz98T0gIroglYvGC9J+O4NWDQD7PnE3lCedTN2jzzs6U5wuZbTKuqcU
        9Re7skjfXY1nli2eogLm7DCwbhSqVJU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-Ur86T0lJPLSe1nDsqltjyA-1; Fri, 10 Jul 2020 10:12:27 -0400
X-MC-Unique: Ur86T0lJPLSe1nDsqltjyA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 569CB1083;
        Fri, 10 Jul 2020 14:12:26 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2992374F52;
        Fri, 10 Jul 2020 14:12:23 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 9/9] KVM: x86: drop superfluous mmu_check_root() from fast_pgd_switch()
Date:   Fri, 10 Jul 2020 16:11:57 +0200
Message-Id: <20200710141157.1640173-10-vkuznets@redhat.com>
In-Reply-To: <20200710141157.1640173-1-vkuznets@redhat.com>
References: <20200710141157.1640173-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The mmu_check_root() check in fast_pgd_switch() seems to be
superfluous: when GPA is outside of the visible range
cached_root_available() will fail for non-direct roots
(as we can't have a matching one on the list) and we don't
seem to care for direct ones.

Also, raising #TF immediately when a non-existent GFN is written to CR3
doesn't seem to mach architectural behavior. Drop the check.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 13ec3c30eda2..50a923696bf1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4277,8 +4277,7 @@ static bool fast_pgd_switch(struct kvm_vcpu *vcpu, gpa_t new_pgd,
 	 */
 	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
 	    mmu->root_level >= PT64_ROOT_4LEVEL)
-		return !mmu_check_root(vcpu, new_pgd >> PAGE_SHIFT) &&
-		       cached_root_available(vcpu, new_pgd, new_role);
+		return cached_root_available(vcpu, new_pgd, new_role);
 
 	return false;
 }
-- 
2.25.4

