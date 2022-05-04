Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3201651B278
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 00:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbiEDWzW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379502AbiEDWyQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:16 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB1D186FF
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:50:39 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id i188-20020a636dc5000000b003c143f97bc2so1342157pgc.11
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Jk9yX0/L/SZGLl/sjgO8qssUyxafpPIYsEjtaY9KLJw=;
        b=d3CxHrnwxlPFqFS4B2lK31TdZzCRwdUaZ0gM1SRSErh/p05O1p+7NSAhMlDoCDWQt8
         YPSQZhPLR1lcHyftAChWvfnaLSO+Vv965NU5hgGicDC7tlURImgaU/NJMZtDQPUeNd7T
         /ABl61lWYjUh9NfVQlZoR1z+V8TmsIUu2LCIAjoT0BkUyoVCiqvozW7roc8BWD2Xq8l1
         t7I4y/Y98HB1qt8SFb68+gz5F8IVsTzjqu8y3tccNQ82qWZCzT8bbke4+p9ai5iTNwO0
         vF7MpkmASyJFi02UAiXueocTV30udmGWt81u2zJEJeg7vJx3rSUi6IXOsdUxBzACrIdv
         v3cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Jk9yX0/L/SZGLl/sjgO8qssUyxafpPIYsEjtaY9KLJw=;
        b=WsJKwqtWR9ARG2LZWyP2ZJEkw+VVBVItcIOqVj+LT9IxNmqeu+RZ0yYa5r8+dMeqwV
         7dUKZrpmHJyTwddxSYP2VnTnLSdaWwgSRVRzTgTW+i+HGYG1G3kXbYnGeapSYoh5vd2P
         zQkjMvvnQ829uaXOk/qvVCGPJMOekGjv5qq6fCCVQCNpPnuVmicZ48gKW0su3m3E26zs
         VghZsFVc4qokwzKTf2rWr+WMB2hTgOe8k9fcQrfl2/N+e3jOFrWFfpH0z2hBYdLk9+DW
         aJW26y3yqcQFi2eXe53Oips6+RbzmEGnEPQxp+fu2gbhora4+2c4S+CCmWhCWegu4qCx
         Q2DA==
X-Gm-Message-State: AOAM532K5Q9znI4f/x7Z+lTgOVOD0Wn2Ix+rdpm6KxZwzuzinxLLdmHy
        c9++YymBtgJp9HHqxILL/CQJXlq4SyE=
X-Google-Smtp-Source: ABdhPJwfLHkCIOEwXQLPUjWO78s7ITeSa4Disk9Q2KtLmuN7M6HDs6WnFqD/s/32Cbgr7eyGeCrUULIAgAI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c986:b0:1d9:56e7:4e83 with SMTP id
 w6-20020a17090ac98600b001d956e74e83mr139674pjt.1.1651704638713; Wed, 04 May
 2022 15:50:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:45 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-40-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 039/128] KVM: selftests: Rename vcpu.state => vcpu.run
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename the "state" field of 'struct vcpu' to "run".  KVM calls it "run",
the struct name is "kvm_run", etc...

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 24 +++++++------------
 .../selftests/kvm/lib/s390x/processor.c       |  2 +-
 3 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 136b5428ae0e..96e08c9be013 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -48,7 +48,7 @@ struct vcpu {
 	uint32_t id;
 	int fd;
 	struct kvm_vm *vm;
-	struct kvm_run *state;
+	struct kvm_run *run;
 	struct kvm_dirty_gfn *dirty_gfns;
 	uint32_t fetch_index;
 	uint32_t dirty_gfns_count;
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 73247afa7265..d31ac35a86f3 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -518,7 +518,7 @@ static void vm_vcpu_rm(struct kvm_vm *vm, struct vcpu *vcpu)
 		vcpu->dirty_gfns = NULL;
 	}
 
-	ret = munmap(vcpu->state, vcpu_mmap_sz());
+	ret = munmap(vcpu->run, vcpu_mmap_sz());
 	TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
 
 	ret = close(vcpu->fd);
@@ -1085,13 +1085,7 @@ void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid)
 	struct vcpu *vcpu;
 
 	/* Confirm a vcpu with the specified id doesn't already exist. */
-	vcpu = vcpu_find(vm, vcpuid);
-	if (vcpu != NULL)
-		TEST_FAIL("vcpu with the specified id "
-			"already exists,\n"
-			"  requested vcpuid: %u\n"
-			"  existing vcpuid: %u state: %p",
-			vcpuid, vcpu->id, vcpu->state);
+	TEST_ASSERT(!vcpu_find(vm, vcpuid), "vCPU%d already exists\n", vcpuid);
 
 	/* Allocate and initialize new vcpu structure. */
 	vcpu = calloc(1, sizeof(*vcpu));
@@ -1102,12 +1096,12 @@ void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid)
 	vcpu->fd = __vm_ioctl(vm, KVM_CREATE_VCPU, (void *)(unsigned long)vcpuid);
 	TEST_ASSERT(vcpu->fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_VCPU, vcpu->fd));
 
-	TEST_ASSERT(vcpu_mmap_sz() >= sizeof(*vcpu->state), "vcpu mmap size "
+	TEST_ASSERT(vcpu_mmap_sz() >= sizeof(*vcpu->run), "vcpu mmap size "
 		"smaller than expected, vcpu_mmap_sz: %i expected_min: %zi",
-		vcpu_mmap_sz(), sizeof(*vcpu->state));
-	vcpu->state = (struct kvm_run *) mmap(NULL, vcpu_mmap_sz(),
+		vcpu_mmap_sz(), sizeof(*vcpu->run));
+	vcpu->run = (struct kvm_run *) mmap(NULL, vcpu_mmap_sz(),
 		PROT_READ | PROT_WRITE, MAP_SHARED, vcpu->fd, 0);
-	TEST_ASSERT(vcpu->state != MAP_FAILED,
+	TEST_ASSERT(vcpu->run != MAP_FAILED,
 		    __KVM_SYSCALL_ERROR("mmap()", (int)(unsigned long)MAP_FAILED));
 
 	/* Add to linked-list of VCPUs. */
@@ -1464,7 +1458,7 @@ struct kvm_run *vcpu_state(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
 
-	return vcpu->state;
+	return vcpu->run;
 }
 
 /*
@@ -1506,9 +1500,9 @@ void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid)
 	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
 	int ret;
 
-	vcpu->state->immediate_exit = 1;
+	vcpu->run->immediate_exit = 1;
 	ret = __vcpu_run(vm, vcpuid);
-	vcpu->state->immediate_exit = 0;
+	vcpu->run->immediate_exit = 0;
 
 	TEST_ASSERT(ret == -1 && errno == EINTR,
 		    "KVM_RUN IOCTL didn't exit immediately, rc: %i, errno: %i",
diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
index 53c413932f64..df9d9650d916 100644
--- a/tools/testing/selftests/kvm/lib/s390x/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
@@ -210,7 +210,7 @@ void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
 	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
 
 	fprintf(stream, "%*spstate: psw: 0x%.16llx:0x%.16llx\n",
-		indent, "", vcpu->state->psw_mask, vcpu->state->psw_addr);
+		indent, "", vcpu->run->psw_mask, vcpu->run->psw_addr);
 }
 
 void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid)
-- 
2.36.0.464.gb9c8b46e94-goog

