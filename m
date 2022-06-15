Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE74A54C90F
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 14:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349152AbiFOMuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 08:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349140AbiFOMta (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 08:49:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 99E0C2BB22
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 05:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655297366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qqM0GdHyxcksDuwznBTEVlvia7GmEG1xLhXl8yuf6VA=;
        b=Nzk6jhZV10Zx/otbVJUwbzz1P4eRuYIef0WwWSF14hfM8MUZgBD/BgPR2XfDYEkwE0ncrv
        CQTkAC3KCGx/U+cYR6Vi0cKvnJ7ecoOWxcvWjH52hG0WE0vkEkKdz5IGShdxKTOGZezwiJ
        hX68fYpCuLwAxYoIYP9WUACc+SwVGH0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-c0diFBA1OtiNmiY8QPvf3Q-1; Wed, 15 Jun 2022 08:49:23 -0400
X-MC-Unique: c0diFBA1OtiNmiY8QPvf3Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6AC3185A79C;
        Wed, 15 Jun 2022 12:49:22 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA5A3401E68;
        Wed, 15 Jun 2022 12:49:20 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC v1 2/5] x86/hyperv: Update 'struct hv_enlightened_vmcs' definition
Date:   Wed, 15 Jun 2022 14:49:12 +0200
Message-Id: <20220615124915.3068295-3-vkuznets@redhat.com>
In-Reply-To: <20220615124915.3068295-1-vkuznets@redhat.com>
References: <20220615124915.3068295-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Updated Hyper-V Enlightened VMCS specification lists several new
fields for the following features:

- PerfGlobalCtrl
- EnclsExitingBitmap
- Tsc Scaling
- GuestLbrCtl
- CET
- SSP

Update the definition.

Note: The latest TLFS is available at
https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/tlfs

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/hyperv-tlfs.h | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 6f0acc45e67a..fd334e8defb7 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -559,9 +559,20 @@ struct hv_enlightened_vmcs {
 	u64 partition_assist_page;
 	u64 padding64_4[4];
 	u64 guest_bndcfgs;
-	u64 padding64_5[7];
+	u64 guest_ia32_perf_global_ctrl;
+	u64 guest_ia32_s_cet;
+	u64 guest_ssp;
+	u64 guest_ia32_int_ssp_table_addr;
+	u64 guest_ia32_lbr_ctl;
+	u64 padding64_5[2];
 	u64 xss_exit_bitmap;
-	u64 padding64_6[7];
+	u64 host_ia32_perf_global_ctrl;
+	u64 encls_exiting_bitmap;
+	u64 tsc_multiplier;
+	u64 host_ia32_s_cet;
+	u64 host_ssp;
+	u64 host_ia32_int_ssp_table_addr;
+	u64 padding64_6;
 } __packed;
 
 #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE			0
-- 
2.35.3

