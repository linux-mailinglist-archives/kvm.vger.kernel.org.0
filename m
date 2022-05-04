Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5508A51B249
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 00:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379420AbiEDWy6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379455AbiEDWyG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:06 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E2812AB6
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:50:24 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 16-20020a630010000000b003c5e4be54b2so1354071pga.2
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=psBTJFrPNVICflUW/MEp016XD8K7S5scJ+9lP/twJs4=;
        b=D7wn7BHdvQWzQkObifPfo0AQLq5qVVVYYLAk3V35LZl5eMWDqO5nIZM7NSw5LDMGVI
         m9WMYX3SoEOjwRolxqUsmGewslsd2YrYQjhGzUsh9EebLfYC//bzpG9bggAxH6ldCl1O
         +rRGGo81kNuoADEVa6osnsIlJgzktWqhNdbFX2a6OC6LK2ejoOfIeHIAFvkLxdPc8OpP
         ZpMTxZZ0xm9cfJPwYaEVCnbwcPQSNj6PMSmJQ+sVX900D24sbiguet9oRPmu1UDK0BbQ
         QlqY7uaoVzZZiftoX5y6XiOjk3QXE58J2AWkuSzoEGlMmtTu32pZseiXsjOaNjWb2zV7
         r76g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=psBTJFrPNVICflUW/MEp016XD8K7S5scJ+9lP/twJs4=;
        b=3hx3serLyYmXiscmWYrUd25puvHUYregWqaGGL+RXbmE/0Ymf5YpLTXjXuifnSGGhx
         WJO8fClQTKh2w2+ODPLSuIeb0PmXiwYMTAilqcKw6LHDavVAr9a+Uy9s/cQry6s3R7lX
         wlssqvXOEdZP50xUnr7lDSFCk3QaitrfBCxYJHErrTyy70mxZzAnqwH5B8OryyXggrZQ
         vL12KfRwhjywk0PoRyGKQZlfiWDNEl1Onto4Lj8Sd8zsKt8JBIUcfO1xlV7lvJuY5GdG
         xmBXPdJJFbGJoM/iTyryTjTHlPU5DRiJypjHNq91oAdfh9yAP5xBktcbaL9AB+DFgI3f
         5B6g==
X-Gm-Message-State: AOAM531V1t9HxfpD5OnQLBgkF9xAMHK8X8IbDNMp3RWdihvCz2y8ViYn
        Lgx+WbEF/mBEr9oYJkxUy6dLUQtkaFE=
X-Google-Smtp-Source: ABdhPJyG7Ej5qmVSbIsTd7T7MsAiDi3azvdGk3RdO1PW3OENI3MLkNrdqZek1cRvp64p338+pEpeq/VTNHQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c986:b0:1d9:56e7:4e83 with SMTP id
 w6-20020a17090ac98600b001d956e74e83mr139603pjt.1.1651704623277; Wed, 04 May
 2022 15:50:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:36 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-31-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 030/128] KVM: selftests: Push vm_adjust_num_guest_pages() into
 "w/o vCPUs" helper
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
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

Move the call to vm_adjust_num_guest_pages() from vm_create_with_vcpus()
down into vm_create_without_vcpus().  This will allow a future patch to
make the "w/o vCPUs" variant the common inner helper, e.g. so that the
"with_vcpus" helper calls the "without_vcpus" helper, instead of having
them be separate paths.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index bf14574288e7..9a82d44e427d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -286,6 +286,8 @@ struct kvm_vm *vm_create_without_vcpus(enum vm_guest_mode mode, uint64_t pages)
 {
 	struct kvm_vm *vm;
 
+	pages = vm_adjust_num_guest_pages(VM_MODE_DEFAULT, pages);
+
 	vm = __vm_create(mode, pages);
 
 	kvm_vm_elf_load(vm, program_invocation_name);
@@ -345,8 +347,6 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 		    "nr_vcpus = %d too large for host, max-vcpus = %d",
 		    nr_vcpus, kvm_check_cap(KVM_CAP_MAX_VCPUS));
 
-	pages = vm_adjust_num_guest_pages(mode, pages);
-
 	vm = vm_create_without_vcpus(mode, pages);
 
 	for (i = 0; i < nr_vcpus; ++i) {
-- 
2.36.0.464.gb9c8b46e94-goog

