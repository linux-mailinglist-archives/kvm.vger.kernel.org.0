Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD81587FF8
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 18:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237953AbiHBQLh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 12:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237902AbiHBQK6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 12:10:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F23A4D143
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 09:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659456548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/AoBIf3PtY9ar1JL5PSL8EGM8yaCXJywCs/izlnKlio=;
        b=EhDFGKr1UJ1ZRZon1h3rXiLU8x4NLwlQvVP7RDdGEtbR2EhXeRvcvN4oEQ8/leVSDrMeRa
        f/TeEci3ELzyANZWOYNu+hNEHGz5EiguUMbuKbds1CseoiysyNIILV/zOMxkLblNwsLU8Z
        UyNOlcOBPyJGhaE+Dm5fT/+glAda5k0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-208-Hi1MZv8rNEKlsGvoXzH1lw-1; Tue, 02 Aug 2022 12:09:05 -0400
X-MC-Unique: Hi1MZv8rNEKlsGvoXzH1lw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB0AC1019C97;
        Tue,  2 Aug 2022 16:09:04 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 481E42166B2A;
        Tue,  2 Aug 2022 16:09:02 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 23/26] KVM: nVMX: Always set required-1 bits of pinbased_ctls to PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR
Date:   Tue,  2 Aug 2022 18:07:53 +0200
Message-Id: <20220802160756.339464-24-vkuznets@redhat.com>
In-Reply-To: <20220802160756.339464-1-vkuznets@redhat.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similar to exit_ctls_low, entry_ctls_low, procbased_ctls_low,
pinbased_ctls_low should be set to PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR
and not host's MSR_IA32_VMX_PINBASED_CTLS value |=
PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR.

The commit eabeaaccfca0 ("KVM: nVMX: Clean up and fix pin-based
execution controls") which introduced '|=' doesn't mention anything
about why this is needed, the change seems rather accidental.

Note: normally, required-1 portion of MSR_IA32_VMX_PINBASED_CTLS should
be equal to PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR so no behavioral change
is expected, however, it is (in theory) possible to observe something
different there when e.g. KVM is running as a nested hypervisor. Hope
this doesn't happen in practice.

Reported-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index edb2f9c74d71..c86a0f8bb0f4 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6574,7 +6574,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 	rdmsr(MSR_IA32_VMX_PINBASED_CTLS,
 		msrs->pinbased_ctls_low,
 		msrs->pinbased_ctls_high);
-	msrs->pinbased_ctls_low |=
+	msrs->pinbased_ctls_low =
 		PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
 	msrs->pinbased_ctls_high &=
 		PIN_BASED_EXT_INTR_MASK |
-- 
2.35.3

