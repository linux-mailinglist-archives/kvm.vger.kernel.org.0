Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 902EE5F17E4
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbiJABCv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232940AbiJABCL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 21:02:11 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5940BEEB62
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:00:16 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3515a8a6e06so56917857b3.12
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=LyAH7hE4jcL9QcgVMCH2onNrTIVmeTtfuLQRhpXukZY=;
        b=MlccqVYVRGGnVkH/IoFciw4sGjXt0kp761f3WozY1LkqPii8NOsfz5TI6jRX0ScdEi
         be+cHOBk3Rd44MIY03XLtWQ1R5wca3jFhe5LedINJRQ3D+YqxEJcyixFQey64/Qg2zEo
         9qgBs+NV5fLTkbYMoDkIUOP1xrMHW44TiPq3sPfC4rnJCmASJYfwDId5FfqpREtIfPKm
         q7s6mBAK12dQqU59hN7FdLeo0rv9hwP419T3rbDYrqzFDDYFZ+HxiuuOgAA6xkzXxNU9
         unZ+rkn0VNl+fgoVEVJ15OENOoio2zWzhzyw6JPdmtU1mjocXLebprCEyy4o7+q4hZFR
         URuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=LyAH7hE4jcL9QcgVMCH2onNrTIVmeTtfuLQRhpXukZY=;
        b=4wOCbvtfzrQsyygt9Be1RhDRXu5dBEKeKgBLy4GubWoTDmOWBytp47VydN0fLNip9x
         aOstGIeWHTfcFcttyXTKaB3ZfJ9uFtPdV5kqvL2IM+HxJvM/jMklo8aLMDjWq9XbwBce
         a+XDGX8bVSvAXPp/MHoEdxvsDCzyQlTlBwwi1IPXvtiJrfsJtvmb9iAh/OFqCoAHFO38
         ace0gd6PYLFxyVSQADWhVd1AGywJ3z3tCsTaSK8xmesnSOzbbTBCFdt+8E5s2NI1JPhy
         hAbLpG7L441dyUL8eRSGPiZu9aZZUrsscHem8HH2TokTPj2iXLV2f7IEyhS3qToNB5Aq
         j/gA==
X-Gm-Message-State: ACrzQf1WIyy+JUIqmz7J+efXAy9wjlH8BgspZlQENuu4plyNXRuUQtPu
        W4r+gqDPAyTQNrxvQMX5zs0tgysvsZI=
X-Google-Smtp-Source: AMsMyM6C+3TlSeGlunUd1eW9Rp33CCs61sjN1XLPKi3j4nR57e92LiXCa3ye9Lka2dxO2w6jaAv/RqCkfuU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:10a:b0:6af:b884:840e with SMTP id
 o10-20020a056902010a00b006afb884840emr10898548ybh.330.1664585996098; Fri, 30
 Sep 2022 17:59:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 00:59:05 +0000
In-Reply-To: <20221001005915.2041642-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001005915.2041642-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001005915.2041642-23-seanjc@google.com>
Subject: [PATCH v4 22/32] KVM: x86: Disable APIC logical map if vCPUs are
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
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
index 7fd55e24247c..14f03e654de4 100644
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
2.38.0.rc1.362.ged0d419d3c-goog

