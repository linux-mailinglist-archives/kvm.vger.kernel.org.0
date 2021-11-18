Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE44D4559D6
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 12:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343996AbhKRLQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 06:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343818AbhKRLOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 06:14:35 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C58C061570;
        Thu, 18 Nov 2021 03:09:21 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso7928670pji.0;
        Thu, 18 Nov 2021 03:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7j1qk06E4vJqUJB6P4Ib9H/n91LJYpqZ3QPhrcbNoYM=;
        b=M8pHr3B+jGgySyah1q9QEBMTdDeusbVkuhrRgxvH6/K7BZROJOQSJEKlpEcU/zwfRl
         M1WlgHDEOaq4LjN17TfkwD9OFE5Wn/aeZf4cKc+lvz5sOmmzkRoZDUz4Nl5vZA7G8r6m
         LypS8TmgK3zXh8dGUdO7BGKtBxIzf48BxAiCtgHlDmXxEPYwn3IA45ykj3ulgoVunwHs
         lpMI4lXzHqjk0ZAz3UrPkB+nvJRLjK8ZwHqj9LQ+oI4Lw/GigaBk4HlyCU9X6QNZx803
         33OaPwbSQfaOxE9cJxjK4HdndkEcku4FivnUat+1lx9rj2ld1QW4A+MU7H9wUth5QPp2
         VsXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7j1qk06E4vJqUJB6P4Ib9H/n91LJYpqZ3QPhrcbNoYM=;
        b=t3Dc/01r7SeZtEfsvfgFp2IKjV3y0uWnguEJgPs2XjKHkDy117cVyElKjsRw7DvYGW
         dkZzI8hPZ+cZaC5XRC1JIgi7YTcM3YESrv73oRrExQ1YwOulxoIO1qxRPo3BMeObkEsZ
         pnxw/+mLqjTrlEx6a2fDkWfWPvo2yQqO5cjNiX46Wt/srOsqo2UbUVXw1a/EbzalEUXw
         Oy3zk6E3oK1jWwFiWw5vxrvecjYhCFnd6pl1s+q8tfevsYkQWwxhhsvMixGroPwqKY5t
         Dao6PFNmScnIphWCy1IDkbLh9UAZ++PZtF+MrtcIJeSA0nkgJmVp+igZCV+K/yNlfDQ5
         ak2A==
X-Gm-Message-State: AOAM530k6y1RjIHd8iewHGP57mDiYi0KTUzcf9kKD9aBqnH0UGnNcsx/
        mmuNTpUlOyBObXRcgYEo9y0j+VpYwsk=
X-Google-Smtp-Source: ABdhPJzrRBu2XpyJm19NI7CAKXh1hPSgnwyS2X6PZXWPwQrfuqv5X6KlzG5+30y8l3nmm6uTWrA6mA==
X-Received: by 2002:a17:90b:4f4d:: with SMTP id pj13mr9706510pjb.4.1637233761239;
        Thu, 18 Nov 2021 03:09:21 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id k14sm2948863pff.6.2021.11.18.03.09.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Nov 2021 03:09:20 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 13/15] KVM: X86: Remove useless code to set role.gpte_is_8_bytes when role.direct
Date:   Thu, 18 Nov 2021 19:08:12 +0800
Message-Id: <20211118110814.2568-14-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211118110814.2568-1-jiangshanlai@gmail.com>
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

role.gpte_is_8_bytes is unused when role.direct, so this code is
useless so far.

And role.gpte_is_8_bytes is going to be used for indicating if gpte is 4
bytes even when role.direct is true when shadowpaging, so this code
has to be removed for preparation.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 64599fa333c4..db8b64971f25 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2082,8 +2082,6 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	role = vcpu->arch.mmu->mmu_role.base;
 	role.level = level;
 	role.direct = direct;
-	if (role.direct)
-		role.gpte_is_8_bytes = true;
 	role.access = access;
 	if (!direct_mmu && vcpu->arch.mmu->root_level <= PT32_ROOT_LEVEL) {
 		quadrant = gaddr >> (PAGE_SHIFT + (PT64_PT_BITS * level));
-- 
2.19.1.6.gb485710b

