Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDD9556DDB
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 23:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbiFVVhL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 17:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbiFVVhK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 17:37:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 05D7F35AA7
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 14:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655933826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gOKc2ikh4vL40/zpc4P3kwwtd9Sh2ixHRUheDMcVbAY=;
        b=YdO2se9gd94Ut8tZVWLUOh82I8qdYnUNy2qkS/jX8iYlM+cXEkNI9W8AzEUi+41JwLlxli
        U/BOb7SdCxVJIp765xdYKTXVC27iQlh7PlKxY/A2AZ1AsltRzEOSoy0LAEUOZ7Bw1O6vVn
        ExHvEFwCjw550+2+sHx7xQRSKk/oUeg=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-VvxXXtcCP82jPR6MO9w3sw-1; Wed, 22 Jun 2022 17:37:05 -0400
X-MC-Unique: VvxXXtcCP82jPR6MO9w3sw-1
Received: by mail-il1-f199.google.com with SMTP id 3-20020a056e0220c300b002d3d7ebdfdeso11749326ilq.16
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 14:37:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gOKc2ikh4vL40/zpc4P3kwwtd9Sh2ixHRUheDMcVbAY=;
        b=e0SVoSgrS6vSg+xNhF93L/yTF4lSk7k8f4Gwvi/S0Q6X2H9kBSFjYSSL3C71VCSF8P
         7EMNjSW0/YC1i3GvjaZobyospR+HRX6oYV4p8C0FAbXCEr00OKNEDhJxf9fuy6TdDR0s
         trJKBBQvHU+zSJKyrinVdtEmyjNh0UXcvItTJ293PJ34SGnL+jlyV5wBgSN7n/3L09mh
         /3b6Nj8blw0VA9zzINmXhNopwRhq3/5Y/0PoErrcNog/KFOX0jV7w+AA/tPDiWGM2alT
         Ehb8h+pcto+/aUECuAeM251RlYWbs9a8VzLzHvdJEWUWpQc9ynVZ9ivGzIuELUs+cEHj
         ISJA==
X-Gm-Message-State: AJIora9CGLiIM6/CiXMhrx1/V2uyPEO9oSOdx8kcVv5/CK1eV0EvPCrQ
        B45oRNjtuQSkXuZGGCNKH4WFyN0uiX0nB7XUwOmy8ykq8SV5eFIecXs+sLkWStKvlGzwLIKf89v
        j/Ot+b0o4ShlWS7WrrrScC464HAnnwa4M0TinwLtvO6nWy9YggmN0g2j5kMgesA==
X-Received: by 2002:a05:6602:2a42:b0:65a:eb90:2a12 with SMTP id k2-20020a0566022a4200b0065aeb902a12mr2846102iov.73.1655933823980;
        Wed, 22 Jun 2022 14:37:03 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t/8cXtBj2IFYSYh/9eeCC/nf69NJ99ofpl9KFVNDHUyqPHOLaFoA3xbf+adONapZRIiJVl6Q==
X-Received: by 2002:a05:6602:2a42:b0:65a:eb90:2a12 with SMTP id k2-20020a0566022a4200b0065aeb902a12mr2846084iov.73.1655933823672;
        Wed, 22 Jun 2022 14:37:03 -0700 (PDT)
Received: from localhost.localdomain (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id g7-20020a0566380c4700b00339d892cc89sm1510446jal.83.2022.06.22.14.37.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 22 Jun 2022 14:37:02 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterx@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 1/4] mm/gup: Add FOLL_INTERRUPTIBLE
Date:   Wed, 22 Jun 2022 17:36:53 -0400
Message-Id: <20220622213656.81546-2-peterx@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220622213656.81546-1-peterx@redhat.com>
References: <20220622213656.81546-1-peterx@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
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

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/mm.h |  1 +
 mm/gup.c           | 33 +++++++++++++++++++++++++++++----
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index bc8f326be0ce..ebdf8a6b86c1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2941,6 +2941,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
 #define FOLL_SPLIT_PMD	0x20000	/* split huge pmd before returning */
 #define FOLL_PIN	0x40000	/* pages must be released via unpin_user_page */
 #define FOLL_FAST_ONLY	0x80000	/* gup_fast: prevent fall-back to slow gup */
+#define FOLL_INTERRUPTIBLE  0x100000 /* allow interrupts from generic signals */
 
 /*
  * FOLL_PIN and FOLL_LONGTERM may be used in various combinations with each
diff --git a/mm/gup.c b/mm/gup.c
index 551264407624..ad74b137d363 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -933,8 +933,17 @@ static int faultin_page(struct vm_area_struct *vma,
 		fault_flags |= FAULT_FLAG_WRITE;
 	if (*flags & FOLL_REMOTE)
 		fault_flags |= FAULT_FLAG_REMOTE;
-	if (locked)
+	if (locked) {
 		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+		/*
+		 * We should only grant FAULT_FLAG_INTERRUPTIBLE when we're
+		 * (at least) killable.  It also mostly means we're not
+		 * with NOWAIT.  Otherwise ignore FOLL_INTERRUPTIBLE since
+		 * it won't make a lot of sense to be used alone.
+		 */
+		if (*flags & FOLL_INTERRUPTIBLE)
+			fault_flags |= FAULT_FLAG_INTERRUPTIBLE;
+	}
 	if (*flags & FOLL_NOWAIT)
 		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT;
 	if (*flags & FOLL_TRIED) {
@@ -1322,6 +1331,22 @@ int fixup_user_fault(struct mm_struct *mm,
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
@@ -1403,11 +1428,11 @@ static __always_inline long __get_user_pages_locked(struct mm_struct *mm,
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
-- 
2.32.0

