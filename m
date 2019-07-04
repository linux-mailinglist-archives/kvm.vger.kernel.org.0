Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F24DC5F5A1
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 11:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbfGDJdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 05:33:04 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40367 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727413AbfGDJdE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 05:33:04 -0400
Received: by mail-wr1-f65.google.com with SMTP id p11so5834062wre.7;
        Thu, 04 Jul 2019 02:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GCbfF9AQXhhHA3gN4buR50ilO2YBfZtyQMuCF8cGZYM=;
        b=L2C31mdwH88LwX9crKO20wmnn0rMLg0NHYCGdHcdfostQh/wTPi7bNnJkliRDMhUdC
         eiPUPHD/OEITroP31BvQS/Eft3rQp9L9ZDSa9tLb6aU9cigd9WhSGru7y/kp0Mq2GVXv
         25wgTmMHDcovSNC8Du8TX+AZPFARDsnhslHcbU5csbr7fVCiBM3J7wHI2lWfJGepmf/3
         O4G+BlODR74lxSuFAd7aIfpfILhqiHAHPK6o+MB/jg6wqRWEg+Q5Ixl3NSidlP/MxMEP
         fvc8TYb0+DvHOIlaPbRIBj0K1f35esjiHLKscsOX1TL8Y6ScBrCrfoij8sSzoDBJyhw/
         JhPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=GCbfF9AQXhhHA3gN4buR50ilO2YBfZtyQMuCF8cGZYM=;
        b=hgf+4HM3ez9jjHBX4FT1LNEhGTXN+IK3IXaxOkrsyCYzHgmydUnLa07KIzzLM3jyc4
         wmEdGpaZ+cur1rirPT696N+xHFtGdcCOoH6XGCtjuBOw6Xv90rQIYRI8LLVLzO8cadZn
         LGFgMoRsfsCsGS0YANQ73im8T8xzbCnt5X6P0QLaP8PetLpZQy/G7M1pU9NnTJpb5tq4
         ehU06886Vj9ThJ23aW6aAoVDp8TiNeG1mc3K/TwTg/TUPsUsd2V9rr55e8vu+9E/VX/3
         Q79A0f+S9fGQ7dmQyBrPLn9Ot/qvG548TVkYZyYDC+m1k9gyEe5yWQDh+IfzgVjxI+t2
         +nkA==
X-Gm-Message-State: APjAAAWUWhNvf0DHqoZ3Bei0py5e4eR39b8awM6X4C+FhD9LVpFkVeMD
        0QrlrMSD5EbPArz/X8uIY5MxHyfnE+Y=
X-Google-Smtp-Source: APXvYqwCnC9wtGdJ+tAPASwLD2HlH1RB67tZDxS6MrIK2PqWRsqEKTu8PT4X3QmfFDoYakzLnOr+TA==
X-Received: by 2002:a5d:45d0:: with SMTP id b16mr32905136wrs.209.1562232782044;
        Thu, 04 Jul 2019 02:33:02 -0700 (PDT)
Received: from donizetti.redhat.com (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id m9sm4868320wrn.92.2019.07.04.02.33.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 02:33:01 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com
Subject: [PATCH 4/5] KVM: x86: change kvm_mmu_page_get_gfn BUG_ON to WARN_ON
Date:   Thu,  4 Jul 2019 11:32:55 +0200
Message-Id: <20190704093256.12989-5-pbonzini@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190704093256.12989-1-pbonzini@redhat.com>
References: <20190704093256.12989-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Note that in such a case it is quite likely that KVM will BUG_ON
in __pte_list_remove when the VM is closed.  However, there is no
immediate risk of memory corruption in the host so a WARN_ON is
enough and it lets you gather traces for debugging.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 084c1a0d9f98..0629a89bb070 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1098,10 +1098,16 @@ static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
 
 static void kvm_mmu_page_set_gfn(struct kvm_mmu_page *sp, int index, gfn_t gfn)
 {
-	if (sp->role.direct)
-		BUG_ON(gfn != kvm_mmu_page_get_gfn(sp, index));
-	else
+	if (!sp->role.direct) {
 		sp->gfns[index] = gfn;
+		return;
+	}
+
+	if (WARN_ON(gfn != kvm_mmu_page_get_gfn(sp, index)))
+		pr_err_ratelimited("gfn mismatch under direct page %llx "
+				   "(expected %llx, got %llx)\n",
+				   sp->gfn,
+				   kvm_mmu_page_get_gfn(sp, index), gfn);
 }
 
 /*
-- 
2.21.0


