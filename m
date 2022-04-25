Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAAC50E8EA
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 20:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240251AbiDYS6u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 14:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244734AbiDYS6s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 14:58:48 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28ACF15A12
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 11:55:44 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id 15-20020aa7920f000000b0050cf449957fso6205068pfo.9
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 11:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0RIUNhOPqpB+HcP2HwzsrrOFF3qCqP329tLBYuBd67E=;
        b=YUTYT09C4kUYu097db2oy0wYcB4QiZZpF+ibqTmsgCmrs0tnYAEmD1oyhU6xNPpSDW
         5YP/UqRtFcrWZXnePhoDgo+2HnniJew9a7i7T30m1yV0NMqnuLNiQ9vOauLFB5MiMirh
         2M9cMFb6XYUpCbI+DyDG516WwrYEjHRD8UtKr9lwcOW2CpKWgaeuKrsmihegBL5WKTwm
         hG8uGNdRabATH4vdvi0yblgUk/RpebKYOCC0r56jGyO7vGyjRBJMa0diVvqm0Je7VZO9
         D9IEooRyyehKCATo7KIqh++6HsJk6p2ay6lItJX+Lo0wiKpjgrrhAyyt08AqdISWX9aE
         YwUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0RIUNhOPqpB+HcP2HwzsrrOFF3qCqP329tLBYuBd67E=;
        b=tv49WTLy7MKTJGapQ/j55eQKvoEPJA+E6sQw45N0OIL0E5llAvm8qpkQacOCC24hPR
         kNoocwJ8VDIIqtg13UwFpbfvTNTV/W93Sa3lnpBqXv6D9VoAAdayOZG+Jiouu3Sn+VP3
         pqnccps2VuRvzzWx8GfcKJEMqGs5p5FIaodBRZgw0iG6/DjC8vX8mSjQbDfRIXhY8Ntd
         u3MYE0Tg5c/XpUgv8oFE++Wp4ZDXoiMyPZnu7XeoRJ70Uk9tvNMvuuLYDcZgTJVtybud
         rabsgSjxUPTWCQxleXxMc9KgMQh3EAJHj/XhbwiIsbLdD98CcwBb0S7JlOR+VH6StwXX
         V3wQ==
X-Gm-Message-State: AOAM532BNOcy2LwxdPSB3nvl87/KWHWWhDLAaTjwM/vznZ4mEbB1bOdr
        xFctwNAqdQpReyKa7S5s4cA7iW3rnr3SXfnWt6T05nDF+iHWO+7NasWgWZlPUqs0HoBSvVbfwNw
        BisrZJDiUzphCtKXlQEVSuC8l+xV1b+4aV5bAYYczQnq2NSVySjVbNrFxJ6vFm0I=
X-Google-Smtp-Source: ABdhPJx8DPrpG0gMUTloJ8fmF2POFuQ8JOkOuYjgYs6Rc/ZB8KM3MbtQp2ca0WZCFkoAaDYMHM6jfYkmP+v+1A==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:d509:b0:15c:fd46:8db with SMTP id
 b9-20020a170902d50900b0015cfd4608dbmr9292897plg.52.1650912943558; Mon, 25 Apr
 2022 11:55:43 -0700 (PDT)
Date:   Mon, 25 Apr 2022 11:55:34 -0700
In-Reply-To: <20220425185534.57011-1-ricarkol@google.com>
Message-Id: <20220425185534.57011-5-ricarkol@google.com>
Mime-Version: 1.0
References: <20220425185534.57011-1-ricarkol@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH 4/4] KVM: arm64: vgic: Undo work in failed ITS restores
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, andre.przywara@arm.com,
        drjones@redhat.com, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        pshier@google.com, Ricardo Koller <ricarkol@google.com>
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

Failed ITS restores should clean up all state restored until the
failure. There is some cleanup present for this situation, but it's not
complete. Add the missing free's.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 4ece649e2493..200ac59edaf9 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2229,8 +2229,10 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 		vcpu = kvm_get_vcpu(kvm, collection->target_addr);
 
 	irq = vgic_add_lpi(kvm, lpi_id, vcpu);
-	if (IS_ERR(irq))
+	if (IS_ERR(irq)) {
+		its_free_ite(kvm, ite);
 		return PTR_ERR(irq);
+	}
 	ite->irq = irq;
 
 	return offset;
@@ -2498,6 +2500,9 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
 	if (ret > 0)
 		ret = 0;
 
+	if (ret < 0)
+		vgic_its_free_device_list(its->dev->kvm, its);
+
 	return ret;
 }
 
@@ -2624,6 +2629,9 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
 		read += cte_esz;
 	}
 
+	if (ret < 0)
+		vgic_its_free_collection_list(its->dev->kvm, its);
+
 	return ret;
 }
 
@@ -2655,7 +2663,10 @@ static int vgic_its_restore_tables_v0(struct vgic_its *its)
 	if (ret)
 		return ret;
 
-	return vgic_its_restore_device_tables(its);
+	ret = vgic_its_restore_device_tables(its);
+	if (ret)
+		vgic_its_free_collection_list(its->dev->kvm, its);
+	return ret;
 }
 
 static int vgic_its_commit_v0(struct vgic_its *its)
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

