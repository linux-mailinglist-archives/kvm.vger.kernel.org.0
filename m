Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7B3201164
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 17:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392008AbgFSPlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 11:41:16 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20936 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2393895AbgFSPkL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 11:40:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592581210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SOfOPV+bdXo7ikGMHzW5QOm7ZJeCM7qYVz4ijnYJn9I=;
        b=MdpIJjh5K1sn5rKOlBqHrVgc3qwCNwjE7tLk4s7p35g9Njz0Ij0E+M1Zfv7LmOtNsbtAiq
        D3VgkueMH+YkeKaurqU7DxY5znbzPMUPd7HRNGRrupyVwAH/7CW0sSG9jC1yNQNM3vtWap
        q22S/IATQoFHRzczrIfhurvECGa/nOI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-CFnl1TpjP5uRKIsb9979Fg-1; Fri, 19 Jun 2020 11:40:08 -0400
X-MC-Unique: CFnl1TpjP5uRKIsb9979Fg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB77F835B48;
        Fri, 19 Jun 2020 15:40:06 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D4A860BF4;
        Fri, 19 Jun 2020 15:40:04 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, thomas.lendacky@amd.com,
        babu.moger@amd.com
Subject: [PATCH v2 08/11] KVM: VMX: optimize #PF injection when MAXPHYADDR does not match
Date:   Fri, 19 Jun 2020 17:39:22 +0200
Message-Id: <20200619153925.79106-9-mgamal@redhat.com>
In-Reply-To: <20200619153925.79106-1-mgamal@redhat.com>
References: <20200619153925.79106-1-mgamal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
index f38cbadcb3a5..8daf78b2d4cb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4358,6 +4358,16 @@ static void init_vmcs(struct vcpu_vmx *vmx)
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

