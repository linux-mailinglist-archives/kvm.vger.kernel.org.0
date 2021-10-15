Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3674E42F841
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 18:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235873AbhJOQe6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 12:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235807AbhJOQei (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 12:34:38 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0EACC061768;
        Fri, 15 Oct 2021 09:32:31 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id f11so4918639pfc.12;
        Fri, 15 Oct 2021 09:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZwuGqL3+ELdyo3s+0IX7nYDyy8R+3UhnzhnMIc+LF1s=;
        b=QP3pvvCLobAXk04nn3CngQjQxqSziImBzJlivyb4zOimnog3M+t5RtaIZ01eeaNldz
         BqwtPvoq3tmB3Geoew/+SWVUlj4VgkxNW6Ru5mVruEl/vr4TQs6GQNb4kOVqovNUbAIS
         Av1ynEbJp6WXzumm2UH88GsDNCTPJ/S3SbrGhN2NTla1/ZdkZKHRuGx3XyTVfK+jXW+2
         46sspANUx7Bzlif9XVAzDAgbUuSKxfFW+nioP75dEBZ75xtcd0yBntimkZLjXh/a7NWJ
         AFxrbSoetbONBKgsHumyd3v7Sheho2HAKjVfnOpkuXDlry6zKWyn9zb01aNjJ1uGcoDY
         HL9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZwuGqL3+ELdyo3s+0IX7nYDyy8R+3UhnzhnMIc+LF1s=;
        b=5lkHppt+nEsyAlKYFPBGtqccKg9h5LZzXyMEDqKrpLx70+JLZF7GPgR4lUhgTQIqBE
         rGowstiwfFw1hnkL4QYMXOCrwK+ZEwv3z9Banabb7J17cAnZ1a0dwm8TBDh4pLkYZI8y
         nG8an7FDiafgi1jKAR6DmLygZO+xW4StjPxw2nJS+BogStMD9fkfSgUVSj2LaTdQjrKu
         tnFtOug+xuETox1g8JLDyYw9qXCUY+TOFv9KdWi9x6NJzMGiAE6uypeG9bp2joghI9p0
         Tm3DpBKWDk4NQ99cXlVXHwDA4l++upBEc0Z5MqQQ4RGNNDSG8f7/agJBMCGXN6628Es9
         0wqQ==
X-Gm-Message-State: AOAM530cfAw8N24I8HbFJ2DMFJXD8o87lFrMwVQ+0CrGRB7myuZ8uplu
        yNGgX+edkBIvh5JxYb/+o4D2+FrWZqd72g==
X-Google-Smtp-Source: ABdhPJzBDOFDLTJVfpSYt84djhXPr0PLOBTMkk8smstBEMcue+uONrG7Y0MDCQoJmhREQtEHP4stng==
X-Received: by 2002:a63:8f5c:: with SMTP id r28mr9742417pgn.70.1634315550931;
        Fri, 15 Oct 2021 09:32:30 -0700 (PDT)
Received: from laptop.hsd1.wa.comcast.net ([2601:600:8500:5f14:d627:c51e:516e:a105])
        by smtp.gmail.com with ESMTPSA id p16sm5818137pfh.97.2021.10.15.09.32.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 09:32:30 -0700 (PDT)
From:   Andrei Vagin <avagin@gmail.com>
To:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc:     Andrei Vagin <avagin@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH] KVM: x86/mmu: kvm_faultin_pfn has to return false if pfh is returned
Date:   Fri, 15 Oct 2021 09:32:21 -0700
Message-Id: <20211015163221.472508-1-avagin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This looks like a typo in 8f32d5e563cb. This change didn't intend to do
any functional changes.

The problem was caught by gVisor tests.

Fixes: 8f32d5e563cb ("KVM: x86/mmu: allow kvm_faultin_pfn to return page fault handling code")
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Andrei Vagin <avagin@gmail.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1a64ba5b9437..5dce77b45476 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3956,7 +3956,7 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 
 	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL,
 				    write, writable, hva);
-
+	return false;
 out_retry:
 	*r = RET_PF_RETRY;
 	return true;
-- 
2.31.1

