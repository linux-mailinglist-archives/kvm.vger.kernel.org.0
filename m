Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A33940F708
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 14:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243998AbhIQMFC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 08:05:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35507 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235036AbhIQME7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Sep 2021 08:04:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631880217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=i2+E4iw4IwPmea7ZaJQqlz/wwifxDZQ9dTKq7+3EUpE=;
        b=bfWUwUG79VqymhPVsawn1pgPdZ+smMqlMT6R86TkXC2hTX97fpusCAKYeyi6mKLP1ruUnv
        bAAdRnXoYGWB+c20YpxEoTgprCh17KPQIS0/diI8THpmMO7snse3MggN/NBnpkY+rUIoJZ
        2IxxPeDar8FRI9+u+weK8MtOlfu6qAA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-EfX0AjqQPse9pyRJtacd_g-1; Fri, 17 Sep 2021 08:03:35 -0400
X-MC-Unique: EfX0AjqQPse9pyRJtacd_g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6D6EDF8A0;
        Fri, 17 Sep 2021 12:03:33 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18FEF100164A;
        Fri, 17 Sep 2021 12:03:32 +0000 (UTC)
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
Subject: [PATCH v2 0/4]  KVM: nSVM: avoid TOC/TOU race when checking vmcb12
Date:   Fri, 17 Sep 2021 08:03:25 -0400
Message-Id: <20210917120329.2013766-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
and in patch 3 and 4 we use it to avoid TOC/TOU races.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>

---
RFC:
* use svm->nested.save instead of local variables.
* not dependent anymore from "KVM: nSVM: remove useless kvm_clear_*_queue"
* simplified patches, we just use the struct and not move the check
  nearer to the TOU.

v2:
* svm->nested.save is a separate struct vmcb_save_area_cached,
  and not vmcb_save_area.
* update also vmcb02->cr3 with svm->nested.save.cr3 

Emanuele Giuseppe Esposito (4):
  KVM: nSVM: move nested_vmcb_check_cr3_cr4 logic in
    nested_vmcb_valid_sregs
  nSVM: introduce smv->nested.save to cache save area fields
  nSVM: use vmcb_save_area_cached in nested_vmcb_valid_sregs()
  nSVM: use svm->nested.save to load vmcb12 registers and avoid TOC/TOU
    races

 arch/x86/kvm/svm/nested.c | 95 +++++++++++++++++++++------------------
 arch/x86/kvm/svm/svm.c    |  1 +
 arch/x86/kvm/svm/svm.h    | 12 +++++
 3 files changed, 64 insertions(+), 44 deletions(-)

-- 
2.27.0

