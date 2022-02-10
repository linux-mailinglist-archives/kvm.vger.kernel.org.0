Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2304B1904
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 00:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345413AbiBJXHU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 18:07:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239716AbiBJXHS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 18:07:18 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5055655BB;
        Thu, 10 Feb 2022 15:07:19 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id p14so7212026qtx.0;
        Thu, 10 Feb 2022 15:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=sS42IV/IyJJJQe1oR3KUsg/jNaiYCRP226dHL2TKSfc=;
        b=eocimBnfXPFWj8+E/eB1AYv5kSg66Mv6qkEhHGxwdqK6+dpi+peRet6nrjcRYlb1tJ
         HLjsHeS4HoimMpuxEg6Q1KFwlnDiLHRIUxX6DAS8BAJyYe1Wb5ZRuGjIJMKR1q4x1tax
         mR0v16h3AqcOHy0zSKKbFeKUUpHpXQKLT1K/LlXJmTYON2jCyhCt2CbAHCunDJet+SQf
         qB3xSxKlgbKAtVXuJt2VZ7Ky2ByxUPWa//VI9ZAvnNBy9epN/zB3cnDTCxQ9bKhG9BuX
         3+3BcwaBmibYIEse7pP1iJqUGgPQy06oSK9nozPDLkXHxtbCOZzb3pzwlcco0UUiQ3qe
         mySw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sS42IV/IyJJJQe1oR3KUsg/jNaiYCRP226dHL2TKSfc=;
        b=lk6t8MLwgU2dFFqPnJwRFF3vFOnCc7KeDA7EdJASpDozZmB0ue7q1Wr7QBzJ8fouGk
         aPfiYoFK/4UF9xm7blwfJIwCLyxVTAKkEPxkcuG50WHLkU3WqSyBSbNOyqCflQklxPas
         s6yFFJC22a/qVrh5yzNk+jDWP40XViZ+igg15GYl1Pbni3ZTUvS9N4qiAat1fF0Q1eE3
         /B4k5Ryq00hCq9me7kLRkQAao2CrHDuUE/PiHBcLHnut8Feq4EG3ew61oKc2WwrMNH2A
         tNhFicd6ayz4vcuzxdzgpvCYlo+Jam0wn+vdMTmFDL6wZn35Nq9kZNRpodxK/jAUO91V
         7ETg==
X-Gm-Message-State: AOAM5316ViZc0B6pYJGF7tq3pfuH8cfqM0uaq/Fes6fe0lvi/i9aSzs3
        jsQXEwjcpsDt49w9oGyzC9A=
X-Google-Smtp-Source: ABdhPJzsKhjH0E928PMWg14kbD+gJ7XaexanfTXEjOjfj8p4ucvwelQVCnWVujQwOdKeD0pnOszvBg==
X-Received: by 2002:ac8:7f82:: with SMTP id z2mr6441488qtj.591.1644534438427;
        Thu, 10 Feb 2022 15:07:18 -0800 (PST)
Received: from localhost ([12.28.44.171])
        by smtp.gmail.com with ESMTPSA id o13sm11924755qtv.36.2022.02.10.15.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 15:07:17 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Joe Perches <joe@perches.com>, Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Nicholas Piggin <npiggin@gmail.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexey Klimov <aklimov@redhat.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 07/49] KVM: x86: replace bitmap_weight with bitmap_empty where appropriate
Date:   Thu, 10 Feb 2022 14:48:51 -0800
Message-Id: <20220210224933.379149-8-yury.norov@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220210224933.379149-1-yury.norov@gmail.com>
References: <20220210224933.379149-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In some places kvm/hyperv.c code calls bitmap_weight() to check if any bit
of a given bitmap is set. It's better to use bitmap_empty() in that case
because bitmap_empty() stops traversing the bitmap as soon as it finds
first set bit, while bitmap_weight() counts all bits unconditionally.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 6e38a7d22e97..06c2a5603123 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -90,7 +90,7 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
 {
 	struct kvm_vcpu *vcpu = hv_synic_to_vcpu(synic);
 	struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
-	int auto_eoi_old, auto_eoi_new;
+	bool auto_eoi_old, auto_eoi_new;
 
 	if (vector < HV_SYNIC_FIRST_VALID_VECTOR)
 		return;
@@ -100,16 +100,16 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
 	else
 		__clear_bit(vector, synic->vec_bitmap);
 
-	auto_eoi_old = bitmap_weight(synic->auto_eoi_bitmap, 256);
+	auto_eoi_old = !bitmap_empty(synic->auto_eoi_bitmap, 256);
 
 	if (synic_has_vector_auto_eoi(synic, vector))
 		__set_bit(vector, synic->auto_eoi_bitmap);
 	else
 		__clear_bit(vector, synic->auto_eoi_bitmap);
 
-	auto_eoi_new = bitmap_weight(synic->auto_eoi_bitmap, 256);
+	auto_eoi_new = !bitmap_empty(synic->auto_eoi_bitmap, 256);
 
-	if (!!auto_eoi_old == !!auto_eoi_new)
+	if (auto_eoi_old == auto_eoi_new)
 		return;
 
 	down_write(&vcpu->kvm->arch.apicv_update_lock);
-- 
2.32.0

