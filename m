Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1CF25C524
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 17:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgICPXF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 11:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728642AbgICPWn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 11:22:43 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE35C061249;
        Thu,  3 Sep 2020 08:22:43 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id gf14so1628174pjb.5;
        Thu, 03 Sep 2020 08:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lcQkM04dJjt5Getpu5T9KGprYqJgTjrGD05xLf6xlJY=;
        b=HaXeOZLHfdo/16NXDGDjO2lPxZWwj3Gm71jwz7RJg0LmPWXx1HctW+SxkT+x414sG2
         Eh/K3t3iCT1WhPoGSaNeeHmBFEpuN35q5PIH2vAYis8yGGEbIQwwqjQWU5ur9Lzt/T84
         DEXIvfLsHMKOA0hAJUlzU1gvKDt0/NvJbCguB3Oe6EIV9sQe0mVBkAP8/LjcPP3gCzeg
         wGG60AJRk4vXLW8vEuLltOvZ6C2DM7noqXm6eGzF4XByEbtsXlVixBCFCVMApOTqS0q0
         fy/fAliMHrRsUpwzzbfH7RVhI+oybNwDZ8sXwg+l39JTGxvS2+SafN9nadJM8n2TEa4k
         +Bog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lcQkM04dJjt5Getpu5T9KGprYqJgTjrGD05xLf6xlJY=;
        b=ZFdp3p63AD6i64k3GiZP7xbKhXiVWeRDLwsi6q++VEpTeHfA/sS5jFSUBqEWGFhGj7
         S/rvpiCTA82yuCQnv2xRrzsxMdTvufQ29BUNBCd2TqXgGBFEMhd0kH7DzfuzTcMWoPWx
         Ws/og+tyWZSgOWL4fWNFVHSmVnCgtiIQf00roQz9Qgp2/qGrwzjQCK37lxn5umP5pqbD
         ARjeF9ysMD6EifPKmYvF5fVrtN4HBcU1o4Uh4ik4Pk74rt17wpz2r7GvphWVwpB4m/XV
         SkE1axlyRSOIr44/rExwGZwGbz3Q2a0pfII/KlnsKyZiMS0fVKh7TRSmHEIM8gJ/DKST
         KxOg==
X-Gm-Message-State: AOAM530OvLHvvDBtK7JqJovHp7fe5z4krneGqqOjvoXUMoQh5cb7ywF2
        J8pg4+pIMnmT2AVkO/l2gdLGNd+FY0e87g==
X-Google-Smtp-Source: ABdhPJzLGpBfCgsWkYgtmAGFFuFFR16B4JeChVvuPseDTtA690faOIHaTtrsUsn6q+I26JJE/5ffTA==
X-Received: by 2002:a17:90b:4a51:: with SMTP id lb17mr3634586pjb.235.1599146562303;
        Thu, 03 Sep 2020 08:22:42 -0700 (PDT)
Received: from localhost ([121.0.29.56])
        by smtp.gmail.com with ESMTPSA id o15sm3140855pgi.74.2020.09.03.08.22.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Sep 2020 08:22:41 -0700 (PDT)
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
Subject: [PATCH V3] kvm x86/mmu: use KVM_REQ_MMU_SYNC to sync when needed
Date:   Fri,  4 Sep 2020 00:23:04 +0800
Message-Id: <20200903162304.19694-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20200903012224.GL11695@sjchrist-ice>
References: <20200903012224.GL11695@sjchrist-ice>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

When kvm_mmu_get_page() gets a page with unsynced children, the spt
pagetable is unsynchronized with the guest pagetable. But the
guest might not issue a "flush" operation on it when the pagetable
entry is changed from zero or other cases. The hypervisor has the 
responsibility to synchronize the pagetables.

The linux kernel behaves correctly as above for many years, but a recent
commit 8c8560b83390 ("KVM: x86/mmu: Use KVM_REQ_TLB_FLUSH_CURRENT for
MMU specific flushes") inadvertently included a line of code to change it
without giving any reason in the changelog. It is clear that the commit's
intention was to change KVM_REQ_TLB_FLUSH -> KVM_REQ_TLB_FLUSH_CURRENT,
so we don't unneedlesly flush other contexts but one of the hunks changed
nearby KVM_REQ_MMU_SYNC instead.

This patch changes it back.

Fixes: 8c8560b83390("KVM: x86/mmu: Use KVM_REQ_TLB_FLUSH_CURRENT for MMU specific flushes)
Link: https://lore.kernel.org/lkml/20200320212833.3507-26-sean.j.christopherson@intel.com/
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
Changed from v1:
	update patch description

Changed form v2:
	update patch description

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

