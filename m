Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9183B0E3C
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 22:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbhFVUIi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 16:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232988AbhFVUIW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 16:08:22 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A91C0611C2
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:06:02 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id q207-20020a3743d80000b02903ab34f7ef76so19508961qka.5
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=HLRh8AoU2d8SgUrNmHvZ5Mv1ioaKQWiagkHThEpM1Is=;
        b=G+GmFiPkocigkueGFrHCAgPjZhDtZlm7aPH7CS0V9LTvDu1nKkmqh3PUSLhTtriueE
         V29YT5vnhv6ZAttFC/tB+VsqGlU45uuxR8zOiTO3LX7lyZi7E2B2PN46GizH2hzXSMP5
         9gGV5cO7JYYAUAZPqyibqXMxhLn7jW+6L+7Z+ac5k8HOQVwJk5xH2OhJKk2QOtSoYZza
         7M/S8pvXOuJIVhrSWU4ytbQAexzjNIgpZdHSF+1v5OvJqA4+kdRoS4QzQyqflHaluR2w
         T8WjkKdYxrG447Dmcl/+t1G4wkL+opHWKWFPVGush4MrJFGB15GtNETh9yza730zYilo
         qdlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=HLRh8AoU2d8SgUrNmHvZ5Mv1ioaKQWiagkHThEpM1Is=;
        b=C0bcdxzfntRhanXJujus4iQppf3OPYygnwoodYoIZ2ioKWUblCcbJTy+/myQerk33A
         U6C3GdLfiUZ3Z67Som51rKCOpalsps58MWAW60XPVlHC9zg8aVj82uqhkWpgXZXmKk1O
         ygBX+f56czEJ/65UzhKmWnf/KN9avyn1sigi9zoreqWa/IXkCi0DVWeKmikqna9wwPGr
         +cXozW8WNWa+PtoQmj5INyfePkKnYK75DPR1DwTomMux/8tDXxpwzwhxEUhJZH7+buIz
         vyZL50tIlbmu/zF7lUjNM989yNRJaGEfQyy15JlrhCUeJPc6dFn1HSommZbKw9ILgAJX
         eGBg==
X-Gm-Message-State: AOAM5319Fa+4JaJoiFuDLsqXZgrCMbLSoJbZevgPkLHXwMHWoqBhYBBl
        IPCqt9uPT343rOyO7QPH19WDaasWhLM=
X-Google-Smtp-Source: ABdhPJzEPoaOhegczuUyhwK+503E54Bl8gSY/uaudyXrO4kdWtq3dfiFDpHOuZxavTgRIELElHBaj8Jxe2U=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:a0c:80ec:: with SMTP id 99mr506577qvb.55.1624392361765;
 Tue, 22 Jun 2021 13:06:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 13:05:20 -0700
In-Reply-To: <20210622200529.3650424-1-seanjc@google.com>
Message-Id: <20210622200529.3650424-11-seanjc@google.com>
Mime-Version: 1.0
References: <20210622200529.3650424-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 10/19] KVM: selftests: Use "standard" min virtual address for
 CPUID test alloc
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use KVM_UTIL_MIN_ADDR as the minimum for x86-64's CPUID array.  The
system page size was likely used as the minimum because _something_ had
to be provided.  Increasing the min from 0x1000 to 0x2000 should have no
meaningful impact on the test, and will allow changing vm_vaddr_alloc()
to use KVM_UTIL_MIN_VADDR as the default.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/get_cpuid_test.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c
index 8c77537af5a1..5e5682691f87 100644
--- a/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c
@@ -145,8 +145,7 @@ static void run_vcpu(struct kvm_vm *vm, uint32_t vcpuid, int stage)
 struct kvm_cpuid2 *vcpu_alloc_cpuid(struct kvm_vm *vm, vm_vaddr_t *p_gva, struct kvm_cpuid2 *cpuid)
 {
 	int size = sizeof(*cpuid) + cpuid->nent * sizeof(cpuid->entries[0]);
-	vm_vaddr_t gva = vm_vaddr_alloc(vm, size,
-					getpagesize(), 0, 0);
+	vm_vaddr_t gva = vm_vaddr_alloc(vm, size, KVM_UTIL_MIN_VADDR, 0, 0);
 	struct kvm_cpuid2 *guest_cpuids = addr_gva2hva(vm, gva);
 
 	memcpy(guest_cpuids, cpuid, size);
-- 
2.32.0.288.g62a8d224e6-goog

