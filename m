Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFA632C9C2
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbhCDBL7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 20:11:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1451777AbhCDAiF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 19:38:05 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B377CC0613E6;
        Wed,  3 Mar 2021 16:35:32 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id j12so17525402pfj.12;
        Wed, 03 Mar 2021 16:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=NzpsCCGXP4ItyQsT4XoNqFxXYXsUAk2E6LWEAjyLuuo=;
        b=tXZgkVEN2lrE004AVMareVAbW5CSpAXGQHu4TYul0hUvEIt3U77pNG1Y3h2bMU2scU
         dHy75x5mdr30iW5JFblz0qIPTdqqvDYSoakbHvxmQAJbO6sTvwoFuktUGTAyHGqRa9kh
         ekBnqEWsPRIl+wbQCGa8ssHhpoyr9ryrhCDfMLoMwsRmd17+P+owjb0q5D+YpDf1ZUmF
         N6Im/b+xicod/UGSxvCoaTOnNsDyJ2A3SA4+hK/LIaZ+2d1+o3aoB2kwURaO0DnXXOum
         HDQ9LyaxEU3F2PNrs818HgChWT3JjV2mxYpkJ2ZpP6x51CQdOBnLY/bWH+O4j8qxVA2Z
         g7bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NzpsCCGXP4ItyQsT4XoNqFxXYXsUAk2E6LWEAjyLuuo=;
        b=a62baNkijeWU/3XywiGQU6l+Jh/tqEtrEmXaWBq9n5NTINMqiXHwN1kK7VLJ3VM7Sm
         dNGJPLhhfxrDLjpCZ3TzJ/SZkjpUfWeN/tlDMS+BxBVgS1geFl6fVJL0flhncodB9Jpa
         EpamShn0dAD+25OegysVw6/yDUwpp4HWsbEesFZHVxxJQYwkRgnptK4V05DtkV08TgA/
         aobe2846CQhCtmdOaqsE3bX+9oPleK3UrCoROyTTpA5567VxIaOpTSO+nX+onO8KBlct
         Z5mIduClHFI1ek1iqqGfH/V61ENAuiCQ3hkqawQQvXBkknl86d/Q618Fn/H7sYWoHh4P
         vVBA==
X-Gm-Message-State: AOAM532KTsWRvdMH1Zgz81t67Aa7mK442fmHg3k4HmVLPaCb3RPQBF4g
        GJqwGZpO8WazZZRLOAoW5uGgPnKttfk=
X-Google-Smtp-Source: ABdhPJzrDCJsduLA3BLhJ/QQO6D0co84IVwpPVmwEn29+QHuww5vNQPL75DG4pm1u+B1hQG6ngiLqw==
X-Received: by 2002:aa7:83cf:0:b029:1ee:f550:7d48 with SMTP id j15-20020aa783cf0000b02901eef5507d48mr1342108pfn.12.1614818132055;
        Wed, 03 Mar 2021 16:35:32 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id e185sm26316479pfe.117.2021.03.03.16.35.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Mar 2021 16:35:31 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2] KVM: LAPIC: Advancing the timer expiration on guest initiated write
Date:   Thu,  4 Mar 2021 08:35:18 +0800
Message-Id: <1614818118-965-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Advancing the timer expiration should only be necessary on guest initiated 
writes. When we cancel the timer and clear .pending during state restore, 
clear expired_tscdeadline as well.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * update patch description

 arch/x86/kvm/lapic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 45d40bf..f2b6e79 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2595,6 +2595,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 
 	apic_update_ppr(apic);
 	hrtimer_cancel(&apic->lapic_timer.timer);
+	apic->lapic_timer.expired_tscdeadline = 0;
 	apic_update_lvtt(apic);
 	apic_manage_nmi_watchdog(apic, kvm_lapic_get_reg(apic, APIC_LVT0));
 	update_divide_count(apic);
-- 
2.7.4

