Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C018C36D61C
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 13:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238305AbhD1LI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 07:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239648AbhD1LIz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 07:08:55 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED36C061574;
        Wed, 28 Apr 2021 04:08:10 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id c3so24720259pfo.3;
        Wed, 28 Apr 2021 04:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sLpoIH+yhyALQFTgQocCci8bsTG3D7jmg/76ZkWjRcY=;
        b=dpwXpyq3mY3XQ/cbopkDD6jheZvyXHH6oeT2KuE8ukVbHVlj940j0PSiy+9xFf9xsh
         +NNRap1mP+dfKzOY1wZpB+MXHl14qTGu29zkTdUjG/9YHWH28q50wsevtiSHsRjZorkp
         TBidwdOjaxRWuGrrBR2WMAHr/hYZRMm4OVYcfrWZfYnhK6qdSLLniHMS7UoT6f1IU1WC
         EzEFS8iidL21YpS0nUD+WLjHvuXCCQFbUuYtw0PctqOWcZndxuKU604QfncYs5H+ik17
         F0z3l2U+DwwnQKsqNKCYHe1ZCgd2WqzmA04SkOUAYz7xZR5HkaDsfztOhENb2tbqAoGm
         9b8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sLpoIH+yhyALQFTgQocCci8bsTG3D7jmg/76ZkWjRcY=;
        b=J9V1vGPHVbYRmUi+52GFCxgGznh7ZnI/kPaHDwgaL3ARZvrO+aDhDbXUaKMwkFFKN9
         t5L+0gnrhVBwmk1hrWAfJlFuysKQ9tsnE+Pnx6c3rR75oDSTY82TN6251ZfQnBMfUXw6
         0Qbuv64S/kkc8Bn75M5vwWqeRJifFZgrPat7UKjVI8+r0IaX3yMKMUouVwwitlvcBAIJ
         /C95Id1DZ6CbQNF2lrln3xC1NyQgz68KJS8DiDWNcFM3X6L8t4PSy0s722quJT0tnphz
         mY+jsNRc4Rgz8D2CznqU7zN0i1aBbGBv7WmShvt82V9jQ9JDJIfRG0gAg7fkenCN3dnJ
         BweQ==
X-Gm-Message-State: AOAM530TzsiLtGc0L+wXj80u5QErXaoQVj6H4CLel1rVVi0kFAY8mUFs
        aMpLBLnQ0HJHYLjB+oUcQRVZCIuP300=
X-Google-Smtp-Source: ABdhPJzgUYS5opVQrXuZN/v6IrlJrCS4wl7W8ENluYVVshJoupHTYPqxcKawOAAerM7DT8BRVj3gKg==
X-Received: by 2002:a63:d942:: with SMTP id e2mr26479270pgj.117.1619608089738;
        Wed, 28 Apr 2021 04:08:09 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id z17sm4738423pfe.181.2021.04.28.04.08.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Apr 2021 04:08:09 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: LAPIC: Accurately guarantee busy wait for timer to expire when using hv_timer
Date:   Wed, 28 Apr 2021 19:08:02 +0800
Message-Id: <1619608082-4187-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Commit ee66e453db13d (KVM: lapic: Busy wait for timer to expire when 
using hv_timer) tries to set ktime->expired_tscdeadline by checking 
ktime->hv_timer_in_use since lapic timer oneshot/periodic modes which 
are emulated by vmx preemption timer also get advanced, they leverage 
the same vmx preemption timer logic with tsc-deadline mode. However, 
ktime->hv_timer_in_use is cleared before apic_timer_expired() handling, 
let's delay this clearing in preemption-disabled region.

Fixes: ee66e453db13d (KVM: lapic: Busy wait for timer to expire when using hv_timer)
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 152591f..c0ebef5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1913,8 +1913,8 @@ void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu)
 	if (!apic->lapic_timer.hv_timer_in_use)
 		goto out;
 	WARN_ON(rcuwait_active(&vcpu->wait));
-	cancel_hv_timer(apic);
 	apic_timer_expired(apic, false);
+	cancel_hv_timer(apic);
 
 	if (apic_lvtt_period(apic) && apic->lapic_timer.period) {
 		advance_periodic_target_expiration(apic);
-- 
2.7.4

