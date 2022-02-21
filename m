Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A46D4BE0AA
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380218AbiBUQXR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 11:23:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380191AbiBUQXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 11:23:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E666E27154
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 08:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645460568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TTbfjz2iff8ZLMo4yQHOTt0V56zvOG1AVXw8qi9cYUA=;
        b=A9BjB0c/HHHB0MbXdN8ke+u97A11/p1RDDem1WVBpvv3WVHRF+C+2DgDqQAATSmGrJqBor
        zlYBCn5FVR8iMjEvLc2IxciPQCpKqoPjbHDU98vGD+GzmgSJNoz/5XkUxOh1HQZUcg7KrE
        K/aTx+wQZCCrhjYbW5feNBn46pZ9d34=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-V-PuRMCpM7apgjDa6ZhrJw-1; Mon, 21 Feb 2022 11:22:45 -0500
X-MC-Unique: V-PuRMCpM7apgjDa6ZhrJw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EEA981926DA0;
        Mon, 21 Feb 2022 16:22:43 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A29277474;
        Mon, 21 Feb 2022 16:22:43 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v2 00/25] KVM MMU refactoring part 2: role changes
Date:   Mon, 21 Feb 2022 11:22:18 -0500
Message-Id: <20220221162243.683208-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the MMU root role vs. CPU mode split.  While not a requirement
in absolute terms for further hacking, it makes it much clearer to reason
on whether the previous root is still valid.

Paolo

Paolo Bonzini (25):
  KVM: x86/mmu: avoid indirect call for get_cr3
  KVM: x86/mmu: nested EPT cannot be used in SMM
  KVM: x86/mmu: constify uses of struct kvm_mmu_role_regs
  KVM: x86/mmu: pull computation of kvm_mmu_role_regs to kvm_init_mmu
  KVM: x86/mmu: rephrase unclear comment
  KVM: nVMX/nSVM: do not monkey-patch inject_page_fault callback
  KVM: x86/mmu: remove "bool base_only" arguments
  KVM: x86/mmu: split cpu_mode from mmu_role
  KVM: x86/mmu: do not recompute root level from kvm_mmu_role_regs
  KVM: x86/mmu: remove ept_ad field
  KVM: x86/mmu: remove kvm_calc_shadow_root_page_role_common
  KVM: x86/mmu: cleanup computation of MMU roles for two-dimensional
    paging
  KVM: x86/mmu: cleanup computation of MMU roles for shadow paging
  KVM: x86/mmu: store shadow EFER.NX in the MMU role
  KVM: x86/mmu: remove extended bits from mmu_role, rename field
  KVM: x86/mmu: rename kvm_mmu_role union
  KVM: x86/mmu: remove redundant bits from extended role
  KVM: x86/mmu: remove valid from extended role
  KVM: x86/mmu: simplify and/or inline computation of shadow MMU roles
  KVM: x86/mmu: pull CPU mode computation to kvm_init_mmu
  KVM: x86/mmu: replace shadow_root_level with root_role.level
  KVM: x86/mmu: replace root_level with cpu_mode.base.level
  KVM: x86/mmu: replace direct_map with root_role.direct
  KVM: x86/mmu: initialize constant-value fields just once
  KVM: x86/mmu: extract initialization of the page walking data

 arch/x86/include/asm/kvm_host.h |  25 +-
 arch/x86/kvm/mmu.h              |  12 +-
 arch/x86/kvm/mmu/mmu.c          | 479 +++++++++++++-------------------
 arch/x86/kvm/mmu/paging_tmpl.h  |  16 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |   4 +-
 arch/x86/kvm/svm/nested.c       |  13 +-
 arch/x86/kvm/svm/svm.c          |   2 +-
 arch/x86/kvm/vmx/nested.c       |   9 +-
 arch/x86/kvm/vmx/vmx.c          |   2 +-
 arch/x86/kvm/x86.c              |  31 ++-
 10 files changed, 260 insertions(+), 333 deletions(-)

-- 
2.31.1

