Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE31B4440D2
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 12:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbhKCL4L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 07:56:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51329 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231869AbhKCL4I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 07:56:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635940412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=L/P3UrVYThs6BCBvUjnusHuZyMwrK4mhs8KvOceIMpY=;
        b=NSSXeDo7dqBE8YlnNy9ygtJmBYUoTQnnOi9uz/p3147z9ldIou64eRvuT22Woz+R8rQgSH
        dKFrxSCYE8nUPu7IiwT6+8+oToKStwQn5Y9TFnKVrNXdI5VkQKxBB0wfJoQAWyLO/eUYBd
        SxlQDkSAxZ2eQLFC1VK3ye9Zn9I6DZI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-duE2122INUOu_nTgl2chhw-1; Wed, 03 Nov 2021 07:53:29 -0400
X-MC-Unique: duE2122INUOu_nTgl2chhw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00D1F8066EF;
        Wed,  3 Nov 2021 11:53:26 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4148A19741;
        Wed,  3 Nov 2021 11:53:15 +0000 (UTC)
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
Subject: [PATCH v4 0/7] KVM: nSVM: avoid TOC/TOU race when checking vmcb12
Date:   Wed,  3 Nov 2021 07:52:23 -0400
Message-Id: <20211103115230.720154-1-eesposit@redhat.com>
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
v4:
* introduce _* helpers (_nested_vmcb_check_save,
  _nested_copy_vmcb_control_to_cache, _nested_copy_vmcb_save_to_cache)
  that take care of additional parameters.
* svm_set_nested_state: introduce {save, ctl}_cached variables
  to not pollute svm->nested.{save,ctl} state, especially if the
  check fails. remove also unnecessary memset added in previous versions.
* svm_get_nested_state: change stack variable ctl introduced in this series
 into a pointer that will be zeroed and freed after it has been copied to user

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

Emanuele Giuseppe Esposito (7):
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

 arch/x86/kvm/svm/nested.c | 250 ++++++++++++++++++++++++--------------
 arch/x86/kvm/svm/svm.c    |   7 +-
 arch/x86/kvm/svm/svm.h    |  57 ++++++++-
 3 files changed, 212 insertions(+), 102 deletions(-)

-- 
2.27.0

