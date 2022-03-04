Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6B6A4CDDA0
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 20:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiCDT7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 14:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiCDT7P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 14:59:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6D4A4233E42
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 11:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646423452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=V4hj5evNOGl+Lr6CX2G+YtA5FLa2dyLPNNnS8TcyC4w=;
        b=hn9fUWEfhGz5cIJgclhLfIeB9YH3TMCOTuBW9hRKk/CYzVcTiMILdLfeyShgVEySW12as8
        91CcuDetF4dDgPLye2QDIBApqRkX6jgK82OROcOkjw9TBCREPfvW16z1pjrxlz6n8u+gue
        G/jTGzgQ+M/PbI+KTC+L/Iu1VcLEQ/Y=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-529-Q84O3Mo_M2isL-0aPFiOmQ-1; Fri, 04 Mar 2022 14:40:28 -0500
X-MC-Unique: Q84O3Mo_M2isL-0aPFiOmQ-1
Received: by mail-qk1-f198.google.com with SMTP id q5-20020a05620a0d8500b004738c1b48beso6335792qkl.7
        for <kvm@vger.kernel.org>; Fri, 04 Mar 2022 11:40:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V4hj5evNOGl+Lr6CX2G+YtA5FLa2dyLPNNnS8TcyC4w=;
        b=AOoHNVkcFVvix7ezUlF7x/eHdRJedi1gmvDgpc+RKuc/KpkntyTaU7oAz/KNVnjE2m
         BFOnRH2si/WCb5Zcfu3RW+up+s6bnetd6vMZ/fMJ9eIQX+UxDYeNjdPoYFu7JCjxgcSN
         QVWYknJIkvbomlWwM160zc+stAZ25ztykWuAm29TgfnPSiGIjPI/sNuy5KTnp+RL9oFk
         XqMclExxTTtSCUfhvDYBuJJYlK5qvvux3bHgXuz72rn2/Z0iSLQnbkEumWbTYhrO9O6s
         ZEvhKYZyJN/GoRK9X3N7LABWA13o1bmkaTfu6m+RUaipTQJIz4RIyLltYzffxxmj+HAz
         t3GA==
X-Gm-Message-State: AOAM530HStMm4+krZr9/g2mAp4nF1zVi/ydLjNkAfSbdy1W/vAmwCI+8
        IwRe3MemdNCM5z/Qr93gAaWv3P04O0Kxk2Z6/imJiNj64VD7Td7vPg98mcSa/BZIVCqO+PmudXY
        m6/lGOOFos1Ut
X-Received: by 2002:ae9:e005:0:b0:46d:cfe5:993 with SMTP id m5-20020ae9e005000000b0046dcfe50993mr170976qkk.138.1646422827773;
        Fri, 04 Mar 2022 11:40:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJygvWtWn+RjVpGiJotLiISijesaD60G1Vf7am9ZqIc0E8NnuEV/HvqRRlj6ouPh7aR/F9g2tQ==
X-Received: by 2002:ae9:e005:0:b0:46d:cfe5:993 with SMTP id m5-20020ae9e005000000b0046dcfe50993mr170960qkk.138.1646422827466;
        Fri, 04 Mar 2022 11:40:27 -0800 (PST)
Received: from fedora.redhat.com (pool-71-175-3-221.phlapa.fios.verizon.net. [71.175.3.221])
        by smtp.gmail.com with ESMTPSA id e9-20020a05620a014900b005084ce66b44sm2824636qkn.88.2022.03.04.11.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 11:40:26 -0800 (PST)
From:   Tyler Fanelli <tfanelli@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        Tyler Fanelli <tfanelli@redhat.com>
Subject: [PATCH v2] i386/sev: Ensure attestation report length is valid before retrieving
Date:   Fri,  4 Mar 2022 14:37:43 -0500
Message-Id: <20220304193742.506703-1-tfanelli@redhat.com>
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
index 025ff7a6f8..80d958369b 100644
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
+                         " length returned=%d",
+                   input.len);
+        return NULL;
     }
 
     data = g_malloc(input.len);
-- 
2.31.1

