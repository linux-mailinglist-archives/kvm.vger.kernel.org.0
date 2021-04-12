Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E81835D154
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 21:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245463AbhDLTov (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 15:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237467AbhDLTot (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 15:44:49 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC88BC06174A
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 12:44:29 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p75so7630863ybc.8
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 12:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=/8EkO2XpIPXcNEfhUs0PL9HjG4CvnSZ9tVEjZh4FrjQ=;
        b=S0iQUxgzZCycSQe3SNyXbIJuej2vlR0NuxrshrOGKhJLLvXPGhDyVZG8IQxuuItysR
         JvVFuwHey6/CIIEmRA3z0yoeyxsl51Y8A78QwLPge3ayY1LxPxecZTzGMQQ7f33wNKwn
         DcFM+V98n1ZzgZVsyXKKRQzZCHl03R25m3DcIGPNfOXxYJspv3HDKjRYd90bxOX5SzNq
         lwN7J3XdrE9Tmas/aIBtkkaWOB5U7o1c1IAdCAEjxMNYdxLP7o0bqrnxvPJYZVSpYu+9
         HzxBg6elw1AxIrzydhstSW4SvvFZQuxWVbQm3gpGCDNtGGzH0y3xJxSlfnROCbHaWmBX
         Ebcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=/8EkO2XpIPXcNEfhUs0PL9HjG4CvnSZ9tVEjZh4FrjQ=;
        b=epbxuom5eLy+BHUMu0OkosNkSmXsPoBH0tKbJQRX19vKS4iVB5Wm/pPibe2OG4sivg
         n5jZktbOiYPn/jbfYbcwRSVrGRSIW5k6o+r/fm8x38WuonZUl1uuYT9g8eqlV+NF2av9
         uzPCbB/Wk5QxKTH7prTp19uTNpONy+qGRzxkm0QgWDQuti1Gp24jxnHxXl8FnvxkxViS
         wPP8ifDTjHlaLqtwbGpt69uueeOV7/ZFGQ0IYPq+2XohRskl2Egvb5kL4dzKDr5LqNGB
         zgcuuJroibJTMgqPu9dYSNJ/gFsk4Z+HULMYZNYaYRTfqG2VIVMTLzXZ7KxPuP/G7yta
         qGog==
X-Gm-Message-State: AOAM532C8M1V7z00vM3yYXvEl7UKJfs2ROH4gV7FZzuEgWBQ9KmX5xTV
        SM98Pfvy90GN2HyRXeaVRcL0H9BXjnkhrUxI7frgzsYP908eFSq/dmqnz6LuEqce8iowHA6tVCD
        bzv9GqgyxDDmdyrHjxw+MvMe1pPPWyYkTBJFABlzdDWjy78W3kDoQu7rzBhuh4bsv2XTebao=
X-Google-Smtp-Source: ABdhPJwNI+9lyvZ0DJiIr2W5uyQ2D6wQHUegyqjJ6pJ+Q7kPEyT/XSIKzfs1B3pw2DkRPG7h7d0DT5MKnQ9V/YVSKQ==
X-Received: from riemann.sea.corp.google.com ([2620:15c:158:202:d03b:94af:33cb:27b9])
 (user=srutherford job=sendgmr) by 2002:a25:af0a:: with SMTP id
 a10mr39867011ybh.390.1618256668824; Mon, 12 Apr 2021 12:44:28 -0700 (PDT)
Date:   Mon, 12 Apr 2021 12:44:08 -0700
Message-Id: <20210412194408.2458827-1-srutherford@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.295.g9ea45b61b8-goog
Subject: [PATCH v3] KVM: SVM: Add support for KVM_SEV_SEND_CANCEL command
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

Reviewed-by: Nathan Tempelman <natet@google.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Steve Rutherford <srutherford@google.com>
---
 .../virt/kvm/amd-memory-encryption.rst        |  9 ++++++++
 arch/x86/kvm/svm/sev.c                        | 23 +++++++++++++++++++
 drivers/crypto/ccp/sev-dev.c                  |  1 +
 include/linux/psp-sev.h                       | 10 ++++++++
 include/uapi/linux/kvm.h                      |  2 ++
 5 files changed, 45 insertions(+)

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
index 83e00e5245136..16d75b39e5e78 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1110,6 +1110,26 @@ static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1163,6 +1183,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_GET_ATTESTATION_REPORT:
 		r = sev_get_attestation_report(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SEND_CANCEL:
+		r = sev_send_cancel(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index cb9b4c4e371ed..4172a1afa0db9 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -129,6 +129,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_DOWNLOAD_FIRMWARE:		return sizeof(struct sev_data_download_firmware);
 	case SEV_CMD_GET_ID:			return sizeof(struct sev_data_get_id);
 	case SEV_CMD_ATTESTATION_REPORT:	return sizeof(struct sev_data_attestation_report);
+	case SEV_CMD_SEND_CANCEL:			return sizeof(struct sev_data_send_cancel);
 	default:				return 0;
 	}
 
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
2.31.1.295.g9ea45b61b8-goog

