Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006EC57C146
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 02:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiGUAD2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 20:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbiGUAD0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 20:03:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B9344743FB
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 17:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658361804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=17Vp4Ex87tn6Uk/BpRm2TxdVL2JJUXYS9NeIPo0wplg=;
        b=EcWfdj4C+RULS3swIwtT6bJTVZVlKBudT09igcl9kYdbYSREsqI0TcIe/yWLgseN80oQtz
        uzP0RyLnSKo3B21mS+DutOSSFt+7FiqmuowdYyQ86n2FHCBFhDJ+wRgaLCdNNMyQdtkIGA
        844d1KXxsDNd9oDhYyzbneZheDTm2vs=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-59-fYrtD-xvP3GpAuyXpvIofw-1; Wed, 20 Jul 2022 20:03:23 -0400
X-MC-Unique: fYrtD-xvP3GpAuyXpvIofw-1
Received: by mail-qv1-f71.google.com with SMTP id e1-20020ad44181000000b00472f8ad6e71so10532735qvp.20
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 17:03:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=17Vp4Ex87tn6Uk/BpRm2TxdVL2JJUXYS9NeIPo0wplg=;
        b=a/EgyeHPC6iTMQO7H8AwnJyvtrAdqCj4m4qU9kXm/a7zWUflnK9vL5eCd+276zIohb
         x9C7O1phheT5mGONP302AF13szGUwZbMdVM5htXLnkMkfBd5DonutpEoddG2YSMxpI9h
         vf/1Dgv+zgfCwAczWLZHimKrr3HKsdceoux9/j3OGYm1STex5oDXwvJ7wWWq5zUroJ5O
         sjn13JGyq48ufy7dbbCdCzh3MnsxigasYDqasKl3Ijmzl6gI+i2r5qQuHTFeJtsyt9lQ
         MYHLLqR++zsBXzgLRbFXOUaMg/KL8ANXThx7knflhoRRogTFnk3I594IRuwdmCp2CTYn
         R0xA==
X-Gm-Message-State: AJIora9B2o/m7AVfXtq12v8WuN/xeL2BLYoJ1rR6g8nRw4vvvao+hLiv
        peWvre6jkxfyhx8LondqsZSXPunv0Lsj7wc4XGgmvQuU6ff1MIia2M5cznzncNyBiIF5gVb00uv
        +M2TxLU6j6BZz
X-Received: by 2002:a0c:b284:0:b0:472:6e5e:e2f0 with SMTP id r4-20020a0cb284000000b004726e5ee2f0mr32317991qve.90.1658361803306;
        Wed, 20 Jul 2022 17:03:23 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s1+KU5FgF3m6vx4q4MlpqxGLoNsyQhiNfjM06PJt/2rXTILbIrwzzfnLXh7xwYd1LxLFugOw==
X-Received: by 2002:a0c:b284:0:b0:472:6e5e:e2f0 with SMTP id r4-20020a0cb284000000b004726e5ee2f0mr32317973qve.90.1658361803125;
        Wed, 20 Jul 2022 17:03:23 -0700 (PDT)
Received: from localhost.localdomain (bras-base-aurron9127w-grc-37-74-12-30-48.dsl.bell.ca. [74.12.30.48])
        by smtp.gmail.com with ESMTPSA id g4-20020ac87f44000000b0031eb3af3ffesm418640qtk.52.2022.07.20.17.03.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 20 Jul 2022 17:03:22 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com,
        John Hubbard <jhubbard@nvidia.com>,
        Sean Christopherson <seanjc@google.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v2 2/3] kvm: Add new pfn error KVM_PFN_ERR_SIGPENDING
Date:   Wed, 20 Jul 2022 20:03:17 -0400
Message-Id: <20220721000318.93522-3-peterx@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220721000318.93522-1-peterx@redhat.com>
References: <20220721000318.93522-1-peterx@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add one new PFN error type to show when we got interrupted when fetching
the PFN due to signal pending.

This prepares KVM to be able to respond to SIGUSR1 (for QEMU that's the
SIGIPI) even during e.g. handling an userfaultfd page fault.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/kvm_host.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 83cf7fd842e0..06a5b17d3679 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -96,6 +96,7 @@
 #define KVM_PFN_ERR_FAULT	(KVM_PFN_ERR_MASK)
 #define KVM_PFN_ERR_HWPOISON	(KVM_PFN_ERR_MASK + 1)
 #define KVM_PFN_ERR_RO_FAULT	(KVM_PFN_ERR_MASK + 2)
+#define KVM_PFN_ERR_SIGPENDING	(KVM_PFN_ERR_MASK + 3)
 
 /*
  * error pfns indicate that the gfn is in slot but faild to
@@ -106,6 +107,16 @@ static inline bool is_error_pfn(kvm_pfn_t pfn)
 	return !!(pfn & KVM_PFN_ERR_MASK);
 }
 
+/*
+ * When KVM_PFN_ERR_SIGPENDING returned, it means we're interrupted during
+ * fetching the PFN (a signal might have arrived), we may want to retry at
+ * some later point and kick the userspace to handle the signal.
+ */
+static inline bool is_sigpending_pfn(kvm_pfn_t pfn)
+{
+	return pfn == KVM_PFN_ERR_SIGPENDING;
+}
+
 /*
  * error_noslot pfns indicate that the gfn can not be
  * translated to pfn - it is not in slot or failed to
-- 
2.32.0

