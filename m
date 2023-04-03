Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB536D42AF
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 12:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbjDCK4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 06:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbjDCK4f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 06:56:35 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333467294
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 03:56:34 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id q19so25808950wrc.5
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 03:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680519392;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cm7R9yWLqiu0OG38vA8XW7ODNMYTuSBM5bmK0m+YYk4=;
        b=coeDgdS9HtMCwM65GeFi0TafS6rZ/wTdboXvl4fia5i63VNhXGD2CWD9X3ogdrqUBh
         UiiOTswhumAzCEw1lNuqhMdwLFeUtn6kxJPRw0Bb6aLKCqDjTKX1L8PK+2V3Xa6QDDNn
         2JHc3e7FZMIKqq8xoKVepN0oeMMt9F9aj4yJVVO+ZOM508v5QYA7K1szLvY5UEporjj+
         XLQBfJs/4UCI2ZuZF72LHJ6hzSHUmreFeZBsGV+hyv4gl/fUCbpdHwa4WjJsXpHzprZx
         y356ebyYLP0ph62c4pPHGHXDQIa+Cm9EHgwQYAQXmAdXimZva0Zmw4fix8rPKY9qNn4S
         IibQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680519392;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cm7R9yWLqiu0OG38vA8XW7ODNMYTuSBM5bmK0m+YYk4=;
        b=hrN5p8dKOD1wA268Vn3MxRBjSqYdNcdbQncJNLj+aWmSr7b8sUBW1mNcb5M9ImviZV
         mzWf19f/rk99mZrVIycqbN0G2kYQAeI0m1uiks++jAZzk21VyF5gK7n8IGOhzxiFj1oQ
         XacGpwZz8b7rzfmfqiWpx8/Da1lQ14DNymbMhyUjiahglyWPhM6v1XNDG2WFfWCL7mSB
         GSCLnEHSPAJ5o/BeecsX59iRt8LSDAD0gvmct7upudjHjCB5woCbRauvVNOt30jS2zaF
         dsrmhP8Yjlnqn1ar1C7bpYgoiLqQgjrHnbn66bgPKJb71y0Wvvthotz0wIUbMNE+Limr
         yG0w==
X-Gm-Message-State: AAQBX9caU5AuWZpw82Kc+VmkWT9eLQXU9z3+LKY8DEhulBdH33bkSmQt
        KG8wutJ3zNt1U9LFSFVEN+AswFVndamq1nrqCc1Sxg==
X-Google-Smtp-Source: AKy350ZGPPWvnd91eo1TQGlk8kYADKO7BC7Z3E2t4Skz2dnVavF0eNuUfV3+68WVqr8/SFOpxyOVFw==
X-Received: by 2002:adf:fd06:0:b0:2e5:51e4:a8a with SMTP id e6-20020adffd06000000b002e551e40a8amr8444796wrr.70.1680519392472;
        Mon, 03 Apr 2023 03:56:32 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af22160069a3c79c8928b176.dip0.t-ipconnect.de. [2003:f6:af22:1600:69a3:c79c:8928:b176])
        by smtp.gmail.com with ESMTPSA id x6-20020a5d60c6000000b002dfca33ba36sm9483671wrt.8.2023.04.03.03.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 03:56:32 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v3 0/4] Tests for CR0.WP=0/1 r/o write access
Date:   Mon,  3 Apr 2023 12:56:14 +0200
Message-Id: <20230403105618.41118-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2: https://lore.kernel.org/kvm/20230331135709.132713-1-minipli@grsecurity.net/

This series adds explicit tests that verify a page fault will occur for
attempts to write to an r/o page while CR0.WP is 1 as well as access is
granted when CR0.WP is 0.

There are existing tests already, e.g. in pks.c, pku.c, smap.c or even
access.c that implicitly test this. However, they all either explicitly
(via INVLPG) or implicitly (via CR3 reload) flush the TLB before doing
the access which might lead to false positives if the access succeeded
before, e.g. because CR0.WP was 0 before.

Better to have an explicit test, especially to back up the changes of
[1] which were missing the emulator case, initially.

Changes from v2 to v3 integrate Sean's feedback, especially the
changelogs were rewritten to avoid pronouns and the guts of the CR0.WP
toggling test were moved to a helper function.

Please apply!

Thanks,
Mathias

[1] https://lore.kernel.org/kvm/20230322013731.102955-1-minipli@grsecurity.net/

Mathias Krause (4):
  x86: Use existing CR0.WP / CR4.SMEP bit definitions
  x86/access: CR0.WP toggling write to r/o data test
  x86/access: Forced emulation support
  x86/access: Try emulation for CR0.WP test as well

 x86/access.c | 114 ++++++++++++++++++++++++++++++++++++++++++++-------
 x86/pks.c    |   5 +--
 x86/pku.c    |   5 +--
 3 files changed, 104 insertions(+), 20 deletions(-)

-- 
2.39.2

