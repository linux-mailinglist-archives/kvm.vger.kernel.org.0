Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EACA2EBCB9
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 11:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbhAFKvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 05:51:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50938 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725896AbhAFKvj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Jan 2021 05:51:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609930213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=kLT4c0oVgoGQ28S7o/zFiab9Iekvo6wVtsgLAAzAA9w=;
        b=dROA8l8vbpcPP/ENQxmQgn2VsNnDehOiutNsk5BC9B/aP95Gh4MPJ2iAkKP4gdk01hqskd
        9MeF0jXJaJsgG1eEVrYvIfzSMhNIH7o3hicFrh08IQY03hcjxmn3iCmJXD7W8r/Z1rxx4/
        gKHehC6biapXkEj/8N80vwnoY3RrC1s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-ViKoHO4uNXW5l6wig8wqkg-1; Wed, 06 Jan 2021 05:50:11 -0500
X-MC-Unique: ViKoHO4uNXW5l6wig8wqkg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2220D800D55;
        Wed,  6 Jan 2021 10:50:09 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2805669FC;
        Wed,  6 Jan 2021 10:50:03 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/6] KVM: nSVM: few random fixes
Date:   Wed,  6 Jan 2021 12:49:55 +0200
Message-Id: <20210106105001.449974-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a series of fixes to nested SVM, that finally makes my kvm on kvm=0D
stress test pass, and fix various other issues/regressions.=0D
=0D
Patches 1-2 are a fix for disappearing interrupts in L2 on migration which=
=0D
usually make the L2 hang.=0D
Same issue happens on VMX and WIP, patches for this will be sent in a separ=
ate=0D
series.=0D
Paulo helped me to find the root cause of this issue.=0D
=0D
Note that this patch likely breaks a nested guest that uses software interr=
upt=0D
injections (SVM_EXITINTINFO_TYPE_SOFT) because currently kvm ignores these=
=0D
on SVM.=0D
=0D
Patch 3 is a fix for recent regression related to code that delayed the nes=
ted=0D
msr bitmap processing to the next vm entry, and started to crash the L1 aft=
er=0D
my on demand nested state allocation patches.=0D
=0D
The problem was that the code assumed that we will still be in the nested=0D
guest mode on next vmentry after setting the nested state, but a pending ev=
ent=0D
can cause a nested vmexit prior to that.=0D
=0D
Patches 4,5,6 are few things I found while reviewing the nested migration c=
ode.=0D
I don't have a reproducer for them.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (6):=0D
  KVM: SVM: create svm_process_injected_event=0D
  KVM: nSVM: fix for disappearing L1->L2 event injection on L1 migration=0D
  KVM: nSVM: cancel KVM_REQ_GET_NESTED_STATE_PAGES on nested vmexit=0D
  KVM: nSVM: correctly restore nested_run_pending on migration=0D
  KVM: nSVM: always leave the nested state first on KVM_SET_NESTED_STATE=0D
  KVM: nSVM: mark vmcb as dirty when forcingly leaving the guest mode=0D
=0D
 arch/x86/kvm/svm/nested.c | 21 ++++++++++++--=0D
 arch/x86/kvm/svm/svm.c    | 58 ++++++++++++++++++++++-----------------=0D
 arch/x86/kvm/svm/svm.h    |  4 +++=0D
 3 files changed, 55 insertions(+), 28 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

