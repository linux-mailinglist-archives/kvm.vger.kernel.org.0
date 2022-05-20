Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26DC52F1C0
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 19:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352261AbiETRgt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 13:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352248AbiETRgq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 13:36:46 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C787D819AC
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 10:36:44 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id g63-20020a636b42000000b003db2a3daf30so4428387pgc.22
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 10:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GdWBZFDhJiVgrbjToTXhMKwWYC+jS0aqPfp6IBtPjQU=;
        b=MeXm4aLrzF/JggIkcCr1PvoEpV6DMd8bww6676h5oDd2dcsV8p3zOG5LystUOsuCGl
         +PK5X74pQ7RrY9thlR1anCQ1iKunPHuXh6p0LSoV6fQXAFirPznf/6vTI+vZblqAN83Z
         UXkgTosFoxaddqiKXxYXfvgF9tZWkISLTJGGY/PZw9wI3nMByRT4Ls0s40EPdTKBTf6f
         +ur9xWSNfb7kk8gwo5lwWQLLiu8AzQAyXBaLpMnUfybCi74VQ84/z1G9y1E8YR2IRI/E
         ULn5dYSsQJj8N2iisfxOD6wdcS2AbCWy0rs0JMMwM3qMMsT6Jhw9utNdoyS2foJHH862
         Bwvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GdWBZFDhJiVgrbjToTXhMKwWYC+jS0aqPfp6IBtPjQU=;
        b=bNmVACf4ytJmGYswvgM3zmyBiPwNCjiaQexc0+/UH0BlrCuRjR42AqG6DAfhZ1GgAN
         rv2J+ZxsWCHW+IBTGjzqx2uunCq4tawN89QJk9r0JfhwoAKIE0tLJmLbnpg3AodutU6m
         9oAMwh9IVYOiy/BsBso58WKt8zAbUNezrw5yoJU1F1i7rYnjdvOAwcu6+iDodLfgI1wU
         AMjthwBnHgUGFX+bnVqENSS65t0RG7U194ZgoU9FEcJCaUUdQJ18np/xUOwtKzYPKmrt
         J+d8qxFCP3zSG74KDgFhs2Lr3/fJnQhp21bfZBt0mw2ZN5VNt9/ygrwQPV4GDcoNKoHY
         P/Tw==
X-Gm-Message-State: AOAM533tyj6yeLJpyk/pDUis77LS5jl4YNSMofLkeXlrzixMzOrCp2/c
        M/NRw8lzv/ZptmnhUxHTHRfCeJSD
X-Google-Smtp-Source: ABdhPJwNVlkpJ/TPfKNggxiFy6ka3cDtK7QG8lj+hLMU3nOs4j8N8YMHpgHu7wabKnt8E4PztWXcDYsQ
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:4c5:ddc5:8182:560f])
 (user=juew job=sendgmr) by 2002:a05:6a00:1393:b0:518:68fe:f036 with SMTP id
 t19-20020a056a00139300b0051868fef036mr5258388pfg.54.1653068204233; Fri, 20
 May 2022 10:36:44 -0700 (PDT)
Date:   Fri, 20 May 2022 10:36:31 -0700
In-Reply-To: <20220520173638.94324-1-juew@google.com>
Message-Id: <20220520173638.94324-2-juew@google.com>
Mime-Version: 1.0
References: <20220520173638.94324-1-juew@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v4 1/8] KVM: x86: Make APIC_VERSION capture only the magic 0x14UL.
From:   Jue Wang <juew@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>
Cc:     Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        Greg Thelen <gthelen@google.com>,
        Jiaqi Yan <jiaqiyan@google.com>, Jue Wang <juew@google.com>
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

To implement Corrected Machine Check Interrupt (CMCI) as another
LVT vector, the APIC LVT logic needs to be able to handle an additional
LVT vector conditioned on whether MCG_CMCI_P is enabled on the vCPU,
this is because CMCI signaling can only be enabled when the CPU's
MCG_CMCI_P bit is set (Intel SDM, section 15.3.1.1).

This patch factors out the dependency on KVM_APIC_LVT_NUM from the
APIC_VERSION macro. In later patches, KVM_APIC_LVT_NUM will be replaced
with a helper kvm_apic_get_nr_lvt_entries that reports different LVT
number conditioned on whether MCG_CMCI_P is enabled on the vCPU.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/kvm/lapic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 66b0eb0bda94..a5caa77e279f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -54,7 +54,7 @@
 #define PRIo64 "o"
 
 /* 14 is the version for Xeon and Pentium 8.4.8*/
-#define APIC_VERSION			(0x14UL | ((KVM_APIC_LVT_NUM - 1) << 16))
+#define APIC_VERSION			0x14UL
 #define LAPIC_MMIO_LENGTH		(1 << 12)
 /* followed define is not in apicdef.h */
 #define MAX_APIC_VECTOR			256
@@ -401,7 +401,7 @@ static inline int apic_lvt_nmi_mode(u32 lvt_val)
 void kvm_apic_set_version(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
-	u32 v = APIC_VERSION;
+	u32 v = APIC_VERSION | ((KVM_APIC_LVT_NUM - 1) << 16);
 
 	if (!lapic_in_kernel(vcpu))
 		return;
-- 
2.36.1.124.g0e6072fb45-goog

