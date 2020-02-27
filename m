Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68786172500
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 18:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730395AbgB0RXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 12:23:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45777 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730315AbgB0RXs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 12:23:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582824227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SlDjxm+2B5grDvGMES0JlUQIqTF3CpfqhZ7QZEVAnzs=;
        b=iy13O7LA5C3mcxLNPt+8KuzK7LpddD/P964NhMQpB9Syln/7H2btkCCYIwxOcz1tCl1See
        q0EPIBh9aM+fhJOXl2Y4I+U8p+I5ay3KlGk65KJQGrHWAtgY+8RQXiTj80YmkHTOOisxdr
        n6SIVq2vms/gkN/42X5LsJ6eYWZ9usE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-Ep8BXDX_MNi_g4ftkKwDLQ-1; Thu, 27 Feb 2020 12:23:45 -0500
X-MC-Unique: Ep8BXDX_MNi_g4ftkKwDLQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 392EF13F5;
        Thu, 27 Feb 2020 17:23:44 +0000 (UTC)
Received: from millenium-falcon.redhat.com (unknown [10.36.118.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46D02101D48A;
        Thu, 27 Feb 2020 17:23:41 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, Mohammed Gamal <mgamal@redhat.com>
Subject: [PATCH 4/5] KVM: x86: mmu: Move translate_gpa() to mmu.c
Date:   Thu, 27 Feb 2020 19:23:05 +0200
Message-Id: <20200227172306.21426-5-mgamal@redhat.com>
In-Reply-To: <20200227172306.21426-1-mgamal@redhat.com>
References: <20200227172306.21426-1-mgamal@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Also no point of it being inline since it's always called through
function pointers. So remove that.

Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 6 ------
 arch/x86/kvm/mmu/mmu.c          | 6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
index 98959e8cd448..683663b437e6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1515,12 +1515,6 @@ void kvm_mmu_new_cr3(struct kvm_vcpu *vcpu, gpa_t =
new_cr3, bool skip_tlb_flush);
 void kvm_enable_tdp(void);
 void kvm_disable_tdp(void);
=20
-static inline gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 =
access,
-				  struct x86_exception *exception)
-{
-	return gpa;
-}
-
 static inline struct kvm_mmu_page *page_header(hpa_t shadow_page)
 {
 	struct page *page =3D pfn_to_page(shadow_page >> PAGE_SHIFT);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 87e9ba27ada1..099643edfdeb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -520,6 +520,12 @@ static bool check_mmio_spte(struct kvm_vcpu *vcpu, u=
64 spte)
 	return likely(kvm_gen =3D=3D spte_gen);
 }
=20
+static gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
+                                  struct x86_exception *exception)
+{
+        return gpa;
+}
+
 /*
  * Sets the shadow PTE masks used by the MMU.
  *
--=20
2.21.1

