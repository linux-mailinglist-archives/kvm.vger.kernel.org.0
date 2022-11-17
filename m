Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40E4262DE5B
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 15:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240548AbiKQOgF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 09:36:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240408AbiKQOew (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 09:34:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D6C3206A
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 06:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668695618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1k8xZrOm8P1dLuASAaP3xDdrnCi2/FFVUPRDCzjye6I=;
        b=DIX1vbNm3ZtsxBSyJk4CNmVUfFVA76v9zfPz4xMF7oSmFczaWxFK5RfAty2/U8EXNy055N
        HE/mWQSqj46UoP3D7b2H3W5MeK4KkTHcWl8OAKQZMsfFphFd7rg4EhrWnpfrcumbr2u5G3
        UMF83f7MdS02SRWihH4OtBgy8zRXsno=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-42-qx5GWSDkPoGBYLKq62dSJQ-1; Thu, 17 Nov 2022 09:33:33 -0500
X-MC-Unique: qx5GWSDkPoGBYLKq62dSJQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E32788F452;
        Thu, 17 Nov 2022 14:33:32 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6B0D2166B29;
        Thu, 17 Nov 2022 14:33:28 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sandipan Das <sandipan.das@amd.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jing Liu <jing2.liu@intel.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Wyes Karny <wyes.karny@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Babu Moger <babu.moger@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Santosh Shukla <santosh.shukla@amd.com>
Subject: [PATCH 12/13] KVM: nSVM: emulate VMEXIT_INVALID case for nested VNMI
Date:   Thu, 17 Nov 2022 16:32:41 +0200
Message-Id: <20221117143242.102721-13-mlevitsk@redhat.com>
In-Reply-To: <20221117143242.102721-1-mlevitsk@redhat.com>
References: <20221117143242.102721-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Santosh Shukla <santosh.shukla@amd.com>

If NMI virtualization enabled and NMI_INTERCEPT is unset then next vm
entry will exit with #INVALID exit reason.

In order to emulate above (VMEXIT(#INVALID)) scenario for nested
environment, extending check for V_NMI_ENABLE, NMI_INTERCEPT bit in func
__nested_vmcb_check_controls.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index c9fcdd691bb5a1..3ef7e1971a4709 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -275,6 +275,11 @@ static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 	if (CC(!nested_svm_check_tlb_ctl(vcpu, control->tlb_ctl)))
 		return false;
 
+	if (CC((control->int_ctl & V_NMI_ENABLE) &&
+		!vmcb12_is_intercept(control, INTERCEPT_NMI))) {
+		return false;
+	}
+
 	return true;
 }
 
-- 
2.34.3

