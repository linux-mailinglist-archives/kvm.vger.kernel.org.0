Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978B04DCED7
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 20:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238019AbiCQT2a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 15:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238022AbiCQT22 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 15:28:28 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3199721DF10
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 12:27:11 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e8-20020a259248000000b0063391b39d14so4203606ybo.10
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 12:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=SY7x7s2PK1m0DaFeGw30caQr16xmi7SnJs2uqFu6Tyw=;
        b=Pq2D5ufP3hwcxoUZn3ncrA9U7bKNQL3SmyjNk8EWShIcSoiE9fS1dcvTCE8PZRJ5nj
         HKOPrvBS32VXg3JkQ9dQfu20mEs6hZFj+7HyzmQu5V+nQDEsIHaa2x5VBsObMyX9X3+X
         IUMx2+j3jrn+1OFqEOxFcVOeCwx69AHzSKLLiHweW23EBIq9I6sYCQj8ebMOpayayNo0
         jTnAE4SV8fSM4AUgh7qJF9NtvAETzbbDRzNNhMjrH4Ngq7Zjastm+JTKvoalR7StkvFh
         4KqcOWDu7c9y/iudHqJbbHbs8/oNUSFlXNbn4iS6rD1Sv+OY5BlwlR0fGtiiV4V5XK9i
         s+xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=SY7x7s2PK1m0DaFeGw30caQr16xmi7SnJs2uqFu6Tyw=;
        b=3XPBaOmnVqTsrS7yxDnWg8ojBPEFk+h3MImT5QYNUAYbxfrgKlAq/KMLIf15lTGoLt
         OYrGpZZIO1kID+Zxu4yIC1atP4M8Sx+et33GVhsIw/YrlX6ogpBZUKHrwt0J3rupBSH2
         sSM1xy6l8UDQkL7iLomcnskMH9Yq1S9wSHx8NV4udUOvRkv7jx1DhdiRDiGFs0Zetchg
         /KIIx6tksdsxcVxY4AqeW39l4jSz43w1wxESFi8DudUMLt3BZNTevh8+phKob/CweFNJ
         2Z24k2m0nQSsT77i8oclvKKI1ljKdgwVrZUZgp3CKvMlkrvH2OG11XGFrepmRdMz14nW
         GVsA==
X-Gm-Message-State: AOAM530JvQmLXWkasHc+GFbaTT4l/fWlwgI5O220Zlfm90e0GuQmVEzh
        0ZpzyBel2FEKaACr8BUjbWWVxMGLpdz+IKlG8x7ROXoHfYKOiuUr3SyKdGZigGZOYRLM/EgpnaE
        HbpuHP5FBDRq1N0ZqQ75tALV1kpty+/dVixggCrnNTw6B4xAikz7l38SBFA==
X-Google-Smtp-Source: ABdhPJwWTSaZMIztaa2dHv/XG9sgD/NjS3ZEbaiRT3d4pb/Xmq+RmjbSJK25dS2htzDnA7JukcKOJ27I6nA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:4c46:0:b0:633:86ed:31e6 with SMTP id
 z67-20020a254c46000000b0063386ed31e6mr6641836yba.319.1647545230214; Thu, 17
 Mar 2022 12:27:10 -0700 (PDT)
Date:   Thu, 17 Mar 2022 19:27:07 +0000
Message-Id: <20220317192707.59538-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH] x86/cpuid: Stop masking the CPU vendor
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

commit bc0b99a ("kvm tools: Filter out CPU vendor string") replaced the
processor's native vendor string with a synthetic one to hack around
some interesting guest MSR accesses that were not handled in KVM. In
particular, the MC4_CTL_MASK MSR was accessed for AMD VMs, which isn't
supported by KVM. This MSR relates to masking MCEs originating from the
northbridge on real hardware, but is of zero use in virtualization.

Speaking more broadly, KVM does in fact do the right thing for such an
MSR (#GP), and it is annoying but benign that KVM does a printk for the
MSR. Masking the CPU vendor string is far from ideal, and gets in the
way of testing vendor-specific CPU features. Stop the shenanigans and
expose the vendor ID as returned by KVM_GET_SUPPORTED_CPUID.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 x86/cpuid.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/x86/cpuid.c b/x86/cpuid.c
index aa213d5..f4347a8 100644
--- a/x86/cpuid.c
+++ b/x86/cpuid.c
@@ -10,7 +10,6 @@
 
 static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid, int cpu_id)
 {
-	unsigned int signature[3];
 	unsigned int i;
 
 	/*
@@ -20,13 +19,6 @@ static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid, int cpu_id)
 		struct kvm_cpuid_entry2 *entry = &kvm_cpuid->entries[i];
 
 		switch (entry->function) {
-		case 0:
-			/* Vendor name */
-			memcpy(signature, "LKVMLKVMLKVM", 12);
-			entry->ebx = signature[0];
-			entry->ecx = signature[1];
-			entry->edx = signature[2];
-			break;
 		case 1:
 			entry->ebx &= ~(0xff << 24);
 			entry->ebx |= cpu_id << 24;
-- 
2.35.1.894.gb6a874cedc-goog

