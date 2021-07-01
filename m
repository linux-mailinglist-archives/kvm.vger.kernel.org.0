Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D833B96C7
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 21:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbhGAT5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 15:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbhGAT5h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 15:57:37 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0335BC061762;
        Thu,  1 Jul 2021 12:55:05 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id a11so13859837lfg.11;
        Thu, 01 Jul 2021 12:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t0nKk5wGeP0nXftaEotyDurI2+QO28/8HgfwxEwbQLs=;
        b=iQ3ViSUGNIEiyfhfoK0YqvEg0w77pJJxsrF29DCnwhEX7Z55D4dOQmzRlApBKYnb4y
         M/QfEjaCsAsE+04FgaHkn1jnY7eyRwfh6MYFmkD/gQgWe0MSvwnANbsrRC5ShTDuY/nP
         TubFMH5HqzosuO9bEmFgDIZXf6RwiVbsbTHEShHRo8M5PM3QODOCQkAfv0BbeIQ3GC1+
         f2cFBFgRkGElSrPEfwnuUQnN+yV6IxI1FYHRMkF/NNy+O9MvwCFVFzbm7UF/BGAkrAGF
         VKfWUSnOKd60yQxXoYSzh/7bkdKQu16aBsa+ebS5pQ6j8N2++zMJv0g/8y1rTBTSuVee
         IuEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t0nKk5wGeP0nXftaEotyDurI2+QO28/8HgfwxEwbQLs=;
        b=cQwUHwsZODkYHa83Q+A93TBwOM9gO2TuoOuYKCsSAZP7H7t+vYl++23TDkx9COTr9s
         urcyQNRUX1T/l34lpCVXReuw9Rt+tLbln1E+zdamqKogNcivQV6l5/ChSpVMYZfwc1uJ
         QnO0xh3RXP6gzIwAflEOTRaBTPR8ZY6VzUwAO8UUF9OETBS/y7Mk0IDfgfgkzY2srloM
         I0fx0/DhSznr43kngRIuzD4FsIjzDZ7ElvQR6mBtkdmatZ9JhyP0NSqcAr1N8mN5/t7n
         AuNhK5fNUt4RD6yl65ZkNpojGbM9RfS/Rqa9pcVmNpTb+pbeYBltXvLKEqABMd1eMPAk
         /IGw==
X-Gm-Message-State: AOAM530qfUG54P0nc76TjMptk4Fa2jlZmlzIFvg03r9NCcbXZ85cQsxY
        v9i/ZMJw+cdld4TUaeeXv+E=
X-Google-Smtp-Source: ABdhPJxNF6t35ilZGoqlkwBAmqZpOvUoDucPY3L+Ql0seF1BteZ/88TL16d3+taambf5VnTp7mNipA==
X-Received: by 2002:a05:6512:3406:: with SMTP id i6mr989613lfr.522.1625169303301;
        Thu, 01 Jul 2021 12:55:03 -0700 (PDT)
Received: from localhost.localdomain ([94.103.225.155])
        by smtp.gmail.com with ESMTPSA id b5sm59616lfv.3.2021.07.01.12.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 12:55:02 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     pbonzini@redhat.com, jingzhangos@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH next] kvm: debugfs: fix memory leak in kvm_create_vm_debugfs
Date:   Thu,  1 Jul 2021 22:55:00 +0300
Message-Id: <20210701195500.27097-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In commit bc9e9e672df9 ("KVM: debugfs: Reuse binary stats descriptors")
loop for filling debugfs_stat_data was copy-pasted 2 times, but
in the second loop pointers are saved over pointers allocated
in the first loop. It causes memory leak. Fix it.

Fixes: bc9e9e672df9 ("KVM: debugfs: Reuse binary stats descriptors")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7d95126cda9e..986959833d70 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -935,7 +935,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 		stat_data->kvm = kvm;
 		stat_data->desc = pdesc;
 		stat_data->kind = KVM_STAT_VCPU;
-		kvm->debugfs_stat_data[i] = stat_data;
+		kvm->debugfs_stat_data[i + kvm_vm_stats_header.num_desc] = stat_data;
 		debugfs_create_file(pdesc->name, kvm_stats_debugfs_mode(pdesc),
 				    kvm->debugfs_dentry, stat_data,
 				    &stat_fops_per_vm);
-- 
2.32.0

