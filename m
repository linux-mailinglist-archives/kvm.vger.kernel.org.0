Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29AEA4064F8
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 03:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235016AbhIJBP6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 21:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234003AbhIJBPw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 21:15:52 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16E7C08ED3E
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 17:49:22 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id v65-20020a627a44000000b003f286b054cbso198946pfc.11
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 17:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=dEdxgR+gW3CA1xQLb38rytPzrES1DL67Ux6A5LMF1hE=;
        b=M5VNWAyB8m19PEM6kIY9iuTeb1Xx80xAZbeYJcIhWPCTh6WRfOB109DGID2/XjRrq0
         lNfXAfaWumtKxg6frGyZOUE3Ti/1bXxS63hAFzKK3vzMWMXFvvXcHswdVCnbSQ4FSVmz
         7xPxcBXufl3zRO6rH2JwBa430gIC4+I9fL2KOkI8azT/p5yLhmvAm3II8j3f6Tzmbdgv
         ib3W1twjR+vmqRt7Td9uaD40H/e+f23ce8Gg21a4knrCwVns02a/SucIaCvZxVe+O4vN
         3pdnKub0f6wG/k3OzlM9KLPGT395AUcP2XHyK8eMmqoYhDZGqps0W5TK2ZPR6miwYUeD
         dK8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=dEdxgR+gW3CA1xQLb38rytPzrES1DL67Ux6A5LMF1hE=;
        b=qVHJT2AZ16GAbAvKcaGqQK+YA4H5lkSkbn29pxE7mW6+jQ1sZWHyqolWraC5POF8nK
         xyITZip2HrHbUUqqZN48ASHYrQCom1kmEsf38uzN6TXc0tWzljcAKr7slnDH+Q18jWn/
         dHcG+blz3umbCidqj5rMdLThpjWmT1gUgOxN0PgHNb6fIZPyFBs4rLw5eHhYmkmGASip
         zU9E2oeeQkI82/xbMWEL2tNtCO2+rCFzxeY3sGnz9UG5KOa053jQ48JgzKkpsJvYJwYL
         N1/WMSjlfim5jl/b2Zedz/iecgUVDnpnOAgMOWDNzQgMy8wRMnvTsiIppTNl5k4SV/wQ
         3V0A==
X-Gm-Message-State: AOAM533hnn3g3lu3A5NLybh8GzAfKAGLsCUuZFsm4KS3f34zX+TNSPhI
        UGC/uKXvYlo+1imq/bu6WYOWe4AccGW+S1IkEbgdymg7lMENZ5ClZM2QOvaoIpu5WgUt6d3jyGt
        Es0AzUxM02z7WQU3z6ZSs9OZS7htgxyi3UAaY5eZHuctluAIVoMarr/Ij7wzXSDo=
X-Google-Smtp-Source: ABdhPJx2dtSeD1rpEMeeTCoYm9lmfTiEVNC3xqi2+/nX82mrsrKK906Uu6TqTvZRHtZHYiRDV8rjHO8nHGBf+w==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:aa7:83c6:0:b029:3e0:1f64:6f75 with SMTP
 id j6-20020aa783c60000b02903e01f646f75mr5657228pfn.69.1631234961995; Thu, 09
 Sep 2021 17:49:21 -0700 (PDT)
Date:   Thu,  9 Sep 2021 17:49:17 -0700
Message-Id: <20210910004919.1610709-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v2 0/2] KVM: arm64: vgic-v3: Missing check for redist region
 above the VM IPA size
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM doesn't check for redist regions that extend partially above the
VM-specified IPA (phys_size).  This can happen when using the
KVM_VGIC_V3_ADDR_TYPE_REDIST or KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION attribute
to set a new region that extends partially above phys_size (with the base below
phys_size).  The issue is that vcpus can potentially run into a situation where
some redistributors are addressable and others are not.

Patch 1 adds the missing checks, and patch 2 adds a test into aarch64/vgic_init.

Changes:
v2: adding a test for KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, and returning E2BIG
    instead of EINVAL (thanks Alexandru and Eric).

Ricardo Koller (2):
  KVM: arm64: vgic: check redist region is not above the VM IPA size
  KVM: arm64: selftests: tests for vgic redist regions above the VM IPA
    size

 arch/arm64/kvm/vgic/vgic-mmio-v3.c            |  7 ++-
 arch/arm64/kvm/vgic/vgic-v3.c                 |  4 ++
 .../testing/selftests/kvm/aarch64/vgic_init.c | 52 +++++++++++++++++++
 3 files changed, 62 insertions(+), 1 deletion(-)

-- 
2.33.0.309.g3052b89438-goog

