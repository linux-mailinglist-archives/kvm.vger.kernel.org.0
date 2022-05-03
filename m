Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA52517CEE
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 08:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiECGFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 02:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiECGFm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 02:05:42 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40FF33351
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 23:02:10 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id h9-20020a631209000000b0039cc31b22aeso7996000pgl.9
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 23:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=t8sqG9N3bDSFcIV4nihap+Y9twMBMAx1j91yk1oqLR8=;
        b=fDfjA+1/0+LcqwDGcxHKZd8ionRfBRzNlkOTN7GRUfD8g3bhg8pDQ5uyFL8oq7q6Na
         EoyIu/iVkG0pujF0nu4inS7G6gI1qyWrLNt7VR+u977NM57eXHKDfc+HHstuIZ/YOlTO
         GDC+ESrL/7lSn7TicirueSi7FRTx9SrqRNpNOXTXE81cHJxUvheeDwap8zbAEewVk7Xw
         S2PH5S+5ZjTC3WxCod8/AhC56Ae2bRRJVtADxwVKVzmvIc3DU+qMsrZBlBycKcX9nxTb
         E7GoavZ31OG/uySeQKncbOYShr/2vP/MMsRpnPaocTB96ijBYhHMvKQGff29TkVMYTkX
         vPuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=t8sqG9N3bDSFcIV4nihap+Y9twMBMAx1j91yk1oqLR8=;
        b=4SfHuGb7AGKB2+Ciow3mJF5w/PaWWtDDZY6DaSXUNhnZkKkUsjUaxkU81E8bi0xcAB
         DUZ7V3fwTqyva6iNVw3hf58JLSPgE2ruvellOsCgQQudeF/1EUXEMnXX6XPPU7wiX49Y
         ++hlfManzgXM5fzr2P7DTtftuiEaHLluObUFEQeV7W5DEx9qNMpMZqcDwF8MtrBQCOXZ
         7RBXRtoN8HAyYin9PgMNtxgSXQ2+CgoYyJS2x+bQFwj7cyIrUchxrK2UtMSQOWoSQnHx
         iT/2Ig/kPisTMbKp7PvEZR8VXoD0AObYrOOMyi7aYkBLXPmOG0ofGJsDTaIbM3HTqXHo
         /n7Q==
X-Gm-Message-State: AOAM533GFMXMtaeSwrzGaEP68e0Cuh9wH4UoKkcufCBypB5c+dHra3Tt
        u3asKYZFAqD4sFQWON8TH9ei7MZ4WFA=
X-Google-Smtp-Source: ABdhPJz/UUNAbn5Z/ZnAPcvJcY0XAWJIASeAIpwVIjQ/WB9rW/6OA1St42zCrG6ilBD1/lLbFfGTrlWn5xg=
X-Received: from oupton3.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a63:6c42:0:b0:3ab:7c9c:1faf with SMTP id
 h63-20020a636c42000000b003ab7c9c1fafmr12960528pgc.518.1651557730161; Mon, 02
 May 2022 23:02:10 -0700 (PDT)
Date:   Tue,  3 May 2022 06:01:59 +0000
In-Reply-To: <20220503060205.2823727-1-oupton@google.com>
Message-Id: <20220503060205.2823727-2-oupton@google.com>
Mime-Version: 1.0
References: <20220503060205.2823727-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v4 1/7] KVM: arm64: Return a bool from emulate_cp()
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
2.36.0.464.gb9c8b46e94-goog

