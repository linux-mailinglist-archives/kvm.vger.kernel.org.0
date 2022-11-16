Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A69962C6F6
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 18:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238874AbiKPR4V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 12:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239015AbiKPR4K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 12:56:10 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9FC61B86
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 09:56:07 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id x18-20020a170902ec9200b001869f20da7eso14415783plg.10
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 09:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KlfWE2cqIDu+7jwt9BbCyjCmf2/9BDPosXGyqPGOT/M=;
        b=YqHanX6E4mgbT+antD03PMvEdQAruUauwGv55O3VagwqEnQWmlXKqePkHqf+JD8EFO
         Zm3/kbyQd5sHKHSwikWlTewuUH5ZcduUQspOux4DbRqVApmJwCSDChNeqEjCf2kXZpA3
         qIREzJmILSklQWgbeteJSpj6AtqOMLnHdX5NKDUv5YNi6gBWNXyx6hfwrQRKopgJWqTu
         iNeARYeKKHi87HMZNYpECxwJvpSY1sJV5GNNwKlwwxJ1F1ujji9+0EQY8fddZZLzgIZ4
         vD8uvlM39B11eol6MO87tSS4ZFEaxziITSPdX8nWko60CqELWyTQTSIyD7cqpTIWjOLa
         0kEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KlfWE2cqIDu+7jwt9BbCyjCmf2/9BDPosXGyqPGOT/M=;
        b=D7ABDIC9rFibG6s86kAZYlrd0MCAkRWr9lno5PVz6XXSn7ia6hacI2bAtMNyCFz37L
         uQuVdKHQj6AfqJtVc9RdOTPZT/Q4iByOP7xRuwrtrD0hsA1bsLY1X2qVARoIdQRN85E2
         FavZeUDe4ea048WsU0+r3N4QOdhNaemDoERY6e0bvfMIi/KDYw3T9R8SOR7/z3ggMnon
         mQCIMi07iS1mGHjM4QXe98nemFqR7xjGdtC0+fgEvBzVsWi+pBTxzMsytZD0XTV8KMyn
         V8o+idj54AScKNCRwfoJ9/Mv3HElsMFQlJ81Fp4WzwhYuB8puEzJrtxyiIKxBpvs7kCU
         rUmg==
X-Gm-Message-State: ANoB5pnvg2T57R30dQCAzxcL2aFH8V+q5hbg+1egZFs5tuA5nyaXa6Ya
        oMjFUNF71y5MztA3vTnrCML3OEv2lwQ=
X-Google-Smtp-Source: AA0mqf5dF4oJxqtS3V6FHFqeA6L+G7+fa9gyTELuMQYaN++HsvSIMV5L1/3KQoZyTXyg8m9g/KDEdLC31Wo=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:11:e28:e984:f232:1178])
 (user=pgonda job=sendgmr) by 2002:a05:6a00:15d2:b0:563:1231:1da with SMTP id
 o18-20020a056a0015d200b00563123101damr24728098pfu.5.1668621366488; Wed, 16
 Nov 2022 09:56:06 -0800 (PST)
Date:   Wed, 16 Nov 2022 09:55:58 -0800
Message-Id: <20221116175558.2373112-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.493.g58b659f92b-goog
Subject: [PATCH V5] virt: sev: Prevent IV reuse in SNP guest driver
From:   Peter Gonda <pgonda@google.com>
To:     thomas.lendacky@amd.com
Cc:     Peter Gonda <pgonda@google.com>, Borislav Petkov <bp@suse.de>,
        Michael Roth <michael.roth@amd.com>,
        Haowen Bai <baihaowen@meizu.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The AMD Secure Processor (ASP) and an SNP guest use a series of
AES-GCM keys called VMPCKs to communicate securely with each other.
The IV to this scheme is a sequence number that both the ASP and the
guest track. Currently this sequence number in a guest request must
exactly match the sequence number tracked by the ASP. This means that
if the guest sees an error from the host during a request it can only
retry that exact request or disable the VMPCK to prevent an IV reuse.
AES-GCM cannot tolerate IV reuse see: "Authentication Failures in NIST
version of GCM" - Antoine Joux et al.

In order to address this make handle_guest_request() delete the VMPCK
on any non successful return. To allow userspace querying the cert_data
length make handle_guest_request() safe the number of pages required by
the host, then handle_guest_request() retry the request without
requesting the extended data, then return the number of pages required
back to userspace.

