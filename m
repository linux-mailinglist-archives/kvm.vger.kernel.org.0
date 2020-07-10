Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E127821B9EE
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 17:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbgGJPtI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 11:49:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37694 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728186AbgGJPss (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 11:48:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594396126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s55KbT4R57P+BEAchl+rWHLC1vvToduMPconk2T3z5s=;
        b=ZAiG0LAqewl8cssq1N0P1WJ35J1rmXlJPnniLNKKVg2Ru8kYS0/79WI+mNoJhLPc1PO15l
        jph+EAFT4MHq2T1Av3hu6vL3wULbqxRZT7Z1K2tU5EwjQTCKfyAwBtbgVlelfn4V8IsV+e
        RJD0efTk73Duk/Bhsou0s9FDJJQh21A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-lzwJa4KCN9OgiEYWiLyzSw-1; Fri, 10 Jul 2020 11:48:45 -0400
X-MC-Unique: lzwJa4KCN9OgiEYWiLyzSw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEC5B193F560;
        Fri, 10 Jul 2020 15:48:43 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-114-235.ams2.redhat.com [10.36.114.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 324055BAC3;
        Fri, 10 Jul 2020 15:48:42 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
Subject: [PATCH v3 8/9] KVM: VMX: optimize #PF injection when MAXPHYADDR does not match
Date:   Fri, 10 Jul 2020 17:48:10 +0200
Message-Id: <20200710154811.418214-9-mgamal@redhat.com>
In-Reply-To: <20200710154811.418214-1-mgamal@redhat.com>
References: <20200710154811.418214-1-mgamal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

Ignore non-present page faults, since those cannot have reserved
bits set.

When running access.flat with "-cpu Haswell,phys-bits=36", the
number of trapped page faults goes down from 8872644 to 3978948.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index de3f436b2d32..0cebc4832805 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4355,6 +4355,16 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmx->pt_desc.guest.output_mask = 0x7F;
 		vmcs_write64(GUEST_IA32_RTIT_CTL, 0);
 	}
+
+	/*
+	 * If EPT is enabled, #PF is only trapped if MAXPHYADDR is mismatched
+	 * between guest and host.  In that case we only care about present
+	 * faults.
+	 */
+	if (enable_ept) {
+		vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, PFERR_PRESENT_MASK);
+		vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, PFERR_PRESENT_MASK);
+	}
 }
 
 static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
-- 
2.26.2

