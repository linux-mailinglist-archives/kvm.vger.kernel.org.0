Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64EAA55A4CF
	for <lists+kvm@lfdr.de>; Sat, 25 Jun 2022 01:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbiFXX1k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 19:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiFXX1i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 19:27:38 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9D687D64
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 16:27:37 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 134-20020a63018c000000b0040cf04213a1so1669458pgb.6
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 16:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=bGEwwK9r6L7n5r0u6Dx3CqpLQXQpKyDLKzzGFvy5vt0=;
        b=hRmiXc9tTN/+eUZA5alTpsbp4FGvgtMAZJ9DmACX/Cmz+vdWGk7NkwDov0rb09Ntnj
         8JasqyMD0UnmFBj0nOR43A0gtVIYWKT/v2/qjHd8NNOpz8bPgJIcLswVkW7qr121FHcu
         mrsTgcxfkdfuv57II9ZKwVfM07UGhBzliy1i0db5qF6w8CSpxd5Z5BiyDqLtGnjwwCv+
         nN/z/kaSombuGitx8ODDfSSSLRz2JHGxgomOm9gbnG0+DKq4IiHpqKR1hb2L7lZQ+AR9
         yKFhbFNYuN4XEoHjQspVvllPL//RqBF4QuNuEg5j6B0dkesA/r/9j9EyXdX8NUFnir5N
         jKIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=bGEwwK9r6L7n5r0u6Dx3CqpLQXQpKyDLKzzGFvy5vt0=;
        b=irPpD/VC5aKMpEpf8web7075jwt0dbaUVmf/kqYNavk4IOWa0LCpvcAdo+EcMbwGYV
         u2AvEQywxkFGpjQ7izjCKEOsG1k0xnleAmyqxSvVprsN1GYx/3QuOCUUxiH9SE5xPqS9
         2SckzAPY1cf0urAuoD/cGJvjhkVvTnzclfjjsVXy42HtnzZs6s40eA74ZGSOI7w03zyr
         WWOGG1E3DICYh49oFtPBecBDIJCFM7a0LWBYWXGLBJiYv5SaBvh4SFoLf6TB39l2x2BW
         qEoplihgJakXYQWdFzAUbycon3fHlF41iM0i08V0wFh5avcirotBs2JFYNge8i6Y6YFy
         wPZw==
X-Gm-Message-State: AJIora+6hC9CaLTsJxUV505S0/ASb+DSZtZGRge6SF5QDZ/0oj7zqAM1
        XTZAUQEAS1IvqPZURMBt1CkxgOU0I9A=
X-Google-Smtp-Source: AGRyM1soUMSp2JRrMGymkYgHj1TJiKUDBciGq3uHyTvhFQ/4ohUJlXI395zGAoN08rEPVNjI6W8LQd4mdaM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:9206:0:b0:525:1068:c026 with SMTP id
 6-20020aa79206000000b005251068c026mr1604348pfo.52.1656113257525; Fri, 24 Jun
 2022 16:27:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 24 Jun 2022 23:27:31 +0000
Message-Id: <20220624232735.3090056-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH 0/4] KVM: x86/mmu: pte_list_desc fix and cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>
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

Reviewing the eager page splitting code made me realize that burning 14
rmap entries for nested TDP MMUs is extremely wasteful due to the per-vCPU
caches allocating 40 entries by default.  For nested TDP, aliasing L2 gfns
to L1 gfns is quite rare and is not performance critical (it's exclusively
pre-boot behavior for sane setups).

Patch 1 fixes a bug where pte_list_desc is not correctly aligned nor sized
on 32-bit kernels.  The primary motivation for the fix is to be able to add
a compile-time assertion on the size being a multiple of the cache line
size, I doubt anyone cares about the performance/memory impact.

Patch 2 tweaks MMU setup to support a dynamic pte_list_desc size.

Patch 3 reduces the number of sptes per pte_list_desc to 2 for nested TDP
MMUs, i.e. allocates the bare minimum to prioritize the memory footprint
over performance for sane setups.

Patch 4 fills the pte_list_desc cache if and only if rmaps are in use,
i.e. doesn't allocate pte_list_desc when using the TDP MMU until nested
TDP is used.

Sean Christopherson (4):
  KVM: x86/mmu: Track the number entries in a pte_list_desc with a ulong
  KVM: x86/mmu: Defer "full" MMU setup until after vendor
    hardware_setup()
  KVM: x86/mmu: Shrink pte_list_desc size when KVM is using TDP
  KVM: x86/mmu: Topup pte_list_desc cache iff VM is using rmaps

 arch/x86/include/asm/kvm_host.h |  5 ++-
 arch/x86/kvm/mmu/mmu.c          | 78 +++++++++++++++++++++++----------
 arch/x86/kvm/x86.c              | 17 ++++---
 3 files changed, 70 insertions(+), 30 deletions(-)


base-commit: 4b88b1a518b337de1252b8180519ca4c00015c9e
-- 
2.37.0.rc0.161.g10f37bed90-goog

