Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0017C4ED802
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 12:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234785AbiCaKzI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 06:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbiCaKzH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 06:55:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72F2918462A
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 03:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648723998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XcDlvWspDG5mfIRp6mHjzmYuHXnw0hkNnfZv5tbcBbY=;
        b=FzaJ9cE0obrhYnrm0NbEa+FxM7Qygri1Zdf1OEkepAl+OmEgaiLst0OwyyblQNKip5EoTd
        C0fHvioNfCHYtbEJTV5bVsp1XvwWiv86EXfIORSfTAmD6ylPAodqimQW6fLZZK8ShMUwpw
        qDzs5xsafQpYcigS+gXre5hI1FBkahk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-AsacG903PWK74GM7ziGzmA-1; Thu, 31 Mar 2022 06:53:17 -0400
X-MC-Unique: AsacG903PWK74GM7ziGzmA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64B06833942;
        Thu, 31 Mar 2022 10:53:16 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F1B64C15D42;
        Thu, 31 Mar 2022 10:53:07 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     lirongqing@baidu.com
Subject: [PATCH] x86, kvm: fix compilation for !CONFIG_PARAVIRT_SPINLOCKS or !CONFIG_SMP
Date:   Thu, 31 Mar 2022 06:53:07 -0400
Message-Id: <20220331105307.487998-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The assembly version of __kvm_vcpu_is_preempted only works if
CONFIG_SMP is defined, due to the use of __per_cpu_offset.  It
also uses the KVM_STEAL_TIME_preempted offset constant which
is currently not defined if !CONFIG_PARAVIRT_SPINLOCKS.  Fix
both issues.

This is the delta between Li RongQing's v3 and v4
submissions.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kernel/asm-offsets_64.c | 4 ++--
 arch/x86/kernel/kvm.c            | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index b14533af7676..9b698215d261 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -5,7 +5,7 @@
 
 #include <asm/ia32.h>
 
-#if defined(CONFIG_KVM_GUEST) && defined(CONFIG_PARAVIRT_SPINLOCKS)
+#if defined(CONFIG_KVM_GUEST)
 #include <asm/kvm_para.h>
 #endif
 
@@ -20,7 +20,7 @@ int main(void)
 	BLANK();
 #endif
 
-#if defined(CONFIG_KVM_GUEST) && defined(CONFIG_PARAVIRT_SPINLOCKS)
+#if defined(CONFIG_KVM_GUEST)
 	OFFSET(KVM_STEAL_TIME_preempted, kvm_steal_time, preempted);
 	BLANK();
 #endif
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 21933095a10e..e12beeed9d13 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -752,7 +752,9 @@ static void kvm_crash_shutdown(struct pt_regs *regs)
 }
 #endif
 
-#ifdef CONFIG_X86_32
+#if defined(CONFIG_X86_32) || !defined(CONFIG_SMP)
+bool __kvm_vcpu_is_preempted(long cpu);
+
 __visible bool __kvm_vcpu_is_preempted(long cpu)
 {
 	struct kvm_steal_time *src = &per_cpu(steal_time, cpu);
-- 
2.31.1

