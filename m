Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7D05BF131
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 01:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbiITXcs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 19:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbiITXcI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 19:32:08 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E93A786F1
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:32:02 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id rw5-20020a17090b2c4500b00203182a71baso2325574pjb.1
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=5GsqhbbGqpXSLs5HXSK0LpXI8Qc72DvGpf3l/GetlBw=;
        b=mjW4qwPG9BQT9ulnOXMpCgH+b9mVvqhrQ3wP9TfW80M6o9SyZmHs/vc/D20Yg7WzTA
         qvxOzLmOfy15+uw8dATfwuJPkgnPdLThidaqknYHPhb12OTKTUJXagoeCP8KDIFuBkEI
         5AyrOOemNU/4jYkcs1Ypt8vsM9RRZUlA4te0OP/jn28C7EMNO1LJAHGdFzloqnSEjoIR
         9doRixXjbNXnVAR/i9xwF6PlrBfcKeDHgCK12cW1vXgGkDPZhG9krCBIQhAV5ZrDzw2i
         jkqZt48isuJbkuWDLrAumAIR26rpIqBJoF3eFOud3iLY1/d7s+zqzAWcVyz3k3L47O02
         eB/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=5GsqhbbGqpXSLs5HXSK0LpXI8Qc72DvGpf3l/GetlBw=;
        b=gkcbEBIPv4Q0RNgfiVlAFMLivfGcxiokTqmex+jo/V6DsOoTsPi0Fn5tBjvqOd5A2s
         jO3fsTPyx3GkfVvFuBcZOX1QXvGUK1IqrO5WLpuL4a7B4eSLcS2rPYlqNCLAGNIZzQvw
         XvKVifrE1QAfeSWR2VURhnHSY26sq6I9/Ng6SDcUFK/FOj9+ocs7GSKnaLluVZppKq16
         xM/fc74uuyUAo9IjREQL/G0r6215P5Jts0FyLK92AlVUDDOAi4D3TAElHvFoaUrQgcxW
         HfqcqbZlVjXF4h+zekNPjlHtn8w2SUFVdzg7LATeNAolAGkPK8Wa4OHsskbhslfWxD4X
         dcoA==
X-Gm-Message-State: ACrzQf3zps7j2Eqt6kSzNypmUzWDZZx5CDTn3Wwqf+94z4yRV8vCtY88
        JmvJLqhkGM/HOcplBo9fz3M0dngfxKk=
X-Google-Smtp-Source: AMsMyM7s03BVUNV2z6j27hTV9ODy9TShZuLIVxKcbTL8RX71hZ8H4oOP41NtdFp3qOctZc+aih0Uk7U7gUo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c245:b0:178:3912:f1f7 with SMTP id
 5-20020a170902c24500b001783912f1f7mr1909652plg.75.1663716722102; Tue, 20 Sep
 2022 16:32:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 20 Sep 2022 23:31:21 +0000
In-Reply-To: <20220920233134.940511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220920233134.940511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920233134.940511-16-seanjc@google.com>
Subject: [PATCH v3 15/28] KVM: x86: Explicitly skip optimized logical map
 setup if vCPU's LDR==0
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly skip the optimized map setup if the vCPU's LDR is '0', i.e. if
the vCPU will never respond to logical mode interrupts.  KVM already
skips setup in this case, but relies on kvm_apic_map_get_logical_dest()
to generate mask==0.  KVM still needs the mask=0 check as a non-zero LDR
can yield mask==0 depending on the mode, but explicitly handling the LDR
will make it simpler to clean up the logical mode tracking in the future.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 70f00eda75b2..bf647af50031 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -286,10 +286,12 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 			continue;
 
 		ldr = kvm_lapic_get_reg(apic, APIC_LDR);
+		if (!ldr)
+			continue;
 
 		if (apic_x2apic_mode(apic)) {
 			new->mode |= KVM_APIC_MODE_X2APIC;
-		} else if (ldr) {
+		} else {
 			ldr = GET_APIC_LOGICAL_ID(ldr);
 			if (kvm_lapic_get_reg(apic, APIC_DFR) == APIC_DFR_FLAT)
 				new->mode |= KVM_APIC_MODE_XAPIC_FLAT;
-- 
2.37.3.968.ga6b4b080e4-goog

