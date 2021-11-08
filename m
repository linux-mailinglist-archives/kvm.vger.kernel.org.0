Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642D4447FB5
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 13:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239781AbhKHMse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 07:48:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239799AbhKHMsS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 07:48:18 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6482BC06122A;
        Mon,  8 Nov 2021 04:45:30 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id g28so6396913pgg.3;
        Mon, 08 Nov 2021 04:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T8hpLUlYpKoolycknjDctgk2NLH51FU7az3iu++Ol2c=;
        b=opwHVayWIMLEZh2njFuTc1B6vQWxBv5AWm068Jk9QebU6DuhSPrt0JM8dixguMk6Ee
         c/HFPgNI8sMxaSOKu9gD2yLxmjBr3g0u2EhENHvv1tLVQR7TY7ybvGAeeeRY1X0bK2TZ
         duIjILbMtd+9JvwBcDXIK4v5PhEjMPhdSbMN3Lj4XSv8WsOzyt7HnGYlA84av6WkFWKs
         P0t+zpTkRTs0/9896NTJ+FRyOAnZeAJf+GXYR9xOJDe1EoZxKH5w6trl7hLM+Wd/3jCe
         cbnx5maqxI1qyRFvhvNbbHi1e9QP2IXg1cKIZeZRtgf9LzacNW8o9CrIS89s4iwaZujl
         NKzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T8hpLUlYpKoolycknjDctgk2NLH51FU7az3iu++Ol2c=;
        b=QQ5FJ++EidgklcOiW1jey9w1Z23CDZw9Fm1XXOeMa8HcfxUS+Sh5QALRI091SivTKW
         cQvhdzwEotWqfZfbTQbOgSiEnXEb/+YNMfmYlmPq5VHThVdDcJK3EY7c2oAaHQ7iX9GF
         v/KuvFF2o/U2OsRP2dvqAek0YvBN60Qk2lJ9yhz+IM9BgNS3zWTTcPgcjSjqPOgO6dHt
         SrywiSeUEpH8QHLnkP9kIVjmi7OddI+daQJNn3XMP1t+88BaFp+5x1QsTUsTE6/nUXTR
         z78KRp+u6bPrEo7axrmFF6xODF6J9eZXShaU4JIsBTLuopVlJKbQsA9GHGWlA8RcWMMy
         0zOA==
X-Gm-Message-State: AOAM533QlwzHS4fCFHa0NsOjSDl6phIPeW2YOZOXpOiFivcqpvpUsR3l
        xEaVI4zKlIlVK5wdTfKRiq91zy/VTLQ=
X-Google-Smtp-Source: ABdhPJwj/V9g53yD5iuSNQkjP9LLhkRiLwwybwqUa7yRLuboP1PQkLi6OMqhEJYQZARZtD+WIxYq7Q==
X-Received: by 2002:a05:6a00:1741:b0:49f:99e6:1d1d with SMTP id j1-20020a056a00174100b0049f99e61d1dmr27440579pfc.34.1636375529742;
        Mon, 08 Nov 2021 04:45:29 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id h22sm4457675pgh.80.2021.11.08.04.45.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Nov 2021 04:45:29 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 14/15] KVM: X86: Remove kvm_register_clear_available()
Date:   Mon,  8 Nov 2021 20:44:06 +0800
Message-Id: <20211108124407.12187-15-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211108124407.12187-1-jiangshanlai@gmail.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

It has no user.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/kvm_cache_regs.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 54a996adb18d..0f8847b981e5 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -61,13 +61,6 @@ static inline void kvm_register_mark_available(struct kvm_vcpu *vcpu,
 	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
 }
 
-static inline void kvm_register_clear_available(struct kvm_vcpu *vcpu,
-					       enum kvm_reg reg)
-{
-	__clear_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
-	__clear_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
-}
-
 static inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
 					   enum kvm_reg reg)
 {
-- 
2.19.1.6.gb485710b

