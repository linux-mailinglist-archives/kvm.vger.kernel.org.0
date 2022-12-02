Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D727640536
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 11:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbiLBKvn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 05:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233190AbiLBKvb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 05:51:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317B4D0383
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 02:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669978233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1ZiLhwAB4T5DlsifWPEOUp55KcHRF76jPNns8olDBLs=;
        b=WPTsBkbqKJsyOImXDltiWu8wMeecaWE0BaaaNUlANhWVYDx09xnAzJdPWkUe8LzBpuw5J0
        U4CLGrG533c0X269DNpvIN9oAvV9dcPJgQFEotz5T2S8nu9pNQxCy8sTq7ouRWMOYoqZUt
        z4LnBx4RDcH6pJvfZFd2PSSZRKCMvrA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-205-iPX_SYswNd6Bioj3tIKicg-1; Fri, 02 Dec 2022 05:50:30 -0500
X-MC-Unique: iPX_SYswNd6Bioj3tIKicg-1
Received: by mail-wm1-f72.google.com with SMTP id c126-20020a1c3584000000b003cfffcf7c1aso3968920wma.0
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 02:50:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1ZiLhwAB4T5DlsifWPEOUp55KcHRF76jPNns8olDBLs=;
        b=Mw8twF1sRHMQ2OuKlZJEZRXu9Msd4XmyW3Cn+npNXA+/8ZriC2c563jnT3k1d0jueG
         AL6yJJuOVCZaLK3KECU2eamcGbaj/enhpM8cRJJbgEqxpkbcIqORc+arwOueOUJootV2
         jd1ZqhkPVMHCLbBvRfW1tX/BeTbmCRZ04Twu+ctBORt9zGP/SMNe+8SeQclLykQqMHMB
         NrjhWakPMb4oKtMyi0YJU7pekq0DljIgQIT+MleHbSrVtPhm6nho7Pisno36hf0G1yq0
         Akbhg7bEzit2SGJ8OA4BmJwnEAMIzRB6+UI5SlQolKNwISjGpx4s3V4FGXQsJVyVy0qC
         LacQ==
X-Gm-Message-State: ANoB5plpZoYC5DQBouGSREulVnBD/OD6T2kuz4c6dd9d/whV33+dR2/U
        CK6OgJl6rX2d30YCkittRIthu5JZgzRkvt0TGhtw+WhpJ0qkPSORpizf/kGXKxXubftV6yZXzVb
        S87zPNu+CB3rb
X-Received: by 2002:a05:6000:983:b0:236:aacc:ea07 with SMTP id by3-20020a056000098300b00236aaccea07mr45038552wrb.36.1669978229097;
        Fri, 02 Dec 2022 02:50:29 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5xmf8N/KoyM3E7rvK+vbyjX3grYot4oQfWOk16THK9TJ5D1uAwksRui+qdQ92XRGd+sHEYog==
X-Received: by 2002:a05:6000:983:b0:236:aacc:ea07 with SMTP id by3-20020a056000098300b00236aaccea07mr45038533wrb.36.1669978228835;
        Fri, 02 Dec 2022 02:50:28 -0800 (PST)
Received: from minerva.home (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id bg2-20020a05600c3c8200b003a3170a7af9sm9728818wmb.4.2022.12.02.02.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 02:50:28 -0800 (PST)
From:   Javier Martinez Canillas <javierm@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sergio Lopez Pascual <slp@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Guang Zeng <guang.zeng@intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jing Liu <jing2.liu@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Nicholas Piggin <npiggin@gmail.com>,
        Wei Wang <wei.w.wang@intel.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 3/4] KVM: Reference to kvm_userspace_memory_region in doc and comments
Date:   Fri,  2 Dec 2022 11:50:10 +0100
Message-Id: <20221202105011.185147-4-javierm@redhat.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221202105011.185147-1-javierm@redhat.com>
References: <20221202105011.185147-1-javierm@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are still references to the removed kvm_memory_region data structure
but the doc and comments should mention struct kvm_userspace_memory_region
instead, since that is what's used by the ioctl that replaced the old one
and this data structure support the same set of flags.

Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
---

(no changes since v1)

 Documentation/virt/kvm/api.rst | 2 +-
 include/linux/kvm_host.h       | 4 ++--
 include/uapi/linux/kvm.h       | 6 +++---
 tools/include/uapi/linux/kvm.h | 6 +++---
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 85a5b12eb017..b15ea129f9cf 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1309,7 +1309,7 @@ yet and must be cleared on entry.
 	__u64 userspace_addr; /* start of the userspace allocated memory */
   };
 
-  /* for kvm_memory_region::flags */
+  /* for kvm_userspace_memory_region::flags */
   #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
   #define KVM_MEM_READONLY	(1UL << 1)
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 18592bdf4c1b..759ed18dabb7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -50,8 +50,8 @@
 #endif
 
 /*
- * The bit 16 ~ bit 31 of kvm_memory_region::flags are internally used
- * in kvm, other bits are visible for userspace which are defined in
+ * The bit 16 ~ bit 31 of kvm_userspace_memory_region::flags are internally
+ * used in kvm, other bits are visible for userspace which are defined in
  * include/linux/kvm_h.
  */
 #define KVM_MEMSLOT_INVALID	(1UL << 16)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6ba2928f8f18..e42be6b45b9b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -96,9 +96,9 @@ struct kvm_userspace_memory_region {
 };
 
 /*
- * The bit 0 ~ bit 15 of kvm_memory_region::flags are visible for userspace,
- * other bits are reserved for kvm internal use which are defined in
- * include/linux/kvm_host.h.
+ * The bit 0 ~ bit 15 of kvm_userspace_memory_region::flags are visible for
+ * userspace, other bits are reserved for kvm internal use which are defined
+ * in include/linux/kvm_host.h.
  */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 6ba2928f8f18..21d6d29502e4 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -96,9 +96,9 @@ struct kvm_userspace_memory_region {
 };
 
 /*
- * The bit 0 ~ bit 15 of kvm_memory_region::flags are visible for userspace,
- * other bits are reserved for kvm internal use which are defined in
- * include/linux/kvm_host.h.
+ * The bit 0 ~ bit 15 of kvm_userspace_memory_region::flags are visible for
+ * userspace, other bits are reserved for kvm internal use which are defined
+ *in include/linux/kvm_host.h.
  */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
-- 
2.38.1

