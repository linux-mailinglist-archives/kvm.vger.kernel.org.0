Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0B754EEEB
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 03:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379614AbiFQBmR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 21:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379568AbiFQBmD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 21:42:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5D52863BD8
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 18:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655430120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Bc6oiDMKyczPP3MnRg+YG2Ibpmu1/F27D1fgoc2Uo0=;
        b=gDXBZOScJ2sU5KdARbajqNpssaqmuZygbU3NXTjKvQM0uE+uidQVbv3plJgby4JCgNb7/Y
        HwSigMBWHRS2GqHNeEaRnrDT9U/tYOvQXyWstG2jk65clq6/O/a3LfwEsjW/0NWcvttmGb
        AmxwNM1xL/5keODuErkn0BVc6vzKZ4Y=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-HBN4oqHLOz-6ArOPbC_Pkg-1; Thu, 16 Jun 2022 21:41:59 -0400
X-MC-Unique: HBN4oqHLOz-6ArOPbC_Pkg-1
Received: by mail-io1-f71.google.com with SMTP id l7-20020a6b7007000000b00669b2a0d497so1790151ioc.0
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 18:41:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Bc6oiDMKyczPP3MnRg+YG2Ibpmu1/F27D1fgoc2Uo0=;
        b=jm94qEqTiK+4i383kcudIU8cgcw6fgZ5q5JoCa7R19IZ142bvGrO1HTsds9L1uqaXz
         Tzvxamy1WAli5J1ycJFiG/VQNx+BwtdiFmCC+Cc22ocy150A0pxOMLGUPThqqqYBabPT
         PCH2jPAgsbc2urYSrv92Px0MACpb18rWP7P2q4aFhEtLQ+cGcOMKUtmINS1/8TgeL1ce
         e8MzFDgaTQJgUVjCue7Yf5yzb/tVogRcFLsv4LT8wRqGI9APk4B/pxUsRB/lYdK9iWBA
         YDkGtpDPHtCQAp9HfYn/JrIx7V8JPqkqb1zBntIhaQ4xXNKLN55HTGkOb+oacgdra7sX
         7cNQ==
X-Gm-Message-State: AJIora83UZcsfWiVmblB0ddhtK18GJR6XZQwjRQyyknj7H44XGcPalwS
        qo2Bx8XupZLYgBDdRgveRunZzAcDaT2due8keQ3Wd8D/OIES8I+R3uuAn6givHHuw52U23WI4y5
        cXefigqo4AV0K/zR0mJMhL2cy1Ob4wqjyBob0sJGeLk8ueVbAUoM4Ipszjn8dsQ==
X-Received: by 2002:a92:da4e:0:b0:2d6:6554:a33b with SMTP id p14-20020a92da4e000000b002d66554a33bmr4355228ilq.10.1655430118330;
        Thu, 16 Jun 2022 18:41:58 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vLhgSniNb4wQ9rsYIx2n9iJ0unph2M/HKN3cx1HhnNV8Tgz+efjRctqDyhOiUvQlicAOOc3w==
X-Received: by 2002:a92:da4e:0:b0:2d6:6554:a33b with SMTP id p14-20020a92da4e000000b002d66554a33bmr4355213ilq.10.1655430117980;
        Thu, 16 Jun 2022 18:41:57 -0700 (PDT)
Received: from localhost.localdomain (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id n4-20020a056e02140400b002d522958fb4sm1726538ilo.2.2022.06.16.18.41.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 16 Jun 2022 18:41:57 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, peterx@redhat.com
Subject: [PATCH RFC 4/4] kvm/x86: Allow to respond to generic signals during slow page faults
Date:   Thu, 16 Jun 2022 21:41:47 -0400
Message-Id: <20220617014147.7299-5-peterx@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220617014147.7299-1-peterx@redhat.com>
References: <20220617014147.7299-1-peterx@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All the facilities should be ready for this, what we need to do is to add a
new KVM_GTP_INTERRUPTIBLE flag showing that we're willing to be interrupted
by common signals during the __gfn_to_pfn_memslot() request, and wire it up
with a FOLL_INTERRUPTIBLE flag that we've just introduced.

Note that only x86 slow page fault routine will set this new bit.  The new
bit is not used in non-x86 arch or on other gup paths even for x86.
However it can actually be used elsewhere too but not yet covered.

When we see the PFN fetching was interrupted, do early exit to userspace
with an KVM_EXIT_INTR exit reason.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c   | 9 +++++++++
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 4 ++++
 3 files changed, 14 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e92f1ab63d6a..b39acb7cb16d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3012,6 +3012,13 @@ static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
 static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			       unsigned int access)
 {
+	/* NOTE: not all error pfn is fatal; handle intr before the other ones */
+	if (unlikely(is_intr_pfn(fault->pfn))) {
+		vcpu->run->exit_reason = KVM_EXIT_INTR;
+		++vcpu->stat.signal_exits;
+		return -EINTR;
+	}
+
 	/* The pfn is invalid, report the error! */
 	if (unlikely(is_error_pfn(fault->pfn)))
 		return kvm_handle_bad_page(vcpu, fault->gfn, fault->pfn);
@@ -4017,6 +4024,8 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		}
 	}
 
+	/* Allow to respond to generic signals in slow page faults */
+	flags |= KVM_GTP_INTERRUPTIBLE;
 	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, flags, NULL,
 					  &fault->map_writable, &fault->hva);
 	return RET_PF_CONTINUE;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4f84a442f67f..c8d98e435537 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1163,6 +1163,7 @@ typedef unsigned int __bitwise kvm_gtp_flag_t;
 
 #define  KVM_GTP_WRITE          ((__force kvm_gtp_flag_t) BIT(0))
 #define  KVM_GTP_ATOMIC         ((__force kvm_gtp_flag_t) BIT(1))
+#define  KVM_GTP_INTERRUPTIBLE  ((__force kvm_gtp_flag_t) BIT(2))
 
 kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 			       kvm_gtp_flag_t gtp_flags, bool *async,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 952400b42ee9..b3873cac5672 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2462,6 +2462,8 @@ static int hva_to_pfn_slow(unsigned long addr, bool *async,
 		flags |= FOLL_WRITE;
 	if (async)
 		flags |= FOLL_NOWAIT;
+	if (gtp_flags & KVM_GTP_INTERRUPTIBLE)
+		flags |= FOLL_INTERRUPTIBLE;
 
 	npages = get_user_pages_unlocked(addr, 1, &page, flags);
 	if (npages != 1)
@@ -2599,6 +2601,8 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, kvm_gtp_flag_t gtp_flags, bool *async,
 	npages = hva_to_pfn_slow(addr, async, gtp_flags, writable, &pfn);
 	if (npages == 1)
 		return pfn;
+	if (npages == -EINTR)
+		return KVM_PFN_ERR_INTR;
 
 	mmap_read_lock(current->mm);
 	if (npages == -EHWPOISON ||
-- 
2.32.0

