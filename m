Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A20FC1724F9
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 18:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730326AbgB0RXr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 12:23:47 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45402 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730208AbgB0RXp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Feb 2020 12:23:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582824224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GBGqIAe5tQ+CoNzImDFl5ROAI2PVGdq9mwXBwBDnxFQ=;
        b=FdEqbwVRQ6K4IYpVTIqjfLW3DfBi2g5x3bOgLZfKOO4y6DRwhiAHBJNTNYIICCG3DXgVb1
        IlimCecBl4KcakKA5cxut5iLMRnXrWlcxltQ7lOQk79LByEFiS3E/RgC9OymhHNjulSyKb
        +ipll4RJugfI4P0W/xb2hJo/AREgFrU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-sKGeDTwYNXyFs6yUXn-1nw-1; Thu, 27 Feb 2020 12:23:42 -0500
X-MC-Unique: sKGeDTwYNXyFs6yUXn-1nw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C55198017CC;
        Thu, 27 Feb 2020 17:23:40 +0000 (UTC)
Received: from millenium-falcon.redhat.com (unknown [10.36.118.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DCB331001B2C;
        Thu, 27 Feb 2020 17:23:37 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, Mohammed Gamal <mgamal@redhat.com>
Subject: [PATCH 3/5] KVM: SVM: Add guest physical address check in NPF interception
Date:   Thu, 27 Feb 2020 19:23:04 +0200
Message-Id: <20200227172306.21426-4-mgamal@redhat.com>
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
 arch/x86/kvm/svm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ad3f5b178a03..facd9b0c9fb0 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2754,6 +2754,13 @@ static int npf_interception(struct vcpu_svm *svm)
 	u64 error_code =3D svm->vmcb->control.exit_info_1;
=20
 	trace_kvm_page_fault(fault_address, error_code);
+
+	/* Check if guest gpa doesn't exceed physical memory limits */
+	if (fault_address >=3D (1ull << cpuid_maxphyaddr(&svm->vcpu))) {
+		kvm_inject_rsvd_bits_pf(&svm->vcpu, fault_address);
+		return 1;
+	}
+
 	return kvm_mmu_page_fault(&svm->vcpu, fault_address, error_code,
 			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
 			svm->vmcb->control.insn_bytes : NULL,
--=20
2.21.1

