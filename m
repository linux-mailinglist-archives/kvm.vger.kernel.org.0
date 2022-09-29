Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 560D55F00FF
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 00:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbiI2WwQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 18:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiI2WwP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 18:52:15 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3DA121E57
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 15:52:13 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id y5-20020a25bb85000000b006af8f244604so2314011ybg.7
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 15:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hadg+lm+nkNCaYkA72NdHm0NRhAZLGplvS73GQ+/TRc=;
        b=ABGUJ9Yv0pM+AIJQ7JzmQxV02K8m+6iMbU/F/Vu379+x/VcfA7rk5Rm6+zeKn4upmn
         KxjHDF8TpLZp4UGK9DB7ke+1aaFpZrfjGAaSojerzJ6Ief/64IpsvhOi6l6RMPBP9KM/
         LpgKowBM6uEWO4nul1iroJ0hu6WQ6ZZ3VYGRGtE6xSWmMWhnX0p0Q8g1gEpTWGuaxZPh
         vg40bTQHY7P5FVUh2yTvI7louzO9siCQqVwSGr4+euVGaI4mV3h+vw7Y0CKlgLxFSMM7
         sOEOVFhYnDMDWSS6kxGeaY6cNwx0/xd0BbBSvJdRqJczupYp57N2Si+VTyBYITKSsDn+
         kvxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hadg+lm+nkNCaYkA72NdHm0NRhAZLGplvS73GQ+/TRc=;
        b=TKSf8A6KVi2TI3tkiu9rCgt6Km+ajbpOrdW0X490616UdYyy4oGdAW2IGgdbsLThM9
         v60OMHSrNjBSn1FTskQoqaGbZX+t2rq+hvANgJQSw5WFXdmIEGxc9tT7v7SuyNqCiJUg
         44DkJW+cc8+PkjLZbsEVhEyNnyP+dHBDOB3SoKT+2EXHSL1kXTL9OU9X+fLAmyu80Ug5
         Zez8Lc7pSdhuPGmUDrFdyVDsm6eebXZ6Xv2dKUR9l8Kvubo3GW8f08+ZzhfHXzDSWlUs
         51m1da3kgoflfY2UCijwMMJsDocSdsu/osiylrNq+6snneQV2rmKNuECO/HLcZeXy6V4
         honQ==
X-Gm-Message-State: ACrzQf0Srm2l65M2sGEKzE2fj5UWIkcPqILRdAdbV6wV3HidtQxWnwYl
        s9m/cI2kM5g33DDuZ8N0nS5y4o8mnVJZTwTU4WWv6G2izxgw4NF7fznaU3qoKsgndZHkdMo/gz9
        I6V6A12QE2y2q3IIqzSWKwDVKRZf+P9DftJXNZiQDos1hfLeADy9LY6ABDLt3a+4=
X-Google-Smtp-Source: AMsMyM6y/h1Dj45smACOkFcxRvcPtZS5QrXvKhea6yBQZfK5IAWHR4HVM3XwAutNP64R3lRDJCKAWDIi+0AzQQ==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a25:660e:0:b0:6ad:896c:f8d0 with SMTP id
 a14-20020a25660e000000b006ad896cf8d0mr5915265ybc.517.1664491932816; Thu, 29
 Sep 2022 15:52:12 -0700 (PDT)
Date:   Thu, 29 Sep 2022 15:52:02 -0700
In-Reply-To: <20220929225203.2234702-1-jmattson@google.com>
Mime-Version: 1.0
References: <20220929225203.2234702-1-jmattson@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220929225203.2234702-5-jmattson@google.com>
Subject: [PATCH 5/6] KVM: x86: Mask off reserved bits in CPUID.8000001EH
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
actually supports. The following ranges of CPUID.8000001EH are reserved
and should be masked off:
    EBX[31:16]
    ECX[31:11]
    EDX[31:0]

Fixes: 382409b4c43e ("kvm: x86: Include CPUID leaf 0x8000001e in kvm's supported CPUID")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/cpuid.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 5d1ec390aa45..576cbcf489ce 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1179,6 +1179,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->ebx = entry->ecx = entry->edx = 0;
 		break;
 	case 0x8000001e:
+		entry->ebx &= ~GENMASK(31, 16);
+		entry->ecx &= ~GENMASK(31, 11);
+		entry->edx = 0;
 		break;
 	case 0x8000001F:
 		if (!kvm_cpu_cap_has(X86_FEATURE_SEV)) {
-- 
2.38.0.rc1.362.ged0d419d3c-goog

