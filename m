Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6400756BC0F
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 17:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238341AbiGHOmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 10:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238310AbiGHOmf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 10:42:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DF1602B185
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 07:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657291353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fEdjnqcwdrP4ky6Ydkpn9hPwr/5/PhNfBhkdDi68CEI=;
        b=d6t2NDsmqSMx2MbN3M5x6halHiSLMp845ynVHiglXV7sfnKCobjfV2aEK5RTVGaM1sshgH
        WpPHiJawQWJEshsQ60ldBAJXXWCIoz7jv7gVjb6sIQvkl6P1AxzxwA70wcTFJioN4zbYG1
        m3+bGfnf+epU6bHHqg2H1kY6w9Etf+g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-288-VdK724GANSCCoFqwWXvY6A-1; Fri, 08 Jul 2022 10:42:31 -0400
X-MC-Unique: VdK724GANSCCoFqwWXvY6A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C1873C01DE4;
        Fri,  8 Jul 2022 14:42:30 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.193.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6CC5E492C3B;
        Fri,  8 Jul 2022 14:42:28 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 01/25] KVM: x86: hyper-v: Expose access to debug MSRs in the partition privilege flags
Date:   Fri,  8 Jul 2022 16:41:59 +0200
Message-Id: <20220708144223.610080-2-vkuznets@redhat.com>
In-Reply-To: <20220708144223.610080-1-vkuznets@redhat.com>
References: <20220708144223.610080-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

Fixes: f97f5a56f597 ("x86/kvm/hyper-v: Add support for synthetic debugger interface")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c             | 1 +
 include/asm-generic/hyperv-tlfs.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index e2e95a6fccfd..e08189211d9a 100644
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

