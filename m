Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F7D6549EA
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 01:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235507AbiLWA57 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 19:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbiLWA5x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 19:57:53 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99B821899
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 16:57:52 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id j18-20020a170902da9200b00189b3b16addso2393504plx.23
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 16:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=d+Q/YQeHZWJ0vREmMTQabuLJv/+4O5g7zAHpbuOFGTs=;
        b=cGB2Kk6wNWNAIq0pn/lG31LZ+jy1BxxG22XBitcS8CWDmp2z4Lhdnef0BGcAm+RvUh
         dJmcq7R+7SuGck4PuyUeyUCJkW65Lvfi9fboC8f7g9EVEpDN857mWJxXqLgFMLrQWGln
         Kjecvsk3TvvJ2gGLKH55SZwSxBxEOcPg0oFfMnU/R5GleViIAv1XjeCPLyU1wTWSJK2S
         +iS3t0vV/qEduOYgT/AES8Jul3ZiXXRXD3dl2cOxJsXpYTudq3EXtRTOFEi2bF+1egWF
         QP48ZSSaeO6lXbbjEfyK0KsD6kqL75R5X9rhhYcXTnDt3mgITCArhWecSITrbyBZ+xt2
         3VTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d+Q/YQeHZWJ0vREmMTQabuLJv/+4O5g7zAHpbuOFGTs=;
        b=dcoQuyarL6KuozyXkKyhWPaY24QH8SqRGktpKmofcGF9amn8RhlBRaePdaerwrdQdJ
         dTCpkihMbcIUTnAlh5TZWuZturpPTDgiJrldRUz/USQWb8rd2bDt/fXRC/wi+e5hXo0L
         MYyeW/1hNanebuWvItiiC03j4UdnG1h0qJU8YdNciEc3gZ5UpN8E9BJiW/YvZru0uB2K
         1TexuknZMBsgNNZBpmSwHr117Q2ZIjMtyHqS12w7GwYeH8WmuHNL1+WJs1XiVcTXnU8I
         BrhLmW3wzTqBLu379c2oySnCYsIoW5dV/wW44kC+3eAgSq6opyuIgZ/Qswv2cPuw/bDd
         BzbA==
X-Gm-Message-State: AFqh2kqsUmER4hG983tlK1r5poWoSd2NhMKBvKWewjA2arOy6A/kpvJ7
        K86aT35TN8Lc4xQnkd7sYkciOc6LlYo=
X-Google-Smtp-Source: AMrXdXs1Xo/ZikoJFeArKRToXLGYmJLPRFbPAWwxlzpvnOIeRODeOddNaO6jwczXdcof/QkZXUFwsMJdkN8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:701:b0:219:1d0a:34a6 with SMTP id
 s1-20020a17090b070100b002191d0a34a6mr180782pjz.1.1671757072021; Thu, 22 Dec
 2022 16:57:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Dec 2022 00:57:16 +0000
In-Reply-To: <20221223005739.1295925-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221223005739.1295925-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221223005739.1295925-5-seanjc@google.com>
Subject: [PATCH 04/27] drm/i915/gvt: Verify VFIO-pinned page is THP when
 shadowing 2M gtt entry
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
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

When shadowing a GTT entry with a 2M page, explicitly verify that the
first page pinned by VFIO is a transparent hugepage instead of assuming
that page observed by is_2MB_gtt_possible() is the same page pinned by
vfio_pin_pages().  E.g. if userspace is doing something funky with the
guest's memslots, or if the page is demoted between is_2MB_gtt_possible()
and vfio_pin_pages().

This is more of a performance optimization than a bug fix as the check
for contiguous struct pages should guard against incorrect mapping (even
though assuming struct pages are virtually contiguous is wrong).

The real motivation for explicitly checking for a transparent hugepage
after pinning is that it will reduce the risk of introducing a bug in a
future fix for a page refcount leak (KVMGT doesn't put the reference
acquired by gfn_to_pfn()), and eventually will allow KVMGT to stop using
KVM's gfn_to_pfn() altogether.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 714221f9a131..6f358b4fe406 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -159,11 +159,25 @@ static int gvt_pin_guest_page(struct intel_vgpu *vgpu, unsigned long gfn,
 			goto err;
 		}
 
-		if (npage == 0)
-			base_page = cur_page;
+		if (npage == 0) {
+			/*
+			 * Bail immediately to avoid unnecessary pinning when
+			 * trying to shadow a 2M page and the host page isn't
+			 * a transparent hugepage.
+			 *
+			 * TODO: support other type hugepages, e.g. HugeTLB.
+			 */
+			if (size == I915_GTT_PAGE_SIZE_2M &&
+			    !PageTransHuge(cur_page))
+				ret = -EIO;
+			else
+				base_page = cur_page;
+		}
 		else if (base_page + npage != cur_page) {
 			gvt_vgpu_err("The pages are not continuous\n");
 			ret = -EINVAL;
+		}
+		if (ret < 0) {
 			npage++;
 			goto err;
 		}
-- 
2.39.0.314.g84b9a713c41-goog

