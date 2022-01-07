Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798CF48757E
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 11:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346708AbiAGK3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 05:29:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:20656 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346679AbiAGK3L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 05:29:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641551350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QTfhdM1+a4CO4gpe38Ku+HajXRy5qhCcL1cLDMAP9Ew=;
        b=BvLJ2TnG5PL02BtuKuKc7PTbf9N53kurMU+Ul9+4eDUFdRfxaUc00ekCI/cahWQwYvGXYL
        f3Bhj68d0hZDfbysZghrFH7I/ygYlmFr3c5tN7Th8fuvqLSzRJhDJyLqur8uXI603dmCev
        o58MUGfkDuGTdZsTzdbDULnALBdyYDw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-175-1xTA2HabO2C9jkS2SIXtAA-1; Fri, 07 Jan 2022 05:29:07 -0500
X-MC-Unique: 1xTA2HabO2C9jkS2SIXtAA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CCD92185302E;
        Fri,  7 Jan 2022 10:29:05 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1075672FA7;
        Fri,  7 Jan 2022 10:29:00 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] KVM: nVMX: Fix Windows 11 + WSL2 + Enlightened VMCS
Date:   Fri,  7 Jan 2022 11:28:54 +0100
Message-Id: <20220107102859.1471362-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v1 [Sean]:
- Rename vmcs12_field_offset_table -> vmcs12_field_offsets, 
 vmcs12_field_offset()->get_vmcs12_field_offset()
- Forbid VMREAD when "current_vmptr == INVALID_GPA && evmptr_is_valid() &&
  is_guest_mode()".

Original description:

Windows 11 with enabled Hyper-V role doesn't boot on KVM when Enlightened
VMCS interface is provided to it. The observed behavior doesn't conform to
Hyper-V TLFS. In particular, I'm observing 'VMREAD' instructions trying to
access field 0x4404 ("VM-exit interruption information"). TLFS, however, is
very clear this should not be happening:

"Any VMREAD or VMWRITE instructions while an enlightened VMCS is active is
unsupported and can result in unexpected behavior."

Microsoft confirms this is a bug in Hyper-V which is supposed to get fixed
eventually. For the time being, implement a workaround in KVM allowing 
VMREAD instructions to read from the currently loaded Enlightened VMCS.

Patches 1-2 are unrelated fixes to VMX feature MSR filtering when eVMCS is
enabled. Patches 3 and 4 are preparatory changes, patch 5 implements the
workaround.

Vitaly Kuznetsov (5):
  KVM: nVMX: Also filter MSR_IA32_VMX_TRUE_PINBASED_CTLS when eVMCS
  KVM: nVMX: eVMCS: Filter out VM_EXIT_SAVE_VMX_PREEMPTION_TIMER
  KVM: nVMX: Rename vmcs_to_field_offset{,_table}
  KVM: nVMX: Implement evmcs_field_offset() suitable for handle_vmread()
  KVM: nVMX: Allow VMREAD when Enlightened VMCS is in use

 arch/x86/kvm/vmx/evmcs.c  |  4 +--
 arch/x86/kvm/vmx/evmcs.h  | 48 +++++++++++++++++++++++++------
 arch/x86/kvm/vmx/nested.c | 59 +++++++++++++++++++++++++++------------
 arch/x86/kvm/vmx/vmcs12.c |  4 +--
 arch/x86/kvm/vmx/vmcs12.h |  6 ++--
 5 files changed, 87 insertions(+), 34 deletions(-)

-- 
2.33.1

