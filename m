Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40423B18E5
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 13:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbhFWLca (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 07:32:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30234 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230061AbhFWLc3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 07:32:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624447812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=X1GzAVf+gb6q4LxhfS5tRSSn/OIp80A59WY9loahInM=;
        b=dorsaBMCGu+WVFuj8a+UCrFPlFeO0sbswPmEGi/P12zGuQg90KGK4U7hS5xBxpv9qQnEWn
        BELOWkhGM304lmXA7YpUO9v7SB7vLevFBsR8z8Xj/Y3PanL5GISuZPnPLSJPtKn9XSKDJx
        sT77Hq0SjADHP0r4ExS1Hob8DRPSaX8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-CuA9jUTFOOaSlj3c1A1bYQ-1; Wed, 23 Jun 2021 07:30:11 -0400
X-MC-Unique: CuA9jUTFOOaSlj3c1A1bYQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D20E219067E5;
        Wed, 23 Jun 2021 11:30:08 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C4875D6D7;
        Wed, 23 Jun 2021 11:30:03 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)),
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 00/10] My AVIC patch queue
Date:   Wed, 23 Jun 2021 14:29:52 +0300
Message-Id: <20210623113002.111448-1-mlevitsk@redhat.com>
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
First 4 patches in this series fix a race condition which can cause=0D
a lost write from a guest to APIC when the APIC write races=0D
the AVIC un-inhibition.=0D
=0D
Next four patches hopefully correctly address an issue of possible=0D
mismatch between the AVIC inhibit state and AVIC enable state on all vCPUs.=
=0D
=0D
Since AVICs state is changed via a request there is a window during which=0D
the states differ which can lead to various warnings and errors.=0D
=0D
There was an earlier attempt to fix this by changing the AVIC enable state=
=0D
on the current vCPU immediately when the AVIC inhibit request is created,=0D
however while this fixes the common case, it actually hides the issue deepe=
r,=0D
because on all other vCPUs but current one, the two states can still=0D
mismatch till the KVM_REQ_APICV_UPDATE is processed on each of them.=0D
=0D
My take on this is to fix the places where the mismatch causes the=0D
issues instead and then drop the special case of toggling the AVIC right=0D
away in kvm_request_apicv_update.=0D
=0D
Patch 9 is an attempt to fix yet another issue I found in AVIC inhibit=0D
code:=0D
Currently avic_vcpu_load/avic_vcpu_put are called on userspace entry/exit=0D
from KVM (aka kvm_vcpu_get/kvm_vcpu_put), and these functions update the=0D
"is running" bit in the AVIC physical ID remap table and update the=0D
target vCPU in iommu code.=0D
=0D
However both of these functions don't do anything when AVIC is inhibited=0D
thus the "is running" bit will be kept enabled during exit to userspace.=0D
This shouldn't be a big issue as the caller=0D
doesn't use the AVIC when inhibited but still inconsistent and can trigger=
=0D
a warning about this in avic_vcpu_load.=0D
=0D
To be on the safe side I think it makes sense to call=0D
avic_vcpu_put/avic_vcpu_load when inhibiting/uninhibiting the AVIC.=0D
This will ensure that the work these functions do is matched.=0D
=0D
Patch 10 is the patch from Vitaly about allowing AVIC with SYNC=0D
as long as the guest doesn=E2=80=99t use the AutoEOI feature. I only slight=
ly=0D
changed it to drop the SRCU lock around call to kvm_request_apicv_update=0D
and also expose the AutoEOI cpuid bit regardless of AVIC enablement.=0D
=0D
Despite the fact that this is the last patch in this series, this patch=0D
doesn't depend on the other fixes.=0D
=0D
Lastly I should note that I spent quite some time last week trying=0D
to avoid dropping the SRCU lock around call to kvm_request_apicv_update,=0D
which is needed due to the fact that this function changes memslots=0D
and needs to do SRCU synchronization.=0D
=0D
I tried to make this function such that it would only raise=0D
the KVM_REQ_APICV_UPDATE, and let all vCPUs try to toggle the memory slot,=
=0D
while processing this request,=0D
but that approach was doomed to fail due to various races.=0D
=0D
Using a delayed work for this as was suggested doesn't work either as it ca=
n't=0D
update the VM's memory slots (this has to be done from the VM's process).=0D
=0D
It is possible to brute force this by raising a new request,=0D
say KVM_REQUEST_AVIC_INHIBITION on say VCPU0, let the new request=0D
processing code drop the srcu lock and then do the things that=0D
kvm_request_apicv_update does. I don't know if this would be better=0D
than the current state of the things.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (9):=0D
  KVM: x86: extract block/allow guest enteries=0D
  KVM: x86: APICv: fix race in kvm_request_apicv_update on SVM=0D
  KVM: x86: rename apic_access_page_done to apic_access_memslot_enabled=0D
  KVM: SVM: add warning for mistmatch between AVIC state and AVIC access=0D
    page state=0D
  KVM: SVM: svm_set_vintr don't warn if AVIC is active but is about to=0D
    be deactivated=0D
  KVM: SVM: tweak warning about enabled AVIC on nested entry=0D
  KVM: SVM: use vmcb01 in svm_refresh_apicv_exec_ctrl=0D
  KVM: x86: APICv: drop immediate APICv disablement on current vCPU=0D
  KVM: SVM: call avic_vcpu_load/avic_vcpu_put when enabling/disabling=0D
    AVIC=0D
=0D
Vitaly Kuznetsov (1):=0D
  KVM: x86: hyper-v: Deactivate APICv only when AutoEOI feature is in=0D
    use=0D
=0D
 arch/x86/include/asm/kvm_host.h | 10 +++++--=0D
 arch/x86/kvm/hyperv.c           | 34 +++++++++++++++++++----=0D
 arch/x86/kvm/svm/avic.c         | 49 +++++++++++++++++----------------=0D
 arch/x86/kvm/svm/nested.c       |  2 +-=0D
 arch/x86/kvm/svm/svm.c          | 18 +++++++++---=0D
 arch/x86/kvm/vmx/vmx.c          |  4 +--=0D
 arch/x86/kvm/x86.c              | 49 ++++++++++++++++++---------------=0D
 7 files changed, 105 insertions(+), 61 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

