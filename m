Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373D660FB24
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 17:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235537AbiJ0PGH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 11:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235387AbiJ0PGF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 11:06:05 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409B5D6B81
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 08:06:04 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id m11-20020a170902db0b00b00186d72ea4b8so1199392plx.23
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 08:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rm31qAFaq+M5EgnK0auSpdF+G0fRaJUMCym7D7tYLvw=;
        b=Iw874OKP9XyuWJmrG1OHfXWZrOxXcb2jULJ6j4+HS40QEL25Wc6OtiLxK0KnUavx5B
         ZFH2ffHBIiZFHOtg6b/LHMy5TBSFbULVIUYQVUaFQxPtKihrmHSAoFjOUf5uK5joyf3x
         w7uxADbDL8eqDwO3IkhUHnYJO2Yfbx07Px4a+ozuf+iA9Z25iwjMQijYBGD0m/ovUQYD
         rR1mEnY5ZBTVTJg4b4W9NLf4y7JOmvlAzhXu+OuWKRPN6rRzrTTw6duo4lSJ9r+g/2Ct
         TDx0kuIfi5wBEMtGaBIzCh+QVsvK9W12adB/3UHf81UbbC6bKWHjHNJuJI3dfLJhxfN1
         ujEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rm31qAFaq+M5EgnK0auSpdF+G0fRaJUMCym7D7tYLvw=;
        b=7wLcDQ9Jowitmm05fewQQZOUQaAznMFaMM8sYELaqvASqbt+7LFhWvccypZ5WTCd+F
         gqfdfxrD/SZ3kh0fdUCYMwgiFQO9D6hx09g+XVsZETtSJle5vT6QHBrylz7VwfmWXM5x
         7CstaLcLYfM93hVlpQJdpwi5MBskBpkXR7MyTcAjvdNJ7vBr0dYanb/B1W2o32zxiuZH
         I3v7b1aTvqBY8JEDv4AI8wAcw0SMcdVs6EqxyXvyFX8DIzllthAKNiAUMfDQ97dXnplj
         2oflgR07GTBTqa1FZGwTNjZhNHN3l4HPWDe78ILU876aIoeJWjECt0b0aech9dZ95Ci8
         0NvA==
X-Gm-Message-State: ACrzQf1Mm7yB6cCQmRKaYOgxxrp9dh6lttPzhenlBvptxSY6zZJdEG/5
        g4kt7OEo/MZs1BRw2bW09eG/nYqJWos=
X-Google-Smtp-Source: AMsMyM7OecIRnuotZ1lJROjEJJXNaGGWp5vI1iFnfcm+ZC982gxSN5usLyNBV4YsDMSgTnZWAOZL2jTIQvs=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:11:da0c:de35:6ecf:7c48])
 (user=pgonda job=sendgmr) by 2002:a05:6a00:1a4d:b0:563:a7c4:f521 with SMTP id
 h13-20020a056a001a4d00b00563a7c4f521mr49813630pfv.61.1666883163776; Thu, 27
 Oct 2022 08:06:03 -0700 (PDT)
Date:   Thu, 27 Oct 2022 08:05:57 -0700
In-Reply-To: <20221027150558.722062-1-pgonda@google.com>
Message-Id: <20221027150558.722062-2-pgonda@google.com>
Mime-Version: 1.0
References: <20221027150558.722062-1-pgonda@google.com>
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
Subject: [PATCH V3 1/2] virt: sev: Prevent IV reuse in SNP guest driver
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
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

To handle userspace querying the cert_data length. Instead of requesting
the cert length from userspace use the size of the drivers allocated
shared buffer. Then copy that buffer to userspace, or give userspace an
error depending on the size of the buffer given by userspace.

Fixes: fce96cf044308 ("virt: Add SEV-SNP guest driver")
Signed-off-by: Peter Gonda <pgonda@google.com>
Reported-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
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
 drivers/virt/coco/sev-guest/sev-guest.c | 93 ++++++++++++++++---------
 1 file changed, 62 insertions(+), 31 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index f422f9c58ba7..8c54ea84bc57 100644
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
@@ -326,29 +345,29 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code, in
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
@@ -437,7 +456,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	struct snp_guest_crypto *crypto = snp_dev->crypto;
 	struct snp_ext_report_req req;
 	struct snp_report_resp *resp;
-	int ret, npages = 0, resp_len;
+	int ret, resp_len, req_cert_len, resp_cert_len;
 
 	lockdep_assert_held(&snp_cmd_mutex);
 
