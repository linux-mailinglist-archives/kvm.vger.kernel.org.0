Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F4A45D2AC
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 02:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352993AbhKYCBE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:01:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348219AbhKYB7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 20:59:01 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2CDC061372
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:04 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id hg9-20020a17090b300900b001a6aa0b7d8cso2324714pjb.2
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=OjqqXuO8pwNDEKnW90jeeumdtByfmdsW+OInQuGM4tA=;
        b=m5NqHGv+SztWMp5Lptoy9EyePBFwH8K8M8GbtCNBX4u6VzVcexQkMosTWQH7GfLJRR
         jNRG25yF/vdhLC7cWvboQitY6z3ynDvsXEYNnTb0QinzMa/JfuQj+8OpfpkQhpu6oDmB
         v8wJ0GXJZLIrfz8Ty6vEcZD9AIvp2tms2gBcQYPVnh474LGaJhf7n0xSorGMWHy2/r2l
         dfaUoxRxt/Jjh/rSFjQfZ4Jgpi7mmNIXRH2r/9saQdS+PNtYp7tStjJoXb+EvXQIh4l1
         O3w2CEJOHe+QWSpVvGENRUAMOaPhTUXk/NkeIF5APwcQebK4ngddSNpWnglEN+/pGGBP
         8C9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=OjqqXuO8pwNDEKnW90jeeumdtByfmdsW+OInQuGM4tA=;
        b=Np8ElAvmWBGqbgEeEY/R/3aLXSIm+6Oji+gH2UpzTHJSOWronLOcS/PzBkzE4V+3cl
         BTF9aWFjCqvP1pm/pOeJHOFvQVuzzAM0SELgMHp5jyd8/3ke7ADpIec7gtJVipBk4Q0G
         QSiqTHxzcR/+5k4nywcNE+nDEw/0XUkuOJm6Qn+b50Jxcp1usLCTIz8eG+HBcBm5gcbN
         akThBzxJ+x18QPysDoIVpba7lkHMLvI93YXTokHSYyhWB9d9ngNbE/T6K+6LTHUA5EDV
         3E1mP9fwUdMbhNz0fCxRV0uKrlRdGmcuYKyfSZqukRa98tdwoQ7jJ7Jsc/9Wy/TSMovb
         yjDA==
X-Gm-Message-State: AOAM530Sl9bQNFcOW4Xv/8eJ8ZDPITSVVcH4vYTV3mcNlcMji8RsTPLE
        8BkTW3+9B1djndu1vq1SJz7wLSsnZyw=
X-Google-Smtp-Source: ABdhPJzO6ePESRNv3n8QfW0sGAq/GJN0rDcnbA/wtgvwfmnVYJk9kZLOT7Edw7LkkMagqQlaVAgEpZy5ubA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:96ba:0:b0:49f:c35f:83f8 with SMTP id
 g26-20020aa796ba000000b0049fc35f83f8mr10836287pfk.47.1637803744053; Wed, 24
 Nov 2021 17:29:04 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:20 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-3-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 02/39] x86/access: Cache CR3 to improve performance
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a shadow for CR3, which avoids a significant number of VM-Exits when
KVM is using shadow paging.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/access.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 2e0636a..eb0ba60 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -189,6 +189,7 @@ typedef struct {
 static void ac_test_show(ac_test_t *at);
 
 static unsigned long shadow_cr0;
+static unsigned long shadow_cr3;
 static unsigned long shadow_cr4;
 static unsigned long long shadow_efer;
 
@@ -515,7 +516,7 @@ static void ac_set_expected_status(ac_test_t *at)
 static void __ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool, bool reuse,
 				      u64 pd_page, u64 pt_page)
 {
-	unsigned long root = read_cr3();
+	unsigned long root = shadow_cr3;
 	int flags = at->flags;
 	bool skip = true;
 
@@ -635,7 +636,7 @@ static void ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool,
 
 static void dump_mapping(ac_test_t *at)
 {
-	unsigned long root = read_cr3();
+	unsigned long root = shadow_cr3;
 	int flags = at->flags;
 	int i;
 
@@ -1084,6 +1085,7 @@ int ac_test_run(int page_table_levels)
 
 	shadow_cr0 = read_cr0();
 	shadow_cr4 = read_cr4();
+	shadow_cr3 = read_cr3();
 	shadow_efer = rdmsr(MSR_EFER);
 
 	if (cpuid_maxphyaddr() >= 52) {
-- 
2.34.0.rc2.393.gf8c9666880-goog

