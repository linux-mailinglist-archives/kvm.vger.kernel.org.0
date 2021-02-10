Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A209316EA4
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 19:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbhBJS3p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 13:29:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234152AbhBJS1A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 13:27:00 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A54C061797
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 10:26:19 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id g17so754355ybh.4
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 10:26:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=qP8W8fesy6rJnl8LFgqcqjLlutMaErDAaGGZqrc5ReM=;
        b=IDp6SH8FucguzZwM8vydazWPuRkkyBURwiL/ZFhG83f5Q5Y+skiev5m88thBUBeLYl
         Iay7T5UchXCsRJGKwHSl4hVNHJ/uBXakaJW5DzO7yZx/DyNf4TA8C9JFEoBsct6RZp0/
         sKNwBbf3IFpvZbbYrwy15yEgKWeCtsA29trFbXPLw0+5eCelppO7mtBn+X/1IpXEQr70
         iUilso7ROd+pLw5F43ylf16NL7Pyr8kl11UulCYa4UYzdZHZKsnhGvHosy94UoAabhaz
         X1pvWU5032pfh2HnarV4zCvh06PlflO5u6EgP2Te3X8H5jJPaYw7yy+BC6lRWTPPQSOF
         148g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=qP8W8fesy6rJnl8LFgqcqjLlutMaErDAaGGZqrc5ReM=;
        b=DE7N/JaLq/fDkhoOaQkTVkVWfrrps2mZkuytu6sW8OGi8ocbRQsrV9h/YgAuFJ9mn6
         BCVdPh5zVGz9WJ476eIEP/pG1FQ1IWGxT1EZzZQA6rQXW1GN3v61411cbtsLLmF6vjQ+
         ZZ+wdJwXI/uHeR4tYaRmBaNyTJkJu4xZSyzuXU9HyfRUJ4iLNCYjNQ0pxob5+SwGnHi2
         AVHT6UA8xBuCh5qv5KmrC74gLxFZQgr1Ebrkb08nsbJYyJ8kpANumiqnRYiyA0ssRVE1
         8NVCRoJIBdc0yTHcbccLFXtO2RXGYPskdmxf6+PFyGRvmXB/di17NMtSt9MEGq6w9lZi
         aEOA==
X-Gm-Message-State: AOAM532m9eI0LENAYXZz5cQ1MxixVx+p3bcZ5zXlhTiFprjSFWiQbGaz
        HN90vXWyMfsy8cno7J3eljI5QkBRP+Y=
X-Google-Smtp-Source: ABdhPJyTPd8l9+mGvnSeTAJBG98ENRZMMYVImrNTwMJ6HjhsDvl2vtCgsZfrvQuK99U9B1lHIpDbTDAOWVM=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:11fc:33d:bf1:4cb8])
 (user=seanjc job=sendgmr) by 2002:a25:ad26:: with SMTP id y38mr6225800ybi.391.1612981579216;
 Wed, 10 Feb 2021 10:26:19 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 10 Feb 2021 10:26:06 -0800
In-Reply-To: <20210210182609.435200-1-seanjc@google.com>
Message-Id: <20210210182609.435200-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210210182609.435200-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 2/5] KVM: selftests: Fix size of memslots created by Xen tests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For better or worse, the memslot APIs take the number of pages, not the
size in bytes.  The Xen tests need 2 pages, not 8192 pages.

Fixes: 8d4e7e80838f ("KVM: x86: declare Xen HVM shared info capability and add test case")
Cc: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c | 3 +--
 tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index bdb3feb86b5b..cb3963957b3b 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -79,8 +79,7 @@ int main(int argc, char *argv[])
 
 	/* Map a region for the shared_info page */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
-                                    SHINFO_REGION_GPA, SHINFO_REGION_SLOT,
-				    2 * getpagesize(), 0);
+				    SHINFO_REGION_GPA, SHINFO_REGION_SLOT, 2, 0);
 	virt_map(vm, SHINFO_REGION_GPA, SHINFO_REGION_GPA, 2, 0);
 
 	struct kvm_xen_hvm_config hvmc = {
diff --git a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
index 86653361c695..8389e0bfd711 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
@@ -102,8 +102,7 @@ int main(int argc, char *argv[])
 
 	/* Map a region for the hypercall pages */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
-                                    HCALL_REGION_GPA, HCALL_REGION_SLOT,
-				    2 * getpagesize(), 0);
+				    HCALL_REGION_GPA, HCALL_REGION_SLOT, 2, 0);
 	virt_map(vm, HCALL_REGION_GPA, HCALL_REGION_GPA, 2, 0);
 
 	for (;;) {
-- 
2.30.0.478.g8a0d178c01-goog

