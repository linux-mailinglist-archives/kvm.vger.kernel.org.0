Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E625A4004
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 00:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiH1WZw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Aug 2022 18:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiH1WZu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Aug 2022 18:25:50 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D467B13FB8
        for <kvm@vger.kernel.org>; Sun, 28 Aug 2022 15:25:48 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id b9-20020a170903228900b001730a0e11e5so5008756plh.19
        for <kvm@vger.kernel.org>; Sun, 28 Aug 2022 15:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=bJzhK9SKVOQc70YSCOsmEBRTVrANtgpX4ADnFqlNU4E=;
        b=CWAFJqwl6pgZp8h7EYlQRaYnt/lP0OKs0B8JSfoq0n4dQD7VKjtlhXPBHwkb3kP5rm
         fsbrh66CcP9AAtVteRxv8bhFS619geeXipmihzDvR+k/7ICaJ06CaOhK1G1jsfQJuIsO
         Z/zCU1fb9+iPNg5vBeSBNWolfdla/C7X/1FA9Sv2s18eXVV5yg9IkpTgglr9vMKpRnUx
         VrzEBtVcdrkEeuYvQ+XnM4xNBAHgNVta/ClOwEREQhaIHimQ/NXLzjshOteCBjHsG98o
         ZCzHVpDInEm4rVfQRw/Itg0jloMDWCUp2fqgKveNcMGmQO45FsJzijLD3Oh7WqW/mAPv
         N12g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=bJzhK9SKVOQc70YSCOsmEBRTVrANtgpX4ADnFqlNU4E=;
        b=CpjQZc4aY2Sq4bL2JwpUwIlbVuiaxUfSEfXwOZ6d8jJhRs3L+O7Wk9smBYmFkQG30b
         HXvNxlD9ZlVuOIf9Zq3aw4+v6QhhNSPfSoCU80tIeaKa+9DMnFStcR/akJL4nDVA58Zk
         qa+W8yoyA0AaLtev7VM4Sw2kNFhf8zqjAiOFNzNbFVr1KlWvylQnbLRQKGrh1/PZDp9V
         o+7XyHv5Vu1aQWhqhD9IRd0/G2j11ljAYgKwo+hyNKgixX4ug7hOdNmHbcTHxKONE3+i
         kEvFi5GVg+nPAQSY7cGj1kNFHSF3oaTxau5I0LTcR9OGeDSLXseM9XN+zud91XQdhxk3
         OVJg==
X-Gm-Message-State: ACgBeo2JBQTSW9VGcRFmcw9HpHRD8+qgRoleYTlllTGVH/bcD74rXhKI
        UqCxSPZgabJuD/zpibbdgF/UzJhshy7x
X-Google-Smtp-Source: AA6agR6aj2JFtODDYyHrp7CN/D0UPfsbQsmThliJrQuKeU+iU4k3Pg9cYu+ZkfDelt/t/B/ejt2Cao/HT200
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a63:81c6:0:b0:42b:c3fa:3a0 with SMTP id
 t189-20020a6381c6000000b0042bc3fa03a0mr5326593pgd.72.1661725548439; Sun, 28
 Aug 2022 15:25:48 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Sun, 28 Aug 2022 22:25:41 +0000
In-Reply-To: <20220828222544.1964917-1-mizhang@google.com>
Mime-Version: 1.0
References: <20220828222544.1964917-1-mizhang@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220828222544.1964917-2-mizhang@google.com>
Subject: [PATCH v2 1/4] KVM: x86: move the event handling of
 KVM_REQ_GET_VMCS12_PAGES into a common function
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Create a common function to handle kvm request in the vcpu_run loop. KVM
implicitly assumes the virtual APIC page being present + mapped into the
kernel address space when executing vmx_guest_apic_has_interrupts().
However, with demand paging KVM breaks the assumption, as the
KVM_REQ_GET_VMCS12_PAGES event isn't assessed before entering vcpu_block.

Fix this by getting vmcs12 pages before inspecting the guest's APIC page.
Because of this fix, the event handling code of
KVM_REQ_GET_NESTED_STATE_PAGES becomes a common code path for both
vcpu_enter_guest() and vcpu_block(). Thus, put this code snippet into a
common helper function to avoid code duplication.

Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Originally-by: Oliver Upton <oupton@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/x86.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d7374d768296..3dcaac8f0584 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10261,12 +10261,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			r = -EIO;
 			goto out;
 		}
-		if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
-			if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
-				r = 0;
-				goto out;
-			}
-		}
 		if (kvm_check_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu))
 			kvm_mmu_free_obsolete_roots(vcpu);
 		if (kvm_check_request(KVM_REQ_MIGRATE_TIMER, vcpu))
@@ -10666,6 +10660,23 @@ static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
 		!vcpu->arch.apf.halted);
 }
 
+static int kvm_vcpu_handle_common_requests(struct kvm_vcpu *vcpu)
+{
+	if (kvm_request_pending(vcpu)) {
+		/*
+		 * Get the vmcs12 pages before checking for interrupts that
+		 * might unblock the guest if L1 is using virtual-interrupt
+		 * delivery.
+		 */
+		if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
+			if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu)))
+				return 0;
+		}
+	}
+
+	return 1;
+}
+
 /* Called within kvm->srcu read side.  */
 static int vcpu_run(struct kvm_vcpu *vcpu)
 {
@@ -10681,6 +10692,12 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 		 * this point can start executing an instruction.
 		 */
 		vcpu->arch.at_instruction_boundary = false;
+
+		/* Process common request regardless of vcpu state. */
+		r = kvm_vcpu_handle_common_requests(vcpu);
+		if (r <= 0)
+			break;
+
 		if (kvm_vcpu_running(vcpu)) {
 			r = vcpu_enter_guest(vcpu);
 		} else {
-- 
2.37.2.672.g94769d06f0-goog

