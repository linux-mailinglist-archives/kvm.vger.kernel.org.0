Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CF540CEDB
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 23:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbhIOVcB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 17:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbhIOVcA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 17:32:00 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E39C061574
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 14:30:41 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id a16-20020a63d410000000b00268ebc7f4faso2884344pgh.17
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 14:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BA66WKx97EK3j9tmGUcSd7HMF4RFkdSNq90zx/RuXw4=;
        b=Lz79uQ5byqrb9VZ/sk7CK8Lx2ceLQi7B6b5tvcwiX94wsv3j+O411FG5gwUGkeFI4h
         nZJiBnBVq/CDFSEccxLhMB/FpkZ1uPGSnAUIGLlRJ0IB2yUDWwjtfvbVB3Z+IWpZu2xm
         +Z4zJ4MfbTf2hnXNedsLPuhe2M/TAoeS6cZjk3582ph6xqRbx95xj/2V961Wb454zRsA
         iExlVvhrWxB6BBnQu2SqxAaAhAFrZx/TvOufAUA58qC42+aFbltE/CvElpRnEcLAJnQm
         Uot4KGrcVehMBtjr7wnAY8nlLpZhk+/IbxtEvdkYE4Yrp1hU1eM5RWX19ijPhObl0DaG
         G7vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BA66WKx97EK3j9tmGUcSd7HMF4RFkdSNq90zx/RuXw4=;
        b=p76pbFQrSAm18I5NivKnqsn1mVtnsfhYPcBst2KAG9NZXMIpNNpPtkMy4ERQ/jFRDS
         wD9mZxN4eYYsYHVK7OQAjryQMk6j9KciR64VI6trvNnlc8WsFM2xk+SpJdj84PrXfu7v
         U1qUTV0dyFVohcJW6AmVm1z6HBOjKbhTVqefXJRzShVBfet2C/m2hhrYqlyHUSdptz16
         yKpGyxfHV8Y6cEmftidF5jAYQuWCup21uQpzXevOYyQzWlc4TkKlyryD7oXZkVOO1dJ4
         btOuQtt5Bp7Ja5GoOB2Asp6olKW09VXD21GCPOq2Byto8WAfKqCpprhHaM5Y56mbmAMQ
         J2aQ==
X-Gm-Message-State: AOAM531xMdamy1uHW1FZOTbRAEHrg6u7N7WJBks0OClznVZ5rV7gAstR
        ++VInZzaOeVz/q5vyahN/QbptDfTP6T2PQ==
X-Google-Smtp-Source: ABdhPJwXVrUepBMgm48cLmyGsT3BolrvxB4fKgHorUE9mJigUSamGLF1Y/6gwmhEvykOJg/uaxfPLT/M5bsXgA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:da89:b0:13b:7d3d:59e9 with SMTP
 id j9-20020a170902da8900b0013b7d3d59e9mr1579667plx.41.1631741440587; Wed, 15
 Sep 2021 14:30:40 -0700 (PDT)
Date:   Wed, 15 Sep 2021 21:30:32 +0000
In-Reply-To: <20210915213034.1613552-1-dmatlack@google.com>
Message-Id: <20210915213034.1613552-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20210915213034.1613552-1-dmatlack@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH 1/3] KVM: selftests: Change backing_src flag to -s in demand_paging_test
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Every other KVM selftest uses -s for the backing_src, so switch
demand_paging_test to match.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index e79c1b64977f..735c081e774e 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -416,7 +416,7 @@ static void help(char *name)
 {
 	puts("");
 	printf("usage: %s [-h] [-m vm_mode] [-u uffd_mode] [-d uffd_delay_usec]\n"
-	       "          [-b memory] [-t type] [-v vcpus] [-o]\n", name);
+	       "          [-b memory] [-s type] [-v vcpus] [-o]\n", name);
 	guest_modes_help();
 	printf(" -u: use userfaultfd to handle vCPU page faults. Mode is a\n"
 	       "     UFFD registration mode: 'MISSING' or 'MINOR'.\n");
@@ -426,7 +426,7 @@ static void help(char *name)
 	printf(" -b: specify the size of the memory region which should be\n"
 	       "     demand paged by each vCPU. e.g. 10M or 3G.\n"
 	       "     Default: 1G\n");
-	printf(" -t: The type of backing memory to use. Default: anonymous\n");
+	printf(" -s: The type of backing memory to use. Default: anonymous\n");
 	backing_src_help();
 	printf(" -v: specify the number of vCPUs to run.\n");
 	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
@@ -446,7 +446,7 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "hm:u:d:b:t:v:o")) != -1) {
+	while ((opt = getopt(argc, argv, "hm:u:d:b:s:v:o")) != -1) {
 		switch (opt) {
 		case 'm':
 			guest_modes_cmdline(optarg);
@@ -465,7 +465,7 @@ int main(int argc, char *argv[])
 		case 'b':
 			guest_percpu_mem_size = parse_size(optarg);
 			break;
-		case 't':
+		case 's':
 			p.src_type = parse_backing_src_type(optarg);
 			break;
 		case 'v':
@@ -485,7 +485,7 @@ int main(int argc, char *argv[])
 
 	if (p.uffd_mode == UFFDIO_REGISTER_MODE_MINOR &&
 	    !backing_src_is_shared(p.src_type)) {
-		TEST_FAIL("userfaultfd MINOR mode requires shared memory; pick a different -t");
+		TEST_FAIL("userfaultfd MINOR mode requires shared memory; pick a different -s");
 	}
 
 	for_each_guest_mode(run_test, &p);
-- 
2.33.0.309.g3052b89438-goog

