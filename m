Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74FAE5EFBD2
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 19:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236160AbiI2RUf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 13:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236079AbiI2RU1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 13:20:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B6D61205A1
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 10:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664472024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zG7c4cSUPjWhNihFqRfTNCioQltxCWvWvLQrMxB9UxU=;
        b=UkZFAgkIyn57WYik3cpfhBvQOfC4Pvus9ygBmSUt+zOPiBGvP30vIoXgKbtCHh8lKrsrOd
        5FWhIiepJMmsX7RNh1QmisdahmOjyf5vHop0zBl9EWqBvdeJSckAkd5bth3kQVm4215ctp
        oHqsYPEYBx8z2csXgOQMx2plFeDDD7I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-SkmU5UTmOrSW5GL_Bf43Cg-1; Thu, 29 Sep 2022 13:20:18 -0400
X-MC-Unique: SkmU5UTmOrSW5GL_Bf43Cg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4395C80C8C3;
        Thu, 29 Sep 2022 17:20:18 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20CA44221F;
        Thu, 29 Sep 2022 17:20:18 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, maciej.szmigiero@oracle.com
Subject: [PATCH v2 7/8] KVM: x86: remove SMRAM address space if SMM is not supported
Date:   Thu, 29 Sep 2022 13:20:15 -0400
Message-Id: <20220929172016.319443-8-pbonzini@redhat.com>
In-Reply-To: <20220929172016.319443-1-pbonzini@redhat.com>
References: <20220929172016.319443-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If CONFIG_KVM_SMM is not defined HF_SMM_MASK will always be zero, and
we can spare userspace the hassle of setting up the SMRAM address space
simply by reporting that only one address space is supported.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cb88da02d965..d11697504471 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1994,11 +1994,14 @@ enum {
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
2.31.1


