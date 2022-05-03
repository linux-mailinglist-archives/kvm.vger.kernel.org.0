Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 229AA5187DD
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 17:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237796AbiECPKc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 11:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237777AbiECPKb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 11:10:31 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0FD2019B;
        Tue,  3 May 2022 08:06:59 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id v11so5471995pff.6;
        Tue, 03 May 2022 08:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OSMLSuAh9ZaOYgp6DvdsEDlozfxSlnsFvoNeJKVnepo=;
        b=PXHQ9B2dxdQLqnlS6VrGKXnDno9p5J8Jtz5tucPJkQuECIJP+K1AW+7cXASdAe2qZy
         +OZx+5ABjQpu5eVQh0ahQGiHRyXNJPCk35ihzsV181MpgUrF1tf4x0P7UWykT92fxXFm
         2JfErHjGcg3TSNf1gz6Of+F16rmtp9b2ZI7mrGssJk92XvH/XzOi237NlBe3d7D6t5lI
         nWccAixnwX/KAvwfz/z3Em2z3JsmHGp/JdO8aPLspRiX06I3wg+K8fYXNy51axTNDCKX
         ZGkwISM78XplytiLHzIE2W9raZnFzKT9YcZCawPJ//R8z1x+0sER6v/22cCGm17fLq1h
         DO0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OSMLSuAh9ZaOYgp6DvdsEDlozfxSlnsFvoNeJKVnepo=;
        b=xwVmYL5zcVXmpN3+QiMS97LkPEBg9i6oaCpU6u+4nZx8/zrXrP6L5z986tdB2SR0Xv
         N03LNqIBOexm5PivvLWH4Vfe7lBmCk5L6/yz0GphT8rgUuuwNjPFBKxFIm2FMM6KjsL7
         c/p4IMGi4xduXpqX2tJmwDN7SWTIS9ksS2j8q4SDPzT4VkLVNFJhbMD3vVwDHGtGXTQ3
         Nkg9CiNs7x+VBXaPbfI6GBx0euUFgI3eeDGKRl7SUrS42b/vVmABkfIV1I6cBECtxmJj
         Pv6QMjEHUmhVK7ntfaT7XS2CCWpS8Lrxtu98DyGhZEkWTQFPwcAb8adH/rhFp8seZ3eF
         zKGQ==
X-Gm-Message-State: AOAM533GvVIwqLdZ9y+jFVX4L0sFCbcQzICgItzFSWjJimQq7TAJQ3he
        X6uJDiK/mu1kVYEF/ulFkF7t28/X+6o=
X-Google-Smtp-Source: ABdhPJxVjZUmBGs8NcQw1/467jjwyFLNaaByMOc3V4JAOuXeTcLJYh8FdWsMEobIftnlwKMyEdzg7Q==
X-Received: by 2002:aa7:8256:0:b0:4e0:78ad:eb81 with SMTP id e22-20020aa78256000000b004e078adeb81mr16398424pfn.30.1651590418427;
        Tue, 03 May 2022 08:06:58 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id c22-20020a62e816000000b0050dc76281e3sm6360530pfi.189.2022.05.03.08.06.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 May 2022 08:06:58 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH V2 0/7] KVM: X86/MMU: Use one-off special shadow page for special roots
Date:   Tue,  3 May 2022 23:07:28 +0800
Message-Id: <20220503150735.32723-1-jiangshanlai@gmail.com>
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

So add new special shadow pages to simplify it.

The special shadow pages are associated with struct kvm_mmu_page and
VCPU-local.

The special shadow pages are created and freed when the roots are
changed (or one-off) which can be optimized but not in the patchset
since the re-creating is light way (in normal case only the struct
kvm_mmu_page needs to be re-allocated and sp->spt doens't, because
it is likely to be mmu->pae_root)

Changed from v1:
	Rebase to newest kvm/queue. Slightly update patch4.

[V1]: https://lore.kernel.org/lkml/20220420132605.3813-1-jiangshanlai@gmail.com/

Lai Jiangshan (7):
  KVM: X86/MMU: Add using_special_root_page()
  KVM: X86/MMU: Add special shadow pages
  KVM: X86/MMU: Link PAE root pagetable with its children
  KVM: X86/MMU: Activate special shadow pages and remove old logic
  KVM: X86/MMU: Remove the check of the return value of to_shadow_page()
  KVM: X86/MMU: Allocate mmu->pae_root for PAE paging on-demand
  KVM: X86/MMU: Remove mmu_alloc_special_roots()

 arch/x86/include/asm/kvm_host.h |   3 -
 arch/x86/kvm/mmu/mmu.c          | 487 ++++++++++----------------------
 arch/x86/kvm/mmu/mmu_internal.h |  10 -
 arch/x86/kvm/mmu/paging_tmpl.h  |  14 +-
 arch/x86/kvm/mmu/spte.c         |   7 +
 arch/x86/kvm/mmu/spte.h         |   1 +
 arch/x86/kvm/mmu/tdp_mmu.h      |   7 +-
 7 files changed, 178 insertions(+), 351 deletions(-)

-- 
2.19.1.6.gb485710b

