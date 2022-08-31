Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFEA55A72C7
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 02:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbiHaAiE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 20:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231851AbiHaAhN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 20:37:13 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44029AB077
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:36:03 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id dc10-20020a056a0035ca00b0053870674be9so2429359pfb.12
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=rkBfsy5vecrqHl4IR9aqERIJtU+S3QBzoIPSLUPWWcQ=;
        b=osChJHQCjyEjzZh+u4eXClqsGeReKzrEX47qOzWatIMtwD1ntPeaDvlnJXz+JRgg0Y
         hlsrXPhUAZfKdTSclu9qwojxkwN+IMSy2hdu2SD9S7ORQDbkFlds6CHb4gJkhBQPApcF
         AmIollHjpJl9UwKBxRzUQ1nwzgJ02lQn568OL0boEXQjeNE2oAauPJxderHfcuC7P5Ap
         MVTdDFeC1JCaQnKq5ijQrIRDC5SKzphoVzQCosh3kguSpVG/vTuI5LX5gR55F21cnQa0
         Zu24Rchbnw4eJi5I1noq7AJ+ED43KvyNzYgGW10zSOxP/5frwNXsgQHiNPiYh6hm+LFh
         An5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=rkBfsy5vecrqHl4IR9aqERIJtU+S3QBzoIPSLUPWWcQ=;
        b=bW+RwVe3JzmTEKFVA2o2Ch+p8i/aaWoxCEna496D6JyRN3c8J2+1CJZaLTxDy0YZE2
         Essh9LJZDT6DChH7lWfKRtWYyPCSUTuk0GdvJ+E+gc8N1AjNDu0Z6TchQHDBsJBdPufI
         hwN73aV6TxScw9E4sT9KqJvDIgX9M9nbvr/tjIq9EOQlhheVtXaLu5W90JnQlKdD4f2s
         5GZuXFU7cBGHpvrvMUNQVIdl7wTz9vp5MjPxXaJ/7jIeW5LCF1yE3aAW0bZ8AGU2X3mZ
         CVGTdoinxdGOXYLdXXN33OASrxh8M6KMGrb8ug9hYQjXnoNCVvcR2dimiYbF6tlChPuL
         8+eg==
X-Gm-Message-State: ACgBeo3C/OHdhqCFkeh2EoBWbZwzK+zjTD4ltk8UkUEUcjmOud/hYser
        Oio6DMlQAxC81QcgvoCklEt04z2w6sM=
X-Google-Smtp-Source: AA6agR42zIyRkCvEj3ckgNwXaZ7y80vJrHd+DtX8xLAytvxHt7YF3iajhVwjSTrnJwHXW5NikzyVP9pxwIg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d2c1:b0:172:c1af:fd26 with SMTP id
 n1-20020a170902d2c100b00172c1affd26mr23311620plc.4.1661906129448; Tue, 30 Aug
 2022 17:35:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 31 Aug 2022 00:34:59 +0000
In-Reply-To: <20220831003506.4117148-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220831003506.4117148-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831003506.4117148-13-seanjc@google.com>
Subject: [PATCH 12/19] KVM: x86: Disable APIC logical map if logical ID covers
 multiple MDAs
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

Disable the optimized APIC logical map if a logical ID covers multiple
MDAs, i.e. if a vCPU has multiple bits set in its ID.  In logical mode,
events match if "ID & MDA != 0", i.e. creating an entry for only the
first bit can cause interrupts to be missed.

Note, creating an entry for every bit is also wrong as KVM would generate
IPIs for every matching bit.  It would be possible to teach KVM to play
nice with this edge case, but it is very much an edge case and probably
not used in any real world OS, i.e. it's not worth optimizing.

Use an impossible value for the "mode" to effectively designate that it's
disabled.  Don't bother adding a dedicated "invalid" value, the mode
handling will be cleaned up in the future and it would take just as much
effort to explain what value is "safe" at this time.

Fixes: 1e08ec4a130e ("KVM: optimize apic interrupt delivery")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9dda989a1cf0..82278acae95b 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -300,8 +300,15 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 		if (!kvm_apic_map_get_logical_dest(new, ldr, &cluster, &mask))
 			continue;
 
-		if (mask)
-			cluster[ffs(mask) - 1] = apic;
+		if (!mask)
+			continue;
+
+		if (!is_power_of_2(mask)) {
+			new->mode = KVM_APIC_MODE_XAPIC_FLAT |
+				    KVM_APIC_MODE_XAPIC_CLUSTER;
+			continue;
+		}
+		cluster[ffs(mask) - 1] = apic;
 	}
 out:
 	old = rcu_dereference_protected(kvm->arch.apic_map,
-- 
2.37.2.672.g94769d06f0-goog

