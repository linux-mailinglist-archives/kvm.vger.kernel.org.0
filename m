Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB824D4FA8
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 17:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244166AbiCJQrm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 11:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244180AbiCJQrb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 11:47:31 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A88C198D1E
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 08:46:20 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id b4-20020a170902a9c400b001532ec9005aso195041plr.10
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 08:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OmK9ig5jJPqHc1lT2kwZLVXWHtYR0m8aDz/I++ZnaZg=;
        b=HdFmzmvSIq4czsk8EyXnKZqkaBCWAJbd0VwxsSv4+1Yw7/3bw6MYRa7aMqdk0mV1e1
         VHNRH9xx/5Te44HQJHZxuyptGPbnXf/j+pXB8dusDq5udVzrfFDbXHWHGiOxW42yBKen
         taetvPR9Zt8E8HQhExhww8N+Q6aj4bq83pNPzWJvmGhzYl+GVOBOWmdrug0kgrir4KZz
         L6/euPHhjKO+W6ssAnsgPJ21R2zI0j4v2cB3usLUUpZK8YA/1cRRoCXlU3X5FAklbDdX
         P1J5k3k7z+EPGWsSylCef3Wx0ns0t++tyYbzx6fhn5LJuHFXaBPNV8cRK6oFrWrcojdz
         pcgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OmK9ig5jJPqHc1lT2kwZLVXWHtYR0m8aDz/I++ZnaZg=;
        b=QmAasxVPuWQlEWBcT0VcwhrAOO2JV4rGwMb4YNXfziHvzhEYxKb/XQ+XaPB28X3awM
         ngDI/Lnan8GBLYjML/UVsBd/Qus+LZtFHh3/fQ0Cq+CmwRjwjttzapkGyOGJs9DSslmk
         ubxSofsnSgJdsl0z9+5qO/ah6BpgLCX4Phm7gANrUfLxEn5l25EhwWO4GAT8eWSJfRag
         cVmogZm7hLzbD/670OTb5UZkttUVYh5Wmw10I/JsdUBM2CotjmPA5ylxbSNwn4YD/ye6
         dQY7yiNWJjQWL++3bcbWNI9iOXFRGGhSV45U+prpnxyHFWSIbdra2ZkST7K2O+qDGOl5
         ORUQ==
X-Gm-Message-State: AOAM530gfcvDmZ0hZgvCSd8CKAmpA5gVSxPuOt+5faXWTZNU3DoZYS1C
        JsJtAU+mxDRkZuVEI2IhLVkwKKPLuWh6
X-Google-Smtp-Source: ABdhPJwrSHkEApdTW6RNQ1Yq3YoC+LnnBLVKJr3xZgwX2aqe4qJL7KcpDIGjBo9jF5gVpEqZyPMtdxBy110l
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:2d58:733f:1853:8e86])
 (user=bgardon job=sendgmr) by 2002:a17:90b:1e10:b0:1bf:6c78:54a9 with SMTP id
 pg16-20020a17090b1e1000b001bf6c7854a9mr94496pjb.1.1646930779582; Thu, 10 Mar
 2022 08:46:19 -0800 (PST)
Date:   Thu, 10 Mar 2022 08:45:31 -0800
In-Reply-To: <20220310164532.1821490-1-bgardon@google.com>
Message-Id: <20220310164532.1821490-13-bgardon@google.com>
Mime-Version: 1.0
References: <20220310164532.1821490-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH 12/13] KVM: x86/MMU: Require reboot permission to disable NX hugepages
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
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

Ensure that the userspace actor attempting to disable NX hugepages has
permission to reboot the system. Since disabling NX hugepages would
allow a guest to crash the system, it is similar to reboot permissions.

This approach is the simplest permission gating, but passing a file
descriptor opened for write for the module parameter would also work
well and be more precise.
The latter approach was suggested by Sean Christopherson.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/x86.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 74351cbb9b5b..995f30667619 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4256,7 +4256,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SYS_ATTRIBUTES:
 	case KVM_CAP_VAPIC:
 	case KVM_CAP_ENABLE_CAP:
-	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
@@ -4359,6 +4358,14 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_DISABLE_QUIRKS2:
 		r = KVM_X86_VALID_QUIRKS;
 		break;
+	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
+		/*
+		 * Since the risk of disabling NX hugepages is a guest crashing
+		 * the system, ensure the userspace process has permission to
+		 * reboot the system.
+		 */
+		r = capable(CAP_SYS_BOOT);
+		break;
 	default:
 		break;
 	}
@@ -6050,6 +6057,15 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		mutex_unlock(&kvm->lock);
 		break;
 	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
+		/*
+		 * Since the risk of disabling NX hugepages is a guest crashing
+		 * the system, ensure the userspace process has permission to
+		 * reboot the system.
+		 */
+		if (!capable(CAP_SYS_BOOT)) {
+			r = -EPERM;
+			break;
+		}
 		kvm->arch.disable_nx_huge_pages = true;
 		kvm_update_nx_huge_pages(kvm);
 		r = 0;
-- 
2.35.1.616.g0bdcbb4464-goog

