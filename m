Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B4B34F592
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 02:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbhCaAuA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 20:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhCaAtq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Mar 2021 20:49:46 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63507C061574
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 17:49:46 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id k189so457217ybb.17
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 17:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=Ip90cd5DdBRO62D8M6ZdfnlkzPDNszJ/oEbwkGCs1tg=;
        b=ZSiT5suIbZXzuUXW/ufGTEQldjuDOY+jEb5yoim4jvJqVl3cIhyTMFcRguKnCrpyMI
         HVhT8iLmAIiJ5q+4LBIDFKH0JGVFKRzHlgl+uGrFFJ/n2TQMGVMLDkDmUrcF7Rp9Lq7o
         i784pm7VONI/3PDPav0rW1nBRJS5y+ztBxfY4l8GSx0pXM570e132nE+GpkVJGB/NzOX
         LJJEfIyYUpAvhIt5pAbjweYLLaMWUDBInsPKEqCzzGKUDIvsmqiG1Xv1kfPv6/LuAELS
         /09TjUNlHVio3ystjVBncTZr2wlGv/QDqxdz69RIWmwNNy7t8elqVzultOkOX1hWRkE/
         pQmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=Ip90cd5DdBRO62D8M6ZdfnlkzPDNszJ/oEbwkGCs1tg=;
        b=TJE4SBeLAwUc8GU8qYWi0fAeZrhAzwjENbaUAq63hAEyTsSvdZe7Qlq8xQGuUApyOI
         pfR3Btc/BfQRR+g3ymnZ/sElAkuvzt71pOohXWXaiKYJHhxH3rUB719dLS4zqpnAdUrN
         VUl1TVMt6LtnuTlBg/JdApGl2xywWUDMpeT+Fm31+qtBszn1Ze9ZEc0TBr3kDx25yDxG
         cUCj66EWxGwr+NPwvAzTJvq7kPDLJmKhKuPmlJzyhuv4W3M2q1eF+rbPWpVkCzYsBcQv
         rH1UCwajvB295IDTm2n6x8waivFET8A0bpgP4lgH8pPiU777LijNs+bGOeRSwzskEQRi
         WcIA==
X-Gm-Message-State: AOAM530kbEqq4jh8+FA8qvAzgA7aaCLMuZa/vobOI7CjbL5kwkIOGoMI
        g367/P/os7Xj9ElhWaXwoDjFmmlAcD8=
X-Google-Smtp-Source: ABdhPJwCFwgSSFL1i7mtqQeLTyQ0J7GlYsbA2OnjWvAxXWS3Y/mD7bH8msEh6JThZU0ztBb03MLhIKtrMcA=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:6c6b:5d63:9b3b:4a77])
 (user=seanjc job=sendgmr) by 2002:a25:483:: with SMTP id 125mr1180394ybe.368.1617151785514;
 Tue, 30 Mar 2021 17:49:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Mar 2021 17:49:40 -0700
Message-Id: <20210331004942.2444916-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 0/2] KVM: x86/mmu: TDP MMU fixes/cleanups
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

Two minor fixes/cleanups for the TDP MMU, found by inspection.

Sean Christopherson (2):
  KVM: x86/mmu: Remove spurious clearing of dirty bit from TDP MMU SPTE
  KVM: x86/mmu: Simplify code for aging SPTEs in TDP MMU

 arch/x86/kvm/mmu/tdp_mmu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

-- 
2.31.0.291.g576ba9dcdaf-goog

