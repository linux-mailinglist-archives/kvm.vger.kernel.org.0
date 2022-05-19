Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99B2F52DB09
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 19:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237612AbiESRRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 13:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242364AbiESRRT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 13:17:19 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2741831210;
        Thu, 19 May 2022 10:17:18 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id r71so5683418pgr.0;
        Thu, 19 May 2022 10:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xmZ9srnb0lk9NsEzaGPp4pHI1F8Mho3yg6axj9HJGJY=;
        b=d0mrkulElJlc2SIdgiDgiYDlJVHerrYUlxXWRg1qWWpeLR4WEmU4FjCs1mJOHU9y93
         z9Elv5y0D/7pxMWhvHEF82Su9oFsab0L3jna+gfmJj5+ahVe0mbiD5csZfjy/u8k/7u3
         LhkR0Qpr00NI7myM1eHsd85L2bdpKMyEouEG1/mGfhrM8fu+D1HwM24+/qnoi5WNNgwx
         53l5ifHZxT2EA+hHpIAuPFYeDVom3RCHhme8tSH2MjUAuN6OBsDiLy19O3hKqOsmtxTN
         U3xnGygB+KdKAUpssqGLSczMFmupGjBd1D9lnQt45Epn+45wxveqainR1nYcdsEVXcRx
         KEVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xmZ9srnb0lk9NsEzaGPp4pHI1F8Mho3yg6axj9HJGJY=;
        b=Mloj36FLUO8IjEFzihiLgafFSKKRO6CUPm/2KjyWoR4cviBleMcSFlETxtktbT+HXO
         9GD7Pr1UaRqdl6+59xlG28BSG5l3gXOq2iTMqz0hKRDZEhTSk2eVQO+Wnh7yWuMDH9cI
         zV4C/lR1bT1H2sKpMAOWcKLQc4kfcrlwLVvuGw94Y0kT6r40/AJiz4drT3hD3POYJDMz
         r/I0iK140m6j3nou5+V4FV3DRinlKJ6vegKOiLGwbYERV424CYAdBVmGURuESqSPOByG
         KeGDTAi07iNUfk9CXnXaZZPEsEmSOCIrpIddDeRBc57/KeWQoHMe6KmOvXVmS5AQFGF3
         +5ng==
X-Gm-Message-State: AOAM531yeC3eKzOTzgkISgRk9p0NSXJ5XIbAawTKRTyaGQ247hRhwziu
        lSLPhaS9mZGGNjlPpGu0yPE=
X-Google-Smtp-Source: ABdhPJy7sGlzmyC8tIiMyooX3Penbg5sgplkN7Tq2YOiZVhoXjvVgbiO3k8fOKAwqMaR2eAgt0kT+A==
X-Received: by 2002:a63:c4e:0:b0:3db:6074:117a with SMTP id 14-20020a630c4e000000b003db6074117amr4840323pgm.87.1652980637526;
        Thu, 19 May 2022 10:17:17 -0700 (PDT)
Received: from localhost (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id f1-20020a170902ff0100b0016160b33319sm4011783plj.246.2022.05.19.10.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 10:17:17 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Yury Norov <yury.norov@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] KVM: x86: hyper-v: fix type of valid_bank_mask
Date:   Thu, 19 May 2022 10:15:04 -0700
Message-Id: <20220519171504.1238724-1-yury.norov@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In kvm_hv_flush_tlb(), valid_bank_mask is declared as unsigned long,
but is used as u64, which is wrong for i386, and has been spotted by
LKP after applying "KVM: x86: hyper-v: replace bitmap_weight() with
hweight64()"

https://lore.kernel.org/lkml/20220510154750.212913-12-yury.norov@gmail.com/

But it's wrong even without that patch because now bitmap_weight()
dereferences a word after valid_bank_mask on i386.

>> include/asm-generic/bitops/const_hweight.h:21:76: warning: right shift count >= width of type
+[-Wshift-count-overflow]
      21 | #define __const_hweight64(w) (__const_hweight32(w) + __const_hweight32((w) >> 32))
         |                                                                            ^~
   include/asm-generic/bitops/const_hweight.h:10:16: note: in definition of macro '__const_hweight8'
      10 |          ((!!((w) & (1ULL << 0))) +     \
         |                ^
   include/asm-generic/bitops/const_hweight.h:20:31: note: in expansion of macro '__const_hweight16'
      20 | #define __const_hweight32(w) (__const_hweight16(w) + __const_hweight16((w) >> 16))
         |                               ^~~~~~~~~~~~~~~~~
   include/asm-generic/bitops/const_hweight.h:21:54: note: in expansion of macro '__const_hweight32'
      21 | #define __const_hweight64(w) (__const_hweight32(w) + __const_hweight32((w) >> 32))
         |                                                      ^~~~~~~~~~~~~~~~~
   include/asm-generic/bitops/const_hweight.h:29:49: note: in expansion of macro '__const_hweight64'
      29 | #define hweight64(w) (__builtin_constant_p(w) ? __const_hweight64(w) : __arch_hweight64(w))
         |                                                 ^~~~~~~~~~~~~~~~~
   arch/x86/kvm/hyperv.c:1983:36: note: in expansion of macro 'hweight64'
    1983 |                 if (hc->var_cnt != hweight64(valid_bank_mask))
         |                                    ^~~~~~~~~

CC: Borislav Petkov <bp@alien8.de>
CC: Dave Hansen <dave.hansen@linux.intel.com>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: Jim Mattson <jmattson@google.com>
CC: Joerg Roedel <joro@8bytes.org>
CC: Paolo Bonzini <pbonzini@redhat.com>
CC: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Vitaly Kuznetsov <vkuznets@redhat.com>
CC: Wanpeng Li <wanpengli@tencent.com>
CC: kvm@vger.kernel.org
CC: linux-kernel@vger.kernel.org
CC: x86@kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 arch/x86/kvm/hyperv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 58baf7f9acce..c8ca95d4e4e9 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1938,7 +1938,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	struct hv_send_ipi_ex send_ipi_ex;
 	struct hv_send_ipi send_ipi;
 	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
-	unsigned long valid_bank_mask;
+	u64 valid_bank_mask;
 	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
 	u32 vector;
 	bool all_cpus;
-- 
2.32.0

