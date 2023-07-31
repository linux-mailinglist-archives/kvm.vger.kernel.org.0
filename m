Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6917B76952B
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 13:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbjGaLrd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 07:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbjGaLrb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 07:47:31 -0400
Received: from mgamail.intel.com (unknown [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BB5E52;
        Mon, 31 Jul 2023 04:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690804050; x=1722340050;
  h=from:to:cc:subject:date:message-id;
  bh=BuF2V2QBl8j3/eWUrzyOnJ939tHmLzmjmmYv3gOvdPY=;
  b=bBs2dApMTONX+CQ3cehD3N92FZ9GgielIGlF1RFiPF9lnolkBgYhHf0Q
   AtQB5paTaRX6yMojFJ3n4JanHEmExk9cLBl9163a92F46Cv9WNYdxD0O+
   /xPaXTR+uECC4PVf5YtfBAyOTJ/OUdu+S5m9J+2Sqd56Z/ZhZyf/MlRzC
   GpfV8FszuAeEC1+3zsti6HNRY3qMGDYYt4JdAn3fJB3w3R3oS4xOXYDW4
   X9Ou98yW3gat7Ga5L+q5H8snIMPgzowt6NV5D328QVb3ZiadlCBXbYsag
   +AHFeTmRjX2fdGePg/4p8dON8QInYC4rYch5WS8UqnpJ1iBrPJ7lv6Utd
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10787"; a="372624147"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="372624147"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 04:47:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10787"; a="763357271"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="763357271"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 04:47:28 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org
Cc:     zhenyuw@linux.intel.com, zhi.a.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH] drm/i915/gvt: Fix bug in getting msg length in AUX CH registers handler
Date:   Mon, 31 Jul 2023 19:20:33 +0800
Message-Id: <20230731112033.7275-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Msg length should be obtained from value written to AUX_CH_CTL register
rather than from enum type of the register.

Commit 0cad796a2269  ("drm/i915: Use REG_BIT() & co. for AUX CH registers")
incorrectly calculates the msg_length from reg type and yields below
warning in intel_gvt_i2c_handle_aux_ch_write():
"i915 0000:00:02.0: drm_WARN_ON(msg_length != 4)".

Fixes: 0cad796a2269 ("drm/i915: Use REG_BIT() & co. for AUX CH registers")
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/gpu/drm/i915/gvt/edid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gvt/edid.c b/drivers/gpu/drm/i915/gvt/edid.c
index 2a0438f12a14..af9afdb53c7f 100644
--- a/drivers/gpu/drm/i915/gvt/edid.c
+++ b/drivers/gpu/drm/i915/gvt/edid.c
@@ -491,7 +491,7 @@ void intel_gvt_i2c_handle_aux_ch_write(struct intel_vgpu *vgpu,
 		return;
 	}
 
-	msg_length = REG_FIELD_GET(DP_AUX_CH_CTL_MESSAGE_SIZE_MASK, reg);
+	msg_length = REG_FIELD_GET(DP_AUX_CH_CTL_MESSAGE_SIZE_MASK, value);
 
 	// check the msg in DATA register.
 	msg = vgpu_vreg(vgpu, offset + 4);
-- 
2.17.1

