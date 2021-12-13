Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797DC472A94
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 11:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238073AbhLMKrg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 05:47:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37805 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238064AbhLMKr3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Dec 2021 05:47:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639392448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=K4sGF0NAW/VsyTENe9DByJ+sB/CuOcKuBSfdoXWyu8M=;
        b=RFV+WPZOwLX/j5LxBttjtNpKasq7G7CtR6Dr2/1ye61LHCQic8/xty6SZOJlsJNEwoKOOE
        UIz9UmC+aPiya7olnupNdPh1R30HaWksvc5GzJ+2yaLOpFfGvJYOCxumskULqipjJ4CTep
        n4x4AzA6iHFV15JBpvYIHnmAHnodjuU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-DjTbVhpcOQabcp4vYdGqZw-1; Mon, 13 Dec 2021 05:47:24 -0500
X-MC-Unique: DjTbVhpcOQabcp4vYdGqZw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4A7381EE67;
        Mon, 13 Dec 2021 10:47:22 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D75DF7AB49;
        Mon, 13 Dec 2021 10:46:35 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 0/5] RFC: KVM: SVM: Allow L1's AVIC to co-exist with nesting
Date:   Mon, 13 Dec 2021 12:46:29 +0200
Message-Id: <20211213104634.199141-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series aims to lift long standing restriction of=0D
using AVIC only when nested virtualization is not exposed=0D
to the guest.=0D
=0D
Notes about specific patches:=0D
=0D
Patch 1 - this is an unrelated fix to KVM for a corner case I found=0D
while writing a unit test for the feature.=0D
=0D
Patch 2 addresses the fact that AVIC appears to be disabled=0D
in CPUID on several Milan systems I am tesing on.=0D
=0D
This adds a workaround (with a big warning and a kernel taint) to enable=0D
it anyway if you really know what you are doing.=0D
=0D
Patch 3 is from Paolo, which was done after our long discussion about the=0D
various races that AVIC inhibition is subject to. Thanks Paolo!=0D
It replaces two patches I sent in the previous version which attempted=0D
to fix the same issue but weren't quite right.=0D
=0D
Patch 4 is the more or less the same patch 5 in V1, but with proper=0D
justification.=0D
=0D
Patch 6 is the patch that adds the AVIC co-existance itself and=0D
in this version I fixed (and partially tested) it in regard to AVIC inhibit=
ion=0D
due to interrupt window.=0D
=0D
Everything was tested on a Zen3 (Milan) machine.=0D
=0D
On Zen2 machines, the errata #1235 makes my tests fail quite fast.=0D
For general use though, most of the time this errata doesn't cause=0D
long hangs.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (5):=0D
  KVM: nSVM: deal with L1 hypervisor that intercepts interrupts but lets=0D
    L2 control EFLAGS.IF=0D
  KVM: SVM: allow to force AVIC to be enabled=0D
  KVM: SVM: fix race between interrupt delivery and AVIC inhibition=0D
  KVM: x86: don't touch irr_pending in kvm_apic_update_apicv when=0D
    inhibiting it=0D
  KVM: SVM: allow AVIC to co-exist with a nested guest running=0D
=0D
 arch/x86/include/asm/kvm-x86-ops.h |  1 +=0D
 arch/x86/include/asm/kvm_host.h    |  7 ++-=0D
 arch/x86/kvm/lapic.c               |  5 +-=0D
 arch/x86/kvm/svm/avic.c            | 91 +++++++++++++++++++-----------=0D
 arch/x86/kvm/svm/nested.c          | 11 ++--=0D
 arch/x86/kvm/svm/svm.c             | 51 +++++++++++------=0D
 arch/x86/kvm/svm/svm.h             |  1 +=0D
 arch/x86/kvm/x86.c                 | 17 +++++-=0D
 8 files changed, 125 insertions(+), 59 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

