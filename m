Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE323A86C6
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 18:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhFOQro (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 12:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbhFOQrn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 12:47:43 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3542CC061574
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 09:45:39 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id j190-20020a253cc70000b029054c72781aa2so19534807yba.9
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 09:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=6HZGdFlUWM4LdlL5+cotm9rGAhlwZSYKVNXCJc52TBE=;
        b=j9bMtMZ1Zel3jGQWMxvx1581g0LAM3fjKvw5SnIg00Xsbe8bVn93dunrjWw2rMq4Cq
         54LEK/RU6P5miLuqCTjGED3cKTaOFH6cujbzfx5TG8ZdK8oHbwmlDEREd9SMOpC/9U1d
         EGizH6qQAYuM4z0uv5FOWe6aus8noEzFaeqk+3QO+BsiC8Y3lJ6HZxTwTlcvCYA7eEdF
         +LQERTO2dF7s5x2EXYjOH3mKHZEWEWch1/IfYT0WbqRXWSJiIgKct4XSNjdcklUbml7y
         u9ZGazlneZshx1D54e8I5se/YmQtztExmgR7VN/TmGVF/I8mSqpQPROmqkxS+6V/xxoS
         GV8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=6HZGdFlUWM4LdlL5+cotm9rGAhlwZSYKVNXCJc52TBE=;
        b=cQz5kyOUXAHxR5FJzMilrHETOlryKwzjTl8Ds4l2AeYPcV9hUr4aec9+LZm2nFK9VG
         j9s0OrDcijRDOPOaPmcIcUV28vLpsk3yFfA5q3SAPTymcn7PivlVobtWXHM2NASKgTEn
         +r86anHqmepQqmIs0LWh/RTbTjJtigKyQIN4mtKhPyb6jCKFgiKNtiFhw6zirl5M35lr
         NZp+ZD5NcrCtm70MITA6NQMcmt1MXxKWSp4u0w4O+Oem70gLsSA39Z2bxOAw201570vm
         HBooHHVCatqfLTo9FF+0TxanCibyP8ABRjhQKGlCUgHIqAtw1YTB9RCqNDtUI/pAFOt/
         jkvw==
X-Gm-Message-State: AOAM531hWQD1diPo4w9NOA1brt22JdI9DG18XzzMPW7VaUJB+SkV3SRk
        PsXIRSmN9O8/dy6LU7BahCPMEado5yg=
X-Google-Smtp-Source: ABdhPJwijPv+0zQjSxRmkTTlgNWU/8MzeoSZ7RLtDFw5X8sp1a318M/0ZuE7ovu43XIh5DcZM4x+lJGK6bI=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:13fc:a8bd:9d6b:e5])
 (user=seanjc job=sendgmr) by 2002:a25:ec12:: with SMTP id j18mr45215ybh.267.1623775538389;
 Tue, 15 Jun 2021 09:45:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Jun 2021 09:45:31 -0700
Message-Id: <20210615164535.2146172-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH 0/4] KVM: x86: Require EFER.NX support unless EPT is on
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM has silently required EFER.NX support for shadow paging for well over
a year, and for NPT for roughly the same amount of time.  Attempting to
run any VM with shadow paging on a system without NX support will fail due
to invalid state, while enabling nx_huge_pages with NPT and no NX will
explode due to setting a reserved bit in the page tables.

I really, really wanted to require NX across the board, because the lack
of bug reports for the shadow paging change strongly suggests no one is
running KVM on a CPU that truly doesn't have NX.  But, Intel CPUs let
firmware disable NX via MISC_ENABLES, so it's plausible that there are
users running KVM with EPT and no NX.

Sean Christopherson (4):
  KVM: VMX: Refuse to load kvm_intel if EPT and NX are disabled
  KVM: SVM: Refuse to load kvm_amd if NX support is not available
  KVM: x86: WARN and reject loading KVM if NX is supported but not
    enabled
  KVM: x86: Simplify logic to handle lack of host NX support

 arch/x86/kvm/cpuid.c   | 13 +++++--------
 arch/x86/kvm/svm/svm.c | 13 ++++++++++---
 arch/x86/kvm/vmx/vmx.c |  6 ++++++
 arch/x86/kvm/x86.c     |  3 +++
 4 files changed, 24 insertions(+), 11 deletions(-)

-- 
2.32.0.272.g935e593368-goog

