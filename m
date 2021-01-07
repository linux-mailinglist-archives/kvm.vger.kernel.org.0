Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03DCE2ECCF3
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 10:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbhAGJkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 04:40:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44679 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725974AbhAGJkg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Jan 2021 04:40:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610012349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0/UvIsE6v1FZ8l1jZ7AnILfXjsl6XgnZoeG7pEBoAX4=;
        b=UswIR7I3sqB3XTAOwxGLgnQiQKoS0jwtpuuz5jb4BnowznAXJhcj4IvLW2mSVOMoIGUNxI
        b1HgfR8lgiS8ZrF9u/UArC5rvXJJGTns+7FN5dvc7UDJjndoubbz/iG2eL+T04R0bRdqja
        pflpRpigdaaPVpHgbGdQEcSyKfr6t1Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-34FcIbIPMUOnL2sw4IGfiQ-1; Thu, 07 Jan 2021 04:39:06 -0500
X-MC-Unique: 34FcIbIPMUOnL2sw4IGfiQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33CD9AFA80;
        Thu,  7 Jan 2021 09:39:04 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3966219D7D;
        Thu,  7 Jan 2021 09:38:55 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 0/4] KVM: nSVM: few random fixes
Date:   Thu,  7 Jan 2021 11:38:50 +0200
Message-Id: <20210107093854.882483-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a series of fixes to nested SVM, that finally makes my kvm on kvm=0D
stress test pass, and fix various other issues/regressions.=0D
=0D
Patch 1 is a fix for recent regression related to code that delayed the nes=
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
Patch 2 makes KVM restore nested_run_pending flag on migration which fixes=
=0D
various issues including potentially missed L1->L2 event injection=0D
if migration happens while nested run is pending.=0D
=0D
Patches 3,4 are few things I found while reviewing the nested migration cod=
e.=0D
I don't have a reproducer for them.=0D
=0D
Thanks a lot to Sean Christopherson for the review feedback on V1 of this=0D
series, which is fully incorporated in this series.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (4):=0D
  KVM: nSVM: cancel KVM_REQ_GET_NESTED_STATE_PAGES on nested vmexit=0D
  KVM: nSVM: correctly restore nested_run_pending on migration=0D
  KVM: nSVM: always leave the nested state first on KVM_SET_NESTED_STATE=0D
  KVM: nSVM: mark vmcb as dirty when forcingly leaving the guest mode=0D
=0D
 arch/x86/kvm/svm/nested.c | 12 ++++++++++++=0D
 1 file changed, 12 insertions(+)=0D
=0D
-- =0D
2.26.2=0D
=0D

