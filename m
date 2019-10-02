Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51AEDC9631
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 03:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbfJCBcV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 21:32:21 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33529 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfJCBcV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 21:32:21 -0400
Received: by mail-pf1-f194.google.com with SMTP id q10so670225pfl.0
        for <kvm@vger.kernel.org>; Wed, 02 Oct 2019 18:32:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RwqMv1VuRaNQclTV5klptGu189WWVB7hjqn7mDkEeqY=;
        b=aeWI5RJf+eVNyMKraUN7BRHRo5SN14Aw0+F7zVSglx6sr59tGqjFSwUK1LkU/ulb6k
         nONAs85vlEoXqo3NHPTC5rlh+23RnRr9uSjhzqXMDtW/8uutsUdvkKnrrWLjv9usIPWf
         WdSS8jOzkJOJvZmTfr+YGStZdgqDg7bqz8HutcdwMYWjc5tDMiEYdygri/oqmCmhOTHy
         z8W/WG8y4fQHwDVFbGdhXSGtiLVmnn+2waueXCQOZSHwDH4Gdw8wcpHI6J7YvRkYeYjh
         eQkNFhUCmzubsHlE4019tZNKrg6hsS8Xr9y3zOU41FjxbGD0vT82DhIqmTNGrwFX3UOG
         7uBw==
X-Gm-Message-State: APjAAAWZoiAWoln8gO9eFeHoPg46jfJYHzYNXIg4YyoNZ5plv/2YvSCe
        hB56+5Jc8gWM/9w58lEwR4s=
X-Google-Smtp-Source: APXvYqxwmoJ4s8OsF7+Q7jyquKJEppkZNo4prre4ovJRzUIFLvcc9IpV81T8r+ZXMSn76em0fpGI2g==
X-Received: by 2002:a62:a509:: with SMTP id v9mr7849498pfm.180.1570066340786;
        Wed, 02 Oct 2019 18:32:20 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id v12sm564310pgr.31.2019.10.02.18.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 18:32:20 -0700 (PDT)
From:   Nadav Amit <namit@vmware.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, sean.j.christopherson@intel.com,
        Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH] x86: VMX: MSR_IA32_VMX_MISC[30] is not MBZ
Date:   Wed,  2 Oct 2019 11:11:14 -0700
Message-Id: <20191002181114.3448-1-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

MSR_IA32_VMX_MISC[30] tells whehter "VM entry allows injection of a
software interrupt, software exception, or privileged software exception
with an instruction length of 0".

In other words, it is not MBZ (must be zero), so do not check that it is
cleared.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 x86/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index d518102..647ab49 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1486,7 +1486,7 @@ static void test_vmx_caps(void)
 	report("MSR_IA32_VMX_MISC",
 	       (!(ctrl_cpu_rev[1].clr & CPU_URG) || val & (1ul << 5)) &&
 	       ((val >> 16) & 0x1ff) <= 256 &&
-	       (val & 0xc0007e00) == 0);
+	       (val & 0x80007e00) == 0);
 
 	for (n = 0; n < ARRAY_SIZE(vmx_ctl_msr); n++) {
 		ctrl.val = rdmsr(vmx_ctl_msr[n].index);
-- 
2.17.1

