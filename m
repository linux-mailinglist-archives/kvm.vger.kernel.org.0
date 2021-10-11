Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46EB429208
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 16:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240366AbhJKOjN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 10:39:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31388 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239917AbhJKOjM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Oct 2021 10:39:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633963031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ee9wJ57bxmWsc4scf9sZAWrwuLxZ6TkutMxSqOnUB5M=;
        b=So4mGKwvwyCWVtXaZE0yQfUG5WC7pNSPS2XI4Js+ysp6wGru1m4UIUdMmHzp1N7HXIVqhe
        sVoK50ccHNguwQWPqfiCXeooZsdSPMpHzc8A2XlPFeauxaCWH5oCXmooY+4KVlbRKKCOk6
        g+SkP5rsBN4G9yGWqN2QoPHgHbUuhYE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-5tbKOs-lNv2HFe_DcF2vow-1; Mon, 11 Oct 2021 10:37:08 -0400
X-MC-Unique: 5tbKOs-lNv2HFe_DcF2vow-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4CE9100D681;
        Mon, 11 Oct 2021 14:37:06 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7501F19D9B;
        Mon, 11 Oct 2021 14:37:04 +0000 (UTC)
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
Subject: [PATCH v3 0/8] KVM: nSVM: avoid TOC/TOU race when checking vmcb12
Date:   Mon, 11 Oct 2021 10:36:54 -0400
Message-Id: <20211011143702.1786568-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently there is a TOC/TOU race between the check of vmcb12's
efer, cr0 and cr4 registers and the later save of their values in
svm_set_*, because the guest could modify the values in the meanwhile.

To solve this issue, this series introduces and uses svm->nested.save
structure in enter_svm_guest_mode to save the current value of efer,
cr0 and cr4 and later use these to set the vcpu->arch.* state.

Similarly, svm->nested.ctl contains fields that are not used, so having
a full vmcb_control_area means passing uninitialized fields.

Patches 1,3 and 8 take care of renaming and refactoring code.
Patches 2 and 6 introduce respectively vmcb_ctrl_area_cached and
vmcb_save_area_cached.
Patches 4 and 5 use vmcb_save_area_cached to avoid TOC/TOU, and patch
7 uses vmcb_ctrl_area_cached.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>

---
v3:
* merge this series with "KVM: nSVM: use vmcb_ctrl_area_cached instead
  of vmcb_control_area in nested state"
* rename "nested_load_save_from_vmcb12" in
  "nested_copy_vmcb_save_to_cache"
* rename "nested_load_control_from_vmcb12" in
  "nested_copy_vmcb_control_to_cache"
* change check functions (nested_vmcb_valid_sregs and nested_vmcb_valid_sregs)
  to accept only the vcpu parameter, since we only check
  nested state now
* rename "vmcb_is_intercept_cached" in "vmcb12_is_intercept"
  and duplicate the implementation instead of calling vmcb_is_intercept

v2:
* svm->nested.save is a separate struct vmcb_save_area_cached,
  and not vmcb_save_area.
* update also vmcb02->cr3 with svm->nested.save.cr3

RFC:
* use svm->nested.save instead of local variables.
* not dependent anymore from "KVM: nSVM: remove useless kvm_clear_*_queue"
* simplified patches, we just use the struct and not move the check
  nearer to the TOU.

Emanuele Giuseppe Esposito (8):
  KVM: nSVM: move nested_vmcb_check_cr3_cr4 logic in
    nested_vmcb_valid_sregs
  nSVM: introduce smv->nested.save to cache save area fields
  nSVM: rename nested_load_control_from_vmcb12 in
    nested_copy_vmcb_control_to_cache
  nSVM: use vmcb_save_area_cached in nested_vmcb_valid_sregs()
  nSVM: use svm->nested.save to load vmcb12 registers and avoid TOC/TOU
    races
  nSVM: introduce struct vmcb_ctrl_area_cached
  nSVM: use vmcb_ctrl_area_cached instead of vmcb_control_area in struct
    svm_nested_state
  nSVM: remove unnecessary parameter in nested_vmcb_check_controls

 arch/x86/kvm/svm/nested.c | 235 ++++++++++++++++++++++----------------
 arch/x86/kvm/svm/svm.c    |   7 +-
 arch/x86/kvm/svm/svm.h    |  57 ++++++++-
 3 files changed, 192 insertions(+), 107 deletions(-)

-- 
2.27.0

