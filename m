Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E369E546B83
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 19:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350172AbiFJRL6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 13:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350154AbiFJRL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 13:11:56 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA63B1FD9D8
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 10:11:53 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id e18-20020a656492000000b003fa4033f9a7so13593032pgv.17
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 10:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MZAi3yK1u5t2/PPPhYZ7bws8IBCCqfLr/RVHEehBKTk=;
        b=KGIj83RcQNuoV7xMIJ30k0ClhjI5cri5X7qxh3md4ad+epDgKwCS76PFTeS1CfKY8Q
         jwJr4iqPsAmfHLdhO4QrzFOo2JfnIPPTlp5McI2rin4nRjOUYGCDPyG02K3xWytorMKj
         0OEOaRRztwkgb1wxwFZ65SSAezvgDrA+TBNr6U8X4pbKxcBwAePoXtZnGyUDV5z35Ifa
         NFE+ptvXcnVKpsKV4FsGDHdHsY7THegMMeVkZb9g1zY4aOD4tEpa9oXWN7hKL4129L7v
         +WzClJKDpnHdsBU5PPL8+urP75vQF4RuyU14Je7nPj9My+yDeVre73Erp4zU0dBav3vK
         CdmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MZAi3yK1u5t2/PPPhYZ7bws8IBCCqfLr/RVHEehBKTk=;
        b=hSLYJf1Qt9ZYYfj3Y/LcUR08K8HUP9UrZ0FD5ayQyfXt9+VEfqT6CXGL/SZxFraFfK
         9d8NUq1P06xuDwGmleoM/gQNsZkYEPnCPwtKWVZsUq22Uz5glr7K/sL9poIQcDLEChp1
         OelMBU1Y/O1PLrGW4kxxkmAv6l1A7QqXUCbRhGppU4HdifcF/vkzZD1bxyLwr0w0b10H
         w0qqbXbsi7yZc+KEtwBMfwHHMDjheVYTVVeBcSC6bnxVpnpK+BPm8ZKbXxEgume7ACXu
         +WG2by+v1G2dbEGHs0Mdr0zxzObi6jtqbXMuojpNxE77OTQFaTQcMYOHh3YdCHQ/bRXC
         zSvA==
X-Gm-Message-State: AOAM530iDe2M7qPehIjBwZAoQoiY4rIy3RYMKQZ+WlCfJiq6IDsOA5r5
        RlM7IHw0rjsjtvQkJty+1tPf6jCr
X-Google-Smtp-Source: ABdhPJx949Pa5b3bUp1ZxJV0QFCmV3rO7TjPI2732MaCtmQLHIrY0oV7kGl3d/+TuYFt2U1IKFNBbtAc
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:9a6e:681b:67df:5cc4])
 (user=juew job=sendgmr) by 2002:a17:902:e78e:b0:163:caf2:2ef2 with SMTP id
 cp14-20020a170902e78e00b00163caf22ef2mr44610355plb.3.1654881112911; Fri, 10
 Jun 2022 10:11:52 -0700 (PDT)
Date:   Fri, 10 Jun 2022 10:11:31 -0700
In-Reply-To: <20220610171134.772566-1-juew@google.com>
Message-Id: <20220610171134.772566-6-juew@google.com>
Mime-Version: 1.0
References: <20220610171134.772566-1-juew@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v5 5/8] KVM: x86: Use kcalloc to allocate the mce_banks array.
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

This patch updates the allocation of mce_banks with the array allocation
API (kcalloc) as a precedent for the later mci_ctl2_banks to implement
per-bank control of Corrected Machine Check Interrupt (CMCI).

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a08693808729..71d0e2a7b417 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11226,7 +11226,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		goto fail_free_lapic;
 	vcpu->arch.pio_data = page_address(page);
 
-	vcpu->arch.mce_banks = kzalloc(KVM_MAX_MCE_BANKS * sizeof(u64) * 4,
+	vcpu->arch.mce_banks = kcalloc(KVM_MAX_MCE_BANKS * 4, sizeof(u64),
 				       GFP_KERNEL_ACCOUNT);
 	if (!vcpu->arch.mce_banks)
 		goto fail_free_pio_data;
-- 
2.36.1.255.ge46751e96f-goog

