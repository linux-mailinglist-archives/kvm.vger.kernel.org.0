Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB5E60FB26
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 17:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235709AbiJ0PGT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 11:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235632AbiJ0PGH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 11:06:07 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F90D8F72
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 08:06:06 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id q62-20020a25d941000000b006cac1a4000cso1721782ybg.14
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 08:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=co6QgImvBY6rg4iltv5GQDLPg23wAqLBYYMlaysrcLQ=;
        b=RKr2mNODlbVwgZbH8QfPexb80BB0KK62G47Vn4P9JLluupGBH+f9mnrZWxTXWE+8EQ
         6W2sgp5Je3yj/2tgVl/WulUUZTGUx27d7Kkhf74NeinxvMQNG6a9fD+8Ded7sxkFqj39
         02sboYXwqP5ihDu2EZum47cC30JOM56VEBtwWCaG6qB4lyVYhMcR2v6WSctPyd5Hkcdw
         xa9YrtTEhKUl+UJOL462AsY3y2urK/U1cF3g6+JXQDyG1iNXPCYf15h8E9OuMT0kE7+N
         glt3+SDD5dM++vBlIsdM1rMfcKxND/joOkoFZAYfJJoH0kvdj5H8pGxWJAT1eVFh3Lfa
         z8rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=co6QgImvBY6rg4iltv5GQDLPg23wAqLBYYMlaysrcLQ=;
        b=f/baxKhSyhiqmQn4naPniUivBGBu1oJy4c7uQm1DJJqSx2xYWpSLUbPbjqgArDDKEr
         alftiw49UbNAcAsydpIGWv8NZj+fHGSFjBcl+XfTQkAoVbmgvwWkz8Kx56UNwAHJ/5rU
         lMOji37u7JWj4Wm34EWdR0OtpLNFn/zIafVGI8Yhbpggew53aW6LpvHu8e9MeWRNN+bZ
         WPt6Rc/tUypTW+7WC4gj6PYB/2tu1XrQRE+a3VR1akQNAZN7FxH0+waLmPhs++5jMs8r
         a/+kkO/Ixa/1mwZ5pUo0+TOerUj4rERIJP6+3Nq4xdiOWP1MloOMiYu0c08Dm5pwM+TA
         bQXg==
X-Gm-Message-State: ACrzQf2oCtc2KFxxX+NZTEFoidr8fd6gBaDkP3Gter2waccB/YLax8Rx
        kQiuYuesPgHH7gQejqbpgXnv91s0QKA=
X-Google-Smtp-Source: AMsMyM5F9bSbPwVvvG2KMJttE2FPFzS3eF1pcrxmO3QwP7b2KjTEfsMBkm7PFZ7TFoj0KLHyVqKc2yO/MDU=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:11:da0c:de35:6ecf:7c48])
 (user=pgonda job=sendgmr) by 2002:a25:9885:0:b0:6b3:e9a7:4952 with SMTP id
 l5-20020a259885000000b006b3e9a74952mr48322400ybo.294.1666883165611; Thu, 27
 Oct 2022 08:06:05 -0700 (PDT)
Date:   Thu, 27 Oct 2022 08:05:58 -0700
In-Reply-To: <20221027150558.722062-1-pgonda@google.com>
Message-Id: <20221027150558.722062-3-pgonda@google.com>
Mime-Version: 1.0
References: <20221027150558.722062-1-pgonda@google.com>
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
Subject: [PATCH V3 2/2] virt: sev: Allow for retrying SNP extended requests
From:   Peter Gonda <pgonda@google.com>
To:     thomas.lendacky@amd.com
Cc:     Peter Gonda <pgonda@google.com>, Borislav Petkov <bp@suse.de>,
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

If an SNP Extended Request is placed without enough data pages the host
will return an error to the guest and tell it the number of required
data pages. If we place an extended request without enogh data page we
can retry the command portion of the request using an SNP Request. This
allows us to keep our command sequence numbers with the ASP in sync
while also supporting the SNP Extended Request's data size querying
capability. This happens inside of snp_issue_guest_request() to keep the
safety of the sequence numbers easy. Any failure
snp_issue_guest_request() should result in no further of the VMCPK due
to issues with the sequence number being the IV in the AES-GCM
communication channel. IV reuse, meaning sequence number reuse in this
driver, can result in the secure channel being compromised.

Signed-off-by: Peter Gonda <pgonda@google.com>
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
 arch/x86/include/asm/svm.h              |  6 ++++++
 arch/x86/kernel/sev.c                   | 28 ++++++++++++++++++++-----
 drivers/virt/coco/sev-guest/sev-guest.c |  2 +-
 3 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 0361626841bc..3886b8ea18ae 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -585,6 +585,12 @@ struct vmcb {
 				(unsigned long *)&ghcb->save.valid_bitmap);	\
 	}									\
 										\
+	static __always_inline void ghcb_clear_##field(const struct ghcb *ghcb) \
+	{									\
+		clear_bit(GHCB_BITMAP_IDX(field),				\
+			  (unsigned long *)&ghcb->save.valid_bitmap);		\
+	}									\
+										\
 	static __always_inline u64 ghcb_get_##field(struct ghcb *ghcb)		\
 	{									\
 		return ghcb->save.field;					\
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index a428c62330d3..3f7e2105ef97 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2213,12 +2213,30 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, unsigned
 		goto e_put;
 
 	if (ghcb->save.sw_exit_info_2) {
-		/* Number of expected pages are returned in RBX */
+		/* For a SNP Extended Request, if the request was placed with
+		 * insufficient data pages. The host will return the number of
+		 * pages required using RBX in the GHCB. We can than retry the
+		 * call as an SNP Request to fulfill the command without getting
+		 * the extended request data.
+		 */
 		if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST &&
-		    ghcb->save.sw_exit_info_2 == SNP_GUEST_REQ_INVALID_LEN)
-			input->data_npages = ghcb_get_rbx(ghcb);
-
-		*fw_err = ghcb->save.sw_exit_info_2;
+		    ghcb->save.sw_exit_info_2 == SNP_GUEST_REQ_INVALID_LEN) {
+			int npages = ghcb_get_rbx(ghcb);
+
+			ghcb_clear_rax(ghcb);
+			ghcb_clear_rbx(ghcb);
+
+			ret = sev_es_ghcb_hv_call(ghcb, &ctxt,
+						  SVM_VMGEXIT_GUEST_REQUEST,
+						  input->req_gpa,
+						  input->resp_gpa);
+			if (ret)
+				goto e_put;
+
+			input->data_npages = npages;
+			*fw_err = SNP_GUEST_REQ_INVALID_LEN;
+		} else
+			*fw_err = ghcb->save.sw_exit_info_2;
 
 		ret = -EIO;
 	}
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 8c54ea84bc57..ede07c0ec0c3 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -496,7 +496,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	if (!resp)
 		return -ENOMEM;
 
-	snp_dev->input.data_npages = sizeof(*snp_dev->certs_data) >> PAGE_SHIFT;
+	snp_dev->input.data_npages = req_cert_len  >> PAGE_SHIFT;
 	ret = handle_guest_request(snp_dev, SVM_VMGEXIT_EXT_GUEST_REQUEST, arg->msg_version,
 				   SNP_MSG_REPORT_REQ, &req.data,
 				   sizeof(req.data), resp->data, resp_len, &arg->fw_err);
-- 
2.38.0.135.g90850a2211-goog

