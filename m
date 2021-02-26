Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E16325B18
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 02:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhBZBE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 20:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbhBZBEN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 20:04:13 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC8EC06174A
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 17:03:33 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id v196so8377788ybv.3
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 17:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=wTYAZE8l/zQPMkdzD7xsvIS6f4NgB+O0D1nsiwHUulE=;
        b=TxqkVa6Q/RFAQfK5SS9lz1EFq/h95m+FCP8+yX5UEZCc3xGG+dozfQEcvKUuO2ZRV8
         CaxYstOd+RXa1GhIT0nzmEgiVT3TiAHWmN/R6VTlmtyK026MgMkb3CzbgDSKYzE0bph8
         AHROcj0cQrdcxr1v4xHv/KQXUZpp7168JPeXL3RrTriDlybgkZoBXH3Prdl74xmVHWmK
         nEYjYLcPYHDWQscUwSa6ZJV/b4/Twjzw1BA/+Z3fufHCO+Z6RSzTg1C9uduDCP5poGqT
         bINRgPXuUwVoS/P2pmewKoV9J1l5BkM8q3IryrywUKkG61rw7uLdxZ2rRHqI57A3/JNP
         TUOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=wTYAZE8l/zQPMkdzD7xsvIS6f4NgB+O0D1nsiwHUulE=;
        b=tJgXbxoIGXRtTiuFZU1UPDmnk6P6HCqWsCE3LpiOdDyGIeEHRB4MLu8TTbeQAH7vgJ
         tII1I1L3fK7veLUABtlhyHHxE2qxrGIF7FP/dn7hhu4I1JsfbFG1WhywdLrHBaPjnnlU
         m0ZpkbT7Chgs/KZzC2bypAT+VqRKmoVbEdbAM6+IpVMrx8rFWW2bGU15xJVmi8mr6XIB
         tnohlgwM/y56+a7AmVuiEUITcbFUQy2OVVC1Ink1moYzW2toy9xNT81su0R4fXje+DUl
         pq+fiDPF8iz0dxiT3tH4PbECexUTqCP2W2jro/lqT6ag8kTOLxbS5+V9UFrkZYZQaPeG
         XHag==
X-Gm-Message-State: AOAM530Ym4Y+FxaIDR+EVQFkHbFSVyA6GR5CDo8NcYIz20cCAKBKQ8Nj
        VYELXMUioibBvxkY5Z2XIA/U5OkBCwM=
X-Google-Smtp-Source: ABdhPJx1I/DKz/d2vGPFiStKyjcq32wUL3PVrpnedWlv7bhpAr8F3TeftRKfJixHYbJLzoL/5ufr7zmZBU8=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:34c4:7c1d:f9ba:4576])
 (user=seanjc job=sendgmr) by 2002:a25:5ac2:: with SMTP id o185mr985108ybb.252.1614301412620;
 Thu, 25 Feb 2021 17:03:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Feb 2021 17:03:24 -0800
Message-Id: <20210226010329.1766033-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 0/5] KVM: x86/mmu: Misc cleanups, mostly TDP MMU
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

Effectively belated code review of a few pieces of the TDP MMU.

Sean Christopherson (5):
  KVM: x86/mmu: Remove spurious TLB flush from TDP MMU's change_pte()
    hook
  KVM: x86/mmu: WARN if TDP MMU's set_tdp_spte() sees multiple GFNs
  KVM: x86/mmu: Use 'end' param in TDP MMU's test_age_gfn()
  KVM: x86/mmu: Add typedefs for rmap/iter handlers
  KVM: x86/mmu: Add convenience wrapper for acting on single hva in TDP
    MMU

 arch/x86/kvm/mmu/mmu.c     | 27 +++++++------------
 arch/x86/kvm/mmu/tdp_mmu.c | 54 ++++++++++++++++++++++----------------
 2 files changed, 41 insertions(+), 40 deletions(-)

-- 
2.30.1.766.gb4fecdf3b7-goog

