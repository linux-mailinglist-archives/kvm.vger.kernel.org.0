Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F6C53C203
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240088AbiFCAox (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240059AbiFCAob (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:31 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCE7344DF
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:29 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id l2-20020a17090a72c200b001e325e14e3eso3515446pjk.7
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=NzLwUqexNZjT3yoB75uY5U+PUQVNL95wKt+DgerDaYg=;
        b=EzvBNpaooL4lVwvoYGQMAHtMX118fSlveCNxwVzP7t5W8Zm0sf82ioVXVqk4QUIy8n
         e4MOUanVKR4rvd5K9GV+CtKdsyd1a9MESFfi0xknSazh/kUFe6xoGh09nXkrv4ozudPi
         nYvEZBlzpD94uJI/SC67PURcPf6MG6fnyGERMm7JxIwlR8c4UbJtBrCAfLyo3G2zYDwF
         IayqYyeJTj3glOyPYtwVzUgnGTp8mc1ptLN3PWWmTq68838vYP4v878e5JOXuuUsOxNV
         O9NN4oJG/J//YXK6rv3QiVkHhOZCPYFT0/OumRFvif3UBsxbsJJmjJzLy33DS3D2fMQ9
         Wvow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=NzLwUqexNZjT3yoB75uY5U+PUQVNL95wKt+DgerDaYg=;
        b=p6D/g+nQEBAq34QhtvaIT35euyo8Ok4WqosicK+1Mzu22d2jsyJSjjqVgAaEM9YD3l
         yM3m2LbMttZrp50cjRO0wntaM2UmzuxNPK+WMRUon2M3XUqg21G4wfGD7j/upJoYzQyN
         9SccPAwwD1Z+qPYUVMPagJ5Tv4LlQNkxqAnBIkZ5AX0LZrpWr0TckzofTL7+VX7sGHS0
         dTd1Ki+U2DkEvpqJkKkaCsl/W5qvcflP4yH8giL8COHXZGcawqUZ6ICRkRd82YWJrUjE
         JpBvRVJER7OeLQ/lHu0Cb9S0NeTcTDiYNsSAM1skKyacXv0wws66Mpka5uUnjiE2pagg
         Yjqg==
X-Gm-Message-State: AOAM530L1UFXHZyl3JXAeMLeZvg6Y/yNyLw36eBFUTWRsRFLBfowDkka
        OuDq9z4U/OYT4EnbItAEN1jKNogwqLg=
X-Google-Smtp-Source: ABdhPJypAaFR6wHZxtdXQ/bGs/sCM42waWGrIU8vJ4HjNW5iT2hB1fIe+44YI9B7zL4KDubGTVL1ISfY2BY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:114e:b0:4c8:55f7:faad with SMTP id
 b14-20020a056a00114e00b004c855f7faadmr36322623pfm.86.1654217069206; Thu, 02
 Jun 2022 17:44:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:36 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-30-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 029/144] KVM: selftests: Add a VM backpointer to 'struct vcpu'
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

Add a backpointer to 'struct vcpu' so that tests can get at the owning
VM when passing around a vCPU object.  Long term, this will be little
more than a nice-to-have feature, but in the short term it is a critical
step toward purging the VM+vcpu_id ioctl mess without introducing even
more churn.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
 tools/testing/selftests/kvm/lib/kvm_util.c          | 1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 6e63e7e57752..2e1453cb0511 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -47,6 +47,7 @@ struct vcpu {
 	struct list_head list;
 	uint32_t id;
 	int fd;
+	struct kvm_vm *vm;
 	struct kvm_run *state;
 	struct kvm_dirty_gfn *dirty_gfns;
 	uint32_t fetch_index;
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 220e079dc749..2d82b5720737 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1099,6 +1099,7 @@ void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid)
 	vcpu = calloc(1, sizeof(*vcpu));
 	TEST_ASSERT(vcpu != NULL, "Insufficient Memory");
 
+	vcpu->vm = vm;
 	vcpu->id = vcpuid;
 	vcpu->fd = __vm_ioctl(vm, KVM_CREATE_VCPU, (void *)(unsigned long)vcpuid);
 	TEST_ASSERT(vcpu->fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_VCPU, vcpu->fd));
-- 
2.36.1.255.ge46751e96f-goog

