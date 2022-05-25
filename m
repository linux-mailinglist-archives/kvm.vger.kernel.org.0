Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0EC53390B
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 11:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbiEYJCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 05:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238082AbiEYJB5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 05:01:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CCF067CDE7
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 02:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653469313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=On79BoR3I89OG/tfaqzTF+/NsxS347djRibEvOA1X7g=;
        b=KTSPczEYPe/zTf5DwpKxGBmxXerl1OO3mKhTGUlMA2E7l4ES65LtsBMJ80fb98SYf1GTqT
        mShDCfPsySrH6t2Iu83h91K4Oy9FdIyjtsIrcngQQK8Zvqe4bX32rXV8LWj1fOESRJgqVj
        tWv8sMtZ/skvp4NvDvQhpHsyiil6RwM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-n28l-sAuNkOiz8Zj6F7mQA-1; Wed, 25 May 2022 05:01:50 -0400
X-MC-Unique: n28l-sAuNkOiz8Zj6F7mQA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACFEF101A54E;
        Wed, 25 May 2022 09:01:49 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 024AE40CFD0A;
        Wed, 25 May 2022 09:01:47 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 06/37] KVM: x86: hyper-v: Expose support for extended gva ranges for flush hypercalls
Date:   Wed, 25 May 2022 11:01:02 +0200
Message-Id: <20220525090133.1264239-7-vkuznets@redhat.com>
In-Reply-To: <20220525090133.1264239-1-vkuznets@redhat.com>
References: <20220525090133.1264239-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
index 576749973727..f491e26ce162 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2644,6 +2644,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 			ent->ebx |= HV_DEBUGGING;
 			ent->edx |= HV_X64_GUEST_DEBUGGING_AVAILABLE;
 			ent->edx |= HV_FEATURE_DEBUG_MSRS_AVAILABLE;
+			ent->edx |= HV_FEATURE_EXT_GVA_RANGES_FLUSH;
 
 			/*
 			 * Direct Synthetic timers only make sense with in-kernel
-- 
2.35.3

