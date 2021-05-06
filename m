Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC0637526D
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 12:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234540AbhEFKfY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 06:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234541AbhEFKfU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 06:35:20 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2B4C061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 03:34:21 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4FbVLh02K8zQjZ5;
        Thu,  6 May 2021 12:34:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        references:in-reply-to:message-id:date:date:subject:subject:from
        :from:received; s=mail20150812; t=1620297256; bh=O1U40Dm7VUdNCxB
        xbT9Ep1tJ7ZE9uqMfLstqOCkOmBw=; b=nnw1RoeckY1ckPDC+bqhzcjJQZUrmIL
        eFraoSGitETnCUrv/LypXHgdnIn0NDALC6KJxVtnf+mVYnOzKOKLQG8mKPGqX6KU
        QYa6oLXAe/lFzilWSgW44MQbIwKpQe8Y1iaVR0jEuTlYKK6pzp+8SdFbjrSvj5iX
        DQi+Vy1LTDzUhx1G3VVtXSPn80NtgGvXW1Wt4Nhf4uO5ZnJY0q+j/BUPi6Rbv1Z3
        sT8u+6FnMhlgE0Y3q9BaJMRtQPXrtpZ5CwIveMXhooCu9My0ulkkaCBtrENdST6E
        siSQf6PIrqarRTAfvr5p00CdThvdcicpJScWw6Pf1HXE+nQ1TE/nqPA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1620297258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=qjOhqsiDQgqlteS3wIV66YcLaaLpsfhzSy7BfJnvIUg=;
        b=X9l6wEIIAUdLG/AgVDAo62q+JMaWVbb8hfdrOsDKQBzvlkqCIY9ECzSJcomxvW+x1AxgP4
        cbbC0s67nwHfDItSzqP5lJrn0Yo+94wrq4VLUwo5Q4bR3X3QGnlOOjBffcnNUA2ssK+Mdo
        CqqpfoSAnuVPs4eXc5MMIgaVTHh6ja5O9cqqkVC0aU4GcMzu0c9xw78UPrdtwfcuT0howq
        +/IRxrV/Ywu1RW+LQnC8DRZCu9lbe224gsu22bTPIaNFMFS0Ewfjp17nLOjQnxJ2kgaxRT
        F1gq1KWR2iLaC0Zoh9R8h/B8cKp1TETjZIA+jwE3utGbxnuUzVpy1eA48b6FPg==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id q8HnZlNLg9YY; Thu,  6 May 2021 12:34:16 +0200 (CEST)
From:   ilstam@mailbox.org
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     ilstam@amazon.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        haozhong.zhang@intel.com, zamsden@gmail.com, mtosatti@redhat.com,
        dplotnikov@virtuozzo.com, dwmw@amazon.co.uk
Subject: [PATCH 1/8] KVM: VMX: Add a TSC multiplier field in VMCS12
Date:   Thu,  6 May 2021 10:32:21 +0000
Message-Id: <20210506103228.67864-2-ilstam@mailbox.org>
In-Reply-To: <20210506103228.67864-1-ilstam@mailbox.org>
References: <20210506103228.67864-1-ilstam@mailbox.org>
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -4.11 / 15.00 / 15.00
X-Rspamd-Queue-Id: F42331891
X-Rspamd-UID: 13f4ac
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ilias Stamatis <ilstam@amazon.com>

This is required for supporting nested TSC scaling.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
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

