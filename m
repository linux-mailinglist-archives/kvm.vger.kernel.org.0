Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B9524F79D
	for <lists+kvm@lfdr.de>; Mon, 24 Aug 2020 11:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgHXJSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Aug 2020 05:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727790AbgHXJSC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Aug 2020 05:18:02 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4318C061573;
        Mon, 24 Aug 2020 02:18:02 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x25so4501391pff.4;
        Mon, 24 Aug 2020 02:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rMbx9PJ3DCBK5KCbc3Tq72JFtt/jZJ3a0mHSBLV/+uA=;
        b=AnqeJkTdPwAVQxkz4xsNAtHq1yAHzh39+X/LXN7tfivOxU91cTAYJkDJJEjAHalmTR
         JZlcvmT0jYOFVX6LkmIh6yFcYtztGmbUR6o6yzTt2BxiUbPXknRCADhyi23jcFSPn4uw
         M71l9lbogTqNOdr1bUTHbUybuPAn+BIlK1zzCStEEaaRqb7iMr0gqZvvHFJO39zu68h7
         3y9YUX1d1+rSQqgmOEVJ5qdyprOkA23HJUvmKtbuFOwVLNgYGmxJLg6a+sS7/fE7N5Eq
         mksxmBPLx7hej4N+hF4XWBKcKl1DxvAZHPO+gnF2uzOwJWB6Lgc0gxCpW6QyWAHddreL
         MUQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rMbx9PJ3DCBK5KCbc3Tq72JFtt/jZJ3a0mHSBLV/+uA=;
        b=OHIupXePxRwVVrsdOC5YHTAS+bM7EKbiHE1B37fZI+imbKYAVEj3WKQohJeUDMPaPF
         OicXOl4AqJwYKuMS7pOWf3LlNVBnIGtt2MVEIEcIML82dDTmaMfWDeFJm/Z2jcdMouW5
         KBVJOUVu2u/sHDRAvOLJpcnNt1tAHKD27RF+tThMYR/y6g9EBydAfM9excyMkKP3lCQW
         IqozGWVg40NtKNhf09s+ga41o5cyyWGSRZDp+fbXFm6kpVbNYWRWMrmqXzBfxFCuhPDB
         VT3PZyhLZvKZiZBag62tZqAY2GnsU6aVRGM0Xc5+3zZE0gIE4F4QcTBDID9hPTm3EE6S
         e86Q==
X-Gm-Message-State: AOAM532VmLXjOzxpDUbNSIegrEXvH6Z5tTKv9Kep1OiRYyuC5GI2hX0U
        +R2yvjtVSBhA6UQRwWChB7xQgY2MCVQnpg==
X-Google-Smtp-Source: ABdhPJwH15eOuacRsnIJtiFTkzCC9mVtco/DG7gF2PFLarQs3vCzzD3G4wVhpqSTXi5lRLlEgpy9XQ==
X-Received: by 2002:a63:4b63:: with SMTP id k35mr2965491pgl.235.1598260682241;
        Mon, 24 Aug 2020 02:18:02 -0700 (PDT)
Received: from localhost ([121.0.29.56])
        by smtp.gmail.com with ESMTPSA id 62sm10342504pfx.47.2020.08.24.02.18.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Aug 2020 02:18:01 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: [PATCH] kvm x86/mmu: use KVM_REQ_MMU_SYNC to sync when needed
Date:   Mon, 24 Aug 2020 18:18:25 +0800
Message-Id: <20200824101825.4106-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

8c8560b83390("KVM: x86/mmu: Use KVM_REQ_TLB_FLUSH_CURRENT for MMU specific flushes)
changed it without giving any reason in the changelog.

In theory, the syncing is needed, and need to be fixed by reverting
this part of change.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4e03841f053d..9a93de921f2b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2468,7 +2468,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		}
 
 		if (sp->unsync_children)
-			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
+			kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
 
 		__clear_sp_write_flooding_count(sp);
 
-- 
2.19.1.6.gb485710b

