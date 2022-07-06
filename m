Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8F7568C0D
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 17:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbiGFPAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 11:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbiGFPAD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 11:00:03 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7091325281
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 08:00:02 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id mh7-20020a17090b4ac700b001ef88609386so5333632pjb.9
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 08:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=jiCbfvBKJiHEBlhpaNZGJF4HgSeCbeiVR31YCzi16jI=;
        b=D20Dw0WKjrQwKOmxtYdaLuon1teiIyQykkLah4zt8SjlekR2O6dVRixQ+MU2peuQW5
         x/1iDMEkPV+TquKezLOr7Z+H7Wn0UdNLgUZjtOKsu6YCQOVoMmGQ80kuLTh5LeEximoh
         GWQ8F3tq+5wR/tGFHSRloQIJNaeJhDSjlBLegA0VX1ZddmYC6+pnCr6uAMbBHbjwQcUG
         JpBgNRpcczdbhSgvCal0ZYnXj10/O5p/AYVkg8altwf1ZuD5ijgKJl1VpQ6T7Z/MWW+g
         V6MYC/zvG4N6Oo65F/PCh5MlMrmSV+Q/triM53s1s40gA/Wwekcd5nhWGfuuVpeCVYE3
         LgwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=jiCbfvBKJiHEBlhpaNZGJF4HgSeCbeiVR31YCzi16jI=;
        b=p9R3bo9d0hYtMD+V+KAuF0+I/jznL7nwQUUbg7MhQHoKzKK4BQH5rz1j7p8NQ9I7Dv
         gB33MRgd6FthH20uG2JxqDh+g+M13JGEGkWgy6ZeCeiJDl+SebqgO0VBQrHvh7JtIiV2
         MTPOwYJ2WtORz+VHAWaan78BMs1DqHgjp82Z3uFX5ealiHiCll/amKo91hjJw+l1aQ0l
         MnNBcdKDSs4vvZU7UmzkX3upKhXpUpJbbcnyAQaErj39zo2iQ7TIu0NDHgrfugWlYWSK
         LH2WcPnHl4Q6bwsa/D1pAxDiUpm8w/PkN1AzGsV2d4YiX49446/1FOwg0MHa2F1TKz4Q
         HSVQ==
X-Gm-Message-State: AJIora8zNaDE7OtkT0LbkJx/b3bACdqvy3buUR/6KRknNHaXneweTMAC
        V6i1Arw4YAaFp164L9X5I0N8qoL9
X-Google-Smtp-Source: AGRyM1ucUqZAg2ejoYeKI2N7SH/z32paYwqRxCAAIiCJwNkHZVnLE2KQgoSDTBocxyzhaXBP9PayeNbz
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:2e3c:7c6b:b9e8:661])
 (user=juew job=sendgmr) by 2002:a17:902:f78b:b0:168:faff:d6a5 with SMTP id
 q11-20020a170902f78b00b00168faffd6a5mr46270139pln.76.1657119601959; Wed, 06
 Jul 2022 08:00:01 -0700 (PDT)
Date:   Wed,  6 Jul 2022 07:59:56 -0700
Message-Id: <20220706145957.32156-1-juew@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v2 1/2] KVM: x86: Initialize nr_lvt_entries to a proper
 default value
From:   Jue Wang <juew@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Siddh Raman Pant <code@siddh.me>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
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

Set the default value of nr_lvt_entries to KVM_APIC_MAX_NR_LVT_ENTRIES-1
to address the cases when KVM_X86_SETUP_MCE is not called.

Fixes: 4b903561ec49 ("KVM: x86: Add Corrected Machine Check Interrupt (CMCI) emulation to lapic.")
Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/kvm/lapic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8537b66cc646..257366b8e3ae 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2524,6 +2524,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 
 	vcpu->arch.apic = apic;
 
+	apic->nr_lvt_entries = KVM_APIC_MAX_NR_LVT_ENTRIES - 1;
 	apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!apic->regs) {
 		printk(KERN_ERR "malloc apic regs error for vcpu %x\n",
-- 
2.37.0.rc0.161.g10f37bed90-goog

