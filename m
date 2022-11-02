Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 210DA6170E7
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbiKBWvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbiKBWvd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:51:33 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19D3DEC0
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:51:30 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 192-20020a6303c9000000b004701a0aa835so52293pgd.15
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IIGvadv2kOWlRN5YGNYsgCF58TZO6k3x6fOisWmD7d8=;
        b=FUmOnQrXmE+LDYrXVpJz0oSZG1HbCucC7UJIWmWkhAA5yCg81ZkmtK1F2gCRKkIylU
         3AAmc9ajZjIy6LRpn5ReyEP/IrTomKigkEgZ0m8rydzAZb1ImfBBW7tpDLckR06tsOUk
         aapAfg1Vju/HwNZJISXsM6zr6cZ3tAxb6xNPXhVURLY2REkljdB0a01XW6tRPRX3IuhY
         cSs7KNdCH6IEaPAtXxYz6VKqelA7HefBnlKk3teIPYgdUcYnf0Q34D16ah++7Sth45Q1
         I9p4r46rByOe3wkuDw54qAU//i9Z46ihhizJVDQl/K1SJPe8ql5tyQ9LOpSS/gzfRTZc
         6PMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IIGvadv2kOWlRN5YGNYsgCF58TZO6k3x6fOisWmD7d8=;
        b=56IGi3n1GWXjMGpu9vyg0Dcc6N3wDMGfrh4+6jQvKNH/unPLcTQlBLDg6Lkr0mfLvD
         XekDL05iuF8AxNpHnoMwd9oetjJuM854OYrWJSlUQjW5w1wXtPvEdp/1oqvT0fm1WP4f
         vpuF2I6k6D7soXQFWncdHxc8Hr38IyVmTgypCiz+mQWAzmgPytxlwNfsdCuBx044Tzhn
         mSZuJn45aqP+ablzL/UkmruX7SUvsEjgmz0rG+T0nttKVEYx4T2f3Wf6tbM+MQi9XoRW
         n4Ff9z9592XaVhVILXZ/6FUyebukvNCGO+XmwZXZPv2Du7Ub3cICS2JgDWgEXNGe445d
         UJGw==
X-Gm-Message-State: ACrzQf3QOcFTtmPXBc3h+g+zlOosD/1wrt4P9876KeyQR76mj69Mrdz2
        9AtUU6AroQoTPQhk/2FCNtmUuXcp5ac=
X-Google-Smtp-Source: AMsMyM74F2A46h66jEgX19ovUwFb/0VB2WIyNsksHFFh8kr3xnhE7SmWYpXQxkCh4l0CZ/hwuuO4OrhxjCQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:f291:b0:20a:eab5:cf39 with SMTP id
 fs17-20020a17090af29100b0020aeab5cf39mr144827pjb.1.1667429489953; Wed, 02 Nov
 2022 15:51:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 22:50:52 +0000
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102225110.3023543-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102225110.3023543-10-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v5 09/27] x86: create pmu group for quick
 pmu-scope testing
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Like Xu <likexu@tencent.com>,
        Sandipan Das <sandipan.das@amd.com>
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

From: Like Xu <likexu@tencent.com>

Any agent can run "./run_tests.sh -g pmu" to run all PMU tests easily,
e.g. when verifying the x86/PMU KVM changes.

Signed-off-by: Like Xu <likexu@tencent.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/unittests.cfg | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index ed651850..07d05070 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -189,6 +189,7 @@ file = pmu.flat
 extra_params = -cpu max
 check = /proc/sys/kernel/nmi_watchdog=0
 accel = kvm
+groups = pmu
 
 [pmu_lbr]
 arch = x86_64
@@ -197,6 +198,7 @@ extra_params = -cpu host,migratable=no
 check = /sys/module/kvm/parameters/ignore_msrs=N
 check = /proc/sys/kernel/nmi_watchdog=0
 accel = kvm
+groups = pmu
 
 [vmware_backdoors]
 file = vmware_backdoors.flat
-- 
2.38.1.431.g37b22c650d-goog

