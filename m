Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B33F65EABF0
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 18:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbiIZQDe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 12:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbiIZQCi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 12:02:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E2472B78
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 07:51:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD62760E83
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 14:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA13C43149;
        Mon, 26 Sep 2022 14:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664203886;
        bh=Vt4MpZxy9cA0Z6Nr6FBms3xW3YZkMmAFr0nagHkKwcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BxAN9o7XxK4utX1Z+e0RX5EzhITH8A5s6KNcQ/H7bj7JX1XcW9Q6MkKu773La9wyx
         5wNDl6ZuSxiT0rw5ywYPVYYHcIMWOnQIj4Mh+sfdBM+nza+kw0q+ShvQCOUJe9BLPc
         IYxGuR3+lB2GTHsJ3wFllegALAo8w9mjDJ3YfWxrPbSyW6sQQnYf3OJKnP3b7XOOAz
         YtHB4eGwSj8QOc7a83R6fBsy0zM6pOYap1smfvue9LYqB+d9kRdaNUe882UwvguqEQ
         oV7s7sh3vldHKqR2CIKhLeuB7cSvxQME5WG6KNF/RFNrCo7xyV/tKICMk+Rx9w7w8q
         arutSGFimmgKA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ocpS8-00Cips-Ps;
        Mon, 26 Sep 2022 15:51:24 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc:     catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
        peterx@redhat.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        shan.gavin@gmail.com, gshan@redhat.com,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 6/6] KVM: selftests: dirty-log: Use KVM_CAP_DIRTY_LOG_RING_ACQ_REL if available
Date:   Mon, 26 Sep 2022 15:51:20 +0100
Message-Id: <20220926145120.27974-7-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220926145120.27974-1-maz@kernel.org>
References: <20220926145120.27974-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org, andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com, peterx@redhat.com, pbonzini@redhat.com, zhenyzha@redhat.com, shan.gavin@gmail.com, gshan@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pick KVM_CAP_DIRTY_LOG_RING_ACQ_REL if exposed by the kernel.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 3 ++-
 tools/testing/selftests/kvm/lib/kvm_util.c   | 5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 53627add8a7c..b5234d6efbe1 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -265,7 +265,8 @@ static void default_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
 
 static bool dirty_ring_supported(void)
 {
-	return kvm_has_cap(KVM_CAP_DIRTY_LOG_RING);
+	return (kvm_has_cap(KVM_CAP_DIRTY_LOG_RING) ||
+		kvm_has_cap(KVM_CAP_DIRTY_LOG_RING_ACQ_REL));
 }
 
 static void dirty_ring_create_vm_done(struct kvm_vm *vm)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9889fe0d8919..411a4c0bc81c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -82,7 +82,10 @@ unsigned int kvm_check_cap(long cap)
 
 void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size)
 {
-	vm_enable_cap(vm, KVM_CAP_DIRTY_LOG_RING, ring_size);
+	if (vm_check_cap(vm, KVM_CAP_DIRTY_LOG_RING_ACQ_REL))
+		vm_enable_cap(vm, KVM_CAP_DIRTY_LOG_RING_ACQ_REL, ring_size);
+	else
+		vm_enable_cap(vm, KVM_CAP_DIRTY_LOG_RING, ring_size);
 	vm->dirty_ring_size = ring_size;
 }
 
-- 
2.34.1

