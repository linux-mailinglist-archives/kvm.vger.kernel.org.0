Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C6C3FFE1D
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 12:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349093AbhICKVz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 06:21:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45755 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349025AbhICKVy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 06:21:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630664454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oFjutN94K9gmEDW/+9c5bQZXpnE4pWkZ70awo3wyftQ=;
        b=GIBU81/rVzM1FePjEvbxAz4zM/wSSdK2FgeUR+QdP41UYBH/F5b4X1oYDsXk6K6wubQpDU
        foRUV319d3eEmlGUpsooQZ4pW1U0OEk7NRXPmCQvJ9QiOk0CIYDrc0b9HO85yIxTZ2tvRJ
        UXNz4kl1ebIfEtTQ5q0dzsCwtGpefQI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-Ee7czsVxPgyUsqbdtL0lSA-1; Fri, 03 Sep 2021 06:20:53 -0400
X-MC-Unique: Ee7czsVxPgyUsqbdtL0lSA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC24F501E0;
        Fri,  3 Sep 2021 10:20:51 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 088BF5D9C6;
        Fri,  3 Sep 2021 10:20:46 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [RFC PATCH 0/3] KVM: nSVM: avoid TOC/TOU race when checking vmcb12
Date:   Fri,  3 Sep 2021 12:20:36 +0200
Message-Id: <20210903102039.55422-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently there is a TOC/TOU race between the check of vmcb12's
efer, cr0 and cr4 registers and the later save of their values in
svm_set_*, because the guest could modify the values in the meanwhile.

To solve this issue, this serie introuces and uses svm->nested.save
structure in enter_svm_guest_mode to save the current value of efer,
cr0 and cr4 and later use these to set the vcpu->arch.* state.

Patch 1 just refactor the code to simplify the next two patches,
patch 2 introduces svm->nested.save to cache the efer, cr0 and cr4 fields
and in patch 3 we use it to avoid TOC/TOU races.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>

---
v1 -> RFC:
- use svm->nested.save instead of local variables.
- not dependent anymore from "KVM: nSVM: remove useless kvm_clear_*_queue"
- simplified patches, we just use the struct and not move the check
  nearer to the TOU.

Emanuele Giuseppe Esposito (3):
  KVM: nSVM: move nested_vmcb_check_cr3_cr4 logic in
    nested_vmcb_valid_sregs
  nSVM: introduce smv->nested.save to cache save area fields
  nSVM: use svm->nested.save to load vmcb12 registers and avoid TOC/TOU
    races

 arch/x86/kvm/svm/nested.c | 82 ++++++++++++++++++++-------------------
 arch/x86/kvm/svm/svm.c    |  1 +
 arch/x86/kvm/svm/svm.h    |  3 ++
 3 files changed, 47 insertions(+), 39 deletions(-)

-- 
2.27.0

