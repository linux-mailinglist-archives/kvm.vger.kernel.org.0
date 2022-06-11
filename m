Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069725470CF
	for <lists+kvm@lfdr.de>; Sat, 11 Jun 2022 03:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350784AbiFKA60 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 20:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348466AbiFKA6L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 20:58:11 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC4569CD4
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 17:58:10 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id o16-20020a170902d4d000b00166d7813226so367810plg.13
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 17:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ql1Sd9pF/0aevrNAhN/dPI6LOpxERHFTraDXP5pQQ+M=;
        b=DEDudNDeQbi9BYH3iE/CYgy5GDEV9rOO4CJb9h/8tP2YrKiFrPFdtZY05MkDgIyeiD
         o+b7ijnX2IhHEI9r/mdsqCtB1KpCT49EQLrLswhG6staT3WpC79S1T9lKKD3XD4pf9Et
         uowg6fwG2Kan3bDR2t/IBibKniCS31inDVsyL2lGwyfF0biO1TgJr33mRRi7rlGvzNZZ
         0eQWZWGLrFwuwK5+B1boY3SPJJylQpB1MAZLMndhb+ZrOsA/jhXfL80jJg3tv8sjUCk8
         oTykfkM/FPON8GVOS1PeMEnt+rIthEcOVZvDHQ7eRIEZSeHW4tTnmeuGFTwAIqYv1Ibe
         kgIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ql1Sd9pF/0aevrNAhN/dPI6LOpxERHFTraDXP5pQQ+M=;
        b=Db7zIeTa1OnVyenG9vMlYKXmoBGUwJHS1Cq2uDyJHhBjRgtmpoezVG7HKBG4pXvWof
         J4LF+FOlcaAMZvPuk0Z0T2rtqyIZCvLTToD8I/Wxg1lODpt5QfcZ9a13uHOagC5hsmxk
         QPbxaZ8VapN9KbZHTpgsroTNbX2knONkOZw+DHtu5DL9m0bbOQSIK3qCZIoc2OP6yw0Y
         5QetXFP8mh/YBFoILaEuEhhskqmErrkVEZiOIT5ubzZDPIUK4cvxPrwGFuT3MqFi3WTb
         cMZgDO4l2JQYBPERP2tfb0mBIt7WtLcDsU6Z8IVJIvQg0CYzu75IciS/Lb/FVKbCtnG2
         SJCw==
X-Gm-Message-State: AOAM532Gz+wsRVFZY9vyPn+q0qs9WiMhkJFxEe9+4Zu7qygLRT+fFyBc
        T/yC2DbhtxP73+Xi6RfBPrGVOxu7OWI=
X-Google-Smtp-Source: ABdhPJy5qpzI553uCL2+KmgXAhbnULI+Wzywy/Ign1YsEDFkvhxjWSV26vmO4i8KdM0PNo1tWRlVv1H06+I=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:ce4f:0:b0:51b:ac5c:4e49 with SMTP id
 y76-20020a62ce4f000000b0051bac5c4e49mr48265688pfg.81.1654909090550; Fri, 10
 Jun 2022 17:58:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 11 Jun 2022 00:57:55 +0000
In-Reply-To: <20220611005755.753273-1-seanjc@google.com>
Message-Id: <20220611005755.753273-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220611005755.753273-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 7/7] KVM: x86: Ignore benign host writes to "unsupported"
 F15H_PERF_CTL MSRs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
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

Ignore host userspace writes of '0' to F15H_PERF_CTL MSRs KVM reports
in the MSR-to-save list, but the MSRs are ultimately unsupported.  All
MSRs in said list must be writable by userspace, e.g. if userspace sends
the list back at KVM without filtering out the MSRs it doesn't need.

Note, reads of said MSRs already have the desired behavior.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 655fb0b3bba4..2fc556ac8a70 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3789,6 +3789,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_PEBS_ENABLE:
 	case MSR_IA32_DS_AREA:
 	case MSR_PEBS_DATA_CFG:
+	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
 		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_set_msr(vcpu, msr_info);
 		/*
-- 
2.36.1.476.g0c4daa206d-goog

