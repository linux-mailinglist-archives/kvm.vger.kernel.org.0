Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 358EE542634
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444282AbiFHBBi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 21:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835813AbiFGX5C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 19:57:02 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C105D7A835
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 16:23:56 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id l5-20020a170902f68500b00167654aeba1so5059810plg.2
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 16:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=bo5BCelcXXt3fHu9uBgQz0Xkxt3J+8ZEKQKzX+su88Q=;
        b=AiWxLo79QymuoxjFrVU0MccHOPdDVerKMgDPDOQLVx7/paevTTfLP5MwnqRr0H2DQ1
         uWS0vJOABqTtIaXzHaSqXGOrcdd9nuhFb7ZbsL0rf6NF5PwgMuLZ2wl0J5PVJlVuqWZj
         npkbf1QsdROJjca6fCWGfw3CI5Uzx9EyRv+7Lbe9Q3fYDnyxqsi9wUDqJJBSxKS5Z2KK
         BTO5PvSVRPL8Y295Rirvtu71qnFQSp+pCXjEKkb7t53+qd6RV5MdPRnGzkbHNdBrosdp
         W9ML1PpUppa5yLI+rn8oRKOfmaKPLjGfhIXb2LVFqVLE/6cOBADFiTsySyENVhxwwRGR
         NRNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=bo5BCelcXXt3fHu9uBgQz0Xkxt3J+8ZEKQKzX+su88Q=;
        b=freUHewJ+JuUgLIel75Y4TMdAsQs0jgZU+K8QdlJZzBTxswN8tVlKmSDLim3dsSlBB
         alOH+A7TSYubXKQH2sQF8rzuoYgj7muDO9e+4HBU8QjW2TD3IfvaPLUCUaRjLkrjbgki
         FRdyqZJUvnwmZQFPVVGcQrJnHa+O3JoK5PRF47C4l5h7boV6dtheHPitZVB7ZPZNmkVw
         s1rKLY0Y0ZmWxdLEW6Oc4EBHBEubraZAB9Sl1Tuy3Cua5CXqGApDDv2sw3tflS0MyHMq
         AyvqQrVkt2MtvMVYnSs8j+y0soS231D6LP2HBfquJbzvmVeeAHwlSZKKaJYU2y144/Et
         ClQQ==
X-Gm-Message-State: AOAM533514RepsJk80j+CpWk2MV68ScDRQuoNIAnLcdl/6Act57m/aZJ
        J5HCb/BF0LZTu9YDZrfPsn5bcJbXKZo=
X-Google-Smtp-Source: ABdhPJyWjszfOTBfQZ2L5GPUQD53SR9MIfNT6OkCd2LGRz0f74hUIQI6IopOkm2dZFMlwhpBGzb0jy7Rp8c=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:807:b0:51b:f4b5:db82 with SMTP id
 m7-20020a056a00080700b0051bf4b5db82mr19693888pfk.57.1654644236226; Tue, 07
 Jun 2022 16:23:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Jun 2022 23:23:50 +0000
Message-Id: <20220607232353.3375324-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 0/3] KVM: VMX: Let userspace set IA32_FEAT_CTL at will
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

Fix a bug where KVM requires userspace to set the guest CPUID model
in order to enable features via IA32_FEAT_CTL.

Note, the selftest builds on the vmx_msrs_test from the VMX MSRs series[*],
i.e. it won't apply cleanly on kvm/queue.  

[*] https://lkml.kernel.org/r/20220607213604.3346000-1-seanjc@google.com

Sean Christopherson (3):
  KVM: VMX: Allow userspace to set all supported FEATURE_CONTROL bits
  KVM: VMX: Move MSR_IA32_FEAT_CTL.LOCKED check into "is valid" helper
  KVM: selftests: Verify userspace can stuff IA32_FEATURE_CONTROL at
    will

 arch/x86/kvm/vmx/vmx.c                        | 43 ++++++++++++++---
 .../selftests/kvm/include/x86_64/processor.h  |  2 +
 .../selftests/kvm/x86_64/vmx_msrs_test.c      | 47 +++++++++++++++++++
 3 files changed, 85 insertions(+), 7 deletions(-)


base-commit: 838fd3e5a7208ee3b95bf73898c135a44a0c589d
-- 
2.36.1.255.ge46751e96f-goog

