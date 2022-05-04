Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5E251B301
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238081AbiEDXBG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 19:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380492AbiEDXAD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 19:00:03 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299BF57B1A
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:53:28 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id d22-20020a25add6000000b00645d796034fso2320203ybe.2
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=1Ko89WgoR4QoPr6VqUAmRTjNB65KGevR+vu8Lfe+KrY=;
        b=hpwTYNVKayJGrqxOPwmZTNGFN/7HtMmZwmydASwz0toZ91ismPoEA3BHf7yB3mF0uI
         0ZZwLS7tDoAO9i9jqoXZLfJh0hnPWnyvQoGSUwnAwkFvYIFwM+ghzuoRM+KIXOi9y5bG
         w2zCfbsMMH+e3h+27GWN/m/TvbtQdMFculxXV3ABs29LwJOdf9lllFbHo+jQH/kHirNb
         xoA0grfeZl8pLt/Uq+fWXcupWBFmHXvjHK3ANNVFC7/C0qx60/zHA0F5+dfiiS8Jsg8S
         8kju4HrgNQwiCDoKQDiGnYlEVPBYFafuUR0QQKJZnwiPwHpozct6r4AABGnbqZ2NX38Z
         CV+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=1Ko89WgoR4QoPr6VqUAmRTjNB65KGevR+vu8Lfe+KrY=;
        b=zpA5PGIVW1WjE8rEtRQP+N9FzHDgHspnqAnFE3d1Oq/bfPWeMumjTLMTiNg84m6QrT
         hU58S21RwIZ70R+vjfIR7D6zfY78px+PtSnd1h/wkN+X5hAw9Fw1x3VkyNj2rXB8qlXu
         FcyV3jumwN/FnaLtqCS7RRUESSvocbm/2j8UBsaQhnPZw5W5x9O+0+7E2BNDv3KZPw5B
         SkpM4I6ct/BoQxXs1HglenR1hPgoqj2nxx5Dv0xxw4p5pRDAJi+GPjdJD4Ov1WhaNuJE
         8qPr8iYT/IZLP35y3dQZmCuX+rVWN8twf+vgvx0Uae+Bqblu/deYaFDFxMmOr2pU8QLr
         kNaw==
X-Gm-Message-State: AOAM533XEq4f0Vbwpupi5/ZXDm/janvkdYS4wdhVUgbsMQY+0ePm85LC
        cH06PsKTDbG9moISkCortYSgSLBhXDw=
X-Google-Smtp-Source: ABdhPJxIyNosEuODp1hRl7pKdS4yHHRTzfhNLT+Ogmit5H7vWGukQNk7xEe18n7Uyy+dvIAC6pWKQmdzoOE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:2646:0:b0:645:8261:d7ff with SMTP id
 m67-20020a252646000000b006458261d7ffmr20289498ybm.351.1651704774982; Wed, 04
 May 2022 15:52:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:49:04 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-119-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 118/128] KVM: selftests: Remove vcpu_get() usage from dirty_log_test
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Grab the vCPU from vm_vcpu_add() directly instead of doing vcpu_get()
after the fact.  This will allow removing vcpu_get() entirely.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index b61af23ba434..73c6fd9c850c 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -668,7 +668,7 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 	}
 }
 
-static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
+static struct kvm_vm *create_vm(enum vm_guest_mode mode, struct kvm_vcpu **vcpu,
 				uint64_t extra_mem_pages, void *guest_code)
 {
 	struct kvm_vm *vm;
@@ -679,7 +679,7 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
 	vm = __vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages);
 
 	log_mode_create_vm_done(vm);
-	vm_vcpu_add(vm, vcpuid, guest_code);
+	*vcpu = vm_vcpu_add(vm, 0, guest_code);
 	return vm;
 }
 
@@ -713,10 +713,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	 * (e.g., 64K page size guest will need even less memory for
 	 * page tables).
 	 */
-	vm = create_vm(mode, 0,
-		       2ul << (DIRTY_MEM_BITS - PAGE_SHIFT_4K),
-		       guest_code);
-	vcpu = vcpu_get(vm, 0);
+	vm = create_vm(mode, &vcpu,
+		       2ul << (DIRTY_MEM_BITS - PAGE_SHIFT_4K), guest_code);
 
 	guest_page_size = vm_get_page_size(vm);
 	/*
-- 
2.36.0.464.gb9c8b46e94-goog

