Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFAD61828F
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 16:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbiKCPXm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 11:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbiKCPXk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 11:23:40 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EEE140D3
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 08:23:39 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b142-20020a253494000000b006ca86d5f40fso2389745yba.19
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 08:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oeNg4z267iM9Zx5yS0UWNTo3rYVAuTWAXrfPBVxf4R4=;
        b=PEcbtMjSEpct3ISlRGfD5Usz5v9gvLcAkHWc+leHqWL65D/RJ/nw8ZUigyhvb/sg56
         FNYo/fF63wzGdDcDF665iXxt2w40s7kD08p3FuM1UQxKILkrPx7Jc5ZSfPrlBBMFnFtJ
         bcmWr1NDag/UsYE/hZZBx9gY1pPqUG13pr/tbfj7gCCrPzKNhUF7EYE+no6xPsjWeAQ+
         LcrosaSPPIHvgsZevmgnljMWdRcTKFXd2NZnPRzbiwvE/ardt1G8d+Pe8EE+oP+Sl/3e
         Lz3/dU/twWNJwaNe1gEYDDnTZYpIZ4OUH8xuDgSlTYEtMflMY4Si7iZn/CXmNS/g5l3J
         CzAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oeNg4z267iM9Zx5yS0UWNTo3rYVAuTWAXrfPBVxf4R4=;
        b=SdyTUL6/OID2PGQ10sQhmVu41LaLf/V4nmQo6BXht0eKUy13kw66a+TUmLyI6+iMQk
         9rEDpoQP7dmMlYgErxRLxNAh76iuZ4ZMvRtp2RmmUfeSyacUp1NhBKFYzTVZSDivmdsA
         H/10DpRTP3NGtoUkP4gzFpgTi/7xaMd3zCqUTUHQtviQSxbAuaosUzaH2bHFO3BDFN7P
         Cilv+qLpPQTjYuXjXUmR6vKfePyaClN/1i4zK7hxciq3xJU5vkmrTVfBz0Q7iKIwTI7N
         kzpZY6BriwLQyIuUoMtqiTLfXVU+V5y/E+OqnlwfbuDeRnxnG98jiAEpuv/i5lt3qbXJ
         lsJA==
X-Gm-Message-State: ACrzQf32/2HmrsFEtqz/Kh3+dULORqq/IwpQu0BRnLNBMPEsJAmqFgE9
        XiMPL2aqqQaCdSgovdrvA8jGjZ4m5VQ=
X-Google-Smtp-Source: AMsMyM6EsKBy8ZJIbMUXt4DHhPw3ke3RtfupzS9jQfwQs3pGBHdShKfVyutJkq+z9keUp9VU0VJT0+/gq9E=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:11:45e5:86a8:76c:1f1c])
 (user=pgonda job=sendgmr) by 2002:a81:48ca:0:b0:368:117c:1308 with SMTP id
 v193-20020a8148ca000000b00368117c1308mr185325ywa.216.1667489018530; Thu, 03
 Nov 2022 08:23:38 -0700 (PDT)
Date:   Thu,  3 Nov 2022 08:23:18 -0700
Message-Id: <20221103152318.88354-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Subject: [PATCH V4] virt: sev: Prevent IV reuse in SNP guest driver
From:   Peter Gonda <pgonda@google.com>
To:     thomas.lendacky@amd.com
Cc:     Peter Gonda <pgonda@google.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        Borislav Petkov <bp@suse.de>,
        Michael Roth <michael.roth@amd.com>,
        Haowen Bai <baihaowen@meizu.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
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

The ASP and an SNP guest use a series of AES-GCM keys called VMPCKs to
communicate securely with each other. The IV to this scheme is a
sequence number that both the ASP and the guest track. Currently this
sequence number in a guest request must exactly match the sequence
number tracked by the ASP. This means that if the guest sees an error
from the host during a request it can only retry that exact request or
disable the VMPCK to prevent an IV reuse. AES-GCM cannot tolerate IV
reuse see:
https://csrc.nist.gov/csrc/media/projects/block-cipher-techniques/documents/bcm/comments/800-38-series-drafts/gcm/joux_comments.pdf

