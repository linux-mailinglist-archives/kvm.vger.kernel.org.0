Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 881D27A2C86
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 02:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238970AbjIPAe6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 20:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239036AbjIPAeV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 20:34:21 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988E1271C
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:31:31 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c448ba292dso5561075ad.3
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824291; x=1695429091; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=C0sn2AnVcRbsYEvqFgh4BzWbc2uKAyyxP92cnWXv5Gc=;
        b=jvDBnkFi8COrquzeFvzZe1NGIcw2+MdT3qMRI4S7MM7TtszA/o4dFGVmucHUardQ0N
         nGh/1bkIjVTOZz4YECMI/AWeidonXnZiVATf/POPsl2fjOLRExjl3/OV0GV3vw5y5BjP
         6YYSZ48XUlyCXQuzXpGRve5bffxA0OSzOhkTIJj8ObEZO9M3vcX8ub2TXheKDnfYpGDJ
         WW9O9i8K/UqxEYpWt+N+D4xO1KLq5GpE5gSkZQbgtA2XIpHKtfv5EX2VrBgQz1Hb2oK6
         aDcZuaC1yLFZfkK0plhW0iiZN+cRhrYegjy5+73NURC3ACgUCig5UVuHKxhPx6BM7Ra4
         PyYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824291; x=1695429091;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C0sn2AnVcRbsYEvqFgh4BzWbc2uKAyyxP92cnWXv5Gc=;
        b=ZxyiN4IGIuMWGDFCpS1V8d4enAhKGeZygzoaqln+v5C9gEPjvlF6gDV8p8BMLF/DuF
         xBMng0pxmmRslwDczWPVYJ9hjZ4Z3fiQiXXmOB9p3CLkydFktSD+PegHGWCy6KrZmbAo
         0LlDL2TsKJI3C9R9vJJP1uU1Cd7d7gG2kP3OWL2nYO0NYAKZsSiHkWhVhVY9FxTvxbep
         bDBYo3Y5q3hIMf3FImpUCJiBrrWJgz4ZxN7bxAa84MEZT1VEkkAMfrWM4n23ce37Gwhw
         a4pzmzb9NpePVvZfwxLXE0vjdioIAJLG+Gmdqs3T8xAa/IlMFrUwW5e9yPR2usbRfxX8
         lZrA==
X-Gm-Message-State: AOJu0Yz1uuQsfgi6c/IBKt0WzX7MAQ8jKf8+D/4MNpbpdPXXdQaivYKn
        8cUPxsyXf1nxJHEeChZus2EtTaulpDc=
X-Google-Smtp-Source: AGHT+IHtRyj8S1iXRa1AyuzUMEtuqAzbJZbP2iFNCt3KVQZXM+xbuQMnV6uSJ406DSy/keoiXYz83X05kPo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:41c2:b0:1c1:fbec:bc39 with SMTP id
 u2-20020a17090341c200b001c1fbecbc39mr73146ple.4.1694824290982; Fri, 15 Sep
 2023 17:31:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Sep 2023 17:30:57 -0700
In-Reply-To: <20230916003118.2540661-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003118.2540661-6-seanjc@google.com>
Subject: [PATCH 05/26] vfio: KVM: Pass get/put helpers from KVM to VFIO, don't
 do circular lookup
From:   Sean Christopherson <seanjc@google.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andy Lutomirski <luto@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Anish Ghulati <aghulati@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        Andrew Thornton <andrewth@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly pass KVM's get/put helpers to VFIO when attaching a VM to
VFIO instead of having VFIO do a symbol lookup back into KVM.  Having both
KVM and VFIO do symbol lookups increases the overall complexity and places
an unnecessary dependency on KVM (from VFIO) without adding any value.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/vfio/vfio.h      |  2 ++
 drivers/vfio/vfio_main.c | 74 +++++++++++++++++++---------------------
 include/linux/vfio.h     |  4 ++-
 virt/kvm/vfio.c          |  9 +++--
 4 files changed, 47 insertions(+), 42 deletions(-)

diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index a1f741365075..eec51c7ee822 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -19,6 +19,8 @@ struct vfio_container;
 
 struct vfio_kvm_reference {
 	struct kvm			*kvm;
+	bool				(*get_kvm)(struct kvm *kvm);
+	void				(*put_kvm)(struct kvm *kvm);
 	spinlock_t			lock;
 };
 
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index e77e8c6aae2f..1f58ab6dbcd2 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -16,7 +16,6 @@
 #include <linux/fs.h>
 #include <linux/idr.h>
 #include <linux/iommu.h>
-#include <linux/kvm_host.h>
 #include <linux/list.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
