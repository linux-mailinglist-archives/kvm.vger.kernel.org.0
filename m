Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21014674541
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 22:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjASVxs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 16:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbjASVxI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 16:53:08 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C536AEDB3
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:34:32 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id f132-20020a636a8a000000b00473d0b600ebso1587404pgc.14
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LXeEK1Kbvuk2JPbM8yD6qcpUOvIqc9ntM80OCtFV2Pc=;
        b=tEnmvnxM4IUmcMY9AKBYh9I/Rb/pEUtEZLgiNEf9uIgLM6z7B0M3Ah9ot6TwzUuIr2
         IB88l1wTD/fGBUWpxzoxMrnUq0Z+euhdRafpokJhocLPNGvD8ZS5i0pJsQzUh9Nm767/
         2JcHdDTv3QxeKaBorqwNJrpHXz4Xq6HIbVTLhTn5UbUtr3vFz2vWAQHv/45NPj9kPVJv
         x/bFoLggsTCaG1VuKdEQVw8DBhUVAghU2vxJqj0Nb2ZcARsToZMoeUY8trThDvkHpkHp
         0VS2+QpFK6YTVWz338kYVSUUte8vAo2wBreh98p1mmsmRZ4z6RPuZOBjhenTXU6xr6IU
         h2GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LXeEK1Kbvuk2JPbM8yD6qcpUOvIqc9ntM80OCtFV2Pc=;
        b=XSCoiXEZS2n3lNVQS9ZeYSOXu4PP0dshA95rerx1wZcjri8K5lYhKuQ+PbaLKx7IeH
         I77aQfsRh6viQPlNglB9Cr5xmV4APTJUSjB9VsN8rptG8xwOgESipe86ZLrOlGNHwGWO
         05xrcmIdW6/giiZFvO2zgsHV7/9MwZg+oexIhIVBeWdBtQrI7mn6TFqoOml+qdpV2ZNm
         imSgZrrTGKdKh8MYmkgn2PVmon8GfG3FVmz9G3hzn7J8rp/NcwEvEzehR9O+9Q1RszkI
         k8l3pE9VmlZl7gPiDzsU8FJg12PrGfNwrlsua3qRJZRMwUpiZBhB60PyCbMUzl4Kn7Qi
         bIEQ==
X-Gm-Message-State: AFqh2kqwFFV3tr+QOj+J9q39J1Qpha7QOCp2xWhCcgl4BagBpx8Hqv7l
        oy73JkyMk23b3Zjb9emJ8fNP+3jpsNm/Ei7dQ48vsRHL3URNG6KcvC1FnLsWFtX0zVrV5mY+4HL
        JQs3Y0p6ZL37IUnBjmiGmoeXvTC7yVdZATtbVLsD+6JGpsI7/lNWC8dk7IwkxaSjPhbSe6x8=
X-Google-Smtp-Source: AMrXdXtKk5XbMAdLQ8flQVxvy7BwTRsUbrJFrpNJeEnd82CJpiPjGzKPwBaraCWcPBUq3FvyH037KosXyJOkWQePsg==
X-Received: from dionnaglaze.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2ee6])
 (user=dionnaglaze job=sendgmr) by 2002:aa7:9727:0:b0:58c:1d0d:f1a6 with SMTP
 id k7-20020aa79727000000b0058c1d0df1a6mr1268749pfg.2.1674164070881; Thu, 19
 Jan 2023 13:34:30 -0800 (PST)
Date:   Thu, 19 Jan 2023 21:34:24 +0000
In-Reply-To: <20230119213426.379312-1-dionnaglaze@google.com>
Mime-Version: 1.0
References: <20230119213426.379312-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230119213426.379312-2-dionnaglaze@google.com>
Subject: [PATCH v3 1/2] kvm: sev: Add SEV-SNP guest request throttling
From:   Dionna Glaze <dionnaglaze@google.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Dionna Glaze <dionnaglaze@google.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <jroedel@suse.de>,
        Peter Gonda <pgonda@google.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The AMD-SP is a precious resource that doesn't have a scheduler other
than a mutex lock queue. To avoid customers from causing a DoS, a
module_param-set rate limit is added with a default of 2 requests
per 2 seconds.

These defaults were chosen empirically with a the assumption that
current server-grade SEV-SNP machines will rarely exceed 128 VMs under
usual circumstance.

The 2 burst per 2 seconds means on average 1 request every second. We
allow 2 requests back to back to allow for the guest to query the
certificate length in an extended guest request without a pause. The
1 second average is our target for quality of service since empirical
tests show that 64 VMs can concurrently request an attestation report
with a maximum latency of 1 second. We don't anticipate more
concurrency than that for a seldom used request for a majority well-
behaved set of VMs. The majority point is decided as >64 VMs given
the assumed 128 VM count for "extreme load".

