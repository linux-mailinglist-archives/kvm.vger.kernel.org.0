Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123103E8628
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 00:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235141AbhHJWqW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 18:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235049AbhHJWqV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 18:46:21 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B31AC061765
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 15:45:59 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id o19-20020a05622a0093b029029624b5db4fso259627qtw.23
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 15:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=eL5s2kUdV+92xFyW3SM6VFXr8+0Pvf4Nps5WWhKV5Uc=;
        b=kg5Fk9UmoJz3x/fwBOfqtRzHd15cZg/zW6cis5AKXZMrURfNBbNRt8Qp3zQoA0rHwV
         OMi1CYFICwGnyLOWITkdd6+VnHJlOBwqDUMSz5Tyy+z87Z2VqvOLH8HAoEjlGd+i26XD
         HFDdDNvsw0Hts5SahirPHgNmCoz/WiAzm1WGwtHTeNbbNeLa8KEsb02moydfomI13dUC
         nQ11G32tDHTZjYmYU5vrTjFasuY9g4VPVAZml7X/cT9v0TqIusCygtdy7ffH+UyK+vO6
         ZLSQHDfbZcRWvgu0jm7pwrf7SLdszggCOAjj2OiIKW+WVoDHQeX72PlpTjL5/nb9+iHc
         +r6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=eL5s2kUdV+92xFyW3SM6VFXr8+0Pvf4Nps5WWhKV5Uc=;
        b=nG7pOop0c2ewlkyd/GT+sX7bkzo6Be/9uZi4JKtfGOcJkAqXyXxhSsF+33MqWJgeHj
         esnTEkiwlvEIYKcWDtWTtUsnnYWX5NdTYv4uT4zFUp68lGt8VO7sKnogBSCcC4rCsEgs
         yjWi6TsPxTHoRdQjMtWOyJV+RXMnpdqDOtjduPk0nRkZ9QlCx3DTMsIbXnyy9qd/Sz2z
         rmOy/ozd3boj1eP44dRhyCkPq0m5/UOt4M8vurfo8AchIW42KlUrsHaAgZqStfBxDj0t
         kI9pOBs9ImlAleLRA5hOt/aeT1hc7YIHOVLU/pxEi4ECalioJPRapMWglViTvcN2mOVk
         ENFw==
X-Gm-Message-State: AOAM5312DZREVWzL4d7eJVGvnQgHNpwd6WGPfwTBiJ9Ke1pFwIhandBA
        S64YE+NiPxinQBIQH9YKmbL2Jx6cwX4=
X-Google-Smtp-Source: ABdhPJzwyzRaDLOx3GRlFxqMEuObzK3tawIVjRbfhlWiHECBUVNSBMw/O/dPef0ZdTYihK6U5WCNqZzm1Mw=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:1c47:622e:7a2a:372d])
 (user=seanjc job=sendgmr) by 2002:ad4:57a3:: with SMTP id g3mr6056782qvx.58.1628635558237;
 Tue, 10 Aug 2021 15:45:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 10 Aug 2021 15:45:52 -0700
Message-Id: <20210810224554.2978735-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH 0/2] KVM: x86/mmu: Fix unsync races within TDP MMU
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

Patch 1 fixes a bug where concurrent TDP MMU page faults can "corrupt" the
unsync shadow page fields, notably unsync_children, as the TDP MMU holds
mmu_lock for read and the unsync logic is not thread safe.

Patch 2 is a tangentially related cleanup.

Sean Christopherson (2):
  KVM: x86/mmu: Protect marking SPs unsync when using TDP MMU with
    spinlock
  KVM: x86/mmu: Drop 'shared' param from tdp_mmu_link_page()

 Documentation/virt/kvm/locking.rst |  8 +++----
 arch/x86/include/asm/kvm_host.h    |  3 +++
 arch/x86/kvm/mmu/mmu.c             | 36 ++++++++++++++++++++++++++++--
 arch/x86/kvm/mmu/mmu_internal.h    |  3 ++-
 arch/x86/kvm/mmu/spte.c            |  4 ++--
 arch/x86/kvm/mmu/spte.h            |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c         | 20 +++++------------
 7 files changed, 52 insertions(+), 24 deletions(-)

-- 
2.32.0.605.g8dce9f2422-goog

