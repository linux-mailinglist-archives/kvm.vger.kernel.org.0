Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828235BF13E
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 01:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbiITXdT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 19:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbiITXcK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 19:32:10 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F61785B4
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:32:09 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id cg5-20020a056a00290500b0053511889856so2480954pfb.18
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=EpWQgthCzwVlN1+QDovdFCTrEnPbNzZiM48g8Uk0Cqs=;
        b=ICkmuWwmWjHn4KH3q8vaKoU16Z+bWz2DowxDhujdMEzB4uglAaJiFzMAss0+DLyuDO
         4fNdkoSB8JYdRaGEpHnzEnhiq785DVElXgbyUcuOChJgA41emKrbWTngTVeVcueUoOgI
         YFHuQUcSCcics6ETwR02K4I0A+ZayxoP7IhtLDAWhxt7mlhQBg5v5y+/dS+zbD9eKIS4
         rQPOwk/qRQTMyP9J2O2FiCtSr/VJBcZi6svRQL0s/afLyA7ZTzP/n4l95BkMARxEAs1z
         KLmOzY9/A/Vw1TJHiiN945z7KYKvMUzxuL4YY0HGjPCDBZkQ+IIua5Ey2487KkJLl4yD
         YLDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=EpWQgthCzwVlN1+QDovdFCTrEnPbNzZiM48g8Uk0Cqs=;
        b=iEAg08arIYiTskl0/BV1OEESOgDtgpou8mcfSLIxHY8OSt3LjVGX5bM/Iel9H9PSeT
         DWPh3mDCdwcyjq2Apl/LUWlnDnE1CWMUR1D1xuvXtEdI50xljXxH4caIoVs68IxRyPVA
         o76xSSLxQsETqX7MXUtuJbf42E3NE1UjvwKd2DttbPsNiBQWYRbDdzVqCYv2dlVpyIOM
         AS42hHnG4WSlMLdRE2aaBFxZHHSoOGRZ1/3s06pULuM0rSw/PiKIAbasi6wgg5pw5qsN
         xKdDCne5G4q+nf2s0Vfi0RsljUAkciCfv6/FxAQk9N5cen/C72QTIeeFKBxowctcYMo8
         7V0w==
X-Gm-Message-State: ACrzQf3Ol1JZawFN7ngFb3L4VDNT8zrBIXhh6POti3pAxGDHIf0vQtBs
        Yns6WQ79fk3sXw8OfBqvtbApqqjU6bM=
X-Google-Smtp-Source: AMsMyM64WYPPbsmc8kPNJpF8TVe2l1U1WthIbKGNZq82LyCgxeCwhItfCI6/KUPndfsknD2/gAtJHYvyGoM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:7586:b0:172:d0de:7a3c with SMTP id
 j6-20020a170902758600b00172d0de7a3cmr2021687pll.38.1663716729065; Tue, 20 Sep
 2022 16:32:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 20 Sep 2022 23:31:25 +0000
In-Reply-To: <20220920233134.940511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220920233134.940511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920233134.940511-20-seanjc@google.com>
Subject: [PATCH v3 19/28] KVM: x86: Disable APIC logical map if vCPUs are
 aliased in logical mode
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Disable the optimized APIC logical map if multiple vCPUs are aliased to
the same logical ID.  Architecturally, all CPUs whose logical ID matches
the MDA are supposed to receive the interrupt; overwriting existing map
entries can result in missed IPIs.

Fixes: 1e08ec4a130e ("KVM: optimize apic interrupt delivery")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/lapic.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a12360fd4df6..e447278d1986 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -341,11 +341,12 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 		if (!mask)
 			continue;
 
-		if (!is_power_of_2(mask)) {
+		ldr = ffs(mask) - 1;
+		if (!is_power_of_2(mask) || cluster[ldr]) {
 			new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
 			continue;
 		}
-		cluster[ffs(mask) - 1] = apic;
+		cluster[ldr] = apic;
 	}
 out:
 	old = rcu_dereference_protected(kvm->arch.apic_map,
-- 
2.37.3.968.ga6b4b080e4-goog

