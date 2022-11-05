Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2BF61A7A1
	for <lists+kvm@lfdr.de>; Sat,  5 Nov 2022 05:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiKEE5c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Nov 2022 00:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiKEE52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Nov 2022 00:57:28 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083D732BA4
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 21:57:19 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-368036d93abso62914077b3.18
        for <kvm@vger.kernel.org>; Fri, 04 Nov 2022 21:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WSg0IO7Xl+tozOh4xkbrWeBiwBnKrWj4O0/zH/r779g=;
        b=NOQmhkl231fjcgvdKUOzvyqky4m6MkeFoOb9YJMy3HeukRVol0YITwYGZxrAlAi1cj
         mFEKmkYeBHVPyFal3aNYHbnNAyvjJOzq/WYv39vZcBU6tYStPLObeOHlDcCEJ+78d3Ov
         DwYNm/O5Wce+rPgWTe/K57ztOSfjOabLgjFtrJURD7fGF4BqpahbuVQ4bYQZgJ+OZVK4
         aIuToHu+DtIPXdheLe9xhldM9vXJlgsCj52tIJLpFdzQklrBCGg2lvY8FSkPZ8ziUT/x
         HxSDQgc/j2X2x/o+6bFoK893dTYDyG1lZTrP6nVyHjJbDsL1zveXVc7qTbQf2j3dqVSv
         oklg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WSg0IO7Xl+tozOh4xkbrWeBiwBnKrWj4O0/zH/r779g=;
        b=Hf2Rj2IFvC2aegxffNeoVkA11JX8hN7The5vVWTenfsxmumA+Bxel/fnKRY7EZ8zF1
         H5XhJTEVfhJkM/WjJYEuYXLO3+q8AhIH8mR0e6Vg8T/s5QC58zp31oNYvS+ZySwbKeW7
         selxLypkgRrPKMkZETp/O/KzffKFzYyApXwaR9GVYFOizfxlnjVLwGnQcJG/STBCR9C8
         kn7dS8cgAGloKUF7ffDGnyqnV6/t/+ZGaxCrNniDW4ZS61YYieXF4629KsFEUnoXjAtZ
         5vYCXMWoYVrA0u4OcpbMSDC3LhXDgaFbc/MuGRXwOkKRwiK7i5ISO6KRx96ItQatcgmb
         Wv3Q==
X-Gm-Message-State: ACrzQf2G2rU8lcnLCQuBRymFz8ZOAuI7uwIbDXGi1mBtMX5nYa7FU8me
        PBsSj5T+pEAljJdWnhiLbvAx16VFFxhZ
X-Google-Smtp-Source: AMsMyM5FC5Vm+MC97SQrJN35M2k6kPcLK1kmaXUEWtZaQkudGpQKB4ob+eFNH4JK9+gWCshHCMMHgChwmzpN
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a81:1d95:0:b0:370:744a:5a07 with SMTP id
 d143-20020a811d95000000b00370744a5a07mr401209ywd.334.1667624238317; Fri, 04
 Nov 2022 21:57:18 -0700 (PDT)
Date:   Fri,  4 Nov 2022 21:57:03 -0700
In-Reply-To: <20221105045704.2315186-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221105045704.2315186-1-vipinsh@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221105045704.2315186-6-vipinsh@google.com>
Subject: [PATCH 5/6] KVM: selftests: Move hypercall() to hyper.h
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com
Cc:     dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

hypercall() can be used by other hyperv tests, move it to hyperv.h.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../selftests/kvm/include/x86_64/hyperv.h       | 17 +++++++++++++++++
 .../selftests/kvm/x86_64/hyperv_features.c      | 17 -----------------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
index 9d8c325af1d9..87d8d9e444f7 100644
--- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
+++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
@@ -199,4 +199,21 @@ static inline uint64_t hv_linux_guest_id(void)
 	       ((uint64_t)LINUX_VERSION_CODE << 16);
 }
 
+static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
+				vm_vaddr_t output_address, uint64_t *hv_status)
+{
+	uint8_t vector;
+
+	/* Note both the hypercall and the "asm safe" clobber r9-r11. */
+	asm volatile("mov %[output_address], %%r8\n\t"
+		     KVM_ASM_SAFE("vmcall")
+		     : "=a" (*hv_status),
+		       "+c" (control), "+d" (input_address),
+		       KVM_ASM_SAFE_OUTPUTS(vector)
+		     : [output_address] "r"(output_address),
+		       "a" (-EFAULT)
+		     : "cc", "memory", "r8", KVM_ASM_SAFE_CLOBBERS);
+	return vector;
+}
+
 #endif /* !SELFTEST_KVM_HYPERV_H */
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index b5a42cf1ad9d..31b22ee07dfb 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -13,23 +13,6 @@
 #include "processor.h"
 #include "hyperv.h"
 
-static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
-				vm_vaddr_t output_address, uint64_t *hv_status)
-{
-	uint8_t vector;
-
-	/* Note both the hypercall and the "asm safe" clobber r9-r11. */
-	asm volatile("mov %[output_address], %%r8\n\t"
-		     KVM_ASM_SAFE("vmcall")
-		     : "=a" (*hv_status),
-		       "+c" (control), "+d" (input_address),
-		       KVM_ASM_SAFE_OUTPUTS(vector)
-		     : [output_address] "r"(output_address),
-		       "a" (-EFAULT)
-		     : "cc", "memory", "r8", KVM_ASM_SAFE_CLOBBERS);
-	return vector;
-}
-
 struct msr_data {
 	uint32_t idx;
 	bool available;
-- 
2.38.1.273.g43a17bfeac-goog

