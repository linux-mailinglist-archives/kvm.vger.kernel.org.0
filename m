Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB52881550
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 11:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfHEJVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 05:21:49 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44294 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727158AbfHEJVt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 05:21:49 -0400
Received: by mail-wr1-f68.google.com with SMTP id p17so83621315wrf.11;
        Mon, 05 Aug 2019 02:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id;
        bh=V2wWMUhEfoTz/ptCW6Cm4wW3fQFRZiOyo0lAiMKG3TQ=;
        b=JNaoUaSZYHg8+/9m3TbOKS6cDiaoljuMhaEobB05f+5ATWkE37VDKBGfOgn18Igizv
         5TQ9fkSueBBGD63/LUZ//Na/iHdfnRvQcKJEujdeRL796fiCZNRnqke3fglHDQ53cNZX
         m63L1YJ1x6l9e1Sw2bEMh4Zo4leO3YF5C84QSH5GEfgo/TKcnZXbb2rqcbhwa599PeWS
         PXIfyOSqCpt/5phipT96iclK9KD3Sbu2VwE1F9lkx1VMBqDhqoTYS+sZY1G9Eki877ZI
         rahCq2yRvrrLHeWBym7WUnxMhVJXTaKzZZUGiAAwdmG9QpZirEAdvEwV30MxCfel1kCK
         daQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id;
        bh=V2wWMUhEfoTz/ptCW6Cm4wW3fQFRZiOyo0lAiMKG3TQ=;
        b=R4n4QnMEKvERacF1+1bGMtdSt/nAP443LHPrEiTrbt9LG06k7G0hp0D1ZNwXZdtRu/
         1M9kBZ7Ipw0HGt7+xL+Bd/oWME6/1O+CFLUNeSCnCYxfNo/oMBO9r3fZL+CduOt5D/Se
         fa3JDEKvLX4wMgoFuY7GUUAs4lhlmkGzosUUGlKl61DGP9BdRC6iCDD6yt6Jg9xL+39N
         wYm77oBgl7s3rQwWxjKZRvlruVOi57bu9wmyR9BvyYGMJ1j013ymg4fZKIDM54n+YNbh
         +BNiaBMPRi/iRzJTVewf47iDthyIHpFqmq+FFNrykraTEWyj1bT5cII1R71WnPqxeYg+
         xOAA==
X-Gm-Message-State: APjAAAXU4PlXxO0Z3KC295WWI5xnPoQitFPEjsme+v5INO7VdLU7WqKi
        2Xdy8+CQBhUsyJGEBp/45sV6hVdN
X-Google-Smtp-Source: APXvYqzKK78GrO0c6eGvIdnD7VuvXUpK2K4+rH5fiLS1IBvR6ovcHd2gq0aJFJoqFkT1L7x24Ir1wQ==
X-Received: by 2002:adf:cf02:: with SMTP id o2mr14384514wrj.352.1564996906615;
        Mon, 05 Aug 2019 02:21:46 -0700 (PDT)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id o126sm82577723wmo.1.2019.08.05.02.21.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 02:21:45 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] kvm: remove unnecessary PageReserved check
Date:   Mon,  5 Aug 2019 11:21:42 +0200
Message-Id: <1564996902-22600-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The same check is already done in kvm_is_reserved_pfn.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 416969d9fefe..c5f1186f4b60 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1855,8 +1855,7 @@ void kvm_set_pfn_dirty(kvm_pfn_t pfn)
 	if (!kvm_is_reserved_pfn(pfn)) {
 		struct page *page = pfn_to_page(pfn);
 
-		if (!PageReserved(page))
-			SetPageDirty(page);
+		SetPageDirty(page);
 	}
 }
 EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);
-- 
1.8.3.1

