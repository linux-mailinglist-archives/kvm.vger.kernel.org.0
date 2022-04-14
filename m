Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA8350076D
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 09:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240632AbiDNHoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 03:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240493AbiDNHmd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 03:42:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E5CBA56C3E
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 00:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649922007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=iHNjoj54lYwN18Dz7c9T9KYDom8xn4aUbJSlnwLzc/c=;
        b=ASYhx8XdjVW+bbevPlYf2IpkGD6VOM/pNsFN+ccO7jV0IZygkTKg4ltr+Q8JgK4OceSZ9Q
        4vgDE9aHFroQYn9efHbhwQlCAl9QNz2oW2WCfTZv6lwWhqVKpHl+DpQt/JZdnURSDIQn3h
        oKIWpkF0OA5ytCtiuj/6EimKn1CWXlg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-bm3CvvOKN8aClSqfucMTcw-1; Thu, 14 Apr 2022 03:40:01 -0400
X-MC-Unique: bm3CvvOKN8aClSqfucMTcw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B176296A61D;
        Thu, 14 Apr 2022 07:40:01 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A25340D1DB;
        Thu, 14 Apr 2022 07:40:01 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH v3 00/22] https://www.spinics.net/lists/kvm/msg267878.html
Date:   Thu, 14 Apr 2022 03:39:38 -0400
Message-Id: <20220414074000.31438-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Right now the "MMU role" is a messy mix of the shadow page table format
and the CPU paging mode (CR0/CR4/EFER, SMM, guest mode, etc).  Whenever
something is different between the MMU and the CPU, it is stored as an
extra field in struct kvm_mmu; for extra bonus complication, sometimes
the same thing is stored in both the role and an extra field.

This series cleans up things by putting the two in separate fields,
so that the "MMU role" represents exactly the role of the root page.
This in turn makes it possible to eliminate various fields that are
now redundant with either the CPU or te MMU role.

These patches have mostly been posted and reviewed already[1], and I
have now retested them on top of kvm/next.

Paolo

[1] https://patchew.org/linux/20220221162243.683208-1-pbonzini@redhat.com/

Paolo Bonzini (21):
  KVM: x86/mmu: nested EPT cannot be used in SMM
  KVM: x86/mmu: constify uses of struct kvm_mmu_role_regs
  KVM: x86/mmu: pull computation of kvm_mmu_role_regs to kvm_init_mmu
  KVM: x86/mmu: rephrase unclear comment
  KVM: x86/mmu: remove "bool base_only" arguments
  KVM: x86/mmu: split cpu_role from mmu_role
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
  KVM: x86/mmu: replace root_level with cpu_role.base.level
  KVM: x86/mmu: replace direct_map with root_role.direct

Sean Christopherson (1):
  KVM: x86: Clean up and document nested #PF workaround

 arch/x86/include/asm/kvm_host.h |  19 +-
 arch/x86/kvm/mmu.h              |   2 +-
 arch/x86/kvm/mmu/mmu.c          | 376 ++++++++++++++------------------
 arch/x86/kvm/mmu/paging_tmpl.h  |  14 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |   4 +-
 arch/x86/kvm/svm/nested.c       |  18 +-
 arch/x86/kvm/svm/svm.c          |   2 +-
 arch/x86/kvm/vmx/nested.c       |  15 +-
 arch/x86/kvm/vmx/vmx.c          |   2 +-
 arch/x86/kvm/x86.c              |  33 ++-
 10 files changed, 219 insertions(+), 266 deletions(-)

-- 
2.31.1

