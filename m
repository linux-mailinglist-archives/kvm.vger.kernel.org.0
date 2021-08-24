Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFD03F688C
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 19:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241149AbhHXSAH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 14:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238831AbhHXSAB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 14:00:01 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49769C08EDA0;
        Tue, 24 Aug 2021 10:40:50 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id v123so4302221pfb.11;
        Tue, 24 Aug 2021 10:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CQW9zcD1iWohLL0SIYdT9vr926ih+mvgsdrlaiOGq68=;
        b=q7ttQLIoeG3ckkiRgxqEPJcPxTRSJalv5DEs23w1eyMvpLw+2d2AUxpeU+AXF1WbXh
         HbS8KcqUbr3vpNR+vEZAaGL4mQuO3OJcqlB+AEkZJFuJpJmz43W5OCx5h+B1HLdfxW62
         YQEwq5ehFTcu/HkZblC+HndnVmad46B8acxo+fFVvdAjMaSgpe6hKrWzC7xNzRhWpfPf
         91sUZYkBCRitRylF2cAZbuAVxvEI5P4fOMaXs9El8fbWhlVYz9lX+CKPZaBFOkNB15Wc
         9jiy2ohaWcPoeXpBIL9TnGgBwhSrV/4JNr3TZZWk7bXRIrQCD/21uzzra9JI6jgw81d6
         sqlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CQW9zcD1iWohLL0SIYdT9vr926ih+mvgsdrlaiOGq68=;
        b=GlSWLF6x5Rcy6rDWULjge93muiE3M8GsO4//94HSEYrNXYcb06JG6RGnakra8eL+B7
         41g/ifmV960mtN7lUEPQHpqQyCVnoxor76to9UgBsB+Rf7+N3gLNMxRHR/ETfZenGkRg
         TgslWUjvKPZRi/rie2Me3YovV0ObRECYtHjAPYR1hBxV5r0nxr5uT5/8HP5r6yw0ssjJ
         T+wf+yPJPoS6vw8oN6LJtcOZcBs7Dxwt09OtkolnWK3gOQEE/zKvuSYgHupQZioO5uLU
         lgC39/CJnRE5yiSCndLnf+zB++R9Xn0f6Nduv+OPmHrVqV9T49VdGZ6ZFjdMoxGIVP3d
         Xkvw==
X-Gm-Message-State: AOAM531YpvDbcy1LjjzTYJznosSixtYPO9tVoYGXbgTiD36/P4kIJoXm
        cw3MvWuhL5PMV8dNhrIn2ctVPtL+zwI=
X-Google-Smtp-Source: ABdhPJzdmTsFFwkdj6b9umV4aZli6sfawea+gfCCbWcIBSHLZiJmFwuZn4MXZg1uwWwWAwDC8kYB7g==
X-Received: by 2002:a63:144f:: with SMTP id 15mr20866714pgu.46.1629826849708;
        Tue, 24 Aug 2021 10:40:49 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id o16sm8920397pgv.29.2021.08.24.10.40.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Aug 2021 10:40:49 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: [PATCH 4/7] KVM: X86: Remove FNAME(update_pte)
Date:   Tue, 24 Aug 2021 15:55:20 +0800
Message-Id: <20210824075524.3354-5-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20210824075524.3354-1-jiangshanlai@gmail.com>
References: <20210824075524.3354-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Its solo caller is changed to use FNAME(prefetch_gpte) directly.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 48c7fe1b2d50..6b2e248f2f4c 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -589,14 +589,6 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	return true;
 }
 
-static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-			      u64 *spte, const void *pte)
-{
-	pt_element_t gpte = *(const pt_element_t *)pte;
-
-	FNAME(prefetch_gpte)(vcpu, sp, spte, gpte, false);
-}
-
 static bool FNAME(gpte_changed)(struct kvm_vcpu *vcpu,
 				struct guest_walker *gw, int level)
 {
@@ -998,7 +990,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 						       sizeof(pt_element_t)))
 				break;
 
-			FNAME(update_pte)(vcpu, sp, sptep, &gpte);
+			FNAME(prefetch_gpte)(vcpu, sp, sptep, gpte, false);
 		}
 
 		if (!is_shadow_present_pte(*sptep) || !sp->unsync_children)
-- 
2.19.1.6.gb485710b

