Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4877F447FAF
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 13:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238412AbhKHMsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 07:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239728AbhKHMr4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 07:47:56 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA390C061746;
        Mon,  8 Nov 2021 04:45:12 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id m14so15870604pfc.9;
        Mon, 08 Nov 2021 04:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=453AXFvM7ls/vHkcEqDha9O8TvC50FNFpYyfW5EvhIs=;
        b=NbGzmf+mbIipAHgHj2T8JRa9A2PbUU0NAn5LQvviB078PItSyUmE5SijqcqplGA3XS
         alAT1wxn8EqferEnrXUoOHDQdYvPT7dQyh8b1dvkTQb8yPa+GGt2RdbtfAt36SFvWa/s
         FZbH8V6n1FrGIU4zgw94Pj08trtree/1ZleRFgiSuhdQV21mN2Q6QHdw2/9TRRgixiSB
         8LwiO/C+IrLCuUWen6S1b1MYXp7rWIg0LC9aa+knSY/GDNMk9AIgNN6aw9Yqu2XGMFY/
         JTGDI+54nxbaDMBid11Fu/D2Ta4eaVbFpTRzWGxZLNOxRk4NjKT6rb5YwatyNCBt1wz6
         DGCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=453AXFvM7ls/vHkcEqDha9O8TvC50FNFpYyfW5EvhIs=;
        b=OyrdR3jgwhWLEUuqFamfa41QuiUo5rdrck5y5GBBF+S3TkzF8uRzMgMO3AP2/161rF
         ebrMsrbH84szDav4QMIWGnvd3RmOTDvx3RopJ9oJfE79irPay2LNUqNjhou80NTx7mh2
         73ku7qRN8uz0oG9ntIgCow0oeANuQUYlsc9+IGGCvjXCzhI2YukOjMFEexsOHDNN7Ave
         Y150UGnNNsEMPk7S1YcEK5HOTuGhXedlDKwPnk9YvqZ0f5kfGG6AZLRfCnbdb+a5oXCc
         10kxnQD1JUyx0EH4efw3EAVOi14fpXPXxdSL94FrlKNJ1Sp2BLg2gVuF2DTI6YEUZiFR
         34qg==
X-Gm-Message-State: AOAM532ioWW8Q3BJDPhjng77oD3LTCgdqGna/YLzdgSkBQcD1ndhy1fL
        JP6Xw/r9Qubi31H9YrbhAj7jhK5ziuc=
X-Google-Smtp-Source: ABdhPJyc4vIsxwlCNzoB79MjjatwWka2mvuy2+/SXLBTZv1nW4SvOI6z9p2qOiXQnxKgUVfd93qnGw==
X-Received: by 2002:a63:2317:: with SMTP id j23mr21090873pgj.41.1636375512099;
        Mon, 08 Nov 2021 04:45:12 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id j6sm12280076pgf.60.2021.11.08.04.45.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Nov 2021 04:45:11 -0800 (PST)
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
Subject: [PATCH 11/15] KVM: VMX: Update vmcs.GUEST_CR3 only when the guest CR3 is dirty
Date:   Mon,  8 Nov 2021 20:44:03 +0800
Message-Id: <20211108124407.12187-12-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211108124407.12187-1-jiangshanlai@gmail.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

When vcpu->arch.cr3 is changed, it is marked dirty, so vmcs.GUEST_CR3
can be updated only when kvm_register_is_dirty(vcpu, VCPU_EXREG_CR3).

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d94e51e9c08f..38b65b97fb7b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3126,9 +3126,9 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 
 		if (!enable_unrestricted_guest && !is_paging(vcpu))
 			guest_cr3 = to_kvm_vmx(kvm)->ept_identity_map_addr;
-		else if (test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
+		else if (kvm_register_is_dirty(vcpu, VCPU_EXREG_CR3))
 			guest_cr3 = vcpu->arch.cr3;
-		else /* vmcs01.GUEST_CR3 is already up-to-date. */
+		else /* vmcs.GUEST_CR3 is already up-to-date. */
 			update_guest_cr3 = false;
 		vmx_ept_load_pdptrs(vcpu);
 	} else {
-- 
2.19.1.6.gb485710b

