Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFE6FFA3A
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 15:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbfD3NZb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 09:25:31 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:47571 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728070AbfD3NZ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 09:25:28 -0400
Received: by mail-vk1-f202.google.com with SMTP id x77so1448945vke.14
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2019 06:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BvUTfQkQM7uCDeEtImKKI/2Hme2ZprNLcMmbkGV4djo=;
        b=dpVTwFKbchbVkkb84ng8BnoHNS2SM91wquNJtuly6Sbp7lXj1bPrbJBiP3SyhTU0xP
         LuA/DNrbjhKI/dHi3IXFK1lS8O09Sk1+qA/R7rjDLupO2W7Szy3T1dELXK4hEpZqkwPw
         qD0yKLxb8ZjzpYALNjI1z0dDf4TB8V0IRIOptCx1gDVu9+jOblt+XzKkwvlPuV63pqHj
         wnFsYt5mNXo/Rj6N9Lo9JMQODsljOWPF/MJrAcRLfdznXkGZCgNmaSrk7MrXtOUREZGb
         X2QTJ1/W011vEIe5OofpK81AMWPuQy4lXPQltspauNse0OruElYuf2mJ90h6FolZJ8lL
         VpnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BvUTfQkQM7uCDeEtImKKI/2Hme2ZprNLcMmbkGV4djo=;
        b=mX6acSFcZki/9xh9mnmfroathFOIXwTOUE9JJTVhNZ6R1qMevaPIRrgivWwtATdjdw
         RM3F9DnktUcVqKEbiWgt6XwYl+w5N+8smwT8+DYdGhtgRf8kjn0PFnHSogmwjtbp61CX
         8Zbyg/r44qCqDzNNSUefDj4MxaTq7joOa1BomWwvPEdT7N+8R3n5N0w4g6BHTcttw8O+
         Vf93yEeEnGGM6mJDYLOTxAPlZjV/qkmTyj2ObliiXbHPmm1KCBgibmwLq1VgU4PA5m9s
         wlZ5H+fjyhEPYndmuIK5Vj0EQzfG20JRWKhbpSB1CaUj3X1lrDDp1WC3N60GzSDnwcUe
         yo4A==
X-Gm-Message-State: APjAAAUI7VPydBIcgb4+mIPdNEkXCnb/CqBtCRYbiGza5nGAfSUxPQE7
        Xv1vX2OyUqVDkP8lLdoVbQvyNohYZHQmZClE
X-Google-Smtp-Source: APXvYqyRA/Qu4LKAWcvJoaQQlsyyIllouYjqkXgAFh5vrZ+95OMG6R4QdBb3NSzDXJSn7wdUrbj4M88LAp+D5Hqp
X-Received: by 2002:a67:ea83:: with SMTP id f3mr2107513vso.59.1556630726654;
 Tue, 30 Apr 2019 06:25:26 -0700 (PDT)
Date:   Tue, 30 Apr 2019 15:24:59 +0200
In-Reply-To: <cover.1556630205.git.andreyknvl@google.com>
Message-Id: <6f38f610cc22dca9aef05d53a5a94b24763cc628.1556630205.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1556630205.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
Subject: [PATCH v14 03/17] lib, arm64: untag user pointers in strn*_user
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
        Yishai Hadas <yishaih@mellanox.com>, Kuehling@google.com,
        Felix <Felix.Kuehling@amd.com>, Deucher@google.com,
        Alexander <Alexander.Deucher@amd.com>, Koenig@google.com,
        Christian <Christian.Koenig@amd.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Evgeniy Stepanov <eugenis@google.com>,
        Lee Smith <Lee.Smith@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        Jacob Bramley <Jacob.Bramley@arm.com>,
        Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Chintan Pandya <cpandya@codeaurora.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Dave Martin <Dave.Martin@arm.com>,
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

strncpy_from_user and strnlen_user accept user addresses as arguments, and
do not go through the same path as copy_from_user and others, so here we
need to handle the case of tagged user addresses separately.

Untag user pointers passed to these functions.

Note, that this patch only temporarily untags the pointers to perform
validity checks, but then uses them as is to perform user memory accesses.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 lib/strncpy_from_user.c | 3 ++-
 lib/strnlen_user.c      | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/strncpy_from_user.c b/lib/strncpy_from_user.c
index 58eacd41526c..6209bb9507c7 100644
--- a/lib/strncpy_from_user.c
+++ b/lib/strncpy_from_user.c
@@ -6,6 +6,7 @@
 #include <linux/uaccess.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
+#include <linux/mm.h>
 
 #include <asm/byteorder.h>
 #include <asm/word-at-a-time.h>
@@ -107,7 +108,7 @@ long strncpy_from_user(char *dst, const char __user *src, long count)
 		return 0;
 
 	max_addr = user_addr_max();
-	src_addr = (unsigned long)src;
+	src_addr = (unsigned long)untagged_addr(src);
 	if (likely(src_addr < max_addr)) {
 		unsigned long max = max_addr - src_addr;
 		long retval;
diff --git a/lib/strnlen_user.c b/lib/strnlen_user.c
index 1c1a1b0e38a5..8ca3d2ac32ec 100644
--- a/lib/strnlen_user.c
+++ b/lib/strnlen_user.c
@@ -2,6 +2,7 @@
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <linux/uaccess.h>
+#include <linux/mm.h>
 
 #include <asm/word-at-a-time.h>
 
@@ -109,7 +110,7 @@ long strnlen_user(const char __user *str, long count)
 		return 0;
 
 	max_addr = user_addr_max();
-	src_addr = (unsigned long)str;
+	src_addr = (unsigned long)untagged_addr(str);
 	if (likely(src_addr < max_addr)) {
 		unsigned long max = max_addr - src_addr;
 		long retval;
-- 
2.21.0.593.g511ec345e18-goog

