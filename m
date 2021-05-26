Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D9139189F
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 15:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbhEZNWI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 09:22:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27730 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232944AbhEZNWH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 09:22:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622035235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=p9p1x7BswRsuTEvRmatlOnyjD69LSl91w/XnLyyopxg=;
        b=QHOzAPnp4a81mx6JOvP+uXtbBcLXIBEvFI1dCCVAx14HzT42+YRctpURLSH0FfSCGC4iVE
        hvUJg4BByPVJrTosCN4PVMPx/ywxOqKpFXU7Q5CRQCaLpgphcjAWHtnMPRY063JQJ8SeO/
        KR4TtI3eE8Wo6UutWQyn/fuZE/q4zxw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-OaFC7kshP1qDaHOMVdhRog-1; Wed, 26 May 2021 09:20:31 -0400
X-MC-Unique: OaFC7kshP1qDaHOMVdhRog-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F7D0501EE;
        Wed, 26 May 2021 13:20:30 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10E095D9CC;
        Wed, 26 May 2021 13:20:27 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 00/11] KVM: nVMX: Fixes for nested state migration when eVMCS is in use
Date:   Wed, 26 May 2021 15:20:15 +0200
Message-Id: <20210526132026.270394-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v2:
- 'KVM: nVMX: Use '-1' in 'hv_evmcs_vmptr' to indicate that eVMCS is not in
 use'/ 'KVM: nVMX: Introduce 'EVMPTR_MAP_PENDING' post-migration state'
 patches instead of 'KVM: nVMX: Introduce nested_evmcs_is_used()' [Paolo]
- 'KVM: nVMX: Don't set 'dirty_vmcs12' flag on enlightened VMPTRLD' patch
 added [Max]
- 'KVM: nVMX: Release eVMCS when enlightened VMENTRY was disabled' patch
  added.
- 'KVM: nVMX: Make copy_vmcs12_to_enlightened()/copy_enlightened_to_vmcs12()
 return 'void'' patch added [Paolo]
- R-b tags added [Max]

Original description:

Commit f5c7e8425f18 ("KVM: nVMX: Always make an attempt to map eVMCS after
migration") fixed the most obvious reason why Hyper-V on KVM (e.g. Win10
 + WSL2) was crashing immediately after migration. It was also reported
that we have more issues to fix as, while the failure rate was lowered 
signifincatly, it was still possible to observe crashes after several
dozens of migration. Turns out, the issue arises when we manage to issue
KVM_GET_NESTED_STATE right after L2->L2 VMEXIT but before L1 gets a chance
to run. This state is tracked with 'need_vmcs12_to_shadow_sync' flag but
the flag itself is not part of saved nested state. A few other less 
significant issues are fixed along the way.

While there's no proof this series fixes all eVMCS related problems,
Win10+WSL2 was able to survive 3333 (thanks, Max!) migrations without
crashing in testing.

Patches are based on the current kvm/next tree.

Vitaly Kuznetsov (11):
  KVM: nVMX: Use '-1' in 'hv_evmcs_vmptr' to indicate that eVMCS is not
    in use
  KVM: nVMX: Don't set 'dirty_vmcs12' flag on enlightened VMPTRLD
  KVM: nVMX: Release eVMCS when enlightened VMENTRY was disabled
  KVM: nVMX: Make
    copy_vmcs12_to_enlightened()/copy_enlightened_to_vmcs12() return
    'void'
  KVM: nVMX: Introduce 'EVMPTR_MAP_PENDING' post-migration state
  KVM: nVMX: Release enlightened VMCS on VMCLEAR
  KVM: nVMX: Ignore 'hv_clean_fields' data when eVMCS data is copied in
    vmx_get_nested_state()
  KVM: nVMX: Force enlightened VMCS sync from nested_vmx_failValid()
  KVM: nVMX: Reset eVMCS clean fields data from prepare_vmcs02()
  KVM: nVMX: Request to sync eVMCS from VMCS12 after migration
  KVM: selftests: evmcs_test: Test that KVM_STATE_NESTED_EVMCS is never
    lost

 arch/x86/kvm/vmx/evmcs.c                      |   3 +
 arch/x86/kvm/vmx/evmcs.h                      |   8 +
 arch/x86/kvm/vmx/nested.c                     | 144 +++++++++++-------
 arch/x86/kvm/vmx/nested.h                     |  11 +-
 arch/x86/kvm/vmx/vmx.c                        |   1 +
 .../testing/selftests/kvm/x86_64/evmcs_test.c |  64 ++++----
 6 files changed, 140 insertions(+), 91 deletions(-)

-- 
2.31.1

