Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7A4351984
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236227AbhDARyB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:54:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36056 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237209AbhDARvI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:51:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6tYRJ1YPm2YiHZpNplHwmZcadjvns9Uy/SktMSxJfhw=;
        b=WxS2TTytlIBoG5DR2QhGt2KZHSbA6ucBbL4q2wX5+P135xeP3o/TRABYEdF1JwfwCR6LOR
        wEEnxAbqKtAvjZ2Zn0/L7Qw9dhAyZgfXVHhiIQmqgng3277H9AucfsLUy3PNnk5zrCo6kI
        KtzE1uRAkF51c3Gty0XRKeV02iIXxN0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-A4WTr3KoPZWJDliuqV2sJA-1; Thu, 01 Apr 2021 07:19:34 -0400
X-MC-Unique: A4WTr3KoPZWJDliuqV2sJA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9ADAE108BD06;
        Thu,  1 Apr 2021 11:19:32 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 368C117B15;
        Thu,  1 Apr 2021 11:19:29 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 0/2] KVM: x86: nSVM: fixes for SYSENTER emulation
Date:   Thu,  1 Apr 2021 14:19:26 +0300
Message-Id: <20210401111928.996871-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

