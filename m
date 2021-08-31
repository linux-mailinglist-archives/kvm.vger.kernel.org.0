Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF0B3FCBAC
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 18:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240648AbhHaQne (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 12:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240532AbhHaQnY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Aug 2021 12:43:24 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20B8C0613D9
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 09:42:28 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id l24-20020ac84a98000000b00298c09593afso2505999qtq.22
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 09:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=f12jBhwq9+r/36NoKImUDEFN+8rcbqX1M1KRePLwVzM=;
        b=k7XX6L8E3h8OOOUPT5I1QXsY0ja9hOXH9xib1TsSyFkgiC+zEr9+9+fJcwJn5CDk7F
         HthqKNLD9bHN6bCcdiHKjb11Jx1eqJPO6A+xvWVKgxiQuTTSbXIfIdU6HWYlcYUgRuGR
         4Ah3lNbn94Dzu4xQ5c/i4AN661IvE3pleqlXYNqCmIKsdlMjC+zQQA2KHD724zf7kYYi
         rgKEnOBl2uz65Nf5pM2wwn/Je1Vu6vOdJDhigMYbPBSHFai61qb79Grv6FN6KiMejmXa
         lHI+1IbylAtPhrNdhK+ef5x6Xquw/XP/r1sC9VBXHBsxpONjJoR8KyzInszFzFWXmRU6
         Y61g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=f12jBhwq9+r/36NoKImUDEFN+8rcbqX1M1KRePLwVzM=;
        b=rEDPO5KRtKkEztin5KUL7TXYwjlcjG/p2R5OCmUAW2pUx2kKC/Tmo9rdyljVsnKey6
         cB+GqM102AsN0oBtBNTYirjGMMD3EeIWxnLkDkokfQfDREYTgYQBhf1TukvTl7Ep0FcX
         5bCIzWuaT9Beulbglf1p7n+gxpGLdPNNQrl0cDSERQ9YXHhtZU6IOWMWGwRBkCozDq2/
         Jktsx9wsRgc2HSogvhcK5K9GbP7yAjUptgkJCSaHqoMcglJU+UG7pUXtQs/KUWEiOBPs
         HpwITk/HXUuajzcjHX3GnBtcCp6kbQgDJa2RlQpt1Gn2sE4lwKRKSQISl7Hw52spInCf
         JnQA==
X-Gm-Message-State: AOAM5332Mql/BRjmNJkVOAQTXfG35VWidaX0plVk4Ln27fEOtbbTQp6W
        CFTPBUb9FX5cXrsegdoWMVINRCGgssM=
X-Google-Smtp-Source: ABdhPJwJpm65TcqXyqkx3P+gbjLiQnm24vEdkncuu85mx+K1P0HAooOTK+aguQjwBYqG1E1oUUgR7+Ii9ac=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:ddbd:588d:571:702a])
 (user=seanjc job=sendgmr) by 2002:a05:6214:2609:: with SMTP id
 gu9mr29117556qvb.35.1630428148017; Tue, 31 Aug 2021 09:42:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 31 Aug 2021 09:42:21 -0700
Message-Id: <20210831164224.1119728-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH 0/3] KVM: x86: guest.MAXPHYADDR fix and related cleanup
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+200c08e88ae818f849ce@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a bug exposed by syzkaller where running with guest.MAXPHYADDR < 32
leads KVM injecting a garbage exception due to mishandling an illegal GPA
check when "translating" a non-nested GPA.

Clean up tangentially related code in load_pdptrs() to discourage reading
guest memory using a potentially-nested GPA.

Sean Christopherson (3):
  Revert "KVM: x86: mmu: Add guest physical address check in
    translate_gpa()"
  KVM: x86: Subsume nested GPA read helper into load_pdptrs()
  KVM: x86: Simplify retrieving the page offset when loading PDTPRs

 arch/x86/include/asm/kvm_host.h |  3 --
 arch/x86/kvm/mmu/mmu.c          |  6 ----
 arch/x86/kvm/x86.c              | 56 +++++++++++----------------------
 3 files changed, 18 insertions(+), 47 deletions(-)

-- 
2.33.0.259.gc128427fd7-goog

