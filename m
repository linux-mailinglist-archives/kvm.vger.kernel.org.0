Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07D105BF13B
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 01:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbiITXdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 19:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiITXcJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 19:32:09 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0DD74E0F
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:32:07 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id f16-20020a17090a4a9000b001f234757bbbso2308610pjh.6
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=bOqaUaJyqI3z8R7EROs3ckH7IV3vf21Y4AlyOgMQUZo=;
        b=ZZJ/8TUjBMyr2KLCj8eOdJ2dhuEEWsGbVkKnR5ZrnRuALq+3XMkFrL1FMkfwpqOi+G
         nifNhjyeZUTdoEi+0Q6iZ2S2BJMxVg9Vkf6laqKQi8xHg4s1cYdxxRJ4fRkYAEcXYjMt
         5J802K6stGF8zcH+b2fkwJGh6vKICdcqpiBezd7GwvkzQad+mcuIO8Z2y7R1VMThvzM1
         R+hnnoiZPn80BpvWrhAncqwr0nzXktn7ij3jpwCjDMBiH6qnzJmg6wkcqenCOPMKhFCu
         YmiQ7aH0LxOjvtpZ9cZ0eyKLqSgtqTLGpTH+7D2dhTgQcc0sMa/FAG3RbKSn2YoQ2uVb
         npPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=bOqaUaJyqI3z8R7EROs3ckH7IV3vf21Y4AlyOgMQUZo=;
        b=Ixn81gb9iTvr4uAwTbErIC9TzxgpQnWarOCx28xwVqx4Ki8/mKL4Wbc5W+n9veR/tc
         Oz/7WZr0XsPKMg/PAvTUPp6QpcgH35M+zfQzcHVLG6Y1x/wplZBEJkdZT01G0yL7Qo3g
         g6EQy483wGRITZMMrRAs8OtDqnVzrGmg1SVmGn8EnvEqR4gdV58sQU6suqK2A82KQFSU
         0hgjzpI3AHq4gD0vuwreneUlOGyhvyHwRsf4MviFFDayDv1V/pn87yqIbLlOsdUJ51YY
         Xdo51HAQ7JZKKg5tbThozCtefzzYf49ZydIdZloRaL6/2IERcaRgUPxt3XERZMW28hI+
         Tvzw==
X-Gm-Message-State: ACrzQf0JbbRFF7csi5PyXx0tuID4B/wOyjkynC/o13Xa+q+4FzLQzKLd
        2g2D5nOczyJx9VXD/f9EBd8mv70GUak=
X-Google-Smtp-Source: AMsMyM4VxJpTz8og5f4YXhJR9xCeJq1cJtncTXNnCfQzORrxjVwc26sG+xw2a9l7lQFaJD5fQg5XU0fKxPs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:27a0:b0:54b:e645:d5d8 with SMTP id
 bd32-20020a056a0027a000b0054be645d5d8mr20734835pfb.86.1663716727284; Tue, 20
 Sep 2022 16:32:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 20 Sep 2022 23:31:24 +0000
In-Reply-To: <20220920233134.940511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220920233134.940511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920233134.940511-19-seanjc@google.com>
Subject: [PATCH v3 18/28] KVM: x86: Disable APIC logical map if logical ID
 covers multiple MDAs
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

Disable the optimized APIC logical map if a logical ID covers multiple
MDAs, i.e. if a vCPU has multiple bits set in its ID.  In logical mode,
events match if "ID & MDA != 0", i.e. creating an entry for only the
first bit can cause interrupts to be missed.

Note, creating an entry for every bit is also wrong as KVM would generate
IPIs for every matching bit.  It would be possible to teach KVM to play
nice with this edge case, but it is very much an edge case and probably
not used in any real world OS, i.e. it's not worth optimizing.

Fixes: 1e08ec4a130e ("KVM: optimize apic interrupt delivery")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/lapic.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 7a39d7be4cc9..a12360fd4df6 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -338,8 +338,14 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 			continue;
 		}
 
-		if (mask)
-			cluster[ffs(mask) - 1] = apic;
+		if (!mask)
+			continue;
+
+		if (!is_power_of_2(mask)) {
+			new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
+			continue;
+		}
+		cluster[ffs(mask) - 1] = apic;
 	}
 out:
 	old = rcu_dereference_protected(kvm->arch.apic_map,
-- 
2.37.3.968.ga6b4b080e4-goog

