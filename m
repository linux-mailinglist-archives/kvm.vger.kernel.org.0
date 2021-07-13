Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 097563C71FC
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 16:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236763AbhGMOXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 10:23:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35677 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236636AbhGMOXX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 10:23:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626186033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pNQ2lCTRvbObMNcD7lph5qANAohw41EceuXt8GmciDk=;
        b=aVHChIbbBBOTq8Tbyyln67CzUGaT+A47qIaFYrI9yz0MF76wj6KaFxdoJgSeJVimFB+15b
        y5dzHrLyZeGpTB1Q2SK17/5JBTvc3eK2m6azFAyc93H1beW7ccIyAhg58VwW/l4cP1fxRA
        9GCrHla6XfEs7h6bZGhTObriCCrXe8c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-hnGZOYq0Np-W6mlmQ95kRg-1; Tue, 13 Jul 2021 10:20:31 -0400
X-MC-Unique: hnGZOYq0Np-W6mlmQ95kRg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88F69101F016;
        Tue, 13 Jul 2021 14:20:29 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C98B25D6AB;
        Tue, 13 Jul 2021 14:20:24 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 0/8] My AVIC patch queue
Date:   Tue, 13 Jul 2021 17:20:15 +0300
Message-Id: <20210713142023.106183-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi!=0D
=0D
This is a series of bugfixes to the AVIC dynamic inhibition, which was=0D
made while trying to fix bugs as much as possible, in this area and trying=
=0D
to make the AVIC+SYNIC conditional enablement work.=0D
=0D
* Patches 1-4 address an issue of possible=0D
  mismatch between the AVIC inhibit state and AVIC enable state on all vCPU=
s.=0D
=0D
  Since AVICs state is changed via a request there is a window during which=
=0D
  the states differ which can lead to various warnings and errors.=0D
=0D
  There was an earlier attempt to fix this by changing the AVIC enable stat=
e=0D
  on the current vCPU immediately when the AVIC inhibit request is created,=
=0D
  however while this fixes the common case, it actually hides the issue dee=
per,=0D
  because on all other vCPUs but current one, the two states can still=0D
  mismatch till the KVM_REQ_APICV_UPDATE is processed on each of them.=0D
=0D
  My take on this is to fix the places where the mismatch causes the=0D
  issues instead and then drop the special case of toggling the AVIC right=
=0D
  away in kvm_request_apicv_update.=0D
=0D
  V2: I rewrote the commit description for the patch that touches=0D
    avic inhibition in nested case.=0D
=0D
* Patches 5-6 in this series fix a race condition which can cause=0D
  a lost write from a guest to APIC when the APIC write races=0D
  the AVIC un-inhibition, and add a warning to catch this problem=0D
  if it re-emerges again.=0D
=0D
  V2: I re-implemented this with a mutex in V2.=0D
=0D
* Patch 7 is an  fix yet another issue I found in AVIC inhibit code:=0D
  Currently avic_vcpu_load/avic_vcpu_put are called on userspace entry/exit=
=0D
  from KVM (aka kvm_vcpu_get/kvm_vcpu_put), and these functions update the=
=0D
  "is running" bit in the AVIC physical ID remap table and update the=0D
  target vCPU in iommu code.=0D
=0D
  However both of these functions don't do anything when AVIC is inhibited=
=0D
  thus the "is running" bit will be kept enabled during exit to userspace.=
=0D
  This shouldn't be a big issue as the caller=0D
  doesn't use the AVIC when inhibited but still inconsistent and can trigge=
r=0D
  a warning about this in avic_vcpu_load.=0D
=0D
  To be on the safe side I think it makes sense to call=0D
  avic_vcpu_put/avic_vcpu_load when inhibiting/uninhibiting the AVIC.=0D
  This will ensure that the work these functions do is matched.=0D
=0D
* Patch 8 is the patch from Vitaly about allowing AVIC with SYNC=0D
  as long as the guest doesn=E2=80=99t use the AutoEOI feature. I only slig=
htly=0D
  changed it to drop the SRCU lock around call to kvm_request_apicv_update=
=0D
  and also expose the AutoEOI cpuid bit regardless of AVIC enablement.=0D
=0D
  Despite the fact that this is the last patch in this series, this patch=0D
  doesn't depend on the other fixes.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (7):=0D
  KVM: SVM: svm_set_vintr don't warn if AVIC is active but is about to=0D
    be deactivated=0D
  KVM: SVM: tweak warning about enabled AVIC on nested entry=0D
  KVM: SVM: use vmcb01 in svm_refresh_apicv_exec_ctrl=0D
  KVM: x86: APICv: drop immediate APICv disablement on current vCPU=0D
  KVM: x86: APICv: fix race in kvm_request_apicv_update on SVM=0D
  KVM: SVM: add warning for mistmatch between AVIC state and AVIC access=0D
    page state=0D
  KVM: SVM: call avic_vcpu_load/avic_vcpu_put when enabling/disabling=0D
    AVIC=0D
=0D
Vitaly Kuznetsov (1):=0D
  KVM: x86: hyper-v: Deactivate APICv only when AutoEOI feature is in=0D
    use=0D
=0D
 arch/x86/include/asm/kvm_host.h |  3 ++=0D
 arch/x86/kvm/hyperv.c           | 34 ++++++++++++++++----=0D
 arch/x86/kvm/svm/avic.c         | 45 ++++++++++++++------------=0D
 arch/x86/kvm/svm/nested.c       |  2 +-=0D
 arch/x86/kvm/svm/svm.c          | 18 ++++++++---=0D
 arch/x86/kvm/x86.c              | 57 ++++++++++++++++++---------------=0D
 include/linux/kvm_host.h        |  1 +=0D
 virt/kvm/kvm_main.c             |  1 +=0D
 8 files changed, 103 insertions(+), 58 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

