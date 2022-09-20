Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 093885BF14D
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 01:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbiITXeW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 19:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiITXdt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 19:33:49 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B6B7962C
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:32:30 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id q22-20020a62e116000000b005428fb66124so2459901pfh.16
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=IwIDRB2fdBDsWatYvvn/b5WepxQQ5yAW/agrrgEdwWA=;
        b=g5gYWoKJoWP2RKZ3tCd/tFFumUE5tJ+17slStwiTofUeIt1XFXEgUug1yMs9fCzmv0
         GtpIf5KmYiUj7YVwZYueywqj7c7Wcs3DcsciGcOOJ4Eck11+wyMYKSrYU+12WSAHPHyZ
         01yND6PkWOjj0UhoJ3OOkuWCURQdbGpnDVkAjr0otE6fa5IYI6UWr/5OlIVYTIcpVGxp
         97r8c5kTc0JzaB4w69EDF4ZAzdJx+AFs0OT0H2EjuYcpcy7fcP4W/TPihb3yUXdnvhfm
         qjsaOzYq7GMFxrDydVy9cxVBPCFZ9tSEB6I7DDORbMewr95GvUbnsL+BJRNzPtrouVXH
         Vlag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=IwIDRB2fdBDsWatYvvn/b5WepxQQ5yAW/agrrgEdwWA=;
        b=oSxT6SiQHMhu32NI1fS6GGRiE5XQT2p9C/aqgvPOd0DqUZwbt/AtzUlg8PveNver9g
         AMucMmNZCrk1JeZgXF2d+LrmV/KAQrJCZkvfERWPGcSjhoOyaFh8keFRllWAkqtBBzza
         avcIr21Do7Kl5LAEibPsn5ZAdM26g1uQ7skWMmFeEplUVnxo+L4NKwUsINybHaKMhr03
         gT2qBLNJR/fZZScLMfJvcHdztvO/KieThVXKOVGzC6QKWZUtD1178uNzTbOIHTWPEYKv
         zDGXGazzNfaCDD+t6oXaCA3clYIo8SdwQ3llLPL1aWGiq8OuaJSQ4LHqhCcJHjOylREV
         90/Q==
X-Gm-Message-State: ACrzQf0ddyUrQxhRoD8FK2ebx5rj8mnutyaaiBRK6KXIte1o/b2tvaeB
        A3VgjNZ17m0ggT6v558UlTP/Bg2B41Q=
X-Google-Smtp-Source: AMsMyM6Ifd/fZX0J5EwCgTEYcvX7LrIRtY5UFKVCalU9/wioZU7W+kaizfcv0gYwyjWidSPJAaZcixpUHss=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:2983:0:b0:54e:7cd5:adb3 with SMTP id
 p125-20020a622983000000b0054e7cd5adb3mr13239877pfp.38.1663716739239; Tue, 20
 Sep 2022 16:32:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 20 Sep 2022 23:31:31 +0000
In-Reply-To: <20220920233134.940511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220920233134.940511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920233134.940511-26-seanjc@google.com>
Subject: [PATCH v3 25/28] KVM: SVM: Require logical ID to be power-of-2 for
 AVIC entry
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

Do not modify AVIC's logical ID table if the logical ID portion of the
LDR is not a power-of-2, i.e. if the LDR has multiple bits set.  Taking
only the first bit means that KVM will fail to match MDAs that intersect
with "higher" bits in the "ID"

The "ID" acts as a bitmap, but is referred to as an ID because theres an
implicit, unenforced "requirement" that software only set one bit.  This
edge case is arguably out-of-spec behavior, but KVM cleanly handles it
in all other cases, e.g. the optimized logical map (and AVIC!) is also
disabled in this scenario.

Refactor the code to consolidate the checks, and so that the code looks
more like avic_kick_target_vcpus_fast().

Fixes: 18f40c53e10f ("svm: Add VMEXIT handlers for AVIC")
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 4b6fc9d64f4d..a9e4e09f83fc 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -513,26 +513,26 @@ unsigned long avic_vcpu_get_apicv_inhibit_reasons(struct kvm_vcpu *vcpu)
 static u32 *avic_get_logical_id_entry(struct kvm_vcpu *vcpu, u32 ldr, bool flat)
 {
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
-	int index;
 	u32 *logical_apic_id_table;
-	int dlid = GET_APIC_LOGICAL_ID(ldr);
+	u32 cluster, index;
 
-	if (!dlid)
-		return NULL;
+	ldr = GET_APIC_LOGICAL_ID(ldr);
 
-	if (flat) { /* flat */
-		index = ffs(dlid) - 1;
-		if (index > 7)
+	if (flat) {
+		cluster = 0;
+	} else {
+		cluster = (ldr >> 4) << 2;
+		if (cluster >= 0xf)
 			return NULL;
-	} else { /* cluster */
-		int cluster = (dlid & 0xf0) >> 4;
-		int apic = ffs(dlid & 0x0f) - 1;
-
-		if ((apic < 0) || (apic > 7) ||
-		    (cluster >= 0xf))
-			return NULL;
-		index = (cluster << 2) + apic;
+		ldr &= 0xf;
 	}
+	if (!ldr || !is_power_of_2(ldr))
+		return NULL;
+
+	index = __ffs(ldr);
+	if (WARN_ON_ONCE(index > 7))
+		return NULL;
+	index += (cluster << 2);
 
 	logical_apic_id_table = (u32 *) page_address(kvm_svm->avic_logical_id_table_page);
 
-- 
2.37.3.968.ga6b4b080e4-goog

