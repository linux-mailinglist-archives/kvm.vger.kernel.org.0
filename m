Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2971E60CC81
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 14:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbiJYMvP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 08:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbiJYMuN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 08:50:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0719B18F26D
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 05:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666702097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6RVePXqf+ZlRyOqE0ZPUurd+WAhhvI1fNgkZgVZLz8k=;
        b=BCMfAgFeIHlazJv3REBYLlRmXckSKxPDvDv/W58gVwLLAZVRZYPIX7/Q4Wxo2gz1RUUf83
        jeBD8TxhtmhXMh0WsOcRBS8XOLNSFQKMv0BzJItP0J2ujvWuUlqg0+F9wKT1I+dz7s5p4n
        UbTl1RMZKbo/vx6HLHjT7klxZJGN+RA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-326-RirOR8KHM6WWyV0fRRj8mw-1; Tue, 25 Oct 2022 08:48:13 -0400
X-MC-Unique: RirOR8KHM6WWyV0fRRj8mw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC3CB802527;
        Tue, 25 Oct 2022 12:48:11 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9972440C6EC6;
        Tue, 25 Oct 2022 12:48:08 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Shuah Khan <shuah@kernel.org>,
        Guang Zeng <guang.zeng@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        linux-kselftest@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Wei Wang <wei.w.wang@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH RESEND v4 07/23] KVM: x86: remove SMRAM address space if SMM is not supported
Date:   Tue, 25 Oct 2022 15:47:25 +0300
Message-Id: <20221025124741.228045-8-mlevitsk@redhat.com>
In-Reply-To: <20221025124741.228045-1-mlevitsk@redhat.com>
References: <20221025124741.228045-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

If CONFIG_KVM_SMM is not defined HF_SMM_MASK will always be zero, and
we can spare userspace the hassle of setting up the SMRAM address space
simply by reporting that only one address space is supported.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 541ed36cbb82f8..28e41926027e7a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1995,11 +1995,14 @@ enum {
 #define HF_SMM_MASK		(1 << 6)
 #define HF_SMM_INSIDE_NMI_MASK	(1 << 7)
 
-#define __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
-#define KVM_ADDRESS_SPACE_NUM 2
-
-#define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
-#define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
+#ifdef CONFIG_KVM_SMM
+# define __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
+# define KVM_ADDRESS_SPACE_NUM 2
+# define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
+# define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
+#else
+# define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, 0)
+#endif
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 
-- 
2.34.3

