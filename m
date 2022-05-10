Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C94C521116
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 11:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238983AbiEJJlW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 05:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239073AbiEJJlO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 05:41:14 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D811620F4E;
        Tue, 10 May 2022 02:37:17 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id fv2so15397268pjb.4;
        Tue, 10 May 2022 02:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=uUIt+ivBmGmxU82/HcgxdoaGxLo7vfsl5XOdCNfMIQ8=;
        b=mXgWRkS0jU51KYzSUCk/8Lxz9pt6VdPKou/GQAi5u3W5uh9QAqwP/qn49MYGU43od/
         9ycoaeYHrJGZSWB1w8fHjRWMYMuCz42VlhJsCKJVmMllBfu5xUeF0o5cXqan5e+Sr3p2
         GSc8qps5cucM93HcU9Sd8sO2bXLNM25PSHExPPywAMjt2GVOCbXFtCAsqngf1umnnS2U
         M1M9CUb8k3nQPQ9ouuo3yJYcI4dMuX3jqEe1TBjJTt7zFRhCIdeq+AMbQcFbz1uYt2Wa
         nekvxe7DpM3UjgZ4/fQn/Nf4TzLqeqn6EluUVxPTBc1BmoUCr8ID/Y40yvlYmx9CuHma
         bD3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uUIt+ivBmGmxU82/HcgxdoaGxLo7vfsl5XOdCNfMIQ8=;
        b=xkaoEgZTOJEyWsbhT8HgowefbPoeBVpH/eV8bs1rGCC0GJOICYd9iPWAU7HowDyQPB
         VwNmBX0n1n/8A0jk8Q1g2eYTIQdJBP5Fiu16KpTiSAuFTsSLrbVT6vabsSQckl9usATZ
         ALYFY9nlhxOHTv+faLpte5bZe17NdhS0ihikyd0OcdtvGzpZCWntfTVEL2xKTSYFMbMB
         5pfr61Mv4IwavpY41oiRQdorm39Y27J1JQh9NF/HXLxuttU4CWazoeqofOyfuqQULsoG
         obkBlnYHwCPbIa0iTIBRJl/aTpk//CkEqbZF+IHSAlKAPJ8yVw+Zijw4f0ubM279zUyj
         Amsw==
X-Gm-Message-State: AOAM530m94uGoY9VKuqZigDL4U0waBu+SSov3i7GMBRyV+5y0JC+G1pK
        hcloQC/GvqxqH1QaBXW09yYKJqv4cTQ=
X-Google-Smtp-Source: ABdhPJx4cjc5Ezad0mYSp88exyBHf1qWdOWH8dm86BR3UaVATW707uineEYaHBA8CGxVkKEft8R/2w==
X-Received: by 2002:a17:902:d551:b0:15e:c50f:41b5 with SMTP id z17-20020a170902d55100b0015ec50f41b5mr19953248plf.98.1652175437088;
        Tue, 10 May 2022 02:37:17 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.81])
        by smtp.googlemail.com with ESMTPSA id e14-20020a6558ce000000b003c14af50639sm10130936pgu.81.2022.05.10.02.37.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 May 2022 02:37:16 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: LAPIC: Disarm LAPIC timer includes pending timer around TSC deadline switch
Date:   Tue, 10 May 2022 02:36:26 -0700
Message-Id: <1652175386-31587-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

The timer is disarmed when switching between TSC deadline and other modes, 
however, the pending timer is still in-flight, so let's accurately set 
everything to a disarmed state.

Fixes: 4427593258 (KVM: x86: thoroughly disarm LAPIC timer around TSC deadline switch)
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 66b0eb0bda94..0274d17d91c2 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1562,6 +1562,7 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
 			kvm_lapic_set_reg(apic, APIC_TMICT, 0);
 			apic->lapic_timer.period = 0;
 			apic->lapic_timer.tscdeadline = 0;
+			atomic_set(&apic->lapic_timer.pending, 0);
 		}
 		apic->lapic_timer.timer_mode = timer_mode;
 		limit_periodic_timer_frequency(apic);
-- 
2.25.1