@@ -448,14 +467,15 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 		return -EFAULT;
 
 	/* userspace does not want certificate data */
-	if (!req.certs_len || !req.certs_address)
+	req_cert_len = req.certs_len;
+	if (!req_cert_len || !req.certs_address)
 		goto cmd;
 
-	if (req.certs_len > SEV_FW_BLOB_MAX_SIZE ||
-	    !IS_ALIGNED(req.certs_len, PAGE_SIZE))
+	if (req_cert_len > sizeof(*snp_dev->certs_data) ||
+	    !IS_ALIGNED(req_cert_len, PAGE_SIZE))
 		return -EINVAL;
 
-	if (!access_ok((const void __user *)req.certs_address, req.certs_len))
+	if (!access_ok((const void __user *)req.certs_address, req_cert_len))
 		return -EFAULT;
 
 	/*
@@ -464,8 +484,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	 * the host. If host does not supply any certs in it, then copy
 	 * zeros to indicate that certificate data was not provided.
 	 */
-	memset(snp_dev->certs_data, 0, req.certs_len);
-	npages = req.certs_len >> PAGE_SHIFT;
+	memset(snp_dev->certs_data, 0, sizeof(*snp_dev->certs_data));
 cmd:
 	/*
 	 * The intermediate response buffer is used while decrypting the
@@ -477,25 +496,37 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	if (!resp)
 		return -ENOMEM;
 
-	snp_dev->input.data_npages = npages;
+	snp_dev->input.data_npages = sizeof(*snp_dev->certs_data) >> PAGE_SHIFT;
 	ret = handle_guest_request(snp_dev, SVM_VMGEXIT_EXT_GUEST_REQUEST, arg->msg_version,
 				   SNP_MSG_REPORT_REQ, &req.data,
 				   sizeof(req.data), resp->data, resp_len, &arg->fw_err);
 
+	resp_cert_len = snp_dev->input.data_npages << PAGE_SHIFT;
+
 	/* If certs length is invalid then copy the returned length */
 	if (arg->fw_err == SNP_GUEST_REQ_INVALID_LEN) {
-		req.certs_len = snp_dev->input.data_npages << PAGE_SHIFT;
+		dev_alert(snp_dev->dev,
+			  "Certificate data from host: %d, Max size allocated by driver: %lu.\n",
+			  resp_cert_len, sizeof(*snp_dev->certs_data));
+		ret = -EFAULT;
+	}
+
+	if (ret)
+		goto e_free;
+
+	/* Pass the actual certificate data size back to userspace */
+	req.certs_len = resp_cert_len;
+	if (resp_cert_len > req_cert_len) {
+		arg->fw_err = SNP_GUEST_REQ_INVALID_LEN;
 
 		if (copy_to_user((void __user *)arg->req_data, &req, sizeof(req)))
 			ret = -EFAULT;
-	}
 
-	if (ret)
 		goto e_free;
+	}
 
-	if (npages &&
-	    copy_to_user((void __user *)req.certs_address, snp_dev->certs_data,
-			 req.certs_len)) {
+	if (copy_to_user((void __user *)req.certs_address, snp_dev->certs_data,
+			 resp_cert_len)) {
 		ret = -EFAULT;
 		goto e_free;
 	}
@@ -676,7 +707,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	if (!snp_dev->response)
 		goto e_free_request;
 
-	snp_dev->certs_data = alloc_shared_pages(dev, SEV_FW_BLOB_MAX_SIZE);
+	snp_dev->certs_data = alloc_shared_pages(dev, sizeof(*snp_dev->certs_data));
 	if (!snp_dev->certs_data)
 		goto e_free_response;
 
@@ -703,7 +734,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	return 0;
 
 e_free_cert_data:
-	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
+	free_shared_pages(snp_dev->certs_data, sizeof(*snp_dev->certs_data));
 e_free_response:
 	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
 e_free_request:
@@ -717,7 +748,7 @@ static int __exit sev_guest_remove(struct platform_device *pdev)
 {
 	struct snp_guest_dev *snp_dev = platform_get_drvdata(pdev);
 
-	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
+	free_shared_pages(snp_dev->certs_data, sizeof(*snp_dev->certs_data));
 	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
 	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
 	deinit_crypto(snp_dev->crypto);
-- 
2.38.0.135.g90850a2211-goog

