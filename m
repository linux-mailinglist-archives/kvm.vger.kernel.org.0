Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D268037C31A
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 17:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbhELPRW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 11:17:22 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:49050 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233532AbhELPOI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 11:14:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1620832380; x=1652368380;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=SU+g1QnEecCGtW6dIbozX2en41atljcTC+E2dUOIv3U=;
  b=msK0IhpfNt6O8BN1hps091DkYQ9A91nrqGCvW3O/aWqVwFsfotI84E59
   cShvj38t2bBKrKHa69EYEzBV7AnCdic1Ols43AS1y8oLkkbmopjoGm0Ft
   RLPw8B6aKSRpRtKaMA2/M82T5CHxCGqoD2K4aRv1+c9oIkrGMNR+wEbxp
   0=;
X-IronPort-AV: E=Sophos;i="5.82,293,1613433600"; 
   d="scan'208";a="932813016"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 12 May 2021 15:12:59 +0000
Received: from EX13MTAUEB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id DB4DE28039A;
        Wed, 12 May 2021 15:12:55 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 May 2021 15:12:23 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 May 2021 15:12:23 +0000
Received: from uae075a0dfd4c51.ant.amazon.com (10.106.82.24) by
 mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 12 May 2021 15:12:20 +0000
From:   Ilias Stamatis <ilstam@amazon.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <zamsden@gmail.com>, <mtosatti@redhat.com>, <dwmw@amazon.co.uk>,
        <ilstam@amazon.com>
Subject: [PATCH v2 04/10] KVM: VMX: Add a TSC multiplier field in VMCS12
Date:   Wed, 12 May 2021 16:09:39 +0100
Message-ID: <20210512150945.4591-5-ilstam@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210512150945.4591-1-ilstam@amazon.com>
References: <20210512150945.4591-1-ilstam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is required for supporting nested TSC scaling.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/vmcs12.c | 1 +
 arch/x86/kvm/vmx/vmcs12.h | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index 034adb6404dc..d9f5d7c56ae3 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -37,6 +37,7 @@ const unsigned short vmcs_field_to_offset_table[] = {
 	FIELD64(VM_ENTRY_MSR_LOAD_ADDR, vm_entry_msr_load_addr),
 	FIELD64(PML_ADDRESS, pml_address),
 	FIELD64(TSC_OFFSET, tsc_offset),
+	FIELD64(TSC_MULTIPLIER, tsc_multiplier),
 	FIELD64(VIRTUAL_APIC_PAGE_ADDR, virtual_apic_page_addr),
 	FIELD64(APIC_ACCESS_ADDR, apic_access_addr),
 	FIELD64(POSTED_INTR_DESC_ADDR, posted_intr_desc_addr),
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 13494956d0e9..bb81a23afe89 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -70,7 +70,8 @@ struct __packed vmcs12 {
 	u64 eptp_list_address;
 	u64 pml_address;
 	u64 encls_exiting_bitmap;
-	u64 padding64[2]; /* room for future expansion */
+	u64 tsc_multiplier;
+	u64 padding64[1]; /* room for future expansion */
 	/*
 	 * To allow migration of L1 (complete with its L2 guests) between
 	 * machines of different natural widths (32 or 64 bit), we cannot have
@@ -258,6 +259,7 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(eptp_list_address, 304);
 	CHECK_OFFSET(pml_address, 312);
 	CHECK_OFFSET(encls_exiting_bitmap, 320);
+	CHECK_OFFSET(tsc_multiplier, 328);
 	CHECK_OFFSET(cr0_guest_host_mask, 344);
 	CHECK_OFFSET(cr4_guest_host_mask, 352);
 	CHECK_OFFSET(cr0_read_shadow, 360);
-- 
2.17.1

