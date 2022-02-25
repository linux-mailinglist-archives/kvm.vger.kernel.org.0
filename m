Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C31C4C3AF0
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 02:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236374AbiBYBaj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 20:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234976AbiBYBah (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 20:30:37 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D98B2692F3
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 17:30:06 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id bm16-20020a656e90000000b00372932b1d83so1844535pgb.10
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 17:30:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Yk0Ykv429Uqar81C4Yj/Co2HxQgqkeiHZrfzsPPDNOY=;
        b=gFXdJqBme9IGxFgKGpMJZq+5C+U5PSw8ghd/D5bVyLj9lFK64pT1tcmjrvlJNAgO6j
         uTNindJF+R09YEhVwbXUhw95Vr9zLgCADz+T6vM+Pxv9KoJVAqlXEDNdyW8UFUDvdnYj
         2mio8XVnjyB77jzVBXvbM6uP6+cNU2yMsMhstfHNHyizy+8zFOBf6oN9KIkruB10fjP9
         cUt1F6xooOMni3w4hEyG+dPXbUa6SCeRLTjOOPh3l/ln+WbkFM9kVojFXnMQDTut3zrz
         cFCVXompiIQgr1KAsLyx3FzeY+irE+EzPZTo4AI5FrUd8hbCD+Vka71TYy3vTPDwYhHr
         0Y/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Yk0Ykv429Uqar81C4Yj/Co2HxQgqkeiHZrfzsPPDNOY=;
        b=j6oUXDjLDZkkBrw54i8sPx4Dl8NSrNnu2/r1aq4XaiDXy5HMuOBYUnUkcaNPWCaLzy
         qCNacoFwmgUOMVDPuw2Yw5+LqLHSA2vaiTTuGTLIIRAhGEEvCRYac0BAcMRxLiJrLHDg
         u+m3E3gvbqGeU50iD6bRESQZX71kajQjKmWZ71JA17ySOTZQA5rNUcAf6cFzuoXqiwWZ
         Idb9zIp1+nMc0jteuswsYYcmjZ6TUy2OsaU/cmGn0NMUbTUzHz6cevtvgLqGvxDpe+u3
         DARdOzNUNA1WStJKwNW+Pk+UB2xUcBCqdPsc/tdNcUfrMZkKKVStNnurE1XmHvNt2BkQ
         giQA==
X-Gm-Message-State: AOAM533qc5ziyLCL+2JrbQ35Sd1AMxb2meSQmgH/5LKADEfz+H1+0WMU
        o/OTjeRDmLlecYyG/PUODrwCd9aHDkwawg+ntrZUU52scLMULnR2i46B0v8x2uJESrtk5spGuta
        ah/ErivETBYxWI52pKxzfwFzPN1GDpemyWwCaR5Ks/Uc4W4HUuYLhlEyzhveEQH8=
X-Google-Smtp-Source: ABdhPJygCgwxhb6t9yRtbDcksEn7sdVqny8CClMMK697EDl2aVeEDIm1FkHsv5Hy+NIxykNJ05XCNIlydgLmRw==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:90b:4f43:b0:1bc:7e5c:e024 with SMTP
 id pj3-20020a17090b4f4300b001bc7e5ce024mr103179pjb.0.1645752604982; Thu, 24
 Feb 2022 17:30:04 -0800 (PST)
Date:   Thu, 24 Feb 2022 17:29:59 -0800
Message-Id: <20220225012959.1554168-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH] KVM: VMX: Fix header file dependency of asm/vmx.h
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jacob Xu <jacobhxu@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jacob Xu <jacobhxu@google.com>

Include a definition of WARN_ON_ONCE() before using it.

Fixes: bb1fcc70d98f ("KVM: nVMX: Allow L1 to use 5-level page walks for nested EPT")
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jacob Xu <jacobhxu@google.com>
[reworded commit message; changed <asm/bug.h> to <linux/bug.h>]
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/vmx.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 0ffaa3156a4e..447b97296400 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -14,6 +14,7 @@
 
 #include <linux/bitops.h>
 #include <linux/types.h>
+#include <linux/bug.h>
 #include <uapi/asm/vmx.h>
 #include <asm/vmxfeatures.h>
 
-- 
2.35.1.574.g5d30c73bfb-goog

