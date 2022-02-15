Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF734B6020
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 02:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbiBOBsv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 20:48:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbiBOBsu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 20:48:50 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0934D9A989
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 17:48:39 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id y10-20020a17090a134a00b001b8b7e5983bso12033976pjf.6
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 17:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=HKswdXJ+0nNnyiWnFTUa/yv0LwwcIJs2eZd1UGozPFY=;
        b=o0hX/GlKa2APfQynI2VyQrWaxPRdH524mf46irlQUdJMhtNVEzbQ9bPE2lbbfW1721
         BuK2aHRcV5jR5PdYZBXKjMvo9JxYANtjnELQGco/c8hjDWC0b56gfJDectssL5VysX1b
         MmK1NZ7yT64lb2L2SgzsPbIdlZcbngrCW1kFyC+BDtgj05vQKWMHx+VdDm6BqOc/5qL9
         RbV2QQfA6df32bytgQurTrGJRi3T8kvY6ncYGodgroUUtIdWp4MSs/5R/fZ5C5zlcQNf
         nG6XkE1xp/B8ScxqW3xU/n8SZ93RcWTS2mG/W5TjUErQKr3193D+zFfgGNgvuFQGl5xo
         v/sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=HKswdXJ+0nNnyiWnFTUa/yv0LwwcIJs2eZd1UGozPFY=;
        b=Avt7CLFdk/+3ouPffJGkuW64v36/7Fq5Qj1uvLhAGwD8hqfu5RtqdpQK22y8pUT0Ac
         kCfCBGgwzVMagscGuS/0R5IcQUXPCXqKUoThwlAc+nwl8b9qGVLdZ6ZqMRAxmVuuqnwu
         lh0pKsOx45NcFo3TX6+mo01eykbDKjG3qBNceHFxTI32pCATw61tvJk4af0+Z8bZE0xT
         ClkS1T04rvxZ0bj014PVTuaDBuIH8W87tXdmWzD+rSQrHKnLibKpPwleJ654vupXysfL
         l2MbNxUciK9M3ITyJtjf489CGA+cbYqsOCByY/DMiP5uPwsp2KoqykNF/SDPU7ZYMRDo
         0SzQ==
X-Gm-Message-State: AOAM531zat/0Z7axUbrU9Nx5djVr3oGGIDceIKGSGnfm0R28Ijn2s+ee
        lowlaJOB1+hwA5egeZ67V4M/sGof1vzQVnY=
X-Google-Smtp-Source: ABdhPJw2j02D0dKkV+duCifZEr08RXlQI+mm2qqaZ7jmjRkJSOLo4TflYjgqVgndZAqvAD0NWcgAWjAYKmO6LNY=
X-Received: from daviddunn-glinux.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:782])
 (user=daviddunn job=sendgmr) by 2002:a17:902:c94c:: with SMTP id
 i12mr1618216pla.159.1644889718445; Mon, 14 Feb 2022 17:48:38 -0800 (PST)
Date:   Tue, 15 Feb 2022 01:48:03 +0000
Message-Id: <20220215014806.4102669-1-daviddunn@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v7 0/3] KVM: x86: Provide per VM capability for disabling PMU virtualization
From:   David Dunn <daviddunn@google.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, jmattson@google.com, like.xu.linux@gmail.com,
        kvm@vger.kernel.org, David Dunn <daviddunn@google.com>
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

Allow usermode to disable PMU virtualization on individual x86 VMs.
When disabled, the PMU is not accessible from the guest.

v6: https://lore.kernel.org/all/20220209172945.1495014-1-daviddunn@google.com/

v6 -> v7
 * Incorporating feedback from Sean.
 * Rephrased commit messages (borrowed from Sean).
 * Added locking around kvm->created_vcpus access.
 * Moved KVM_CAP_PMU_VALID_MASK out of user ABI headers.
 * Changed comments on vm_create_without_vcpus.
 * Directly check results in selftest TEST_ASSERT statements.

v5 -> v6
 * resolve minor conflicts that were queued after v5 was reviewed.

v4 -> v5
 * Remove automatic CPUID adjustment when PMU disabled.
 * Update documentation and changelog to reflect above.
 * Update documentation to document arg[0] and return values.

David Dunn (3):
  KVM: x86: Provide per VM capability for disabling PMU virtualization
  KVM: selftests: Carve out helper to create "default" VM without vCPUs
  KVM: selftests: Verify disabling PMU virtualization via
    KVM_CAP_CONFIG_PMU

 Documentation/virt/kvm/api.rst                | 22 ++++++++++++
 arch/x86/include/asm/kvm_host.h               |  1 +
 arch/x86/kvm/svm/pmu.c                        |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c                  |  2 +-
 arch/x86/kvm/x86.c                            | 17 +++++++++
 include/uapi/linux/kvm.h                      |  3 ++
 tools/include/uapi/linux/kvm.h                |  3 ++
 .../selftests/kvm/include/kvm_util_base.h     |  3 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 35 +++++++++++++++----
 .../kvm/x86_64/pmu_event_filter_test.c        | 33 +++++++++++++++++
 10 files changed, 113 insertions(+), 8 deletions(-)

-- 
2.35.1.265.g69c8d7142f-goog

