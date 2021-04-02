Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37DE352D41
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 18:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236415AbhDBP61 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 11:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236339AbhDBP6P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 11:58:15 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A91AC0613E6;
        Fri,  2 Apr 2021 08:58:14 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id b9so5098510wrt.8;
        Fri, 02 Apr 2021 08:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=43FpCxX0SVzfOugEOQk73VHo0lcUDXRR1mTG2VJrV24=;
        b=O71U8IkgAOkcDTf0HexDGvvYgfmnzBNBLucYyXbL6gsSmc0cC6b+ibn0v+g83j0Sq+
         0o2Ds99FytvE/8nT4kZrDGQkHOwd7HfvVbi+vy77EBZvVwFDEIQq7gDhzdSMQmtI8WEJ
         WsTlunnqyNvUZ2dE8XIH4sbIC/jLB98ohUvPVfLztONbgMvOsWDfLKmhPkIR4Ag32vU8
         wPYBJHgaQkHo/TNTxN1jaggCnHiOOAvS0PryD2YaMCTZ9yGQ3DPjF+swLv2QAbxXXylt
         7TqqVYg9hTyT5/scedmBrdYTdAZEW/UHXIkLvlMpWQpnwu/geL47ZHFxsOnrBtXWuKkF
         cErw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=43FpCxX0SVzfOugEOQk73VHo0lcUDXRR1mTG2VJrV24=;
        b=qnTL/pps5rwin9Gmkfw5vdnvUAClymtOh1crxFZJ+nxMKqQBflfKj879thI2/SVDtu
         /hEvBFTjSx7aNYA6ZOTEJeTOxy5OoNLLBTiCOmaX2ocPVFjz40IIsqKK1CglKhcLQGwz
         Bx0yi4vH85b7lEKIvuVEpfAmEbi9ijn0ov/FYtA1+/nWBtIMTyzPxe//2UsSo8naZmZM
         l/lR62Wom8d4dD7XVmnHn2kYTbekdFhBZEzpjijs0mCyn1eZm5SbUplHsf896Io09Zt0
         SGaafyfAJhRGEec8HpUHL6ApzI77LG9eWGV+edKvV+GcV5pdZ9ZkGjGyaenQIjRrnMAP
         5p/g==
X-Gm-Message-State: AOAM531gVLfjdsGh1g7kJxEffQ6IQl5Dn0ojLcX9ccreWVTdA0rsr7BE
        4N/OFkP79vd5jLmjAyiysyZHwt1Ppn4=
X-Google-Smtp-Source: ABdhPJy40VzvN06rqq1Rze1hJe0FWvMeBslGqDWCgLdpW2+frdxEDgqtczCiJqYQQTlwLtqPwppNpQ==
X-Received: by 2002:a5d:42ca:: with SMTP id t10mr15796822wrr.274.1617379092877;
        Fri, 02 Apr 2021 08:58:12 -0700 (PDT)
Received: from avogadro.lan ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w11sm2293625wmb.35.2021.04.02.08.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 08:58:12 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com,
        seanjc@google.com, linux-mips@vger.kernel.org
Subject: [PATCH 4/4] KVM: MIPS: defer flush to generic MMU notifier code
Date:   Fri,  2 Apr 2021 17:58:07 +0200
Message-Id: <20210402155807.49976-5-pbonzini@redhat.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210402155807.49976-1-pbonzini@redhat.com>
References: <20210402155807.49976-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Return 1 from kvm_unmap_hva_range and kvm_set_spte_hva if a flush is
needed, so that the generic code can coalesce the flushes.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/mips/kvm/mmu.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index 2cedf908d744..a3a49b009dc4 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -489,9 +489,7 @@ static int kvm_unmap_hva_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
 int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
 			unsigned flags)
 {
-	handle_hva_to_gpa(kvm, start, end, &kvm_unmap_hva_handler, NULL);
-	kvm_flush_remote_tlbs(kvm);
-	return 0;
+	return handle_hva_to_gpa(kvm, start, end, &kvm_unmap_hva_handler, NULL);
 }
 
 static int kvm_set_spte_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
@@ -528,12 +526,7 @@ static int kvm_set_spte_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
 int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 {
 	unsigned long end = hva + PAGE_SIZE;
-	int ret;
-
-	ret = handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &pte);
-	if (ret)
-		kvm_flush_remote_tlbs(kvm);
-	return 0;
+	return handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &pte);
 }
 
 static int kvm_age_hva_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
-- 
2.30.1

