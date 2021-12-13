Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326BD472B43
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 12:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235483AbhLMLZW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 06:25:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28449 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234882AbhLMLZV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Dec 2021 06:25:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639394720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TfuZb98OrcjjdgIH1J2QFI1jNJ7RnHQCrRzvX/D3t1E=;
        b=RYpEF3bwpBmRl7igL5GASRwnsrZjlKzTDuHpcTKD87WPU9H5fpTqyUq4pgWPPn6pfdpmHQ
        NvT9ENGDHsJ1nl2cxNAGMIqAFdg67jN72zPv8oDIE58BhtRBnkwFz/viCTOjkhoHE+jaIN
        I+O2I1NKf/Oggy5iHDYgITULey+CqQQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-496-nNgJEFlnPUGLI-KZ4B-Zmg-1; Mon, 13 Dec 2021 06:25:17 -0500
X-MC-Unique: nNgJEFlnPUGLI-KZ4B-Zmg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB81E612ED;
        Mon, 13 Dec 2021 11:25:15 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E89A5ED2A;
        Mon, 13 Dec 2021 11:25:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, ignat@cloudflare.com, bgardon@google.com,
        dmatlack@google.com, stevensd@chromium.org,
        kernel-team@cloudflare.com
Subject: [PATCH 0/2] KVM: x86: Fix dangling page reference in TDP MMU
Date:   Mon, 13 Dec 2021 06:25:12 -0500
Message-Id: <20211213112514.78552-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_tdp_mmu_zap_all is intended to visit all roots and zap their page
tables, which flushes the accessed and dirty bits out to the Linux
"struct page"s.  Missing some of the roots has catastrophic effects,
because kvm_tdp_mmu_zap_all is called when the MMU notifier is being
removed and any PTEs left behind might become dangling by the time
kvm-arch_destroy_vm tears down the roots for good.

Unfortunately that is exactly what kvm_tdp_mmu_zap_all is doing: it
visits all roots via for_each_tdp_mmu_root_yield_safe, which in turn
uses kvm_tdp_mmu_get_root to skip invalid roots.  If the current root is
invalid at the time of kvm_tdp_mmu_zap_all, its page tables will remain
in place but will later be zapped during kvm_arch_destroy_vm.

To fix this, ensure that kvm_tdp_mmu_zap_all goes over all
roots, including the invalid ones.  The easiest way to do so is for
kvm_tdp_mmu_zap_all to do the same as kvm_mmu_zap_all_fast: invalidate
all roots, and then zap the invalid roots.  The only difference is that
there is no need to go through tdp_mmu_zap_spte_atomic.

Paolo

Paolo Bonzini (2):
  KVM: x86: allow kvm_tdp_mmu_zap_invalidated_roots with write-locked
    mmu_lock
  KVM: x86: zap invalid roots in kvm_tdp_mmu_zap_all

 arch/x86/kvm/mmu/mmu.c     |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c | 42 ++++++++++++++++++++------------------
 arch/x86/kvm/mmu/tdp_mmu.h |  2 +-
 3 files changed, 24 insertions(+), 22 deletions(-)

-- 
2.31.1

