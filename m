Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B050574FA5
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 15:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239962AbiGNNuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 09:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239942AbiGNNtx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 09:49:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E5DF3599F6
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 06:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657806592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rqHdS/MUS1zlplWbbCoRp7W6T1XpHQG+LzicxUX07tU=;
        b=CQwdwBvGQHj6j2OuIqdgPldJUeuXEXiFqOFS93I+MSf18x+fF3hazhv5vbn2Uov8pNysZR
        H6WzLcrwDmmpgIiY6AEjzW/r1aXAVHwyOXuQGTGjjYEejO2CY/OsaHaIgAebxFYPDU+Q/I
        5MV7WMck3sAWnkxzyafWWrsGraApg9I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-3-eOiWC1XpNmqi8GygqVeduw-1; Thu, 14 Jul 2022 09:49:48 -0400
X-MC-Unique: eOiWC1XpNmqi8GygqVeduw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 58C1A85A584;
        Thu, 14 Jul 2022 13:49:47 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D66C2166B26;
        Thu, 14 Jul 2022 13:49:45 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 06/39] KVM: x86: hyper-v: Expose support for extended gva ranges for flush hypercalls
Date:   Thu, 14 Jul 2022 15:48:56 +0200
Message-Id: <20220714134929.1125828-7-vkuznets@redhat.com>
In-Reply-To: <20220714134929.1125828-1-vkuznets@redhat.com>
References: <20220714134929.1125828-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extended GVA ranges support bit seems to indicate whether lower 12
bits of GVA can be used to specify up to 4095 additional consequent
GVAs to flush. This is somewhat described in TLFS.

Previously, KVM was handling HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX}
requests by flushing the whole VPID so technically, extended GVA
ranges were already supported. As such requests are handled more
gently now, advertizing support for extended ranges starts making
sense to reduce the size of TLB flush requests.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/hyperv-tlfs.h | 2 ++
 arch/x86/kvm/hyperv.c              | 1 +
 2 files changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 0a9407dc0859..5225a85c08c3 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -61,6 +61,8 @@
 #define HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE		BIT(10)
 /* Support for debug MSRs available */
 #define HV_FEATURE_DEBUG_MSRS_AVAILABLE			BIT(11)
+/* Support for extended gva ranges for flush hypercalls available */
+#define HV_FEATURE_EXT_GVA_RANGES_FLUSH			BIT(14)
 /*
  * Support for returning hypercall output block via XMM
  * registers is available
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index facd418ea3e8..783612e1fa3f 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2642,6 +2642,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 			ent->ebx |= HV_DEBUGGING;
 			ent->edx |= HV_X64_GUEST_DEBUGGING_AVAILABLE;
 			ent->edx |= HV_FEATURE_DEBUG_MSRS_AVAILABLE;
+			ent->edx |= HV_FEATURE_EXT_GVA_RANGES_FLUSH;
 
 			/*
 			 * Direct Synthetic timers only make sense with in-kernel
-- 
2.35.3

