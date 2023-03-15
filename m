Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71EF6BA512
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 03:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbjCOCSR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 22:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbjCOCSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 22:18:08 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA6B22CB5
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 19:18:08 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 204-20020a2514d5000000b00a3637aea9e1so19133669ybu.17
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 19:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678846687;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yfFTGhbbVraDRgVNXHu8uvOvYJ9e5XPaW8umznc0CcA=;
        b=iuPFeNQCLIKVWv/PcGHPSOQF56F84Z4k6pPGo0DhTV127D1hJTtMM4gCrWjMuL5kRT
         m2Ic2ugK52Um0iz4hpxkEYyFnEchVCLlI1OD/bE0XEmAzddQ/0Af0m/wcu0ceOniHJL8
         GtuxDu170BEQ8m1x+ZGwUWOiXs3VL9khy0XLBscsfq6UdfMwA95HDdxASJuGKo7tMd1E
         69rAtrdkNEAvjcQXcjLHzQTPRJG7zEn4PvIAxEcrswUatNFATsZOvLt0Qv23jKg2cnLC
         L9YMXDOb8x6OqbR3DF8hZ+XI/k8ZpuBHq451/BJlxUmFn3RUZsJCwjQEJPwlXtgd3bwZ
         zYhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678846687;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yfFTGhbbVraDRgVNXHu8uvOvYJ9e5XPaW8umznc0CcA=;
        b=BMKe9q9FEqiOQm68jqszBEKoxGSIILc6vg88aWXnhF6+CEdAP6gDWhxSI68v1zjsbG
         RFENgC0i06v10dYt1ifIYYd61vA24PGF14OGDmUurJ4VlpooNy10k/9mlB2FZWDtDQtS
         VQP6i21LITP/PNIC9P2mDvEiiXLJ8H7OxjgB+nEJPgidoJbPaFIk7uaKv/Km7tM172Xi
         1hHAz5rrf8Jozm/jjJ5UaOeruzlU/AGEHoSe0o6ndUzlADaylRgFyfoz0IPQMZgp4JL/
         n1Pytf81XOsi+VaFGRZ/ffJr6O8b/+fm89Os3AwVxTzKsuxd0S+5uhgDT0f+Pv9SdNMJ
         lqDg==
X-Gm-Message-State: AO0yUKVzptEfDwfojAIKXvltmy4HAXuFqxDyDI9PqhY9MheQTEiOrsDC
        mcKDEi1oREWDhYJF1ndIuCBOSS0F/OQFcQ==
X-Google-Smtp-Source: AK7set9NS3+w2A3CePKXQBzZnfMtJpEuyDhal2sNJnOm7hnztem4I38hnaHSRurYYAV88qWsTKdT9/k8B6I1wQ==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a81:ef01:0:b0:541:66a2:dd93 with SMTP id
 o1-20020a81ef01000000b0054166a2dd93mr9094443ywm.3.1678846687407; Tue, 14 Mar
 2023 19:18:07 -0700 (PDT)
Date:   Wed, 15 Mar 2023 02:17:31 +0000
In-Reply-To: <20230315021738.1151386-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230315021738.1151386-8-amoorthy@google.com>
Subject: [WIP Patch v2 07/14] KVM: x86: Implement memory fault exit for setup_vmgexit_scratch
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com
Cc:     jthoughton@google.com, kvm@vger.kernel.org,
        Anish Moorthy <amoorthy@google.com>
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

---
 arch/x86/kvm/svm/sev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c25aeb550cd97..c042d385350de 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2683,7 +2683,9 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 			pr_err("vmgexit: kvm_read_guest for scratch area failed\n");
 
 			kvfree(scratch_va);
-			return -EFAULT;
+			return kvm_memfault_exit_or_efault(
+				&svm->vcpu, scratch_gpa_beg, len,
+				KVM_MEMFAULT_REASON_UNKNOWN);
 		}
 
 		/*
-- 
2.40.0.rc1.284.g88254d51c5-goog

