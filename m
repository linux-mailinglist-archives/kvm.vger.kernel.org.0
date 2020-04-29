Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F8A1BD85F
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 11:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgD2Jgw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 05:36:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40558 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726678AbgD2Jgv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 05:36:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588153011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qrU45IjYpsSPhee98a71DO7PSXKEWlgj/Cgaykvb5Xg=;
        b=dj/fOCZDm7sNGXBmmk4Tc05OqP0XQgluyD7BwVnJbq2x3VAhjIsKxlGRQfDJ2i2tyBXlBm
        +pC4vlwr7oMNYVDxsaTI/N+T6NVkq1Waonf0FnVp+9s2g7nArv04bcjxM4Of3tTvSF9A5C
        hMiYNy699/4BD9v7EHiktW1ktrmphhM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-SW8I2XbHNheSFWLDCaJulg-1; Wed, 29 Apr 2020 05:36:46 -0400
X-MC-Unique: SW8I2XbHNheSFWLDCaJulg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7088E800C78;
        Wed, 29 Apr 2020 09:36:44 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B86C05D9C9;
        Wed, 29 Apr 2020 09:36:40 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     x86@kernel.org, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH RFC 1/6] Revert "KVM: async_pf: Fix #DF due to inject "Page not Present" and "Page Ready" exceptions simultaneously"
Date:   Wed, 29 Apr 2020 11:36:29 +0200
Message-Id: <20200429093634.1514902-2-vkuznets@redhat.com>
In-Reply-To: <20200429093634.1514902-1-vkuznets@redhat.com>
References: <20200429093634.1514902-1-vkuznets@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 9a6e7c39810e (""KVM: async_pf: Fix #DF due to inject "Page not
Present" and "Page Ready" exceptions simultaneously") added a protection
against 'page ready' notification coming before 'page not ready' is
delivered. This situation seems to be impossible since commit 2a266f23550=
b
("KVM MMU: check pending exception before injecting APF) which added
'vcpu->arch.exception.pending' check to kvm_can_do_async_pf.

On x86, kvm_arch_async_page_present() has only one call site:
kvm_check_async_pf_completion() loop and we only enter the loop when
kvm_arch_can_inject_async_page_present(vcpu) which when async pf msr
is enabled, translates into kvm_can_do_async_pf().

There is also one problem with the cancellation mechanism. We don't seem
to check that the 'page not ready' notification we're cancelling matches
the 'page ready' notification so in theory, we may erroneously drop two
valid events.

Revert the commit. apf_get_user() stays as we will need it for the new
'page ready notifications via interrupt' mechanism.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/x86.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c5835f9cb9ad..b93133ee07ba 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10430,7 +10430,6 @@ void kvm_arch_async_page_present(struct kvm_vcpu =
*vcpu,
 				 struct kvm_async_pf *work)
 {
 	struct x86_exception fault;
-	u32 val;
=20
 	if (work->wakeup_all)
 		work->arch.token =3D ~0; /* broadcast wakeup */
@@ -10439,19 +10438,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu=
 *vcpu,
 	trace_kvm_async_pf_ready(work->arch.token, work->cr2_or_gpa);
=20
 	if (vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED &&
-	    !apf_get_user(vcpu, &val)) {
-		if (val =3D=3D KVM_PV_REASON_PAGE_NOT_PRESENT &&
-		    vcpu->arch.exception.pending &&
-		    vcpu->arch.exception.nr =3D=3D PF_VECTOR &&
-		    !apf_put_user(vcpu, 0)) {
-			vcpu->arch.exception.injected =3D false;
-			vcpu->arch.exception.pending =3D false;
-			vcpu->arch.exception.nr =3D 0;
-			vcpu->arch.exception.has_error_code =3D false;
-			vcpu->arch.exception.error_code =3D 0;
-			vcpu->arch.exception.has_payload =3D false;
-			vcpu->arch.exception.payload =3D 0;
-		} else if (!apf_put_user(vcpu, KVM_PV_REASON_PAGE_READY)) {
+	    !apf_put_user(vcpu, KVM_PV_REASON_PAGE_READY)) {
 			fault.vector =3D PF_VECTOR;
 			fault.error_code_valid =3D true;
 			fault.error_code =3D 0;
@@ -10459,7 +10446,6 @@ void kvm_arch_async_page_present(struct kvm_vcpu =
*vcpu,
 			fault.address =3D work->arch.token;
 			fault.async_page_fault =3D true;
 			kvm_inject_page_fault(vcpu, &fault);
-		}
 	}
 	vcpu->arch.apf.halted =3D false;
 	vcpu->arch.mp_state =3D KVM_MP_STATE_RUNNABLE;
--=20
2.25.3

