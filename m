Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F5A496826
	for <lists+kvm@lfdr.de>; Sat, 22 Jan 2022 00:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbiAUXS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 18:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiAUXS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 18:18:57 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A169C06173B
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 15:18:57 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id b136-20020a621b8e000000b004bfc3cd755cso6808632pfb.4
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 15:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=LPeP+CLz6BW/wFm6eZxkqUXXQnD2033C/C7cPV4SsQs=;
        b=jXAs4QP0BKiRm/KkfCFEP7BKUQMTOVKCwVtfk9Z5zzn/Zr7H/dtEH/eDdpO2uKtqZ6
         c/lxbx1k+RDWU1PNIA4xReCxD33jyo2pOb9U0EU+yu0foCvgxZFsSRqBvI1z7vJw6aJL
         UBSEFHWBnI93eLAqcSxxyVB68U2OGulxBbEgIesuJIGcSV+zelBrXSvTzAuamy+8zgkd
         yqQF95M9B4qkPT8R3lkyXUAHZUDSB3to4h7lKrgLwNN8bNhKExwWsCc+a9YnIxy3Z2p8
         gLetoGchfXQluNBMQnA+pleQzxtklm3fW+UVaz7oM1aB/mrBiprPOI0feDxtZ9EV1XRk
         Jeiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=LPeP+CLz6BW/wFm6eZxkqUXXQnD2033C/C7cPV4SsQs=;
        b=QpK0q5gwDl76RGUeGAWGlRm9U7MO8T4/jp+fn3/rPuQlhqzlkP0uWfk9/lkoEyrP8H
         kw6L/y537VxwP2G2jj/oL0VtzoaY9i79fIjOE/fUct1SWKW2b/NIe64YHDH2rR8MD/nF
         Rj4ppMMVmiasUXxXY/nC5w96rEkX2v9ivJmxhadCrRkxk98x4bnbtZYRTqQmVgFBTr7k
         9pHur59BVVpyOAi4c7eZaV9elBZddjQJC+SUd1Uym6dSdPedm1FJPGyg34w9969ztBOt
         pWG9XsnMs1QevmNGdQ+a7/lDzy6j2guNZNgLZMRjcgv6BST9+weNWy0rjN72WjnONlck
         V+wA==
X-Gm-Message-State: AOAM533LUrwxyCWCey8Y2k92IaMlkjaDCBmSn3ScZ1ErV8ThggyaKbQr
        QSVgDM7AQ07y5jgTIneND0xkOzUdGTk=
X-Google-Smtp-Source: ABdhPJz6Ra6EE2DGVnQP7ipwXXh/AP+8MUHLzF78Yt+OMabaZDcQgoQSdAiMZk3QiumRzYocdqRsdFj0PjU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:3f09:: with SMTP id
 l9mr2902528pjc.36.1642807136742; Fri, 21 Jan 2022 15:18:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jan 2022 23:18:44 +0000
Message-Id: <20220121231852.1439917-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [kvm-unit-tests PATCH 0/8] x86: APIC bug fix and cleanup
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a bug introduced by the UEFI support where setup_tss() can race with
enable_x2apic() and crash the test due to attempting to read an x2APIC MSR
prior to enabling x2APIC (failure manifests in smptest3).

In an attempt to avoid similar bugs in the future, clean up the per-cpu
stuff and convert apic_ops into a per-cpu pointer.  32-bit KUT has a
chick-and-egg problem due to using the APIC ID to choose the selector
for GS (the per-cpu segment), so the original bug "has" to say on a
dedicated helper.

Sean Christopherson (8):
  x86: Always use legacy xAPIC to get APIC ID during TSS setup
  x86: nVMX: Load actual GS.base for both guest and host
  x86: smp: Replace spaces with tabs
  x86: desc: Replace spaces with tabs
  x86: Add proper helpers for per-cpu reads/writes
  x86: apic: Replace spaces with tabs
  x86: apic: Track APIC ops on a per-cpu basis
  x86: apic: Make xAPIC and I/O APIC pointers static

 lib/x86/apic-defs.h |   3 +-
 lib/x86/apic.c      | 157 ++++++++++++++++++++++++--------------------
 lib/x86/apic.h      |   5 +-
 lib/x86/desc.c      | 120 ++++++++++++++++-----------------
 lib/x86/desc.h      |  68 +++++++++----------
 lib/x86/setup.c     |   4 +-
 lib/x86/smp.c       | 128 +++++++++++++++++-------------------
 lib/x86/smp.h       |  67 +++++++++++++++++++
 x86/vmx.c           |   4 +-
 9 files changed, 311 insertions(+), 245 deletions(-)


base-commit: 3df301615cead4142fe28629d86142de32fc6768
-- 
2.35.0.rc0.227.g00780c9af4-goog

