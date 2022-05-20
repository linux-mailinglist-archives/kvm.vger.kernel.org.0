Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED55C52F128
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 18:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351949AbiETQ5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 12:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351933AbiETQ5Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 12:57:16 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B7D14A246
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 09:57:15 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id i1so7841233plg.7
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 09:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6SpNaB2y1Al28S6NM7uzx+ecVRdfZl8NU3/XOGW88bQ=;
        b=FlSBAkr4ofMj/1FfrjZdKJHGWxG5It1GsGUnToRA0ztAQWucRqPq4eJCdV9rBICATG
         p22NWsd07otLxl9qy0pg3FlOUwx8PnAG1t198y4QkGLfPzgimEVAMvWu2HQG70OGWgdS
         rWLo2Ju0uuDXL89mk3bvO92g5uE8YJGwBQ3Q4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6SpNaB2y1Al28S6NM7uzx+ecVRdfZl8NU3/XOGW88bQ=;
        b=AUPmW9QD7wcFUjXzkDTKzNE0Dl8KvYyqLOh90ASxBGilEub/7uF+KV/QnFbQGaiMc7
         wOu5nNydojMOgXFXttw9hV25CVxkyVkZP+64HRBZYhRYh7eyvjKlujd07vr+liNjZW9o
         7KcBL4P3g1ZmHpbJohZSmC0yqM9nUuwvt7p+q+7M7q6LP6vIlz0ZKFRxVMiT2TcHhLiV
         OO3y2FclLf1TDTde83L72NgX4Outa+phIGAmdc1i0arJ/5lRTEJH9FoGQAYBBqrV+0GO
         F0qlDQAJab5niWscQBlZZTCZk7/5OPO+cKzrfB5crqcCT+iofa/WeC9QSf0HNiimnhVv
         c9qw==
X-Gm-Message-State: AOAM532Ol5dysLfiRbvennbMxQclDpb8gmosrX8i7+THrMot1UkrHR7F
        WkVLXWlNd5iaq2Q6vtm9msa0fA==
X-Google-Smtp-Source: ABdhPJxkVZRhHdGR5NDul9Khe/5JxygEEdSRxZBEPGrG33xqgtDPzhBAR+c7Iv2CIauYTn5mEid49Q==
X-Received: by 2002:a17:90b:1a8c:b0:1dc:1c62:2c0c with SMTP id ng12-20020a17090b1a8c00b001dc1c622c0cmr12594751pjb.140.1653065834734;
        Fri, 20 May 2022 09:57:14 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id e21-20020aa79815000000b005104c6d7941sm2060007pfl.31.2022.05.20.09.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 09:57:14 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] KVM: x86/emulator: Bounds check reg nr against reg array size
Date:   Fri, 20 May 2022 09:57:04 -0700
Message-Id: <20220520165705.2140042-1-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1901; h=from:subject; bh=JJuMLpa4bRxd+XIVXJHSB00fFvogB4eo+vqKcUS+E5c=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBih8hg9y6m79FVwywHWrIpyRZj+n8gfvE1kdQ4vttq CxUDwHGJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYofIYAAKCRCJcvTf3G3AJtHhEA CJetvbOuFyM9hM1wpAXtchIPly9FkjVoOpZjYYW1QuSIQo44/BvNeHZFgtxmVE3BGchr2akYhClwI1 nTy/7bc8Z/i6DFUm6mF0VpTt0Sj32XouSRJb8goy+KJNCO9mn0AaJFfOLkDysFXw98ov7nAl3TrICA 7wXEzs7MPwStZ+Eg3Fod2/LmHSNCyPjgVwguQAPJY2y820fqEWhr58sH6d/hQeSqRZ9/V3N+NM9+Z8 wVEOxxBwVUkzqYUYEq4BavHyE2qUfMpCEUgu9ijb/b+x9/ekkWVFb6/nIQ+KDMKc9bFrAFjJbUrqFp 4XsOUjfjJQXz04M1TibNo0mCM22Ph10iUFlXxYIMpa6kcHkVAnGDU6H2tiGst+/H7j9LjL6+sLFoHE f6uBS262o12sISPjZJP4MzsnmMbJAmoqtpEU/Ws/bIf3VDoB0HLdd7MVOLGk5FH20k+RnLy/GDR2bm zNkBmURh2qIWVrUtbWyNZaM3mpVWY0LQGcUfBYKzRMgPFwl92+nyVeptwm6yaVjTndDHqE7aPBxpVz oW+pJ2XsLw+/GHfLO46BNH9VH3hMBmsDZBcNjriHMERtI97JI6UO/RowyS22w48uZwAu7+nYUlWum7 v0TUYX74ldqPWaE9gjBI2b+XcHC9ERv93e/aHHQ7TvsfTV22SA5aqoQy1mlw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

GCC 12 sees that it might be possible for "nr" to be outside the _regs
array. Add explicit bounds checking.

In function 'reg_read',
    inlined from 'reg_rmw' at ../arch/x86/kvm/emulate.c:266:2:
../arch/x86/kvm/emulate.c:254:27: warning: array subscript 32 is above array bounds of 'long unsigned int[17]' [-Warray-bounds]
  254 |         return ctxt->_regs[nr];
      |                ~~~~~~~~~~~^~~~
In file included from ../arch/x86/kvm/emulate.c:23:
../arch/x86/kvm/kvm_emulate.h: In function 'reg_rmw':
../arch/x86/kvm/kvm_emulate.h:366:23: note: while referencing '_regs'
  366 |         unsigned long _regs[NR_VCPU_REGS];
      |                       ^~~~~

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/kvm/emulate.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 89b11e7dca8a..fbcbc012a3ae 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -247,6 +247,8 @@ enum x86_transfer_type {
 
 static ulong reg_read(struct x86_emulate_ctxt *ctxt, unsigned nr)
 {
+	if (WARN_ON(nr >= ARRAY_SIZE(ctxt->_regs)))
+		return 0;
 	if (!(ctxt->regs_valid & (1 << nr))) {
 		ctxt->regs_valid |= 1 << nr;
 		ctxt->_regs[nr] = ctxt->ops->read_gpr(ctxt, nr);
@@ -256,6 +258,8 @@ static ulong reg_read(struct x86_emulate_ctxt *ctxt, unsigned nr)
 
 static ulong *reg_write(struct x86_emulate_ctxt *ctxt, unsigned nr)
 {
+	if (WARN_ON(nr >= ARRAY_SIZE(ctxt->_regs)))
+		return 0;
 	ctxt->regs_valid |= 1 << nr;
 	ctxt->regs_dirty |= 1 << nr;
 	return &ctxt->_regs[nr];
-- 
2.32.0

