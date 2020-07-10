Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0A321B9DB
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 17:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgGJPse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 11:48:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27161 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728116AbgGJPsc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 11:48:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594396110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ysp4pgGf28/Rv6t1JVehGYmHl2LaKg10kElk18AGj/A=;
        b=iyzHRZfzrgSIYkzF6zV+yzAVszehIXSwqPSg1Ud37epfLiIm7XS0lajNDhXyl7aREOK0VH
        p5JsECOfRdoLQlLMORaO2Qw3xRkjkziLAw1+F+bN05Q9U+KZd9pIfDcrUAinH0eSQXjgwu
        t6HE4aJCTIDq9VWGVISTSQkNo4BPWFs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-Q3lgybjmN6-wDuq7YU7rBg-1; Fri, 10 Jul 2020 11:48:29 -0400
X-MC-Unique: Q3lgybjmN6-wDuq7YU7rBg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F40ED1083;
        Fri, 10 Jul 2020 15:48:27 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-114-235.ams2.redhat.com [10.36.114.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBDD27EFA1;
        Fri, 10 Jul 2020 15:48:25 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org,
        Mohammed Gamal <mgamal@redhat.com>
Subject: [PATCH v3 3/9] KVM: x86: mmu: Add guest physical address check in translate_gpa()
Date:   Fri, 10 Jul 2020 17:48:05 +0200
Message-Id: <20200710154811.418214-4-mgamal@redhat.com>
In-Reply-To: <20200710154811.418214-1-mgamal@redhat.com>
References: <20200710154811.418214-1-mgamal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In case of running a guest with 4-level page tables on a 5-level page
table host, it might happen that a guest might have a physical address
with reserved bits set, but the host won't see that and trap it.

Hence, we need to check page faults' physical addresses against the guest's
maximum physical memory and if it's exceeded, we need to add
the PFERR_RSVD_MASK bits to the PF's error code.

Also make sure the error code isn't overwritten by the page table walker.

Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f8b3c5181466..e03e85b21cda 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -518,6 +518,12 @@ static bool check_mmio_spte(struct kvm_vcpu *vcpu, u64 spte)
 static gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
                                   struct x86_exception *exception)
 {
+	/* Check if guest physical address doesn't exceed guest maximum */
+	if (kvm_mmu_is_illegal_gpa(vcpu, gpa)) {
+		exception->error_code |= PFERR_RSVD_MASK;
+		return UNMAPPED_GVA;
+	}
+
         return gpa;
 }
 
-- 
2.26.2

