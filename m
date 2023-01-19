Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6A6674542
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 22:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbjASVxv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 16:53:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbjASVxN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 16:53:13 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACAAB1EC9
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:34:34 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id x8-20020a17090a8a8800b0022941842cc0so3954575pjn.3
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XP5abnKwoWHYzfvPZhByiAlFcIOsPkv0onTEpyjGkOA=;
        b=i4TDJZV9AsYZggXWT49Rh8u+Cqa1ja4Ok/tTT96quI+KK+vj/fKuizWOfYp3FBC28G
         RgcXCk0MTknMVs0eGoHSVbG5x5Jh2QrCBOtiIAM/pZitOj/QH/+EbKRD1hX/LGfTSXEm
         XdsGBNAQ1ve/IjyYAwCzZSBEpL1hNp7b8UEhbvKQjIAJiBG/QuhbRtiR7kReLh1wR9un
         31CWO+3vnlDRNAe5wq9dDA9jC58lWSjR586Au3LI6Iuwb43aSzMweU/Z0WY31q2ZeFME
         jKluDnzlI9UyLtChnv4pZFVa+xdS3hjuPDq84zkdKmAGMXE59wBBT0khj6vWbkskA18m
         i1sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XP5abnKwoWHYzfvPZhByiAlFcIOsPkv0onTEpyjGkOA=;
        b=Xs6xtNHfTBk/1KNG894pYoU0gzVq9g1280gIWsv1gHImXv+Zh8+3ErgbFAVwKcWxf1
         x+TirQV3dmNtB0nsO9kH7lvAEvcnwsTAPU6HL24Hk4DBCbFyi7t62X1S1Z69c+NitnZW
         kMhEi0xU88xu+jz3llDtRFEekyaBObyGULBdJWzjFIVpaZTyIBaU3RGsZ+6WSmTIXbff
         mq4hmXsVtNg6vJiy+i5xqescI0c3CsRvr1CKWzXusZiC497Lb7Nn/g0FSL4KVdYtF+a3
         Ee0wxB0AXYvxpXoo2BJ+xFAD5Nii+tz35gQXVCWp6yv4JwTFjOYaXBCxB7KEpiUhRtxY
         Hfyg==
X-Gm-Message-State: AFqh2kpjee/g8ND5hHHh5m9d7p2PE9Jo5QZiMfSn1RZiUqjxMXh34GRf
        h2Hf/BGW7ryHn1To6W1LxHREp8lZDgCub6iSfkVEHiDR5mp12aG1N4sqaltIGvvJgOEtsdkMeqU
        UikEUnIGZDky4qML6COxhlG5S6a8EMq0ho8ZF06YpkIJPteL6lmPqrOt/5Fh/5U9dACzmXE0=
X-Google-Smtp-Source: AMrXdXvNYervhBkZcdhUEFpRVywQkR7lK/Et6wxL6MXKVleX90gS/xRSqlXGxsj5OxYrd15e9POisxZ7yWd9E0mRUg==
X-Received: from dionnaglaze.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2ee6])
 (user=dionnaglaze job=sendgmr) by 2002:a05:6a00:4088:b0:586:7e0c:372d with
 SMTP id bw8-20020a056a00408800b005867e0c372dmr1215084pfb.14.1674164072489;
 Thu, 19 Jan 2023 13:34:32 -0800 (PST)
Date:   Thu, 19 Jan 2023 21:34:25 +0000
In-Reply-To: <20230119213426.379312-1-dionnaglaze@google.com>
Mime-Version: 1.0
References: <20230119213426.379312-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230119213426.379312-3-dionnaglaze@google.com>
Subject: [PATCH v3 2/2] kvm: sev: If ccp is busy, report throttled to guest
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ccp driver can be overloaded even with 1 HZ throttling. The return
value of -EBUSY means that there is no firmware error to report back to
user space, so the guest VM would see this as exitinfo2 = 0. The false
success can trick the guest to update its the message sequence number
when it shouldn't have.

Instead, when ccp returns -EBUSY, that is reported to userspace as the
throttling return value.

Cc: Thomas Lendacky <Thomas.Lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Peter Gonda <pgonda@google.com>
Cc: Borislav Petkov <bp@alien8.de>

Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
---
 arch/x86/kvm/svm/sev.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index cd9372ce6fc2..7da1cc300d7b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3642,7 +3642,14 @@ static void snp_handle_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t
 		goto unlock;
 
 	rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &err);
-	if (rc)
+
+	/*
+	 * The ccp driver can return -EBUSY if the PSP is overloaded, so signal
+	 * the request has been throttled.
+	 */
+	if (rc == -EBUSY)
+		rc = SNP_GUEST_REQ_THROTTLED;
+	else if (rc)
 		/* use the firmware error code */
 		rc = err;
 
@@ -3713,7 +3720,14 @@ static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gp
 	if (sev->snp_certs_len)
 		data_npages = sev->snp_certs_len >> PAGE_SHIFT;
 
-	if (rc) {
+	/*
+	 * The ccp driver can return -EBUSY if the PSP is overloaded, so signal
+	 * the request has been throttled.
+	 */
+	if (rc == -EBUSY) {
+		rc = SNP_GUEST_REQ_THROTTLED;
+		goto cleanup;
+	} else if (rc) {
 		/*
 		 * If buffer length is small then return the expected
 		 * length in rbx.
-- 
2.39.0.246.g2a6d74b583-goog

