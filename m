Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1D9319520
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 22:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhBKVZc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 16:25:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38912 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229553AbhBKVZb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Feb 2021 16:25:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613078645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ADT06ck/6Xn7ictWiXc1dStSUqWO1AGKXN0MDBeaO8=;
        b=gp4WiEKKlnZpmh6Kv5WFgof+b+mcduenxrs8PMIE+B6dbRTFOXiHOUTBSoJ9qIj7H2DawC
        +WPLI8/vkmyWLRDtYWRgnB+1tOoOaibIa0LBoGZADBcqSlnAALu0vD4WwgbH1DQ3qC20sd
        k8+ATuSg8eIVkexffeXeI3wC8fkmZmc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-1n-ftOs4MFiND3SBrnspKw-1; Thu, 11 Feb 2021 16:24:03 -0500
X-MC-Unique: 1n-ftOs4MFiND3SBrnspKw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6868A107ACE3;
        Thu, 11 Feb 2021 21:24:02 +0000 (UTC)
Received: from gigantic.usersys.redhat.com (helium.bos.redhat.com [10.18.17.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDCAE60BF1;
        Thu, 11 Feb 2021 21:24:01 +0000 (UTC)
From:   Bandan Das <bsd@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, wei.huang2@amd.com,
        babu.moger@amd.com
Subject: [PATCH 3/3] KVM: SVM:  check if we need to track GP intercept for invpcid
Date:   Thu, 11 Feb 2021 16:22:39 -0500
Message-Id: <20210211212241.3958897-4-bsd@redhat.com>
In-Reply-To: <20210211212241.3958897-1-bsd@redhat.com>
References: <20210211212241.3958897-1-bsd@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is only set when the feature is available on the host
but the guest has disabled it, this will allow us to inject
the correct exception to the guest

Signed-off-by: Bandan Das <bsd@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0e8ce7adb815..2ecbf9bc929f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1102,6 +1102,7 @@ static u64 svm_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 
 static void svm_check_invpcid(struct vcpu_svm *svm)
 {
+	struct kvm_vcpu *vcpu = &svm->vcpu;
 	/*
 	 * Intercept INVPCID instruction only if shadow page table is
 	 * enabled. Interception is not required with nested page table
@@ -1112,6 +1113,16 @@ static void svm_check_invpcid(struct vcpu_svm *svm)
 			svm_set_intercept(svm, INTERCEPT_INVPCID);
 		else
 			svm_clr_intercept(svm, INTERCEPT_INVPCID);
+		/*
+		 * For CPL <> 0, #GP takes priority over intercepts.
+		 * This means that if invpcid is present but guest has disabled
+		 * it, it might end up getting a #GP instead of #UD
+		 * Let kvm inject the correct exception instead.
+		 */
+		if (!guest_cpuid_has(vcpu, X86_FEATURE_INVPCID))
+			set_exception_intercept(svm, GP_VECTOR);
+		else
+			clr_exception_intercept(svm, GP_VECTOR);
 	}
 }
 
-- 
2.24.1

