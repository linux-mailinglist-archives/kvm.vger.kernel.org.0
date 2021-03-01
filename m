Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B861C327EAA
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 13:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbhCAMyM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 07:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235218AbhCAMyK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 07:54:10 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0051BC06178A
        for <kvm@vger.kernel.org>; Mon,  1 Mar 2021 04:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=xmz93cwfIQjZW14w+D3D6/AQJx8CfakKLGheckDukRs=; b=nttHqTn+ONxCuveGmoN9bUPk4r
        HiFG3gCVMZjdAev2lrWWcT33saCKgFJBK7XUOPzSGBQTdfZkCFWJ8IuaBWZ42vwJtszxt+j50dFME
        LwRO1aq/gtQ2k8vwgBHnBmPq9K85s2XeW8z5aSVF71I5S2pugGiKkcJK6sLwkDOcqiqLWU9OEGaRR
        mffz5dkLd9ah1bfpm6XkIN1nY1Z9nJK1U5G11o0erGPmtZ+bONluYS3pjd7utyR2ASB0HLlEa224C
        pWtMl8dTi3lcyd1nWiFA9SaK9u0yGSUYW3yGsm5WadN8ri8D5E9ZD3NtuRSXoMVUrEpmnTd/KOeFi
        f/rm1R5g==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lGi2y-00Fiya-3P; Mon, 01 Mar 2021 12:53:16 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lGi2w-003fcu-0J; Mon, 01 Mar 2021 12:53:10 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH 1/2] KVM: x86/xen: Fix return code when clearing vcpu_info and vcpu_time_info
Date:   Mon,  1 Mar 2021 12:53:08 +0000
Message-Id: <20210301125309.874953-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

When clearing the per-vCPU shared regions, set the return value to zero
to indicate success. This was causing spurious errors to be returned to
userspace on soft reset.

Also add a paranoid BUILD_BUG_ON() for compat structure compatibility.

Fixes: 0c165b3c01fe ("KVM: x86/xen: Allow reset of Xen attributes")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/xen.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index af8f6562fce4..77b20ff09078 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -187,9 +187,12 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		/* No compat necessary here. */
 		BUILD_BUG_ON(sizeof(struct vcpu_info) !=
 			     sizeof(struct compat_vcpu_info));
+		BUILD_BUG_ON(offsetof(struct vcpu_info, time) !=
+			     offsetof(struct compat_vcpu_info, time));
 
 		if (data->u.gpa == GPA_INVALID) {
 			vcpu->arch.xen.vcpu_info_set = false;
+			r = 0;
 			break;
 		}
 
@@ -206,6 +209,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO:
 		if (data->u.gpa == GPA_INVALID) {
 			vcpu->arch.xen.vcpu_time_info_set = false;
+			r = 0;
 			break;
 		}
 
-- 
2.29.2

