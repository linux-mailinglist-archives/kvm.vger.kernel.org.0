Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8CBE57482B
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 11:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbiGNJOP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 05:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237780AbiGNJN7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 05:13:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EE36313F01
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 02:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657790031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NkdjbmoNnDxWYR3z6tS+XiCrlq2oKH7PyMNJMWXhrn0=;
        b=Zybwt3t1ZzplmEmxUdg0wwbT2E/Gfedrqi3r/Gnx1Rfla57B1BIE86CgigOhv4iQckbBQP
        zXjGSlS8SW1BxHd5A46RugXH73MbdDKH5vYbbJdiq4baxVkenaZceFIY4/NQ3HKtjBY7Gx
        lJj2mpuOrvXjLEZqDdAvFJzIcA+C7es=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-489-azQKX1tZOVuTouxp4747rQ-1; Thu, 14 Jul 2022 05:13:50 -0400
X-MC-Unique: azQKX1tZOVuTouxp4747rQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5BBF885A581;
        Thu, 14 Jul 2022 09:13:50 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 152152166B2A;
        Thu, 14 Jul 2022 09:13:47 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 08/25] KVM: selftests: Switch to updated eVMCSv1 definition
Date:   Thu, 14 Jul 2022 11:13:10 +0200
Message-Id: <20220714091327.1085353-9-vkuznets@redhat.com>
In-Reply-To: <20220714091327.1085353-1-vkuznets@redhat.com>
References: <20220714091327.1085353-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update Enlightened VMCS definition in selftests from KVM.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/include/x86_64/evmcs.h      | 45 +++++++++++++++++--
 1 file changed, 42 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/evmcs.h b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
index 3c9260f8e116..58db74f68af2 100644
--- a/tools/testing/selftests/kvm/include/x86_64/evmcs.h
+++ b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
@@ -203,14 +203,25 @@ struct hv_enlightened_vmcs {
 		u32 reserved:30;
 	} hv_enlightenments_control;
 	u32 hv_vp_id;
-
+	u32 padding32_2;
 	u64 hv_vm_id;
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
+	u64 encls_exiting_bitmap;
+	u64 host_ia32_perf_global_ctrl;
+	u64 tsc_multiplier;
+	u64 host_ia32_s_cet;
+	u64 host_ssp;
+	u64 host_ia32_int_ssp_table_addr;
+	u64 padding64_6;
 };
 
 #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE                     0
@@ -656,6 +667,18 @@ static inline int evmcs_vmread(uint64_t encoding, uint64_t *value)
 	case VIRTUAL_PROCESSOR_ID:
 		*value = current_evmcs->virtual_processor_id;
 		break;
+	case HOST_IA32_PERF_GLOBAL_CTRL:
+		*value = current_evmcs->host_ia32_perf_global_ctrl;
+		break;
+	case GUEST_IA32_PERF_GLOBAL_CTRL:
+		*value = current_evmcs->guest_ia32_perf_global_ctrl;
+		break;
+	case ENCLS_EXITING_BITMAP:
+		*value = current_evmcs->encls_exiting_bitmap;
+		break;
+	case TSC_MULTIPLIER:
+		*value = current_evmcs->tsc_multiplier;
+		break;
 	default: return 1;
 	}
 
@@ -1169,6 +1192,22 @@ static inline int evmcs_vmwrite(uint64_t encoding, uint64_t value)
 		current_evmcs->virtual_processor_id = value;
 		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_XLAT;
 		break;
+	case HOST_IA32_PERF_GLOBAL_CTRL:
+		current_evmcs->host_ia32_perf_global_ctrl = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1;
+		break;
+	case GUEST_IA32_PERF_GLOBAL_CTRL:
+		current_evmcs->guest_ia32_perf_global_ctrl = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1;
+		break;
+	case ENCLS_EXITING_BITMAP:
+		current_evmcs->encls_exiting_bitmap = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2;
+		break;
+	case TSC_MULTIPLIER:
+		current_evmcs->tsc_multiplier = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2;
+		break;
 	default: return 1;
 	}
 
-- 
2.35.3

