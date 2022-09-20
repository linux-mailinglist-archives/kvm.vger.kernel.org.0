Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCB445BF116
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 01:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbiITXbm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 19:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbiITXbk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 19:31:40 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FEC04D81C
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:31:39 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-349cf83cfc7so36659597b3.5
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=8DIJ+rv31hO3wgLmnQbReiEvjfaGVY+rgrY/lUx1yYI=;
        b=szI7vZsxPLW3mjv4KVmvNIJ2TlvhFBUYmY3qEAKG+k89+ES4vnvqZPEuVRfzjBfnet
         SWaa9GaxssZGvCEAkkNYE9ULn529nHwBIUsNDSxEm4S/nwDDr5b7ZXOsD0hddPL2Q7ru
         R24JVlwUSWORKK81Ddl2q51s9npDHBLDnyCpap+ryWJfPE1/+j/1M8I79kbnYMgqvYOc
         A53HGAr55eZFriDhvKNgKtQ9Ylq7Fs4KCQCMjM2rFGdEgRNfQlGfC5fdnRVg7iZr9K2R
         pY3ZpN50Zv61CiJXTvBxbGDCRQ8pqC64P8vZWdMsBo2ZxD4xqvLvkSO4Y3j5zAXs4o8p
         dSZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=8DIJ+rv31hO3wgLmnQbReiEvjfaGVY+rgrY/lUx1yYI=;
        b=FLJXzzM0vFyZ0eQDd1wuNy/nmnYkUGKOloE0bwtz5Ha2sj/bI23QXIcGSMoQfoillI
         iOtIKU4R7LuHMgN6kcKqF9/S1URlvanuz1Isuz9QPqzM9zghKz5PaoElnfyHXlBZKu7z
         Xnv3Yr0ZDHaEhmrXyzlfTzqeC7FEpzo0o09zKXkU11Rgp2rKFPo4mRRxS49/GsYw6pdY
         0i3/fGzS3kTFNahHVfiEAVlUxOpy525ogX3Vk18VdiLPzOxMYbjcfAncQblRTFTn3ybu
         aEo6xh7Kr1/8rj881m2jrLV4j/FlZU8OwNgTgr4vZsQO48S7vhC5/7SSwDi90aAj+f3M
         R4OA==
X-Gm-Message-State: ACrzQf1VBssrRry7ufpCnge3WXSgiLL8rN1pi/VoH/KFCw3PGRG0Gtmk
        rTaNQlizA+DJ5rb3MYbnMgS60BlGzYg=
X-Google-Smtp-Source: AMsMyM5WFLArj65i1u+S4kFIUU0v7QlqGoljtEt8cX9ZZSZiL+6Ak+MXR5R0hVT5v7hxsSL0A3dCUC2zFaw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:6941:0:b0:345:4409:5842 with SMTP id
 e62-20020a816941000000b0034544095842mr22180892ywc.298.1663716698901; Tue, 20
 Sep 2022 16:31:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 20 Sep 2022 23:31:07 +0000
In-Reply-To: <20220920233134.940511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220920233134.940511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920233134.940511-2-seanjc@google.com>
Subject: [PATCH v3 01/28] KVM: x86: Blindly get current x2APIC reg value on
 "nodecode write" traps
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

When emulating a x2APIC write in response to an APICv/AVIC trap, get the
the written value from the vAPIC page without checking that reads are
allowed for the target register.  AVIC can generate trap-like VM-Exits on
writes to EOI, and so KVM needs to get the written value from the backing
page without running afoul of EOI's write-only behavior.

Alternatively, EOI could be special cased to always write '0', e.g. so
that the sanity check could be preserved, but x2APIC on AMD is actually
supposed to disallow non-zero writes (not emulated by KVM), and the
sanity check was a byproduct of how the KVM code was written, i.e. wasn't
added to guard against anything in particular.

Fixes: 70c8327c11c6 ("KVM: x86: Bug the VM if an accelerated x2APIC trap occurs on a "bad" reg")
Fixes: 1bd9dfec9fd4 ("KVM: x86: Do not block APIC write for non ICR registers")
Reported-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9dda989a1cf0..8004c4d0a8e5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2284,23 +2284,18 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u64 val;
 
-	if (apic_x2apic_mode(apic)) {
-		if (KVM_BUG_ON(kvm_lapic_msr_read(apic, offset, &val), vcpu->kvm))
-			return;
-	} else {
-		val = kvm_lapic_get_reg(apic, offset);
-	}
-
 	/*
 	 * ICR is a single 64-bit register when x2APIC is enabled.  For legacy
 	 * xAPIC, ICR writes need to go down the common (slightly slower) path
 	 * to get the upper half from ICR2.
 	 */
 	if (apic_x2apic_mode(apic) && offset == APIC_ICR) {
+		val = kvm_lapic_get_reg64(apic, APIC_ICR);
 		kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
 		trace_kvm_apic_write(APIC_ICR, val);
 	} else {
 		/* TODO: optimize to just emulate side effect w/o one more write */
+		val = kvm_lapic_get_reg(apic, offset);
 		kvm_lapic_reg_write(apic, offset, (u32)val);
 	}
 }
-- 
2.37.3.968.ga6b4b080e4-goog

