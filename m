Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D0B5E702C
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 01:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbiIVXTE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 19:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbiIVXS7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 19:18:59 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC259113B5E
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 16:18:58 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id b9-20020a17090a6e0900b00203a8013b45so5614392pjk.5
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 16:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=jCn2hDAW0p9eYa6Z6hn6TsnE3OussppQKkRgVZYEu/8=;
        b=oJfOK9zvKTFksYNpGApUx1V24DynP/zOujE9BAzzg81NPswEFglkvXOVnM4SSO+NBG
         AuMt62xbhVfP3zg5Mut05O9NR0LffMUHQZci6q+ZInu3sqJUYDGX06VSn04aJmTxPdKG
         OgAY4rtLmWHudKZS5Yjry15LAmqN/KGDzs2gswENs1SVDwGl/aIlNnVo5I98qV9Z7r3I
         67Cz/OmZY2OVGs9PEzkNtsdn0PAGvHpGUlGtmh9FrOr5j4uffgCxlbIoDm2aQl+nLmiy
         EHP6fHqIGHmk95pRvcF+AFiPu2YboxHHKTfSBbZId4MKGBY6kP13uK1nbp9RvwXnm+IH
         dU3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=jCn2hDAW0p9eYa6Z6hn6TsnE3OussppQKkRgVZYEu/8=;
        b=Pj2cPFhDR0iYBE90Pv7kiNvIaybjOhSamkPNECzR6cZdLTlmFXRw4ftktkblv0fHg6
         WSNXZqM9bdu7J1GCvWGW3ufidu3ctlrlZ37nrQJpGek6kDsTVfpMUXI0c3cC5JMhI1gu
         yRJFgaoh0vy0lLuud5rB2tbDbjaev0d0+lcCVoSltvzbXH9BUPsEcN9xBfokvAxN24lH
         osvTXw7uC2z4VciMWBCoAFeamdrRfz0AxbH6sUGPfIW+2URcrKdimfpCd/wmccv34vBs
         H0jFSV11gFpBbtKP9X4YK5z7Bnjfua6OzVWhXBkmJy5iGg397Pw/HmZIvQWe0wu7lRWx
         r3xQ==
X-Gm-Message-State: ACrzQf1HQcbyqEX6fV1MJe8a6BnmxfnYVipc0T2yNYIYZES2M4yRh/hq
        Bd1fKvkKZxIRho2rhRntHadPKCwW05/O9gxkBoM1iFmANG3qAOr6UndUjd6ardETdFW6N9gzPvy
        BEZnmRQUaUFD7uRf0t3+z9osOit1tkr5Ds/CqtOGXIQgPWxj6pfoUcjYrABubahU=
X-Google-Smtp-Source: AMsMyM7niX5jOb8Y1byl4fk+huGKVAaBdwZd+PsqTTX/itk6ctRsDqH6lAxdoAzjr99oxreuYfj67VpIwo+CYg==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a63:b545:0:b0:43c:2ad9:b00 with SMTP id
 u5-20020a63b545000000b0043c2ad90b00mr2457681pgo.535.1663888738108; Thu, 22
 Sep 2022 16:18:58 -0700 (PDT)
Date:   Thu, 22 Sep 2022 16:18:54 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220922231854.249383-1-jmattson@google.com>
Subject: [PATCH] KVM: x86: Hide IA32_PLATFORM_DCA_CAP[31:0] from the guest
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

The only thing reported by CPUID.9 is the value of
IA32_PLATFORM_DCA_CAP[31:0] in EAX. This MSR doesn't even exist in the
guest, since CPUID.1:ECX.DCA[bit 18] is clear in the guest.

Clear CPUID.9 in KVM_GET_SUPPORTED_CPUID.

Fixes: 24c82e576b78 ("KVM: Sanitize cpuid")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/cpuid.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 75dcf7a72605..675eb9ae3948 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -897,8 +897,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			entry->edx = 0;
 		}
 		break;
-	case 9:
-		break;
 	case 0xa: { /* Architectural Performance Monitoring */
 		union cpuid10_eax eax;
 		union cpuid10_edx edx;
-- 
2.37.3.998.g577e59143f-goog

