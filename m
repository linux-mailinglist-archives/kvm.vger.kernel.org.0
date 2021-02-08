Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19DD3143A8
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 00:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhBHXYN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 18:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbhBHXYL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 18:24:11 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1ACFC061786
        for <kvm@vger.kernel.org>; Mon,  8 Feb 2021 15:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=MQZKEBWdevU9Wtq5jy3eQdq2M/+JDldM/SAS8N901aU=; b=c8lCLbF6XXXOsBQF5IqcFR464R
        3SMggo34f3eXt5ujX2Ygsk66jB3ijss+QWmlJrLWnnhQPVwLeba+TWWDfQNtK9bktT2b7rW21LEZW
        RPyGTsyPVLwxj5ifCPwLyHKhVd8ggRqxpUX3tzb3uXxxbDfafjkQqM8abWubTOXIQNVPzZpMRk+ma
        udtgutqPSSRhPF4ezF1BET/qVfIzNOh5iG+LIuivDRi6AHfVzZd1bU1yGDfW3f6Ss9fa3PPJPhShq
        vizRmMRy8UiJ9QJ/6i+yN4wqp7lu3U9IfQTbDsg6ROEdTWhWL6IBl/JymY2UVbtTcOi2Dux7S+9S9
        0NcMSemQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l9FsO-0002eP-1f; Mon, 08 Feb 2021 23:23:28 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l9FsM-007gAr-Uu; Mon, 08 Feb 2021 23:23:26 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH 1/2] KVM: x86/xen: Allow reset of Xen attributes
Date:   Mon,  8 Feb 2021 23:23:25 +0000
Message-Id: <20210208232326.1830370-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

In order to support Xen SHUTDOWN_soft_reset (for guest kexec, etc.) the
VMM needs to be able to tear everything down and return the Xen features
to a clean slate.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/xen.c | 38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 39a7ffcdcf22..06fec10ffc4f 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -118,12 +118,17 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		break;
 
 	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
+		if (data->u.shared_info.gfn == GPA_INVALID) {
+			kvm->arch.xen.shinfo_set = false;
+			r = 0;
+			break;
+		}
 		r = kvm_xen_shared_info_init(kvm, data->u.shared_info.gfn);
 		break;
 
 
 	case KVM_XEN_ATTR_TYPE_UPCALL_VECTOR:
-		if (data->u.vector < 0x10)
+		if (data->u.vector && data->u.vector < 0x10)
 			r = -EINVAL;
 		else {
 			kvm->arch.xen.upcall_vector = data->u.vector;
@@ -152,10 +157,11 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		break;
 
 	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
-		if (kvm->arch.xen.shinfo_set) {
+		if (kvm->arch.xen.shinfo_set)
 			data->u.shared_info.gfn = gpa_to_gfn(kvm->arch.xen.shinfo_cache.gpa);
-			r = 0;
-		}
+		else
+			data->u.shared_info.gfn = GPA_INVALID;
+		r = 0;
 		break;
 
 	case KVM_XEN_ATTR_TYPE_UPCALL_VECTOR:
@@ -184,6 +190,11 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		BUILD_BUG_ON(sizeof(struct vcpu_info) !=
 			     sizeof(struct compat_vcpu_info));
 
+		if (data->u.gpa == GPA_INVALID) {
+			vcpu->arch.xen.vcpu_info_set = false;
+			break;
+		}
+
 		r = kvm_gfn_to_hva_cache_init(vcpu->kvm,
 					      &vcpu->arch.xen.vcpu_info_cache,
 					      data->u.gpa,
@@ -195,6 +206,11 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		break;
 
 	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO:
+		if (data->u.gpa == GPA_INVALID) {
+			vcpu->arch.xen.vcpu_time_info_set = false;
+			break;
+		}
+
 		r = kvm_gfn_to_hva_cache_init(vcpu->kvm,
 					      &vcpu->arch.xen.vcpu_time_info_cache,
 					      data->u.gpa,
@@ -222,17 +238,19 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 
 	switch (data->type) {
 	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO:
-		if (vcpu->arch.xen.vcpu_info_set) {
+		if (vcpu->arch.xen.vcpu_info_set)
 			data->u.gpa = vcpu->arch.xen.vcpu_info_cache.gpa;
-			r = 0;
-		}
+		else
+			data->u.gpa = GPA_INVALID;
+		r = 0;
 		break;
 
 	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO:
-		if (vcpu->arch.xen.vcpu_time_info_set) {
+		if (vcpu->arch.xen.vcpu_time_info_set)
 			data->u.gpa = vcpu->arch.xen.vcpu_time_info_cache.gpa;
-			r = 0;
-		}
+		else
+			data->u.gpa = GPA_INVALID;
+		r = 0;
 		break;
 
 	default:
-- 
2.29.2

