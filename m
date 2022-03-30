Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 290B64EB88C
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 04:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242156AbiC3C5w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 22:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242148AbiC3C5u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 22:57:50 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDAA9B6C;
        Tue, 29 Mar 2022 19:56:06 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id h19so16584587pfv.1;
        Tue, 29 Mar 2022 19:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yDTHn/+rErQ1GIm4EG6ELcr2d0dp2bkrDwck7VKtVYk=;
        b=IxdQ60tMukoYLEsgDLz2wic8YwgwGpuXy9Q2s10HuFOTOk9U3D9pSOZLfOHhTcncQb
         dvKTC2qgTS8nIb/S/Jm6sILAg//GYq8CpBLk+kXIbcQMSC38YGPPE1SpbY0SH2eRteXl
         Zh7t6TMOMXhkgYM8n/Gwyad0HNuYdYYDw+860ca6+Tu+tGYJeG7BwI0JDzlt88+aIClI
         mICMtPURvF0TqjSY2QSA8MqVEuQ7m1abAN5O2xuJnp45B0T/+jXmycblG17Iym/KgyBb
         CxXZuw5lje+jmcbkMbaswZVA/WrIfWhuzCTOZLm3pBGBljLs2AKfOJaJLa3/JYZ5VL24
         PZIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yDTHn/+rErQ1GIm4EG6ELcr2d0dp2bkrDwck7VKtVYk=;
        b=ZW85sbraY78CMCiXEUyttqSlfT9W46+AmeUPvBNi+ov7LHdqSRoG9I/D4QSxS+Dv7T
         k3EYuhg/buj26ez3lNccW+hWIe0leykaROB981++tmzQpyn7jv15HAaObYV2qs36T6D8
         ykYlBKE2GASifrU0iEiM9zz8ikKLqgnZjqb5YDGULQacjFygkXYG08svPNgwBeHQbPbQ
         uKvJPMGUgZX7vI2rBM3YyD54TvU5n1K+0Lg4DTyKZlt+PLi7r0rKz7EedEyZ2Djp5A74
         XAF1RZZuTU1eSQcn0NL8J6ynF81akXnkawBUGiVb7NXaKitF+UAXeKJvTzY9FvQFdaTX
         SS9g==
X-Gm-Message-State: AOAM532BrvWoLS+7gIV8dMQbdnl87uynA3a+ZVeHsyJKTOLbTeuYeMUl
        WSjmLIJkUdI+ueF49UHifh4BvqLYToxiPGdQ97I=
X-Google-Smtp-Source: ABdhPJzFM+ydPvI4a+aXkKUnZfkjG9Br6nO3e7OLKGHaehw55ov1PBH6VyYrljXzDZERQTamrcTIJw==
X-Received: by 2002:a65:6909:0:b0:382:53c4:43c5 with SMTP id s9-20020a656909000000b0038253c443c5mr4263204pgq.502.1648608966358;
        Tue, 29 Mar 2022 19:56:06 -0700 (PDT)
Received: from localhost.localdomain (118-166-41-36.dynamic-ip.hinet.net. [118.166.41.36])
        by smtp.gmail.com with ESMTPSA id me5-20020a17090b17c500b001c63699ff60sm4532951pjb.57.2022.03.29.19.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 19:56:05 -0700 (PDT)
From:   Zhiguang Ni <zhiguangni01@gmail.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhiguang Ni <zhiguangni01@gmail.com>
Subject: [PATCH] KVM: use kvcalloc for array allocations
Date:   Wed, 30 Mar 2022 10:55:47 +0800
Message-Id: <20220330025547.246126-1-zhiguangni01@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

Instead of using array_size, use a function that takes care of the
multiplication.  While at it, switch to kvcalloc since this allocation
should not be very large.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Zhiguang Ni <zhiguangni01@gmail.com>
---
 arch/x86/kvm/cpuid.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 32007f902bba..58b0b4e0263c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1290,8 +1290,7 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 	if (sanity_check_entries(entries, cpuid->nent, type))
 		return -EINVAL;
 
-	array.entries = vzalloc(array_size(sizeof(struct kvm_cpuid_entry2),
-					   cpuid->nent));
+	array.entries = kvcalloc(sizeof(struct kvm_cpuid_entry2), cpuid->nent, GFP_KERNEL);
 	if (!array.entries)
 		return -ENOMEM;
 
@@ -1309,7 +1308,7 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 		r = -EFAULT;
 
 out_free:
-	vfree(array.entries);
+	kvfree(array.entries);
 	return r;
 }
 
-- 
2.25.1