The throttling code is 2 << 32 given that invalid length is 1 and 2 is
the next available code. This was suggested by Tom Lendacky, and will
be included in a new revision of the GHCB specification.

Cc: Thomas Lendacky <Thomas.Lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Peter Gonda <pgonda@google.com>
Cc: Borislav Petkov <bp@alien8.de>

Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
---
 arch/x86/include/asm/sev-common.h |  1 +
 arch/x86/kvm/svm/sev.c            | 29 +++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h            |  3 +++
 include/uapi/linux/in.h           |  1 +
 4 files changed, 34 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 1b111cde8c82..e3a6b039480d 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -158,6 +158,7 @@ struct snp_psc_desc {
 
 /* Guest message request error code */
 #define SNP_GUEST_REQ_INVALID_LEN	BIT_ULL(32)
+#define SNP_GUEST_REQ_THROTTLED		(((u64)2) << 32)
 
 #define GHCB_MSR_TERM_REQ		0x100
 #define GHCB_MSR_TERM_REASON_SET_POS	12
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d0e58cffd1ed..cd9372ce6fc2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -58,6 +58,14 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
 /* enable/disable SEV-SNP support */
 static bool sev_snp_enabled = true;
 module_param_named(sev_snp, sev_snp_enabled, bool, 0444);
+
+/* Throttle guest requests to a burst # per this many seconds */
+unsigned int guest_request_throttle_s = 2;
+module_param(guest_request_throttle_s, int, 0444);
+
+/* Throttle guest requests to this many per the above many seconds */
+unsigned int guest_request_throttle_burst = 2;
+module_param(guest_request_throttle_burst, int, 0444);
 #else
 #define sev_enabled false
 #define sev_es_enabled false
@@ -333,6 +341,9 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 			goto e_free;
 
 		mutex_init(&sev->guest_req_lock);
+		ratelimit_state_init(&sev->snp_guest_msg_rs,
+				guest_request_throttle_s * HZ,
+				guest_request_throttle_burst);
 		ret = sev_snp_init(&argp->error, false);
 	} else {
 		ret = sev_platform_init(&argp->error);
@@ -3595,6 +3606,14 @@ static void snp_cleanup_guest_buf(struct sev_data_snp_guest_request *data, unsig
 		*rc = SEV_RET_INVALID_ADDRESS;
 }
 
+static bool snp_throttle_guest_request(struct kvm_sev_info *sev) {
+	if (__ratelimit(&sev->snp_guest_msg_rs))
+		return false;
+
+	pr_info_ratelimited("svm: too many guest message requests\n");
+	return true;
+}
+
 static void snp_handle_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
 {
 	struct sev_data_snp_guest_request data = {0};
@@ -3611,6 +3630,11 @@ static void snp_handle_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t
 
 	sev = &to_kvm_svm(kvm)->sev_info;
 
+	if (snp_throttle_guest_request(sev)) {
+		rc = SNP_GUEST_REQ_THROTTLED;
+		goto e_fail;
+	}
+
 	mutex_lock(&sev->guest_req_lock);
 
 	rc = snp_setup_guest_buf(svm, &data, req_gpa, resp_gpa);
@@ -3648,6 +3672,11 @@ static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gp
 
 	sev = &to_kvm_svm(kvm)->sev_info;
 
+	if (snp_throttle_guest_request(sev)) {
+		rc = SNP_GUEST_REQ_THROTTLED;
+		goto e_fail;
+	}
+
 	data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
 	data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8d1ba66860a4..7048f817efb0 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -18,6 +18,7 @@
 #include <linux/kvm_types.h>
 #include <linux/kvm_host.h>
 #include <linux/bits.h>
+#include <linux/ratelimit.h>
 
 #include <asm/svm.h>
 #include <asm/sev-common.h>
@@ -105,6 +106,8 @@ struct kvm_sev_info {
 	unsigned int snp_certs_len; /* Size of instance override for certs */
 	struct mutex guest_req_lock;
 
+	struct ratelimit_state snp_guest_msg_rs; /* Limit guest requests */
+
 	u64 sev_features;	/* Features set at VMSA creation */
 };
 
diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
index f243ce665f74..07a4cb149305 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -20,6 +20,7 @@
 #define _UAPI_LINUX_IN_H
 
 #include <linux/types.h>
+#include <linux/stddef.h>
 #include <linux/libc-compat.h>
 #include <linux/socket.h>
 
-- 
2.39.0.246.g2a6d74b583-goog

