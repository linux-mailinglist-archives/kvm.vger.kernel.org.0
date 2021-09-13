Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F924092AC
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 16:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343964AbhIMONh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 10:13:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59183 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344186AbhIMOLd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Sep 2021 10:11:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631542217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rOIleuW7ntxBl5bDlUbNb+ctoG6rTIoi5sLSfP0Cy3w=;
        b=CwpWHBTUOOvOdnhGnDmEzDUg1sJjZFrYUc09MNlCzaHCUUSYOD3K/UV6X5sjCNs/IUmblR
        oBd9s6X48M95N4Fbye72huarSI4n/x3edw5Upq2m3CknhLxaDkjk/xI/EA4+2piFgWBxYk
        YB2B8qiJSBGAtreH7WlZBJ9qPBthIX8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-Unp0dlGhPw-Ra3D_YOxMKQ-1; Mon, 13 Sep 2021 10:10:16 -0400
X-MC-Unique: Unp0dlGhPw-Ra3D_YOxMKQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E508835DE2;
        Mon, 13 Sep 2021 14:10:14 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0853B19724;
        Mon, 13 Sep 2021 14:10:07 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v3 3/7] KVM: x86: reset pdptrs_from_userspace when exiting smm
Date:   Mon, 13 Sep 2021 17:09:50 +0300
Message-Id: <20210913140954.165665-4-mlevitsk@redhat.com>
In-Reply-To: <20210913140954.165665-1-mlevitsk@redhat.com>
References: <20210913140954.165665-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When exiting SMM, pdpts are loaded again from the guest memory.

This fixes a theoretical bug, when exit from SMM triggers entry to the
nested guest which re-uses some of the migration
code which uses this flag as a workaround for a legacy userspace.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 86539c1686fa..3a61f19455cb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7654,6 +7654,13 @@ static void kvm_smm_changed(struct kvm_vcpu *vcpu, bool entering_smm)
 
 		/* Process a latched INIT or SMI, if any.  */
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
+
+		/*
+		 * Even if KVM_SET_SREGS2 loaded PDPTRs out of band,
+		 * on SMM exit we still need to reload them from
+		 * guest memory
+		 */
+		vcpu->arch.pdptrs_from_userspace = false;
 	}
 
 	kvm_mmu_reset_context(vcpu);
-- 
2.26.3

