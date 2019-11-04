Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD835EF0F7
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 00:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730336AbfKDXBL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 18:01:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21466 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729194AbfKDXAN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 18:00:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572908413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qV3OgrjNYfT/kr+aj4kw4nJxA2gAsFaFbytpcJxxu3Q=;
        b=HvL+o4npNtizMRVEuJlawlB+Q1JUm0u0TPCKfJCtaScxpiyS41VmmgeqjXvd+kUlmsK+qY
        tVJj788VQ6XWP/75lToRZJaV0LFUcOtykIAE3ff6P3f2BwII6Wowv/tk3maF4KOrHV7O7v
        bMechZqWAAhSj//iqLidq8yE08mBg+c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-KhOeieY8NJaPLT88Yzs1zg-1; Mon, 04 Nov 2019 18:00:09 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A76AA107ACC2;
        Mon,  4 Nov 2019 23:00:08 +0000 (UTC)
Received: from mail (ovpn-121-157.rdu2.redhat.com [10.10.121.157])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F968600D5;
        Mon,  4 Nov 2019 23:00:06 +0000 (UTC)
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 06/13] KVM: monolithic: x86: remove __exit section prefix from machine_unsetup
Date:   Mon,  4 Nov 2019 17:59:54 -0500
Message-Id: <20191104230001.27774-7-aarcange@redhat.com>
In-Reply-To: <20191104230001.27774-1-aarcange@redhat.com>
References: <20191104230001.27774-1-aarcange@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: KhOeieY8NJaPLT88Yzs1zg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adjusts the section prefixes of some KVM x86 code function because
with the monolithic KVM model the section checker can now do a more
accurate static analysis at build time and it found a potentially
kernel crashing bug. This also allows to build without
CONFIG_SECTION_MISMATCH_WARN_ONLY=3Dn.

The __exit removed from machine_unsetup is because
kvm_arch_hardware_unsetup() is called by kvm_init() which is in the
__init section. It's not allowed to call a function located in the
__exit section and dropped during the kernel link from the __init
section or the kernel will crash if that call is made.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 4 ++--
 arch/x86/kvm/svm.c              | 2 +-
 arch/x86/kvm/vmx/vmx.c          | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index b36dd3265036..2b03ec80f6d7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1004,7 +1004,7 @@ extern int kvm_x86_hardware_enable(void);
 extern void kvm_x86_hardware_disable(void);
 extern __init int kvm_x86_check_processor_compatibility(void);
 extern __init int kvm_x86_hardware_setup(void);
-extern __exit void kvm_x86_hardware_unsetup(void);
+extern void kvm_x86_hardware_unsetup(void);
 extern bool kvm_x86_cpu_has_accelerated_tpr(void);
 extern bool kvm_x86_has_emulated_msr(int index);
 extern void kvm_x86_cpuid_update(struct kvm_vcpu *vcpu);
@@ -1196,7 +1196,7 @@ struct kvm_x86_ops {
 =09void (*hardware_disable)(void);
 =09int (*check_processor_compatibility)(void);/* __init */
 =09int (*hardware_setup)(void);               /* __init */
-=09void (*hardware_unsetup)(void);            /* __exit */
+=09void (*hardware_unsetup)(void);
 =09bool (*cpu_has_accelerated_tpr)(void);
 =09bool (*has_emulated_msr)(int index);
 =09void (*cpuid_update)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1705608246fb..4ce102f6f075 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1412,7 +1412,7 @@ __init int kvm_x86_hardware_setup(void)
 =09return r;
 }
=20
-__exit void kvm_x86_hardware_unsetup(void)
+void kvm_x86_hardware_unsetup(void)
 {
 =09int cpu;
=20
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9c5f0c67b899..e406707381a4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7737,7 +7737,7 @@ __init int kvm_x86_hardware_setup(void)
 =09return r;
 }
=20
-__exit void kvm_x86_hardware_unsetup(void)
+void kvm_x86_hardware_unsetup(void)
 {
 =09if (nested)
 =09=09nested_vmx_hardware_unsetup();

