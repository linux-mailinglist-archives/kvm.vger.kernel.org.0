Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D69B31DE34
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 18:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbhBQRbY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 12:31:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbhBQRbN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Feb 2021 12:31:13 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F8DC061574
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 09:30:33 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 194so12809858ybl.5
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 09:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=jHfqonvlMKl1wsgB/F2W/qoXTxBiDKQ8+KEhAtz6vqY=;
        b=PzcnGWb+9YlawHHBzCy0ixjJsg6CAcCZLbYZJPCjxkNLvmnH4MzE58JTFFCBzx1IoZ
         IeMKw+kpNLMNSMaqCBQd6PH+TUwrSLCXGcqfEvUXmNgdEPa21PmkkBqpLDwA/tC2uRGT
         1K66VUnyqGxYkxZ5qtIR5idf035Rwo2ROgzhEX8FdTuLBSqXUhuA23b+JqhrIkpiXtyz
         S1SG6kOWbk7rby4JMKYwTC4ABRaFmev+e8uYejP3K2HVjawu/km+bOD3WdGemy3jWIwG
         azGtQzru9zBdL4aO3SIeZMTEF6qz4z9vbHtTSyyQle9J+BMqBV2d9BhXclosuYX3JFcQ
         8pgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=jHfqonvlMKl1wsgB/F2W/qoXTxBiDKQ8+KEhAtz6vqY=;
        b=dzszYmk/Rvw6krRkJgsEn5FVnmY1XmfvQC91w0rOc1RaWZ3b8WU2aFz3OiFc53jcq+
         vrjl1ebke9hfBj+YAf3lpPFfoweloW6ccx6Qs6MFnz5eeqPIF8EallqUeN3lbpXV4PEU
         LCqnJkv3PwXyOV0gt0Ec21tCaGgE/EKfw+H7B07+wDQuvK7emDxgVtkHpDuAL35/RdCe
         kzztOtMDPOp0D/OExIiE/1tR+1OKS2dWESjqAPke5Wr5Zja8XfQVIl773SqofY0ngHs9
         07TV2bvQLnb9BwiGF4+VGBvJ1TXUwRbIyd50AXY3hrVLnmGV2ICX4gf08ALPkq4acn1E
         qXtw==
X-Gm-Message-State: AOAM53158gOSFt5jzi+RQJ7dBR+H9NbXFmw/UgMYiI69XMhEY+d8p03x
        7wnNPCVxs6qeVXk7Ic+WoVLFsrLM69hc7TkECDTzJKaZMP1RIUcV/w1S8IA9K3X36tShh+QT7/J
        jqrY1HahNR7WzPWtEmGZCLswJLGVwEA5Nj02mT6XbFpJ7G6UJy1bTvebdWRlZ7GKsosGy
X-Google-Smtp-Source: ABdhPJykAOfKVkSiVgyo1aPX35HYdsLlFd9CbcWO7jIpaPUMALw7DAoA8kQIytI/+7X/9Sh/PjZB7o9j2mN6JY1f
Sender: "aaronlewis via sendgmr" <aaronlewis@aaronlewis1.sea.corp.google.com>
X-Received: from aaronlewis1.sea.corp.google.com ([2620:15c:100:202:95fa:4161:5a32:e12])
 (user=aaronlewis job=sendgmr) by 2002:a25:af52:: with SMTP id
 c18mr761621ybj.196.1613583032910; Wed, 17 Feb 2021 09:30:32 -0800 (PST)
Date:   Wed, 17 Feb 2021 09:27:31 -0800
Message-Id: <20210217172730.1521644-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH v2] selftests: kvm: Mmap the entire vcpu mmap area
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, Aaron Lewis <aaronlewis@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Andrew Jones <drjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vcpu mmap area may consist of more than just the kvm_run struct.
Allocate enough space for the entire vcpu mmap area. Without this, on
x86, the PIO page, for example, will be missing.  This is problematic
when dealing with an unhandled exception from the guest as the exception
vector will be incorrectly reported as 0x0.

Co-developed-by: Steve Rutherford <srutherford@google.com>
Signed-off-by: Steve Rutherford <srutherford@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 66 +++++++++++-----------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index fa5a90e6c6f0..a2874e366d0f 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -486,6 +486,37 @@ struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid)
 	return NULL;
 }
 
+/*
+ * VCPU mmap Size
+ *
+ * Input Args: None
+ *
+ * Output Args: None
+ *
+ * Return:
+ *   Size of VCPU state
+ *
+ * Returns the size of the structure pointed to by the return value
+ * of vcpu_state().
+ */
+static int vcpu_mmap_sz(void)
+{
+	int dev_fd, ret;
+
+	dev_fd = open(KVM_DEV_PATH, O_RDONLY);
+	if (dev_fd < 0)
+		exit(KSFT_SKIP);
+
+	ret = ioctl(dev_fd, KVM_GET_VCPU_MMAP_SIZE, NULL);
+	TEST_ASSERT(ret >= sizeof(struct kvm_run),
+		"%s KVM_GET_VCPU_MMAP_SIZE ioctl failed, rc: %i errno: %i",
+		__func__, ret, errno);
+
+	close(dev_fd);
+
+	return ret;
+}
+
 /*
  * VM VCPU Remove
  *
@@ -509,7 +540,7 @@ static void vm_vcpu_rm(struct kvm_vm *vm, struct vcpu *vcpu)
 		vcpu->dirty_gfns = NULL;
 	}
 
-	ret = munmap(vcpu->state, sizeof(*vcpu->state));
+	ret = munmap(vcpu->state, vcpu_mmap_sz());
 	TEST_ASSERT(ret == 0, "munmap of VCPU fd failed, rc: %i "
 		"errno: %i", ret, errno);
 	close(vcpu->fd);
@@ -909,37 +940,6 @@ void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot)
 	__vm_mem_region_delete(vm, memslot2region(vm, slot));
 }
 
-/*
- * VCPU mmap Size
- *
- * Input Args: None
- *
- * Output Args: None
- *
- * Return:
- *   Size of VCPU state
- *
- * Returns the size of the structure pointed to by the return value
- * of vcpu_state().
- */
-static int vcpu_mmap_sz(void)
-{
-	int dev_fd, ret;
-
-	dev_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (dev_fd < 0)
-		exit(KSFT_SKIP);
-
-	ret = ioctl(dev_fd, KVM_GET_VCPU_MMAP_SIZE, NULL);
-	TEST_ASSERT(ret >= sizeof(struct kvm_run),
-		"%s KVM_GET_VCPU_MMAP_SIZE ioctl failed, rc: %i errno: %i",
-		__func__, ret, errno);
-
-	close(dev_fd);
-
-	return ret;
-}
-
 /*
  * VM VCPU Add
  *
@@ -978,7 +978,7 @@ void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid)
 	TEST_ASSERT(vcpu_mmap_sz() >= sizeof(*vcpu->state), "vcpu mmap size "
 		"smaller than expected, vcpu_mmap_sz: %i expected_min: %zi",
 		vcpu_mmap_sz(), sizeof(*vcpu->state));
-	vcpu->state = (struct kvm_run *) mmap(NULL, sizeof(*vcpu->state),
+	vcpu->state = (struct kvm_run *) mmap(NULL, vcpu_mmap_sz(),
 		PROT_READ | PROT_WRITE, MAP_SHARED, vcpu->fd, 0);
 	TEST_ASSERT(vcpu->state != MAP_FAILED, "mmap vcpu_state failed, "
 		"vcpu id: %u errno: %i", vcpuid, errno);
-- 
2.30.0.478.g8a0d178c01-goog

