Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64FE5FBBA8
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 21:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiJKT6s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 15:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiJKT63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 15:58:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B2698CA4
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 12:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665518304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SAlECgJKwNknwoioVUeF/uXHuNVkO1eljRPrSr7m9O4=;
        b=FKtBOG+IeOBeeTRsTFt7EwuhTnfOchwUVJMJ7kC1GsK16s6wfxDoGlJ+rhNjwJAv9rZOWE
        yDL50+/7hSazBBYEoGIuxymHebzbj8ZcH3mWWLKleEAcNcdS2ocDRpo4Q8RAep0KOPBp1j
        HcxjEV6d7e69X4tTXBc5HLlCE6Bo/Bk=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-552-10RWun2uMIGtyPfhlNKk1w-1; Tue, 11 Oct 2022 15:58:15 -0400
X-MC-Unique: 10RWun2uMIGtyPfhlNKk1w-1
Received: by mail-qk1-f199.google.com with SMTP id o13-20020a05620a2a0d00b006cf9085682dso12385635qkp.7
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 12:58:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SAlECgJKwNknwoioVUeF/uXHuNVkO1eljRPrSr7m9O4=;
        b=NmD3XmVj+dyVtRaz0a830QAcGGXze9JIjS82kXWhuQMtN/L/fjrroL4C8Tm+PcMbtW
         K4JKS3rIvV/8hbt3J04t4fCnIQbMKtl2jS8QbBQq2uJ3II8pDteSm+dIK7U81AE6Ts3o
         +9in0HIVWthc0t98h4Nc/Q4cD8FR33g/byyjzLtg4nDzzUVQF8OYy+S+gXTq2gPnLTWG
         czW0StCWI+Pf8pdqiElFDt5zzJQhpNIatYDk1An7RWtbVH38NsVuzJw1JHF/+Quo0c7E
         cihVDE6zyaG5yXkNH1RVGSrv4pqDcdqUGtLO9L6/ClVIsUpbT969WgMpZWJBFFI4vtjC
         pfIg==
X-Gm-Message-State: ACrzQf0M01rLaow+r914kBNnUoiCnFtALcfo1zIXl5MatXdWkBgAclFC
        rFNztgFAbS8Venh5uxNH07O4KD4OzjhDqZ0qRxGeu5poLtw6TnREDAVadJml2urPzp33GBog9Je
        G+xZm0N4s6GxX1UYp/wwY//DZzwFY+NBxqKamivjdkSEAs3J3CG30TbuMbWeC4Q==
X-Received: by 2002:ac8:574a:0:b0:394:3388:9fc3 with SMTP id 10-20020ac8574a000000b0039433889fc3mr20682011qtx.292.1665518294848;
        Tue, 11 Oct 2022 12:58:14 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5lzV/hWT/COel7yjUmDe/h42rtZvKalYrmBS4qOaAdmcwzGvcmWe1PC252299lW5tk7hr3pg==
X-Received: by 2002:ac8:574a:0:b0:394:3388:9fc3 with SMTP id 10-20020ac8574a000000b0039433889fc3mr20681987qtx.292.1665518294584;
        Tue, 11 Oct 2022 12:58:14 -0700 (PDT)
Received: from x1n.redhat.com (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id az31-20020a05620a171f00b006ce9e880c6fsm13648837qkb.111.2022.10.11.12.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 12:58:14 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, peterx@redhat.com,
        John Hubbard <jhubbard@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Mike Kravetz <mike.kravetz@oracle.com>
Subject: [PATCH v4 2/4] kvm: Add KVM_PFN_ERR_SIGPENDING
Date:   Tue, 11 Oct 2022 15:58:07 -0400
Message-Id: <20221011195809.557016-3-peterx@redhat.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221011195809.557016-1-peterx@redhat.com>
References: <20221011195809.557016-1-peterx@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new pfn error to show that we've got a pending signal to handle
during hva_to_pfn_slow() procedure (of -EINTR retval).

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/kvm_host.h | 10 ++++++++++
 virt/kvm/kvm_main.c      |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 32f259fa5801..92baa930b891 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -96,6 +96,7 @@
 #define KVM_PFN_ERR_FAULT	(KVM_PFN_ERR_MASK)
 #define KVM_PFN_ERR_HWPOISON	(KVM_PFN_ERR_MASK + 1)
 #define KVM_PFN_ERR_RO_FAULT	(KVM_PFN_ERR_MASK + 2)
+#define KVM_PFN_ERR_SIGPENDING	(KVM_PFN_ERR_MASK + 3)
 
 /*
  * error pfns indicate that the gfn is in slot but faild to
@@ -106,6 +107,15 @@ static inline bool is_error_pfn(kvm_pfn_t pfn)
 	return !!(pfn & KVM_PFN_ERR_MASK);
 }
 
+/*
+ * KVM_PFN_ERR_SIGPENDING indicates that fetching the PFN was interrupted
+ * by a pending signal.  Note, the signal may or may not be fatal.
+ */
+static inline bool is_sigpending_pfn(kvm_pfn_t pfn)
+{
+	return pfn == KVM_PFN_ERR_SIGPENDING;
+}
+
 /*
  * error_noslot pfns indicate that the gfn can not be
  * translated to pfn - it is not in slot or failed to
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e30f1b4ecfa5..e20a59dcda32 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2667,6 +2667,8 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 	npages = hva_to_pfn_slow(addr, async, write_fault, writable, &pfn);
 	if (npages == 1)
 		return pfn;
+	if (npages == -EINTR)
+		return KVM_PFN_ERR_SIGPENDING;
 
 	mmap_read_lock(current->mm);
 	if (npages == -EHWPOISON ||
-- 
2.37.3

