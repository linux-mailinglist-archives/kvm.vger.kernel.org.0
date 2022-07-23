Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD7C57EB17
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 03:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbiGWBaf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 21:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbiGWBad (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 21:30:33 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C7015718
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 18:30:31 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id u8-20020a170902e80800b0016cf8f0c7e4so3483717plg.11
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 18:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=T2BlS9fiXQwfYfA9NCHRCPS0v7PhSvHsuXGq1KjbYXY=;
        b=sNPwYftGBbnNzm7D0kIMjJbhsaqMg9FSxG7nGCE+zAJwIBORx0FeL2uKRqNPR20pyB
         YQLu8L22Rcejlrfysm58w79udzt4DyOItbN4dyF7OYbX/giW0LtoQOJXAKsgt+0HHeK6
         pNq6HRnLia7ZxD/AMqcCEP+umj2D6X6Cn55evVyTaNxxU7p/+xOrfeTOmvTU6mLSSHoi
         ih/hGUrpfaxkvG7d1ULhSV/VEFjecffsMM9vqxQ91KG3H83sGEDsFIcEzVmljo/7qyuW
         QO9Ll3Naw6466tdVEApChx2yPvNjbslL42juORaxBhokKyeuWDTb64WYntk0ZSeEFBA4
         IeJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=T2BlS9fiXQwfYfA9NCHRCPS0v7PhSvHsuXGq1KjbYXY=;
        b=uT0odRG5Pbhf/jsMEDGLgLTTxHR7zlafSmvBb9lTuhSqoOzEID7e8uzI0VBe3wxQhJ
         mhVpUIN+hN09jiQv88MuZqwFJsUJZkz0qsqS1uDIZkulsX8BPCJ+2Z2b4r0NL5P38jzt
         3aK1p+ohaJ4LesqwlutUnL9/byBuPpmuNgmEgvFiqMP2o1eX0YG1BMq0bpfEJle+bvp3
         MQP/lgY6nx14Xbdtj4TIvyvMgmj3855urGHpLqVJw9hHoO+vz47QfA982y0+4gG91Vxc
         qUI+ZJeMWnfxne72YyLozW2qHuLjEn3Ijxw0HNKnLleQr6KbLWF/V26Py512RPCMZQ8N
         iF6g==
X-Gm-Message-State: AJIora+8GDeVv/jljz2zgFR67ykxYqhXhswfOfJ4YXlM/1HlrdqPOm++
        YpSb4/K2ugADvHZ/w8+GbpTH4EViXpM=
X-Google-Smtp-Source: AGRyM1t85oK8vpIGc5IfuSQYKRDW1+A7RKin+XGcwcBlqJifpnU7mGMNFq3anb1shsAblnGcruDOWdjpWy4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4b50:b0:1f0:5643:fa5c with SMTP id
 mi16-20020a17090b4b5000b001f05643fa5cmr21032656pjb.131.1658539831499; Fri, 22
 Jul 2022 18:30:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Jul 2022 01:30:29 +0000
Message-Id: <20220723013029.1753623-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH] KVM: x86/mmu: Treat NX as a valid SPTE bit for NPT
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Treat the NX bit as valid when using NPT, as KVM will set the NX bit when
the NX huge page mitigation is enabled (mindblowing) and trigger the WARN
that fires on reserved SPTE bits being set.

KVM has required NX support for SVM since commit b26a71a1a5b9 ("KVM: SVM:
Refuse to load kvm_amd if NX support is not available") for exactly this
reason, but apparently it never occurred to anyone to actually test NPT
with the mitigation enabled.

  ------------[ cut here ]------------
  spte = 0x800000018a600ee7, level = 2, rsvd bits = 0x800f0000001fe000
  WARNING: CPU: 152 PID: 15966 at arch/x86/kvm/mmu/spte.c:215 make_spte+0x327/0x340 [kvm]
  Hardware name: Google, Inc. Arcadia_IT_80/Arcadia_IT_80, BIOS 10.48.0 01/27/2022
  RIP: 0010:make_spte+0x327/0x340 [kvm]
  Call Trace:
   <TASK>
   tdp_mmu_map_handle_target_level+0xc3/0x230 [kvm]
   kvm_tdp_mmu_map+0x343/0x3b0 [kvm]
   direct_page_fault+0x1ae/0x2a0 [kvm]
   kvm_tdp_page_fault+0x7d/0x90 [kvm]
   kvm_mmu_page_fault+0xfb/0x2e0 [kvm]
   npf_interception+0x55/0x90 [kvm_amd]
   svm_invoke_exit_handler+0x31/0xf0 [kvm_amd]
   svm_handle_exit+0xf6/0x1d0 [kvm_amd]
   vcpu_enter_guest+0xb6d/0xee0 [kvm]
   ? kvm_pmu_trigger_event+0x6d/0x230 [kvm]
   vcpu_run+0x65/0x2c0 [kvm]
   kvm_arch_vcpu_ioctl_run+0x355/0x610 [kvm]
   kvm_vcpu_ioctl+0x551/0x610 [kvm]
   __se_sys_ioctl+0x77/0xc0
   __x64_sys_ioctl+0x1d/0x20
   do_syscall_64+0x44/0xa0
   entry_SYSCALL_64_after_hwframe+0x46/0xb0
   </TASK>
  ---[ end trace 0000000000000000 ]---

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8e477333a263..3e1317325e1f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4735,7 +4735,7 @@ reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *context)
 
 	if (boot_cpu_is_amd())
 		__reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
-					context->root_role.level, false,
+					context->root_role.level, true,
 					boot_cpu_has(X86_FEATURE_GBPAGES),
 					false, true);
 	else

base-commit: 1a4d88a361af4f2e91861d632c6a1fe87a9665c2
-- 
2.37.1.359.gd136c6c3e2-goog

