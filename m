Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D807A33C4DD
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 18:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhCOR4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 13:56:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50446 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233192AbhCORsk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Mar 2021 13:48:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615830340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wVIrHu5i7uEomxJk7uMi6tnqyeAug3yjA4h+WiRfCDs=;
        b=bCjjvmgOllhyKk0EVDaP4Encu23Io8humN1jQl/7Xx/WNJTToHesQXzJKArs0k9BW+a7tx
        b7AXj9MzuQGQ7j2sxqzdSIwM5AGKUV8zCU7b7hKPGoz5uQQe7x51oNSGgwQQaaGpruHrcA
        MGCyEsCDBz4gE4QePhnBh+FLE8XtXoM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-p15X9b5UOpygdTl2bJiq-w-1; Mon, 15 Mar 2021 13:43:23 -0400
X-MC-Unique: p15X9b5UOpygdTl2bJiq-w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFDDB80006E;
        Mon, 15 Mar 2021 17:43:21 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.207.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCC7F5D745;
        Mon, 15 Mar 2021 17:43:17 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/2] KVM: x86: nSVM: fixes for SYSENTER emulation
Date:   Mon, 15 Mar 2021 19:43:14 +0200
Message-Id: <20210315174316.477511-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a result of deep rabbit hole dive in regard to why currently the=0D
nested migration of 32 bit guests is totally broken on AMD.=0D
=0D
It turns out that due to slight differences between the original AMD64=0D
implementation and the Intel's remake, SYSENTER instruction behaves a=0D
bit differently on Intel, and to support migration from Intel to AMD we=0D
try to emulate those differences away.=0D
=0D
Sadly that collides with virtual vmload/vmsave feature that is used in nest=
ing=0D
such as on migration (and otherwise when userspace=0D
reads MSR_IA32_SYSENTER_EIP/MSR_IA32_SYSENTER_ESP), wrong value is returned=
,=0D
which leads to #DF in the nested guest when the wrong value is loaded back.=
=0D
=0D
The patch I prepared carefully fixes this, by mostly disabling that SYSCALL=
=0D
emulation when we don't spoof Intel's vendor ID, and if we do, and yet some=
how=0D
SVM is enabled (this is very rare corner case), then virtual vmload/save is=
=0D
force disabled.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (2):=0D
  KVM: x86: add guest_cpuid_is_intel=0D
  KVM: nSVM: improve SYSENTER emulation on AMD=0D
=0D
 arch/x86/kvm/cpuid.h   |  8 ++++=0D
 arch/x86/kvm/svm/svm.c | 97 ++++++++++++++++++++++++++++--------------=0D
 arch/x86/kvm/svm/svm.h |  7 +--=0D
 3 files changed, 77 insertions(+), 35 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

