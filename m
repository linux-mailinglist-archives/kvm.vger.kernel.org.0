Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88CD366AC8B
	for <lists+kvm@lfdr.de>; Sat, 14 Jan 2023 17:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjANQQQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Jan 2023 11:16:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbjANQQN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Jan 2023 11:16:13 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAFB7EFF
        for <kvm@vger.kernel.org>; Sat, 14 Jan 2023 08:16:12 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-4d5097a95f5so123719757b3.1
        for <kvm@vger.kernel.org>; Sat, 14 Jan 2023 08:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KJuCfGqvEnsFNnzPmA6roby62rnOaZ6HAgmfPgHZMU4=;
        b=HH6qILaSThu/E2sCBhXNknYppHTUrCYzRSNI528hMzMluNoHAMRek1uOSm4lutB73C
         GQ5rMyDbGybdzzlBIgX1eO4sAww9WKFm0Xyl/5ek5nw8HHwWmO27IABN2tNTwmvsKRNC
         KcMn3jcGSarR7ZUWw5L90K0lI980ApitslUWbbMNFL+7j1mPPgSsKqBaRqbJ6c781rvZ
         JrEJDJYxk/Wze8ty3yfUELFdq+BH/+XYgLmYDmLIlYZI40xWGFs1o2K9wKe8zfhVBbQy
         ySp6JF8PNNUSB+MRAcJBeXBKt8hb71Nya+fSCRtiBdsHbquvbR7k8Nvg7ualkhOrTtRU
         iNsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KJuCfGqvEnsFNnzPmA6roby62rnOaZ6HAgmfPgHZMU4=;
        b=4zZTar7662yKL40KdbJcjN95BwtQhR9HBs+xtc9hYCQCndZmfqmdF6YKLk/XwNeg5P
         QFeOGku1IZTSTpYHzCTP5Xf89h61eRMzGqPAQOOu13jk7upM3SREjQGX+ZDfk2c+qf9G
         XRacwM9gHfbvmheM9CTM+bukKzeGae8hjj4DU7GqKWZc7//qW/bKnYWTgnWdt4E/jfaw
         RXsk8IVzcah7+c8OJK0eURCn/9a3l0EheKbXZEs18AQU6DdorZEUptiAVwv4l1aS0+Jp
         qH0VjvihU3fSrPJJpq08u3+DVRAHGWLveYcgX/8cIGs4kBCjWcrjnxrUZ07uBNVzwpoH
         G2TA==
X-Gm-Message-State: AFqh2krZM9rQLC+ovZnL5K9F3Ruo9qgPanrDJTXYPsYSbOHhvtCLZ+9/
        u5q5s4U5790s/7v6NWg6kemwxSkQXL/hWmW+bg==
X-Google-Smtp-Source: AMrXdXu0CT3jcwq5kiw+ed+TV0oTW59J195KjR8I23YWK/pDZp5PcH1hjTV7KmWK7wwNI26Kv6K0I1rzybDLLwfXbw==
X-Received: from ackerleytng-cloudtop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:b30])
 (user=ackerleytng job=sendgmr) by 2002:a81:1650:0:b0:3b3:174d:7a6b with SMTP
 id 77-20020a811650000000b003b3174d7a6bmr3566865yww.204.1673712971473; Sat, 14
 Jan 2023 08:16:11 -0800 (PST)
Date:   Sat, 14 Jan 2023 16:15:56 +0000
In-Reply-To: <20230114161557.499685-1-ackerleytng@google.com>
Mime-Version: 1.0
References: <20230114161557.499685-1-ackerleytng@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230114161557.499685-2-ackerleytng@google.com>
Subject: [PATCH 1/2] KVM: selftests: Fix initialization of GDT limit
From:   Ackerley Tng <ackerleytng@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Wei Wang <wei.w.wang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Subtract 1 to initialize GDT limit according to spec.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index acfa1d01e7df..33ca7f5232a4 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -502,7 +502,12 @@ static void kvm_setup_gdt(struct kvm_vm *vm, struct kvm_dtable *dt)
 		vm->gdt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
 
 	dt->base = vm->gdt;
-	dt->limit = getpagesize();
+
+	/*
+	 * Intel SDM Volume 3, 3.5.1: "the GDT limit should always be one less
+	 * than an integral multiple of eight"
+	 */
+	dt->limit = getpagesize() - 1;
 }
 
 static void kvm_setup_tss_64bit(struct kvm_vm *vm, struct kvm_segment *segp,
-- 
2.39.0.314.g84b9a713c41-goog

