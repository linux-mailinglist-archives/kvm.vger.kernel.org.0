Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9BA32DF89
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 03:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhCECQl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 21:16:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhCECQl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 21:16:41 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1161C061756
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 18:16:40 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id a186so898306ybg.1
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 18:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=XCuZlcex++tlORTWddHh341Mae7tA0syCjmGbmGPn9g=;
        b=qWBQmAwlMgMgF4FtEbl6VOjLqoWiCkJFNktt9fpqeco2hKyqjvgv9fgentVlBECwVy
         qwATzdmr4c7yY4EhBm4HboriqczFqV4Il+hRoYSxJn0FmVuvZUAn8RO/oJCAVx7/MuMs
         T5bvw+xjZnjoAKG0HwtUzo84urtfEO1d0PNPSqfyenZWbXhLayyU9y9dJ2hhdnTMBKSa
         BC69jOdx39bVmd4E3TVQodre8QBR0cutRcrNfzOZdZhAfGbyjOMlqBTS8xlj4ZvUyXDB
         H4hCm/0aM/uWQUlRd9Q3x/qM68r5m5dhxjxPyJXC4UZiGdXF4U7iGeWAAmzbMyCnxyJ8
         X+Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=XCuZlcex++tlORTWddHh341Mae7tA0syCjmGbmGPn9g=;
        b=NvOk2plssF3Ew6lEysYGtpqCOYQrc61YVUyplUmdjgESgIvE3/TCnjnotzw9wL573p
         BFniQNmTiYY2Ow2kscjJCqcrT5L5Df7dnkFxSVA/vHA4c9s3B6VB9nPVWn3V3NCIGyop
         fhdtHblzzW4gLcJioIIIBplLbWA6VLUyuPUlavO6Xkv3DAwCuDXi3Z98fO9ey5WdfAKz
         uOdtzEQnkWU9md+vGoW4QE5u7XaLe0FYWvuk+BAyYojg9+dl69b3Yo6pY1ziA5nwyQJ1
         YVPUSRdCcKqpxPdS/NlgK/W1ZXAkx58BCzZhIWU5vdfv9AU8a0eHscoen395Mhb47lT+
         p13w==
X-Gm-Message-State: AOAM533lBEdx6RJrqyvmys+PSoi4rxXdFut6i69/M8gL5cEJcEIaXTcM
        FdzHQd/sUOd7NCPr2N3+KvVcsXl+b+A=
X-Google-Smtp-Source: ABdhPJw6kqqgn6lrO6/hWAaUSPFDGUSNlB+6yvYlFi8u2jKAW9fWp2mYtsqAFS5R4iAcL7UPxV2InPNUHg8=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a25:9c02:: with SMTP id c2mr9890875ybo.402.1614910600122;
 Thu, 04 Mar 2021 18:16:40 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Mar 2021 18:16:37 -0800
Message-Id: <20210305021637.3768573-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH] KVM: SVM: Connect 'npt' module param to KVM's internal 'npt_enabled'
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Directly connect the 'npt' param to the 'npt_enabled' variable so that
runtime adjustments to npt_enabled are reflected in sysfs.  Move the
!PAE restriction to a runtime check to ensure NPT is forced off if the
host is using 2-level paging, and add a comment explicitly stating why
NPT requires a 64-bit kernel or a kernel with PAE enabled.

Opportunistically switch the param to octal permissions.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 54610270f66a..0ee74321461e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -115,13 +115,6 @@ static const struct svm_direct_access_msrs {
 	{ .index = MSR_INVALID,				.always = false },
 };
 
-/* enable NPT for AMD64 and X86 with PAE */
-#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
-bool npt_enabled = true;
-#else
-bool npt_enabled;
-#endif
-
 /*
  * These 2 parameters are used to config the controls for Pause-Loop Exiting:
  * pause_filter_count: On processors that support Pause filtering(indicated
@@ -170,9 +163,12 @@ module_param(pause_filter_count_shrink, ushort, 0444);
 static unsigned short pause_filter_count_max = KVM_SVM_DEFAULT_PLE_WINDOW_MAX;
 module_param(pause_filter_count_max, ushort, 0444);
 
-/* allow nested paging (virtualized MMU) for all guests */
-static int npt = true;
-module_param(npt, int, S_IRUGO);
+/*
+ * Use nested page tables by default.  Note, NPT may get forced off by
+ * svm_hardware_setup() if it's unsupported by hardware or the host kernel.
+ */
+bool npt_enabled = true;
+module_param_named(npt, npt_enabled, bool, 0444);
 
 /* allow nested virtualization in KVM/SVM */
 static int nested = true;
@@ -988,12 +984,17 @@ static __init int svm_hardware_setup(void)
 			goto err;
 	}
 
+	/*
+	 * KVM's MMU doesn't support using 2-level paging for itself, and thus
+	 * NPT isn't supported if the host is using 2-level paging since host
+	 * CR4 is unchanged on VMRUN.
+	 */
+	if (!IS_ENABLED(CONFIG_X86_64) && !IS_ENABLED(CONFIG_X86_PAE))
+		npt_enabled = false;
+
 	if (!boot_cpu_has(X86_FEATURE_NPT))
 		npt_enabled = false;
 
-	if (npt_enabled && !npt)
-		npt_enabled = false;
-
 	kvm_configure_mmu(npt_enabled, get_max_npt_level(), PG_LEVEL_1G);
 	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
 
-- 
2.30.1.766.gb4fecdf3b7-goog