To handle userspace querying the cert_data length handle_guest_request()
now: saves the number of pages required by the host, retries the request
without requesting the extended data, then returns the number of pages
required.

Fixes: fce96cf044308 ("virt: Add SEV-SNP guest driver")
Signed-off-by: Peter Gonda <pgonda@google.com>
Reported-by: Peter Gonda <pgonda@google.com>
Cc: Dionna Glaze <dionnaglaze@google.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Cc: Haowen Bai <baihaowen@meizu.com>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Cc: Marc Orr <marcorr@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
---
Tested by placing each of the guest requests: attestation quote,
extended attestation quote, and get key. Then tested the extended
attestation quote certificate length querying.

V4
 * As suggested by Dionna moved the extended request retry logic into
   the driver.
 * Due to big change in patch dropped any reviewed-by tags.

---
 drivers/virt/coco/sev-guest/sev-guest.c | 70 +++++++++++++++++++------
 1 file changed, 53 insertions(+), 17 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index f422f9c58ba79..7dd6337ebdd5b 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -41,7 +41,7 @@ struct snp_guest_dev {
 	struct device *dev;
 	struct miscdevice misc;
 
-	void *certs_data;
+	u8 (*certs_data)[SEV_FW_BLOB_MAX_SIZE];
 	struct snp_guest_crypto *crypto;
 	struct snp_guest_msg *request, *response;
 	struct snp_secrets_page_layout *layout;
@@ -67,8 +67,27 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
 	return true;
 }
 
+/*
+ * If we receive an error from the host or ASP we have two options. We can
+ * either retry the exact same encrypted request or we can discontinue using the
+ * VMPCK.
+ *
+ * This is because in the current encryption scheme GHCB v2 uses AES-GCM to
+ * encrypt the requests. The IV for this scheme is the sequence number. GCM
+ * cannot tolerate IV reuse.
+ *
+ * The ASP FW v1.51 only increments the sequence numbers on a successful
+ * guest<->ASP back and forth and only accepts messages at its exact sequence
+ * number.
+ *
+ * So if we were to reuse the sequence number the encryption scheme is
+ * vulnerable. If we encrypt the sequence number for a fresh IV the ASP will
+ * reject our request.
+ */
 static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
 {
+	dev_alert(snp_dev->dev, "Disabling vmpck_id: %d to prevent IV reuse.\n",
+		  vmpck_id);
 	memzero_explicit(snp_dev->vmpck, VMPCK_KEY_LEN);
 	snp_dev->vmpck = NULL;
 }
@@ -323,32 +342,49 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code, in
 
 	/* Call firmware to process the request */
 	rc = snp_issue_guest_request(exit_code, &snp_dev->input, &err);
+
+	/*
+	 * If the extended guest request fails due to having to small of a
+	 * certificate data buffer retry the same guest request without the
+	 * extended data request.
+	 */
+	if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST &&
+	    err == SNP_GUEST_REQ_INVALID_LEN) {
+		const unsigned int certs_npages = snp_dev->input.data_npages;
+
+		exit_code = SVM_VMGEXIT_GUEST_REQUEST;
+		rc = snp_issue_guest_request(exit_code, &snp_dev->input, &err);
+
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
@@ -676,7 +712,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	if (!snp_dev->response)
 		goto e_free_request;
 
-	snp_dev->certs_data = alloc_shared_pages(dev, SEV_FW_BLOB_MAX_SIZE);
+	snp_dev->certs_data = alloc_shared_pages(dev, sizeof(*snp_dev->certs_data));
 	if (!snp_dev->certs_data)
 		goto e_free_response;
 
@@ -703,7 +739,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	return 0;
 
 e_free_cert_data:
-	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
+	free_shared_pages(snp_dev->certs_data, sizeof(*snp_dev->certs_data));
 e_free_response:
 	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
 e_free_request:
@@ -717,7 +753,7 @@ static int __exit sev_guest_remove(struct platform_device *pdev)
 {
 	struct snp_guest_dev *snp_dev = platform_get_drvdata(pdev);
 
-	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
+	free_shared_pages(snp_dev->certs_data, sizeof(*snp_dev->certs_data));
 	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
 	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
 	deinit_crypto(snp_dev->crypto);
-- 
2.38.1.273.g43a17bfeac-goog

