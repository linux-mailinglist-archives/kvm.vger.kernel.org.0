Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC0668F045
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 15:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbjBHODA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 09:03:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbjBHOC7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 09:02:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8DD2B0BA
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 06:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675864897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9VUihSXhHG3crO6gxfgrAAyIGkZYu2m/25/NZApjVEg=;
        b=U2e50ItvVNhiH3b8ScEOae7lwx0mqVYRcTScjMtpAhvyA4jmtvOYlOiOuCI/m9ecRem2xx
        7M0qsE2I7k8IRzV/b3kWwQh6X9EQQ5UYMy5XoKPiiFhyn9wxs6hZWmhJ7MLEOeuVrY2S7+
        Y4e6LTFAFSBc0c5nYU+IecvESxlAzZQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-386-6ereSqNlMcuDiFWXGxqYbA-1; Wed, 08 Feb 2023 09:01:32 -0500
X-MC-Unique: 6ereSqNlMcuDiFWXGxqYbA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A889B1C0897B;
        Wed,  8 Feb 2023 14:01:19 +0000 (UTC)
Received: from thuth.com (unknown [10.39.193.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C2B4140EBF4;
        Wed,  8 Feb 2023 14:01:07 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Steven Price <steven.price@arm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v2 0/6] KVM: Standardize on "int" return types instead of "long"
Date:   Wed,  8 Feb 2023 15:00:59 +0100
Message-Id: <20230208140105.655814-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM functions use "long" return values for functions that are wired up
to "struct file_operations", but otherwise use "int" return values for
functions that can return 0/-errno in order to avoid unintentional
divergences between 32-bit and 64-bit kernels. Some related functions
that are not part of a "struct file_operations" still use "long", though,
which can cause confusion or even subtle problems (see the x86 and the
arm64 patches). Thus let's standardize on using "int" for return values
in these functions to avoid such problems in the future.

v2:
- Remove KVM_GET_NR_MMU_PAGES ioctl instead of trying to work-around
  the problem (the ioctl is not used in any userspace app anyway)
- Add check for INT_MAX to the arm64 patch
- Added Reviewed-bys from v1

Thomas Huth (6):
  KVM: PPC: Standardize on "int" return types in the powerpc KVM code
  KVM: s390: Use "int" as return type for kvm_s390_get/set_skeys()
  KVM: x86: Remove the KVM_GET_NR_MMU_PAGES ioctl
  KVM: arm64: Limit length in kvm_vm_ioctl_mte_copy_tags() to INT_MAX
  KVM: Standardize on "int" return types instead of "long" in kvm_main.c
  KVM: Change return type of kvm_arch_vm_ioctl() to "int"

 Documentation/virt/kvm/api.rst      |  3 ++-
 arch/arm64/include/asm/kvm_host.h   |  4 ++--
 arch/arm64/kvm/arm.c                |  3 +--
 arch/arm64/kvm/guest.c              |  8 ++++++--
 arch/mips/kvm/mips.c                |  4 ++--
 arch/powerpc/include/asm/kvm_ppc.h  | 14 +++++++-------
 arch/powerpc/kvm/book3s_64_mmu_hv.c | 14 +++++++-------
 arch/powerpc/kvm/book3s_64_vio.c    |  4 ++--
 arch/powerpc/kvm/book3s_hv.c        |  6 +++---
 arch/powerpc/kvm/book3s_pr.c        |  4 ++--
 arch/powerpc/kvm/powerpc.c          |  5 ++---
 arch/riscv/kvm/vm.c                 |  3 +--
 arch/s390/kvm/kvm-s390.c            |  7 +++----
 arch/x86/kvm/x86.c                  | 11 +----------
 include/linux/kvm_host.h            |  3 +--
 include/uapi/linux/kvm.h            |  2 +-
 tools/include/uapi/linux/kvm.h      |  2 +-
 virt/kvm/kvm_main.c                 |  4 ++--
 18 files changed, 46 insertions(+), 55 deletions(-)

-- 
2.31.1

