Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4CDA42754B
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 03:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbhJIBDh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 21:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbhJIBDf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 21:03:35 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7117FC061570
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 18:01:39 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id 13-20020ac8560d000000b0029f69548889so8810966qtr.3
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 18:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=2XmwK2K833EFOLIJ37ngWkEGrt3oRZzXMcCNeCxgUt8=;
        b=SC025lOceSrL6R2NfEHW+1SG5OZ9xeLPjd1eipxsnCviLmnH7udp7jPgvu7dZDugwy
         Qfv4MFmr85/b3FP1zVVeBS64mxu8ZfVL782E8y4h3mC14eVMd9mHPAr1YzjNZlcj/SO9
         Ckt8eQj5sywPNjVt8kRi87iiMhein1EVB5wMjXI0v/lStKpPF+9IQl77Op2q4Q9gKo+E
         IRPHGIWDHK33IxRZZ2Vms1cc0cQOk+QBucaCCKVctW3YXrqBSNsJajq3uDGkvpeihlI+
         skbz2lKmBXLRWCitCiFkG6vmUDjZ/PzZNLqueG3Qj/bRaC2jmzfm5EiU0UHF5qVoDxxy
         eDpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=2XmwK2K833EFOLIJ37ngWkEGrt3oRZzXMcCNeCxgUt8=;
        b=0us8k7nYPM5UC9r6uHtGJIs9iMjbBUu++XiFILKYjb3QyzCUwQ4sjR9YmgdWefiO7P
         LKjZwYvAm5VR/brXd/Z8q0GMGuA6vxglfWxWltW5VCiOjeNWyknI7Jtpbq6Ym8wiLbMP
         90Q9S8FhLaCAlvr7QVwt+bsSHbbMVu7hEfUVFpD5u2o6P7N5sM7CHdfiHaVN6mx787Kc
         3DJTn95W/1YP3LfrZc4jbh6y5p8yH0jrcc/rWuykF6l32tFR4w2nUd4EqP/gRJnudXsW
         MywSwxRk9RMcocN89tuzIJpR8eWIAIpGvnJNH1ZH8k0gpg4ZOwxBpcYMCEYrjr/TPi2b
         Tsfw==
X-Gm-Message-State: AOAM530rkcRT0qbZA58V4Zh7QDsGYN13TJ1FEz82SUnotcsCeO+7B11L
        jFbDAhVvrLyHMC6Z6VsqkOVPZwRMDr4=
X-Google-Smtp-Source: ABdhPJyImYrXiX4huD62GcgSUkgAGB2sC+Z7x6QVt8ecoJLUPZQusHnIg9Dk9iwp/Sa9e7cFfJw+0K4lQX8=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:ac8:5a4f:: with SMTP id o15mr1663853qta.394.1633741298613;
 Fri, 08 Oct 2021 18:01:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 18:01:33 -0700
Message-Id: <20211009010135.4031460-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH 0/2] KVM: x86: Fix and cleanup for recent AVIC changes
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

Belated "code review" for Maxim's recent series to rework the AVIC inhibit
code.  Using the global APICv status in the page fault path is wrong as
the correct status is always the vCPU's, since that status is accurate
with respect to the time of the page fault.  In a similar vein, the code
to change the inhibit can be cleaned up since KVM can't rely on ordering
between the update and the request for anything except consumers of the
request.

Sean Christopherson (2):
  KVM: x86/mmu: Use vCPU's APICv status when handling APIC_ACCESS
    memslot
  KVM: x86: Simplify APICv update request logic

 arch/x86/kvm/mmu/mmu.c |  2 +-
 arch/x86/kvm/x86.c     | 16 +++++++---------
 2 files changed, 8 insertions(+), 10 deletions(-)

-- 
2.33.0.882.g93a45727a2-goog

