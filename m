Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E638440D497
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 10:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234998AbhIPIeJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 04:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235120AbhIPIeF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 04:34:05 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B507C061767
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 01:32:45 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id s16so1493278wra.10
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 01:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dme-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jxlL0lGtv5ZlNrPQbf90760XLEjt/UFew72/NT7P6ZA=;
        b=TkTWRVF+5Q7Su3IUaesuhgf4CtLDdMSqoQgis6/0kVEgCS2xqDGymVIOELO3gYGYTB
         e2SxJlu5+fKJqBBEjqHq2o1+9vd+KD8skQfo5Rpb/nlUSzaPqRW8Lei0/HUwgFkSdIAG
         oEdHGSp1kHWO3MrUUi4vBU+/qkp49b26WEEMww/cNRsoBZ22a929EP/U3gQkvEAyAMqE
         CB0T6twNdt6LcikTrYASFmN4ztePGAtLJH0SgTbcRyh1EM3v7UecYNhsS/gBe7nt+Ivc
         ITPu5MHfPqsM96Bt2I2GKNLDo3Nuwq1zv+C3BIJP2RT3pVfAjH3BQUfsAvcLwi0W4Qad
         faGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jxlL0lGtv5ZlNrPQbf90760XLEjt/UFew72/NT7P6ZA=;
        b=R005tU1+mPJOJM8poLw/YxqBQ7gfQjFBzWPxg3eaUD70DHavwV2sLNUETNuu1p4A71
         GSygilMmHPwQSjdhAhARy0yUovt1iB5KAI3GSfzDfe5dNxhHGtmcnXInnrZkFztGwEUT
         PZmAbm7/tjhkKmRKcER8f/Amkyek5bkqGZxQYhfyN8OAa2xy2739eH9ALCNxivhI0hhi
         Ut2ePSqy37GGRysZu9DBgIcSQhm+RgtQDE29N1pogo/zNt8sT8jwko1Mo7euwAgLf1AE
         G+gI7tdyN9wCKGrwghYqN8yBxKtKPCE8agHBzA6gowEBSCrH3lnxQoFDWXezgzPoYEvb
         N2zQ==
X-Gm-Message-State: AOAM531IT1rMcleZmJ7bs3/mKL1X+Y/A/Kgo7YvrujNuzt7QbUBvhSsX
        rClst2o8Y3ClobP9u/03di93UKIUYM/Z9ZJcC7Y=
X-Google-Smtp-Source: ABdhPJyfE8/wyEQRvmpiR7oOPNOL4J2PzWMdBSBvGwpu/s4Fd6Im8ZXwX9obCHi1pvvQC+8rA7nVsw==
X-Received: by 2002:adf:e384:: with SMTP id e4mr4705046wrm.64.1631781163393;
        Thu, 16 Sep 2021 01:32:43 -0700 (PDT)
Received: from disaster-area.hh.sledj.net ([2001:8b0:bb71:7140:64::1])
        by smtp.gmail.com with ESMTPSA id c135sm6760024wme.6.2021.09.16.01.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 01:32:43 -0700 (PDT)
From:   David Edmondson <dme@dme.org>
X-Google-Original-From: David Edmondson <david.edmondson@oracle.com>
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 6aff296b;
        Thu, 16 Sep 2021 08:32:39 +0000 (UTC)
To:     linux-kernel@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH v5 4/4] KVM: x86: SGX must obey the KVM_INTERNAL_ERROR_EMULATION protocol
Date:   Thu, 16 Sep 2021 09:32:39 +0100
Message-Id: <20210916083239.2168281-5-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916083239.2168281-1-david.edmondson@oracle.com>
References: <20210916083239.2168281-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When passing the failing address and size out to user space, SGX must
ensure not to trample on the earlier fields of the emulation_failure
sub-union of struct kvm_run.

Signed-off-by: David Edmondson <david.edmondson@oracle.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/sgx.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 6693ebdc0770..35e7ec91ae86 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -53,11 +53,9 @@ static int sgx_get_encls_gva(struct kvm_vcpu *vcpu, unsigned long offset,
 static void sgx_handle_emulation_failure(struct kvm_vcpu *vcpu, u64 addr,
 					 unsigned int size)
 {
-	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-	vcpu->run->internal.ndata = 2;
-	vcpu->run->internal.data[0] = addr;
-	vcpu->run->internal.data[1] = size;
+	uint64_t data[2] = { addr, size };
+
+	__kvm_prepare_emulation_failure_exit(vcpu, data, ARRAY_SIZE(data));
 }
 
 static int sgx_read_hva(struct kvm_vcpu *vcpu, unsigned long hva, void *data,
@@ -112,9 +110,7 @@ static int sgx_inject_fault(struct kvm_vcpu *vcpu, gva_t gva, int trapnr)
 	 * but the error code isn't (yet) plumbed through the ENCLS helpers.
 	 */
 	if (trapnr == PF_VECTOR && !boot_cpu_has(X86_FEATURE_SGX2)) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
+		kvm_prepare_emulation_failure_exit(vcpu);
 		return 0;
 	}
 
@@ -155,9 +151,7 @@ static int __handle_encls_ecreate(struct kvm_vcpu *vcpu,
 	sgx_12_0 = kvm_find_cpuid_entry(vcpu, 0x12, 0);
 	sgx_12_1 = kvm_find_cpuid_entry(vcpu, 0x12, 1);
 	if (!sgx_12_0 || !sgx_12_1) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
+		kvm_prepare_emulation_failure_exit(vcpu);
 		return 0;
 	}
 
-- 
2.33.0

