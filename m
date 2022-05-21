Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6983E52FCBA
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 15:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353180AbiEUNQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 09:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237249AbiEUNQH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 09:16:07 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A0315702;
        Sat, 21 May 2022 06:16:05 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id a38so7044195pgl.9;
        Sat, 21 May 2022 06:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LEcoGUtASg7L12J/ZwcGjQp6K0Il0IXJCxqacljc2XE=;
        b=F/XYIRLnlSp6q9kjViACzlTmOXyNfxxBRaXBaJfrDrSJF0exs0vTnoguUQcHI44cf8
         qNsHp/wpzIM3sCtgfsc1nDLE+zhQzwgSUjDtFUYYzs1E8ghymyuhjlZ3o4GcqLUgkYpi
         2G2Ho7HnkD/XmvCY9ObRwSf7FANCntENwkSE6JkL44h+mJnvjYtPnHmWeZ3DoEcTEehZ
         ftC8jTJAy3jPvJ63WB+FOsff9puMcUXkuP5D22ZA5nE+ByJigWG6v7QoeSph8YnFEXDP
         aQtKIgBQO5fhl+JnZveSna6TOS0u/8EaWgGUgyyxG2aJmbWO0xW4byDCErvIN351pmos
         vQ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LEcoGUtASg7L12J/ZwcGjQp6K0Il0IXJCxqacljc2XE=;
        b=g3f/Nr2T5dA+0gzV/vB1NZWV3DKOhB29BRH5+oDZ1l11Q2DeYA53o6e5CDFOjyhQzc
         CFqrtm0robuNIgAeHbGisi3oLnLtz3sJbf4X6YsS/NWcD+MhLWAqi5Gj2vmHIyir8pBY
         ebo6CBrzG4KxLmK1gUQuWuBr9p6opdpC60vdc9OqFI7vxRT2TG3pVSPii+M7N4WrDKdg
         bJNDd4QJKKOikdngsFzJ9YKEhntKaMtYlBUh7Vq+Ls6BDvupoT0LyvINHQSaGS4zqYt5
         M8K62YuvADug8I8MwG/PWUVcijS5Kocn+GvNUQGXZf/elfLAV3bsE/FWC9SR0QrZiS/5
         zNTA==
X-Gm-Message-State: AOAM530YZ+hV/8vUins8w6+g2MrNObkM26M/7WXxHUcxz+Qjsn6+/yHl
        4+J5FQlv/qMUTzAEvIR/AaQ71yPZl9k=
X-Google-Smtp-Source: ABdhPJxQwtF2Y9oNu+2nqdsMxFCQx49TTaJbOD96LAv1aRM3/HZYTsZ/3h9DElZ+pEoCFth9FoENFQ==
X-Received: by 2002:a05:6a00:2187:b0:50c:ef4d:ef3b with SMTP id h7-20020a056a00218700b0050cef4def3bmr14538539pfi.83.1653138964817;
        Sat, 21 May 2022 06:16:04 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id o2-20020a170902d4c200b0016168e90f2csm1549877plg.208.2022.05.21.06.16.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 May 2022 06:16:04 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH V3 00/12] KVM: X86/MMU: Use one-off local shadow page for special roots
Date:   Sat, 21 May 2022 21:16:48 +0800
Message-Id: <20220521131700.3661-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Current code uses mmu->pae_root, mmu->pml4_root, and mmu->pml5_root to
setup special roots.  The initialization code is complex and the roots
are not associated with struct kvm_mmu_page which causes the code more
complex.

So add new local shadow pages to simplify it.

The local shadow pages are associated with struct kvm_mmu_page and
VCPU-local.

The local shadow pages are created and freed when the roots are
changed (or one-off) which can be optimized but not in the patchset
since the re-creating is light way (in normal case only the struct
kvm_mmu_page needs to be re-allocated and sp->spt doens't, because
it is likely to be mmu->pae_root)

The patchset also fixes a possible bug described in:
https://lore.kernel.org/lkml/20220415103414.86555-1-jiangshanlai@gmail.com/
as patch1.

And the fixing is simplifed in patch9 with the help of local shadow page.

Note:
using_local_root_page() can be implemented in two ways.

static bool using_local_root_page(struct kvm_mmu *mmu)
{
	return mmu->root_role.level == PT32E_ROOT_LEVEL ||
	       (!mmu->root_role.direct && mmu->cpu_role.base.level <= PT32E_ROOT_LEVEL);
}

static bool using_local_root_page(struct kvm_mmu *mmu)
{
	if (mmu->root_role.direct)
		return mmu->root_role.level == PT32E_ROOT_LEVEL;
	else
		return mmu->cpu_role.base.level <= PT32E_ROOT_LEVEL;
}

I prefer the second way.  But when I wrote the documents for them.  I
couldn't explain well enough for the second way.  Maybe I explained the
second way in a wrong aspect or my English is not qualified to explain
it.

So I put the first way in patch 2 and the second way in patch3.
Patch3 adds much more documents and changes the first way to the second
way.  Patch3 can be discarded.

Changed from v2:
	Add document for using_local_root_page()
	Update many documents
	Address review comments
	Add a patch that fix a possible bug (and split other patches for patch9)

Changed from v1:
	Rebase to newest kvm/queue. Slightly update patch4.

[V2]: https://lore.kernel.org/lkml/20220503150735.32723-1-jiangshanlai@gmail.com/
[V1]: https://lore.kernel.org/lkml/20220420132605.3813-1-jiangshanlai@gmail.com/


Lai Jiangshan (12):
  KVM: X86/MMU: Verify PDPTE for nested NPT in PAE paging mode when page
    fault
  KVM: X86/MMU: Add using_local_root_page()
  KVM: X86/MMU: Reduce a check in using_local_root_page() for common
    cases
  KVM: X86/MMU: Add local shadow pages
  KVM: X86/MMU: Link PAE root pagetable with its children
  KVM: X86/MMU: Activate local shadow pages and remove old logic
  KVM: X86/MMU: Remove the check of the return value of to_shadow_page()
  KVM: X86/MMU: Allocate mmu->pae_root for PAE paging on-demand
  KVM: X86/MMU: Move the verifying of NPT's PDPTE in FNAME(fetch)
  KVM: X86/MMU: Remove unused INVALID_PAE_ROOT and IS_VALID_PAE_ROOT
  KVM: X86/MMU: Don't use mmu->pae_root when shadowing PAE NPT in 64-bit
    host
  KVM: X86/MMU: Remove mmu_alloc_special_roots()

 arch/x86/include/asm/kvm_host.h |   5 +-
 arch/x86/kvm/mmu/mmu.c          | 575 ++++++++++++++------------------
 arch/x86/kvm/mmu/mmu_internal.h |  10 -
 arch/x86/kvm/mmu/paging_tmpl.h  |  51 ++-
 arch/x86/kvm/mmu/spte.c         |   7 +
 arch/x86/kvm/mmu/spte.h         |   1 +
 arch/x86/kvm/mmu/tdp_mmu.h      |   7 +-
 arch/x86/kvm/x86.c              |   4 +-
 8 files changed, 303 insertions(+), 357 deletions(-)

-- 
2.19.1.6.gb485710b

