Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02352934D1
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 08:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403996AbgJTGUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 02:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403827AbgJTGTM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 02:19:12 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167D1C0613D1
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:12 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id a4so720508lji.12
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y7hM+tUDAeAq4RAxUld5ugj5h0NrD2Du8CkrLpwlkag=;
        b=QOwj6pUPgpTDZ6ktUvy4xykf+ox4KixOkoZHuQqKEafWwwbuwhWO8H15O9F2S74Kyb
         aKOivTr6vej82pS6GKMyAEpN9vglV3fdogePZcExy41kgzXGzhx0JEZOYEBBgQauJfbf
         a4fpB0aFkwpbAZow63PKwa2cI3mLpbrXowiG8FCfuo621x3Xv+E9Yu7FMmUIwTEnAYRs
         OBWkoRYnDrD971FOU2wxMq0kpfZSB8vPJoBpfy+oTVo/8R14HJIBOngbE85+oA+IEQ/A
         B/MYw1omq+M7GBfCkdovs/HQaPgwVTpyuHY/J9z1tQkVrsaQjLFe+L8wzWGA6UrGvN0Y
         p+rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y7hM+tUDAeAq4RAxUld5ugj5h0NrD2Du8CkrLpwlkag=;
        b=o7NBqQv3IKeWD/8AnIjQZRE/5Eh2AWx3F70QXIE1AdeiodJHgXqwkXBHvMTi+bokXf
         HVtHLiLguXz+7Tfbx56cPxww/lGlQ/vamMg1h0fFP4b2Yzmk7c6LkM2q6qOIB0ZL5tA7
         crvYjw5IQ/vd8vGWCnPOWhlMJfubZEDxOynxXQfBarP7wSh1cbyxNrD4sITJm53oeNTG
         ntLPOvEikBpHi9XSEa3HY3NcDzPCbgOLVoYfu7xoRm54iwh4GeIWHBIsSwwIiTqEF6Hp
         3Dy0ubZmITu2CA4qhqVaRXcCksoBbh3+UV0QGjkJGKm4VuQmy6xrJynTKJmGwbcEpb+D
         WGYw==
X-Gm-Message-State: AOAM533MLIYcYj58K5sFhU/PzPcS76ez6p6Gg8WrnPplQT8qrbrKNDg8
        nwQWr1xNO6YVxdwuh9pNM+MVNw==
X-Google-Smtp-Source: ABdhPJyNQOaGkoovzVmlF7h+01Jp8CyRpn89ZWIY3mQpFq+pcIj7Ik9DQ/oAPoDKgfNVHjdjAC5Vog==
X-Received: by 2002:a2e:949:: with SMTP id 70mr511621ljj.319.1603174750510;
        Mon, 19 Oct 2020 23:19:10 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id l14sm194088lji.123.2020.10.19.23.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 23:19:09 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 0BAA4102F69; Tue, 20 Oct 2020 09:19:02 +0300 (+03)
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFCv2 10/16] KVM: x86: Use GUP for page walk instead of __get_user()
Date:   Tue, 20 Oct 2020 09:18:53 +0300
Message-Id: <20201020061859.18385-11-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The user mapping doesn't have the page mapping for protected memory.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 4dd6b1e5b8cf..258a6361b9b2 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -397,8 +397,14 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 			goto error;
 
 		ptep_user = (pt_element_t __user *)((void *)host_addr + offset);
-		if (unlikely(__get_user(pte, ptep_user)))
-			goto error;
+		if (vcpu->kvm->mem_protected) {
+			if (copy_from_guest(&pte, host_addr + offset,
+					    sizeof(pte), true))
+				goto error;
+		} else {
+			if (unlikely(__get_user(pte, ptep_user)))
+				goto error;
+		}
 		walker->ptep_user[walker->level - 1] = ptep_user;
 
 		trace_kvm_mmu_paging_element(pte, walker->level);
-- 
2.26.2

