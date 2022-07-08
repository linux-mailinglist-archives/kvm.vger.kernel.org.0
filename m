Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADCE56BC48
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 17:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238653AbiGHOnw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 10:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238572AbiGHOnd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 10:43:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B47D41CE
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 07:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657291405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QYONl9THxMtT6V1w81Fo54UYVsMaakv0NH4e6XEHbyg=;
        b=Oa71XTKdfW93V92GUHAVGuwcTBMIobiq8htn12LVxt9eq+lEKDbcCH9b3m3bB9kHJIWp5W
        8K28KmZhwvt+IvupFjNXhmAybNUH9fuImhJiFXub4wJk2sESXfk585sCv+8MD0mqUMGVMt
        VZLNkzFqU/+upYpm5/5bwcU5Qatr6Gw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-537-nUkSh3ISN_qM8ddpoVE4JA-1; Fri, 08 Jul 2022 10:43:20 -0400
X-MC-Unique: nUkSh3ISN_qM8ddpoVE4JA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 43DA485A585;
        Fri,  8 Jul 2022 14:43:20 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.193.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8AFBE492C3B;
        Fri,  8 Jul 2022 14:43:18 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 22/25] KVM: nVMX: Always set required-1 bits of pinbased_ctls to PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR
Date:   Fri,  8 Jul 2022 16:42:20 +0200
Message-Id: <20220708144223.610080-23-vkuznets@redhat.com>
In-Reply-To: <20220708144223.610080-1-vkuznets@redhat.com>
References: <20220708144223.610080-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
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
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index dcf3ee645212..09654d5c2144 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6586,7 +6586,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
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