Fixes: fce96cf044308 ("virt: Add SEV-SNP guest driver")
Signed-off-by: Peter Gonda <pgonda@google.com>
Reported-by: Peter Gonda <pgonda@google.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Cc: Haowen Bai <baihaowen@meizu.com>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Cc: Marc Orr <marcorr@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dionna Glaze <dionnaglaze@google.com>
Cc: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
---
 drivers/virt/coco/sev-guest/sev-guest.c | 83 ++++++++++++++++++++-----
 1 file changed, 69 insertions(+), 14 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index f422f9c58ba79..64b4234c14da8 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -67,8 +67,27 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
 	return true;
 }
 
+/*
+ * If an error is received from the host or AMD Secure Processor (ASP) there
+ * are two options. Either retry the exact same encrypted request or discontinue
+ * using the VMPCK.
+ *
+ * This is because in the current encryption scheme GHCB v2 uses AES-GCM to
+ * encrypt the requests. The IV for this scheme is the sequence number. GCM
+ * cannot tolerate IV reuse.
+ *
+ * The ASP FW v1.51 only increments the sequence numbers on a successful
+ * guest<->ASP back and forth and only accepts messages at its exact sequence
+ * number.
+ *
+ * So if the sequence number were to be reused the encryption scheme is
+ * vulnerable. If the sequence number were incremented for a fresh IV the ASP
+ * will reject the request.
+ */
 static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
 {
+	dev_alert(snp_dev->dev, "Disabling vmpck_id: %d to prevent IV reuse.\n",
+		  vmpck_id);
 	memzero_explicit(snp_dev->vmpck, VMPCK_KEY_LEN);
 	snp_dev->vmpck = NULL;
 }
@@ -321,34 +340,70 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code, in
 	if (rc)
 		return rc;
 
-	/* Call firmware to process the request */
+	/*
+	 * Call firmware to process the request. In this function the encrypted
+	 * message enters shared memory with the host. So after this call the
+	 * sequence number must be incremented or the VMPCK must be deleted to
+	 * prevent reuse of the IV.
+	 */
 	rc = snp_issue_guest_request(exit_code, &snp_dev->input, &err);
+
+	/*
+	 * If the extended guest request fails due to having too small of a
+	 * certificate data buffer retry the same guest request without the
+	 * extended data request in order to not have to reuse the IV.
+	 */
+	if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST &&
+	    err == SNP_GUEST_REQ_INVALID_LEN) {
+		const unsigned int certs_npages = snp_dev->input.data_npages;
+
+		exit_code = SVM_VMGEXIT_GUEST_REQUEST;
+
+		/*
+		 * If this call to the firmware succeeds the sequence number can
+		 * be incremented allowing for continued use of the VMPCK. If
+		 * there is an error reflected in the return value, this value
+		 * is checked further down and the result will be the deletion
+		 * of the VMPCK and the error code being propagated back to the
+		 * user as an IOCLT return code.
+		 */
+		rc = snp_issue_guest_request(exit_code, &snp_dev->input, &err);
+
+		/*
+		 * Override the error to inform callers the given extended
+		 * request buffer size was too small and give the caller the
+		 * required buffer size.
+		 */
+		err = SNP_GUEST_REQ_INVALID_LEN;
+		snp_dev->input.data_npages = certs_npages;
+	}
+
 	if (fw_err)
 		*fw_err = err;
 
-	if (rc)
-		return rc;
+	if (rc) {
+		dev_alert(snp_dev->dev,
+			  "Detected error from ASP request. rc: %d, fw_err: %llu\n",
+			  rc, *fw_err);
+		goto disable_vmpck;
+	}
 
-	/*
-	 * The verify_and_dec_payload() will fail only if the hypervisor is
-	 * actively modifying the message header or corrupting the encrypted payload.
-	 * This hints that hypervisor is acting in a bad faith. Disable the VMPCK so that
-	 * the key cannot be used for any communication. The key is disabled to ensure
-	 * that AES-GCM does not use the same IV while encrypting the request payload.
-	 */
 	rc = verify_and_dec_payload(snp_dev, resp_buf, resp_sz);
 	if (rc) {
 		dev_alert(snp_dev->dev,
-			  "Detected unexpected decode failure, disabling the vmpck_id %d\n",
-			  vmpck_id);
-		snp_disable_vmpck(snp_dev);
-		return rc;
+			  "Detected unexpected decode failure from ASP. rc: %d\n",
+			  rc);
+		goto disable_vmpck;
 	}
 
 	/* Increment to new message sequence after payload decryption was successful. */
 	snp_inc_msg_seqno(snp_dev);
 
 	return 0;
+
+disable_vmpck:
+	snp_disable_vmpck(snp_dev);
+	return rc;
 }
 
 static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
-- 
2.38.1.493.g58b659f92b-goog

