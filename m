Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D55382DEA
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 15:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237549AbhEQNwR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 09:52:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59811 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233139AbhEQNwR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 09:52:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621259460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=C+tg4c3vND5Z6+PsNiPP16d8jOHSNadBgt74LgH79DM=;
        b=EYDrNMP92yCUa6d3wixDYUGfjhqrJsktX7HJob+vAMJPguJZFXrEQ+RNkfkaaL1vdw1r4i
        1QQtOrdibo7XXNXHiGcQi2ja0zKEiYakBmc+OH0lHJpEzLzqQbskYarDCA5XDUDN4m54iy
        mBnCt2cGez/sBBFxhXUVsniwl4usQ1Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-6QNT2PQ7MiqH4mdwbB0tGg-1; Mon, 17 May 2021 09:50:59 -0400
X-MC-Unique: 6QNT2PQ7MiqH4mdwbB0tGg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC973801106;
        Mon, 17 May 2021 13:50:57 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C08985C1A1;
        Mon, 17 May 2021 13:50:55 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/7] KVM: nVMX: Fixes for nested state migration when eVMCS is in use
Date:   Mon, 17 May 2021 15:50:47 +0200
Message-Id: <20210517135054.1914802-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v1 (Sean):
- Drop now-unneeded curly braces in nested_sync_vmcs12_to_shadow().
- Pass 'evmcs->hv_clean_fields' instead of 'bool from_vmentry' to
  copy_enlightened_to_vmcs12().

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

Vitaly Kuznetsov (7):
  KVM: nVMX: Introduce nested_evmcs_is_used()
  KVM: nVMX: Release enlightened VMCS on VMCLEAR
  KVM: nVMX: Ignore 'hv_clean_fields' data when eVMCS data is copied in
    vmx_get_nested_state()
  KVM: nVMX: Force enlightened VMCS sync from nested_vmx_failValid()
  KVM: nVMX: Reset eVMCS clean fields data from prepare_vmcs02()
  KVM: nVMX: Request to sync eVMCS from VMCS12 after migration
  KVM: selftests: evmcs_test: Test that KVM_STATE_NESTED_EVMCS is never
    lost

 arch/x86/kvm/vmx/nested.c                     | 110 ++++++++++++------
 .../testing/selftests/kvm/x86_64/evmcs_test.c |  64 +++++-----
 2 files changed, 115 insertions(+), 59 deletions(-)

-- 
2.31.1

