Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB8D5F00FE
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 00:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiI2WwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 18:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiI2WwM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 18:52:12 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F91E12058F
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 15:52:11 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id r7-20020a632047000000b00439d0709849so1721466pgm.22
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 15:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=voXt1o9YrEllvbmoR+hpYnDIlHSpu5NrRGVSNr9FTeA=;
        b=HOMMF0opfRAmcrQ1yYM+KjgVLYxoCbsVy8idpRfyWzRWT9staJ4U+S0ht6XP/7e2cz
         UnzTRdkCQ2Xtb+AwtuE71/tg0Fzv+WxZUakky72WKcMKQTHaD0A4Qoi17zAe3hEfmrfo
         GqKYL7QYyavJe4lMI1Kmayp2XBePQgpspBsOE2G0wcnd0wWjK5rr/p6M9MS5/ElxA3uv
         Ht4iflpa3pF3Og5XNYgTRxyH+A2iLDJN20mgmiw5EBsaEY7oYwZRrq8ILiczBoFyBJ61
         jojky/b8rNxneAkKyE/BfFD5Rf2JjqvSW3L29K7bWuuvRT5Q7OMow4bFraErOJ5QNa6c
         B9Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=voXt1o9YrEllvbmoR+hpYnDIlHSpu5NrRGVSNr9FTeA=;
        b=dB3JpnunJyA0bpgEJt6GZfYPdTb1PiIUZV7L2h7f4z+RJxQoLmig22dzCwrvSkxUD9
         EJGVyxP113P4am2VvdR6yIWgnHRVKW4HQlkFAFI3qeWbnJLnS022MIVWkKXB3hI5dW5I
         lcB/pTX9tqwkEa1OJX7Y7gfRwhmQkM0kd7NVC350Z7YnmVsPEYfLUs/qJmO6iUgXnUGn
         gFXMte8w9DRf9fPx3kzxNR2h+LZCq7XvK1V6llGK3D40npO+uzOArmxI7X0zvf/QOA/y
         fjcRBEKy3NRvRSC01qL5fK/oU7as0b07T10HZQ7FEOK943RkS0q78S+jfpbXQ36eLkum
         1Z5Q==
X-Gm-Message-State: ACrzQf0Ipmna+Sn/WDjvFyS2wWvTATjOicIvX9CgP78IW1mmFwKhdDrn
        PVUYjuEX4ScoQS44L8OdclK9Zr91b8wyPkJSuYjtSQzGBkrkwJNREreuaO0WRsc6kH9CjWSOc6m
        oIFlxCTnpv3MM1onXqdH2iHG5b8LlKsYB+EGkA6sKLTP1hsOUMkGsfBC+k7rxksc=
X-Google-Smtp-Source: AMsMyM6sveMHCWJGNmvJ9cLsYfEyAxo48wnCwL15kTjrAlfcKr/H1+WPkZLDvdf+FP5sV/XC8ZHBjhUGx8/1ZQ==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a17:902:a611:b0:178:6b71:2ee5 with SMTP
 id u17-20020a170902a61100b001786b712ee5mr5661928plq.53.1664491931080; Thu, 29
 Sep 2022 15:52:11 -0700 (PDT)
Date:   Thu, 29 Sep 2022 15:52:01 -0700
In-Reply-To: <20220929225203.2234702-1-jmattson@google.com>
Mime-Version: 1.0
References: <20220929225203.2234702-1-jmattson@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220929225203.2234702-4-jmattson@google.com>
Subject: [PATCH 4/6] KVM: x86: Mask off reserved bits in CPUID.8000001AH
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
actually supports. In the case of CPUID.8000001AH, only three bits are
currently defined. The 125 reserved bits should be masked off.

Fixes: 24c82e576b78 ("KVM: Sanitize cpuid")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/cpuid.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 15318f3f415e..5d1ec390aa45 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1175,6 +1175,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->ecx = entry->edx = 0;
 		break;
 	case 0x8000001a:
+		entry->eax &= GENMASK(2, 0);
+		entry->ebx = entry->ecx = entry->edx = 0;
+		break;
 	case 0x8000001e:
 		break;
 	case 0x8000001F:
-- 
2.38.0.rc1.362.ged0d419d3c-goog

