Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDB1447F9D
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 13:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239622AbhKHMrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 07:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239606AbhKHMrE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 07:47:04 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24936C061570;
        Mon,  8 Nov 2021 04:44:20 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id g184so15050983pgc.6;
        Mon, 08 Nov 2021 04:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AWnQnZTcd6KUjYhg83N5anaGWnmVBccSmNsieVINo74=;
        b=l+rRI9cFGm9PUxjnxTpddwYEhrSqXixq6evuxem9IcribVyDgmEESyHEppavveYwHG
         qV/EJSUuC9j+Jc97LSCdT0b8goqUjUwbYoRO1GaIQ4JOELmyadomu8jKqnk48kXCRqzU
         IIxpN9AGHAsmIZmnYlY9SaBVx1KiW/jAAw40ncRX2GMOwfWFZQ6YP5EDKzXaZpSJQJrc
         7X17TPwegOpFAooos1VuxO/hqHzNxdNPmLP0HKjnUfkxSvdDU//D4l+yq1TLnAaK3V1Z
         ZnZQcMXaYcQxuUlxTb/V0WlMeooyAMfHXPoMVfgFcBaY3eyyAx6lN61p+7Dd6ppqBwSo
         Z7wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AWnQnZTcd6KUjYhg83N5anaGWnmVBccSmNsieVINo74=;
        b=BmImN0/4b8+BTfeem8pf9LvyF8w8k4Ikr+oW9UuvCTj9ZEOYE3ixUfIlIbZ9lVkzon
         0fkv1rdPhKiq8b3Sct9qr1RHTnSidvMz80lBnrlTKBRTKq+s6JUq2pMfChnHcgBgBGo2
         N68R+/Su0CqEod2jW9HiYeu2h4+28Bm/kMqpY1UNqM6A6N7GDoUF8bxMN7PWaQpjmXiA
         HqMaFQ6G1pKeh1psXlCTpnLrXnLy/xjtsc5pGbBKCuGSG9z2MiWHGyATTCwukF3XKs68
         GBs1NIfMbijTs9HNo4CeVzfw0I8IXVngs1bh3TC/3IicE/3Ym1C7vixKDtFvHvXR7cQD
         j2xA==
X-Gm-Message-State: AOAM530TIKB16/dNfoq01sERHQKLpuqENAYKHS0Pb0gSfxKn0yiHihJs
        VAGdGhdx15CarB5sb4Fc2c+E+6lEGvY=
X-Google-Smtp-Source: ABdhPJy486BVET8NcxrEGHISk5duKnZbe0kDNeK/ZvleavDOCHXCrIxBIxuL/N9EVTjikteRIOgPsA==
X-Received: by 2002:a05:6a00:140c:b0:44b:e251:fe13 with SMTP id l12-20020a056a00140c00b0044be251fe13mr81521000pfu.10.1636375459387;
        Mon, 08 Nov 2021 04:44:19 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id hk18sm11764497pjb.20.2021.11.08.04.44.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Nov 2021 04:44:19 -0800 (PST)
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
Subject: [PATCH 02/15] KVM: VMX: Mark VCPU_EXREG_PDPTR available in ept_save_pdptrs()
Date:   Mon,  8 Nov 2021 20:43:54 +0800
Message-Id: <20211108124407.12187-3-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211108124407.12187-1-jiangshanlai@gmail.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

mmu->pdptrs[] and vmcs.GUEST_PDPTR[0-3] are synced, so mmu->pdptrs is
available and GUEST_PDPTR[0-3] is not dirty.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 39db4f56bffd..79e5df5fbb32 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3001,7 +3001,7 @@ void ept_save_pdptrs(struct kvm_vcpu *vcpu)
 	mmu->pdptrs[2] = vmcs_read64(GUEST_PDPTR2);
 	mmu->pdptrs[3] = vmcs_read64(GUEST_PDPTR3);
 
-	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
+	kvm_register_mark_available(vcpu, VCPU_EXREG_PDPTR);
 }
 
 #define CR3_EXITING_BITS (CPU_BASED_CR3_LOAD_EXITING | \
-- 
2.19.1.6.gb485710b

