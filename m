Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A4735318B
	for <lists+kvm@lfdr.de>; Sat,  3 Apr 2021 01:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235720AbhDBXhU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 19:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235228AbhDBXhT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 19:37:19 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6A7C061793
        for <kvm@vger.kernel.org>; Fri,  2 Apr 2021 16:37:17 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id i6so10857329ybk.2
        for <kvm@vger.kernel.org>; Fri, 02 Apr 2021 16:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=0LM6xcoLFCRsb/RrOWErJVCC7SaCW1PJNWp8wUkAbs8=;
        b=Pg0Typ4Q1+Mnkw5PV9gEyPGAg3vVXc9K2xcboUDafknVQoB+1YdTsZM2Aj4t6mdJKi
         iS0cldfS2nCihyYUUwduL8D/bT+cRUvnt+2TYTjiFhFrf3VhvctCDCTUEUPDs2uvJaI6
         RjrRkq970wcGJqChk4YEI+vmURNdKbKrMNVjQKsUtv1gTAYDetRarMh0fM0TcJ+QaRCL
         yvYcukJGhDP/++YhQfxX+JHjK8SO6DCiMhsL6qv/CCobRPCCwyGQDf9/6GKyuE9s0JuG
         9uBCO2nOVBqEywUBq1QO2P0PModU5TOZgI1NbZwmMi4LSJpaG+sMIdVF8Evio7uTRp2w
         s+lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=0LM6xcoLFCRsb/RrOWErJVCC7SaCW1PJNWp8wUkAbs8=;
        b=PFbIAHr+3903SGD7gtkv74qWhJ4BCGQtzEprq0uJVcgdel2B1NDDmPTp+/ZCoTyoUt
         2bhlBC0dGXPMYXfwUeM0xXVVbR1sO9+8HnAO8hjVm/9BdQFaPPN1Yhn6fzX89odP8U1o
         9y4x2fskKgTPREeopD6tixCQdgnt8fxjrW76zZEOX0xtPrI8Wo6NUZ6mYwBDTEFuXOMJ
         0E4PfKjm8PBSmacM4ctc98uJn0/Eo9mXpAJQ6bsR7IgFsayyX/AhhtUDOeJPRICqDUAL
         fTKxu0BO+MOTDuAQA9J+12crimwIDpk3BXWI3qAuWUozcjyrttQRRaB3RNk+oyjCC2JY
         zuQw==
X-Gm-Message-State: AOAM530fQtddGBGRIrtXOIfyR4ZW2SRrlRJ3yCL3x5/7LyjqtKSb9kjL
        kIRXYh/yf7Xq+IRaugwp9SWWKEX5Cx0=
X-Google-Smtp-Source: ABdhPJwqG3jIPZ0z+TizSalVeZBrtmUZjK9lKQGsJb/Q2mt+C2P4+FWk3plTbgpam0rOqej5aloGscqXgnQ=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:24a7:3342:da61:f6aa])
 (user=seanjc job=sendgmr) by 2002:a25:144:: with SMTP id 65mr19595306ybb.394.1617406636576;
 Fri, 02 Apr 2021 16:37:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  2 Apr 2021 16:36:58 -0700
In-Reply-To: <20210402233702.3291792-1-seanjc@google.com>
Message-Id: <20210402233702.3291792-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210402233702.3291792-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH 1/5] crypto: ccp: Detect and reject vmalloc addresses destined
 for PSP
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly reject vmalloc'd data as the source for SEV commands that are
sent to the PSP.  The PSP works with physical addresses, and __pa() will
not return the correct address for a vmalloc'd pionter, which at best
will cause the command to fail, and at worst lead to system instability.

While it's unlikely that callers will deliberately use vmalloc() for SEV
buffers, a caller can easily use a vmalloc'd pointer unknowingly when
running with CONFIG_VMAP_STACK=y as it's not obvious that putting the
command buffers on the stack would be bad.  The command buffers are
relative small and easily fit on the stack, and the APIs to do not
document that the incoming pointer must be a physically contiguous,
__pa() friendly pointer.

Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Fixes: 200664d5237f ("crypto: ccp: Add Secure Encrypted Virtualization (SEV) command support")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/crypto/ccp/sev-dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index cb9b4c4e371e..6556d220713b 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -150,6 +150,9 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 
 	sev = psp->sev_data;
 
+	if (data && WARN_ON_ONCE(is_vmalloc_addr(data)))
+		return -EINVAL;
+
 	/* Get the physical address of the command buffer */
 	phys_lsb = data ? lower_32_bits(__psp_pa(data)) : 0;
 	phys_msb = data ? upper_32_bits(__psp_pa(data)) : 0;
-- 
2.31.0.208.g409f899ff0-goog

