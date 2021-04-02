Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A31E352540
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 03:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233901AbhDBBpk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 21:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbhDBBpj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 21:45:39 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F3EC061788
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 18:45:39 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id c7so4949334qka.6
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 18:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=B7WcpZ6OMWphpXj982R+9f98aP8oPdWyveFaKChJc9U=;
        b=ShvmTpFEutpHpZUiSFstp1N4vq7foUYvHyUdFzMRaF7EisCH49QrnqUAoMyvnhnA6e
         K5HKDMBtLDiR143ruaUn6/6D088D8A+RwRxGKLhSlG56lKFsw9Z9EzgB4Pozzcg1J6ev
         jXTLXTSRs+GKpp/V6YULuy/GKwhDUt2XwELt2bHJcMdbOEZU6HCggtHyXe0EcpxhmXcH
         ZHT596H618QJZEIZr5EoaJ+pCFaxkFxOSkgpsu68AW2Qn2d9DRurIpmYDgXwD/88WJS9
         YZJ8xGqsXZgPsGAraPgOSnGQwKMtUOFOYa3tN80QRrNqWyA3XOyzeYr5nd3/Wruao94t
         HRzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=B7WcpZ6OMWphpXj982R+9f98aP8oPdWyveFaKChJc9U=;
        b=o2Iv933rUNVINVQXLAGLMH2Wbw8R+0MleSnLt4BwrGvijNTl7SoOysdY5ZJIfiPO6L
         Nk9w4kiMRK/q1Jw9j7J99Kdaccp1/l1YdhS4WD+KImdgu9UWRu4PfBrQytjzcSO23Koi
         tptOIVvyGS6PZqylBo0tMeKUhBlZIX2XvK4c6IqdpgFYW7B9no+fOEzDL8mG+K6uCzNg
         wqRVY2C48ZIh9c3m5O92BtUjSb1dIzweYOML3+yEphWcTx4GLZwusXs65E9621SxDLQH
         S1haCyq3z6N+nd+r1rij+Uxb/TuXZInT2nhmAVJpm4uyMEwHXFKBJXHuesh4/FwH9+9H
         aerg==
X-Gm-Message-State: AOAM531kzHdAtxXZXcxUw5IAoWY3NgeWnTzqFt5gdNrMW2PEd5AWZa/N
        T952Hok3Jjl5ooa+a7mu9kC/bCDJ6uUnQ0wlcUBDxSKDBAumoiITFUOO826FtTWmXWQlrjomNWA
        ce3y3XRHx+avavVKQEXPHFzd7saBegGZVGWh+fmMq+T9QkUvPFE8fA9wMaICLUKXoYUB5+Gc=
X-Google-Smtp-Source: ABdhPJw5qj6CWaSf0NeH4Vuwhk3KPzvrtiaesRG6UETXTQ2Z1/J4sPx9X350idkyGLf9t/JpnUmBYgHYpNO1kqOIxA==
X-Received: from riemann.sea.corp.google.com ([2620:15c:158:202:68ed:8390:2860:e44a])
 (user=srutherford job=sendgmr) by 2002:a0c:e409:: with SMTP id
 o9mr1023699qvl.31.1617327938539; Thu, 01 Apr 2021 18:45:38 -0700 (PDT)
Date:   Thu,  1 Apr 2021 18:44:38 -0700
Message-Id: <20210402014438.1721086-1-srutherford@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH] KVM: SVM: Add support for KVM_SEV_SEND_CANCEL command
From:   Steve Rutherford <srutherford@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, natet@google.com,
        Ashish.Kalra@amd.com, brijesh.singh@amd.com, pbonzini@redhat.com,
        Steve Rutherford <srutherford@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After completion of SEND_START, but before SEND_FINISH, the source VMM can
issue the SEND_CANCEL command to stop a migration. This is necessary so
that a cancelled migration can restart with a new target later.

Signed-off-by: Steve Rutherford <srutherford@google.com>
---
 .../virt/kvm/amd-memory-encryption.rst        |  9 +++++++
 arch/x86/kvm/svm/sev.c                        | 24 +++++++++++++++++++
 include/linux/psp-sev.h                       | 10 ++++++++
 include/uapi/linux/kvm.h                      |  2 ++
 4 files changed, 45 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 469a6308765b1..9e018a3eec03b 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -284,6 +284,15 @@ Returns: 0 on success, -negative on error
                 __u32 len;
         };
 
+16. KVM_SEV_SEND_CANCEL
+------------------------
+
+After completion of SEND_START, but before SEND_FINISH, the source VMM can issue the
+SEND_CANCEL command to stop a migration. This is necessary so that a cancelled
+migration can restart with a new target later.
+
+Returns: 0 on success, -negative on error
+
 References
 ==========
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 83e00e5245136..88e72102cb900 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1110,6 +1110,27 @@ static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_send_cancel(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_send_cancel *data;
+	int ret;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->handle = sev->handle;
+	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_CANCEL, data, &argp->error);
+
+	kfree(data);
+	return ret;
+}
+
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1163,6 +1184,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_GET_ATTESTATION_REPORT:
 		r = sev_get_attestation_report(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SEND_CANCEL:
+		r = sev_send_cancel(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index b801ead1e2bb5..74f2babffc574 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -73,6 +73,7 @@ enum sev_cmd {
 	SEV_CMD_SEND_UPDATE_DATA	= 0x041,
 	SEV_CMD_SEND_UPDATE_VMSA	= 0x042,
 	SEV_CMD_SEND_FINISH		= 0x043,
+	SEV_CMD_SEND_CANCEL		= 0x044,
 
 	/* Guest migration commands (incoming) */
 	SEV_CMD_RECEIVE_START		= 0x050,
@@ -392,6 +393,15 @@ struct sev_data_send_finish {
 	u32 handle;				/* In */
 } __packed;
 
+/**
+ * struct sev_data_send_cancel - SEND_CANCEL command parameters
+ *
+ * @handle: handle of the VM to process
+ */
+struct sev_data_send_cancel {
+	u32 handle;				/* In */
+} __packed;
+
 /**
  * struct sev_data_receive_start - RECEIVE_START command parameters
  *
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f6afee209620d..707469b6b7072 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1671,6 +1671,8 @@ enum sev_cmd_id {
 	KVM_SEV_CERT_EXPORT,
 	/* Attestation report */
 	KVM_SEV_GET_ATTESTATION_REPORT,
+	/* Guest Migration Extension */
+	KVM_SEV_SEND_CANCEL,
 
 	KVM_SEV_NR_MAX,
 };
-- 
2.31.0.208.g409f899ff0-goog

