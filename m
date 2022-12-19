Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B37E65154E
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 23:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbiLSWHO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 17:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbiLSWGm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 17:06:42 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94A1167F3
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 14:04:25 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id n5-20020a170902d2c500b00189e5b86fe2so7754224plc.16
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 14:04:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IcOxVrMFtonV2JcJvLKuNirvT3tsAql2W8+eBXYCUW8=;
        b=Cb+dorP/Ez/xVGt+7se+4/cx8/UREubLq3yumt/Cida8VPKvOw0A/2hH+YtqzBx+y+
         +7y38mr3rU43VhaV+knSDQ5bsxNbAxUFeja9rEODMrz/c0zMuEljFFAdOkiivDiHksXh
         Euuh8mMWH2So1mWPnZnDtMdBVYYtw3IADWFmeGHVoSUYIxfmJ2daBghBNOmA8XDduEnO
         GCJ79ha6409HSSzYSaMwWGcAbHOqbe9LuSH/jC23QKtgq0PhaNUkPPWXU5okq7hg0R3V
         dEpERvPZcHBhHpDiwunuWjfgpDt2uTVr8wCNIvqpIcV3P6DH9XSo9qtbQPTTQuQSdDzZ
         P9lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IcOxVrMFtonV2JcJvLKuNirvT3tsAql2W8+eBXYCUW8=;
        b=GTn08vsyM3fZy1msxpqQcw6Y+9Eq8nmdKVkLiwG6idbKeZFTJ5TvP105HvXTl2aYaL
         uXzCn68sQzJuuJhREKqB/5bks4Yn4Lzas1HSqyfvKLYdLa/KSgV2G9StfjRgxLTPaSId
         rL4S3nSm5Y0vvgRB8yHPZkb6Y/dWUWyViy7N8SpP6to+/DHiH0iNwviCdtkIdqyEBg6y
         XRlmEjTjCyPZVT054YFDuvzwuWmS8ib7CXlYnVPQxOxnMFJsIkKRoc6iCCgjIJJNkL1+
         /g/LOMFe17zrZFf0gLC0c/LSd4YLT/cPWrujO+TXMwszWcIbjqXf/uWWxesUw9bjiY02
         94Qg==
X-Gm-Message-State: AFqh2kry3RWVTkF+w/xaFsWaj2aaiIdc5OLyN3eU7AvvPL96oqIgo/wy
        tZrxenj3/+mHRq41X/qImstjEnNIha0=
X-Google-Smtp-Source: AMrXdXte8mRIyw/ZPDbnFxHME9VBMGtfTslaf8S1qgynZruPms70MgakdhbKwiWxLl1Ahh/ff797KQrqfSc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d318:b0:220:1f03:129b with SMTP id
 p24-20020a17090ad31800b002201f03129bmr294532pju.0.1671487458819; Mon, 19 Dec
 2022 14:04:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 19 Dec 2022 22:04:16 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221219220416.395329-1-seanjc@google.com>
Subject: [PATCH] KVM: selftests: Zero out valid_bank_mask for "all" case in
 Hyper-V IPI test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
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

Zero out the valid_bank_mask when using the fast variant of
HVCALL_SEND_IPI_EX to send IPIs to all vCPUs.  KVM requires the "var_cnt"
and "valid_bank_mask" inputs to be consistent even when targeting all
vCPUs.  See commit bd1ba5732bb9 ("KVM: x86: Get the number of Hyper-V
sparse banks from the VARHEAD field").

Fixes: 998489245d84 ("KVM: selftests: Hyper-V PV IPI selftest")
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/hyperv_ipi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c b/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
index 8b791eac7d5a..0cbb0e646ef8 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
@@ -193,8 +193,9 @@ static void sender_guest_code(void *hcall_page, vm_vaddr_t pgs_gpa)
 	GUEST_SYNC(stage++);
 	/*
 	 * 'XMM Fast' HvCallSendSyntheticClusterIpiEx to HV_GENERIC_SET_ALL.
-	 * Nothing to write anything to XMM regs.
 	 */
+	ipi_ex->vp_set.valid_bank_mask = 0;
+	hyperv_write_xmm_input(&ipi_ex->vp_set.valid_bank_mask, 2);
 	hyperv_hypercall(HVCALL_SEND_IPI_EX | HV_HYPERCALL_FAST_BIT,
 			 IPI_VECTOR, HV_GENERIC_SET_ALL);
 	nop_loop();

base-commit: 9d75a3251adfbcf444681474511b58042a364863
-- 
2.39.0.314.g84b9a713c41-goog

