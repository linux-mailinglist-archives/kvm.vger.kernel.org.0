Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B03434291A
	for <lists+kvm@lfdr.de>; Sat, 20 Mar 2021 00:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhCSXU2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 19:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhCSXUM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 19:20:12 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E966C061761
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 16:20:12 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id l83so6979608ybf.22
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 16:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=CvQ5tXzFvKmiPJ3XmaWouDYXr0Pnkz+oNik9wEm0aE0=;
        b=eX2PETl3TR/9qMzY1ZqSlgBlCPt71CLJcdHrJZXxvuQOxMLpvQV416RwDdItcChYKV
         1NuoDItQtRM3Fg3W3WIClKW2OfCeZE51UtfFHfyjJlGVoUfrFHcxDGCP5jb3RHF3QUDn
         CI6RfsMAeNLHote6T/FT45OgRKvGjA0hv2gLX9z7kbPc/fJcezVMM7LvQ1e1Ex7JGmtP
         PMBxRC/1/o6eeMn33BiCM1CYL0GCoSPUaM0MEXF18uNPUjiNtVm58cYkwV4uJBVd2RbK
         DGaMwM2jVhDM80NYUvZ/ilPvA/XWlvvKFGiZMwxrv47JrDTm6LXB2aUtbdTLqW7dlP9P
         D17g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=CvQ5tXzFvKmiPJ3XmaWouDYXr0Pnkz+oNik9wEm0aE0=;
        b=BQwLzFmhDjU64JMzc/Pjstn+KC/hTHqaFvqZY+AUojxsQzVYm7u8z/Sf9LOhF8ipkG
         l+94HciMuYpmIfgFzoakd3u8sQPIb3rM58WMuW17QaeJqzNCBv9f4yqoOZ4AJoXX4xlg
         xommO/VWwAm3mH5V7sZdzyhogvEitCditCIENSAcIUydKunJCiuVhCOigfyHEHcs8lpB
         SAMv6+qRDilzp2iQIczSexVKzr+kVqglS7Q6kxmKYcP2YDuBhLLncY18tljtVyzabOhW
         mcLmqrqNg5PqcIcpXSpPKRAr/IwNylrWf/Bu0bPqWxBbCYk4aJ8j9S/Q+SdOEIbM+3Eu
         j/Ow==
X-Gm-Message-State: AOAM530bSU5d7M6eQRyHUWmxongJokSU0dgAcNcyK22mkzv0If7ZsAz+
        wQPmxvOwbONopsazU3f2FCzursVJWhw=
X-Google-Smtp-Source: ABdhPJxPApAsYFIsf405wMqKW5zAk/n920Ju9PJupoufH7Gg02Rt9dFSEEGKZlz6d2CcKwWRuTNUWc+5CDQ=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:115a:eb6e:42f6:f9d5])
 (user=seanjc job=sendgmr) by 2002:a25:ddc3:: with SMTP id u186mr9555238ybg.238.1616196011260;
 Fri, 19 Mar 2021 16:20:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 19 Mar 2021 16:20:04 -0700
Message-Id: <20210319232006.3468382-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH 0/2] KVM: x86/mmu: Fix TLB flushing bugs in TDP MMU
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two bug fixes involving the TDP MMU.  Found by inspection while working on
a series to consolidate MMU notifier memslot walks across architectures,
which I'll hopefully post next week.

Patch 1 fixes a bug where KVM yields, e.g. due to lock contention, without
performing a pending TLB flush that was required from a previous root.

Patch 2 fixes a much more egregious bug where it fails to handle TDP MMU
flushes in NX huge page recovery, as well as a similar bug to patch 1
where KVM can yield without correctly handling a previously triggered
pending TLB flush.

Sean Christopherson (2):
  KVM: x86/mmu: Ensure TLBs are flushed when yielding during GFN range
    zap
  KVM: x86/mmu: Ensure TLBs are flushed when yielding during NX zapping

 arch/x86/kvm/mmu/mmu.c     | 15 ++++++++++-----
 arch/x86/kvm/mmu/tdp_mmu.c | 29 +++++++++++++++--------------
 arch/x86/kvm/mmu/tdp_mmu.h |  3 ++-
 3 files changed, 27 insertions(+), 20 deletions(-)

-- 
2.31.0.rc2.261.g7f71774620-goog

