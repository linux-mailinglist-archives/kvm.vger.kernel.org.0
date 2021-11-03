Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C608044484A
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 19:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbhKCSgO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 14:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbhKCSgN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 14:36:13 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB565C061714
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 11:33:36 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id o15-20020a0cc38f000000b0038455e36f89so3549584qvi.6
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 11:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ei7sopFgRurTTqGpUq8SXd94JhFlqKl/BO/TFEpfruo=;
        b=B12w5puCbPLqOx5+T4VSZ98h+udJT7r1UEJaufpU9vzE28ouwslQ+3sl7+Soiy2zYK
         MwuEDzZeOKjHlO4cl9zUydheBxzOEEozRHi0Pis4x8OD5Et1BJp8WK985hQXETx9+Q/5
         BO2B0I2v3zNm2TVC5yH5RhAwC06VOSmy695lrBnwMpoHFs9RWTns/EZN1lKtmKXSmjI4
         sF8AZoP1w/eaxG7H4dAXyRLV9zeGBYjyXj5kuwP0v+MgAKx5xq0hmLElddE70Uoz22RB
         TNJi+pDdL+vFPve5DGepYphx9Q0NP3aBK9Sd3WAHlcHk6pk5lzjNyAQGs/IEwUxk7xFi
         RaWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ei7sopFgRurTTqGpUq8SXd94JhFlqKl/BO/TFEpfruo=;
        b=QJWjP0wazMqfKSSreRuae5Wwa4klc1YWb5jcpC61o1YNO0oPjDUgm4ZiYIw6YZLIOD
         CG9/LWZFVnC+dv6BxLUQ1XrPJrbuJAprui4l9bkV2dXiam4HU9mf+u3LYhbCMtDAZIJt
         qPU4M8UMidcI/eUJvdU6eFhiWU4VDSWbLDMqZUdmTAtNpojUPiOscZ5dpDcIbzvD0HJ5
         mO2oZQEOiOJXmWXFvKZ4h8jkZb2fTfDIaUpkVBOy7C3pAiXXBM7F9ql85+VboLwkCFWF
         tL1MNdzzME/8Y2Lqt71b0CMdguhAo8B6EqmeqoakKWN5Q65Lsg33tkubhLs2RwwcfQP4
         lwug==
X-Gm-Message-State: AOAM533AaXagBuJGWJ1tjdcg+I/LiYdT4TfzzEPzoBSmOGZIHqIl82Qh
        2yMHPLlrfE7XjmTOyzwKlEDuJC7CL4iD
X-Google-Smtp-Source: ABdhPJymfOoaJlePf+f24GEFzO5CKc2wj3N8gNxBKpKz5rg1yiDo6AdtqXwlFu9GI41kadVnTwBBfHqArf+o
X-Received: from vipinsh.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:36b0])
 (user=vipinsh job=sendgmr) by 2002:ac8:183:: with SMTP id x3mr47052620qtf.279.1635964416111;
 Wed, 03 Nov 2021 11:33:36 -0700 (PDT)
Date:   Wed,  3 Nov 2021 18:32:30 +0000
Message-Id: <20211103183232.1213761-1-vipinsh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v2 0/2] Add wrapper to read GPR of INVPCID, INVVPID, and INVEPT
From:   Vipin Sharma <vipinsh@google.com>
To:     pbonzini@redhat.com, seanjc@google.com, jmattson@google.com
Cc:     dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

VMX code to handle INVPCID, INVVPID, and INVEPT read the same GPR index
in VM exit info. This patch series improves that handling by adding a
common wrapper function for them.

This series also moves INVPCID type check from both SVM and VMX to
common place in kvm_handle_invpcid().

Overall, this series is just reducing duplicate code.

Changes in v2:
- Keeping the register read visible in the functions.
- Removed INVPCID type check hardcoding and moved error condition to common 
  function.

[v1] https://lore.kernel.org/lkml/20211011194615.2955791-1-vipinsh@google.com/

Vipin Sharma (2):
  KVM: VMX: Add a wrapper to read index of GPR for INVPCID, INVVPID, and
    INVEPT
  KVM: Move INVPCID type check from vmx and svm to the common
    kvm_handle_invpcid()

 arch/x86/kvm/svm/svm.c    |  5 -----
 arch/x86/kvm/vmx/nested.c | 10 ++++++----
 arch/x86/kvm/vmx/vmx.c    |  9 +++------
 arch/x86/kvm/vmx/vmx.h    |  5 +++++
 arch/x86/kvm/x86.c        |  3 ++-
 5 files changed, 16 insertions(+), 16 deletions(-)

-- 
2.33.1.1089.g2158813163f-goog

