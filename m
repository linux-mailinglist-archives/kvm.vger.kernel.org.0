Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E35640532
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 11:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbiLBKvf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 05:51:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbiLBKv1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 05:51:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44CDAD038D
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 02:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669978230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+/LEkekaTEo+dH48I9BDoWLnS9MzBRMjobxYQkKyym4=;
        b=fP9WQb7rAsmiUFRtHvgCrUtel4UX2bUjpAo5/oFO2JadiGwh5uWyEvxB3YawQk3vZNtLnl
        ULnbSeJvN+t+acSBtynA/Ow3mwcbS2+rh8b9M6aMwb9v6oOHVSpvn6fUMs8yMFJyD7f8Dr
        iROAd4axaMERiQBEzFT5fnsXJTmEemc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-178-uR4UC7nOMWGC8_tDHL7Qdw-1; Fri, 02 Dec 2022 05:50:28 -0500
X-MC-Unique: uR4UC7nOMWGC8_tDHL7Qdw-1
Received: by mail-wm1-f69.google.com with SMTP id c187-20020a1c35c4000000b003cfee3c91cdso2314775wma.6
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 02:50:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+/LEkekaTEo+dH48I9BDoWLnS9MzBRMjobxYQkKyym4=;
        b=RWwNEFPSdigIjq2uJs6lhianzsFnOhe5T15KgdirIN7h2jLDp7agq3NjVPwjbpWe/F
         EEBt8onrZLENxdSjbEw/3QBFCADycUo9KMWftZjxBVMkOggwVRuV42aK3N/fzivuFXWC
         +aNZ3k6ppvwRcMquQAgwLGi93Emq5OWNC8jtQNWWDEVz5cjOjoClfDUr6aPYJXbIeY52
         NnEKIBZHGZj/coUWaS9odlWaowpiKpTwk62w+jRrJ/dMgreSoZtndI03JmzA7IygQ8+b
         64xzFsxK6H4DmGVLKq0HenVhrXdnw82lrs4fp7kFQK1xhc9P/ufuBfeqqQgm57N3sKDs
         wB4Q==
X-Gm-Message-State: ANoB5plqep8MIEkJ1VAcWlUG/Oz772F6Zpo882cLo8EZQMK5kHzswj+G
        FurNXIfsSFugLDNMJR/R29SRJNeOXNXMn8x96yyAZdFEY6IdNumeIl8nge9blsFp7BQKEZRoiYE
        MEjaT5isQUPLc
X-Received: by 2002:a1c:2743:0:b0:3c6:e471:7400 with SMTP id n64-20020a1c2743000000b003c6e4717400mr38026477wmn.98.1669978227533;
        Fri, 02 Dec 2022 02:50:27 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6LRw+Q5h08VxPWoFG1o+HyiLNocv2IiuqIXrVvaQwPWzbHSZnbDyo9D+lrAYgNTlYhm9tRrQ==
X-Received: by 2002:a1c:2743:0:b0:3c6:e471:7400 with SMTP id n64-20020a1c2743000000b003c6e4717400mr38026452wmn.98.1669978227323;
        Fri, 02 Dec 2022 02:50:27 -0800 (PST)
