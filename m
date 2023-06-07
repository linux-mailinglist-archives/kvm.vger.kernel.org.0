Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2897270BB
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 23:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbjFGVvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 17:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjFGVvi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 17:51:38 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25851BFF
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 14:51:37 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-565ba5667d5so115238417b3.0
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 14:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686174697; x=1688766697;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=g4PU7TNg0vLFGTjMSf9kDJAayeJqWfZUJRQBFWbCryE=;
        b=Za23uIchU6M4RNBISOH7M1U8+k7Ppb4VZ53LiX4pQCodNqGH/R8TsFL8M2s5LoKn8y
         K3v9lrboQy/tKkAxWYn/sTxe2eJLGpw9O6+fX/08Wq1iIc87uXh3LXaXYV4x2Tk2Lt0o
         Rr9L9lvozSNqt715WZecQ+WkF0XPgyurKcZE/4qn9SJF/dxlQLxAWqA0ZdTzAWSiasDi
         4NVQu5UT0N5QaFDCkMWESXk5epiOYyDFG8rBYxMAZ9thI7Fw67GmBKQl3BsPJqIVJh3M
         zqTzjSjM3ZPZjuPQ9hhx9YYc0aj379jIuF+SdB7Z5r/OTQLikoZXrzkfvK5K1L+M/AZw
         Zefg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686174697; x=1688766697;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g4PU7TNg0vLFGTjMSf9kDJAayeJqWfZUJRQBFWbCryE=;
        b=hQWFnYOK60k9BQt2Gjhem+PYMjVaxTwDebLBsTKiWeD2AdIPxuggh9eCHRXLc6NfMz
         xNOa+kCP3+hdJ24Us4N7bVflkSbqDCOHNJWdJhg1A7vZU05EpN+ht4gd+4H4v+9qxAga
         mg37GOzLMj6QCUXXp8bzHmiL9QE9uKrehf+xCEE6PUnRRvu2rlzeufMvGi+ZNW1it/jY
         N0kCsyHAjZvA/3/cxE+UGbEbO9ra/24U4fKVmfwZDL0V9tLi9Rakxf5pHK0yn1QyPe2g
         L9bPyH1NYDpvt3ZhHied34bLMfxDiLUaqvPihzTpe4Z8S7SEKMzvDO0yT809ZDixLYYR
         YwwQ==
X-Gm-Message-State: AC+VfDydMiUqwPAGmnTztcjOCi5PY+3EM+bI288zIvOjU2Dz6Ni0qniC
        ixOAQ3by8tSQiXC9s4rIB//EOKOnOKI=
X-Google-Smtp-Source: ACHHUZ6XDuIV5F8IGH/3iHv+ap2i2/SRyxPl8JpU/WFJvfvzY7BWnjMhReokfpXmxPneUdjhS6tsphgSSxE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c004:0:b0:ba8:6148:4300 with SMTP id
 c4-20020a25c004000000b00ba861484300mr2450462ybf.6.1686174696873; Wed, 07 Jun
 2023 14:51:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  7 Jun 2023 14:51:14 -0700
In-Reply-To: <20230607215114.1586228-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230607215114.1586228-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230607215114.1586228-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 2/2] x86/pmu: Make PMU testcases dependent on
 vPMU being enabled in KVM
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Like Xu <like.xu.linux@gmail.com>
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

Make the PMU testcases dependent on KVM actually enabling a vPMU.

Opportunistically fix the pmu_lbrs testcase to separate requirements by
whitespace, not by adding additional "check" entries.

Reported-by: Like Xu <like.xu.linux@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/unittests.cfg | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index f4e7b254..3fe59449 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -206,7 +206,7 @@ extra_params = -cpu max,vendor=GenuineIntel
 [pmu]
 file = pmu.flat
 extra_params = -cpu max
-check = /proc/sys/kernel/nmi_watchdog=0
+check = /sys/module/kvm/parameters/enable_pmu=Y /proc/sys/kernel/nmi_watchdog=0
 accel = kvm
 groups = pmu
 
@@ -214,8 +214,7 @@ groups = pmu
 arch = x86_64
 file = pmu_lbr.flat
 extra_params = -cpu host,migratable=no
-check = /sys/module/kvm/parameters/ignore_msrs=N
-check = /proc/sys/kernel/nmi_watchdog=0
+check = /sys/module/kvm/parameters/enable_pmu=Y /proc/sys/kernel/nmi_watchdog=0 /sys/module/kvm/parameters/ignore_msrs=N
 accel = kvm
 groups = pmu
 
@@ -223,7 +222,7 @@ groups = pmu
 arch = x86_64
 file = pmu_pebs.flat
 extra_params = -cpu host,migratable=no
-check = /proc/sys/kernel/nmi_watchdog=0
+check = /sys/module/kvm/parameters/enable_pmu=Y /proc/sys/kernel/nmi_watchdog=0
 accel = kvm
 groups = pmu
 
-- 
2.41.0.162.gfafddb0af9-goog

