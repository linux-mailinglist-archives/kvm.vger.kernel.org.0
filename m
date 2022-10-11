Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53815FBBA1
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 21:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiJKT6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 15:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiJKT6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 15:58:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401CE98CA2
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 12:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665518295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V/+ripU4Cn0e2jw5c/awHk5ywDVBelMr8KNke92yFbw=;
        b=bkun3Cln06Y6GtyXN0vys3GYlpr0GocFYNRIK0VPKIycDeaofmOELmVVKI3oDyNxNPSzbs
        NEvHXEYycwcwaU1A9kLGEQj7gTHivmsW4m4eLhdtNh+DJY60dbzXrnzJZ1ZS+6gaamT0T+
        fOH2SnNP+gDEwuWtOvSbaH5BsSK3ys4=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-625-wWLq1tN0NZSDZ2MStKkUeQ-1; Tue, 11 Oct 2022 15:58:14 -0400
X-MC-Unique: wWLq1tN0NZSDZ2MStKkUeQ-1
Received: by mail-qk1-f200.google.com with SMTP id n13-20020a05620a294d00b006cf933c40feso12657213qkp.20
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 12:58:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V/+ripU4Cn0e2jw5c/awHk5ywDVBelMr8KNke92yFbw=;
        b=lHNqG/exSu4SYaGCinoQcmm9MBb3RpXgCSnGtoY1uj09FHDrKEUZmqI6GA2/qwky+b
         0CksvEM4giHBpOM8oBgDkVVUNNYGOgxtVgbjVwK775bcLFbRd3Oap9SAgov8Lyv5IBKN
         4Uw1ezH0T/gq+HBfPtSe8+8pvruA98a6Rt78ubIZz5HQab3Wxx8tCglc17zj2WF4e83Z
         bdQMsGSuuVnt3Tnmfv/QABvoUokAgYLg7cgX1tobuKMzuL0m3cT6lnGvU1OVg5m+0ov/
         42GDzWKrSq8wFsI3ZTEpR3WyhE4s9Occi5+P2rS4LgwE7gM9nLXivCerMh9xlTsOED5R
         SPxw==
X-Gm-Message-State: ACrzQf0i5cd0RlQh46B1kx5r8m7OHUvy/KVCm0v4qGdJE1cufIvfbzxD
        omx6KvHttocO4gOOfSp+3xNAPBstyoCEgK17T2UKpVZd/glcuMCyANqf9NOiCk3JOR2pViymtWw
        MlvhETZ8pDcH+phTUKbLncjNHEAV9Tvd1B9t9EsuMk4dQ4pWcStf0BXJBX09C2Q==
X-Received: by 2002:a0c:9a0d:0:b0:4b1:982e:96d4 with SMTP id p13-20020a0c9a0d000000b004b1982e96d4mr19788285qvd.114.1665518293370;
        Tue, 11 Oct 2022 12:58:13 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6PixulCqGkG8rkh18fizY4hjzT3AYfYhVR7T8bvGGt8538uBuPPVxwiplaUYFmIz1hwWZjbA==
X-Received: by 2002:a0c:9a0d:0:b0:4b1:982e:96d4 with SMTP id p13-20020a0c9a0d000000b004b1982e96d4mr19788255qvd.114.1665518293119;
        Tue, 11 Oct 2022 12:58:13 -0700 (PDT)
