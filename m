Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420F23B0E36
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 22:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbhFVUI2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 16:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbhFVUIR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 16:08:17 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A5AC0617A6
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:06:00 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id jm5-20020ad45ec50000b0290219dc9a1ab8so271285qvb.21
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=l/JRo2YX24UnuecMDab+COARG9prpR51zi0SeGy+27g=;
        b=uFZQ1pZU0jM+GfAZ1WNnhwK06kyfcMFKTheDt+RKPq3wb9aLAfCGX9SCZl8oZg95HI
         /ZoI/qnQex6nCMnmNBzx0FmbFjWPvR8k8gsPvdNaFkqqnFfUHkxrI9w7ozCeKPYEONGk
         ZWPeVX3e3R1YcOH0s83VLSEFq9qk7stH2pxPc7OdFPflxTnZiVJ5waPuH2rUK/kBFkeJ
         AMIOTbhhPJcOJWtjR7+/+D3TsvTLW7Kfhjks6JnXofFCwsFxQsERh+jxjgmIB5kG/n5h
         9oJg62NjUttyvr1cNNRUV8Tlg2+UPHmS67XrQQVjk+BTbEv7wZ9lu2iBPpQL4tjk4t39
         MuRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=l/JRo2YX24UnuecMDab+COARG9prpR51zi0SeGy+27g=;
        b=GrskvctwTZkGdfXHY1n4GcJILb5RvwMFK+w5DcI/MVGeq8nQ+K1NAZpsv0i2fjBhx5
         kkj7rSQ/kFIbARpG/soFbO5GRIBKO1Fh30TdL5Ex14MUVqdev+FFVNh/1JAiRhnpN3NM
         L5Y5R8Zea7Vf6no+gZb+8r5+iU/WXdHny4uBeOBhcfqXspszf8vHrCvdoSTxJaHSrhIT
         wLkUUvSY1cZfB5/AGz89tVXnjt65mGbwRtJ1G3/eiKd0QCBs0YMJAZHOgPHe9zO4wSIB
         bUf6ERlu01nbc6osVkW+qvyNRq+wZjronDm1nmCGmoYLuBivj/oZoC+mBq+O604qU0Fm
         k91w==
X-Gm-Message-State: AOAM53364Kzt+tic2vAdzKxOOtQZNEKPcsrxVCV3mnMrjmkXZQS2He9w
        l3WRsxrzKavtLnbYlSRh2hket0Ns0Ck=
X-Google-Smtp-Source: ABdhPJx5ixIQh4nUYSOEJyh9rcUVCRZR/7CJ5Ngnxn4UBt9/hGVCPxU0KBjbqL/cQOYwzJBK/z6T6aDjMTU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:a0c:c507:: with SMTP id x7mr589963qvi.10.1624392359533;
 Tue, 22 Jun 2021 13:05:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 13:05:19 -0700
In-Reply-To: <20210622200529.3650424-1-seanjc@google.com>
Message-Id: <20210622200529.3650424-10-seanjc@google.com>
Mime-Version: 1.0
References: <20210622200529.3650424-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 09/19] KVM: selftests: Use alloc page helper for xAPIC IPI test
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

Use the common page allocation helper for the xAPIC IPI test, effectively
raising the minimum virtual address from 0x1000 to 0x2000.  Presumably
the test won't explode if it can't get a page at address 0x1000...

Cc: Peter Shier <pshier@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
index 21b22718a9db..5a79c8ed4611 100644
--- a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
@@ -427,7 +427,7 @@ int main(int argc, char *argv[])
 
 	vm_vcpu_add_default(vm, SENDER_VCPU_ID, sender_guest_code);
 
-	test_data_page_vaddr = vm_vaddr_alloc(vm, 0x1000, 0x1000, 0, 0);
+	test_data_page_vaddr = vm_vaddr_alloc_page(vm);
 	data =
 	   (struct test_data_page *)addr_gva2hva(vm, test_data_page_vaddr);
 	memset(data, 0, sizeof(*data));
-- 
2.32.0.288.g62a8d224e6-goog

