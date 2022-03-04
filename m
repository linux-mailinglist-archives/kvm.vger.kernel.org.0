Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1C24CDE68
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbiCDURU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbiCDURG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:17:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 19F7124A138
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 12:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646424765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=yae9tcyRRIcMMdXZij4r2aPFClIS/AdEq2K919VwPEI=;
        b=gnpaHZ9R1H5lPOPweOoaGubn1GvjI3J3D/VRFHQwFc+uK4U/aAxCWIKU0GGxMLwnZPieCF
        0Aojwr37DD/gWizRctH6NXIefPCAIx8u0eVm5mNfeqY12Vki/SdWEY7x18HZMF/8hbC/+P
        n4HKhCfpyXZwAoED7XtrnCK2tMZGl6Y=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-KtTOSm76NCGbCgTPXtJm2g-1; Fri, 04 Mar 2022 15:12:44 -0500
X-MC-Unique: KtTOSm76NCGbCgTPXtJm2g-1
Received: by mail-qv1-f71.google.com with SMTP id w7-20020a0ce107000000b0043512c55ecaso7750170qvk.11
        for <kvm@vger.kernel.org>; Fri, 04 Mar 2022 12:12:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yae9tcyRRIcMMdXZij4r2aPFClIS/AdEq2K919VwPEI=;
        b=OYtBRHUHqWJzhc0isVtwDw9jRkyECR8Z7J5L7tqw6KZy1XJ9Nmx9y1kLNFx/rBBJZq
         JhrAw+0TB1AgRFvVIFV0PeaFR7n5T5Xj0xrtkR39gyBM0nV39/vDBxWp0RKnyd7Mi+4q
         dnqHkLb7HJ35A93Js/lDuYoozRDlwEvDok+7O5NbFp8qwLn1KUM9r8wi2HcBxbwiYRqn
         2UaVnAvCibT3QoIiG0wM5ez+0AWQ2c6MjFqUEZ/CNciE5BARjvpeEB5BPPnd+SOKupKz
         mMxHNWWYMoX/OIf/396EFTbazVuU0a8vWX4jXgqOKwCNuW/epvF/rD49X2nCBd1JJ0f+
         78SQ==
X-Gm-Message-State: AOAM5309cUv7hH4tf8KHpE3Mu3eEfTHc1ELSDsIcXVVp/+PfzJgl9A36
        ncqlhnU8yaR05GzJiWYmLl73ObxH7qye7h4ISUMszLuWDbuXtOZvXOMGdxvBa0d3m+pbdUIjOVg
        tSxRoPWK/68St
X-Received: by 2002:a37:cc6:0:b0:47e:b863:a65c with SMTP id 189-20020a370cc6000000b0047eb863a65cmr247539qkm.202.1646424763247;
        Fri, 04 Mar 2022 12:12:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzSOrAecTFY+QApqcPd6vP/Bk7IrTPHDRJ+re0Dhz97JEsBzgunhI1q8ZrPiTiPuBJCOWK4dA==
X-Received: by 2002:a37:cc6:0:b0:47e:b863:a65c with SMTP id 189-20020a370cc6000000b0047eb863a65cmr247533qkm.202.1646424763049;
        Fri, 04 Mar 2022 12:12:43 -0800 (PST)
Received: from fedora.redhat.com (pool-71-175-3-221.phlapa.fios.verizon.net. [71.175.3.221])
        by smtp.gmail.com with ESMTPSA id v26-20020a05620a0a9a00b00605c6dbe40asm2762997qkg.87.2022.03.04.12.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 12:12:42 -0800 (PST)
From:   Tyler Fanelli <tfanelli@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        berrange@redhat.com, Tyler Fanelli <tfanelli@redhat.com>
Subject: [PATCH v3] i386/sev: Ensure attestation report length is valid before retrieving
Date:   Fri,  4 Mar 2022 15:11:43 -0500
Message-Id: <20220304201141.509492-1-tfanelli@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The length of the attestation report buffer is never checked to be
valid before allocation is made. If the length of the report is returned
to be 0, the buffer to retrieve the attestation buffer is allocated with
length 0 and passed to the kernel to fill with contents of the attestation
report. Leaving this unchecked is dangerous and could lead to undefined
behavior.

Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
---
 target/i386/sev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 025ff7a6f8..e82be3e350 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -616,6 +616,8 @@ static SevAttestationReport *sev_get_attestation_report(const char *mnonce,
         return NULL;
     }
 
+    input.len = 0;
+
     /* Query the report length */
     ret = sev_ioctl(sev->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
             &input, &err);
@@ -626,6 +628,11 @@ static SevAttestationReport *sev_get_attestation_report(const char *mnonce,
                        ret, err, fw_error_to_str(err));
             return NULL;
         }
+    } else if (input.len == 0) {
+        error_setg(errp, "SEV: Failed to query attestation report:"
+                         " length returned=%u",
+                   input.len);
+        return NULL;
     }
 
     data = g_malloc(input.len);
-- 
2.31.1

