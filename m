Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591646728DD
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 20:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjART7Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 14:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjART7R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 14:59:17 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D645957D
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 11:59:13 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id d8so145074pjc.3
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 11:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=unXRO6bZrfZbYWm8f6ZOjrpS93pJrOltQeFYVVz3fCI=;
        b=i6XJewPhr6o0wJ2q3hHspIxyzFd7LtRGObuPmBZ81HtGP4z4JoAMsoxf7FlxbM9K/o
         3hp/y0QoY7kagZ9oCkSQKDVpbSZtxShRn80o3kKCf7XNIy51h2FQr6LKwb7Mnjz9C2QZ
         d4bkv4kTps7lgB+b/qHdaTxZVaaKgOCtgQn34=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=unXRO6bZrfZbYWm8f6ZOjrpS93pJrOltQeFYVVz3fCI=;
        b=4kkvox78YyjoSdeu+de2L33SXgVyyiBcQOtZFsliMmAEN/diEDubSK9xd84E7S2rJD
         rW9xezJvneon1GcnHMAGa1xGgYKhIzVqngHW9ONz7RiqpQuWUOzUS8mtz7BQ4O4K1fv7
         eQLSdcUpXnzbCpkHnz4k6r4Hv3CQ53DUveeYl02NOXQWFh7Oo4p9R6Z49Jv+axzybTxq
         uQfq0mnC7uG0riwMm5jHsf1iiccqHAmVFA9+ZyBsey3zxE8tb8z8y15hmJqlXnBem9rQ
         APkeU5M6ia8/keuywJenpJuOMu2QLMaOD12HLl/+Mnf3dLNbkzjnfTlkapjV64gEJ2mg
         TKdQ==
X-Gm-Message-State: AFqh2kpXwPO+Xed4oyvonnaxp65cEwwwaKeYiUgaHqp3HM8G5zGftk+f
        2dQ/j9eqxtbbqBg2KOOJktzVBg==
X-Google-Smtp-Source: AMrXdXtNkBPob3UsDVT0L3j5RomnNmmg0FqN+Ke+Mi2pwxPuPm6Nus4mo8MkxgaeiY0pJx0zO/2gmA==
X-Received: by 2002:a17:903:1005:b0:192:5283:3096 with SMTP id a5-20020a170903100500b0019252833096mr7335642plb.56.1674071952811;
        Wed, 18 Jan 2023 11:59:12 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id z9-20020a170903018900b00189db296776sm23671829plg.17.2023.01.18.11.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 11:59:12 -0800 (PST)
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
Subject: [PATCH v2] KVM: x86: Replace 0-length arrays with flexible arrays
Date:   Wed, 18 Jan 2023 11:59:09 -0800
Message-Id: <20230118195905.gonna.693-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2544; h=from:subject:message-id; bh=LRNFAlXz15jSczMxHrCA2KpHuFvqd4UhOYrqNn7nZe0=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjyE+NUyzP6Au3qoCf0nTCY/x1haf3i8YXeR9CltCP EJ3QesCJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY8hPjQAKCRCJcvTf3G3AJo1BEA CszsUkZWN3jC/bQDe6MiJGRylzMvOLRkSUMd1Y/o0IS9m+9+IilWjxZIAhDmowy3kt5zQew2ixXC7B LWonkZv8PE0rQKgZno3IzhWnF7Urtley+jbdE9occM3stb2jTtmb2AqOFbP4p2wSGE+A37f4lJKUb1 I6DEEuzNojSDUumpwIyedU4m4y5yBplnA4eLH81IiKYjrwBYTXITZe/dD+Zi2eXGDJcLKfaz7D8lUo JgfibNOQ/gNZ8+b2pYoN8kELg6itD0UqdU+glSQwPleu+5HDzpSK/OZ30pIoH2VIZzC8sj1jcyYpt6 NQop0KITFmyvjBI3IGvXqNMrku17dN4tPNl80MiElay2ImpeKQKkQq5WqErxCP2ox7S5dUZCVpRVZg W8IK4RAsI7Cwdh7RRe6AHEcPKF5YLcHOdiTzyO0bMrOem1IyUXkiDeEGk4BUyWKHh7rmVvAO+OJ6d9 lx4BUfdJ0khSp0YeuUS5/+bfzLMzaQRIL5E61jDXnEA+hWySZLFypBMuQzIrqWn8sxw9qsYg2j+0Ff 0HJRaVufge2znDgiCEu4JhWsF9V55emKOeVm+dHY8py8dYJLbT/6Da0as2FPDbEkC5mFGSDBumMYgs oKPM9++43+B3s/qF1Kh9MtV/4WRz8nKXpsQKf6+FgAVXqF58rfYwxf2XT2vw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/20230105190548.never.323-kees@kernel.org
---
v2: add missing stddef.h include
v1: https://lore.kernel.org/all/20230105190548.never.323-kees@kernel.org/
---
 arch/x86/include/uapi/asm/kvm.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index e48deab8901d..bde47f3a8c9d 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -9,6 +9,7 @@
 
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/stddef.h>
 
 #define KVM_PIO_PAGE_OFFSET 1
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 2
@@ -507,8 +508,8 @@ struct kvm_nested_state {
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

