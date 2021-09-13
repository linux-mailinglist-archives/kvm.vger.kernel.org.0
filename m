Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9B84092A7
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 16:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244992AbhIMONV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 10:13:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39758 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344350AbhIMOLT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Sep 2021 10:11:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631542203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=4Egw9OHG2GpnYX4LsAOvKgPFes7KymhOEWBKcvrU0jg=;
        b=WvBo/nPQe/3GUtp2pIOH8yChwfRODCijKynxAZRQFXPKinL6xdQbznHYsW5NEI3rswvytI
        SK83XwWth7kEAi6obdetMY4zdfRtmEC6SeJgsR/I8ZiRhnFSR2iFnNzKtKxbnEEjumbASg
        56+XbqL0dvbN/DnzhIc01YKxkliH/sI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-BBGu1yWcM3-bqMzZlidmCA-1; Mon, 13 Sep 2021 10:10:02 -0400
X-MC-Unique: BBGu1yWcM3-bqMzZlidmCA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19FDF1084685;
        Mon, 13 Sep 2021 14:10:00 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6214A196E2;
        Mon, 13 Sep 2021 14:09:55 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v3 0/7] KVM: few more SMM fixes
Date:   Mon, 13 Sep 2021 17:09:47 +0300
Message-Id: <20210913140954.165665-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These are few SMM fixes I was working on last week.=0D
=0D
* Patch 1,2 fixes a minor issue that remained after=0D
  commit 37be407b2ce8 ("KVM: nSVM: Fix L1 state corruption upon return from=
 SMM")=0D
=0D
  While now, returns to guest mode from SMM work due to restored state from=
 HSAVE=0D
  area, the guest entry still sees incorrect HSAVE state.=0D
=0D
  This for example breaks return from SMM when the guest is 32 bit, due to =
PDPTRs=0D
  loading which are done using incorrect MMU state which is incorrect,=0D
  because it was setup with incorrect L1 HSAVE state.=0D
=0D
  V3: updated with review feedback from Sean.=0D
=0D
* Patch 3 fixes a theoretical issue that I introduced with my SREGS2 patchs=
et,=0D
  which Sean Christopherson pointed out.=0D
=0D
  The issue is that KVM_REQ_GET_NESTED_STATE_PAGES request is not only used=
=0D
  for completing the load of the nested state, but it is also used to compl=
ete=0D
  exit from SMM to guest mode, and my compatibility hack of pdptrs_from_use=
rspace=0D
  was done assuming that this is not done.=0D
=0D
  V3: I moved the reset of pdptrs_from_userspace to common x86 code.=0D
=0D
* Patch 4 makes SVM SMM exit to be a bit more similar to how VMX does it=0D
  by also raising KVM_REQ_GET_NESTED_STATE_PAGES requests.=0D
=0D
  I do have doubts about why we need to do this on VMX though. The initial=
=0D
  justification for this comes from=0D
=0D
  7f7f1ba33cf2 ("KVM: x86: do not load vmcs12 pages while still in SMM")=0D
=0D
  With all the MMU changes, I am not sure that we can still have a case=0D
  of not up to date MMU when we enter the nested guest from SMM.=0D
  On SVM it does seem to work anyway without this.=0D
=0D
* Patch 5 fixes guest emulation failure when unrestricted_guest=3D0 and we =
reach=0D
  handle_exception_nmi_irqoff.=0D
  That function takes stale values from current vmcs and fails not taking i=
nto account=0D
  the fact that we are emulating invalid guest state now, and thus no VM ex=
it happened.=0D
=0D
* Patch 6 fixed a corner case where return from SMM is slightly corrupting=
=0D
  the L2 segment register state when unrestricted_guest=3D0 due to real mod=
e segement=0D
  caching register logic, but later it restores it correctly from SMMRAM.=0D
  Fix this by not failing nested_vmx_enter_non_root_mode and delaying this=
=0D
  failure to the next nested VM entry.=0D
=0D
* Patch 7 fixes another corner case where emulation_required was not update=
d=0D
  correctly on nested VMexit when restoring the L1 segement registers.=0D
=0D
I still track 2 SMM issues:=0D
=0D
1. When HyperV guest is running nested, and uses SMM enabled OVMF, it crash=
es and=0D
   reboots during the boot process.=0D
=0D
2. Nested migration on VMX is still broken when L1 floods itself with SMIs.=
=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (7):=0D
  KVM: x86: nSVM: refactor svm_leave_smm and smm_enter_smm=0D
  KVM: x86: nSVM: restore the L1 host state prior to resuming nested=0D
    guest on SMM exit=0D
  KVM: x86: reset pdptrs_from_userspace when exiting smm=0D
  KVM: x86: SVM: call KVM_REQ_GET_NESTED_STATE_PAGES on exit from SMM=0D
    mode=0D
  KVM: x86: VMX: synthesize invalid VM exit when emulating invalid guest=0D
    state=0D
  KVM: x86: nVMX: don't fail nested VM entry on invalid guest state if=0D
    !from_vmentry=0D
  KVM: x86: nVMX: re-evaluate emulation_required on nested VM exit=0D
=0D
 arch/x86/kvm/svm/nested.c |   9 ++-=0D
 arch/x86/kvm/svm/svm.c    | 131 ++++++++++++++++++++------------------=0D
 arch/x86/kvm/svm/svm.h    |   3 +-=0D
 arch/x86/kvm/vmx/nested.c |   9 ++-=0D
 arch/x86/kvm/vmx/vmx.c    |  28 ++++++--=0D
 arch/x86/kvm/vmx/vmx.h    |   1 +=0D
 arch/x86/kvm/x86.c        |   7 ++=0D
 7 files changed, 113 insertions(+), 75 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

