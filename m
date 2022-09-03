Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 329E75ABBC5
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 02:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbiICAZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 20:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbiICAZB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 20:25:01 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2443B112EC8
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 17:23:58 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id h12-20020a170902f54c00b0016f8858ce9bso2108776plf.9
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 17:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=yq8rKHnlAx/4DWABYX1mFX9uFU/+PCTlIPB312439UQ=;
        b=TKFhg3LAJMrV16A/4dAGF27lXzJUSFetR+f3A80VfApjg2+P9tJXoDm6Z4U9IUeY30
         8jYY5yBOQWSFVC4BZ8MG9yoVBTSaBi7zNiArYlzrQLsEVTNjAzJVGoZr1Jl4sRa/1U/9
         +VTq3+oQ/it6ZH+V3BCoPWC+XRGMG2N7F7hTW+vz6yq0GaP5GcqC+Io0VDVELUt/ntC7
         MFlXLZEQpFQuO1akDGR9LdSbdY/5kt4hqBh6wmak0PO0cNrqVz1wyIsuPlvI7rwQX8oF
         KNf3vHYei0aZVGJgxZer2NGpWwoFt4lToHld1QfOSsl48RHmZpkn5Ho8BnKridvsT9d5
         zxHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=yq8rKHnlAx/4DWABYX1mFX9uFU/+PCTlIPB312439UQ=;
        b=FqQDVSLjz5WXjVD3vX80yRleGnivaOH0PksdKW11lAWBRW1HBfL+s5YnEpq1ASkfIc
         tZXJE0sh2VARxEbPFoDTqXn/Aca5l6er36ssiqfr7VtUFCIF/VXcslC12KjVRT9iDrpf
         pfiXvpFJBKH39WafzCOMHQOJ9CUvNwZacXDfvru+VXwOtN1GG1q8xlo0LIBX0wxc3IA4
         xVPY/7UvfdfZut3WnHUTtia74pAdYLIKQVJiayAaYiNbHrUWJA9JJrwT4AIlb3k8+YRz
         /Bft5rLs2JkJiJ3FtWKXt1oufRIYJSeZc4HC5+PflU3Y08QsuY+eI419g/Uz/bxXlKCq
         RFAQ==
X-Gm-Message-State: ACgBeo2dNoaT+4bBUzeRR4Jp3b0blgrP/lmddACIdJrFegWXagEqwCuG
        kKksA224TAplgQHy9owgcRpkHSloZWE=
X-Google-Smtp-Source: AA6agR4Bc9TlcFnkBSJ7Ifwme04Amv5NR4xxJxrKUpqAqHbGDTd3OghEmb9cnpUzT3+MkQMR6v4nBPcxnmk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:150e:b0:537:e2f5:dc87 with SMTP id
 q14-20020a056a00150e00b00537e2f5dc87mr34332719pfu.44.1662164617809; Fri, 02
 Sep 2022 17:23:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  3 Sep 2022 00:22:54 +0000
In-Reply-To: <20220903002254.2411750-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220903002254.2411750-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220903002254.2411750-24-seanjc@google.com>
Subject: [PATCH v2 23/23] Revert "KVM: SVM: Do not throw warning when calling
 avic_vcpu_load on a running vcpu"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Turns out that some warnings exist for good reasons.  Restore the warning
in avic_vcpu_load() that guards against calling avic_vcpu_load() on a
running vCPU now that KVM avoids doing so when switching between x2APIC
and xAPIC.  The entire point of the WARN is to highlight that KVM should
not be reloading an AVIC.

Opportunistically convert the WARN_ON() to WARN_ON_ONCE() to avoid
spamming the kernel if it does fire.

This reverts commit c0caeee65af3944b7b8abbf566e7cc1fae15c775.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 17c78051f3ea..a13279205df3 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1064,6 +1064,7 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		return;
 
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
+	WARN_ON_ONCE(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
 	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
-- 
2.37.2.789.g6183377224-goog

