Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4499154EEEA
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 03:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379588AbiFQBmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 21:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379458AbiFQBmB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 21:42:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D2A263BD7
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 18:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655430119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ghHac7UV1N6vPGfjk7ojRXZFbMUyEtSeJQo5S/wAoOg=;
        b=UrS3mwPEcs57xDdDkIykHFCj1GTK5Lk8UVCsdou1GwUeeQVytItXPFp321+7kCaqqG7P3A
        FucUGVETLCwrF1Vpa/pvzT3GjZ0kO43aZwave4rqWHLL2VBKEV22AfUANII7dcemPklRsu
        RqTS9dh3eaz6/pxfkajXPUAp1WQ1XsM=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-267-VR95ee9kOjCqRErhvPE5WQ-1; Thu, 16 Jun 2022 21:41:57 -0400
X-MC-Unique: VR95ee9kOjCqRErhvPE5WQ-1
Received: by mail-il1-f200.google.com with SMTP id e4-20020a056e020b2400b002d5509de6f3so1827568ilu.6
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 18:41:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ghHac7UV1N6vPGfjk7ojRXZFbMUyEtSeJQo5S/wAoOg=;
        b=Hjyq5fjDtTYKEaj4avcmAPu2NrM7UT8ZMyULVo7nP/eil7JLhjxiz+pHfhHadV9+Nx
         9HmvS2v5o4nQC8mPhPtPiMpmK9f4fekJehPQe8OxzwxIBJDOevNMq+joOaqMqKpdHejU
         xw1z4skAWMg6VArYB88xq3wV7OvCJ6XxafR4fDxQ+NbT2fBn8SiIUlBGjhbg4qnrzyAY
         kIi/y6Pu8hEsLietjseS9ONyj2tzER8BHdkr3YnJCuX382oai7+xkY18nOa6hlE5mhDK
         aAJL5SJ4sUEj+XHCDr0KBSWvFnHAvpT+uCgN7lGIH8uH4NWONe55SmJWbt4kINp/7+oQ
         +54Q==
X-Gm-Message-State: AJIora9G09nh2jbIF5R8O9M6OEt4EMNlaKexTbcmk/c2/qaYIwmhdbez
        AhdcLdaLF3a7uQw2FvEoIQjXRABy2iPwICArjBA/kL7FuOYMF3cbcssnkcT/u8KLRTMDcxq69ti
        J5c4c+2D2Wg252Jcm2S2nXAu4iiyjF06hhu0wuiYr8CL/JUOj4tng+9RxdH4pJw==
X-Received: by 2002:a05:6e02:811:b0:2d5:2294:ff37 with SMTP id u17-20020a056e02081100b002d52294ff37mr4319995ilm.249.1655430116808;
        Thu, 16 Jun 2022 18:41:56 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vkkfMz7cqp5MF8GJOCZIECqzgeFNO0MvlQHMdn1ovMhxzPuVoVfsfN47FOLsLaed4L90CO1w==
X-Received: by 2002:a05:6e02:811:b0:2d5:2294:ff37 with SMTP id u17-20020a056e02081100b002d52294ff37mr4319979ilm.249.1655430116477;
        Thu, 16 Jun 2022 18:41:56 -0700 (PDT)
Received: from localhost.localdomain (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id n4-20020a056e02140400b002d522958fb4sm1726538ilo.2.2022.06.16.18.41.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 16 Jun 2022 18:41:56 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, peterx@redhat.com
Subject: [PATCH RFC 3/4] kvm: Add new pfn error KVM_PFN_ERR_INTR
Date:   Thu, 16 Jun 2022 21:41:46 -0400
Message-Id: <20220617014147.7299-4-peterx@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220617014147.7299-1-peterx@redhat.com>
References: <20220617014147.7299-1-peterx@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add one new PFN error type to show when we cannot finish fetching the PFN
due to interruptions.  For example, by receiving a generic signal.

This prepares KVM to be able to respond to SIGUSR1 (for QEMU that's the
SIGIPI) even during e.g. handling an userfaultfd page fault.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/kvm_host.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b646b6fcaec6..4f84a442f67f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -96,6 +96,7 @@
 #define KVM_PFN_ERR_FAULT	(KVM_PFN_ERR_MASK)
 #define KVM_PFN_ERR_HWPOISON	(KVM_PFN_ERR_MASK + 1)
 #define KVM_PFN_ERR_RO_FAULT	(KVM_PFN_ERR_MASK + 2)
+#define KVM_PFN_ERR_INTR	(KVM_PFN_ERR_MASK + 3)
 
 /*
  * error pfns indicate that the gfn is in slot but faild to
@@ -106,6 +107,16 @@ static inline bool is_error_pfn(kvm_pfn_t pfn)
 	return !!(pfn & KVM_PFN_ERR_MASK);
 }
 
+/*
+ * When KVM_PFN_ERR_INTR is returned, it means we're interrupted during
+ * fetching the PFN (e.g. a signal might have arrived), so we may want to
+ * retry at some later point and kick the userspace to handle the signal.
+ */
+static inline bool is_intr_pfn(kvm_pfn_t pfn)
+{
+	return pfn == KVM_PFN_ERR_INTR;
+}
+
 /*
  * error_noslot pfns indicate that the gfn can not be
  * translated to pfn - it is not in slot or failed to
-- 
2.32.0

