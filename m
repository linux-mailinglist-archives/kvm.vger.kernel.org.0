Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1258C34F6A2
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 04:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbhCaCbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 22:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbhCaCa3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Mar 2021 22:30:29 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4FEC061574
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 19:30:29 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id d1so679547ybj.15
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 19:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=gQCuwGLAfsbw/UNMTMJ5GJMFsizewCkNOypdYowqK48=;
        b=wSryiJNO0/HtB5GXTbVL00PPqna6O7GlK+7E34vVtFEfl/ee5FOWHf36YgIP+5Kthy
         pcea+iq0lPtzOiZN1WlKxV81tK+ZNbYmP5nv2I6GpglqgMLax8hw7w0M6lLKSAXSVFZb
         Tv13wHHoE5JHQ3mUOnZRugmnalesT78gxOj/lkw0Amx4xiVXUSzHNaJ2XTEpFmk3+oqL
         S5cBspBO1WxvwGZnZS+WTiR7kCQR0a0SXT9N/RCNQIwnW9d0mWn0nvXrh6AvFhPkcLZd
         NaS1qsXm02OE9DfD3en6WKSs6Gqh0Syj+o8cTsw5AuKSaP5Oroc7NQORIsb047C4z0NL
         lItg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=gQCuwGLAfsbw/UNMTMJ5GJMFsizewCkNOypdYowqK48=;
        b=loSwDBnq3s25smJfYby/mQMdCe0Z2UmV6+JQ08hc2OJNM3AZw0DYhWY88QUzxNMbGG
         TBKyv5iZlPa3BzU8pyKu/16ICiIAGdp5f0M8Jgwl5R830kNdZjvzmIfhm9mYo3Fu0WUT
         DiE/CP49RrTA9UMPzo6sdAbH+ZFZmwEtuCFyXttqWhHUwDSqOAPDorCMLxArTku+scJU
         No3u62Z+uGrk5sZpkTdDHek7ZbdN5Fursxjocp+o4SMuu4JfIFgfcvfa7EW+4BAmbUZQ
         1mp+mqrUfz89UlZvHPkEAz/9lB63lkXuvLLbVbqJ8TEQ4Ogy6W2PGvOiULJoM7UF/qfT
         kQiQ==
X-Gm-Message-State: AOAM532FBe0TwxAzqplGGNyKPCnBATOHU2A9Qx/G/wHJ5SWRDIdtL6ha
        ZRLIrX3aX+/URDMsUDCv2qLa/T1DX/k=
X-Google-Smtp-Source: ABdhPJzIBEctIXJVpThNi6OlflzTn7FgBN15h3E04Il0jjJ+PmqaPLPHYW1WqIwC6phByJXcquT8AMP5OvE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:6c6b:5d63:9b3b:4a77])
 (user=seanjc job=sendgmr) by 2002:a25:ce13:: with SMTP id x19mr1522852ybe.235.1617157828611;
 Tue, 30 Mar 2021 19:30:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Mar 2021 19:30:23 -0700
Message-Id: <20210331023025.2485960-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 0/2] KVM: Fix missing GFP_KERNEL_ACCOUNT usage
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix (almost) all cases in KVM x86 where allocations that are tied to a           
task/VM are not correctly accounted.                                            
                                                                                
There are a handful of allocations in SEV code that I intentionally didn't
fix in this series.  I'm 95% certain those allocations can be eliminated
completely, changing them in this series only to delete them seemed
pointless.

The allocations in questions are for structs that are used to communicate
 with the PSP; they are temporary (freed in the same function that does
the allocation) and small (some are _tiny_, e.g. 4 bytes).   AFAICT, the
sole reason they are dynamically allocated is because the CCP driver uses
__pa() to retrieve the physical address that is passed to the PSP, and
__pa() does not work for vmalloc'd memory, which is in play when running
with CONFIG_VMAP_STACKS=y.  

I have functional code that uses a scratch buffer as a bounce buffer to
cleanly handle vmalloc'd memory in the CCP driver.  I'll hopefully get
that posted tomorrow.

Sean Christopherson (2):
  KVM: Account memory allocations for 'struct kvm_vcpu'
  KVM: x86: Account a variety of miscellaneous allocations

 arch/x86/kvm/svm/nested.c | 4 ++--
 arch/x86/kvm/svm/sev.c    | 6 +++---
 arch/x86/kvm/vmx/vmx.c    | 2 +-
 virt/kvm/kvm_main.c       | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

-- 
2.31.0.291.g576ba9dcdaf-goog

