Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3FF15ABBAA
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 02:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbiICAX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 20:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbiICAXO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 20:23:14 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB89F63D8
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 17:23:13 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id x25-20020aa79199000000b005358eeebf49so1733742pfa.17
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 17:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=Jc8tRpF99XNZU8n/zffImYz5blGtS9807hd1TKthgTk=;
        b=d+xh8WQ/+GTZy4U7G4pl3sLVfJ2oq6oyYhl7nGeBkTD6wNGtYwT5zuAushnn3gMO/w
         aB3GGtJsTSOnvcLV3HyzranfOaWf4ChYJx2OQxbJHlPNBN4K5Syw9PJ+Mm2V0+SnIxMN
         u2XVaQUxZc/03nQ9bVjDJuGQvW++RG06IY71UXJ9n93kVuQWe/y6Bwq72lKNhS4gMeeH
         R2B6yW2Lcwo6o1NhzPnBA6HqCPQo/En06xiUG1US56mKmWEgH0SRHjf5PnIVeYxFMdF3
         9fnLFi47dEh/cXENyqaFaGyVYbd+7Z9scAmi5t1Mxtpk6RNFMv8TZp5bpBzWXF70iExn
         pGJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=Jc8tRpF99XNZU8n/zffImYz5blGtS9807hd1TKthgTk=;
        b=o1m6c5s8SgMn6184J2j4L2NZgxpw6ZOmc/Mz/ax3dNGhoYfqP3kIyOL9GRt5YljBI2
         3tJZcnt6wwr5hRrwNN6axxBtlm4g61ksqk+blQqiiaVdLWFCy9NikucfbmkOMTXYdvZw
         oPqesEvqIhQfV8S2myCQifBgfLsLcGsHUMrrmmqQRcT32kqOlLpcOd/TaLaRYbLF1uOA
         86LMs5Sf4E3WL/gFjdPMzgZNoy79v/x52KqvrnSVgziqHgibiek2jvxWGYPjIgSY9jFl
         oQWcqixyoyucWe+UFPM2CgKOVDd0L3xkS3lT2rtM5FN72iMNSbYuW5WxwoIw55ufMiXB
         DCXQ==
X-Gm-Message-State: ACgBeo3L5y5CrgbuXBuMFGgtOHL+USE+Gj1j6kBDfh++Jsb+SMPU5ZE3
        Y5GeY9ifGqpjXCTxJHCBhULifhiKoYM=
X-Google-Smtp-Source: AA6agR71SBaZCeDyyRaHmxa0LZCa3oA0kjUUtNmD6qTohE8KIzS0YM497vbBYfyrfgAWMl0Fnezg669BY1A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1308:b0:53a:9663:1c19 with SMTP id
 j8-20020a056a00130800b0053a96631c19mr18133933pfu.60.1662164592882; Fri, 02
 Sep 2022 17:23:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  3 Sep 2022 00:22:39 +0000
In-Reply-To: <20220903002254.2411750-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220903002254.2411750-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220903002254.2411750-9-seanjc@google.com>
Subject: [PATCH v2 08/23] KVM: SVM: Fix x2APIC Logical ID calculation for avic_kick_target_vcpus_fast
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
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

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

For X2APIC ID in cluster mode, the logical ID is bit [15:0].

Fixes: 603ccef42ce9 ("KVM: x86: SVM: fix avic_kick_target_vcpus_fast")
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 50721c9167c4..163edc42f979 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -383,7 +383,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 
 		if (apic_x2apic_mode(source)) {
 			/* 16 bit dest mask, 16 bit cluster id */
-			bitmap = dest & 0xFFFF0000;
+			bitmap = dest & 0xFFFF;
 			cluster = (dest >> 16) << 4;
 		} else if (kvm_lapic_get_reg(source, APIC_DFR) == APIC_DFR_FLAT) {
 			/* 8 bit dest mask*/
-- 
2.37.2.789.g6183377224-goog

