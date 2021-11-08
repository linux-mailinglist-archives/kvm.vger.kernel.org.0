Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F98447FAB
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 13:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239706AbhKHMry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 07:47:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239723AbhKHMrq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 07:47:46 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C7AC06120B;
        Mon,  8 Nov 2021 04:45:01 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id u11so15730210plf.3;
        Mon, 08 Nov 2021 04:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=su/igV5uUfDsLAamJ/jUapW9IEC/znYL2Yl/thFDQYY=;
        b=AwpkEwlCHjvUNJyxjkHCj5gYTo8dZFeOMM4QuKatYtFU+KctX0PYuwKvCyoDdehB1u
         hvkeTCZPkMp5kpArc8EYeOczf4D3vYWVbwdMsln9Ira4tTQAHXA+inHRKTyQsnOKegyu
         U8pUcFkobAS/jS50k5jO73jAn4Zp4xy3+4r0a5dcVGawT4YKSksi4o39hQRlxdKrf6QG
         iVffIR/u0pWg2GW0VOP4J3BJ0Q4LtVy/kcY9cC2oPrXza/8kkb7u4uR4CKrYuv1lgkzf
         U7E1l+Ya03YIsYQxVZtpESzBjEaIgkdfaH+cS9B7U6eW7i2nNds7W8rAmxq0V/9Jdyva
         qHlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=su/igV5uUfDsLAamJ/jUapW9IEC/znYL2Yl/thFDQYY=;
        b=qdthaZ0B8ONOaYuF8AD1Gwtt4WGgocAYso3FYuIMMIf5hOdC0lTIQXYxwmmvO+E8l/
         FJ18wS1rkQx6YsuyapjlxVKdTZFDYF5Ei39v+Itr02T/ZDnpQ91z6tC6+kcRA61MAsUk
         O4jhyyvdzlVH6OI5KSX+gz0ZLDWmqojw9JGY8+BjE425dsr4i8WeQHow8LUFAyjy7ZmQ
         kiDa7blYl9Wslv9t4CLZx8nn5tmQOsZY5/9pg1tTAfSliiaLBkQgD4/0j0BmAjj/xnzJ
         nBrcXORBhGGDwVWAt+/LGrnX+8Xar/Rzir9UNREvmrjYlmCViy7k3dxaMlGkREBK4Bua
         GNtA==
X-Gm-Message-State: AOAM532qy5/fYgpq8ptA3F1Qe8ibmlgkg8c3jjerYo86961wC18rdQ6X
        xkbbFxuJnINd1R0HtJQXUgwaiYdi51w=
X-Google-Smtp-Source: ABdhPJwEJrGtdd7MwUO8/jqF7X5w5JTleM1Efb6C5Vx1BOVCVCTJ9SqKeQvLkOyofFoKZyVX72fMxw==
X-Received: by 2002:a17:90a:ce02:: with SMTP id f2mr51648501pju.77.1636375500683;
        Mon, 08 Nov 2021 04:45:00 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id g16sm16383815pfj.5.2021.11.08.04.44.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Nov 2021 04:45:00 -0800 (PST)
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
Subject: [PATCH 09/15] KVM: SVM: Remove the unneeded code to mark available for CR3
Date:   Mon,  8 Nov 2021 20:44:01 +0800
Message-Id: <20211108124407.12187-10-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211108124407.12187-1-jiangshanlai@gmail.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

VCPU_EXREG_CR3 is never cleared from vcpu->arch.regs_avail in SVM so
marking available for CR3 is mere an NOP, just remove it.

And it is not required to mark it dirty since VCPU_EXREG_CR3 is neither
never cleared from vcpu->arch.regs_dirty and SVM doesn't use the dirty
information of VCPU_EXREG_CR3.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/svm/nested.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 13a58722e097..2d88ff584d61 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -444,7 +444,6 @@ static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 		kvm_mmu_new_pgd(vcpu, cr3);
 
 	vcpu->arch.cr3 = cr3;
-	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
 
 	/* Re-initialize the MMU, e.g. to pick up CR4 MMU role changes. */
 	kvm_init_mmu(vcpu);
-- 
2.19.1.6.gb485710b

