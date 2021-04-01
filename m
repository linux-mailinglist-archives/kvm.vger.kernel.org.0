Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F5F352404
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 01:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235949AbhDAXhp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 19:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234548AbhDAXho (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 19:37:44 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63F4C0613E6
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 16:37:42 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id c1so4806980qke.8
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 16:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=vJ782tPIwg5HrJEEBMGpQmwNZsk9pDTuVerO6dJHWsw=;
        b=vTJwbEAu/t/5wjVhuKeAyWFRl/XKhnrScZ8p3fG7OVHAXGKID0UIxVoi3bwPA1Sa3z
         my7FswdYJWVOzOXsMwWMytT299p+3GmTzjBLfeTdg/IOiEhlCljIrAnmilsr5kCXRkcQ
         C9IiLRGlN2QDwVhACUN3SrDAmIiAQ7vc2E/YKySqepqxLCMrUGZYG+DnufFUJDWcfneZ
         L1R6Ybn7nUc0YA13CaKBcfj1q3FLfdISK9pc+q6bZ4FEkT1t6oit+5jjUDUz1cU3z+Re
         LurQ/wYnapokxkghUBE1y7e2c0fM5oHYTpP4ZVUqgWg2eRakJXUtvvMxCcgRlRXw5yhO
         FUhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=vJ782tPIwg5HrJEEBMGpQmwNZsk9pDTuVerO6dJHWsw=;
        b=fh62hm1G3eOe7gAsJy94o0lOWvb6srwqPhbverRLfU3Zb5YdWM1VdBKfeR6Qot4Egf
         rfyFdKCFNmx4PEPFGf6FQkCzljkwePBlMRIgiUpYQC2x6zavur5ZHW4bLSiJn6lSwgPj
         mawBImJGI4CN6gUxmonlWZJ67U8LympRClRPSdDKkmRz9WH7lMC1bbCDv0TfKpos6aYz
         1n6kodSx1vLIz79oCoSKcb+GNGRH8538H4Ef9JYz3lnnx5GlPQEoHG1UR24MeH7EHVZp
         +2haVGiYnM4KD9rKQbl2N6kFbDEEGVsNaX84a3h1gRInTqDxOAfJ5aUk0MJ38HuU1f8e
         OtNA==
X-Gm-Message-State: AOAM5335VLook8yWs9LnsAb5qwH62SBrtiA/QYfL9CksNm9v4uks/sZl
        V1AaPMkc1fhDkt6oXWfPDVW/00BZQ3ud
X-Google-Smtp-Source: ABdhPJwb6aFvxKbxcOeSkUQALt7XSlnEE2UVCGTOZMkY0L/y0eaBNHoMr25u4faIyyH6LpVmwDAbLT9I5Vyg
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:e088:88b8:ea4a:22b6])
 (user=bgardon job=sendgmr) by 2002:a0c:fd62:: with SMTP id
 k2mr10563221qvs.51.1617320261994; Thu, 01 Apr 2021 16:37:41 -0700 (PDT)
Date:   Thu,  1 Apr 2021 16:37:23 -0700
Message-Id: <20210401233736.638171-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 00/13] More parallel operations for the TDP MMU
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the TDP MMU is able to handle page faults in parallel, it's a
relatively small change to expand to other operations. This series allows
zapping a range of GFNs, reclaiming collapsible SPTEs (when disabling
dirty logging), and enabling dirty logging to all happen under the MMU
lock in read mode.

This is partly a cleanup + rewrite of the last few patches of the parallel
page faults series. I've incorporated feedback from Sean and Paolo, but
the patches have changed so much that I'm sending this as a separate
series.

Ran kvm-unit-tests + selftests on an SMP kernel + Intel Skylake, with the
TDP MMU enabled and disabled. This series introduces no new failures or
warnings.

I know this will conflict horribly with the patches from Sean's series
which were just queued, and I'll send a v2 to fix those conflicts +
address any feedback on this v1.

Changelog
v2:
--	Rebased patches on top of kvm/queue to incorporate Sean's recent
	TLB flushing changes
--	Dropped patch 5: "KVM: x86/mmu: comment for_each_tdp_mmu_root
	requires MMU write lock" as the following patch to protect the roots
	list with RCU adds lockdep which makes the comment somewhat redundant.

Ben Gardon (13):
  KVM: x86/mmu: Re-add const qualifier in
    kvm_tdp_mmu_zap_collapsible_sptes
  KVM: x86/mmu: Move kvm_mmu_(get|put)_root to TDP MMU
  KVM: x86/mmu: use tdp_mmu_free_sp to free roots
  KVM: x86/mmu: Merge TDP MMU put and free root
  KVM: x86/mmu: Refactor yield safe root iterator
  KVM: x86/mmu: Make TDP MMU root refcount atomic
  KVM: x86/mmu: handle cmpxchg failure in kvm_tdp_mmu_get_root
  KVM: x86/mmu: Protect the tdp_mmu_roots list with RCU
  KVM: x86/mmu: Allow zap gfn range to operate under the mmu read lock
  KVM: x86/mmu: Allow zapping collapsible SPTEs to use MMU read lock
  KVM: x86/mmu: Allow enabling / disabling dirty logging under MMU read
    lock
  KVM: x86/mmu: Fast invalidation for TDP MMU
  KVM: x86/mmu: Tear down roots in fast invalidation thread

 arch/x86/include/asm/kvm_host.h |  21 +-
 arch/x86/kvm/mmu/mmu.c          | 115 +++++++---
 arch/x86/kvm/mmu/mmu_internal.h |  27 +--
 arch/x86/kvm/mmu/tdp_mmu.c      | 375 +++++++++++++++++++++++---------
 arch/x86/kvm/mmu/tdp_mmu.h      |  28 ++-
 include/linux/kvm_host.h        |   2 +-
 6 files changed, 407 insertions(+), 161 deletions(-)

-- 
2.31.0.208.g409f899ff0-goog

