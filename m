Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2FE2183ED
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 11:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgGHJgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 05:36:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32837 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726445AbgGHJgZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 05:36:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594200984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oAXL7efwWQ65Jbeb4ZcetX33ECLslAvkcqVWVq+hHRs=;
        b=NeXKN7MVEblnl9FD2dL3szLn93lqjlknbutJP41IZE+E94tCJHODKj09jlpGWAiFjAwLRI
        t5ddysiCoJLKFa0ELCnjtZTRg5iHeCzE5+tnvwXYDAkajocB/I2UQBu5jGbaXt3Gl4qjdE
        zdKD+uwGICRlwTxQ0XF3+HPg97tinSM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-th7ubrwaOKKdO8MRqOJn4A-1; Wed, 08 Jul 2020 05:36:23 -0400
X-MC-Unique: th7ubrwaOKKdO8MRqOJn4A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEC2F107ACCA;
        Wed,  8 Jul 2020 09:36:21 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23D865C1D6;
        Wed,  8 Jul 2020 09:36:19 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] KVM: x86: drop superfluous mmu_check_root() from fast_pgd_switch()
Date:   Wed,  8 Jul 2020 11:36:11 +0200
Message-Id: <20200708093611.1453618-4-vkuznets@redhat.com>
In-Reply-To: <20200708093611.1453618-1-vkuznets@redhat.com>
References: <20200708093611.1453618-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
index ebf0cb3f1ce0..16c7701f1741 100644
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

