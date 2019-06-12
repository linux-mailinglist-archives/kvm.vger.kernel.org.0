Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D88E442491
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 13:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438599AbfFLLpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 07:45:01 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:39234 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438456AbfFLLoD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 07:44:03 -0400
Received: by mail-vk1-f202.google.com with SMTP id d14so2603141vka.6
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2019 04:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0pRrtQh1WGSItgbOKTKHJXYw3ig9cf9ovTOOwQBNCxo=;
        b=IoAMjSO8LpV9sQ4rhyGuwSi9qAWnWdJKm92qjIFlDfIzZK27lRdtbBpUTTqSsHKQqq
         mk4pY6s02uPltexkWHMnxfPS6E14WpHQTBtMuXD5ciPLmKwQYfFZ7D/irHKINjpULcIC
         qesPb2LJHGU1U+hg3Lnr8sbHR2PLa6XJRSA+MwutfJ1QD1fm8gchvdk4JFKcehQpLj7U
         rwlJqHzorntg7c/BDSuoHH78gq9KnzX7dlAs2pxjWc6C1dDkPCqTKTM+gMG73nj/ByrG
         HBTS6w/3UTjUct6MrDb5Sf2LP5/PYv9l52cM1MNahSes/06CDdeCzTIAFl18VFOFWLlP
         HuBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0pRrtQh1WGSItgbOKTKHJXYw3ig9cf9ovTOOwQBNCxo=;
        b=LRAZTb+PsqjUx75QNU5AAzS5wPXbUd6zoQ8du6q5F/i6y8Jxuto/wYguVnMWVWiIg/
         CIzcOsPs2r9Aj5ses+D9a8DG7Plei1iuCH6DDRlPbZQcPHyq4gAaMc6vKeXKwNCLD/NI
         iGgP4NQAFnMJQJPFDJWx4ETVcbtNPIht6mFsJQmuKmr8zbT5QKo4jNy6d15v1L9Ao/Rm
         +4u/g0C2gSAoDloX6c1szenuuvWENglqkLuCihNTXC2LO+yOGmpsZ/2lQ5gIodqgZWwg
         8yokzpDS8f2qCkcuH2Q1Zz5+TCWNpRCGm4yJ/b6/kZcwj73jSZVL4BwptlngIKDJD92n
         srBg==
X-Gm-Message-State: APjAAAVJelMucSyCishP/0b+YbQODn/9Imf8FSm5hfxMTdy2f4HTQfEB
        5FihFVy2PydLT5kGMxTle1GUG15wbwm9R7G3
X-Google-Smtp-Source: APXvYqyhjQEo4g9YND5Fe8F9dcUypnQYf8jfozQHANwshchy+6+kG6ludLuigCmoO08U0FojfDlhn98Rsb9Khi5b
X-Received: by 2002:a9f:25e9:: with SMTP id 96mr28666032uaf.95.1560339842024;
 Wed, 12 Jun 2019 04:44:02 -0700 (PDT)
Date:   Wed, 12 Jun 2019 13:43:25 +0200
In-Reply-To: <cover.1560339705.git.andreyknvl@google.com>
Message-Id: <e2f35a0400150594a39d9c3f4b3088601fd5dc30.1560339705.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1560339705.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH v17 08/15] userfaultfd, arm64: untag user pointers
From:   Andrey Konovalov <andreyknvl@google.com>
To:     linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
        linux-media@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Christian Koenig <Christian.Koenig@amd.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Khalid Aziz <khalid.aziz@oracle.com>, enh <enh@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christoph Hellwig <hch@infradead.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Evgeniy Stepanov <eugenis@google.com>,
        Lee Smith <Lee.Smith@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        Jacob Bramley <Jacob.Bramley@arm.com>,
        Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Szabolcs Nagy <Szabolcs.Nagy@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch is a part of a series that extends arm64 kernel ABI to allow to
pass tagged user pointers (with the top byte set to something else other
than 0x00) as syscall arguments.

userfaultfd code use provided user pointers for vma lookups, which can
only by done with untagged pointers.

Untag user pointers in validate_range().

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 fs/userfaultfd.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 3b30301c90ec..24d68c3b5ee2 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1263,21 +1263,23 @@ static __always_inline void wake_userfault(struct userfaultfd_ctx *ctx,
 }
 
 static __always_inline int validate_range(struct mm_struct *mm,
-					  __u64 start, __u64 len)
+					  __u64 *start, __u64 len)
 {
 	__u64 task_size = mm->task_size;
 
-	if (start & ~PAGE_MASK)
+	*start = untagged_addr(*start);
+
+	if (*start & ~PAGE_MASK)
 		return -EINVAL;
 	if (len & ~PAGE_MASK)
 		return -EINVAL;
 	if (!len)
 		return -EINVAL;
-	if (start < mmap_min_addr)
+	if (*start < mmap_min_addr)
 		return -EINVAL;
-	if (start >= task_size)
+	if (*start >= task_size)
 		return -EINVAL;
-	if (len > task_size - start)
+	if (len > task_size - *start)
 		return -EINVAL;
 	return 0;
 }
@@ -1327,7 +1329,7 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		goto out;
 	}
 
-	ret = validate_range(mm, uffdio_register.range.start,
+	ret = validate_range(mm, &uffdio_register.range.start,
 			     uffdio_register.range.len);
 	if (ret)
 		goto out;
@@ -1516,7 +1518,7 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
 	if (copy_from_user(&uffdio_unregister, buf, sizeof(uffdio_unregister)))
 		goto out;
 
-	ret = validate_range(mm, uffdio_unregister.start,
+	ret = validate_range(mm, &uffdio_unregister.start,
 			     uffdio_unregister.len);
 	if (ret)
 		goto out;
@@ -1667,7 +1669,7 @@ static int userfaultfd_wake(struct userfaultfd_ctx *ctx,
 	if (copy_from_user(&uffdio_wake, buf, sizeof(uffdio_wake)))
 		goto out;
 
-	ret = validate_range(ctx->mm, uffdio_wake.start, uffdio_wake.len);
+	ret = validate_range(ctx->mm, &uffdio_wake.start, uffdio_wake.len);
 	if (ret)
 		goto out;
 
@@ -1707,7 +1709,7 @@ static int userfaultfd_copy(struct userfaultfd_ctx *ctx,
 			   sizeof(uffdio_copy)-sizeof(__s64)))
 		goto out;
 
-	ret = validate_range(ctx->mm, uffdio_copy.dst, uffdio_copy.len);
+	ret = validate_range(ctx->mm, &uffdio_copy.dst, uffdio_copy.len);
 	if (ret)
 		goto out;
 	/*
@@ -1763,7 +1765,7 @@ static int userfaultfd_zeropage(struct userfaultfd_ctx *ctx,
 			   sizeof(uffdio_zeropage)-sizeof(__s64)))
 		goto out;
 
-	ret = validate_range(ctx->mm, uffdio_zeropage.range.start,
+	ret = validate_range(ctx->mm, &uffdio_zeropage.range.start,
 			     uffdio_zeropage.range.len);
 	if (ret)
 		goto out;
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

