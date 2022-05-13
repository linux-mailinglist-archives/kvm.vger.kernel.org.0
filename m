Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7479E526922
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 20:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383275AbiEMSVP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 14:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383279AbiEMSVB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 14:21:01 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0252B23BB45
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 11:21:00 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id b10-20020a170902bd4a00b0015e7ee90842so4718069plx.8
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 11:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IJxSnagy2sm2B4KUyvi+8Pfu8z1S62fQlZ1vK8Er4xM=;
        b=qQ6qJDKbPkcZno+x5oT47zj87mmPdhjZCM2L2OM0A+xqxNik/V4jTEPCTQvrknkfho
         0QeW4SWbW2Vw+jglnLkAylpLc1G8pmu5QQJ3qRRgs+/7iSpyP2LkPIpD8xCKutETQQqX
         w/8GjA44d3Lzo771UPZRXT4FQ72Z1wFkKIghTiGss+BYoMxOYT0Ol0DgytFJNh3yLrFW
         w4GOM7kNiwcG/20ORlbzL8SbBIAenWMUejjnyBcjIHFkpdNg7yXCh4Oii0MUlPbqruCx
         n8u9hFGmwm8JuP39iUDzSOCu2B7GalrkuN4NoalyqXiU1yJdvaJ/00t8pkYjDGCAxiZ+
         dIkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IJxSnagy2sm2B4KUyvi+8Pfu8z1S62fQlZ1vK8Er4xM=;
        b=7pwEm6W35pCKTUvF8JZxoNuJ/tlYQ2cBF4YaWiga5J1CIk1DBim3Iz75Ao73gocCjQ
         vKAK/24p759FyguK4L3qYLfchFZbrPpmXC2e4Gky52W/fk7cyGhM7RSxuTcXMrD5xXkg
         YIo0oVW0ZpyXZumQbFqQyb3O26YjynCj8DYi5ZPNjQ4nJd8Rsh3E97l2kSdadx1jVfzy
         BhihTF49ApSyzdrx757NH8IpCe5VzF9PcykGp9Vc127bMlILbQYBGbCYLiCT+KlQ/ol7
         X1gRQPAeu9A7X9a+AFO7GqRvwwa0BkyrT3z1EUgkEHe0G1vDlnYjwe4+7sb5mUBHzShz
         kejg==
X-Gm-Message-State: AOAM533XQkLRWWcLLATnrwOMdwsSzK+i5Xd3/USASixyEaJRoDY6T5Ys
        LBDy8Vv+SbFQu3XjUC3YtUqk/O6q
X-Google-Smtp-Source: ABdhPJz9VOvN31JGjH2g3ERrca7FLGcavnNuE1qAkpAnhmlT/a6bg3kD4L3hGDoSPIZyz+/hUnUjVAG8
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:d883:9294:4cf5:a395])
 (user=juew job=sendgmr) by 2002:a05:6a00:856:b0:510:85fd:14f9 with SMTP id
 q22-20020a056a00085600b0051085fd14f9mr5622340pfk.76.1652466060297; Fri, 13
 May 2022 11:21:00 -0700 (PDT)
Date:   Fri, 13 May 2022 11:20:34 -0700
In-Reply-To: <20220513182038.2564643-1-juew@google.com>
Message-Id: <20220513182038.2564643-4-juew@google.com>
Mime-Version: 1.0
References: <20220513182038.2564643-1-juew@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v3 3/7] KVM: x86: Add APIC_LVTx() macro.
From:   Jue Wang <juew@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
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

This series adds the Corrected Machine Check Interrupt (CMCI) and
Uncorrectable Error No Action required (UCNA) emulation to KVM. The
former is implemented as a LVT CMCI vector. The emulation of UCNA share
the MCE emulation infrastructure.

This is the third of 3 patches that clean up KVM APIC LVT logic.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/kvm/lapic.c | 7 +++----
 arch/x86/kvm/lapic.h | 2 ++
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0886fb6adbcd..c01f6ecb3d12 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2041,9 +2041,8 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 			u32 lvt_val;
 
 			for (i = 0; i < KVM_APIC_MAX_NR_LVT_ENTRIES; i++) {
-				lvt_val = kvm_lapic_get_reg(apic,
-						       APIC_LVTT + 0x10 * i);
-				kvm_lapic_set_reg(apic, APIC_LVTT + 0x10 * i,
+				lvt_val = kvm_lapic_get_reg(apic, APIC_LVTx(i));
+				kvm_lapic_set_reg(apic, APIC_LVTx(i),
 					     lvt_val | APIC_LVT_MASKED);
 			}
 			apic_update_lvtt(apic);
@@ -2343,7 +2342,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_apic_set_version(apic->vcpu);
 
 	for (i = 0; i < KVM_APIC_MAX_NR_LVT_ENTRIES; i++)
-		kvm_lapic_set_reg(apic, APIC_LVTT + 0x10 * i, APIC_LVT_MASKED);
+		kvm_lapic_set_reg(apic, APIC_LVTx(i), APIC_LVT_MASKED);
 	apic_update_lvtt(apic);
 	if (kvm_vcpu_is_reset_bsp(vcpu) &&
 	    kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_LINT0_REENABLED))
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index f8368dca177a..7ba4c548853e 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -39,6 +39,8 @@ enum lapic_lvt_entry {
 	KVM_APIC_MAX_NR_LVT_ENTRIES,
 };
 
+#define APIC_LVTx(x) (APIC_LVTT + 0x10 * (x))
+
 struct kvm_timer {
 	struct hrtimer timer;
 	s64 period; 				/* unit: ns */
-- 
2.36.0.550.gb090851708-goog

