Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7123654A257
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 00:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240467AbiFMW6J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 18:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234770AbiFMW5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 18:57:30 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D432AC5
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 15:57:26 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id s22-20020a252d56000000b0065d1ef35f9dso6186884ybe.5
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 15:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=BqcYaynfjY3B1HPR6nmJnp/4eztkVj8MCX0aS8dr66w=;
        b=m7+gnRx3yjoJ6EBdiUGNJi+jpn7Wy5ewGgx2olla1k0Wc18wJYVBdukH3stWRnwmDW
         Q+uUszfsdUcF/Olg1vYO1mDVWQJH94hCIpDZTizRBLLxM0Ou5Zsbna03MMUAzYZ6/Id9
         RFp8cuvy/z9lpLAxy/dRMmI4rdQAbyyfhTyPBVWkYbuCqkoWH//+XQ5+vWvPXBkSVj6u
         a4/hvjkHJbJ/2k+5KdsxIbNlk18lAPI97xnEcDc92lZtI5itEAQ7YvoKp1Vxmwbyg4s1
         DL42THcEvci4xrG0nptaxS6iLN1c07Zwo3gDVvDPJBXh5QuECKcLojeuYLYxqby7Lu9D
         aXmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=BqcYaynfjY3B1HPR6nmJnp/4eztkVj8MCX0aS8dr66w=;
        b=GQuZJv4qB2cg7zPttsHzNEseJlZNybZBoZ43STnpXsKrGqtWepcT4JrUJSHebL6OMa
         TA5deEQdmuWK3KeqJD2dTkuCOCeSGrsaYxUS1FF3fTVQ05jRcEtuV8KRI0jaXK8YrMnG
         o4y9EK+NCgq2/Erx6VkgCHfk6CGLt76Oe3BQAQTdaTeA+YNXqgpYfGCYmG2JHvUKINv2
         Goijk4z6IgEEVZwF6ELQpbqjOfN9JSi20uMoGrqhgJ6YxzaVE54Xd4L6edEA1RHagBxp
         PDZsIPjl22yOZBKpXxBUDRZOfSIhDNtzYT5TjRnMyZfu2x/oJFRSdDUoJyqL0VEi6IFC
         iA5A==
X-Gm-Message-State: AJIora/239QGTTPaLVV1IcOhbxxDE3A03GVtqP0KjVYl0dtOzRTWbLAV
        HVuBQnL5NrpAjL8E4TUvXfWBaDHqTUs=
X-Google-Smtp-Source: AGRyM1vFGnbGn0GbwGAUaNrqZvft0HGw+nji3FJdtHYUf5pdiU9xGYC1wxD7QAwzeO1I3Ppm00eUY2/4GCM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:97c8:0:b0:664:7592:a904 with SMTP id
 j8-20020a2597c8000000b006647592a904mr2032248ybo.28.1655161046067; Mon, 13 Jun
 2022 15:57:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 13 Jun 2022 22:57:15 +0000
Message-Id: <20220613225723.2734132-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 0/8] KVM: x86/mmu: Use separate namespaces gPTEs and SPTEs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

Clean up the x86 MMU code to use separate namespaces for guest PTEs and
shadow PTEs.  While there is most definitely overlap, especially in
attribute bits, the rules for walking gPTEs and for generating/walking
SPTEs differ in subtle ways, e.g. see commit fc9bf2e087ef ("KVM: x86/mmu:
Do not apply HPA (memory encryption) mask to GPAs").  The paging32 macros
in particular should never be used outside of paging_tmpl.h.

Separating gPTEs from SPTEs actually provides for nice cleanups (see the
diffstat) as KVM has ended up with a fair bit of copy+paste code that can
be deduplicated once KVM isn't trying to use PT64_* defines for both gPTEs
and SPTEs.

This is a spiritual successor to patches 4-7 of the series[*] that added
the aformentenioned commit.

[*] https://lore.kernel.org/all/20210623230552.4027702-1-seanjc@google.com

Sean Christopherson (8):
  KVM: x86/mmu: Drop unused CMPXCHG macro from paging_tmpl.h
  KVM: VMX: Refactor 32-bit PSE PT creation to avoid using MMU macro
  KVM: x86/mmu: Bury 32-bit PSE paging helpers in paging_tmpl.h
  KVM: x86/mmu: Dedup macros for computing various page table masks
  KVM: x86/mmu: Use separate namespaces for guest PTEs and shadow PTEs
  KVM: x86/mmu: Use common macros to compute 32/64-bit paging masks
  KVM: x86/mmu: Truncate paging32's PT_BASE_ADDR_MASK to 32 bits
  KVM: x86/mmu: Use common logic for computing the 32/64-bit base PA
    mask

 arch/x86/kvm/mmu.h              | 10 ------
 arch/x86/kvm/mmu/mmu.c          | 64 ++++++++-------------------------
 arch/x86/kvm/mmu/mmu_internal.h | 17 +++++++++
 arch/x86/kvm/mmu/paging.h       | 14 --------
 arch/x86/kvm/mmu/paging_tmpl.h  | 56 ++++++++++++++++-------------
 arch/x86/kvm/mmu/spte.c         |  2 +-
 arch/x86/kvm/mmu/spte.h         | 28 +++++++--------
 arch/x86/kvm/mmu/tdp_iter.c     |  6 ++--
 arch/x86/kvm/mmu/tdp_mmu.c      |  6 ++--
 arch/x86/kvm/vmx/vmx.c          |  2 +-
 10 files changed, 83 insertions(+), 122 deletions(-)
 delete mode 100644 arch/x86/kvm/mmu/paging.h


base-commit: 8baacf67c76c560fed954ac972b63e6e59a6fba0
-- 
2.36.1.476.g0c4daa206d-goog

