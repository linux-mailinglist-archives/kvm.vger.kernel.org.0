Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1676016FB27
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 10:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgBZJo6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 04:44:58 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:37562 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbgBZJo6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 04:44:58 -0500
Received: by mail-pg1-f202.google.com with SMTP id b22so1516579pgs.4
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 01:44:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1mPKloEPT/3VCCmlRL4FcBxSmIuE32tpcUsdGN9GJ5o=;
        b=F4NeoXtLHXoCwc4PdenpmA5NxQAorTZCsyq/xBgLD0gPky+X6yF/yk1ujOuIKD9zzD
         c25stG1mTrAoInMHeMbywmDMPfoxGqhSAqJ3VP636ckjU89UwXZxxbUImPzLSTpTnGjX
         gUjbvRR2Tmca9c6pUj7hCyA/YJAClIcoZhSkrClNsX2ilHtELA64WSyLhhX7ia1lwOnn
         5BS0KH4RAaCt+zAXTFQhtqmbkWP3Q2rumWj4vlqbSHilrid/EWpBQYgrPorCuNtRCKF/
         xDE7xu1iY3Cx2KibGcpnsf7idJyvGIB4eRklySWsRWqqvelEbT3afy/6y93ttMX5ikLA
         wYdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1mPKloEPT/3VCCmlRL4FcBxSmIuE32tpcUsdGN9GJ5o=;
        b=gCT8JtAorqvX8m11OG8Bxyf0K6c+8jIdacxvf+ie+Kvw3ENUQgPvn1Fnonz/C1Oge+
         kjLJeUCRIfW+jXxNnJFpSS0OWlJSDzFlkcepGvtqpxZQ2MEepvF8JWqgr0N4K9osoAhm
         cW0zEFbR3Jw8aidobM50Bd3ulBBQDNPzk2CNvz7f43jvFKDAyqibzoJzQOC2ogUFEOJJ
         s5yvA59HF8MxQQDwYe6taZ63WNa37Jw0uEQ1nizROaQpuDGivYFf4/a8ZhRxjFdtG6no
         wQbXvFG3BR1rkewRzdx7nLYzkPWU5Kyj3vR0dFZR9Y+M1PufI4B2hYbnfEX8Iu1j3nkk
         fNaQ==
X-Gm-Message-State: APjAAAUM6oOL9feez9J4a3/yJ0yRmw1iihACFRauxqtzYOlW6jDsJnns
        0bktrPy1a4LTj48YGS0nW2qCVurnmyjEpIz4RbEY9fGkSYCAwnLzXx8PHRajKH+cco15B6UMvfl
        n6VrjKYJChxnZMCjf8larIOocgku5KbistMD/2M884WSCB4Xj3igRbw==
X-Google-Smtp-Source: APXvYqwLIWtbqy5cx1/Tw/c2SNlzlbilPkrk1wgKMBUmZEwWn0N/EhnEKoAfVrW8NP8IrMr14e1WGs+nrQ==
X-Received: by 2002:a63:48f:: with SMTP id 137mr2915616pge.245.1582710297195;
 Wed, 26 Feb 2020 01:44:57 -0800 (PST)
Date:   Wed, 26 Feb 2020 01:44:27 -0800
In-Reply-To: <20200226094433.210968-1-morbo@google.com>
Message-Id: <20200226094433.210968-9-morbo@google.com>
Mime-Version: 1.0
References: <20200226074427.169684-1-morbo@google.com> <20200226094433.210968-1-morbo@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [kvm-unit-tests PATCH v2 4/7] vmx: tweak XFAILS for #DB test
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org
Cc:     oupton@google.com, pbonzini@redhat.com, drjones@redhat.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

These were already fixed by KVM_CAP_EXCEPTION_PAYLOAD, but they were failing
on old QEMUs that did not support it.  The recent KVM patch "KVM: x86: Deliver
exception payload on KVM_GET_VCPU_EVENTS" however fixed them even there, so
it is about time to flip the arguments to check_db_exit and avoid ugly XPASS
results with newer versions of QEMU.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/vmx_tests.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index b31c360..1323dc5 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8332,7 +8332,7 @@ static void vmx_db_test(void)
 	 * modified DR6, but fails miserably.
 	 */
 	single_step_guest("Software synthesized single-step", starting_dr6, 0);
-	check_db_exit(true, true, false, &post_wbinvd, DR_STEP, starting_dr6);
+	check_db_exit(false, false, false, &post_wbinvd, DR_STEP, starting_dr6);
 
 	/*
 	 * L0 synthesized #DB trap for single-step in MOVSS shadow is
@@ -8342,7 +8342,7 @@ static void vmx_db_test(void)
 	 */
 	single_step_guest("Software synthesized single-step in MOVSS shadow",
 			  starting_dr6, BIT(12) | DR_STEP | DR_TRAP0);
-	check_db_exit(true, true, true, &post_movss_wbinvd, DR_STEP | DR_TRAP0,
+	check_db_exit(true, false, true, &post_movss_wbinvd, DR_STEP | DR_TRAP0,
 		      starting_dr6);
 
 	/*
-- 
2.25.0.265.gbab2e86ba0-goog

