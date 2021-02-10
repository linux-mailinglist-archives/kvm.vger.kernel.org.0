Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3445B3173F1
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 00:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233225AbhBJXIJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 18:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233849AbhBJXH6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 18:07:58 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67BD8C061797
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 15:06:44 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id j128so4258654ybc.5
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 15:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=/D10CsPyV0SuKQhqygo5NqkKV98of4qDPh0B02671yY=;
        b=p6eFbB4lV84/po/qFsuqgktneKBFo/rdWPBnWdHij7zzm6K8PMOFLAPqOCJv36wE/4
         l7WuOWfAhWI1QejNw5yQ43OLcuej3BIfd5lPcxNE3OgTCnUOoF6WjcOLnKNty6n+Ap0f
         lj5gSFkg7iIFNFW5Q/hNNPBxlY+YcgFKS09YmueZQc2F2EL6uKBb2Kn7txvRVFK0pIQP
         mMW0869Q9IizM29Pm509hXPM4JFymamPqEnzmvcLCHxwn5k+7uGfpOCnHT5tCq2wLA7K
         IBqA1IVe0V4NMIEJtaBxHpQTSMafxvECoJ2CGME+Y+yocFlTTvwb09xLNPiDNGduuhhG
         bXOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=/D10CsPyV0SuKQhqygo5NqkKV98of4qDPh0B02671yY=;
        b=uBhKCAQ3T2dI6i/PIO5uYDhzZ+OLx9VNBz16FRmxMVwgHxHON/LQAnuoj1lY5J3EiR
         +MX55gdMKARIawmn4cveBvURyGbCksT/QE1bm71JpcZJe5FFk0An7hjKuGALDDtDErIk
         iuXkKN0I3k6nO3tTp3PhHLmVBS8C5io1GHvqgtF+APZS+VmT9p/UoswRxoHOErEjRiWE
         X0oHxijpYJu67aho78K39B9U+SZ1SlPwMpfsRytfleRulrITwHWHqQ54hx2ZjePyFcZE
         BBw2ooQyT5IM9hsTdFA1WlnCxoxZ3H+7+ROYVxrR5G9TfcV5S1SYpWDxYfhIa+VbEcuO
         kFDQ==
X-Gm-Message-State: AOAM531mPF1g38ib2DBabsSXgx+4/3fpeeS2noDOFHz69Culzd0gjpN1
        uJ/IAZJS/m2FcjmTUrEsrnyxwkBSptg=
X-Google-Smtp-Source: ABdhPJziAmKySI1rzYdb9feq0O5Fk7tmeqsze9N/hr8LgrlFki/ADyfd+JFTGXW5t1oLWJiizAKMxq7CDA8=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:11fc:33d:bf1:4cb8])
 (user=seanjc job=sendgmr) by 2002:a25:68cf:: with SMTP id d198mr3045894ybc.258.1612998403659;
 Wed, 10 Feb 2021 15:06:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 10 Feb 2021 15:06:15 -0800
In-Reply-To: <20210210230625.550939-1-seanjc@google.com>
Message-Id: <20210210230625.550939-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210210230625.550939-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 05/15] KVM: selftests: Require GPA to be aligned when backed
 by hugepages
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Assert that the GPA for a memslot backed by a hugepage is 1gb aligned,
and fix perf_test_util accordingly.  Lack of GPA alignment prevents KVM
from backing the guest with hugepages, e.g. x86's write-protection of
hugepages when dirty logging is activated is otherwise not exercised.

Add a comment explaining that guest_page_size is for non-huge pages to
try and avoid confusion about what it actually tracks.

Cc: Ben Gardon <bgardon@google.com>
Cc: Yanan Wang <wangyanan55@huawei.com>
Cc: Andrew Jones <drjones@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c       | 2 ++
 tools/testing/selftests/kvm/lib/perf_test_util.c | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 2e497fbab6ae..855d20784ba7 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -735,6 +735,8 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	else
 		ASSERT_EQ(src_type, VM_MEM_SRC_ANONYMOUS);
 
+	ASSERT_EQ(guest_paddr, align(guest_paddr, alignment));
+
 	/* Add enough memory to align up if necessary */
 	if (alignment > 1)
 		region->mmap_size += alignment;
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 81490b9b4e32..f187b86f2e14 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -58,6 +58,11 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
 	perf_test_args.host_page_size = getpagesize();
+
+	/*
+	 * Snapshot the non-huge page size.  This is used by the guest code to
+	 * access/dirty pages at the logging granularity.
+	 */
 	perf_test_args.guest_page_size = vm_guest_mode_params[mode].page_size;
 
 	guest_num_pages = vm_adjust_num_guest_pages(mode,
@@ -87,6 +92,10 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 	guest_test_phys_mem = (vm_get_max_gfn(vm) - guest_num_pages) *
 			      perf_test_args.guest_page_size;
 	guest_test_phys_mem &= ~(perf_test_args.host_page_size - 1);
+	if (backing_src == VM_MEM_SRC_ANONYMOUS_THP ||
+	    backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB)
+		guest_test_phys_mem &= ~(KVM_UTIL_HUGEPAGE_ALIGNMENT - 1);
+
 #ifdef __s390x__
 	/* Align to 1M (segment size) */
 	guest_test_phys_mem &= ~((1 << 20) - 1);
-- 
2.30.0.478.g8a0d178c01-goog

