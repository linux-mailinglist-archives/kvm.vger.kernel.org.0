Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723D244CE13
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 01:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbhKKAGS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 19:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234287AbhKKAGQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 19:06:16 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EEC8C061766
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:03:28 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id t24-20020a252d18000000b005c225ae9e16so6602743ybt.15
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BnDYr7XeHG59cPA98gYZELhabwdzUR4OfVOWYOyZ6EU=;
        b=sdOEnVAJx8GbSLGQSvAV1rJl6GRwRVQrZiW9VTo26tMd8jFVcv5Ol48U79d8/enJSq
         wdlAHGAxz3wLd9A7PVO2bdaiTh7HbW9ElMLBX1lByNluz3pb9UCBtZ4e7ySTRD+pJeB1
         Sh4BV6Ni0bYmEwOU3kf/VUTZa6vGs9ECMjiRQb/SfFMfF5prrx+CqsBEuS1JWpiH90l5
         fuGr+C7Zg+7kAXkZPKU7xMS/X/XrDaOUteC+9o3qzIJyR9aIXhfITOrVUF/vFy9x8hSn
         oFovH5y1oTuqfJrcp9Ud/EES+aQswnpFNzIT01zvdh0UhVkHdwiz59re5RdfvAaiEq2O
         xEAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BnDYr7XeHG59cPA98gYZELhabwdzUR4OfVOWYOyZ6EU=;
        b=IpvwRuks6ITkutNxXNCp2SghptqMda2YCUaZbOz1Qchc+S7TXXDmVjtVsPlEINTZiV
         45o3XEETd++bxn2YaU7B566wSuR1RczyNry0uELH4eMswDXrzgiwvY8jMGpzHxOTIMMR
         2YYMQU9TpFjAMRl3OIZZL32JS/DglwNtVf/hY0IjoLQpeHI+9WXHiCUWqiLhmOuJBfop
         BeKnzxehkMSD1RbxvLmnMspQlG0NjJ3Qim4aSigypamLkViZAD3Gtbsi9T7mrLk81/L9
         Jo18mGKBmjsnl2MLyXMveqQtamqBG2GdFhMx1Tzdml8fE7s7PqvGycyoRXZwwJhGf2Hh
         OLsw==
X-Gm-Message-State: AOAM530kCPrhLh9dfB3ci050po7q8ddzWgWqSkjWEhcgo693EjhImRfC
        r/xxSUYWsh/t4+ybU1MUJMihSU4ySXIUcQ==
X-Google-Smtp-Source: ABdhPJw4KmYhJehCaO58EiAB8UZRtWym1d/vti55KXrbtM6qhbk60HDJlXidasiZR+EiQ5ScjqBjjh3ahQusng==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a25:748a:: with SMTP id
 p132mr3421484ybc.207.1636589007776; Wed, 10 Nov 2021 16:03:27 -0800 (PST)
Date:   Thu, 11 Nov 2021 00:03:05 +0000
In-Reply-To: <20211111000310.1435032-1-dmatlack@google.com>
Message-Id: <20211111000310.1435032-8-dmatlack@google.com>
Mime-Version: 1.0
References: <20211111000310.1435032-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH v2 07/12] KVM: selftests: Use perf util's per-vCPU GPA/pages
 in demand paging test
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Grab the per-vCPU GPA and number of pages from perf_util in the demand
paging test instead of duplicating perf_util's calculations.

Note, this may or may not result in a functional change.  It's not clear
that the test's calculations are guaranteed to yield the same value as
perf_util, e.g. if guest_percpu_mem_size != vcpu_args->pages.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/demand_paging_test.c        | 21 +++++--------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 1510b21e6306..3c729a0a1ab1 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -322,26 +322,15 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		TEST_ASSERT(pipefds, "Unable to allocate memory for pipefd");
 
 		for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
-			vm_paddr_t vcpu_gpa;
+			struct perf_test_vcpu_args *vcpu_args;
 			void *vcpu_hva;
 			void *vcpu_alias;
-			uint64_t vcpu_mem_size;
 
-
-			if (p->partition_vcpu_memory_access) {
-				vcpu_gpa = guest_test_phys_mem +
-					   (vcpu_id * guest_percpu_mem_size);
-				vcpu_mem_size = guest_percpu_mem_size;
-			} else {
-				vcpu_gpa = guest_test_phys_mem;
-				vcpu_mem_size = guest_percpu_mem_size * nr_vcpus;
-			}
-			PER_VCPU_DEBUG("Added VCPU %d with test mem gpa [%lx, %lx)\n",
-				       vcpu_id, vcpu_gpa, vcpu_gpa + vcpu_mem_size);
+			vcpu_args = &perf_test_args.vcpu_args[vcpu_id];
 
 			/* Cache the host addresses of the region */
-			vcpu_hva = addr_gpa2hva(vm, vcpu_gpa);
-			vcpu_alias = addr_gpa2alias(vm, vcpu_gpa);
+			vcpu_hva = addr_gpa2hva(vm, vcpu_args->gpa);
+			vcpu_alias = addr_gpa2alias(vm, vcpu_args->gpa);
 
 			/*
 			 * Set up user fault fd to handle demand paging
@@ -355,7 +344,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 					    pipefds[vcpu_id * 2], p->uffd_mode,
 					    p->uffd_delay, &uffd_args[vcpu_id],
 					    vcpu_hva, vcpu_alias,
-					    vcpu_mem_size);
+					    vcpu_args->pages * perf_test_args.guest_page_size);
 		}
 	}
 
-- 
2.34.0.rc1.387.gb447b232ab-goog

