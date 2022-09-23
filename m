Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B52965E85EA
	for <lists+kvm@lfdr.de>; Sat, 24 Sep 2022 00:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbiIWWdq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 18:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiIWWdo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 18:33:44 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5261121658
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 15:33:43 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id v9-20020a17090a4ec900b00200bba6b0a1so655697pjl.5
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 15:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=fmTVhWLO0IRuGHAE9Qnxb5NPTclXZAFN1d2uU0FmFQU=;
        b=GMQZ/UTqwQQS3p7xnbBqZfjIjYylTXQZ6mYnvbj+5F9cOq5t4qvvE0rwicUg5Kcykj
         Hn2V7fz7Jmgeqtsy2baZmcs+AsO/9q3Zn14hQvP13tFg2Faj6++rxstdAxz7haalbtn4
         ewRXmd26TJ6jiiR06f7h341SSMkY8EScEsrkYB3O5Q0mtdc+ZxVvZ2ZqDRc4m8wYTzr0
         yTCvRVjssv/qDTxNho5ePMMf6ev+2hF4FH3GfvSRaoNvGGM47HyJTMhTdsrkIvN48hnR
         VKf7B+7sDQV/DRk6UPi7l8DqMFlrFwG4Jk4cWmNMgNYlt0UKYbb8LOzTe2G1BjoPHK3w
         fBHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=fmTVhWLO0IRuGHAE9Qnxb5NPTclXZAFN1d2uU0FmFQU=;
        b=SFBWp0Ix24sI6SKxLl8zx38Fmz1vBD9lsvV1bKARHKo4KC/gCKBNBIcvk9Fy+skbNL
         xw3rl67L+M3jMjEAQzoVVfBqPZjv23ZXzHj9ax4dNpFLG5ZwHBrVvhkylLIy3TMpcCBW
         tSqkV3pdrd1ctb83PjYYOqNfPfsiCXNilfBOaN1kfvnA9Lj+C3lRTerI0dyk0l+e5kzs
         HQIcbBaweR5EhhbZG/SmUM64f1IKG5hA1iI0zUpxa9fyPtxCb7p9/aj/kRyofeAgmIsY
         e3RJsju4hmPo7UdOk8wZaxFAA2p2ETF0P7ni8qmehgah8J07XPgf0CyvmZ6+y0KJ70QC
         24cQ==
X-Gm-Message-State: ACrzQf14ZdhJSye0jdogLOhnyhrQGi4pYfaC12C+Du4Oz7SS8ME/thN8
        FJpfRMKdjkbSur8yHh8denFSdm5v+p7FItOjwWfM7dDAsoQn+Yn0XduTRx9IF3bo7JpqFzZ1alk
        E6pwJ36BhCiYoFunjlz5/N/WoG30UJ16a5utPFbnayIghyBG5CFSUX5oKkSKdJXs=
X-Google-Smtp-Source: AMsMyM5sN80uDo3wNY+V1FEyd+sP85CRBlK+BZghwaU/Dc/dNyu73WXwzntQxpTNYZ8A4xB0aDOTIjMzZGq10w==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a17:90b:1d0f:b0:202:be3e:a14a with SMTP
 id on15-20020a17090b1d0f00b00202be3ea14amr23388637pjb.102.1663972423280; Fri,
 23 Sep 2022 15:33:43 -0700 (PDT)
Date:   Fri, 23 Sep 2022 15:33:38 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220923223338.483103-1-jmattson@google.com>
Subject: [PATCH] KVM: x86: Pass host's CPUID.16H through to KVM_GET_SUPPORTED_CPUID
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Cc:     Jim Mattson <jmattson@google.com>
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

In the default configuration, the guest TSC frequency is the same as
the host TSC frequency. Similarly, the maximum frequency of the
virtual CPU is the same as the maximum frequency of the physical
CPU. Also, the bus (reference) frequency of the virtual CPU matches
that of the physical CPU.

Pass this information directly from host CPUID.16H to guest CPUID.16H
in KVM_GET_SUPPORTED_CPUID.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/cpuid.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 675eb9ae3948..1527f467d4f8 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1043,6 +1043,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 				goto out;
 		}
 		break;
+	/* Processor Frequency Information */
+	case 0x16:
+		break;
 	/* Intel AMX TILE */
 	case 0x1d:
 		if (!kvm_cpu_cap_has(X86_FEATURE_AMX_TILE)) {
-- 
2.37.3.998.g577e59143f-goog

