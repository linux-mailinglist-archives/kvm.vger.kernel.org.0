Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850C25209EC
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 02:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbiEJAUo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 20:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233430AbiEJAUk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 20:20:40 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E932B50E39
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 17:16:43 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id s68-20020a637747000000b003aaff19b95bso8053309pgc.1
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 17:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QD0NrA0rKRp0pec8KTI6IW9xj1xL+jmM30atKcgc1k8=;
        b=IsPJS7H00adX3QCpXSD/mei1YnsTS2t4N0eGi1xaHGFE9rvLkH7wtUefVUaJfrzn2p
         10u5MV81UqQWp3TpHepR6qIEBLGeFmlK0kDu2Kt0BEc1l5jB+ODl1tq//5JLEFO4wbaT
         7KRRS+4714+Dzjthcko2VpxIjKNWkKbe7MEf1NPZoCBOzC7ijO+aAvZSqhnQr9JcxpYF
         +TZ9CyIGWmQXW6DZt9E+Ggsp1F88nhlZhYws0RTap6rjuNvr9klcWR2CgcYO2rS9wxtz
         SgY/DIZ1ud9YikCUqrQPR2gp6+hlA1XGmcXhy+0266rdssKkbAp8XzxMvoK4snDkZciU
         Jmkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QD0NrA0rKRp0pec8KTI6IW9xj1xL+jmM30atKcgc1k8=;
        b=O2CoD6jsV70COx4yZ+G0V3TbhBZJlk2tIrxoh32x1RoGo2QPu/TtcYRyij7XOz5o+2
         4QGv62KBbHbFU/G1Zj9kOw1KLZKV1vYtEU6IOZ5N9Ry+uXguqwT5xN9jQheUMfoDoe9C
         jUumy7wdlp+jDiNSp9oxnAlIpzcOda+c6veIUaAvADtQDZq4Wu/eVZ8m4oml++hf/afh
         7POugaJWDWn4yU08HoXNtkcjOUwqA+NuI+DH5cFAgtXHs/UvA0N/5jptmH6fEJYFOFaJ
         IUHS+4dRITcYxeyO6YflnQkzeLdIrVwyFOlwH45GCbZHU7Tp4qhyI/jnNT6ZSakRG+n+
         OofQ==
X-Gm-Message-State: AOAM530OtwGFBbK4lwPGpVVt/gtzGmn7xBlW0sDnL7VGbu8DPQiOoNYQ
        utd9eULaW624EImO260ncbW4bEkI91fHN9nrjBUUtIrmzfcyfcpO5CwEl3jrYTSVQY9syGr9VpN
        E41Xn+Lj5hnx9TJOVLoth5TJ5+WJr4UV3yQb4eGi97wAtaEJ/ZhoUEWvKvxyqUew=
X-Google-Smtp-Source: ABdhPJxEsqmOiWFXOmG9gfTVXmnMY2awFbxdCsS4fVflAyYeQ7zgfAEbrQ7Klo1c6Bx3gWtqokF0wyTe4W0ZOQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:15c2:b0:510:6d56:730 with SMTP
 id o2-20020a056a0015c200b005106d560730mr18178625pfu.62.1652141802619; Mon, 09
 May 2022 17:16:42 -0700 (PDT)
Date:   Mon,  9 May 2022 17:16:33 -0700
In-Reply-To: <20220510001633.552496-1-ricarkol@google.com>
Message-Id: <20220510001633.552496-5-ricarkol@google.com>
Mime-Version: 1.0
References: <20220510001633.552496-1-ricarkol@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v3 4/4] KVM: arm64: vgic: Undo work in failed ITS restores
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, andre.przywara@arm.com,
        drjones@redhat.com, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        pshier@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Failed ITS restores should clean up all state restored until the
failure. There is some cleanup already present when failing to restore
some tables, but it's not complete. Add the missing cleanup.

Note that this changes the behavior in case of a failed restore of the
device tables.

	restore ioctl:
	1. restore collection tables
	2. restore device tables

With this commit, failures in 2. clean up everything created so far,
including state created by 1.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index f34e09cc86dc..b50542c98d79 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2219,8 +2219,10 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 		vcpu = kvm_get_vcpu(kvm, collection->target_addr);
 
 	irq = vgic_add_lpi(kvm, lpi_id, vcpu);
-	if (IS_ERR(irq))
+	if (IS_ERR(irq)) {
+		its_free_ite(kvm, ite);
 		return PTR_ERR(irq);
+	}
 	ite->irq = irq;
 
 	return offset;
@@ -2485,6 +2487,9 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
 	if (ret > 0)
 		ret = 0;
 
+	if (ret < 0)
+		vgic_its_free_device_list(its->dev->kvm, its);
+
 	return ret;
 }
 
@@ -2615,6 +2620,9 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
 	if (ret > 0)
 		return 0;
 
+	if (ret < 0)
+		vgic_its_free_collection_list(its->dev->kvm, its);
+
 	return ret;
 }
 
@@ -2646,7 +2654,10 @@ static int vgic_its_restore_tables_v0(struct vgic_its *its)
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
2.36.0.512.ge40c2bad7a-goog

