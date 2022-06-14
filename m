Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1E2154BE23
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 01:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353692AbiFNXFy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 19:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237349AbiFNXFw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 19:05:52 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810534C79C
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 16:05:51 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id y2-20020a655b42000000b0040014afa54cso5603584pgr.21
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 16:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=A9rUXvdVK65qUUpsbFmN+bngaxum3AL+F3dm7wAVHWY=;
        b=Umptkd+8NKLxaEKI4cNl2ZYx3SCrphu2j/zUusXMdXqbdBYvUEArY/0NMWP0kdza0h
         LP9dCvPGMMd7QKpNr/5lRShkHYOQq6F/dkZUgmsBulpD86vfye9wDj7nQvdUqGyvEVcO
         CmWXNbbukqV5APzsTaVJK1/+ObQYKj/CiaEK4NFdPeiJ7mMap+5V+kdCXl8YsNb1LQnD
         KVdviBv1MQY0L39MoHtJjQKe4yAjlVw9y6kRUtoENnKi4NZ8Jru+Sc5rbNq7DYisMS/G
         ZIJtai4Mtb18MT4DJ1KowTAX2CKu3l5/Xf0PuW9CTI/6Wo5QvICSnOuiXGxnB+1hcYGx
         NCEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=A9rUXvdVK65qUUpsbFmN+bngaxum3AL+F3dm7wAVHWY=;
        b=BUCvIO03CMxwzyH/H4s3ZAOFY7tze/wzKzA1h30rZIgdj/7Qvr+SQ3za1M2TiEzK66
         /5Cd9BrDSGB+6ANkVWJbL/OHi6cFxo9hPgDOSTnQtdyclVdJNh1AI6K1an2Wt+UfwLeB
         g7loHqPMqbTLsGi/n3jzYWxldWFQ26W7trr8Sr+hPFj/5SKeJNm2bvhUjA0m324QUiFC
         gI3RLHcQ2BRqtIVQANYccXI115CvUEnYRq4gkQLmoApFlaew/WHz7xLFfxQAm4NU1tAs
         GjdShTdvCNta0GEm6JW86IZIhLMyqFay9h26GF4WqVf17RtyS52uO7Q7eegDWa09h991
         MnLg==
X-Gm-Message-State: AJIora8p0enPayZaOoR4XO1+cQBdb8tsUbsV+zybD2Cf66WyCGvlHLJE
        IC2VN3w21P5NkKRoScMD0E8baXkwXH0=
X-Google-Smtp-Source: AGRyM1uXOIC51AJADaKJ+5YB7+WUpl3cweTvMN7oZYuXo9Q8RhX6gXBSHPORq9zbag4Z8a5av8va5iKaLLs=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:2341:b0:167:4b11:a8e with SMTP id
 c1-20020a170903234100b001674b110a8emr6361773plh.10.1655247950995; Tue, 14 Jun
 2022 16:05:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 23:05:43 +0000
Message-Id: <20220614230548.3852141-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 0/5] KVM: x86: Move apicv_active into kvm_lapic
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

Move apicv_active into struct kvm_lapic; KVM enables APICv if and only if
a VM/vCPU has an in-kernel APIC.

This was posted a while back as a one-off patch in an APICv cleanup[*].
The idea and most of the changes remain the same, though I eked out a few
more cleanups.

[*] https://lore.kernel.org/all/20211022004927.1448382-4-seanjc@google.com/

Sean Christopherson (5):
  KVM: SVM: Drop unused AVIC / kvm_x86_ops declarations
  KVM: x86: Drop @vcpu parameter from kvm_x86_ops.hwapic_isr_update()
  KVM: x86: Check for in-kernel xAPIC when querying APICv for directed
    yield
  KVM: x86: Move "apicv_active" into "struct kvm_lapic"
  KVM: x86: Use lapic_in_kernel() to query in-kernel APIC in APICv
    helper

 arch/x86/include/asm/kvm_host.h |  3 +--
 arch/x86/kvm/lapic.c            | 38 ++++++++++++---------------------
 arch/x86/kvm/lapic.h            |  3 ++-
 arch/x86/kvm/svm/svm.c          |  5 +++--
 arch/x86/kvm/svm/svm.h          |  4 ----
 arch/x86/kvm/vmx/vmx.c          |  5 +++--
 arch/x86/kvm/x86.c              | 14 ++++++------
 7 files changed, 31 insertions(+), 41 deletions(-)


base-commit: 8baacf67c76c560fed954ac972b63e6e59a6fba0
-- 
2.36.1.476.g0c4daa206d-goog

