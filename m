Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B56553C1D3
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240619AbiFCAzS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241351AbiFCAvC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:51:02 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135CB34B89
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:47:49 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id u1-20020a17090a2b8100b001d9325a862fso3520601pjd.6
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=1ZvG+5/wZpUAC90uvh+akjpkSn0i92RxKUjEYWBqrYg=;
        b=sgScZDk5zVz4fw/BQVRlIJp5pQMk8dEkokKERscif59Eeqo3a6F4CqAk8JFLmpiHXF
         NHc/CFk6Z91YX0RCXgwFA8DvuUXxo4BmnP2DVk9neuEVzKIHslb2VVPqW2bNUcEIZMNY
         fJGJxnwGEAYHk+i4RUGq/8ZZebxz6jVwF2ClNhu/0paTnTcwMBboxJ7n+iVMP1cg1ju+
         1lX6HdYzH89D18KqzgJDDkNluwHnLe0iGV0u5cujXLbWt9Btb1vgqP2A6bA1FE+OD0a0
         pZ1WAWeRnWW+L5TUiibIQsIPs7zZNQXIF/WRk1mXFLAqkDFbwvq6veSJXeCn41Q4+pS1
         0fVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=1ZvG+5/wZpUAC90uvh+akjpkSn0i92RxKUjEYWBqrYg=;
        b=kyIEPLC04WubQnBm2tLDywELrM5dpIlbvTD4e3jnoe0s1uAx2B1w1g0Tkrh384Pzf5
         j2xIuqy7AAuFYSvDfHrSRB6Z9aSJstCSUa2X2puKXv/wpOKo7nvbS8wPqHP4JIzvu1B1
         oQXlE+zadWK/hKpjrFf0WxAsF99xArwV1R5+kkUAq7y0poVX4efxjKWJvUphkeKcXR4Q
         7fa/0RRHAp3XA4KpCgRlVYZdurUpmXqerEC2KlDCML2XtUR9hDFxlPAz/T/wiL0UXvL0
         Kj2c9j050dsb3NCzv97RIB/9sK9Z0hiS/NPFuL4led0vseG4TpwPf1BvoLTsu+bfs1+L
         hujA==
X-Gm-Message-State: AOAM530MyjSSmHFr4EyK1RfKufEEYjiawxuxwVLRZkwHGvCsZpzEeZP3
        BmVLx2ko//vnWIUqrLv+fIbxXypcfe8=
X-Google-Smtp-Source: ABdhPJyVF7MsShOiUhLdM3RTFRisaQrEeNwNutLK3YJNPYJsVvtsN8aAT0rvcmwqun9joKQpqnheHRRFj90=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:6907:b0:162:1237:42df with SMTP id
 j7-20020a170902690700b00162123742dfmr7622482plk.157.1654217269184; Thu, 02
 Jun 2022 17:47:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:43:27 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-141-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 140/144] KVM: selftests: Drop DEFAULT_GUEST_PHY_PAGES, open
 code the magic number
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove DEFAULT_GUEST_PHY_PAGES and open code the magic number (with a
comment) in vm_nr_pages_required().  Exposing DEFAULT_GUEST_PHY_PAGES to
tests was a symptom of the VM creation APIs not cleanly supporting tests
that create runnable vCPUs, but can't do so immediately.  Now that tests
don't have to manually compute the amount of memory needed for basic
operation, make it harder for tests to do things that should be handled
by the framework, i.e. force developers to improve the framework instead
of hacking around flaws in individual tests.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 1 -
 tools/testing/selftests/kvm/lib/kvm_util.c          | 8 +++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index db9c00a7af4e..1c762988ab9c 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -100,7 +100,6 @@ memslot2region(struct kvm_vm *vm, uint32_t memslot);
 #define KVM_UTIL_MIN_VADDR		0x2000
 #define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x180000
 
-#define DEFAULT_GUEST_PHY_PAGES		512
 #define DEFAULT_GUEST_STACK_VADDR_MIN	0xab6000
 #define DEFAULT_STACK_PGS		5
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 494bce490344..2dcd83a03cc2 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -270,7 +270,13 @@ static uint64_t vm_nr_pages_required(uint32_t nr_runnable_vcpus,
 		    "nr_vcpus = %d too large for host, max-vcpus = %d",
 		    nr_runnable_vcpus, kvm_check_cap(KVM_CAP_MAX_VCPUS));
 
-	nr_pages = DEFAULT_GUEST_PHY_PAGES;
+	/*
+	 * Arbitrarily allocate 512 pages (2mb when page size is 4kb) for the
+	 * test code and other per-VM assets that will be loaded into memslot0.
+	 */
+	nr_pages = 512;
+
+	/* Account for the per-vCPU stacks on behalf of the test. */
 	nr_pages += nr_runnable_vcpus * DEFAULT_STACK_PGS;
 
 	/*
-- 
2.36.1.255.ge46751e96f-goog

