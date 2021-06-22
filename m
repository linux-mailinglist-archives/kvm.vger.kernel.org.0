Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05203B0E28
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 22:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbhFVUIP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 16:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbhFVUII (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 16:08:08 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80297C0617A8
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:05:51 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id ez18-20020ad459120000b029020e62abfcbdso289617qvb.16
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=0XVpnJDCQ2BGPYYGq9GKg5rmYLHKHpfKOrEmd4DYAeA=;
        b=WNag1aUBLq5QLUAkuqsYWTWvrQZCab3ntIKWYAs6fGz5dn9vWB9jiSmSXGtJiQ9Qys
         k1+PizPNPk4JMuPE8kW2BSBLvTn7X3k34iUXNRQVwlXTH4SkZrSsDip+kiogggJ3Y/ra
         94cletA81xwRJHuc9/ix9hKTHYFvaZpM0B/ypX0uZJGnqNfuAugGIGqkheVwuLh6L4MQ
         T76nZ+mK2ps5O9Z4FfKraNyRg3ZoLCUQKa8doyr7ejg50m+yCPWEEJoyQgtOC1+xNKOr
         99iSYIGCY9UqF4CiQ0HWjml1OpOToA8cHIwAseBlZLP+edbd9k2mbRXhY0HthdunjlmW
         GPvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=0XVpnJDCQ2BGPYYGq9GKg5rmYLHKHpfKOrEmd4DYAeA=;
        b=plZvfZ/2nkcRt4azZLQWwX3PyWlNZE39WJ2/L5mlxpTKBRmcLT6mg9oetIExfs+6Sz
         h1N6+HpjBk3etPFO+TRClq4qi9ybGuTFGpuX3hrnR1yHfEfzX9JdDzEFJ9ooLG7A0+TS
         Hjz0mQKDUJ9hnYV86wd7fP3yC87D2q/Oi13Gh4ULWOLct1n/m7RCsVFCraI61oktkFjR
         h3NBzseh3RSnhc9R59VgAWdX3acjwhV7v8eI9GR20jzB4DJ8Aqgos/OyRzLeyBuuMkpO
         PNrUgnaUtzXLPYVfmBkCNzbVqWwiOBCe/NCwBoaFi7UxKKb5v8kYsGL2NH/CtXstX/2s
         vu9w==
X-Gm-Message-State: AOAM531MS8yfuTolv1MNC+2cv4jnyyFBM6Ve+p5zfr+SCWvBj4EzMWgD
        IYdzavSDB+imyFRHqLxpHgbM5mFyP4Y=
X-Google-Smtp-Source: ABdhPJzs+ALv5D72Nf8vUEzlz5cNz1p2vNm+Q4t4v+NwF1/jCsY4n3pF/FWV19dswgNzBEoFiYYKB2ywJQM=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:a25:c7c1:: with SMTP id w184mr6753970ybe.204.1624392350572;
 Tue, 22 Jun 2021 13:05:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 13:05:15 -0700
In-Reply-To: <20210622200529.3650424-1-seanjc@google.com>
Message-Id: <20210622200529.3650424-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210622200529.3650424-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 05/19] KVM: selftests: Use "standard" min virtual address for
 Hyper-V pages
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

Use the de facto standard minimum virtual address for Hyper-V's hcall
params page.  It's the allocator's job to not double-allocate memory,
i.e. there's no reason to force different regions for the params vs.
hcall page.  This will allow adding a page allocation helper with a
"standard" minimum address.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/hyperv_features.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 030c9447cb90..ad7ee06fa71e 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -629,7 +629,7 @@ int main(void)
 	hcall_page = vm_vaddr_alloc(vm, 2 * getpagesize(), 0x10000, 0, 0);
 	memset(addr_gva2hva(vm, hcall_page), 0x0, 2 * getpagesize());
 
-	hcall_params = vm_vaddr_alloc(vm, getpagesize(), 0x20000, 0, 0);
+	hcall_params = vm_vaddr_alloc(vm, getpagesize(), 0x10000, 0, 0);
 	memset(addr_gva2hva(vm, hcall_params), 0x0, getpagesize());
 
 	vcpu_args_set(vm, VCPU_ID, 2, addr_gva2gpa(vm, hcall_page), hcall_params);
-- 
2.32.0.288.g62a8d224e6-goog

