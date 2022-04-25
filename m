Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF3550ECF0
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 01:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238381AbiDYX4y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 19:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238325AbiDYX4w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 19:56:52 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216B745AE2
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 16:53:47 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2f7c5767f0fso62886327b3.4
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 16:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7I/ymirdAiT7TDA2OEpHDGEYZgcTkJFO31W7cy5XbpM=;
        b=GIEXDRW1lPHYxJDlewu1cQeA6Q+QhOYQG/Xg8+PRoE5TU9K+EszCSi+GS/y1yYdqKQ
         k/hrOFfkpq5XjEnBTx1gg0IKP9CD+wqs+KYV8IBKykKdf6qgUHxeHd55YceasrVFn9mw
         o9HKcPVnYwI3o4aMI2OPjArD2rckzGSvUFmrO9xNvkgk8klD1nMq/kohI2CdazTjq5Jf
         Ak0UhNEI4w4AqZKNdd5wNvgAXTUDy724YE2e5d8zmzpUkKbcZxng8IF+DponlhaL7c8x
         LL6EDVRikFw7s5dE77bM9YkXLHYb5Nfbwh93Bes5BL+1D2/4yHIP4wXj4e8Sme3DIay7
         twfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7I/ymirdAiT7TDA2OEpHDGEYZgcTkJFO31W7cy5XbpM=;
        b=jl5JR6gQ+X2y2NCCc6mgqj3QBTcy2kfnnH6pR7BF9n1ianmYS3e4EZa9gzzeWQmYNd
         G0UyLGyH7TeqBfuxuSUo75/mFy6IYoIzxz4CRr3kMuMlTAcuK15egetUCfybivsIGEgJ
         0SknkZmiiXAd7cW40W5pk+Bjp3Hd7ZSO/dCYYEQDXwEyRi5wPRzUdwioolrz+9t9Iz93
         3TaAQr+4soPD6KYUulcOFAK9bOFjbafqCbiiW36d+5bxMEAgDg5jtoDKSlKzGs0M86pF
         xNjPwZBpxtlAHAksmtJrbp0MzyhdrEy5GhG0rxt8ibklNQX/GtQJDGPOIzp6PwyxZG64
         7lZA==
X-Gm-Message-State: AOAM530hmKyaSwx0HfYEcgxQGkQ7lVXc4XzibLuY8HTVJUR0sI3KWBmw
        L8PKCtjmNisLGcIFfSQXszLdwnPm8yI=
X-Google-Smtp-Source: ABdhPJyjGc04tDLhhnCLskCP5jrH+A6ez9JfIN9/o5bxHFb6wiRVScPynPJ1gA3GO95ctuwxRLPE7a7ohO0=
X-Received: from oupton3.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a25:240c:0:b0:645:d54e:830f with SMTP id
 k12-20020a25240c000000b00645d54e830fmr16918344ybk.34.1650930826367; Mon, 25
 Apr 2022 16:53:46 -0700 (PDT)
Date:   Mon, 25 Apr 2022 23:53:38 +0000
In-Reply-To: <20220425235342.3210912-1-oupton@google.com>
Message-Id: <20220425235342.3210912-2-oupton@google.com>
Mime-Version: 1.0
References: <20220425235342.3210912-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v3 1/5] KVM: arm64: Return a bool from emulate_cp()
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        reijiw@google.com, ricarkol@google.com,
        Oliver Upton <oupton@google.com>
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

KVM indicates success/failure in several ways, but generally an integer
is used when conditionally bouncing to userspace is involved. That is
not the case from emulate_cp(); just use a bool instead.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/sys_regs.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7b45c040cc27..36895c163eae 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2246,27 +2246,27 @@ static void perform_access(struct kvm_vcpu *vcpu,
  * @table: array of trap descriptors
  * @num: size of the trap descriptor array
  *
- * Return 0 if the access has been handled, and -1 if not.
+ * Return true if the access has been handled, false if not.
  */
-static int emulate_cp(struct kvm_vcpu *vcpu,
-		      struct sys_reg_params *params,
-		      const struct sys_reg_desc *table,
-		      size_t num)
+static bool emulate_cp(struct kvm_vcpu *vcpu,
+		       struct sys_reg_params *params,
+		       const struct sys_reg_desc *table,
+		       size_t num)
 {
 	const struct sys_reg_desc *r;
 
 	if (!table)
-		return -1;	/* Not handled */
+		return false;	/* Not handled */
 
 	r = find_reg(params, table, num);
 
 	if (r) {
 		perform_access(vcpu, params, r);
-		return 0;
+		return true;
 	}
 
 	/* Not handled */
-	return -1;
+	return false;
 }
 
 static void unhandled_cp_access(struct kvm_vcpu *vcpu,
@@ -2330,7 +2330,7 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
 	 * potential register operation in the case of a read and return
 	 * with success.
 	 */
-	if (!emulate_cp(vcpu, &params, global, nr_global)) {
+	if (emulate_cp(vcpu, &params, global, nr_global)) {
 		/* Split up the value between registers for the read side */
 		if (!params.is_write) {
 			vcpu_set_reg(vcpu, Rt, lower_32_bits(params.regval));
@@ -2365,7 +2365,7 @@ static int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
 	params.Op1 = (esr >> 14) & 0x7;
 	params.Op2 = (esr >> 17) & 0x7;
 
-	if (!emulate_cp(vcpu, &params, global, nr_global)) {
+	if (emulate_cp(vcpu, &params, global, nr_global)) {
 		if (!params.is_write)
 			vcpu_set_reg(vcpu, Rt, params.regval);
 		return 1;
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

