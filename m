Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A9D27FE6C
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 13:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731961AbgJALaP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 07:30:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46491 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731846AbgJALaN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 07:30:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601551812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lW3c3YcYcFwwbVYa8MVvOts8QufJEheVZBkFp2GjStc=;
        b=aBKQ+cakLy3Uv1z44mdlXYe5XfQCSyUULT2qwZ42byXeNPzC5NVQxI9q5kLe5pWg3vPBbe
        oi3wcrBs1cCrdt84jU7tZD4UUZkelJffnVZG/potywG/RKqW+DjZpXaEKYuQwtzimvvebG
        RY+pez2ewlTbt9L37/SU6DbNYcVeIo8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-zYie6UEjNGSos4rTC9BJyw-1; Thu, 01 Oct 2020 07:30:11 -0400
X-MC-Unique: zYie6UEjNGSos4rTC9BJyw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 006D71882FA1;
        Thu,  1 Oct 2020 11:30:09 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C47275122;
        Thu,  1 Oct 2020 11:29:56 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v7 0/4] KVM: nSVM: ondemand nested state allocation
Date:   Thu,  1 Oct 2020 14:29:50 +0300
Message-Id: <20201001112954.6258-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the next version of this patch series.=0D
=0D
In V5 I adopted Sean Christopherson's suggestion to make .set_efer return=0D
a negative error (-ENOMEM in this case) which in most cases in kvm=0D
propagates to the userspace.=0D
=0D
I noticed though that wrmsr emulation code doesn't do this and instead=0D
it injects #GP to the guest on _any_ error.=0D
=0D
So I fixed the wrmsr code to behave in a similar way to the rest=0D
of the kvm code.=0D
(#GP only on a positive error value, and forward the negative error to=0D
the userspace)=0D
=0D
I had to adjust one wrmsr handler (xen_hvm_config) to stop it from returnin=
g=0D
negative values	so that new WRMSR emulation behavior doesn't break it.=0D
This patch was only compile tested.=0D
=0D
The memory allocation failure was tested by always returning -ENOMEM=0D
from svm_allocate_nested.=0D
=0D
The nested allocation itself was tested by countless attempts to run=0D
nested guests, do nested migration on both my AMD and Intel machines.=0D
I wasn't able to break it.=0D
=0D
Changes from V5: addressed Sean Christopherson's review feedback.=0D
Changes from V6: rebased the code on latest kvm/queue=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (4):=0D
  KVM: x86: xen_hvm_config: cleanup return values=0D
  KVM: x86: report negative values from wrmsr emulation to userspace=0D
  KVM: x86: allow kvm_x86_ops.set_efer to return an error value=0D
  KVM: nSVM: implement on demand allocation of the nested state=0D
=0D
 arch/x86/include/asm/kvm_host.h |  2 +-=0D
 arch/x86/kvm/emulate.c          |  4 +--=0D
 arch/x86/kvm/svm/nested.c       | 42 ++++++++++++++++++++++=0D
 arch/x86/kvm/svm/svm.c          | 64 ++++++++++++++++++---------------=0D
 arch/x86/kvm/svm/svm.h          | 10 +++++-=0D
 arch/x86/kvm/vmx/vmx.c          |  6 ++--=0D
 arch/x86/kvm/x86.c              | 39 ++++++++++----------=0D
 7 files changed, 114 insertions(+), 53 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

