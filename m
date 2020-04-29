Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A462C1BD860
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 11:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgD2Jgz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 05:36:55 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48013 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbgD2Jgx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 05:36:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588153012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lZBfH0Jx4PF1hsdpN4RcVTKCHOwJWLp3oI6mwGy80qo=;
        b=EOXYebOE3ZqN6fV22BBDbmt4Mkqoag2Bixl+d//rsru4ldFZ3MduGoK2roZBzJ225ZhkzA
        GDOoQCmwLiVPS0nghIGSlzbEDlehfJNtnvjTFmgiGuJhQRQG88Z7k8rI3ANJ58qHXO/cTA
        cUyOzBERqDiHVE8F6tOEJ82GMuaU+Gs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-RdkrfyHiPUu6_mH5c_xKhw-1; Wed, 29 Apr 2020 05:36:49 -0400
X-MC-Unique: RdkrfyHiPUu6_mH5c_xKhw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F9A9800C78;
        Wed, 29 Apr 2020 09:36:47 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C9A915D9C9;
        Wed, 29 Apr 2020 09:36:44 +0000 (UTC)
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
Subject: [PATCH RFC 2/6] KVM: x86: extend struct kvm_vcpu_pv_apf_data with token info
Date:   Wed, 29 Apr 2020 11:36:30 +0200
Message-Id: <20200429093634.1514902-3-vkuznets@redhat.com>
In-Reply-To: <20200429093634.1514902-1-vkuznets@redhat.com>
References: <20200429093634.1514902-1-vkuznets@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, APF mechanism relies on the #PF abuse where the token is being
passed through CR2. If we switch to using interrupts to deliver page-read=
y
notifications we need a different way to pass the data. Extent the existi=
ng
'struct kvm_vcpu_pv_apf_data' with token information.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/uapi/asm/kvm_para.h |  3 ++-
 arch/x86/kvm/x86.c                   | 10 ++++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi=
/asm/kvm_para.h
index 2a8e0b6b9805..df2ba34037a2 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -113,7 +113,8 @@ struct kvm_mmu_op_release_pt {
=20
 struct kvm_vcpu_pv_apf_data {
 	__u32 reason;
-	__u8 pad[60];
+	__u32 token;
+	__u8 pad[56];
 	__u32 enabled;
 };
=20
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b93133ee07ba..7c21c0cf0a33 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2662,7 +2662,7 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *=
vcpu, u64 data)
 	}
=20
 	if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.apf.data, gpa,
-					sizeof(u32)))
+					sizeof(u64)))
 		return 1;
=20
 	vcpu->arch.apf.send_user_only =3D !(data & KVM_ASYNC_PF_SEND_ALWAYS);
@@ -10352,8 +10352,9 @@ static void kvm_del_async_pf_gfn(struct kvm_vcpu =
*vcpu, gfn_t gfn)
 	}
 }
=20
-static int apf_put_user(struct kvm_vcpu *vcpu, u32 val)
+static int apf_put_user(struct kvm_vcpu *vcpu, u32 reason, u32 token)
 {
+	u64 val =3D (u64)token << 32 | reason;
=20
 	return kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.apf.data, &val,
 				      sizeof(val));
@@ -10405,7 +10406,8 @@ void kvm_arch_async_page_not_present(struct kvm_v=
cpu *vcpu,
 	kvm_add_async_pf_gfn(vcpu, work->arch.gfn);
=20
 	if (kvm_can_deliver_async_pf(vcpu) &&
-	    !apf_put_user(vcpu, KVM_PV_REASON_PAGE_NOT_PRESENT)) {
+	    !apf_put_user(vcpu, KVM_PV_REASON_PAGE_NOT_PRESENT,
+			  work->arch.token)) {
 		fault.vector =3D PF_VECTOR;
 		fault.error_code_valid =3D true;
 		fault.error_code =3D 0;
@@ -10438,7 +10440,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu =
*vcpu,
 	trace_kvm_async_pf_ready(work->arch.token, work->cr2_or_gpa);
=20
 	if (vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED &&
-	    !apf_put_user(vcpu, KVM_PV_REASON_PAGE_READY)) {
+	    !apf_put_user(vcpu, KVM_PV_REASON_PAGE_READY, work->arch.token)) {
 			fault.vector =3D PF_VECTOR;
 			fault.error_code_valid =3D true;
 			fault.error_code =3D 0;
--=20
2.25.3

