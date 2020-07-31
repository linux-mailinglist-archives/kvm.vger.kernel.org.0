Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA05233D97
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 05:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731289AbgGaDMn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 23:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730820AbgGaDMk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 23:12:40 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65815C061574;
        Thu, 30 Jul 2020 20:12:40 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id e4so2781968pjd.0;
        Thu, 30 Jul 2020 20:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=n4jnMGbCRukfnq6mAWC7DIZwbVNmNRQBNC6Djiv/OMc=;
        b=FZ95jRAv43lUFjjKKZ5yU+PvIm34UyEsXv4FM5BpQp9BL7l/z5eVisL0lUqtQeqWl9
         GSFRF8lyuYD9evBme/Aho9gzt8cBU9EAJWJHErT0/o25GsuyTuYPzffbINcuV7FX4bdv
         vZGU1BtlWPk5cIqLSRsOE0bm1rDLAdtaxgrG04xMoQDSM+l+iFsxfTxuAK5oDvLclr0j
         6TygTREXdX5ZA1ckniL5mrjqcu+i8KovpttI2SjLbXf65PMCouuzzRQfymnqeLrwkLJo
         r025XcbOaBcSIX6ESx1wu3v9YidelyeQ+qrii+QS4qd0HwVsaBo5Lryv0L9hEr2VmqE1
         4LwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=n4jnMGbCRukfnq6mAWC7DIZwbVNmNRQBNC6Djiv/OMc=;
        b=Vui8wFJO/GW0R+oAYB1s3eHeC5MNbHDORtb2YcnLfcpbE13qHu8MjUGp2GpOnhDcMm
         7KW/EEPFRMMSMGEU9KwE+XodYK5XQa9Str+Bk+hOKfivWKzw4FnnpjE16TIVax1fJD8N
         al0rgN8ZWpsCOB70u0vFr33KWukzu8NAZg6icYtNGwu6efa16w5OYiYEB8m2FkGfqxzZ
         6ejuhpHo1DU3U4RkWQfNMAfPn5TnRdIulrbjU7FhkD74yhC2YpU1cIuTO+SEUOaOfUqC
         mH7SNgzwIGKOEcYLNvehR2Seh5x7vYEUwfQ0nzqvGfH9bnglQqwlrAB+MQL24BmjwQbq
         YJhA==
X-Gm-Message-State: AOAM532ZjMqBQxPKRsZYJyT8PIfseQzWgJWD/VCpd9YZnYUlcGlGda0m
        n/oh7AwVrloDonmBzP/Z6KsocmFc
X-Google-Smtp-Source: ABdhPJxBvOVyMFOZYiBnF5HqG3dQBBvFhUR/0+KGOEIZhFCN14A/LLvDtXKz8ET0a83yS9gXdcMclw==
X-Received: by 2002:a63:6fc7:: with SMTP id k190mr1782013pgc.54.1596165159782;
        Thu, 30 Jul 2020 20:12:39 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id t19sm8221961pfq.179.2020.07.30.20.12.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jul 2020 20:12:39 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v3 2/3] KVM: LAPIC: Set the TDCR settable bits
Date:   Fri, 31 Jul 2020 11:12:20 +0800
Message-Id: <1596165141-28874-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1596165141-28874-1-git-send-email-wanpengli@tencent.com>
References: <1596165141-28874-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

It is a little different between Intel and AMD, Intel's bit 2
is 0 and AMD is reserved. On bare-metal, Intel will refuse to set
APIC_TDCR once bits except 0, 1, 3 are setting, however, AMD will
accept bits 0, 1, 3 and ignore other bits setting as patch does.
Before the patch, we can get back anything what we set to the
APIC_TDCR, this patch improves it.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * update patch description

 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 4ce2ddd..8f7a14d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2068,7 +2068,7 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 	case APIC_TDCR: {
 		uint32_t old_divisor = apic->divide_count;
 
-		kvm_lapic_set_reg(apic, APIC_TDCR, val);
+		kvm_lapic_set_reg(apic, APIC_TDCR, val & 0xb);
 		update_divide_count(apic);
 		if (apic->divide_count != old_divisor &&
 				apic->lapic_timer.period) {
-- 
2.7.4

