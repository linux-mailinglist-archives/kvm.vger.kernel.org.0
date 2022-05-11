Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E820F5229FC
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 04:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241451AbiEKCrc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 22:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243049AbiEKCjW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 22:39:22 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72EE720EE3B;
        Tue, 10 May 2022 19:39:21 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id gj17-20020a17090b109100b001d8b390f77bso3624254pjb.1;
        Tue, 10 May 2022 19:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=bRhgqqQeID2Oa4GSgEHe0YMx1hgoRaEiDLzYZL7Wrco=;
        b=dWTc3hnaL7bFobYNR47KVtVbyVt/UWPFajuPvhythntamkQkDtwiaCr9F9ko7TMt7Y
         JwG5jsXBAzn2K3BPy036pC3QG0Sbq5zWMxzY+4wdHgPVryDhxL2h1kupE6gr1SCsKvn3
         92BABNA0Z7XPUywm1Er0ahSh2eNIF5Is4MkV3IaQbViOyU+OmMfblHGoLqNtwdRDzZ+Y
         xGRY7jt2WYNJPnQ9QguAym0RsBbnrkfv+SZRmKChINZ75JRUOfAjth5l+mr/wmdg6bsD
         hY7Z2yzocZ4iAQXMHaN2oTEgqIWjdIDqlVb1+hCCjIqBlooc3xRwjiD5Ou0Pf2tL32RC
         2JPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bRhgqqQeID2Oa4GSgEHe0YMx1hgoRaEiDLzYZL7Wrco=;
        b=D2/aFzwhhih7O3vbR6m4QlhCUMXgvGi2td4+FSDwwdTve/pPPTKgfVH7JKrIcKZfVJ
         1PT9tEZJkt+T7y4D/3epiw/xSwwiFDp1bzN9+XWbDR8AZYVBHhevkCz5O0c4sBK9I4Ch
         4ql45FekDa9DN/fUmTnIwb+5WM98/qVunv4UPPeuO5cG0c66l1bBgJiRihh+/6jE6Asy
         3UmkhysoACGzTsJVZ3jElt5lNoktwqe12fgSuOvS5RXgv2T2BdiF0mQ8mdIcNiwrwi5C
         tDAXP5B3vJwOyFA4uEwinpDgVnikZ19MHSs17oZ16uUZ9wPc+Z1ryFQ2dL3ytOB8HD4x
         741w==
X-Gm-Message-State: AOAM532wX4cyhoIIZqz0Z+/2R9+i+7EEeB5e+F0zmDbOeOGSjie/UqtF
        j8RgBepEs6Sgkj9baYiCb8fccaEQAHU=
X-Google-Smtp-Source: ABdhPJwht+g4ut0Qf6przHB6l3Dub4LRPo5gUKloeDs7PbONZoKMVVLfE6zdTLOfgb6bu4gh3tKBeQ==
X-Received: by 2002:a17:90a:a410:b0:1dc:d03b:5623 with SMTP id y16-20020a17090aa41000b001dcd03b5623mr2956835pjp.95.1652236760764;
        Tue, 10 May 2022 19:39:20 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.119])
        by smtp.googlemail.com with ESMTPSA id j64-20020a638b43000000b003c659b92b8fsm425610pge.32.2022.05.10.19.39.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 May 2022 19:39:20 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 1/2] KVM: LAPIC: Disarm LAPIC timer includes pending timer around TSC deadline switch
Date:   Tue, 10 May 2022 19:38:29 -0700
Message-Id: <1652236710-36524-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

The timer is disarmed when switching between TSC deadline and other modes, 
however, the pending timer is still in-flight, so let's accurately set 
everything to a disarmed state, this patch does it by clearing pending
when canceling the timer.

Fixes: 4427593258 (KVM: x86: thoroughly disarm LAPIC timer around TSC deadline switch)
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * clear pending in cancel_apic_timer

 arch/x86/kvm/lapic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 66b0eb0bda94..6268880c8eed 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1548,6 +1548,7 @@ static void cancel_apic_timer(struct kvm_lapic *apic)
 	if (apic->lapic_timer.hv_timer_in_use)
 		cancel_hv_timer(apic);
 	preempt_enable();
+	atomic_set(&apic->lapic_timer.pending, 0);
 }
 
 static void apic_update_lvtt(struct kvm_lapic *apic)
-- 
2.25.1

