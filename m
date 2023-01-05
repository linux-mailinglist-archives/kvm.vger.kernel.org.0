Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED17065F417
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 20:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235300AbjAETGZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 14:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235315AbjAETFw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 14:05:52 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C8111B
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 11:05:51 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id c6so7095044pls.4
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 11:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hQYkxUoH0Um5KU/sL31ODM/gQ64ye5V0yfhxxDU8Y1A=;
        b=O0xTzOir3dNuuKC6s1mEf6Ob11VoHPlW40KeegEoFCywOUJtRYTTSjThD0TeGAVwlU
         pmchoonifNXQ/m2+MoEJbsCywF8LiHyaaDqMawZezaUjSsjpqzMmKtlhk5FNNBYy8CzW
         kUDJ7nAekO5aDSyy9M4JC8+4H/8ggZfQ/miiQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hQYkxUoH0Um5KU/sL31ODM/gQ64ye5V0yfhxxDU8Y1A=;
        b=xErDBxmqtR6SGVd8/x8MR0o4B8GxMAZocxzZpXUuZgptKfUu4bgfmkdKqpuw0tFnbH
         EcpKUXjPeKzCvuripUP7NnCtcau67ym+wZBsqYntQO0O4GOlcBQ4DDSS7yFOgx4DYf7O
         WmBOGurutK+GfUfl1XwEDP+w/20QM9uek5gHOSKgwDdN2s+fTHtDIvfFN0xTwxj3ETau
         p2W5Cro8fTQ6Kzwm8WdBihh9hYbOJfoV1pOc7nb4Btq8rzhRTmm6o5dfEPAy3F79QAoS
         KdoZmVcPoZ6O4mbkJBAk6yUvNytd4e6nVJRfO8K6LoB7xFj3M9c9OZQHb24jwo5CFegM
         /jog==
X-Gm-Message-State: AFqh2kotz3kpnm357DeBSwMciaNnp1EL7zd4NfDz8nZrvm71p7ebJIAw
        j9UxrDWOOFvNFXgu3vv/EN0xNQ==
X-Google-Smtp-Source: AMrXdXstxZXSmTD2kLZ1gMKouy6MVGflapLT0FWXVd6PBcZqQLA8iipPIAAflGCg8uRkX2vpKXA1Iw==
X-Received: by 2002:a17:90a:eb03:b0:225:b9df:c4a3 with SMTP id j3-20020a17090aeb0300b00225b9dfc4a3mr50832489pjz.3.1672945551335;
        Thu, 05 Jan 2023 11:05:51 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id x5-20020a17090aa38500b00219cf5c3829sm1658597pjp.57.2023.01.05.11.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 11:05:50 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] KVM: x86: Replace 0-length arrays with flexible arrays
Date:   Thu,  5 Jan 2023 11:05:49 -0800
Message-Id: <20230105190548.never.323-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2361; h=from:subject:message-id; bh=4Cc5ATtGGJ62WdR/RRtEjd3vcbEKzg9EcvjLs50yP4M=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjtx+Mrzj8257RzFFkg/QcFRjziiNI/h5hA61oodCI Vw30ef6JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY7cfjAAKCRCJcvTf3G3AJhZJEA CY04hWGr+64pn8pHkpIMM8qmZt2aB4+QuzuYa8dsIb5raXrCgCp1UpUfMiptB8MLEpv1H2YploSa0e H6KMgqEDSkpuqO73fM8QyWWWNxmljXMCXEq+Ya1FWzdHSBTaqI1SHWrrogWGrrjCvkh+vXfnBzbUto +Raa3tL/ME4x20W4QyCxP6bXJ0mby6HKC1l8rSNRJMGjW4nvD82e4E1XquDk6zM6jXfgGC/lDi4B8a 6FNrTOEjG4Lk9UX8UhU5Qayt9SWDoP5YcwUyEQnzxv0N5ACTZmV5fO4PTZFG3t7k6G19aKbknxzDe9 7M8NHS26L+kk5zqfLHhXMpHBzxvsn28PiShxfbBcKSBt4usMLaqLSs2t4LdHYujcFEZMPN2+K7mPjq lOzJCSnCHj2GAf6ZnSldlsXzzCADUi2W0XfgH+obT5xBfpwVRiVYDUFEDhdA3jyNczFc17+oG7Xi+m ZiLH0nSOVB4c0eTX/RNOkdIaZtBZaNHnGtgz6Sa1oDCNQG+txyWgdtbDSAi71EOIdcHgpV5lGNeQgp R/zMzFDNUC9oM4Paci2nfc+5ABN3b9NRLto1HiLQ3X8acOGnQi/NfL2UPWdT3uw48FbvPsgQgyE+p3 3qVYoWllPMvdNy88+wtjoYN+QivCmDaG1y7CfcpApnvI0i1oSP2MZqIXStgg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Zero-length arrays are deprecated[1]. Replace struct kvm_nested_state's
"data" union 0-length arrays with flexible arrays. (How are the
sizes of these arrays verified?) Detected with GCC 13, using
-fstrict-flex-arrays=3:

arch/x86/kvm/svm/nested.c: In function 'svm_get_nested_state':
arch/x86/kvm/svm/nested.c:1536:17: error: array subscript 0 is outside array bounds of 'struct kvm_svm_nested_state_data[0]' [-Werror=array-bounds=]
 1536 |                 &user_kvm_nested_state->data.svm[0];
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from include/uapi/linux/kvm.h:15,
                 from include/linux/kvm_host.h:40,
                 from arch/x86/kvm/svm/nested.c:18:
arch/x86/include/uapi/asm/kvm.h:511:50: note: while referencing 'svm'
  511 |                 struct kvm_svm_nested_state_data svm[0];
      |                                                  ^~~

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays

Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/uapi/asm/kvm.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index e48deab8901d..8ec3dfd641b0 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -502,13 +502,13 @@ struct kvm_nested_state {
 	} hdr;
 
 	/*
-	 * Define data region as 0 bytes to preserve backwards-compatability
+	 * Define union of flexible arrays to preserve backwards-compatability
 	 * to old definition of kvm_nested_state in order to avoid changing
 	 * KVM_{GET,PUT}_NESTED_STATE ioctl values.
 	 */
 	union {
-		struct kvm_vmx_nested_state_data vmx[0];
-		struct kvm_svm_nested_state_data svm[0];
+		__DECLARE_FLEX_ARRAY(struct kvm_vmx_nested_state_data, vmx);
+		__DECLARE_FLEX_ARRAY(struct kvm_svm_nested_state_data, svm);
 	} data;
 };
 
-- 
2.34.1

