Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77E9B502FA7
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 22:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345491AbiDOUSU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 16:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244871AbiDOUSS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 16:18:18 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1562A3B287
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 13:15:50 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id b15-20020a05660214cf00b00648a910b964so5323315iow.19
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 13:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/w+lI2clq4aNvOBAeM7isWx8sEkr2kSrYxVwFxgdH8c=;
        b=PTb/sr8g/+4WvlVNyz1ZQ16eC0D/jMtPUZOzTMdo30fC7qDZJ3N+DJU4ag58CGX+Kb
         n2/yTJpFO84bciYqJJN8jguqU8y4v8T9M5vsOjExn1Jxoy+GViUWdBS32oHP0C0TGdvT
         T30F2O2h/JS6L8vldgGZwowmLlud+OTUNOUajIn1+XItVq10zDYw5HXShHfdf81XutPl
         IJ9abUzriaLGciLZHolzxnhuCj6GEG20xEiYTw2VXbT4vV2qSVnktSZqvu+7eaogcyPb
         LTY/+JDglaqfXrR2ra/EK9BA2CAAzYx6AZxzKJ2E9+a1US+ZnlbYXdqfWScNocFyu9Hb
         ByQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/w+lI2clq4aNvOBAeM7isWx8sEkr2kSrYxVwFxgdH8c=;
        b=yID0lOv7ftwI8CDPvzWtWQCrjHeJuHKpeeCPaQHcNdHgKUHKkPX3nEVcdbdPje7T57
         wa+t4KSyuKTK/lh9HT4+1AWM33WmbYS6CxISxlY14RSHilh5Xbbt9qR8x2/ybrSo7xYL
         p/LbIE6dZztoLs8KTOF60aOkBtArk1GzIZbd8mK6tVb/kY0GF9dIahv3UYUFyu9RJYeD
         NcuXDi3bXfxfJ+v5x2JnuvPcmrr6gn4Aq4VArK0Jg4X0dMFOIyEiHbR8y/Ni7m8l9rV5
         KHI4OOFZ86CpdknzEhjtY1nUSeJWpto4+Oa7c5Xa+KSce338qmswJizbhtA9pZ3+lClU
         vyEg==
X-Gm-Message-State: AOAM533FuOf11o32ULvfjILegXQRo9lUv+I7VuNi9FhEMlCKhRQcvWcz
        g3uB/AIRU+kwpdWinANEgj51LZCZz9U3Uc6r2y2RCa9qLs0wJ3GKaI6T/sneWFQfrdB+AplVg/F
        nw+yMwPEmEJatQcecMMR0tOIc5sv65zBTEuai6X8I51hyk1sRnuLyPt0VsA==
X-Google-Smtp-Source: ABdhPJytbJcWTyREI5pIGYxtYH7uU6jRUcLhUJUmVsFvBMtpc5jJDsv51yk6RHwLISubEgAAn4yoS5KyWGQ=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:9999:0:b0:314:4a83:ac2e with SMTP id
 a25-20020a029999000000b003144a83ac2emr310808jal.37.1650053749367; Fri, 15 Apr
 2022 13:15:49 -0700 (PDT)
Date:   Fri, 15 Apr 2022 20:15:38 +0000
In-Reply-To: <20220415201542.1496582-1-oupton@google.com>
Message-Id: <20220415201542.1496582-2-oupton@google.com>
Mime-Version: 1.0
References: <20220415201542.1496582-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH 1/5] KVM: Shove vm stats_id init into kvm_create_vm_debugfs()
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, maz@kernel.org,
        kvmarm@vger.kernel.org, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The field is only ever used for debugfs; put the initialization where
it belongs.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 virt/kvm/kvm_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d292c4397579..ec9c6aad041b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -955,6 +955,9 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 	int kvm_debugfs_num_entries = kvm_vm_stats_header.num_desc +
 				      kvm_vcpu_stats_header.num_desc;
 
+	snprintf(kvm->stats_id, sizeof(kvm->stats_id),
+			"kvm-%d", task_pid_nr(current));
+
 	if (!debugfs_initialized())
 		return 0;
 
@@ -4765,9 +4768,6 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 	if (r < 0)
 		goto put_kvm;
 
-	snprintf(kvm->stats_id, sizeof(kvm->stats_id),
-			"kvm-%d", task_pid_nr(current));
-
 	file = anon_inode_getfile("kvm-vm", &kvm_vm_fops, kvm, O_RDWR);
 	if (IS_ERR(file)) {
 		put_unused_fd(r);
-- 
2.36.0.rc0.470.gd361397f0d-goog

