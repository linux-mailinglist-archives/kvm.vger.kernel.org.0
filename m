Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16AE494552
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 02:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358013AbiATBHZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 20:07:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345578AbiATBHY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 20:07:24 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF07C061574
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 17:07:24 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id x15-20020a17090a46cf00b001b35ee9643fso5007428pjg.6
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 17:07:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=8k4Y3VNhARizHBLoBeVlBsEIO9RktxArLbOUz+wMzEA=;
        b=opu/MwONHVOFKyzulY2hDvm6HGIeLsEVzxDtlWA8Pqsdn9s/lbq2LRxB/OUq63udCV
         3BYO/p8t1E2G1dSKTTryOXmEdToPoUXnmDEUFTvHNYgRgAznPfR3VzuK0B6ZnvAfV2YW
         9KQK/NFRbYv3gzhweDbHOg2LWEIS/4fbKe1nhhRKEY3+ujaG/Io+e1eX5YuXicLNuU8d
         v0OF8yPXnXBDOIU+alEU54SD7r9YP3AlzZbI9rOQ0n7Y3VtB77VBYezQA8pOS5v2dVZN
         FVwlfk3v5LtCW+p/5UBWZv+5A6JEem+1JNYrYgEzx1VAV9/lfbB3sQ67oxDsS5DxZMw4
         /7kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=8k4Y3VNhARizHBLoBeVlBsEIO9RktxArLbOUz+wMzEA=;
        b=2pypCcTr2VoQ02Qsc25h5hacAZ1A/CvfMe/DNV/Zku28sp/Bl21W4oBqB3totiFpqE
         uji5u6cS4pBYOULQXBIsvqu47thQQL6H/tdApqJ53jenVGaN+1OkhzoPJ1Mlr+OhSzgo
         wwFZHCfrGzgy6N4dCeGdkzWLYs5Qj/Ft6ofulgh4hWYemQdG9lcI0Yg2PWZbVGNyvxnv
         1vpsM4Kk6QmpZ/zo4z+vxE1OgGW78TZFi+v0ZTeUm6MnJon4TZuee8zBSs0LbcitINaX
         mlJBpvlFlAda7aBa09C8lfEZ5BKy9sNC34BneRc12truyae6bqVtWbUftdnS21PPLRSA
         5KeQ==
X-Gm-Message-State: AOAM532se2bjDfLinCTxqiFmeeSxOAtkHbHaH+1sAzUBDslbWW8w7DmI
        VyFcNR6+Ni2KeF8zfuS7DmUuWgZSRkw=
X-Google-Smtp-Source: ABdhPJyiA7Rs4s7U+9aku6ZWeT21TC8qBXpEH9hQ0bc+CUBqZUFu088Wf24TiSfmeDGGQh8PhVQ1OqU77PY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3b52:: with SMTP id
 ot18mr7688600pjb.129.1642640843789; Wed, 19 Jan 2022 17:07:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 20 Jan 2022 01:07:10 +0000
Message-Id: <20220120010719.711476-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH 0/9] KVM: SVM: Fix and clean up "can emulate" mess
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Liam Merwick <liam.merwick@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Revert an amusing/embarassing goof reported by Liam Merwick, where KVM
attempts to determine if RIP is backed by a valid memslot without first
translating RIP to its associated GPA/GFN.  Fix the underlying bug that
was "fixed" by the misguided memslots check by (a) never rejecting
emulation for !SEV guests and (b) using the #NPF error code to determine
if the fault happened on the code fetch or on guest page tables, which is
effectively what the memslots check attempted to do.

Further clean up, harden, and document SVM's "can emulate" helper, and
fix a #GP interception SEV bug found in the process of doing so.

Sean Christopherson (9):
  KVM: SVM: Never reject emulation due to SMAP errata for !SEV guests
  Revert "KVM: SVM: avoid infinite loop on NPF from bad address"
  KVM: SVM: Don't intercept #GP for SEV guests
  KVM: SVM: Explicitly require DECODEASSISTS to enable SEV support
  KVM: x86: Pass emulation type to can_emulate_instruction()
  KVM: SVM: WARN if KVM attempts emulation on #UD or #GP for SEV guests
  KVM: SVM: Inject #UD on attempted emulation for SEV guest w/o insn
    buffer
  KVM: SVM: Don't apply SEV+SMAP workaround on code fetch or PT access
  KVM: SVM: Don't kill SEV guest if SMAP erratum triggers in usermode

 arch/x86/include/asm/kvm_host.h |   3 +-
 arch/x86/kvm/svm/sev.c          |   9 +-
 arch/x86/kvm/svm/svm.c          | 162 ++++++++++++++++++++++----------
 arch/x86/kvm/vmx/vmx.c          |   7 +-
 arch/x86/kvm/x86.c              |  11 ++-
 virt/kvm/kvm_main.c             |   1 -
 6 files changed, 135 insertions(+), 58 deletions(-)


base-commit: edb9e50dbe18394d0fc9d0494f5b6046fc912d33
-- 
2.34.1.703.g22d0c6ccf7-goog

