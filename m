Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 845645298FB
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 07:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234569AbiEQFMq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 01:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbiEQFMp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 01:12:45 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4F629811
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 22:12:42 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i17-20020a259d11000000b0064cd3084085so7468029ybp.9
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 22:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=DB3N5E4EVtF03jnDYizTsAa7EFV8bT7M0HNpaC0p7yE=;
        b=IYhGUq56iaNZ0uf2WbcquwqN4fNYbEQsuZZBwA6vXJmYmscFRK89VMQOzeI+CoDym6
         599ZiQ0S53iHXy9VnOnvHfif6MEDNwN0YDjjwsX4nnAJ5U8vE1xTyVq7FfZ+Kr44Cm7O
         eZWKxDUwh+gHYWjLPpcf0X1etuV/+xI3XXfuOjvzMmGP1kiFYzNf4qlChhxYI/LaHh1K
         1Uo0HzHEDECreTHYIOIT9DQrrtZ8RRKMP8roczkwCzsF6MIxSylaOxd+oG9JJ8ve+vVP
         NvIlG+QRIgJxy+WIaql4Dx9NTxOROwctgmJwVCJWGBxXaSn4a6J7vqWF+J95J2tEpTiw
         Ja4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=DB3N5E4EVtF03jnDYizTsAa7EFV8bT7M0HNpaC0p7yE=;
        b=DITgCKdg/Tpwuyp2LKw/I3xH+kfTT3pskyVim8KW4ugWiCBSKDPwdFXVl5+/RybHL0
         Z6YUWIXPyGxR8UXtZorWsPTX7YcUyFW+R7OXLGfEwCWpTFbtxLl8vG+QL1pRyMc97OtX
         I8sSTG/Ky5B4Cq5aLgG5G+djxFzHkg63de+j0DT1qxSXhS0eQOD8GU2Ffs9d83CmXYVg
         rP2raIRZZddPc+R+8P429eQm8HugjtQyrC4IKT4RCOPm8Zgz/KaDcViL4bx+0nj+qBPI
         9469B55TUJPZEs9GDosU8ijp5EyuAcGE4CyBPFRQd4RRpL9OLqsOQMdE8HAzPeR2Ml9t
         3Qiw==
X-Gm-Message-State: AOAM530PLjOrcdASKaQn1wTnPcB3UW+SeNxffZMJqIFNxO+Iz8fdzszd
        iboRtr0pI8MZr6GjdxQwoQNBM4GRBxwbhi8X4VBJck6hT/POerAo/vpi4qqZOymfe+22jy6M9h8
        mhkikbZs6bA91Kwjmt9PIvDLZUjwOn4/Fa9K7iepo+QxF9WiDembhLYgHTzd+TbpgjuSg
X-Google-Smtp-Source: ABdhPJx9niaunlArs/Hzh79xAmtXKxYQ2HafTyHgm3aD0Y9kIX/3ROYX0xBrnD02eFkTEQzz9mSfuNsS6nrpbdEm
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a81:5bc5:0:b0:2d6:5659:73c2 with SMTP
 id p188-20020a815bc5000000b002d6565973c2mr23988173ywb.121.1652764362120; Mon,
 16 May 2022 22:12:42 -0700 (PDT)
Date:   Tue, 17 May 2022 05:12:36 +0000
Message-Id: <20220517051238.2566934-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH 1/3] kvm: x86/pmu: Fix the compare function used by the pmu
 event filter
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

When returning from the compare function the u64 is truncated to an
int.  This results in a loss of the high nybble[1] in the event select
and its sign if that nybble is in use.  Switch from using a result that
can end up being truncated to a result that can only be: 1, 0, -1.

[1] bits 35:32 in the event select register and bits 11:8 in the event
    select.

Fixes: 7ff775aca48ad ("KVM: x86/pmu: Use binary search to check filtered events")
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index eca39f56c231..1666e9d3e545 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -173,7 +173,7 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 
 static int cmp_u64(const void *a, const void *b)
 {
-	return *(__u64 *)a - *(__u64 *)b;
+	return (*(u64 *)a > *(u64 *)b) - (*(u64 *)a < *(u64 *)b);
 }
 
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
-- 
2.36.1.124.g0e6072fb45-goog

