Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD88D44D883
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 15:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbhKKOsN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 09:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbhKKOsM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 09:48:12 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EBEC061766;
        Thu, 11 Nov 2021 06:45:23 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so4776691pjc.4;
        Thu, 11 Nov 2021 06:45:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Dn20pTIFu4HHwXs9x/rHm6WXV5R7u62HLta5pjb6tC0=;
        b=ANTb3xKSQAjwywKq8UHZQzAS5iqonIlBAAexPyNnUwbY8KA/pmekqLy3qy2gIBffKl
         pbe+K8S7xbSkFL7KorIdut2gR52/t3Xfs81h8vHqYTGjPuMCIMWFtaR3DHskymrVUq8m
         MOUne3SkkJGChx6GODQZkkKzqfo+8/zd4CXfcY3MY/qhCFFHhswmO2l0WBHJiUbEE6TC
         gERDvQ5V243OIAIwL/WGksbBHjacWO+9tW1Iaa0d4filtz+ipqd9FcdLPzGb7tvg6eKo
         205DNx+vN1fWi5ImltXrUEnWAGobtSHzyN+TR+Pov/nJXNoOFbgvVpwKX6z3JcixKxDo
         ce/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dn20pTIFu4HHwXs9x/rHm6WXV5R7u62HLta5pjb6tC0=;
        b=3yygbe7JGBpXXRJdxKQ06Ypq4aAvpNfH44f2pYzPm2hx41u6BgcCu+tLo80VcRhFkA
         uGIEmrRjQUMIHup77cT4zm/UY8di96OsZBKSrAN05Neb8ZkKBHww/Up8mYsVlty49vF5
         ljOU8NuoPwrMeOg0WKiuZGDeTyd06I/yaOMR1xiAXu97KCV1s/CtJa9WwJ9Ym7ExLq6q
         Nq2CYN7caQx0WdqalNVZG7N9C57MR1qV2AJelHaQX9Rilmoyiect054HwnbDug6UE/Hr
         pT0CDRPNQuhHV9Vz7BKGe6+ff48Jav++ybW91YYukB0jRdJ9vPAfHLIoCqM37XMT5gEO
         CQUA==
X-Gm-Message-State: AOAM530Q+5+4RC3XbkU510/BhFajQ6E6+3CAWpM0V+cGBWVKwngYJqlI
        BEb+mUNlg8lILSv+tIoHGInyIg5yIww=
X-Google-Smtp-Source: ABdhPJwuU77mjaqDv9EnZe9RcQ379DtJYH3n1Dzslu6+/oS8afhvwexoiOXJXgsPzxWgD6WikuOwNA==
X-Received: by 2002:a17:902:7fc5:b0:143:6d84:88eb with SMTP id t5-20020a1709027fc500b001436d8488ebmr8191238plb.61.1636641922348;
        Thu, 11 Nov 2021 06:45:22 -0800 (PST)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id ns21sm8329927pjb.37.2021.11.11.06.45.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Nov 2021 06:45:22 -0800 (PST)
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
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 16/15] KVM: X86: Update mmu->pdptrs only when it is changed
Date:   Thu, 11 Nov 2021 22:45:26 +0800
Message-Id: <20211111144527.88852-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211108124407.12187-1-jiangshanlai@gmail.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

It is unchanged in most cases.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/x86.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6ca19cac4aff..0176eaa86a35 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -828,10 +828,13 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
 		}
 	}
 
-	memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
-	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
-	/* Ensure the dirty PDPTEs to be loaded. */
-	kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
+	kvm_register_mark_available(vcpu, VCPU_EXREG_PDPTR);
+	if (memcmp(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs))) {
+		memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
+		kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
+		/* Ensure the dirty PDPTEs to be loaded. */
+		kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
+	}
 	vcpu->arch.pdptrs_from_userspace = false;
 
 	return 1;
-- 
2.19.1.6.gb485710b

