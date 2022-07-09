Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8F056C69F
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 06:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiGIEVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 00:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiGIEVY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 00:21:24 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E817D643EC;
        Fri,  8 Jul 2022 21:21:23 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id r22so532795pgr.2;
        Fri, 08 Jul 2022 21:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V/wDVdyPPVBcB1yefKcLd5sdm0T+4PqhqJ52IFO1R5I=;
        b=Mq9Vi3/OJ12uq6CB3rPI5R6hgkYuMpLlHO3QMykGnT8/OwPpXe+YLMNJ/KJB+0EKBl
         DA+8lCxBgVoiT0x34zZw7DRLabxDMqBMYGhe0BS4uB05Alp44GFS8Zg1nO/9hxdG0aHn
         hWa4XeUeEPC4eIIbHLRn6OCxt7FPauItFDqURA6ME/0BsYeM9unBKFk4xcMKcxpUwLQQ
         9esXoY3Ty02zxYe0qOmypoyhqiMaqy3848l5lYYtbbrRnpc+raeeeDTdRzHetxUopfJf
         6Ldwvfk4LcyG+YwtpV6KZo8Mmkdkb9Z0fox2g0+vpxa8VY/wTiPDJMxUWe+SGDxlaV3V
         MPew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V/wDVdyPPVBcB1yefKcLd5sdm0T+4PqhqJ52IFO1R5I=;
        b=SdhsfwgRNfp52ckF7tpVaLLBRp9pquQyIm9cHYLS4pgC86tVxXzgkUjXTIxZNUdcYj
         6eAgtUoiZAbA31BGDueyJaw+t+Yn9EcyOVdPvhiomE+U7nDTmXA2xrXkK5F2qJy0LV3B
         VIMm6p2ZQ8rObxIUN3jGmSeYrUGdGRw6vRI2sjyag+wI0/fX59eCCPsW2cAqWtdykh6C
         tsPIFSPJkxwL5BnnRqPdkAbYRfMcaS+c/tlJseUOy8j3fZwHK2AlaGojwRFSoYs8yCMq
         X9W89lqvafMTK6mc1eEdKsY/GqjZaGDUyoSDRqQRHqYoWY3BVwu19+Gf3OiXqZeeZ0xt
         ZgUw==
X-Gm-Message-State: AJIora+YtBSutEJaz1ROBCu/Z451gbRowyHGQPDiYtPMpZxQmnb45JRo
        5VrAhGACpd27NPmu85Enlv0=
X-Google-Smtp-Source: AGRyM1seTB3wYYjlVq9trAZ01j1wiacWJMkiimYvYccMbc+uIihWK6yIR/pj2gHPY259ns+As8O0oA==
X-Received: by 2002:a63:c21:0:b0:412:22fa:6cdb with SMTP id b33-20020a630c21000000b0041222fa6cdbmr5940431pgl.423.1657340483479;
        Fri, 08 Jul 2022 21:21:23 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-88.three.co.id. [180.214.232.88])
        by smtp.gmail.com with ESMTPSA id d8-20020a17090a7bc800b001efa332d365sm236966pjl.33.2022.07.08.21.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 21:21:21 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 0D7101039BC; Sat,  9 Jul 2022 11:21:11 +0700 (WIB)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH 12/12] Documentation: kvm: Add TDX documentation to KVM table of contents
Date:   Sat,  9 Jul 2022 11:20:38 +0700
Message-Id: <20220709042037.21903-13-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220709042037.21903-1-bagasdotme@gmail.com>
References: <20220709042037.21903-1-bagasdotme@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TDX documentation files under Documentation/virt/kvm/ are missing from
the table of contents index. Add the missing entries.

Fixes: 471b5bf12a3728 ("[MARKER] The start of TDX KVM patch series: TDX architectural definitions")
Fixes: 9e54fa1ac03df3 ("Documentation/virtual/kvm: Document on Trust Domain Extensions(TDX)")
Fixes: 7af4efe3263854 ("KVM: x86: design documentation on TDX support of x86 KVM TDP MMU")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/virt/kvm/index.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index e0a2c74e1043a0..f368a4625aa902 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -18,3 +18,7 @@ KVM
    locking
    vcpu-requests
    review-checklist
+
+   intel-tdx
+   intel-tdx-layer-status
+   tdx-tdp-mmu
-- 
An old man doll... just what I always wanted! - Clara

