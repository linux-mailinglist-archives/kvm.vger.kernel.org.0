Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7613BEF0E9
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 00:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387470AbfKDXAT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 18:00:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46928 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387399AbfKDXAS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 18:00:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572908417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MPSLE44CrTdmlpvXHFayzgdX5FlkhhVbp9gFdKUYL+k=;
        b=UQpcGFO4ljdxIrcJodG5iDvGBbH1TEsyOkL1EarDkNLIQ4118Sobrb5uDQ/XBi9eO+HzEU
        qpbjusk19544RFSDDmAnrYx+f7fsiRGhfMsPtfcE3N7bZ70bPdgZpMYgT3WtP5UjhjB1A0
        QRK8Ao3+zTOSZNgHcmOYQo0lH3x296Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-b5UzRDpCM4imlDSRq6tXOg-1; Mon, 04 Nov 2019 18:00:09 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8221B1005500;
        Mon,  4 Nov 2019 23:00:08 +0000 (UTC)
Received: from mail (ovpn-121-157.rdu2.redhat.com [10.10.121.157])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B31C4A0E;
        Mon,  4 Nov 2019 23:00:08 +0000 (UTC)
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 07/13] KVM: monolithic: x86: remove __init section prefix from kvm_x86_cpu_has_kvm_support
Date:   Mon,  4 Nov 2019 17:59:55 -0500
Message-Id: <20191104230001.27774-8-aarcange@redhat.com>
In-Reply-To: <20191104230001.27774-1-aarcange@redhat.com>
References: <20191104230001.27774-1-aarcange@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: b5UzRDpCM4imlDSRq6tXOg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adjusts the section prefixes of some KVM x86 code function because
with the monolithic KVM model the section checker can now do a more
accurate static analysis at build time. This also allows to build
without CONFIG_SECTION_MISMATCH_WARN_ONLY=3Dn.

The __init needs to be removed on vmx despite it's only svm calling it
from kvm_x86_hardware_enable which is eventually called by
hardware_enable_nolock() or there's a (potentially false positive)
warning (false positive because this function isn't called in the vmx
case). If this isn't needed the right cleanup isn't to put it in the
__init section, but to drop it. As long as it's defined in vmx as a
kvm_x86 operation, it's expectable that might eventually be called at
runtime while hot plugging new CPUs.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 4 ++--
 arch/x86/kvm/vmx/vmx.c          | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 2b03ec80f6d7..2ddc61fdcd09 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -998,7 +998,7 @@ struct kvm_lapic_irq {
 =09bool msi_redir_hint;
 };
=20
-extern __init int kvm_x86_cpu_has_kvm_support(void);
+extern int kvm_x86_cpu_has_kvm_support(void);
 extern __init int kvm_x86_disabled_by_bios(void);
 extern int kvm_x86_hardware_enable(void);
 extern void kvm_x86_hardware_disable(void);
@@ -1190,7 +1190,7 @@ extern bool kvm_x86_apic_init_signal_blocked(struct k=
vm_vcpu *vcpu);
 extern int kvm_x86_enable_direct_tlbflush(struct kvm_vcpu *vcpu);
=20
 struct kvm_x86_ops {
-=09int (*cpu_has_kvm_support)(void);          /* __init */
+=09int (*cpu_has_kvm_support)(void);
 =09int (*disabled_by_bios)(void);             /* __init */
 =09int (*hardware_enable)(void);
 =09void (*hardware_disable)(void);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e406707381a4..87e5d7276ea4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2178,7 +2178,7 @@ void kvm_x86_cache_reg(struct kvm_vcpu *vcpu, enum kv=
m_reg reg)
 =09}
 }
=20
-__init int kvm_x86_cpu_has_kvm_support(void)
+int kvm_x86_cpu_has_kvm_support(void)
 {
 =09return cpu_has_vmx();
 }

