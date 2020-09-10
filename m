Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33A12642D9
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 11:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730486AbgIJJvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 05:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729781AbgIJJvE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 05:51:04 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A868C061573;
        Thu, 10 Sep 2020 02:51:04 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 34so3935863pgo.13;
        Thu, 10 Sep 2020 02:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cdLm++xYkcDurXtOuboxDgxpAJcdgeOErpU/g8ChEs0=;
        b=YMfqaa8x3VnmAW238O4aMYbWh8YpJvMiNexqZYyhRbQfHPkg05ZBKLaD5SMzm6EF3b
         RZV8uJMMz6SvQ8anjIMo3AcFo8Ngd+Y1ObHkrdzz9aBivexABBpCWABoUwn8SiwOzug2
         jRbyqwM6e/r2S1dFECbpseje/9r4I89d7me4hNIbTUxqgCeLeCOzM9kQLdcKhJDGgLcQ
         F2vUqSQqJIfF0VQ/3X3AwJz4QZwR24izr+rwNKTLEIWV0TORwYBGPOdBQPkY891vAvNg
         6BemgllzAGTdycAALowGnWJIFeGuKqIihs2Q50n2A/0W74emODcM/ME8ZXkfo1Ivqwhj
         AfDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cdLm++xYkcDurXtOuboxDgxpAJcdgeOErpU/g8ChEs0=;
        b=I0zo5PjAJVuM1I8+PHdeLV4rceqdEiIWjzcYdshSHlCoPcjAmoxzTWUK/daRbwieQR
         kEge//iuy+fzmGVwAymyDwkgbg+IDQwambVbIdZbadqG0Ar2Suof2k9Ref7ww4RSC+4Y
         6M5TgK4IllR/ayuqAFIwtGanQoV2/3WeAIfRVdmKCiWQCaeGFCsvTvdWfFWqurkOzdfz
         +Z8bPXIF8roOdI5H3RjW/OdDArSASm/utKBU/M4dxk5xPrTHqt5aSQrS3ImIyl4gEwSs
         G+3mbJql4Z2ht7e1uU5V+LCCPhGQbdjhlrh6mIKvoX37e6GZhIJ1ZlfoifxEzsF8xgUC
         iaBQ==
X-Gm-Message-State: AOAM530oD9tW1ZcJ8DoRTh3Sbqt11Y4vMNOxrbmLesn/1fSsvcAmvpAS
        ZKXK5zWZiXhqWvfKCChoRV9kveEPXTg=
X-Google-Smtp-Source: ABdhPJxOb7Bzcz7WquKtLWovKvX25s8F05+NUPa+yNzWmnHRS8zIOvHL10P8R3RK3KCDcdhoXOwFZQ==
X-Received: by 2002:a63:1d5a:: with SMTP id d26mr3735967pgm.432.1599731460205;
        Thu, 10 Sep 2020 02:51:00 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id e1sm2576534pfl.162.2020.09.10.02.50.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 02:50:59 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 1/9] KVM: LAPIC: Return 0 when getting the tscdeadline timer if the lapic is hw disabled
Date:   Thu, 10 Sep 2020 17:50:36 +0800
Message-Id: <1599731444-3525-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599731444-3525-1-git-send-email-wanpengli@tencent.com>
References: <1599731444-3525-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Return 0 when getting the tscdeadline timer if the lapic is hw disabled.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 35cca2e..81bf6a8 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2183,8 +2183,7 @@ u64 kvm_get_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	if (!lapic_in_kernel(vcpu) ||
-		!apic_lvtt_tscdeadline(apic))
+	if (!kvm_apic_present(vcpu) || !apic_lvtt_tscdeadline(apic))
 		return 0;
 
 	return apic->lapic_timer.tscdeadline;
-- 
2.7.4

