Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD46172502
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 18:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730414AbgB0RX4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 12:23:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23750 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730404AbgB0RXz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 12:23:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582824234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6XC36jUNMrRkhe8v5qZn1zVMtVX2JPkjS3b1Prtcpv4=;
        b=VAtT8x1xtlsjQTp1WTDDwnFC/pqkHt4cUFRigyaJkyjO5whVYYP9VJkIkwriXHf9k32F+c
        NqnetouCVnf2dc6zN+rdSfK4FXFsm2sAcayVHrZmXat9Ulw+/Y9MOpWcbAi4Z11tJ5g7EF
        udbFGjsfWIR05/etBrivqr6ot/Vseu0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-ezsQoYhqMwCkTfO-IVeMCg-1; Thu, 27 Feb 2020 12:23:53 -0500
X-MC-Unique: ezsQoYhqMwCkTfO-IVeMCg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6812F107ACCA;
        Thu, 27 Feb 2020 17:23:50 +0000 (UTC)
Received: from millenium-falcon.redhat.com (unknown [10.36.118.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AEC9C1001B2C;
        Thu, 27 Feb 2020 17:23:44 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, Mohammed Gamal <mgamal@redhat.com>
Subject: [PATCH 5/5] KVM: x86: mmu: Add guest physical address check in translate_gpa()
Date:   Thu, 27 Feb 2020 19:23:06 +0200
Message-Id: <20200227172306.21426-6-mgamal@redhat.com>
In-Reply-To: <20200227172306.21426-1-mgamal@redhat.com>
References: <20200227172306.21426-1-mgamal@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In case of running a guest with 4-level page tables on a 5-level page
table host, it might happen that a guest might have a physical address
with reserved bits set, but the host won't see that and trap it.

Hence, we need to check page faults' physical addresses against the guest=
's
maximum physical memory and if it's exceeded, we need to add
the PFERR_RSVD_MASK bits to the PF's error code.

Also make sure the error code isn't overwritten by the page table walker.

Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c         | 4 ++++
 arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 099643edfdeb..994e8377b65f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -523,6 +523,10 @@ static bool check_mmio_spte(struct kvm_vcpu *vcpu, u=
64 spte)
 static gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
                                   struct x86_exception *exception)
 {
+	/* Check if guest physical address doesn't exceed guest maximum */
+	if (gpa >=3D (1ull << cpuid_maxphyaddr(vcpu)))
+		exception->error_code |=3D PFERR_RSVD_MASK;
+
         return gpa;
 }
=20
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmp=
l.h
index e4c8a4cbf407..aa3db722604b 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -476,7 +476,7 @@ static int FNAME(walk_addr_generic)(struct guest_walk=
er *walker,
=20
 	walker->fault.vector =3D PF_VECTOR;
 	walker->fault.error_code_valid =3D true;
-	walker->fault.error_code =3D errcode;
+	walker->fault.error_code |=3D errcode;
=20
 #if PTTYPE =3D=3D PTTYPE_EPT
 	/*
--=20
2.21.1

