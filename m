Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AECC9701328
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 02:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241533AbjEMAgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 20:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241229AbjEMAgX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 20:36:23 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 068265FC4
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 17:36:17 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-643aad3bbf3so5480234b3a.0
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 17:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683938177; x=1686530177;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=K7Ya3jZlcB5DIRxzkVo+FZAIt5xtGXopE24BSYXVJKk=;
        b=XGrwjfzUB5Z1Jr54Bh0GK3KWvn+DCPj5RUIT8j+z/Np9og8cN1KchmZJeni93Uvy7s
         diX49O5EZtEAZDH2WnfFLiyblqMGn3njDBFEEx4TsGcwwfWlJUozJCqrroNvuCoxbIYz
         J0FqR0PoQrdGlfChocEzL4ehm6rj3oVBLYzpxsgigepwA3t/aWUQalt82flPm5MqOlRV
         yvOJrlvI7bNR8cuw6XxGtB9scFveudIqc6MylQO/+aUTS/d8dFu3I5ONlqZkRBCavgOK
         RZZqzwsCiukW+fDl2ye5ropvD2aVluFjExuqqI/dhyiqhNsRe/dsALVzXvEPG+ETz5qV
         D3rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683938177; x=1686530177;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K7Ya3jZlcB5DIRxzkVo+FZAIt5xtGXopE24BSYXVJKk=;
        b=cDsDnbKEg0pzYXh8kHz0FyfaO29RREtkRxg5LA5k+aLtKDLIz48bdU4LxwxICgEzEY
         uVOwpq5f0COjowixdPXwX2pafvDXpt5UiIBY41RKbjWAVnSNTel/k8TZDAnfibqlSNeb
         N0n0mDfAqTb/Ub5oClSYhOm0lyiWjoOpM0TTy/S9IWbNXafkGSckIiGf+3P8yV6Ua7z0
         SQre3Bzz5pyNcYTo6t9Fi0aY2nir3FlsAS9rygzMoKOVLZHkgc+RRRX/muDQFKH7QUk5
         zeDLOCk+IzwloXSNhAG7xqj2CN8qSaHwZiKF8VAjs5XcnFij+Lv3ut2aGwIK1obDy5hZ
         aE7A==
X-Gm-Message-State: AC+VfDwriIK3FY6QNOTtZ6OPR/xT5kKN2MHdrhZWTA7klf533vlWcJwJ
        hXhaKUvaTN3p3r9LBi0SJdsNB2Pl+n4=
X-Google-Smtp-Source: ACHHUZ6rw3ymcV2J3+x78P6uQz6mtkbxujPRSeirm0OG2Uoo/pYeAsqh0YVKR+ziA21mJLEFCY5YXAXWSGI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3a8:b0:643:ae47:9bc0 with SMTP id
 y40-20020a056a0003a800b00643ae479bc0mr6493792pfs.3.1683938177325; Fri, 12 May
 2023 17:36:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 May 2023 17:35:38 -0700
In-Reply-To: <20230513003600.818142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230513003600.818142-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230513003600.818142-7-seanjc@google.com>
Subject: [PATCH v3 06/28] drm/i915/gvt: Error out on an attempt to shadowing
 an unknown GTT entry type
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bail from ppgtt_populate_shadow_entry() if an unexpected GTT entry type
is encountered instead of subtly falling through to the common "direct
shadow" path.  Eliminating the default/error path's reliance on the common
handling will allow hoisting intel_gvt_dma_map_guest_page() into the case
statements so that the 2MiB case can try intel_gvt_dma_map_guest_page()
and fallback to splitting the entry on failure.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/gpu/drm/i915/gvt/gtt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
index 2aed31b497c9..61e38acee2d5 100644
--- a/drivers/gpu/drm/i915/gvt/gtt.c
+++ b/drivers/gpu/drm/i915/gvt/gtt.c
@@ -1306,6 +1306,7 @@ static int ppgtt_populate_shadow_entry(struct intel_vgpu *vgpu,
 		return -EINVAL;
 	default:
 		GEM_BUG_ON(1);
+		return -EINVAL;
 	}
 
 	/* direct shadow */
-- 
2.40.1.606.ga4b1b128d6-goog

