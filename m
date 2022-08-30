Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4244E5A654E
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 15:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiH3NmJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 09:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbiH3Nl2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 09:41:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7122DC7
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 06:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661866743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=leb04kms++8UO/3wqkyniMqaiaURa03+1IgpQdNpVu0=;
        b=T10S2VADwwd/ayXVNE+Ps9wpFKSiBLbD8yTAtkd+DLkPN8r0/Dlk6AjKW2jAu3UjEDJ2Nv
        OSp6KB+hsJ9otEFU6mLY+2ygCnpH93DB9aNq8p/PJ+3hLXSEPD/fGX2pUdsXkvvNB5hinv
        28bwRNdYtcKYvbfopjBFupo5a6xXRCk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-389-NEWFwmhIMdK6MHFRpLT5Bw-1; Tue, 30 Aug 2022 09:38:58 -0400
X-MC-Unique: NEWFwmhIMdK6MHFRpLT5Bw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 882B43C0D853;
        Tue, 30 Aug 2022 13:38:57 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 309962166B26;
        Tue, 30 Aug 2022 13:38:55 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 30/33] KVM: nVMX: Always set required-1 bits of pinbased_ctls to PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR
Date:   Tue, 30 Aug 2022 15:37:34 +0200
Message-Id: <20220830133737.1539624-31-vkuznets@redhat.com>
In-Reply-To: <20220830133737.1539624-1-vkuznets@redhat.com>
References: <20220830133737.1539624-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 19a96cf65b99..0975d48cfd06 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6579,7 +6579,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 	rdmsr(MSR_IA32_VMX_PINBASED_CTLS,
 		msrs->pinbased_ctls_low,
 		msrs->pinbased_ctls_high);
-	msrs->pinbased_ctls_low |=
+	msrs->pinbased_ctls_low =
 		PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
 	msrs->pinbased_ctls_high &=
 		PIN_BASED_EXT_INTR_MASK |
-- 
2.37.2