Received: from x1n.redhat.com (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id az31-20020a05620a171f00b006ce9e880c6fsm13648837qkb.111.2022.10.11.12.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 12:58:12 -0700 (PDT)
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
Subject: [PATCH v4 1/4] mm/gup: Add FOLL_INTERRUPTIBLE
Date:   Tue, 11 Oct 2022 15:58:06 -0400
Message-Id: <20221011195809.557016-2-peterx@redhat.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221011195809.557016-1-peterx@redhat.com>
References: <20221011195809.557016-1-peterx@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We have had FAULT_FLAG_INTERRUPTIBLE but it was never applied to GUPs.  One
issue with it is that not all GUP paths are able to handle signal delivers
besides SIGKILL.

That's not ideal for the GUP users who are actually able to handle these
cases, like KVM.

KVM uses GUP extensively on faulting guest pages, during which we've got
existing infrastructures to retry a page fault at a later time.  Allowing
the GUP to be interrupted by generic signals can make KVM related threads
to be more responsive.  For examples:

  (1) SIGUSR1: which QEMU/KVM uses to deliver an inter-process IPI,
      e.g. when the admin issues a vm_stop QMP command, SIGUSR1 can be
      generated to kick the vcpus out of kernel context immediately,

  (2) SIGINT: which can be used with interactive hypervisor users to stop a
      virtual machine with Ctrl-C without any delays/hangs,

  (3) SIGTRAP: which grants GDB capability even during page faults that are
      stuck for a long time.

Normally hypervisor will be able to receive these signals properly, but not
if we're stuck in a GUP for a long time for whatever reason.  It happens
easily with a stucked postcopy migration when e.g. a network temp failure
happens, then some vcpu threads can hang death waiting for the pages.  With
the new FOLL_INTERRUPTIBLE, we can allow GUP users like KVM to selectively
enable the ability to trap these signals.

Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/mm.h |  1 +
 mm/gup.c           | 33 +++++++++++++++++++++++++++++----
 mm/hugetlb.c       |  5 ++++-
 3 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 21f8b27bd9fd..488a9f4cce07 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2897,6 +2897,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
 #define FOLL_SPLIT_PMD	0x20000	/* split huge pmd before returning */
 #define FOLL_PIN	0x40000	/* pages must be released via unpin_user_page */
 #define FOLL_FAST_ONLY	0x80000	/* gup_fast: prevent fall-back to slow gup */
+#define FOLL_INTERRUPTIBLE  0x100000 /* allow interrupts from generic signals */
 
 /*
  * FOLL_PIN and FOLL_LONGTERM may be used in various combinations with each
diff --git a/mm/gup.c b/mm/gup.c
index 5abdaf487460..d51e7ccaef32 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -970,8 +970,17 @@ static int faultin_page(struct vm_area_struct *vma,
 		fault_flags |= FAULT_FLAG_WRITE;
 	if (*flags & FOLL_REMOTE)
 		fault_flags |= FAULT_FLAG_REMOTE;
-	if (locked)
+	if (locked) {
 		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+		/*
+		 * FAULT_FLAG_INTERRUPTIBLE is opt-in. GUP callers must set
+		 * FOLL_INTERRUPTIBLE to enable FAULT_FLAG_INTERRUPTIBLE.
+		 * That's because some callers may not be prepared to
+		 * handle early exits caused by non-fatal signals.
+		 */
+		if (*flags & FOLL_INTERRUPTIBLE)
+			fault_flags |= FAULT_FLAG_INTERRUPTIBLE;
+	}
 	if (*flags & FOLL_NOWAIT)
 		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT;
 	if (*flags & FOLL_TRIED) {
@@ -1380,6 +1389,22 @@ int fixup_user_fault(struct mm_struct *mm,
 }
 EXPORT_SYMBOL_GPL(fixup_user_fault);
 
+/*
+ * GUP always responds to fatal signals.  When FOLL_INTERRUPTIBLE is
+ * specified, it'll also respond to generic signals.  The caller of GUP
+ * that has FOLL_INTERRUPTIBLE should take care of the GUP interruption.
+ */
+static bool gup_signal_pending(unsigned int flags)
+{
+	if (fatal_signal_pending(current))
+		return true;
+
+	if (!(flags & FOLL_INTERRUPTIBLE))
+		return false;
+
+	return signal_pending(current);
+}
+
 /*
  * Please note that this function, unlike __get_user_pages will not
  * return 0 for nr_pages > 0 without FOLL_NOWAIT
@@ -1461,11 +1486,11 @@ static __always_inline long __get_user_pages_locked(struct mm_struct *mm,
 		 * Repeat on the address that fired VM_FAULT_RETRY
 		 * with both FAULT_FLAG_ALLOW_RETRY and
 		 * FAULT_FLAG_TRIED.  Note that GUP can be interrupted
-		 * by fatal signals, so we need to check it before we
+		 * by fatal signals of even common signals, depending on
+		 * the caller's request. So we need to check it before we
 		 * start trying again otherwise it can loop forever.
 		 */
-
-		if (fatal_signal_pending(current)) {
+		if (gup_signal_pending(flags)) {
 			if (!pages_done)
 				pages_done = -EINTR;
 			break;
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e070b8593b37..202f3ad7f35c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6206,9 +6206,12 @@ long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 				fault_flags |= FAULT_FLAG_WRITE;
 			else if (unshare)
 				fault_flags |= FAULT_FLAG_UNSHARE;
-			if (locked)
+			if (locked) {
 				fault_flags |= FAULT_FLAG_ALLOW_RETRY |
 					FAULT_FLAG_KILLABLE;
+				if (flags & FOLL_INTERRUPTIBLE)
+					fault_flags |= FAULT_FLAG_INTERRUPTIBLE;
+			}
 			if (flags & FOLL_NOWAIT)
 				fault_flags |= FAULT_FLAG_ALLOW_RETRY |
 					FAULT_FLAG_RETRY_NOWAIT;
-- 
2.37.3

