Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6110A25AB7A
	for <lists+kvm@lfdr.de>; Wed,  2 Sep 2020 14:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgIBMyE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Sep 2020 08:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbgIBMx7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Sep 2020 08:53:59 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6829C061244;
        Wed,  2 Sep 2020 05:53:58 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id gf14so2260023pjb.5;
        Wed, 02 Sep 2020 05:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GPYnsVkem3+rGz/hx35DWNwrA6gRvemoFnUQJ0NxbXk=;
        b=O3IliV7T1Fi5FVyDT80cvvfFZipGaOhG7IHj5wmk+aM5nRA+7s6hAcCzbQlG8BwdxX
         54f/Gvy8uAPninfvMtb5FsMDiz3OvpvPWVhF3Q5dML5syZvJF0mgurliqkv009WVDxkV
         DKCIKjfCcCJSb6alglsLEty0+b2/OGbCF7y2MQ8e1IkBpiwfNMd957e6nCfIELviTgwg
         86+eVzUqh36SZuRlLGOkd6BZntCZx7OAJGgYl+4yp86c/EJ/5M4W9JhiDd3rMAq6bFtZ
         A9k+04RosFknwjeAGWeIMUC5Eeb/AU1BIeIHS9R7CkFXuyhhS2qN/YRAsCVrJ0xyGgBZ
         h0gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GPYnsVkem3+rGz/hx35DWNwrA6gRvemoFnUQJ0NxbXk=;
        b=rgxVA5l7ZuF2BTUsNVpRp45PBl87Spxe8jfEu75REIHAcYDHOlrTMgCOmSB0rMZYvU
         BjMpZqDGdEA9EHzyWuJ07hUPq2excrQtYtrbWdGTUVXrvsWA2yQLbig0FtGJpKEpDJHj
         M7txCiCysKf6TOWtaGjZUka87U/QLvTmRSX12WLbqPDpLw5ld0aXdTzpX0j5sTNiwyXO
         VqdeDtmZsLWC+OIOza/kpKFlW4971VRX2wpibwBET0LfOdOHtIEPFO+ZPru34p8e/Cza
         y0CmXg9TItwILDG/zuWGNyNJL9m8l6wY6Au+GnIFGKaz8OECnVCHATnlLVD58CnrIa9n
         h21w==
X-Gm-Message-State: AOAM532isjszWnsACXVykOToUA1/36o9a2o36bIN+33/mEpNcvhya6hF
        Rm2evoGHdApGDKZQqidHPbw5IKsIiUDKpg==
X-Google-Smtp-Source: ABdhPJzAP+Z5tZoU/7BeymZD+T3FE/yPFfem59xGZ5yk9RLyR0EfRMQ/J022r+Y1ZzSejAs4fCiUPA==
X-Received: by 2002:a17:90a:e2cc:: with SMTP id fr12mr2143502pjb.125.1599051238181;
        Wed, 02 Sep 2020 05:53:58 -0700 (PDT)
Received: from localhost ([121.0.29.56])
        by smtp.gmail.com with ESMTPSA id np4sm4243201pjb.4.2020.09.02.05.53.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Sep 2020 05:53:57 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: [PATCH V2] kvm x86/mmu: use KVM_REQ_MMU_SYNC to sync when needed
Date:   Wed,  2 Sep 2020 21:54:21 +0800
Message-Id: <20200902135421.31158-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <87y2ltx6gl.fsf@vitty.brq.redhat.com>
References: <87y2ltx6gl.fsf@vitty.brq.redhat.com>
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

The linux kernel behaves as above for many years, But
8c8560b83390("KVM: x86/mmu: Use KVM_REQ_TLB_FLUSH_CURRENT for MMU specific flushes)
inadvertently included a line of code to change it without giving any
reason in the changelog. It is clear that the commit's intention was to
change KVM_REQ_TLB_FLUSH -> KVM_REQ_TLB_FLUSH_CURRENT, so we don't
unneedlesly flush other contexts but one of the hunks changed
nearby KVM_REQ_MMU_SYNC instead.

The this patch changes it back.

Link: https://lore.kernel.org/lkml/20200320212833.3507-26-sean.j.christopherson@intel.com/
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
Changed from v1:
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

