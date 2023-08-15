Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF5577D530
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 23:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240221AbjHOVgP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 17:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240288AbjHOVfv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 17:35:51 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE421BD8
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 14:35:39 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-564b8c529bfso6315900a12.0
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 14:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692135338; x=1692740138;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tVl3VRj57iGr8qaIRcvd93q5Wtl5mgpiK42P78vs0Wk=;
        b=st/sTpRNP/idx5nlQZE0UaS24tJVAcF4CELTvWKEpOBxgj1C2QWWPrpIZvxmbTd0Ip
         hr0jUZwnERWNdnSUZoMdaS0UF/GVcygUH6nlTEsQGb50HvVWmbsyS7kc9NWoj9r+MiGv
         pH6vEZAwPcYxZGa4aZugNXLAQaJrV9kngpycQftIzDW2oeOeD0H0cN2VygiIouovp3oa
         YAIKwVT2AG1eBqo2IISvcl0XDoSr2+US9Suzl23ovnjkQmczqdwvlmYpLQ698FmWd6DE
         dXy/Alrh3bAytD25sizHNdi7CylUdgAMwj6udvCHrTw16L9SbRHJdsB8NaYGIzG1fpRW
         5rLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692135338; x=1692740138;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tVl3VRj57iGr8qaIRcvd93q5Wtl5mgpiK42P78vs0Wk=;
        b=UUl3pzVw3PAG5hUbemrWWkTZXJ4WeAowilhMNbmVHGy+dHBZYgK9wwgt2px1/OXrkU
         Ytz2iQtN4f5KPUn8ER5RVRenyg20aVzXqvBPJQjW7WngTdZ8NqelLbq4IFNJI5qPWeLl
         Q8Lq0qkQMmxUkKdTfa41n8t+0QBLZ0BKB2MaOW7l5680HjARY1IITN599uuAvG1pG2hc
         Lf3qKhhO873iAbJvqvwMwqlFglxPduLMDnZq0lroQUCa+uZu9KKj1RwmKQdqN0rmHcbO
         XzmtJ5Y/q/8PDzrmFOwL0Vg60Z6M1myVZlSTyV2yxK9DvZLGCuifnEp5O32csneiRwBs
         N61Q==
X-Gm-Message-State: AOJu0YwB+Kv6yRl7h7EKcJY6QjvbVistFp7PcJV7ptlMlcR90OEABjPU
        wriRPDPYuVa1/W/Z8s07iBHc98gf+yE=
X-Google-Smtp-Source: AGHT+IEQJUXjsmbqH1x4y9bzfU8nFQD6xuICpUdNtkubfBXgLbWJbZDHZj0rAyx8MSDnBexaefmpTUylrls=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:950c:0:b0:565:e2cd:c9e1 with SMTP id
 p12-20020a63950c000000b00565e2cdc9e1mr8860pgd.11.1692135338581; Tue, 15 Aug
 2023 14:35:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Aug 2023 14:35:23 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230815213533.548732-1-seanjc@google.com>
Subject: [PATCH 00/10] VM: SVM: Honor KVM_MAX_VCPUS when AVIC is enabled
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The only true functional change in this entire mess is to change KVM's
handling of KVM_CREATE_VCPU when AVIC is enabled.  Currently, KVM rejects
vCPU creation if the vcpu_id is unaddressable, i.e. if it's larger than
what is suppported by AVIC/x2AVIC hardware.  That is a rather blatant
violation of both KVM_CAP_MAX_VCPUS and KVM_CAP_MAX_VCPU_ID, as KVM will
advertise a KVM_CAP_MAX_VCPUS as 1024 and KVM_CAP_MAX_VCPU_ID as 4096,
but then reject vcpu_ids as low as 256 (AVIC).

To fix the problem, add yet another AVIC inhibit to disable AVIC if
userspace creates unaddressable vCPUs.  Alternatively, KVM could report
different KVM_CAP_MAX_VCPUS and KVM_CAP_MAX_VCPU_ID values when AVIC is
enabled, but IMO that path sets KVM up for failure, e.g. it would make it
really hard for us to enable AVIC/x2AVIC by default, and we'd have to have
to rework KVM selftests, which assume that KVM supports at least 512 vCPUs,
e.g. recalc_apic_map_test fails when AVIC is enabled.

The bulk of this series is cleaning up related code, most of which is
purely opportunistic, e.g. the many pointless PA masks, but some of which
are functionally "necessary", for some definitions of necessary.

Lightly tested, and the IOMMU interaction is basically compile tested only.
But this is firmly post-6.6 material, so no rush on anyone testing this
(I wouldn't even care all that much if the darn selftests didn't fail).

Sean Christopherson (10):
  KVM: SVM: Drop pointless masking of default APIC base when setting
    V_APIC_BAR
  KVM: SVM: Use AVIC_HPA_MASK when initializing vCPU's Physical ID entry
  KVM: SVM: Drop pointless masking of kernel page pa's with "AVIC's" HPA
    mask
  KVM: SVM: Add helper to deduplicate code for getting AVIC backing page
  KVM: SVM: Drop vcpu_svm's pointless avic_backing_page field
  iommu/amd: KVM: SVM: Use pi_desc_addr to derive ga_root_ptr
  KVM: SVM: Inhibit AVIC if ID is too big instead of rejecting vCPU
    creation
  KVM: SVM: WARN if KVM attempts to create AVIC backing page with user
    APIC
  KVM: SVM: Drop redundant check in AVIC code on ID during vCPU creation
  KVM: SVM: Rename "avic_physical_id_cache" to "avic_physical_id_entry"

 arch/x86/include/asm/kvm_host.h |  6 +++
 arch/x86/include/asm/svm.h      |  6 +--
 arch/x86/kvm/svm/avic.c         | 79 +++++++++++++++------------------
 arch/x86/kvm/svm/svm.h          |  6 +--
 drivers/iommu/amd/iommu.c       |  2 +-
 include/linux/amd-iommu.h       |  1 -
 6 files changed, 48 insertions(+), 52 deletions(-)


base-commit: 240f736891887939571854bd6d734b6c9291f22e
-- 
2.41.0.694.ge786442a9b-goog

