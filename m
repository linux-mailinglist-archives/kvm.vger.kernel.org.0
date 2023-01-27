Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847FB67DC5F
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 03:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233626AbjA0Cw7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 21:52:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233236AbjA0Cwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 21:52:55 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009D924117
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 18:52:51 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id u21so3618948edv.3
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 18:52:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=profian-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ytT3Q0695m5Y9Xvmkrg+w4EmcEmCVa0jLjn4WfE//S8=;
        b=KJ38u2Xmat3lo0fPE4H3YTxidKGLp15TIOWnYppX3OUcz/f7hOQYnF8lPZWfoGQLDt
         KoPrbu4E1t2dc/rpiABw6JqFH9d5DSX3OtvP+z1nPVa/6MG1pzxfxGGM2yAEae3XAnbJ
         oK8RexGFhpDzXdvPxwPnRiz8BBZUXtC/luz+uiW2DOq9oLRg5yWw0xGWWjhMRnl1vV65
         WqjLRXn8bNUcPjioT4VcoVBhLED24zwc/Njr8K+/i4UkIcYsY1c4hCud+a3BAb5gT8Cc
         a82U8FqFvx/WMGw10WGey9tl98iidA/qis1WbV2Z/d3Xy273+jvhYjmaLuwYW2qxoikR
         gRtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ytT3Q0695m5Y9Xvmkrg+w4EmcEmCVa0jLjn4WfE//S8=;
        b=SNco5D5Ai60HYlmhV6C5UbK1kHlyvhsKmpUYSTiE11RnucdoKGefEBLFliKfKaJFMK
         m4ibt0DFk0cBUQX+nmIiqJtIKmbOUuPLVPaHC8KPeRxE5dtC9XcgfUKwTLCCTldX8BjP
         F6FGCopSd8VMCeauweWDFCsNLClau78RAapT9TuvBmXoPXTn0RLGkdX700QdwCKXhsnd
         BcGYIjx2UM6UIyVllG1q82jOCAvhUx1xmRfyeEZOF1NxEnNrMoWtsor2JPr00zTGr/wP
         EtXJ0e/lXeqXEDlBkx3NP611jYKOJlJtlblpLT+8i6hn2/+sMl/eX2sPJ5nJke9rWrap
         H68g==
X-Gm-Message-State: AO0yUKXYLxKqPR6xBcoaCTfaiKVkJDz+3aRqO9vjl9ppzQz9TKRAFfOS
        098WecGUPZEjRDYnF4AnrcXImg==
X-Google-Smtp-Source: AK7set+nkhdtXFrQNgkvDYB8ZERdEObgycOgQtX+MVNSxiQIRYslKQ+vrTeV6GnYBIvkirdHfAsx7g==
X-Received: by 2002:a50:9eef:0:b0:4a0:8fc4:6be8 with SMTP id a102-20020a509eef000000b004a08fc46be8mr11338521edf.26.1674787970574;
        Thu, 26 Jan 2023 18:52:50 -0800 (PST)
Received: from localhost (88-113-101-73.elisa-laajakaista.fi. [88.113.101.73])
        by smtp.gmail.com with ESMTPSA id s13-20020a05640217cd00b0049c2b02bad4sm1059790edy.88.2023.01.26.18.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 18:52:50 -0800 (PST)
From:   Jarkko Sakkinen <jarkko@profian.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     Harald Hoyer <harald@profian.com>, Tom Dohrmann <erbse.13@gmx.de>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jarkko Sakkinen <jarkko@profian.com>,
        kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT))
Subject: [PATCH RFC 3/8] KVM: SVM: write back corrected CPUID page
Date:   Fri, 27 Jan 2023 02:52:32 +0000
Message-Id: <20230127025237.269680-4-jarkko@profian.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230127025237.269680-1-jarkko@profian.com>
References: <20230127025237.269680-1-jarkko@profian.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Dohrmann <erbse.13@gmx.de>

When doing a launch update for a CPUID page the firmware checks that the values
conform to the policy laid out in the processor programming manual. If the
values don't conform, the firmware will return SEV_RET_INVALID_PARAM.
In addition to returning an error the firmware will choose some acceptable
values and write them back to the page that was used for the launch update, so
that the VMM can inspect the changes and try again with the corrected values.
This is specified in section 8.17.2.6 in the SEV-SNP Firmware ABI spec.
Because launch updates are always done on the private UPM mappings, the pages
are first copied from the shared mappings to the private mappings. When the
firmware corrects the values, the corrected values are in the private mappings,
inaccessible to userspace. In order to make the corrected values accessible to
userspace, the page containing them must be copied from the private mappings
back to the shared mappings.

[jarkko@profian.com: fixed checkpatch.pl errors]
Link: https://lore.kernel.org/lkml/Y76%2FI6Nrh7xEAAwv@notebook/
Signed-off-by: Tom Dohrmann <erbse.13@gmx.de>
Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
---
 arch/x86/kvm/svm/sev.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6d3162853c33..4a8e552d8cfe 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2230,6 +2230,23 @@ static int snp_launch_update_gfn_handler(struct kvm *kvm,
 			pr_err("SEV-SNP launch update failed, ret: 0x%x, fw_error: 0x%x\n",
 			       ret, *error);
 			snp_page_reclaim(pfns[i]);
+
+			/*
+			 * When invalid CPUID function entries are detected, the firmware
+			 * corrects these entries.  In that case write the page back to
+			 * userspace.
+			 */
+			if (params.page_type == SNP_PAGE_TYPE_CPUID &&
+			    *error == SEV_RET_INVALID_PARAM) {
+				int ret;
+
+				host_rmp_make_shared(pfns[i], PG_LEVEL_4K, true);
+
+				ret = kvm_write_guest_page(kvm, gfn, kvaddr, 0, PAGE_SIZE);
+				if (ret)
+					pr_err("Guest write failed, ret: 0x%x\n", ret);
+			}
+
 			goto e_release;
 		}
 	}
-- 
2.38.1

