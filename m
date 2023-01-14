Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298E966AC8D
	for <lists+kvm@lfdr.de>; Sat, 14 Jan 2023 17:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbjANQQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Jan 2023 11:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjANQQS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Jan 2023 11:16:18 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9CD393EA
        for <kvm@vger.kernel.org>; Sat, 14 Jan 2023 08:16:17 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id d8-20020a17090a7bc800b00226eb4523ceso10801675pjl.7
        for <kvm@vger.kernel.org>; Sat, 14 Jan 2023 08:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BzgEcC1ikADsSn9DBlaMTyfNz57w5J1py6VoLV6xpdI=;
        b=oKK4Om/Zr+blK1xdfE/T2ofv4VPBmTYvP4I3rHnvDEIufhZEZqJVCXwSyF0GVNQspG
         P8jHMhQWgQ3XuQscECgXhAjxPT7IpynAt5BnQbBir+lRADI3e70KMdQUelWIKZDOTZFo
         pNCut45+TEwJGwbzceWNdgtEqKkKaQMt6vQTCtwsf01/DlP9si1UsNWDrvKZ2p2/CAKw
         JE9vuWKLv5ahm7nO5Z2DGyAo+Ajg+4Up0tq+miYlAlcU1mHNE6QzUQMRwqdLW8t1Itlz
         ZLhl9x++3lzk2S4dDJ4PDF9CPYhMZyqk+CNCkcJpmo5ZhAL+aN5/1f6dI56WeHsAm8Sj
         naMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BzgEcC1ikADsSn9DBlaMTyfNz57w5J1py6VoLV6xpdI=;
        b=qG8elzXS93onHNtEWnX05Cj8cAKHt9xuOGLYCXPuxV3KwfBzknW5KyEp+e8ghIqBUm
         LJs14XjnlQtLbgRsWzJ+7XBsCw4H78DdbGyeryBVgBdMyW9ijRA93/nEcpWf7FL9j8je
         UxhGerp+ZfkceotqIFVtvSm/WQDGV28ykhH4xS70hKVuxkprxgT5A1IuTB804nBtrFRy
         daynlZI3sIzDQTo44leF/pbofYuEK+zjkHSmgEDVB2yrgESkMB3TjVsC+C3K37UybeSc
         2mlUAIaOBb7tnwvBRYffRLPUG1rSRHWw280YQS3NLnFmbTv5+qOFbE/LfJETzbomnPS4
         12Cw==
X-Gm-Message-State: AFqh2kon07hpYu1dIKRu2io8KyByTHqXh0s8V9l/EUq1JxTPrgHGRA8S
        EkE87Hm4mOUb/eN3YV7Vh1hDd/FLA13ftUsJ5g==
X-Google-Smtp-Source: AMrXdXv7MgW1NvJDvr1pN8B/h8tiUFGKAnGn7dp9yk9nJWdzTVBt8tzoDZkMtyWc7Oypt4sgFs2vxtow8do6j1Q9ZA==
X-Received: from ackerleytng-cloudtop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:b30])
 (user=ackerleytng job=sendgmr) by 2002:a17:90b:68e:b0:226:2e5:2e1a with SMTP
 id m14-20020a17090b068e00b0022602e52e1amr5030109pjz.145.1673712977533; Sat,
 14 Jan 2023 08:16:17 -0800 (PST)
Date:   Sat, 14 Jan 2023 16:15:57 +0000
In-Reply-To: <20230114161557.499685-1-ackerleytng@google.com>
Mime-Version: 1.0
References: <20230114161557.499685-1-ackerleytng@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230114161557.499685-3-ackerleytng@google.com>
Subject: [PATCH 2/2] KVM: selftests: Reuse kvm_setup_gdt in vcpu_init_descriptor_tables
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor vcpu_init_descriptor_tables to use kvm_setup_gdt

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 33ca7f5232a4..8d544e9237aa 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1119,8 +1119,7 @@ void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu)
 	vcpu_sregs_get(vcpu, &sregs);
 	sregs.idt.base = vm->idt;
 	sregs.idt.limit = NUM_INTERRUPTS * sizeof(struct idt_entry) - 1;
-	sregs.gdt.base = vm->gdt;
-	sregs.gdt.limit = getpagesize() - 1;
+	kvm_setup_gdt(vcpu->vm, &sregs.gdt);
 	kvm_seg_set_kernel_data_64bit(NULL, DEFAULT_DATA_SELECTOR, &sregs.gs);
 	vcpu_sregs_set(vcpu, &sregs);
 	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
-- 
2.39.0.314.g84b9a713c41-goog

