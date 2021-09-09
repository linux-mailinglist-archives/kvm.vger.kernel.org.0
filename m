Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240E2405CE3
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 20:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237348AbhIISd2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 14:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237208AbhIISdZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 14:33:25 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786AFC061574
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 11:32:15 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id r18-20020a056214069200b0037a291a6081so8064873qvz.18
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 11:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=E4WONWu0ir6n8Rh4Cpspn9vyK4soJzcnQ8jT8FRunA0=;
        b=TSOIETlgDAd1INBqwNX3wXGWMArTCD3OV+0Z3EIIR1JRd6ZHxm417j3emsiyGFJcQy
         k8a9S5TID+UERaldlzurOuFMVXmN6mYt4xKeTIUVCMtK5pdTPrtv5y+IaLGXLt8yYve0
         T8mWPUnpxP7KwZFokx4PvrKGuuadaBBKgnTqwd8bn8ESFTSV3HZkU5Qm8Mm85adi4zVq
         7ngjZbVNbwqkFPibyB7MPXK53MrOIZKYc3dGek7CeDXvuwy0bVEvxK8J1IiEwC+kZfnr
         ZizyfoA3hw/q0+vseLtWoJO/Ecrb07XHnnQffXldIh5fUd4riFgp1l4P9dMV/iI8uOHF
         s1Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=E4WONWu0ir6n8Rh4Cpspn9vyK4soJzcnQ8jT8FRunA0=;
        b=EdHFGFmwjbzqg9hf5duDtAo9o9ETG2dRFBTyqEi28z22DKGiB9fJDaHfiG3DYrN/Ao
         A8/qMXzEx1ZqN892TMjRlsW79AMuQUUUWbT1IZm5KTE9LIebD8x4PEbpC5qtLvegrHmp
         OjJCd2uNW/8IorOI3pO21UfdHX8Dn/GmLSf0gA4DfQRobeu6lSHv69oKcYifJsq9CcWm
         VOwMiOttNVxnFr0KDowmZPw+5IXfyig9kUvBbLVSlnQqB/ksw4lpxSKcWXqvk7OsOWoD
         FRfGQLaV5doUAkcSdI0IKra8le3vJ4NelO/TM2OSHAc/XcdJprN8r5GMhlUBcWRZVLU0
         virw==
X-Gm-Message-State: AOAM532QokC6LQHO4ZjxXQMcW4w8edJeT40vKMNK3O8E4DhyXYuH9W2h
        /GpWhrqzJBvgRFr2icneTFBSzBp7wp0=
X-Google-Smtp-Source: ABdhPJwqSUjJGgRyHa8eQcGHaGiHNtkJWk/fkb+ce4btZeiM4uZpk3OLUTpuoDpgh9pNSq4tPV7PSSOuCv4=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:295c:3114:eec1:f9f5])
 (user=seanjc job=sendgmr) by 2002:ad4:54e4:: with SMTP id k4mr4540653qvx.54.1631212334693;
 Thu, 09 Sep 2021 11:32:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  9 Sep 2021 11:32:02 -0700
In-Reply-To: <20210909183207.2228273-1-seanjc@google.com>
Message-Id: <20210909183207.2228273-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210909183207.2228273-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [kvm-unit-tests PATCH v3 2/7] lib: define the "noinline" macro
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bill Wendling <morbo@google.com>

Define "noline" macro to reduce the amount of typing for functions using
the "noinline" attribute.  Opportunsitically convert existing users.

Signed-off-by: Bill Wendling <morbo@google.com>
[sean: put macro in compiler.h instead of libcflat.h]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/linux/compiler.h | 1 +
 x86/pmu_lbr.c        | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/linux/compiler.h b/lib/linux/compiler.h
index 5d9552a..5937b7b 100644
--- a/lib/linux/compiler.h
+++ b/lib/linux/compiler.h
@@ -46,6 +46,7 @@
 #define barrier()	asm volatile("" : : : "memory")
 
 #define __always_inline	inline __attribute__((always_inline))
+#define noinline __attribute__((noinline))
 
 static __always_inline void __read_once_size(const volatile void *p, void *res, int size)
 {
diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
index 3bd9e9f..5ff805a 100644
--- a/x86/pmu_lbr.c
+++ b/x86/pmu_lbr.c
@@ -16,14 +16,14 @@
 
 volatile int count;
 
-static __attribute__((noinline)) int compute_flag(int i)
+static noinline int compute_flag(int i)
 {
 	if (i % 10 < 4)
 		return i + 1;
 	return 0;
 }
 
-static __attribute__((noinline)) int lbr_test(void)
+static noinline int lbr_test(void)
 {
 	int i;
 	int flag;
-- 
2.33.0.309.g3052b89438-goog

