Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1A76FE054
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 16:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237280AbjEJOcF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 10:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237237AbjEJOcE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 10:32:04 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187C511D
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 07:32:01 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pwkQy-00GlQt-HP; Wed, 10 May 2023 16:04:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=Jq5qoPFv4LzNUNRqyEJ72HTDY3B03nyAi8dIfseclDA=; b=nIiO9EjI3leMNVU95lUg3aE7Lz
        V4pCrEuhQXyC+86oxEy3Zbe06kkRIB6k5JscQdCDxKcNJqbfKO/r29LKauQxyqMs2HBYTPxxZONo+
        xJ1Zp0/huRV8QOic8nHJ3urACVuPaO1ppGjV9ZDDGhOCEFd/IMosokGN54YkcWgEoc+0R4LMOgrXA
        bACQiUgVECxCH1lpUla0/lZON/HzH/8vNAP1YzBZFh1lh7BCLBLywq9UkVsQvaZW3g7WU1xj71AL7
        A9j2DcbLCU3+bKZqZirt4JLf8DvWO9rvDlt7OIlB3eXYweMUzfS+yyMuGLt/0olrQQvtwag5vKzw2
        ovujPjWw==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pwkQy-0007b3-5u; Wed, 10 May 2023 16:04:48 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pwkQm-0003HK-CS; Wed, 10 May 2023 16:04:36 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, shuah@kernel.org, Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 1/2] KVM: Fix vcpu_array[0] races
Date:   Wed, 10 May 2023 16:04:09 +0200
Message-Id: <20230510140410.1093987-2-mhal@rbox.co>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230510140410.1093987-1-mhal@rbox.co>
References: <20230510140410.1093987-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In kvm_vm_ioctl_create_vcpu(), add vcpu to vcpu_array iff it's safe to
access vcpu via kvm_get_vcpu() and kvm_for_each_vcpu(), i.e. when there's
no failure path requiring vcpu removal and destruction. Such order is
important because vcpu_array accessors may end up referencing vcpu at
vcpu_array[0] even before online_vcpus is set to 1.

When online_vcpus=0, any call to kvm_get_vcpu() goes through
array_index_nospec() and ends with an attempt to xa_load(vcpu_array, 0):

	int num_vcpus = atomic_read(&kvm->online_vcpus);
	i = array_index_nospec(i, num_vcpus);
	return xa_load(&kvm->vcpu_array, i);

Similarly, when online_vcpus=0, a kvm_for_each_vcpu() does not iterate over
an "empty" range, but actually [0, ULONG_MAX]:

	xa_for_each_range(&kvm->vcpu_array, idx, vcpup, 0, \
			  (atomic_read(&kvm->online_vcpus) - 1))

In both cases, such online_vcpus=0 edge case, even if leading to
unnecessary calls to XArray API, should not be an issue; requesting
unpopulated indexes/ranges is handled by xa_load() and xa_for_each_range().

However, this means that when the first vCPU is created and inserted in
vcpu_array *and* before online_vcpus is incremented, code calling
kvm_get_vcpu()/kvm_for_each_vcpu() already has access to that first vCPU.

This should not pose a problem assuming that once a vcpu is stored in
vcpu_array, it will remain there, but that's not the case:
kvm_vm_ioctl_create_vcpu() first inserts to vcpu_array, then requests a
file descriptor. If create_vcpu_fd() fails, newly inserted vcpu is removed
from the vcpu_array, then destroyed:

	vcpu->vcpu_idx = atomic_read(&kvm->online_vcpus);
	r = xa_insert(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, GFP_KERNEL_ACCOUNT);
	kvm_get_kvm(kvm);
	r = create_vcpu_fd(vcpu);
	if (r < 0) {
		xa_erase(&kvm->vcpu_array, vcpu->vcpu_idx);
		kvm_put_kvm_no_destroy(kvm);
		goto unlock_vcpu_destroy;
	}
	atomic_inc(&kvm->online_vcpus);

This results in a possible race condition when a reference to a vcpu is
acquired (via kvm_get_vcpu() or kvm_for_each_vcpu()) moments before said
vcpu is destroyed.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 virt/kvm/kvm_main.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cb5c13eee193..56087ddf97f8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3962,18 +3962,19 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	}
 
 	vcpu->vcpu_idx = atomic_read(&kvm->online_vcpus);
-	r = xa_insert(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, GFP_KERNEL_ACCOUNT);
-	BUG_ON(r == -EBUSY);
+	r = xa_reserve(&kvm->vcpu_array, vcpu->vcpu_idx, GFP_KERNEL_ACCOUNT);
 	if (r)
 		goto unlock_vcpu_destroy;
 
 	/* Now it's all set up, let userspace reach it */
 	kvm_get_kvm(kvm);
 	r = create_vcpu_fd(vcpu);
-	if (r < 0) {
-		xa_erase(&kvm->vcpu_array, vcpu->vcpu_idx);
-		kvm_put_kvm_no_destroy(kvm);
-		goto unlock_vcpu_destroy;
+	if (r < 0)
+		goto kvm_put_xa_release;
+
+	if (KVM_BUG_ON(!!xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0), kvm)) {
+		r = -EINVAL;
+		goto kvm_put_xa_release;
 	}
 
 	/*
@@ -3988,6 +3989,9 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	kvm_create_vcpu_debugfs(vcpu);
 	return r;
 
+kvm_put_xa_release:
+	kvm_put_kvm_no_destroy(kvm);
+	xa_release(&kvm->vcpu_array, vcpu->vcpu_idx);
 unlock_vcpu_destroy:
 	mutex_unlock(&kvm->lock);
 	kvm_dirty_ring_free(&vcpu->dirty_ring);
-- 
2.40.1

