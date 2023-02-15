Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3876F697354
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 02:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbjBOBRJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 20:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233310AbjBOBRG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 20:17:06 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B616E211A
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:16:40 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-4cddba76f55so182662767b3.23
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OVCdKhDDZw/gGjfaku0Q25g+1PJYV5T4NjwoSTMXyIM=;
        b=YS0IVuodOriuD6adGk6yJIyRbkJGKtwXHdpw1eiZyMtO/0jtjpiry/ha4aiE86Lbqu
         tYnZLXKu6LhNvMjZT6lc9zM4Dvu0tgNeemkcwqfITKacVnU/TqlwJnFPIjN3vzZRziBa
         QnPI+nQBR2XFtlewR0E9N5vIIjyfymSMXo8yQysEDk9SagSu0T3U5xbW5mZrSaY8oVXF
         jic/nk4POmV7OjagmW5oCyoyOjWlUPb+nft0Bjir5SvqCbjlxTCxp71+UId36Xf77oHE
         CvNSWJqfmhGoClwY4Vh3M5sTu7kHvX4L1Ejtu5cj9z1Zy/uRjnc1c9UT9xHtBlijvc/c
         qjdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OVCdKhDDZw/gGjfaku0Q25g+1PJYV5T4NjwoSTMXyIM=;
        b=W8ajxLLwekr8rLT8rqbeTj/Jeovs9pnXolMl+xtZWmsWIV9lYwv8IoQlNzT8NwkXXv
         /4F6SD93+67tfFpBtF2ZphVqxqZXgbqd2Qux0Wt3P/b5apscayFLnen2s3SAzDmJhc8T
         t4oMaTIKftu9t/j+NfYOoDibqTvbx9LkHFQzVdYgGKVlQzz6Iom0ZH7Lw0cJ6YdJ1PPK
         D2JUyYaivrqgJDerDeieygVhhLtx/nFSfMe0cr3w4Cv2BdVU0YdIG4hNhtr1WFhVit8K
         huZBReT+cPGW7XEAT3v4w8Muf62EcaJBxMZSXGHEBhEvkO0RgmURQMCBKLundhCKKRdB
         GTGQ==
X-Gm-Message-State: AO0yUKWJmwbxZqY0c2dBU5zeTVmvjW/Mo4c4MOkyYOa554KOVu+mxceJ
        C/PP6ShIK/njnWDxcR7VKiqiQxYFA4TpVQ==
X-Google-Smtp-Source: AK7set/0P5HkCsHCdqNkX6Phqm5KuQtLcG9ryS3GI3DTfruqUOURyBW0cYukAJvfbIrniqxUkkuylJt1BjwNYQ==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a5b:10e:0:b0:94a:ebba:cba6 with SMTP id
 14-20020a5b010e000000b0094aebbacba6mr2ybx.9.1676423796690; Tue, 14 Feb 2023
 17:16:36 -0800 (PST)
Date:   Wed, 15 Feb 2023 01:16:12 +0000
In-Reply-To: <20230215011614.725983-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215011614.725983-7-amoorthy@google.com>
Subject: [PATCH 6/8] kvm/x86: Add mem fault exit on EPT violations
From:   Anish Moorthy <amoorthy@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Sean Christopherson <seanjc@google.com>,
        James Houghton <jthoughton@google.com>,
        Anish Moorthy <amoorthy@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the relevant kvm cap enabled, EPT violations will exit to userspace
w/ reason KVM_EXIT_MEMORY_FAULT instead of resolving the fault via slow
get_user_pages.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
Suggested-by: James Houghton <jthoughton@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 23 ++++++++++++++++++++---
 arch/x86/kvm/x86.c     |  1 +
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index aeb240b339f54..28af8d60adee6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4201,6 +4201,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 {
 	struct kvm_memory_slot *slot = fault->slot;
 	bool async;
+	bool mem_fault_nowait;
 
 	/*
 	 * Retry the page fault if the gfn hit a memslot that is being deleted
@@ -4230,9 +4231,25 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	}
 
 	async = false;
-	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
-					  fault->write, &fault->map_writable,
-					  &fault->hva);
+	mem_fault_nowait = memory_faults_enabled(vcpu->kvm);
+
+	fault->pfn = __gfn_to_pfn_memslot(
+		slot, fault->gfn,
+		mem_fault_nowait,
+		false,
+		mem_fault_nowait ? NULL : &async,
+		fault->write, &fault->map_writable,
+		&fault->hva);
+
+	if (mem_fault_nowait) {
+		if (fault->pfn == KVM_PFN_ERR_FAULT) {
+			vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
+			vcpu->run->memory_fault.gpa = fault->gfn << PAGE_SHIFT;
+			vcpu->run->memory_fault.size = PAGE_SIZE;
+		}
+		return RET_PF_CONTINUE;
+	}
+
 	if (!async)
 		return RET_PF_CONTINUE; /* *pfn has correct page already */
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 508074e47bc0e..fe39ab2af5db4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4427,6 +4427,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VAPIC:
 	case KVM_CAP_ENABLE_CAP:
 	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
+	case KVM_CAP_MEM_FAULT_NOWAIT:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
-- 
2.39.1.581.gbfd45094c4-goog

