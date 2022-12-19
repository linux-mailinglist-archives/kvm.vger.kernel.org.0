Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F12651231
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 19:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbiLSSxh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 13:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbiLSSxe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 13:53:34 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64573F55
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 10:53:33 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id z9-20020a6be009000000b006e0577c3686so4460016iog.0
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 10:53:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wppcRybhsa1D+MJGf2QRd6LwePVql2vPJWBF38NpA2o=;
        b=qEwnyZz/kHeIYiGoGUWihIfAToGNVAmjadbU4bRC9mw4aGqSfL51V6XugfXpXYo2vL
         oxv7EX2Ogam4Gb0R00I1vlGmkyzrgvo9ryON4vAYxur3cKetpUvv2SZgFLIKPfZIX9jE
         HJR4CweyC4G5TIcV47oDdUmpLgYkl4f8PgRfcm5q3a88Nb+Rpi/F2IFzJ3JDSu6JdodJ
         RB2m8JkCFTUsQymEBF4VSWEtM1taphQm4hAd5N6XtTzKQaNT9HlMIQhNbZwH6F7M+03O
         VZJeDM0gorwOIg14NJA7faq5RiMOwPWQyqBjkDN1zRqhjI1yTa/8XGpP6v/am6jepacJ
         1NCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wppcRybhsa1D+MJGf2QRd6LwePVql2vPJWBF38NpA2o=;
        b=w5u9RqnY4zrOi1CplNhknXrh2Wn142rhxApEbuwN/m0x8eYU84wW3xptZ2vk8Nh/67
         fglKKKtdxTcOlInm+Ncjqe38Srneo0/yH3IZ3p46fv7lP/CtX30OVJxHY9rUEHFykwVi
         v2c8bHSWEFvv6vOwnCc7akniulphCsD33eb/ibnpC7ot/WaOkLyKrm4MtQapF80WOS7N
         XvbUZUZHGbaE8re4XEdZYXNnp2QfLTNtdIQi0Kn0dZ4Be4ZDe3JzwQf6bbwdvV5F9apB
         D3UNErGU+YY7979kBSj05W77qhKa5NYGncESgr4rsegC6m/dsovr6EhPtBV6+6g/F2Pb
         Mf/A==
X-Gm-Message-State: ANoB5pklq24XMKaLDpM8GhjPpU8X8+6z5wGGF00wRGNVUfdI4/S+RUkC
        9b+z3fD6Z6WzwbKhAbGhNr/Sj4VptTF/Og0bhNzCZICYqgrg6hTKHF11sJQuOIeC5po5pNP6lOv
        5bVPldULcDd1ItFMUS8JeEzEmc/tNRWVk7gSuranlqFZy5bxdUHmouC8cJDPmbw3WUIGeiXc=
X-Google-Smtp-Source: AA0mqf7DiaNp0GrKsEOujv+Oe9vnA2Oz5I9BmoWs05G430VgNfQjwF62tfkDu6k1XPiRniP1sus+oHYjvW02y7EWFg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:1901:b0:389:d4f3:216f with
 SMTP id p1-20020a056638190100b00389d4f3216fmr30745147jal.92.1671476012739;
 Mon, 19 Dec 2022 10:53:32 -0800 (PST)
Date:   Mon, 19 Dec 2022 18:52:50 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221219185250.631503-1-coltonlewis@google.com>
Subject: [kvm-unit-tests PATCH] arm: Remove MAX_SMP probe loop
From:   Colton Lewis <coltonlewis@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     maz@kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com, ricarkol@google.com,
        Colton Lewis <coltonlewis@google.com>
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

This loop logic is broken for machines with a number of CPUs that
isn't a power of two. A machine with 8 CPUs will test with MAX_SMP=8
but a machine with 12 CPUs will test with MAX_SMP=6 because 12 >> 2 ==
6. This can, in rare circumstances, lead to different test results
depending only on the number of CPUs the machine has.

The loop is safe to remove with no side effects. It has an explanitory
comment explaining that it only applies to kernels <=v4.3 on arm and
suggestion deletion when it becomes tiresome to maintain.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 scripts/runtime.bash | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index f8794e9..18a8dd7 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -183,17 +183,3 @@ function run()
 
     return $ret
 }
-
-#
-# Probe for MAX_SMP, in case it's less than the number of host cpus.
-#
-# This probing currently only works for ARM, as x86 bails on another
-# error first. Also, this probing isn't necessary for any ARM hosts
-# running kernels later than v4.3, i.e. those including ef748917b52
-# "arm/arm64: KVM: Remove 'config KVM_ARM_MAX_VCPUS'". So, at some
-# point when maintaining the while loop gets too tiresome, we can
-# just remove it...
-while $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
-		|& grep -qi 'exceeds max CPUs'; do
-	MAX_SMP=$((MAX_SMP >> 1))
-done
-- 
2.39.0.314.g84b9a713c41-goog

