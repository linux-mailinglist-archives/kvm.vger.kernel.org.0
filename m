Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D332946E7CB
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 12:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236940AbhLIL6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 06:58:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46518 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230080AbhLIL6l (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 06:58:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639050907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=v8P8gXSKRjtgzP3kwGA7Y2AqfOQb6hphXDVJ7u2cqbs=;
        b=C30+8yxglzoc1hMoAk1mtW0/dxWDThIIHrZi4FZbghRJ+0WGW36lmG5HlbVd58cQbDouCz
        P550Bifd/wVjlmZfQy1zXFEehCqSSIaM69BgOyYT/JW6LVudIi3G648mxUQolGPxBZNKWZ
        SozdLu6/0aqPcBXv3Xs8DJjjxRv7huo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-mkQXJrnVME2tpw2sZN5m0Q-1; Thu, 09 Dec 2021 06:55:04 -0500
X-MC-Unique: mkQXJrnVME2tpw2sZN5m0Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A8A4760C1;
        Thu,  9 Dec 2021 11:55:02 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 828D145D7B;
        Thu,  9 Dec 2021 11:54:41 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Wanpeng Li <wanpengli@tencent.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/6] RFC: KVM: SVM: Allow L1's AVIC to co-exist with nesting
Date:   Thu,  9 Dec 2021 13:54:34 +0200
Message-Id: <20211209115440.394441-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series aims to lift long standing restriction of=0D
using AVIC only when nested virtualization is not exposed=0D
to the guest.=0D
=0D
Notes about specific patches:=0D
=0D
Patch 1 addresses the fact that AVIC appears to be disabled=0D
in CPUID on several Milan systems I am tesing on.=0D
This adds a workaround (with a big warning and a kernel taint) to enable=0D
it anyway if you really know what you are doing.=0D
=0D
It is possible that those systems have the AVIC disabled as a workaround=0D
for the AVIC errata #1235 which might be already fixed but OEM might=0D
not yet re-enabled it out of caution.=0D
=0D
Patch 6 adds the AVIC co-existance itself, and was tested with a modificati=
on=0D
of the ipi_stress unit test which I soon post upstream which made one=0D
of vCPUs enter nested guest and receive the IPI while nested guest is runni=
ng.=0D
=0D
It was tested on a Zen3 (Milan) machine. On Zen2 machines I have errata #12=
35=0D
makes my test fail quite fast.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (6):=0D
  KVM: SVM: allow to force AVIC to be enabled=0D
  KVM: x86: add a tracepoint for APICv/AVIC interrupt delivery=0D
  KVM: SVM: fix AVIC race of host->guest IPI delivery vs AVIC inhibition=0D
  KVM: SVM: fix races in the AVIC incomplete IPI delivery to vCPUs=0D
  KVM: x86: never clear irr_pending in kvm_apic_update_apicv=0D
  KVM: SVM: allow AVIC to co-exist with a nested guest running=0D
=0D
 arch/x86/include/asm/kvm-x86-ops.h |  1 +=0D
 arch/x86/include/asm/kvm_host.h    |  7 +++++-=0D
 arch/x86/kvm/lapic.c               |  6 ++++-=0D
 arch/x86/kvm/svm/avic.c            | 35 +++++++++++++++++++++++-----=0D
 arch/x86/kvm/svm/nested.c          | 13 ++++++-----=0D
 arch/x86/kvm/svm/svm.c             | 37 +++++++++++++++++++-----------=0D
 arch/x86/kvm/svm/svm.h             |  1 +=0D
 arch/x86/kvm/trace.h               | 24 +++++++++++++++++++=0D
 arch/x86/kvm/x86.c                 | 17 ++++++++++++--=0D
 9 files changed, 111 insertions(+), 30 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

