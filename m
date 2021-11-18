Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2BC4559D2
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 12:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343962AbhKRLQK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 06:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343714AbhKRLOR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 06:14:17 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F09C061230;
        Thu, 18 Nov 2021 03:09:10 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so7874448pjc.4;
        Thu, 18 Nov 2021 03:09:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cEtQ1Na8i+7W/Q+NNUCdn0+wSJgL9gwMTU0z+MM3hHA=;
        b=mPLPZGdHN7CumIJHuMhCD1209JHXxJyt3SAvb/hdEmQiiQ0xpTDkkx/xCdYsIfEtdf
         Imk2DWb+ZkUXdccvfNoRePqNXGptuEFBXKEyzzyTujG6W0Wvg0dp6YEbdqaLprDhNPU4
         cJ0ejMQEbJ9l9A4aq7vX2//ezzXDxTN2C1ipvmc/SVY7ZClssYb+THJRY2Vs0I2VHdE6
         8ScXCn+23BTDzzd+gXmXfqjYyFC/ptMniKFLs96Kg8vG3Cf9gPZsGZLYSNKq7VSib0Nq
         iAVe1pSjTXX/pHF7KligiJe+DPwT4n2GH1puNMB28YxgcF3COsdQHqCC9501BGiZKyif
         ufBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cEtQ1Na8i+7W/Q+NNUCdn0+wSJgL9gwMTU0z+MM3hHA=;
        b=kIBjF0W/rU6rpDwGyNApXoqE2M2pql9M8TzyHi3P3FMWGO74MyC01TnIz9BLAh6v/p
         zx0QuE6f/6ciZF+f3VBRAhx9Ut0zaTZe/kH2aXTehJ6tfgOmmeEznWUzrMWjUawOajss
         6UYgezEeYaPrX1BlHx3naI2NgVyee2+lyU775GwBk5/DINPPt6pZyp+J4Ps4Kj3fpekp
         qgVnB0yERV0nJI3hy33kHVExXSJZps/WHhnusttyl3RKq48i94LYchmCGoZz0xbVkIWV
         raTQ1/ZUS/wTD54v9o3UfCuJr8Q+K7WAZo2lwVHbP6kXLXC+IuzUotOPwI8M6lYkLFxp
         equw==
X-Gm-Message-State: AOAM531QXQZkX0r7lT9dH7tSI9D2L3Oo/AZcIihMaaKtzz65mryC1S2h
        3D8yW/lSP04Hpl+Mh9FBJHBZ6dATMyI=
X-Google-Smtp-Source: ABdhPJzdFMacoH6J/1AVdPlIREGhk8b8sLZpfLrP2BLKvsx91PGlMyhUQXDjE7qwJoFVfOyPWXf+ng==
X-Received: by 2002:a17:902:74cb:b0:143:6fe9:ca4 with SMTP id f11-20020a17090274cb00b001436fe90ca4mr66486639plt.2.1637233749926;
        Thu, 18 Nov 2021 03:09:09 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id w189sm2827192pfd.164.2021.11.18.03.09.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Nov 2021 03:09:09 -0800 (PST)
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
Subject: [PATCH 11/15] KVM: X86: Fix comment in __kvm_mmu_create()
Date:   Thu, 18 Nov 2021 19:08:10 +0800
Message-Id: <20211118110814.2568-12-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211118110814.2568-1-jiangshanlai@gmail.com>
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

The allocation of special roots is moved to mmu_alloc_special_roots().

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e1fe8af874ef..64599fa333c4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5514,7 +5514,7 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 	 * generally doesn't use PAE paging and can skip allocating the PDP
 	 * table.  The main exception, handled here, is SVM's 32-bit NPT.  The
 	 * other exception is for shadowing L1's 32-bit or PAE NPT on 64-bit
-	 * KVM; that horror is handled on-demand by mmu_alloc_shadow_roots().
+	 * KVM; that horror is handled on-demand by mmu_alloc_special_roots().
 	 */
 	if (tdp_enabled && kvm_mmu_get_tdp_level(vcpu) > PT32E_ROOT_LEVEL)
 		return 0;
-- 
2.19.1.6.gb485710b