@@ -1306,38 +1305,22 @@ EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
 void vfio_device_get_kvm_safe(struct vfio_device *device,
 			      struct vfio_kvm_reference *ref)
 {
-	void (*pfn)(struct kvm *kvm);
-	bool (*fn)(struct kvm *kvm);
-	bool ret;
-
 	lockdep_assert_held(&device->dev_set->lock);
 
+	/*
+	 * Note!  The "kvm" and "put_kvm" pointers *must* be transferred to the
+	 * device so that the device can put its reference to KVM.  KVM can
+	 * invoke vfio_device_set_kvm() to detach from VFIO, i.e. nullify all
+	 * pointers in @ref, even if a device holds a reference to KVM!  That
+	 * also means that detaching KVM from VFIO only prevents "new" devices
+	 * from using KVM, it doesn't invalidate KVM references in existing
+	 * devices.
+	 */
 	spin_lock(&ref->lock);
-
-	if (!ref->kvm)
-		goto out;
-
-	pfn = symbol_get(kvm_put_kvm);
-	if (WARN_ON(!pfn))
-		goto out;
-
-	fn = symbol_get(kvm_get_kvm_safe);
-	if (WARN_ON(!fn)) {
-		symbol_put(kvm_put_kvm);
-		goto out;
+	if (ref->kvm && ref->get_kvm(ref->kvm)) {
+		device->kvm = ref->kvm;
+		device->put_kvm = ref->put_kvm;
 	}
-
-	ret = fn(ref->kvm);
-	symbol_put(kvm_get_kvm_safe);
-	if (!ret) {
-		symbol_put(kvm_put_kvm);
-		goto out;
-	}
-
-	device->put_kvm = pfn;
-	device->kvm = ref->kvm;
-
-out:
 	spin_unlock(&ref->lock);
 }
 
@@ -1353,28 +1336,37 @@ void vfio_device_put_kvm(struct vfio_device *device)
 
 	device->put_kvm(device->kvm);
 	device->put_kvm = NULL;
-	symbol_put(kvm_put_kvm);
-
 clear:
 	device->kvm = NULL;
 }
 
 static void vfio_device_set_kvm(struct vfio_kvm_reference *ref,
-				struct kvm *kvm)
+				struct kvm *kvm,
+				bool (*get_kvm)(struct kvm *kvm),
+				void (*put_kvm)(struct kvm *kvm))
 {
+	if (WARN_ON_ONCE(kvm && (!get_kvm || !put_kvm)))
+		return;
+
 	spin_lock(&ref->lock);
 	ref->kvm = kvm;
+	ref->get_kvm = get_kvm;
+	ref->put_kvm = put_kvm;
 	spin_unlock(&ref->lock);
 }
 
-static void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm)
+static void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm,
+			       bool (*get_kvm)(struct kvm *kvm),
+			       void (*put_kvm)(struct kvm *kvm))
 {
 #if IS_ENABLED(CONFIG_VFIO_GROUP)
-	vfio_device_set_kvm(&group->kvm_ref, kvm);
+	vfio_device_set_kvm(&group->kvm_ref, kvm, get_kvm, put_kvm);
 #endif
 }
 
-static void vfio_device_file_set_kvm(struct file *file, struct kvm *kvm)
+static void vfio_device_file_set_kvm(struct file *file, struct kvm *kvm,
+				     bool (*get_kvm)(struct kvm *kvm),
+				     void (*put_kvm)(struct kvm *kvm))
 {
 	struct vfio_device_file *df = file->private_data;
 
@@ -1383,27 +1375,31 @@ static void vfio_device_file_set_kvm(struct file *file, struct kvm *kvm)
 	 * be propagated to vfio_device::kvm when the file is bound to
 	 * iommufd successfully in the vfio device cdev path.
 	 */
-	vfio_device_set_kvm(&df->kvm_ref, kvm);
+	vfio_device_set_kvm(&df->kvm_ref, kvm, get_kvm, put_kvm);
 }
 
 /**
  * vfio_file_set_kvm - Link a kvm with VFIO drivers
  * @file: VFIO group file or VFIO device file
  * @kvm: KVM to link
+ * @get_kvm: Callback to get a reference to @kvm
+ * @put_kvm: Callback to put a reference to @kvm
  *
  * When a VFIO device is first opened the KVM will be available in
  * device->kvm if one was associated with the file.
  */
-void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
+void vfio_file_set_kvm(struct file *file, struct kvm *kvm,
+		       bool (*get_kvm)(struct kvm *kvm),
+		       void (*put_kvm)(struct kvm *kvm))
 {
 	struct vfio_group *group;
 
 	group = vfio_group_from_file(file);
 	if (group)
-		vfio_group_set_kvm(group, kvm);
+		vfio_group_set_kvm(group, kvm, get_kvm, put_kvm);
 
 	if (vfio_device_from_file(file))
-		vfio_device_file_set_kvm(file, kvm);
+		vfio_device_file_set_kvm(file, kvm, get_kvm, put_kvm);
 }
 EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
 #endif
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e80955de266c..35e970e3d3fb 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -312,7 +312,9 @@ static inline bool vfio_file_has_dev(struct file *file, struct vfio_device *devi
 bool vfio_file_is_valid(struct file *file);
 bool vfio_file_enforced_coherent(struct file *file);
 #if IS_ENABLED(CONFIG_KVM)
-void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
+void vfio_file_set_kvm(struct file *file, struct kvm *kvm,
+		       bool (*get_kvm)(struct kvm *kvm),
+		       void (*put_kvm)(struct kvm *kvm));
 #endif
 
 #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index ca24ce120906..f14fcbb34bc6 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -37,13 +37,18 @@ struct kvm_vfio {
 
 static void kvm_vfio_file_set_kvm(struct file *file, struct kvm *kvm)
 {
-	void (*fn)(struct file *file, struct kvm *kvm);
+	void (*fn)(struct file *file, struct kvm *kvm,
+		   bool (*get_kvm)(struct kvm *kvm),
+		   void (*put_kvm)(struct kvm *kvm));
 
 	fn = symbol_get(vfio_file_set_kvm);
 	if (!fn)
 		return;
 
-	fn(file, kvm);
+	if (kvm)
+		fn(file, kvm, kvm_get_kvm_safe, kvm_put_kvm);
+	else
+		fn(file, kvm, NULL, NULL);
 
 	symbol_put(vfio_file_set_kvm);
 }
-- 
2.42.0.459.ge4e396fd5e-goog

