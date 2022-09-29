Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5805F5F00FA
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 00:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiI2WwI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 18:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiI2WwH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 18:52:07 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E604F11F12E
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 15:52:06 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id x23-20020a634857000000b0043c700f6441so1729303pgk.21
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 15:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=V4eWuSKSPKJlqNoIa//vxG4wlWJfnC/SYZGbcsXbf6w=;
        b=R/r/ai6vYpuAt1Hn990qxXkYTY/pAZ2al1R85xVfesPEkpLG1Y6shkMcSOREamNZJD
         uYp0vkYqISP9KG4ocIKsqJxP4fEkWdcx++MnWIW3dmwrezP8NnfkBZm/Y94pzkabP5FX
         SYsI7U4/ciLBinsiz+5U6WHK2YB8sdxrQP0HrWig26R4ika6Q2162D8+ucA034gjfiUE
         xPJVwszt/hkZbtZkJDrIIqOZVVdWneJzh9cGlPjbqwt3DqNJaHhFVQFUye/92SgSd7th
         fEs1JoTrcy6xOyFOn/lw5eV8YPFj2z3zTcrHJmv+IlLdqQXBRj3wJwsAieg3vlM5cuOr
         AZ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V4eWuSKSPKJlqNoIa//vxG4wlWJfnC/SYZGbcsXbf6w=;
        b=fAk6S0XfDTVgGYI1TjFOusoYCMyrzV5VLRZMmOfreRVoQSNHGZypn6uQs7emAtggNo
         fg8oeeJLs9OEE2DhEXAL468BM2PbF0XKk0APK9MvKj5S8sxDBDbL6hgjHbKS4QU7PGUl
         iW0+pCunUq8n0gq37uvnQYHHVvB+ws87AU5AfIE7QZY/eOKzYrWsUg5McZjIOHJ0Ww4/
         Hhk94brYGCgDTvBQMuhI5lvZ95gjHK8mqi3XOUNYmzqNcV+qOuDkYlimnQbPYucZwdwi
         WogEKi0rPP8v8BCn/BCGr9BXUVsokC1gx1WTc57iMSWltr/bbguyMNy0aIyQrh2L3jah
         IM7w==
X-Gm-Message-State: ACrzQf06G/ctcqn/CHjoTdPB5nKl0fM54LerhdfOVHUkBaYdQsfhDxut
        IEdv9muOmyOiha8WwkCAZm/vlf5vRtyJD1HvHPqkekDuwG4apuwPltilZAe52mUPIBprscIqyyp
        /sWSh6k8XHLRWdPkbMcxPApFnNaNLvxtf/HGAGyZYF3H6V9POwMC1M7B+ZIxp0cw=
X-Google-Smtp-Source: AMsMyM7tTGvnTuBuKN4ZLrQLHZnGnHJnVtkn/jU1BgjYT3Ze8ziDNYs84szVUGE/NdEheQ5MGEOIIgmcnGnWFg==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a17:902:c9cc:b0:17a:a81:2a8c with SMTP id
 q12-20020a170902c9cc00b0017a0a812a8cmr5733116pld.6.1664491926372; Thu, 29 Sep
 2022 15:52:06 -0700 (PDT)
Date:   Thu, 29 Sep 2022 15:51:58 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220929225203.2234702-1-jmattson@google.com>
Subject: [PATCH 1/6] KVM: x86: Mask off reserved bits in CPUID.80000001H
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

KVM_GET_SUPPORTED_CPUID should only enumerate features that KVM
actually supports. CPUID.80000001:EBX[27:16] are reserved bits and
should be masked off.

Fixes: 0771671749b5 ("KVM: Enhance guest cpuid management")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/cpuid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 4c1c2c06e96b..ea4e213bcbfb 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1119,6 +1119,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			entry->eax = max(entry->eax, 0x80000021);
 		break;
 	case 0x80000001:
+		entry->ebx &= ~GENMASK(27, 16);
 		cpuid_entry_override(entry, CPUID_8000_0001_EDX);
 		cpuid_entry_override(entry, CPUID_8000_0001_ECX);
 		break;
-- 
2.38.0.rc1.362.ged0d419d3c-goog

