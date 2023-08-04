Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0160F77073A
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 19:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbjHDRe5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 13:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbjHDRex (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 13:34:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8B34C21
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 10:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691170440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7rUT4DyFNHLsbrKuTmkoJFFXnreb/7vwjwFohU+6Wls=;
        b=JfGNZs+XHnL3jRym9GHlEzmqd/sK71PLI+n9Ujxr7u3IE2kZpd5yqAkxwTR7M2LG5I2m3t
        +HybW1KNKE0Rnn7AMgzxWmd+oY/1rMTAvu2zW9RgkXP+QEt+y/z/XGQszf0H5IFMYfRyNk
        UOIi9U/Ph2/qI5ZSLQD5OFuM4vUnK2M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-ihzmKkq0Mf6RPlBorRO-IA-1; Fri, 04 Aug 2023 13:33:57 -0400
X-MC-Unique: ihzmKkq0Mf6RPlBorRO-IA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F270104458A;
        Fri,  4 Aug 2023 17:33:57 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FB16C5796B;
        Fri,  4 Aug 2023 17:33:57 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pgonda@google.com, seanjc@google.com, theflow@google.com,
        vkuznets@redhat.com, thomas.lendacky@amd.com
Subject: [PATCH 3/3] KVM: SEV: remove ghcb variable declarations
Date:   Fri,  4 Aug 2023 13:33:55 -0400
Message-Id: <20230804173355.51753-4-pbonzini@redhat.com>
In-Reply-To: <20230804173355.51753-1-pbonzini@redhat.com>
References: <20230804173355.51753-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To avoid possible time-of-check/time-of-use issues, the GHCB should
almost never be accessed outside dump_ghcb, sev_es_sync_to_ghcb
and sev_es_sync_from_ghcb.  The only legitimate uses are to set the
exitinfo fields and to find the address of the scratch area embedded
in the ghcb.  Accessing ghcb_usage also goes through svm->sev_es.ghcb
in sev_es_validate_vmgexit(), but that is because anyway the value is
not used.

Removing a shortcut variable that contains the value of svm->sev_es.ghcb
makes these cases a bit more verbose, but it limits the chance of someone
reading the ghcb by mistake.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ca4ba5fe9a01..d3aec1f2cad2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2454,12 +2454,9 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
-	struct ghcb *ghcb;
 	u64 exit_code;
 	u64 reason;
 
-	ghcb = svm->sev_es.ghcb;
-
 	/*
 	 * Retrieve the exit code now even though it may not be marked valid
 	 * as it could help with debugging.
@@ -2467,7 +2464,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	exit_code = kvm_ghcb_get_sw_exit_code(control);
 
 	/* Only GHCB Usage code 0 is supported */
-	if (ghcb->ghcb_usage) {
+	if (svm->sev_es.ghcb->ghcb_usage) {
 		reason = GHCB_ERR_INVALID_USAGE;
 		goto vmgexit_err;
 	}
@@ -2561,7 +2558,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 vmgexit_err:
 	if (reason == GHCB_ERR_INVALID_USAGE) {
 		vcpu_unimpl(vcpu, "vmgexit: ghcb usage %#x is not valid\n",
-			    ghcb->ghcb_usage);
+			    svm->sev_es.ghcb->ghcb_usage);
 	} else if (reason == GHCB_ERR_INVALID_EVENT) {
 		vcpu_unimpl(vcpu, "vmgexit: exit code %#llx is not valid\n",
 			    exit_code);
@@ -2571,8 +2568,8 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		dump_ghcb(svm);
 	}
 
-	ghcb_set_sw_exit_info_1(ghcb, 2);
-	ghcb_set_sw_exit_info_2(ghcb, reason);
+	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, reason);
 
 	/* Resume the guest to "return" the error code. */
 	return 1;
@@ -2637,7 +2634,6 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
-	struct ghcb *ghcb = svm->sev_es.ghcb;
 	u64 ghcb_scratch_beg, ghcb_scratch_end;
 	u64 scratch_gpa_beg, scratch_gpa_end;
 	void *scratch_va;
@@ -2713,8 +2709,8 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 	return 0;
 
 e_scratch:
-	ghcb_set_sw_exit_info_1(ghcb, 2);
-	ghcb_set_sw_exit_info_2(ghcb, GHCB_ERR_INVALID_SCRATCH_AREA);
+	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_SCRATCH_AREA);
 
 	return 1;
 }
@@ -2827,7 +2823,6 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	u64 ghcb_gpa, exit_code;
-	struct ghcb *ghcb;
 	int ret;
 
 	/* Validate the GHCB */
@@ -2852,17 +2847,16 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	}
 
 	svm->sev_es.ghcb = svm->sev_es.ghcb_map.hva;
-	ghcb = svm->sev_es.ghcb_map.hva;
 
-	trace_kvm_vmgexit_enter(vcpu->vcpu_id, ghcb);
+	trace_kvm_vmgexit_enter(vcpu->vcpu_id, svm->sev_es.ghcb);
 
 	sev_es_sync_from_ghcb(svm);
 	ret = sev_es_validate_vmgexit(svm);
 	if (ret)
 		return ret;
 
-	ghcb_set_sw_exit_info_1(ghcb, 0);
-	ghcb_set_sw_exit_info_2(ghcb, 0);
+	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 0);
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 0);
 
 	exit_code = kvm_ghcb_get_sw_exit_code(control);
 	switch (exit_code) {
@@ -2902,13 +2896,13 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 			break;
 		case 1:
 			/* Get AP jump table address */
-			ghcb_set_sw_exit_info_2(ghcb, sev->ap_jump_table);
+			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, sev->ap_jump_table);
 			break;
 		default:
 			pr_err("svm: vmgexit: unsupported AP jump table request - exit_info_1=%#llx\n",
 			       control->exit_info_1);
-			ghcb_set_sw_exit_info_1(ghcb, 2);
-			ghcb_set_sw_exit_info_2(ghcb, GHCB_ERR_INVALID_INPUT);
+			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
 		}
 
 		ret = 1;
-- 
2.39.0

