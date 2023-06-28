Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7F8740B8D
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 10:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbjF1Ic3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 04:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjF1I3q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 04:29:46 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E854237
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 01:22:23 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-5700b15c12fso57500047b3.1
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 01:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=g-ecc-u-tokyo-ac-jp.20221208.gappssmtp.com; s=20221208; t=1687940543; x=1690532543;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YaAvVHVt7cghRwFLnQgjFZ0g8XBe2b92w1gFr9dUG3Q=;
        b=NwGziJsQPvSuhv8fbLnxb+WrJM9vntDrkwRRXeJ+3bGeBSt741QASxWlBFEJKbG2y8
         LF60T0UlldKx5riqRC7RM0sYx7PL1oEiWElQ7adGobJKRC07InbhJwel9PYX+0VuPca7
         khjVCG7VozG/fBpiKw7dRBZ2PW2lMo5L1WJbKpimlJhDUFTas4F977t/mK56pgpWvRjr
         bKn4ldp5Hj0BTvIzmf5oszrB9JAhq2MZmxrJufgSy+eTQWId+EqejCRXP9YStUOIvp8U
         vZ5eRpMk0j9LXNg1NSbZ6WhiknPIlYUPILj3aWeRUeilAQLxNW3CbioIpSZWZJ9rlKoK
         PIAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687940543; x=1690532543;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YaAvVHVt7cghRwFLnQgjFZ0g8XBe2b92w1gFr9dUG3Q=;
        b=YAlIlJ/g99RnA3P+WXg+CTpObdNBSYHBFkLn4FRn4hT4owB/epyxEMF6bGWJTV6AS7
         R2NIHQ5PetnHavruiuZvihPPjOrqa9INkTl1INoDvymRbMOxpXiv6Dedk6YebLSB0Ud0
         7ZWUxTjab1IgR/S2XKII6VQpSl6mKV+bG4tjoSS5zQLFb177RsLjYdCSSfb59KeyaZoo
         qCOl/BYmXiB/x5JfXKPz+KZYCuSP13FGKpkG/+a/aOCTj2VuWatcBhKK3p6+W/J8XbU2
         FYP/tQxn/0S//wUkDz7+7QUWsuI7AVkvXJTLZFrpNw85HBaIhJtx0tdDcGzRhRDB79Nf
         ww8w==
X-Gm-Message-State: AC+VfDzVGZQ5CwtQ3JfNaMLQrs/BB9X2/67jSbB+oTHcKAv/h3M/+g3v
        en0Z8nrz5Of5Mdw3X0lo6/HYBEp7FWvjvpNlIZamqvSD
X-Google-Smtp-Source: ACHHUZ5CMH5/HFG+qo5JZyhLGoo9OcY9mI+7JUgKxp/odXJZ7O2JLk9F+U6WXu9CPVXbQ7H/fcAnog==
X-Received: by 2002:a05:6a20:7daa:b0:127:32d9:78f0 with SMTP id v42-20020a056a207daa00b0012732d978f0mr7946880pzj.47.1687936343100;
        Wed, 28 Jun 2023 00:12:23 -0700 (PDT)
Received: from ishii-desktop.. ([133.11.45.41])
        by smtp.gmail.com with ESMTPSA id e13-20020a62aa0d000000b0067526282193sm4884941pff.157.2023.06.28.00.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jun 2023 00:12:22 -0700 (PDT)
From:   Reima Ishii <ishiir@g.ecc.u-tokyo.ac.jp>
Cc:     ishiir@g.ecc.u-tokyo.ac.jp, shina@ecc.u-tokyo.ac.jp,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: nVMX: Prevent vmlaunch with EPTP pointing outside assigned memory area
Date:   Wed, 28 Jun 2023 16:12:17 +0900
Message-Id: <20230628071217.71126-1-ishiir@g.ecc.u-tokyo.ac.jp>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In nested virtualization, if L1 sets an EPTP in VMCS12 that points
beyond the assigned memory area and initiates a vmlaunch to L2, the
existing KVM code handles the vmlaunch, and passes the VMCS
consistency check. However, due to EPTP pointing outside accessible
memory from the vCPU in mmu_check_root(), it attempts to trigger a
triple fault.

As a result, the nested_vmx_triple_fault() and nested_vmx_vmexit() are
called before the actual vmlaunch to L2 occurs. Despite the vmlaunch
not actually being executed in L2, KVM attempts a vmexit to L1,
resulting in a warning in nested_vmx_vmexit() due to the
nested_run_pending flag.

This commit resolves the issue by modifying the nested_vmx_check_eptp()
to return false when EPTP points outside the assigned memory area.
This effectively prevents a vmlaunch with such an EPTP, thus avoiding
the unnecessary warning.

Signed-off-by: Reima Ishii <ishiir@g.ecc.u-tokyo.ac.jp>
---
 arch/x86/kvm/vmx/nested.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e35cf0bd0df9..721f98a5dc24 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2727,6 +2727,10 @@ static bool nested_vmx_check_eptp(struct kvm_vcpu *vcpu, u64 new_eptp)
 			return false;
 	}
 
+	/* Check if EPTP points to an assigned memory area */
+	if (!kvm_vcpu_is_visible_gfn(vcpu, new_eptp >> PAGE_SHIFT))
+		return false;
+
 	return true;
 }
 
-- 
2.34.1

