Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1892587FAD
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 18:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbiHBQIH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 12:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiHBQIG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 12:08:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6AEE932B
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 09:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659456484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZBudYlQfwY1bFgy8hf1vbp471K4XLEsuIqWFDRge2Wg=;
        b=VOINCfeGJKq4IBnQMwcE9ZMpxTQ25q/4hzuxHgh2VuvgRtMUuwkAG9CGa/tJDuqmH8aio3
        HhqPpJ3hz8rDkDQfnxUxckw0fWVkQX7zNBoC5380JF5EQIJcDG60utxMBzIJTZcWKML0jO
        Q/0Q5gT31T5gU3i+TTcIzKvNfMVnknE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-mDmJ7M0zOsGOosyAG0AUTg-1; Tue, 02 Aug 2022 12:08:03 -0400
X-MC-Unique: mDmJ7M0zOsGOosyAG0AUTg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 051963804502;
        Tue,  2 Aug 2022 16:08:03 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 851C82166B26;
        Tue,  2 Aug 2022 16:08:00 +0000 (UTC)
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
Subject: [PATCH v5 01/26] KVM: x86: hyper-v: Expose access to debug MSRs in the partition privilege flags
Date:   Tue,  2 Aug 2022 18:07:31 +0200
Message-Id: <20220802160756.339464-2-vkuznets@redhat.com>
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

For some features, Hyper-V spec defines two separate CPUID bits: one
listing whether the feature is supported or not and another one showing
whether guest partition was granted access to the feature ("partition
privilege mask"). 'Debug MSRs available' is one of such features. Add
the missing 'access' bit.

Note: hv_check_msr_access() deliberately keeps checking
HV_FEATURE_DEBUG_MSRS_AVAILABLE bit instead of the new HV_ACCESS_DEBUG_MSRS
to not break existing VMMs (QEMU) which only expose one bit. Normally, VMMs
should set either both these bits or none.

Fixes: f97f5a56f597 ("x86/kvm/hyper-v: Add support for synthetic debugger interface")
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c             | 1 +
 include/asm-generic/hyperv-tlfs.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index ed804447589c..c284a605e453 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2496,6 +2496,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 			ent->eax |= HV_MSR_RESET_AVAILABLE;
 			ent->eax |= HV_MSR_REFERENCE_TSC_AVAILABLE;
 			ent->eax |= HV_ACCESS_FREQUENCY_MSRS;
+			ent->eax |= HV_ACCESS_DEBUG_MSRS;
 			ent->eax |= HV_ACCESS_REENLIGHTENMENT;
 
 			ent->ebx |= HV_POST_MESSAGES;
diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
index fdce7a4cfc6f..1d99dd296a76 100644
--- a/include/asm-generic/hyperv-tlfs.h
+++ b/include/asm-generic/hyperv-tlfs.h
@@ -70,6 +70,8 @@
 #define HV_MSR_GUEST_IDLE_AVAILABLE		BIT(10)
 /* Partition local APIC and TSC frequency registers available */
 #define HV_ACCESS_FREQUENCY_MSRS		BIT(11)
+/* Debug MSRs available */
+#define HV_ACCESS_DEBUG_MSRS			BIT(12)
 /* AccessReenlightenmentControls privilege */
 #define HV_ACCESS_REENLIGHTENMENT		BIT(13)
 /* AccessTscInvariantControls privilege */
-- 
2.35.3

