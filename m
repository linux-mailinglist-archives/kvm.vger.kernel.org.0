Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97853274AD9
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 23:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgIVVKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 17:10:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27967 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726625AbgIVVKf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 17:10:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600809034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bNjVgWpgtIkPhRa8XVCPnausw2GfEoBb82DdGdZXVvc=;
        b=ekIwuyE46DrYdAaRR3VUm9LJ6r86ZyXtW9vna51dozcxfWozLSzNT6srwE2a0xuuuUv4XQ
        AEg5PntS9WxpfXwePKBvt4KyJRAGcL9RvrB036MI35X+RjLHN8wY7TVNG517Fc9UqGOOIU
        ahdkDAwhtTWQKy7OVlzx6mYY3DHOA3k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-EmSHZr1ePa6cO30n87NEuA-1; Tue, 22 Sep 2020 17:10:32 -0400
X-MC-Unique: EmSHZr1ePa6cO30n87NEuA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4AE01007B36;
        Tue, 22 Sep 2020 21:10:30 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF02155768;
        Tue, 22 Sep 2020 21:10:26 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v6 0/4] KVM: nSVM: ondemand nested state allocation
Date:   Wed, 23 Sep 2020 00:10:21 +0300
Message-Id: <20200922211025.175547-1-mlevitsk@redhat.com>
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
 arch/x86/kvm/emulate.c          |  7 ++--=0D
 arch/x86/kvm/svm/nested.c       | 42 ++++++++++++++++++++++++=0D
 arch/x86/kvm/svm/svm.c          | 58 +++++++++++++++++++--------------=0D
 arch/x86/kvm/svm/svm.h          |  8 ++++-=0D
 arch/x86/kvm/vmx/vmx.c          |  6 ++--=0D
 arch/x86/kvm/x86.c              | 37 ++++++++++++---------=0D
 7 files changed, 113 insertions(+), 47 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

