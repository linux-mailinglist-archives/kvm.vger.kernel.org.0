Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A7133D5E4
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 15:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236685AbhCPOi1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 10:38:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46510 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236603AbhCPOhr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 10:37:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615905466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O5Co9d4ozrTngCdGCM1S57GEotFMyYjlIiNeBZ4sqxk=;
        b=HELIEJsh1rW8+Rncv04RgjHnYzqtIvh0y14smFbb8RIRl86G7ujCYrC6w7WfCIiuokQ9Is
        CgE3ntv7XopozwxDlvzWKiT+u1oSQIDcUXf0ZXZ2cg83/XiA2rl0C8WFxL/AlapysuEqDQ
        lT0RzRDQgRC4XlagffvmOAIT9V4f+CU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-8c4DSKPmMzOUr2hW85FC2A-1; Tue, 16 Mar 2021 10:37:45 -0400
X-MC-Unique: 8c4DSKPmMzOUr2hW85FC2A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23E69100C662;
        Tue, 16 Mar 2021 14:37:44 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 916835D9D3;
        Tue, 16 Mar 2021 14:37:40 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v2 1/4] KVM: x86: hyper-v: Limit guest to writing zero to HV_X64_MSR_TSC_EMULATION_STATUS
Date:   Tue, 16 Mar 2021 15:37:33 +0100
Message-Id: <20210316143736.964151-2-vkuznets@redhat.com>
In-Reply-To: <20210316143736.964151-1-vkuznets@redhat.com>
References: <20210316143736.964151-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HV_X64_MSR_TSC_EMULATION_STATUS indicates whether TSC accesses are emulated
after migration (to accommodate for a different host TSC frequency when TSC
scaling is not supported; we don't implement this in KVM). Guest can use
the same MSR to stop TSC access emulation by writing zero. Writing anything
else is forbidden.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 58fa8c029867..eefb85b86fe8 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1229,6 +1229,9 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 		hv->hv_tsc_emulation_control = data;
 		break;
 	case HV_X64_MSR_TSC_EMULATION_STATUS:
+		if (data && !host)
+			return 1;
+
 		hv->hv_tsc_emulation_status = data;
 		break;
 	case HV_X64_MSR_TIME_REF_COUNT:
-- 
2.30.2

