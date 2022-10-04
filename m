Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05ADA5F4326
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 14:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiJDMlr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 08:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiJDMlS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 08:41:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49B75C9C4
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 05:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664887235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eZGxgt0oprjgv5pOjok2Bjxxb0EJF9XEOurD7XpaAr4=;
        b=hJ/ozjh+pg/L7l1zh7tWMLZTSmrqBE0MrwjEaQn91QkSSQNLyMx3XvPNr+jxtbkUH0IKnp
        3apU4L6x6DWqTlSDCaKLrsztZX3nwAlFDWUvaLD+EUv0AN7WNyxZgovJqSac3yYF/IXfui
        XRZu+hvCwjhkBOsajUvqsoiKMuT1fEw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-lp-SasHzNnS-47hT99GvlQ-1; Tue, 04 Oct 2022 08:40:30 -0400
X-MC-Unique: lp-SasHzNnS-47hT99GvlQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B675D1C08960;
        Tue,  4 Oct 2022 12:40:29 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D54A135429;
        Tue,  4 Oct 2022 12:40:27 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v11 12/46] KVM: x86: hyper-v: Expose support for extended gva ranges for flush hypercalls
Date:   Tue,  4 Oct 2022 14:39:22 +0200
Message-Id: <20221004123956.188909-13-vkuznets@redhat.com>
In-Reply-To: <20221004123956.188909-1-vkuznets@redhat.com>
References: <20221004123956.188909-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index c5e0e5a06c0d..6639979302ab 100644
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
index 2119f6116766..9ede23e881b1 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2636,6 +2636,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 			ent->ebx |= HV_DEBUGGING;
 			ent->edx |= HV_X64_GUEST_DEBUGGING_AVAILABLE;
 			ent->edx |= HV_FEATURE_DEBUG_MSRS_AVAILABLE;
+			ent->edx |= HV_FEATURE_EXT_GVA_RANGES_FLUSH;
 
 			/*
 			 * Direct Synthetic timers only make sense with in-kernel
-- 
2.37.3

