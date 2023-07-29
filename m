Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74CBF767AE1
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237491AbjG2Bf4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237390AbjG2Bfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:35:53 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A953C1D
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:35:50 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-585f254c41aso4631427b3.1
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690594549; x=1691199349;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jEX944Eq3FR7IMm0zyV2J78IA1pYMR7a1LBZmsndkp4=;
        b=EusHJXExcAmxW94p+Y+WzpBoXgOHGapVubepNLVe1AjQFq4L5DyiXFwSfT7lAKZP2B
         LbstAlazYFqIHYNHWE9V6nKli4q5Y0K2fyfD216QZG3evAmQp6EgzhArMOhsjP2D0ElV
         B6qwPZ9a/i9In0E55fHIM4mb9ugp3zYDctkxuHsv6F88IcOYAE2VED+v+Lk/ZmoPYG/2
         lkQCY3PhAbTRH+u8Ae/SnMEwzw13MNUKDcBi0qG4LXNUvbTFAvrgKXodpE6AzSf38TDQ
         sMQJ+cT1fMFi0cUz1wu0ff5mLmSDncQAQiHhjP1MSwt+Xyt6OmHxozc9Cly/LUlxpBCN
         YceQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690594549; x=1691199349;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jEX944Eq3FR7IMm0zyV2J78IA1pYMR7a1LBZmsndkp4=;
        b=Qy9VoUpw+Z+lADQwHlTwaZoEfy6Y5bkf60Gw2ZROlm7C4UgdZU8x4uBkIjEChrezmW
         HvYsswqqncIU6xRNniHrBLSNSOvOhhpbl4jUuz1T1hRFRSggL5dx8JpzwmhjuRWHW6Md
         j5swNoWMiwCWhY/RyaQRa6GzpR1sp9wlb9Uw12up/26pBN3UUIePRREON1963pygebXn
         Whj7ycZ3wiFKYTd2SWhBwNV5QfUlfOxf8JXUGaq5v50mc301qOzoQSsI6EOpgmjX5HmG
         apQfOHc29Rhsr+qqndwRLYhdjJb3j318RI+OBDYN+lvyifOunO9dn8VuQcDeZHyPzj6Q
         vXdA==
X-Gm-Message-State: ABy/qLbvJzXdyRvctyoqomhyqfTUpiAnI8cOnqukT1crO8OhhLbkimUm
        yf2HR6CSU3kmVmo/vwUkF1oLxMU0yx4=
X-Google-Smtp-Source: APBJJlHaMJ266s4owvydBsGasNevM0zaMSoOGKTU1pN9RjVzgaKXC6MzhQvAdGBBorhN1PRis7f6VXl7qB0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:af03:0:b0:583:9db4:6c20 with SMTP id
 n3-20020a81af03000000b005839db46c20mr22745ywh.1.1690594549610; Fri, 28 Jul
 2023 18:35:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:35:09 -0700
In-Reply-To: <20230729013535.1070024-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729013535.1070024-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729013535.1070024-4-seanjc@google.com>
Subject: [PATCH v4 03/29] drm/i915/gvt: Verify hugepages are contiguous in
 physical address space
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Yongwei Ma <yongwei.ma@intel.com>,
        Ben Gardon <bgardon@google.com>
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

When shadowing a GTT entry with a 2M page, verify that the pfns are
contiguous, not just that the struct page pointers are contiguous.  The
memory map is virtual contiguous if "CONFIG_FLATMEM=y ||
CONFIG_SPARSEMEM_VMEMMAP=y", but not for "CONFIG_SPARSEMEM=y &&
CONFIG_SPARSEMEM_VMEMMAP=n", so theoretically KVMGT could encounter struct
pages that are virtually contiguous, but not physically contiguous.

In practice, this flaw is likely a non-issue as it would cause functional
problems iff a section isn't 2M aligned _and_ is directly adjacent to
another section with discontiguous pfns.

Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index de675d799c7d..429f0f993a13 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -161,7 +161,7 @@ static int gvt_pin_guest_page(struct intel_vgpu *vgpu, unsigned long gfn,
 
 		if (npage == 0)
 			base_page = cur_page;
-		else if (base_page + npage != cur_page) {
+		else if (page_to_pfn(base_page) + npage != page_to_pfn(cur_page)) {
 			gvt_vgpu_err("The pages are not continuous\n");
 			ret = -EINVAL;
 			npage++;
-- 
2.41.0.487.g6d72f3e995-goog

