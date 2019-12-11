Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E83311BE85
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 21:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfLKUtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 15:49:45 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:44874 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727319AbfLKUtB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 15:49:01 -0500
Received: by mail-pl1-f201.google.com with SMTP id h8so42287plr.11
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 12:49:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nhUvad64y2J5+k80ysZ9zgdkeo4zQNXWR3pwGYhF48c=;
        b=acHQQrZrnlr62CvNe5hxg9AohvcCZSjyCDFZ3Hf5zH8EGMQDG6TujUFqKegZobyqaJ
         7sI/4zwUeQFvB+2u50CjyMrj/ifLgYYvLIf99oOMmrewQwIkGelULqk7ofqEgb/3JkTo
         Az8Fm/HnT5CtdvcYvSQXcEQLAlpUY8cI/5x8Vgk3WBdNado0bfxlVBd2l9+5JhFCB0Dp
         TlC2DKTS+DnW0a3B1QDsKKGIEC9sGa6z8g/KKaY3L99Z4jKH3+pbSmWlYVSYD1ADltT+
         4IeQVJL031mY56W+XjhxwAsmN3ZSrFPcVmQi3F0vwX5oQZBsY2eHl9PM9RmLxQDKlzW/
         2mXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nhUvad64y2J5+k80ysZ9zgdkeo4zQNXWR3pwGYhF48c=;
        b=VQuHuaD/lQrp+anx5Q4PzzLZ0ltjwvsKLDRJwAVm9HRF8+KsmVwPDiu826F98oXk4J
         gL59D0Hd/WI60hsgzjrRoJcZZ9MP4aLA01sq2KrB0kSwwyehxjZD3/WVAeJcGFKI8y4M
         ZRfLE5Wl619Gd8mqwn9cGO95WZiaGEVv/fehF3jK9tyqn6Lk2lX+ZV2MLOUrSuFVE6x1
         GGn2FqawBdjGiAGlMTLYU4FW6VATEPgAILBY5+8PovEivZwC6oxJblaJlTvKoCOmXUa7
         gn2IJWyBf5SSbELWUKspwh7w1aFpyxNu8oyaz2AAiJhoUDb2MaZ9dNoM5ChO8Hb9b1mk
         42+g==
X-Gm-Message-State: APjAAAUS/RKjPaJDBgp8/TjqvCfJIwUcr7m+hiClZ6dTUt8OIE2co17H
        g3fLWTquJfB62E1RJU2FpJgKpLKFYV/D
X-Google-Smtp-Source: APXvYqzMbqg2ZAo3mpcOI/CliiFPYJvF/vXz4zNY+Ru1eO8xRLB0Z0l/Wn9cCmNlY1KiEQ3HCVcbYKqOZLU6
X-Received: by 2002:a63:9d07:: with SMTP id i7mr6629501pgd.344.1576097340640;
 Wed, 11 Dec 2019 12:49:00 -0800 (PST)
Date:   Wed, 11 Dec 2019 12:47:49 -0800
In-Reply-To: <20191211204753.242298-1-pomonis@google.com>
Message-Id: <20191211204753.242298-10-pomonis@google.com>
Mime-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com>
X-Mailer: git-send-email 2.24.0.525.g8f36a354ae-goog
Subject: [PATCH v2 09/13] KVM: x86: Protect MSR-based index computations from
 Spectre-v1/L1TF attacks in x86.c
From:   Marios Pomonis <pomonis@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nick Finco <nifi@google.com>, Andrew Honig <ahonig@google.com>,
        Marios Pomonis <pomonis@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This fixes a Spectre-v1/L1TF vulnerability in set_msr_mce() and
get_msr_mce().
Both functions contain index computations based on the
(attacker-controlled) MSR number.

Fixes: commit 890ca9aefa78 ("KVM: Add MCE support")

Signed-off-by: Nick Finco <nifi@google.com>
Signed-off-by: Marios Pomonis <pomonis@google.com>
Reviewed-by: Andrew Honig <ahonig@google.com>
Cc: stable@vger.kernel.org
---
 arch/x86/kvm/x86.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a256e09f321a..a9e66f09422e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2496,7 +2496,10 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	default:
 		if (msr >= MSR_IA32_MC0_CTL &&
 		    msr < MSR_IA32_MCx_CTL(bank_num)) {
-			u32 offset = msr - MSR_IA32_MC0_CTL;
+			u32 offset = array_index_nospec(
+				msr - MSR_IA32_MC0_CTL,
+				MSR_IA32_MCx_CTL(bank_num) - MSR_IA32_MC0_CTL);
+
 			/* only 0 or all 1s can be written to IA32_MCi_CTL
 			 * some Linux kernels though clear bit 10 in bank 4 to
 			 * workaround a BIOS/GART TBL issue on AMD K8s, ignore
@@ -2937,7 +2940,10 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 	default:
 		if (msr >= MSR_IA32_MC0_CTL &&
 		    msr < MSR_IA32_MCx_CTL(bank_num)) {
-			u32 offset = msr - MSR_IA32_MC0_CTL;
+			u32 offset = array_index_nospec(
+				msr - MSR_IA32_MC0_CTL,
+				MSR_IA32_MCx_CTL(bank_num) - MSR_IA32_MC0_CTL);
+
 			data = vcpu->arch.mce_banks[offset];
 			break;
 		}
-- 
2.24.0.525.g8f36a354ae-goog

