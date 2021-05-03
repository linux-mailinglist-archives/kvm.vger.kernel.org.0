Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9312337157A
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 14:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbhECMzu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 08:55:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52276 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230246AbhECMzt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 08:55:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620046495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=1Rw8PEoNDUSMjSr1Op+FeFRDfcIRdOVFZ6tTPEgh5kA=;
        b=c/luLvoSRJ9tfceNU2Ic0lt8rUvCqVXB1+0zuAF8qD/s73xjY+scaBUvG+CEh7goqYclDb
        IRgQSEsHjaNPI4Ri3kbXUq03t5NsBOs+hSryO/UxuYhOllq7kOK0eueJq151gYa8tQo3Af
        aVvFVuq+3aCwfdirYqElslUyGttZyXo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-nzEQ7-B_NrCWNWi_DZLH4A-1; Mon, 03 May 2021 08:54:54 -0400
X-MC-Unique: nzEQ7-B_NrCWNWi_DZLH4A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5802E1922962;
        Mon,  3 May 2021 12:54:52 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.193.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A79E610DF;
        Mon,  3 May 2021 12:54:47 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Sean Christopherson <seanjc@google.com>,
        Cathy Avery <cavery@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/5] KVM: nSVM: few fixes for the nested migration
Date:   Mon,  3 May 2021 15:54:41 +0300
Message-Id: <20210503125446.1353307-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Those are few fixes for issues I uncovered by doing variants of a=0D
synthetic migration test I just created:=0D
=0D
I modified the qemu, such that on each vm pause/resume cycle,=0D
just prior to resuming a vCPU, qemu reads its KVM state,=0D
then (optionaly) resets this state by uploading a=0D
dummy reset state to KVM, and then it uploads back to KVM,=0D
the state that this vCPU had before.=0D
=0D
I'll try to make this test upstreamable soon, pending few details=0D
I need to figure out.=0D
=0D
Last patch in this series is for false positive warning=0D
that I have seen lately when setting the nested state,=0D
in nested_svm_vmexit, where it expects the vmcb01 to have=0D
VMRUN vmexit, which is not true after nested migration,=0D
as it is not fully initialized.=0D
If you prefer the warning can be removed instead.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (5):=0D
  KVM: nSVM: fix a typo in svm_leave_nested=0D
  KVM: nSVM: fix few bugs in the vmcb02 caching logic=0D
  KVM: nSVM: leave the guest mode prior to loading a nested state=0D
  KVM: nSVM: force L1's GIF to 1 when setting the nested state=0D
  KVM: nSVM: set a dummy exit reason in L1 vmcb when loading the nested=0D
    state=0D
=0D
 arch/x86/include/asm/kvm_host.h |  1 +=0D
 arch/x86/kvm/svm/nested.c       | 29 ++++++++++++++++++++++++++---=0D
 arch/x86/kvm/svm/svm.c          |  4 ++--=0D
 3 files changed, 29 insertions(+), 5 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

