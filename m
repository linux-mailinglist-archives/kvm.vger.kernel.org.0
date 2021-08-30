Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981943FB687
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 14:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236743AbhH3M4n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 08:56:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33772 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236671AbhH3M4m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Aug 2021 08:56:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630328148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=O/adh2CL/0uFAWeanQAJZ3tgc0mK1zIK8d1KVfT8pDc=;
        b=Hl99BTgZD07t507OJC4nEmL3Xls5RHpGzJq6aUKWGWJEc0Aafph8hfMDkq6FrWMHuAivEX
        j5mAGzavrcPPA49IAnvFaupfPPA05gxr1WNZaC9A9wd5UdGBNDFo8qs/ai0PAWexO3XIkd
        3dyQ7DjsMmVdj8nyI9vRU3bofkNwvBM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-TFiFWKQXMnSOE5BdrS_Mug-1; Mon, 30 Aug 2021 08:55:47 -0400
X-MC-Unique: TFiFWKQXMnSOE5BdrS_Mug-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 699E68042E0;
        Mon, 30 Aug 2021 12:55:44 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC53860854;
        Mon, 30 Aug 2021 12:55:40 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH v2 0/6] KVM: few more SMM fixes
Date:   Mon, 30 Aug 2021 15:55:33 +0300
Message-Id: <20210830125539.1768833-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These are few SMM fixes I was working on last week.=0D
=0D
(V2: I merged here VMX's SMM fixes, while SVM SMM fixes are unchanged from =
V1)=0D
=0D
* Patch 1 fixes a minor issue that remained after=0D
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
* Patch 2 fixes a theoretical issue that I introduced with my SREGS2 patchs=
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
  While it is safe to just reset 'pdptrs_from_userspace' on each VM entry,=
=0D
  I don't want to slow down the common code for this very rare hack.=0D
  Instead I explicitly zero this variable when SMM exit to guest mode is do=
ne,=0D
  because in this case PDPTRs do need to be reloaded from memory always.=0D
=0D
  Note that this is a theoretical issue only, because after 'vendor' return=
 from=0D
  smm code (aka .leave_smm) is done, even when it returned to the guest mod=
e,=0D
  which loads some of L2 CPU state, we still load again all of the L2 cpu s=
tate=0D
  captured in SMRAM which includes CR3, at which point guest PDPTRs are re-=
loaded=0D
  anyway.=0D
=0D
  Also note that across SMI entries the CR3 seems not to be updated, and In=
tel's=0D
  SDM notes that it saved value in SMRAM isn't writable, thus it is possibl=
e=0D
  that if SMM handler didn't change CR3, the pdptrs would not be touched.=0D
=0D
  I guess that means that a SMI handler can in theory preserve PDPTRs by ne=
ver=0D
  touching CR3, but since recently we removed that code that didn't update =
PDPTRs=0D
  if CR3 didn't change, I guess it won't work.=0D
=0D
  Anyway I don't think any OS bothers to have PDPTRs not synced with whatev=
er=0D
  page CR3 points at, thus I didn't bother to try and test what the real ha=
rdware=0D
  does in this case.=0D
=0D
* 3rd patch makes SVM SMM exit to be a bit more similar to how VMX does it=
=0D
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
* Patch 3 fixes guest emulation failure when unrestricted_guest=3D0 and we =
reach=0D
  handle_exception_nmi_irqoff.=0D
  That function takes stale values from current vmcs and fails not taking i=
nto account=0D
  the fact that we are emulating invalid guest state now, and thus no VM ex=
it happened.=0D
=0D
* Patch 4 fixed a corner case where return from SMM is slightly corrupting=
=0D
  the L2 segment register state when unrestricted_guest=3D0 due to real mod=
e segement=0D
  caching register logic, but later it restores it correctly from SMMRAM.=0D
  Fix this by not failing nested_vmx_enter_non_root_mode and delaying this=
=0D
  failure to the next nested VM entry.=0D
=0D
* Patch 5 fixes another corner case where emulation_required was not update=
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
Maxim Levitsky (6):=0D
  KVM: SVM: restore the L1 host state prior to resuming nested guest on=0D
    SMM exit=0D
  KVM: x86: force PDPTR reload on SMM exit=0D
  KVM: nSVM: call KVM_REQ_GET_NESTED_STATE_PAGES on exit from SMM mode=0D
  KVM: VMX: synthesize invalid VM exit when emulating invalid guest=0D
    state=0D
  KVM: nVMX: don't fail nested VM entry on invalid guest state if=0D
    !from_vmentry=0D
  KVM: nVMX: re-evaluate emulation_required on nested VM exit=0D
=0D
 arch/x86/kvm/svm/nested.c | 10 +++++++---=0D
 arch/x86/kvm/svm/svm.c    | 27 ++++++++++++++++++---------=0D
 arch/x86/kvm/svm/svm.h    |  3 ++-=0D
 arch/x86/kvm/vmx/nested.c |  9 ++++++++-=0D
 arch/x86/kvm/vmx/vmx.c    | 35 ++++++++++++++++++++++++++++-------=0D
 arch/x86/kvm/vmx/vmx.h    |  1 +=0D
 6 files changed, 64 insertions(+), 21 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

