Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3854E66A5B7
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 23:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbjAMWJx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 17:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbjAMWJu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 17:09:50 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712A31BE87
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 14:09:48 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-4597b0ff5e9so243795037b3.10
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 14:09:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UTBnuJDCNTixyImGa4cos/Yt8U53a4kJ0LI12qqBltY=;
        b=LqBp4oyh3asgsAGa6im7QUMiW6d/Bt7kD5XzE71Pr5S7yjgSlnrBTrWDXRr8Y5mjS8
         8LZBdNB+Yjpyq7pH8swq9cab1qfQMERqLR/A3L5TlDQ0ASJRl0zQC+PGsrZLoA0jUpfe
         Ms1ZvRkIQjwYOMBkUbhls+wf/5XwKMk3M8tEcdtydrxTs2GhXlFMGbjnboh6cqtx05/t
         gujB1KwNWXcmYOCBYaYOCkzFRdeUA4PWRMoHEsvpCl91wrsN/21MyI8Z7YnxWZcG27Lz
         LILzLlzOvgZKY+RYe88k/tLlwAuYf+Ti+R32OjiUhL7CimCe7vKzjqXqZ0tDKi0V89/a
         OZuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UTBnuJDCNTixyImGa4cos/Yt8U53a4kJ0LI12qqBltY=;
        b=LNePKM3so1L2C2GihB7+98epwk+l4SYI12zrlcRtrf2rflRGohFbUqHGFy8KvNjib6
         ycJf0k+vIICFlhSoT5RSnFfl0g5lVO4UR2/ANASZ/MTQOUj1rM08SC/bjO/y3cp1dNGT
         yQS70N68JLQBfbM0AA9u3PpEVIIOYfmqQeqE1Vjnv/izDvq+PfZbj/QBS4MUwTnfR4fQ
         fi525Pg12oWPKQPpzMbmip8H4BMos+s66C+EmS43EAckWg+BG5+iEEemdUdvKzha4WM1
         EwOno6arfgXU50d7zlTtfwyGHcLEH43Khab4Z+pepJDUojy7qEDrK7dKK3GPtSkWbXd8
         S17A==
X-Gm-Message-State: AFqh2kqDOfwoN2zsXd5B6VFM4o9egQ9wGxJ3AAB7jiaM2stGOGih+TeP
        2H3sclfi3USGS2pujXVOvMBIyBQq+DHMbg==
X-Google-Smtp-Source: AMrXdXuzA2HnEdXZlpJhcyUyB1DumQUbaSwGrHGcM4zjIFAPCE/SNm72dTDNFI3T0SMC6HkxNK25rjD5dDfGxA==
X-Received: from aghulati-dev.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:19cb])
 (user=aghulati job=sendgmr) by 2002:a25:5642:0:b0:7b9:4d82:a301 with SMTP id
 k63-20020a255642000000b007b94d82a301mr1901227ybb.368.1673647787753; Fri, 13
 Jan 2023 14:09:47 -0800 (PST)
Date:   Fri, 13 Jan 2023 22:09:23 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230113220923.2834699-1-aghulati@google.com>
Subject: [PATCH] KVM: SVM: Account scratch allocations used to decrypt SEV
 guest memory
From:   Anish Ghulati <aghulati@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Anish Ghulati <aghulati@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Account the temp/scratch allocation used to decrypt unaligned debug
accesses to SEV guest memory, the allocation is very much tied to the
target VM.

Reported-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Anish Ghulati <aghulati@google.com>
---
 arch/x86/kvm/svm/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 273cba809328..a5e4c5ef7c9e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -813,7 +813,7 @@ static int __sev_dbg_decrypt_user(struct kvm *kvm, unsigned long paddr,
 	if (!IS_ALIGNED(dst_paddr, 16) ||
 	    !IS_ALIGNED(paddr,     16) ||
 	    !IS_ALIGNED(size,      16)) {
-		tpage = (void *)alloc_page(GFP_KERNEL | __GFP_ZERO);
+		tpage = (void *)alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 		if (!tpage)
 			return -ENOMEM;
 
-- 
2.39.0.314.g84b9a713c41-goog

