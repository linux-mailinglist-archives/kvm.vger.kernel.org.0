Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD47E55DAD2
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238516AbiF0QFH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 12:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238042AbiF0QE6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 12:04:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CEAF5B7D7
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 09:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656345896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P3teDbXPDt7g635Pm4RqkvXv+/sr8wiPNgE9tvD8u5k=;
        b=QJ1jXQqSdFtbavBYApLNLL6Rzlf0h0W44D9EZnT4MkVXTe0Jmz8eOHkgF4bgaPZGqmUaUb
        0tx0dKXtQ3/3uu5NA5LK+Pg64oJmkwIYwl3jNq+nvyhf2BSGunPsMRAu38j8MiyEi/A7y+
        fh8aSHzRxEeZwXhICIhoT/zjCaVdjfA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-OHig1CDjPZeM5Wnhrcp18A-1; Mon, 27 Jun 2022 12:04:51 -0400
X-MC-Unique: OHig1CDjPZeM5Wnhrcp18A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A57628339A4;
        Mon, 27 Jun 2022 16:04:50 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FDFAC26E98;
        Mon, 27 Jun 2022 16:04:48 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/14] KVM: VMX: Tweak the special handling of SECONDARY_EXEC_ENCLS_EXITING in setup_vmcs_config()
Date:   Mon, 27 Jun 2022 18:04:29 +0200
Message-Id: <20220627160440.31857-4-vkuznets@redhat.com>
In-Reply-To: <20220627160440.31857-1-vkuznets@redhat.com>
References: <20220627160440.31857-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SECONDARY_EXEC_ENCLS_EXITING is conditionally added to the 'optional'
checklist in setup_vmcs_config() but there's little value in doing so.
First, as the control is optional, we can always check for its
presence, no harm done. Second, the only real value cpu_has_sgx() check
gives is that on the CPUs which support SECONDARY_EXEC_ENCLS_EXITING but
don't support SGX, the control is not getting enabled. It's highly unlikely
such CPUs exist but it's possible that some hypervisors expose broken vCPU
models.

Preserve cpu_has_sgx() check but filter the result of adjust_vmx_controls()
instead of the input.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ecd00fc69674..5300f2ad6a25 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2528,9 +2528,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			SECONDARY_EXEC_PT_CONCEAL_VMX |
 			SECONDARY_EXEC_ENABLE_VMFUNC |
 			SECONDARY_EXEC_BUS_LOCK_DETECTION |
-			SECONDARY_EXEC_NOTIFY_VM_EXITING;
-		if (cpu_has_sgx())
-			opt2 |= SECONDARY_EXEC_ENCLS_EXITING;
+			SECONDARY_EXEC_NOTIFY_VM_EXITING |
+			SECONDARY_EXEC_ENCLS_EXITING;
+
 		if (adjust_vmx_controls(min2, opt2,
 					MSR_IA32_VMX_PROCBASED_CTLS2,
 					&_cpu_based_2nd_exec_control) < 0)
@@ -2577,6 +2577,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		vmx_cap->vpid = 0;
 	}
 
+	if (!cpu_has_sgx())
+		_cpu_based_2nd_exec_control &= ~SECONDARY_EXEC_ENCLS_EXITING;
+
 	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) {
 		u64 opt3 = TERTIARY_EXEC_IPI_VIRT;
 
-- 
2.35.3

