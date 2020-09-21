Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE001272542
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 15:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgIUNTf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 09:19:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30752 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726876AbgIUNTf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Sep 2020 09:19:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600694374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2li71nHKDdeIHk4pBYNK/fNmoEg3vB9ERzI+dLskZvo=;
        b=bPct19gyY+B6+dw+al61BDgFX6fTfSongPZczHIxyTdPdkfPaKY0cQwlso8qkU7JZX7bzT
        8YryzdWBBKep9nDCg/6FA77TFor3HK1mcvg5KGcfXCIa0CgOHSroLHyrBg0GxCpsz0j1+r
        urFJCEHkx5tD/ctcG7Q9Zg9LOqm8l8c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-_ZZloquDNz6-Zlg1Un68nQ-1; Mon, 21 Sep 2020 09:19:32 -0400
X-MC-Unique: _ZZloquDNz6-Zlg1Un68nQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A19F018C89C1;
        Mon, 21 Sep 2020 13:19:30 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DBD133782;
        Mon, 21 Sep 2020 13:19:25 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v5 0/4] KVM: nSVM: ondemand nested state allocation
Date:   Mon, 21 Sep 2020 16:19:19 +0300
Message-Id: <20200921131923.120833-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is yet another version of ondemand nested state allocation.=0D
=0D
In this version I adoped the suggestion of Sean Christopherson=0D
to return make EFER write return a negative error which then should=0D
propogate to the userspace.=0D
=0D
So I fixed the WRMSR code to actually obey this (#GP on positive=0D
return value, exit to userspace when negative error value,=0D
and success on 0 error value, and fixed one user (xen)=0D
that returned negative error code on failures.=0D
=0D
The XEN patch is only compile tested. The rest were tested=0D
by always returning -ENOMEM from svm_allocate_nested.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (4):=0D
  KVM: x86: xen_hvm_config cleanup return values=0D
  KVM: x86: report negative values from wrmsr to userspace=0D
  KVM: x86: allow kvm_x86_ops.set_efer to return a value=0D
  KVM: nSVM: implement ondemand allocation of the nested state=0D
=0D
 arch/x86/include/asm/kvm_host.h |  2 +-=0D
 arch/x86/kvm/emulate.c          |  7 ++--=0D
 arch/x86/kvm/svm/nested.c       | 42 ++++++++++++++++++++++++=0D
 arch/x86/kvm/svm/svm.c          | 58 +++++++++++++++++++--------------=0D
 arch/x86/kvm/svm/svm.h          |  8 ++++-=0D
 arch/x86/kvm/vmx/vmx.c          |  9 +++--=0D
 arch/x86/kvm/x86.c              | 36 ++++++++++----------=0D
 7 files changed, 113 insertions(+), 49 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

