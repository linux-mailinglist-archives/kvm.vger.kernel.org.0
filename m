Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8396D436F02
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 02:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbhJVAvt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 20:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbhJVAvs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 20:51:48 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BD3C061766
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 17:49:32 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e71-20020a25d34a000000b005bf2ce89e18so2198330ybf.15
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 17:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=Irtqju5gyMJV6AfkdBNEvxt/hGwjhVmgHlVM/0ELFLE=;
        b=JUmTYWhjRmsmKN3avQsdo0t1lweZaevgxc2zPZyMVroilnqAJnXFDyeG33JM2aH/xd
         k4ytzFrQm34UICd476f86EI+hpBFBJHMPKr2+VeycWsBaxiEat3gushgx/k3GuRCiS0E
         o5bQxtcSOSt9xXD2ABYjLG0O32Ix12XCgl5BA0RDxD9GMP6VQift/Sx3V5gXNyY/Gv1h
         po3FRrWpD5WO50yXj7xwJCcXptbIX+FcbOHZokTC/8hjHlWAQ9EJ0VsIME0eY89XdtY2
         Nzkx9qAXltu7ZpDfnd7SKDCNSGHqlTGi2DKzOtrgyNmGsarVsf0qcFD2ueAbl2QvagV1
         +lFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=Irtqju5gyMJV6AfkdBNEvxt/hGwjhVmgHlVM/0ELFLE=;
        b=8An6Q7QYyh4S15/xr6IIavO0Ola3ZYyDf1D4QJ1LcN7VtQQnd/PO6xgL1tyPoPtGky
         EhFvMGlpMBwDFx0wdNugNAXSzh8vaVBKPZVyUkSJyl/QReggwCi8OOPeHl+0bOnebLwl
         SNNwSM9pWQMDv/nLCt1S1rjAdXRupMTE0cZ/bucH7Ysq4mn2zeVeDqDSRu5/eWTUL2iV
         SNKBkK4uAB+jcmeJYRjpUXwtcvM1VJoZ/6uSAjuzJf8QuJP5cbrgmCYsLqGsBmjbq+Z5
         BsxXMl74fIOA+KeVd0mQ7dKh6x4e3EHIhbd2XExYSPczhiCBXe/305VV3l+/fF7lz8RT
         oRcg==
X-Gm-Message-State: AOAM531+zLq9HQaX6Tq695o7sfkYumpeG/GFRGhyINxKoad9t6FcyNSp
        JXIj83+GUDVx0E6DrtmmWV1EPRDJvYQ=
X-Google-Smtp-Source: ABdhPJzY9La0a3g1kdxtp/7IS9I1MUumeAI3g6gsUsChvHTbvFLFjXq5GsnCNNyd4erOIYWC6Vw4vIJVQ9k=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:db63:c8c0:4e69:449d])
 (user=seanjc job=sendgmr) by 2002:a25:d34d:: with SMTP id e74mr10205544ybf.253.1634863769748;
 Thu, 21 Oct 2021 17:49:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 21 Oct 2021 17:49:23 -0700
Message-Id: <20211022004927.1448382-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH v2 0/4] KVM: x86: APICv cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

APICv cleanups and a dissertation on handling concurrent APIC access page
faults and APICv inhibit updates.

I've tested this but haven't hammered the AVIC stuff, I'd appreciate it if
someone with the Hyper-V setup can beat on the AVIC toggling.

Sean Christopherson (4):
  KVM: x86/mmu: Use vCPU's APICv status when handling APIC_ACCESS
    memslot
  KVM: x86: Move SVM's APICv sanity check to common x86
  KVM: x86: Move apicv_active flag from vCPU to in-kernel local APIC
  KVM: x86: Use rw_semaphore for APICv lock to allow vCPU parallelism

 arch/x86/include/asm/kvm_host.h |  3 +-
 arch/x86/kvm/hyperv.c           |  4 +--
 arch/x86/kvm/lapic.c            | 46 ++++++++++---------------
 arch/x86/kvm/lapic.h            |  5 +--
 arch/x86/kvm/mmu/mmu.c          | 29 ++++++++++++++--
 arch/x86/kvm/svm/avic.c         |  2 +-
 arch/x86/kvm/svm/svm.c          |  2 --
 arch/x86/kvm/vmx/vmx.c          |  4 +--
 arch/x86/kvm/x86.c              | 59 ++++++++++++++++++++++-----------
 9 files changed, 93 insertions(+), 61 deletions(-)

-- 
2.33.0.1079.g6e70778dc9-goog

