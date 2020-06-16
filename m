Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5441FBADC
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 18:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732302AbgFPQOo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 12:14:44 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:56907 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732260AbgFPQOm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Jun 2020 12:14:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592324081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=EGk4MDxuxjJxgEfnB6gIyOaKHUzMx57nfzVxFUf1flw=;
        b=b/U4j28mnQmJJ2K3ZZsm0kFoFZauhNVQWi91KqZiObYKmnSxwHnOTGNlUxvUVAm+Up9VPI
        mU+iLjzCDkwv9A0SIT6YKPmLVt4CmJ2j8f6U4UirpCAp9qmuzdGfXS4Za1xCMavVHWpU2L
        le6pg+Ywc8kZp3Ung2wBcWIrLEw7GYU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-KOglBjA_PZOFj8z9UPRzyA-1; Tue, 16 Jun 2020 12:14:39 -0400
X-MC-Unique: KOglBjA_PZOFj8z9UPRzyA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22EC5100A69D;
        Tue, 16 Jun 2020 16:14:32 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C6FF7CAA0;
        Tue, 16 Jun 2020 16:14:28 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Like Xu <like.xu@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: SVM: drop MSR_IA32_PERF_CAPABILITIES from emulated MSRs
Date:   Tue, 16 Jun 2020 18:14:27 +0200
Message-Id: <20200616161427.375651-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

state_test/smm_test selftests are failing on AMD with:
"Unexpected result from KVM_GET_MSRS, r: 51 (failed MSR was 0x345)"

MSR_IA32_PERF_CAPABILITIES is an emulated MSR indeed but only on Intel,
make svm_has_emulated_msr() skip it so it is not returned by
KVM_GET_MSR_INDEX_LIST.

Fixes: 27461da31089 ("KVM: x86/pmu: Support full width counting")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8ccfa4197d9c..2c423d64fb8f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3539,6 +3539,8 @@ static bool svm_has_emulated_msr(u32 index)
 	case MSR_IA32_MCG_EXT_CTL:
 	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
 		return false;
+	case MSR_IA32_PERF_CAPABILITIES:
+		return false;
 	default:
 		break;
 	}
-- 
2.25.4

