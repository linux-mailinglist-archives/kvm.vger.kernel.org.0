Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 730F51724FE
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 18:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730173AbgB0RXm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 12:23:42 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48070 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729948AbgB0RXl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Feb 2020 12:23:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582824220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a0y/j4KW7R+c8IZgk86JY7zUwSLsnh5fFNeVauypTJo=;
        b=FSJlJfFmYW3XCqTp1ACaMO5LIx14IRKFrvfwvgvJiMfBpwLnJaYPUqTArXQrWsqkBW2W4k
        GnNELN/i3OAAiPCiCzpx41M6M+7HdDKpy4Mac9okJEeIfIFdFRVg14r6cfXi2vDDt8nUSB
        5+DX+5ccuuhg7wvY5UbZ3cr/W2AtpqY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-fv0YXZNdMtuo_5rIlChthw-1; Thu, 27 Feb 2020 12:23:39 -0500
X-MC-Unique: fv0YXZNdMtuo_5rIlChthw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65951477;
        Thu, 27 Feb 2020 17:23:37 +0000 (UTC)
Received: from millenium-falcon.redhat.com (unknown [10.36.118.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 58CEE1001B2C;
        Thu, 27 Feb 2020 17:23:34 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, Mohammed Gamal <mgamal@redhat.com>
Subject: [PATCH 2/5] KVM: VMX: Add guest physical address check in EPT violation and misconfig
Date:   Thu, 27 Feb 2020 19:23:03 +0200
Message-Id: <20200227172306.21426-3-mgamal@redhat.com>
In-Reply-To: <20200227172306.21426-1-mgamal@redhat.com>
References: <20200227172306.21426-1-mgamal@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check guest physical address against it's maximum physical memory. If
the guest's physical address exceeds the maximum (i.e. has reserved bits
set), inject a guest page fault with PFERR_RSVD_MASK.

Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 63aaf44edd1f..477d196aa235 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5162,6 +5162,12 @@ static int handle_ept_violation(struct kvm_vcpu *v=
cpu)
 	gpa =3D vmcs_read64(GUEST_PHYSICAL_ADDRESS);
 	trace_kvm_page_fault(gpa, exit_qualification);
=20
+	/* Check if guest gpa doesn't exceed physical memory limits */
+	if (gpa >=3D (1ull << cpuid_maxphyaddr(vcpu))) {
+		kvm_inject_rsvd_bits_pf(vcpu, gpa);
+		return 1;
+	}
+
 	/* Is it a read fault? */
 	error_code =3D (exit_qualification & EPT_VIOLATION_ACC_READ)
 		     ? PFERR_USER_MASK : 0;
@@ -5193,6 +5199,13 @@ static int handle_ept_misconfig(struct kvm_vcpu *v=
cpu)
 	 * nGPA here instead of the required GPA.
 	 */
 	gpa =3D vmcs_read64(GUEST_PHYSICAL_ADDRESS);
+
+	/* Check if guest gpa doesn't exceed physical memory limits */
+	if (gpa >=3D (1ull << cpuid_maxphyaddr(vcpu))) {
+		kvm_inject_rsvd_bits_pf(vcpu, gpa);
+		return 1;
+	}
+
 	if (!is_guest_mode(vcpu) &&
 	    !kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS, gpa, 0, NULL)) {
 		trace_kvm_fast_mmio(gpa);
--=20
2.21.1