Received: from minerva.home (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id bg2-20020a05600c3c8200b003a3170a7af9sm9728818wmb.4.2022.12.02.02.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 02:50:26 -0800 (PST)
From:   Javier Martinez Canillas <javierm@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sergio Lopez Pascual <slp@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jing Liu <jing2.liu@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Nicholas Piggin <npiggin@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wei Wang <wei.w.wang@intel.com>,
        Yang Zhong <yang.zhong@intel.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, x86@kernel.org
Subject: [PATCH v2 2/4] KVM: Delete all references to removed KVM_SET_MEMORY_ALIAS ioctl
Date:   Fri,  2 Dec 2022 11:50:09 +0100
Message-Id: <20221202105011.185147-3-javierm@redhat.com>
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

The documentation says that the ioctl has been deprecated, but it has been
actually removed and the remaining references are just left overs.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
---

(no changes since v1)

 Documentation/virt/kvm/api.rst        | 11 -----------
 arch/x86/include/uapi/asm/kvm.h       |  8 --------
 include/uapi/linux/kvm.h              |  2 --
 tools/arch/x86/include/uapi/asm/kvm.h |  8 --------
 tools/include/uapi/linux/kvm.h        |  2 --
 5 files changed, 31 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 54af33645df3..85a5b12eb017 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -356,17 +356,6 @@ see the description of the capability.
 Note that the Xen shared info page, if configured, shall always be assumed
 to be dirty. KVM will not explicitly mark it such.
 
-4.9 KVM_SET_MEMORY_ALIAS
-------------------------
-
-:Capability: basic
-:Architectures: x86
-:Type: vm ioctl
-:Parameters: struct kvm_memory_alias (in)
-:Returns: 0 (success), -1 (error)
-
-This ioctl is obsolete and has been removed.
-
 
 4.10 KVM_RUN
 ------------
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 46de10a809ec..649e50a8f9dd 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -53,14 +53,6 @@
 /* Architectural interrupt line count. */
 #define KVM_NR_INTERRUPTS 256
 
-struct kvm_memory_alias {
-	__u32 slot;  /* this has a different namespace than memory slots */
-	__u32 flags;
-	__u64 guest_phys_addr;
-	__u64 memory_size;
-	__u64 target_phys_addr;
-};
-
 /* for KVM_GET_IRQCHIP and KVM_SET_IRQCHIP */
 struct kvm_pic_state {
 	__u8 last_irr;	/* edge detection */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 8899201d5964..6ba2928f8f18 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1435,8 +1435,6 @@ struct kvm_vfio_spapr_tce {
  */
 #define KVM_CREATE_VCPU           _IO(KVMIO,   0x41)
 #define KVM_GET_DIRTY_LOG         _IOW(KVMIO,  0x42, struct kvm_dirty_log)
-/* KVM_SET_MEMORY_ALIAS is obsolete: */
-#define KVM_SET_MEMORY_ALIAS      _IOW(KVMIO,  0x43, struct kvm_memory_alias)
 #define KVM_SET_NR_MMU_PAGES      _IO(KVMIO,   0x44)
 #define KVM_GET_NR_MMU_PAGES      _IO(KVMIO,   0x45)
 #define KVM_SET_USER_MEMORY_REGION _IOW(KVMIO, 0x46, \
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 46de10a809ec..649e50a8f9dd 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -53,14 +53,6 @@
 /* Architectural interrupt line count. */
 #define KVM_NR_INTERRUPTS 256
 
-struct kvm_memory_alias {
-	__u32 slot;  /* this has a different namespace than memory slots */
-	__u32 flags;
-	__u64 guest_phys_addr;
-	__u64 memory_size;
-	__u64 target_phys_addr;
-};
-
 /* for KVM_GET_IRQCHIP and KVM_SET_IRQCHIP */
 struct kvm_pic_state {
 	__u8 last_irr;	/* edge detection */
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 8899201d5964..6ba2928f8f18 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1435,8 +1435,6 @@ struct kvm_vfio_spapr_tce {
  */
 #define KVM_CREATE_VCPU           _IO(KVMIO,   0x41)
 #define KVM_GET_DIRTY_LOG         _IOW(KVMIO,  0x42, struct kvm_dirty_log)
-/* KVM_SET_MEMORY_ALIAS is obsolete: */
-#define KVM_SET_MEMORY_ALIAS      _IOW(KVMIO,  0x43, struct kvm_memory_alias)
 #define KVM_SET_NR_MMU_PAGES      _IO(KVMIO,   0x44)
 #define KVM_GET_NR_MMU_PAGES      _IO(KVMIO,   0x45)
 #define KVM_SET_USER_MEMORY_REGION _IOW(KVMIO, 0x46, \
-- 
2.38.1

