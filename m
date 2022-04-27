Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAF35121EA
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 20:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiD0TCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 15:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbiD0TBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 15:01:45 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB2CA94C5
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 11:48:23 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id b6-20020a170902d50600b0015d1eb8c82eso1429294plg.12
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 11:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=h6i932oX/jFZxDeCgPoTJkzP+yH7aYfI+DgBzirxODs=;
        b=QIZgIEqufTlsX6ImsR51+hEPqbxHx3Yf30qGjXgSYPJCBVtJj4VFyxlmGt4GLy2fme
         O8v20Qbl7rUGzQVhQvtgICDH36pYKZjiSHCDic9hjSujDY59PrB6N3ef3LAwDSvgCCgY
         LoDThBX9JNQmVC4vz9ZOE3BzD8QhP9UVJnKsnh3PPZE0I9Q+BVwlhA+BW/nCI7HMuwKI
         QMvn2o5vyv7eFxrsRZ1DJlK1ewKninzZ2J5mX9C86VZFH4ZQW5rVGEOiB8xlMJiDT3YO
         Yjj/Ska9kuvKyxC9bgoavvCxoPprqgGd1e3PNCk21QMX6meNtLRxdo9IOkIDrzCiubzM
         v50A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=h6i932oX/jFZxDeCgPoTJkzP+yH7aYfI+DgBzirxODs=;
        b=B5n9Ja7TVmnuvU+qkWjKkQFKDn0681rgHPRtFEZxcefVPYS6dpVZEooUQ60QJzemcd
         CAf0HyNsS8Se/Accn7UhK4J/pOGIQ/VACxjm1RJNxne3zr7RkcsO3xj6qRylf0J/dsp2
         iWrH7n8xmGdVXNRu9DGkmyu2c2fHQW751Ss9lRFwv1qdpIOliP4Xck0lKL251UkgzgQ6
         0P/flWTxJi/f8BYSOIft949vAlmy1xoG8YsDiLmJ3SrZw6+AvyXWMRUrkKyy1c71okSd
         bDvGYkl3YaAMS/H/2lDjdFa8NoaDr4SjyEY3sV018z6rk1Lle0LBMffV26P5pVRg6pmO
         7nEA==
X-Gm-Message-State: AOAM531wyzBob/RK+NuyJo++VWh2WTJjfXtkmGp4cf9mRPqCUJ3RXHgv
        YikgQOzPP+EBNrHDyUh1sb58biWJGvWwpdFzz/9jl6TERp9GXFFJ6KW5kEdMoOAPxgxlao8ZEh7
        YZqWT0XshIhwgqofiYTnL33DRxcQMYb2zUMktQKdV3b4pVA5sPFdXCAtV+3+Q6gE=
X-Google-Smtp-Source: ABdhPJzNqPfb/x+YKrEsZ3li+cQ0pLyAnvLP4bZGKCHDHyL9eXtfLjRh5cZ+nMHDNIO+Th6alnvjKnACtR2EJA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a62:1e03:0:b0:505:64c1:3e19 with SMTP id
 e3-20020a621e03000000b0050564c13e19mr31675138pfe.32.1651085303160; Wed, 27
 Apr 2022 11:48:23 -0700 (PDT)
Date:   Wed, 27 Apr 2022 11:48:14 -0700
In-Reply-To: <20220427184814.2204513-1-ricarkol@google.com>
Message-Id: <20220427184814.2204513-5-ricarkol@google.com>
Mime-Version: 1.0
References: <20220427184814.2204513-1-ricarkol@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v2 4/4] KVM: arm64: vgic: Undo work in failed ITS restores
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
failure. There is some cleanup already present when failing to restore
some tables, but it's not complete. Add the missing cleanup.

Note that this changes the behavior in case of a failed restore of the
device tables.

	restore ioctl:
	1. restore collection tables
	2. restore device tables

With this commit, failures in 2. clean up everything created so far,
including state created by 1.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 86c26aaa8275..c35534d7393a 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2222,8 +2222,10 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 		vcpu = kvm_get_vcpu(kvm, collection->target_addr);
 
 	irq = vgic_add_lpi(kvm, lpi_id, vcpu);
-	if (IS_ERR(irq))
+	if (IS_ERR(irq)) {
+		its_free_ite(kvm, ite);
 		return PTR_ERR(irq);
+	}
 	ite->irq = irq;
 
 	return offset;
@@ -2491,6 +2493,9 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
 	if (ret > 0)
 		ret = 0;
 
+	if (ret < 0)
+		vgic_its_free_device_list(its->dev->kvm, its);
+
 	return ret;
 }
 
@@ -2617,6 +2622,9 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
 		read += cte_esz;
 	}
 
+	if (ret < 0)
+		vgic_its_free_collection_list(its->dev->kvm, its);
+
 	return ret;
 }
 
@@ -2648,7 +2656,10 @@ static int vgic_its_restore_tables_v0(struct vgic_its *its)
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
2.36.0.464.gb9c8b46e94-goog

