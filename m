Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3600C73EFC0
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 02:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjF0Ad1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 20:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjF0AdZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 20:33:25 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96FC171F
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 17:33:23 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-c1039cbba72so5787696276.0
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 17:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687826003; x=1690418003;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=AweP17RhXXUhFvTFJBuae1XOhsBHKJK3W2/Ypd65v/s=;
        b=2+QCXPod217ocojLCUlG1YqICnEAUGAGYHAXWKh6uo+eBYUDs17BpCmtxKXZsbNAl/
         aOGwoE0cg21F7ThBz6qXsSh/ktjyqA/MuWPOHTy56DBJAx7KHt5k0FKHyxxKVkkTexw3
         xLEb1BXtQHMevvZShTuTTXKaC82JkIFx3X2TAkjYaFppeun3R1zbmeNKXd+SYxbxAukJ
         IsceXK9P2C/0WWApQwFQPfpLoZ0BNTmPAdo5+0L3w/ajEpyBftp3RbVTn/3kLl5/Yjdn
         +noJCPsbrfKBxB47gwC6BfuprK/wPyTv0Nu5MeQOjGjT1se7pb13Gol6EAcEVykCDzvM
         L7TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687826003; x=1690418003;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AweP17RhXXUhFvTFJBuae1XOhsBHKJK3W2/Ypd65v/s=;
        b=fH8piHjBuS+DjFfSTV2fr8KGsFhG6z6vR8cra2i8z34DbfXOp+xXUnPNi1aZzkVpVn
         UDWFDttOy8wY0FGJcNKXlbbL6Ul/XpbOKoYEHRJJBSj/fLYhYx8cy9pom7eqt3z7fRKA
         aW3BxcOK6uv6IUrRiO9ZVYCPDRjG3ww9fiKyz0d0dIcToOL6UxCPUPkaA036+zFHdH4D
         VENj9+BBO0xXRepcqReDU+yR95lcukxi0Csc8DijjgtpV8Q/+zSc7ru824yCQ8TwcNx9
         YVCudSC2x33UPSLdAYcvfqTLhEGHSB/RNZHV36Vt/EzK7x0BjmMQ0FaczSDXOVPFzOAb
         fZSA==
X-Gm-Message-State: AC+VfDwmyZt5FvVjQy474aHHm1Rcz6eXfaNYV1f/VzAxfWcgt1QIEcum
        klUBYGqur5fDO1wl1CQVpmIru4NPqTM=
X-Google-Smtp-Source: ACHHUZ42B9lwkUYh0JHlV2Mu1ktaee7xco1IJ9fPR/Tl5eTVgCkdAwVy/Z6I6Ok0xJ62LxG4d8VuhlODByg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d304:0:b0:bc3:cdb7:4ec8 with SMTP id
 e4-20020a25d304000000b00bc3cdb74ec8mr13558791ybf.6.1687826002930; Mon, 26 Jun
 2023 17:33:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 26 Jun 2023 17:33:05 -0700
In-Reply-To: <20230627003306.2841058-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230627003306.2841058-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230627003306.2841058-7-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: VMX changes for 6.5
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
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

KVM VMX changes for 6.5.  The highlight is moving away from .invalidate_range()
for the APIC-access page, which you've already reviewed.  Everything else is
minor fixes and cleanups.

The following changes since commit b9846a698c9aff4eb2214a06ac83638ad098f33f:

  KVM: VMX: add MSR_IA32_TSX_CTRL into msrs_to_save (2023-05-21 04:05:51 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-vmx-6.5

for you to fetch changes up to 0a3869e14d4a5e1016aad6bc6c5b70f82bc0dbbe:

  KVM: x86/mmu: Trigger APIC-access page reload iff vendor code cares (2023-06-06 15:07:05 -0700)

----------------------------------------------------------------
KVM VMX changes for 6.5:

 - Fix missing/incorrect #GP checks on ENCLS

 - Use standard mmu_notifier hooks for handling APIC access page

 - Misc cleanups

----------------------------------------------------------------
Jinrong Liang (1):
      KVM: x86/pmu: Remove redundant check for MSR_IA32_DS_AREA set handler

Jon Kohler (1):
      KVM: VMX: restore vmx_vmexit alignment

Sean Christopherson (7):
      KVM: VMX: Treat UMIP as emulated if and only if the host doesn't have UMIP
      KVM: VMX: Use proper accessor to read guest CR4 in handle_desc()
      KVM: VMX: Inject #GP on ENCLS if vCPU has paging disabled (CR0.PG==0)
      KVM: VMX: Inject #GP, not #UD, if SGX2 ENCLS leafs are unsupported
      KVM: VMX: Retry APIC-access page reload if invalidation is in-progress
      KVM: x86: Use standard mmu_notifier invalidate hooks for APIC access page
      KVM: x86/mmu: Trigger APIC-access page reload iff vendor code cares

Xiaoyao Li (2):
      KVM: VMX: Use kvm_read_cr4() to get cr4 value
      KVM: VMX: Move the comment of CR4.MCE handling right above the code

 arch/x86/kvm/mmu/mmu.c          |  4 +++
 arch/x86/kvm/vmx/capabilities.h |  4 +--
 arch/x86/kvm/vmx/nested.c       |  3 +-
 arch/x86/kvm/vmx/pmu_intel.c    |  2 --
 arch/x86/kvm/vmx/sgx.c          | 15 ++++++----
 arch/x86/kvm/vmx/vmenter.S      |  2 +-
 arch/x86/kvm/vmx/vmx.c          | 66 ++++++++++++++++++++++++++++++++++-------
 arch/x86/kvm/x86.c              | 14 ---------
 include/linux/kvm_host.h        |  3 --
 virt/kvm/kvm_main.c             | 18 -----------
 10 files changed, 73 insertions(+), 58 deletions(-)
