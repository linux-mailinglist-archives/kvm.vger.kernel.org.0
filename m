Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D147658F3D4
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 23:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbiHJVbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 17:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233150AbiHJVa7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 17:30:59 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A885B7AA
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 14:30:58 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-32a144ac47fso30900087b3.8
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 14:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=d5xbPugTDLWV3T4HexGWlKQR5TkIJ9FBtzj7sNTtEx8=;
        b=imNyFB4pO/pGOQCPC171v2WAZmYpon7AM/WI+V1x7SMcriUIjF9zj3SgNAU4ZIK2Lx
         1L9Bkc68hewOZGMez/idOmhmgu5fm7X4IxQw4APXVnFcWW4SYungLTg/w0qFHzzFMz3Z
         mK5hqKHXwIFGs/iL/bOMOLfhOb2bXN3Ybxm34VKHz7M+j9wbjXgZAjlkQgU3Yp7eYukL
         2L6xTez6ijam4ExUB1i2Sk7jXYgULts4a6WcsJLXN1IoVYGn5VFht2519hW5kQNVo31S
         Hog57FMO7SmWY7oODIQKSfbqT4tLpzXt1SN26l0IiSV11drlsn383ENYNLOynG2Jh+UL
         7x/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=d5xbPugTDLWV3T4HexGWlKQR5TkIJ9FBtzj7sNTtEx8=;
        b=WbJFLrYweckZWSwa5kA3MoXxsX4+5RLU60fcGxw/AV4ZTsp3Eg66eqKo/nTO4UpdER
         UonOdE1YT72iYx7PQfPgCfxTaqLUTRrjtdqm4gUJ/rxAOo9eN/b1ADJcDr0C5aNXwoTb
         Kvyt5K1kJIyVW6u/en0ZlE8pWTwVaZ+r8GvAeYNeJUPGdxDLBi1+z4Kcz4KUtszvHicL
         98bUJ7tqppxU6ET78cbkQDTEvndjtF7ZcK2lzfNb9MZKODOxdsQrz1vslN02F7umazK/
         9mgGzvhtJltkk9D47qOlazpRzpJfLf0LXs36Mh342pkBhizy9cza3/JgZt9fYEIDYMfU
         Q+6Q==
X-Gm-Message-State: ACgBeo2kjceRkU/DW/ZZdC60tSDtuT+gmjEJ8AHeMhRWS4vRZp4r6in5
        ncSb/63vJ5OCqB4U7fDGLwO2Ohkq08B883HdTgG3HGMm7MD0Ff0MBHaex54eJfRzwTXLD8+v/Q/
        Ow4+aPXChvyVBxox3vc7huWxmhHTDdK24HPQHLOOGu0p5HivVxiKs67U8AwVm0u4=
X-Google-Smtp-Source: AA6agR6ibWhOUCspDbW4kPdiyMGFnnJAw2YuRRXI/n1k7uSHiuBqE5790Uj+Ho604OJhWrsAwPyy6SlxQ6fSyg==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a05:690c:826:b0:32a:c39d:191d with SMTP
 id by6-20020a05690c082600b0032ac39d191dmr3821426ywb.157.1660167058142; Wed,
 10 Aug 2022 14:30:58 -0700 (PDT)
Date:   Wed, 10 Aug 2022 14:30:50 -0700
Message-Id: <20220810213050.2655000-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH] KVM: VMX: Heed the 'msr' argument in msr_write_intercepted()
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
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

Regardless of the 'msr' argument passed to the VMX version of
msr_write_intercepted(), the function always checks to see if a
specific MSR (IA32_SPEC_CTRL) is intercepted for write.  This behavior
seems unintentional and unexpected.

Modify the function so that it checks to see if the provided 'msr'
index is intercepted for write.

Fixes: 67f4b9969c30 ("KVM: nVMX: Handle dynamic MSR intercept toggling")
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d7f8331d6f7e..c9b49a09e6b5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -843,8 +843,7 @@ static bool msr_write_intercepted(struct vcpu_vmx *vmx, u32 msr)
 	if (!(exec_controls_get(vmx) & CPU_BASED_USE_MSR_BITMAPS))
 		return true;
 
-	return vmx_test_msr_bitmap_write(vmx->loaded_vmcs->msr_bitmap,
-					 MSR_IA32_SPEC_CTRL);
+	return vmx_test_msr_bitmap_write(vmx->loaded_vmcs->msr_bitmap, msr);
 }
 
 unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
-- 
2.37.1.559.g78731f0fdb-goog

