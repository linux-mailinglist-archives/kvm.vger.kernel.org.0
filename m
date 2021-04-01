Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18853518AA
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 19:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235025AbhDARrA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:47:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32337 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235169AbhDARmW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:42:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617298942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6tYRJ1YPm2YiHZpNplHwmZcadjvns9Uy/SktMSxJfhw=;
        b=O74nDNps+K7mgMbGeV8pKAA0J3x+6+oZAaK2igZ1xpuRiBfASpZ2NjcUxRzym9Dw01od/c
        r9Thw/Y3JwTRFRtlpz8RHqfikUYv1n8v6M/Ap+VfX6PQ8LUisz6RbkF1SM6dmmSKwJoeS/
        ZSRP2aCDEPu5qiVG09eSVmesfHoCyxk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-c_-25MNsOuaopDL9pXv0Sw-1; Thu, 01 Apr 2021 07:16:23 -0400
X-MC-Unique: c_-25MNsOuaopDL9pXv0Sw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D713480063;
        Thu,  1 Apr 2021 11:16:19 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 06D8A73A69;
        Thu,  1 Apr 2021 11:16:15 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/2] KVM: x86: nSVM: fixes for SYSENTER emulation
Date:   Thu,  1 Apr 2021 14:16:12 +0300
Message-Id: <20210401111614.996018-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a result of a deep rabbit hole dive in regard to why=0D
currently the nested migration of 32 bit guests=0D
is totally broken on AMD.=0D
=0D
It turns out that due to slight differences between the original AMD64=0D
implementation and the Intel's remake, SYSENTER instruction behaves a=0D
bit differently on Intel, and to support migration from Intel to AMD we=0D
try to emulate those differences away.=0D
=0D
Sadly that collides with virtual vmload/vmsave feature that is used in nest=
ing.=0D
The problem was that when it is enabled,=0D
on migration (and otherwise when userspace reads MSR_IA32_SYSENTER_{EIP|ESP=
},=0D
wrong value were returned, which leads to #DF in the=0D
nested guest when the wrong value is loaded back.=0D
=0D
The patch I prepared carefully fixes this, by mostly disabling that=0D
SYSCALL emulation when we don't spoof the Intel's vendor ID, and if we do,=
=0D
and yet somehow SVM is enabled (this is a very rare edge case), then=0D
virtual vmload/save is force disabled.=0D
=0D
V2: incorporated review feedback from Paulo.=0D
=0D
Best regards,=0D
        Maxim Levitsky=0D
=0D
Maxim Levitsky (2):=0D
  KVM: x86: add guest_cpuid_is_intel=0D
  KVM: nSVM: improve SYSENTER emulation on AMD=0D
=0D
 arch/x86/kvm/cpuid.h   |  8 ++++=0D
 arch/x86/kvm/svm/svm.c | 99 +++++++++++++++++++++++++++---------------=0D
 arch/x86/kvm/svm/svm.h |  6 +--=0D
 3 files changed, 76 insertions(+), 37 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

