Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8DE413820
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 19:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhIURM4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 13:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhIURMz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 13:12:55 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7402C061574
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 10:11:26 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id f34-20020a05622a1a2200b0029c338949c1so220211284qtb.8
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 10:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jzWR7Fq+/HAR8FRZ5CmWSQlSyJSKtGaA1okeOYzuzGU=;
        b=SRNa1zbX4Hlo2D0JzsaExaDQ/o+xv5a3XVc2p1Ds3bUplbwmS3q6FzHFGfO6viO3tx
         UryxD6046QZNjR9r+69hcdSw2WNjndojahCKDtDMVFLbsnQLby9zo1kaKVVSvhYZ35Ab
         N1XuaLB9ymwxPiDzOqnDCatr7f+AnGBW/FZ8jw1+tXmchZcorWtKXb7X+iVDB6Lsnw+6
         Dr7bGpQ5U09p+edUYGyTkyxZocA6S25DGmN6ZVbyhQ5KMRM1oJBRrg5DQUDEyg2nDsTl
         TBLDdFnK5k+0atVZS7dXSqIDQ16oPe7jTkoMHF5iu43OgOpq3zC+jP+TJoPPbSPfsvgV
         l6yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jzWR7Fq+/HAR8FRZ5CmWSQlSyJSKtGaA1okeOYzuzGU=;
        b=H+nTvQycenVqaL8b9iiFyIGD1WZfR0HAXVIAscHwF40T5I7RKMLFs2h9GxCVvAdg9a
         cxkz4fSN5p2Frt688EQnvMpS845ncN2d1/oltz3U6tKlAU8kVQdUPHCRvrNV3APPbjBn
         ZGFfFLDVaa1+/+QbwJGL8mmrgf0yYlQlZqoi6NKx5warY1YPe5M+HE96Gru+SR3r3quv
         JpgXnWT6FrAoqSslOiXsMuN+bIOzwc7p5+lNjktsQAIKwu47csh5DnsMZLGxeF1BoOGM
         KlnKHJbi/3+V+queORSpoPZXcHHFees8JetSAcJyL3ATuki3HG16wlLTEPT6NFr5vZO6
         ggAw==
X-Gm-Message-State: AOAM532s2P60wIffMUVz8QYOuCP474CUl9trTe3jnwgJXFHJyyVDWJ5n
        gS5cJ82aKr3l33Pr9fv+AHjLa3V9ylJWP/aL+riWJvSe/pGlP4FxG0Low7T995L9k5C9scttnrX
        ZLmKm52SOt+EcJhSQ76J1xBiGk4DBNutN+MSdSaRa/nIevBkwDMALa85nWA==
X-Google-Smtp-Source: ABdhPJxTaVdhnf2NYKqOfGZMxyn1rqiFJZMJSy1HY3CHx0lbCdjT7xpbhLQC0Atg6HG9LiGEYTEt9oY+BH8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:eb0b:: with SMTP id d11mr37032784ybs.101.1632244285806;
 Tue, 21 Sep 2021 10:11:25 -0700 (PDT)
Date:   Tue, 21 Sep 2021 17:11:20 +0000
In-Reply-To: <20210921171121.2148982-1-oupton@google.com>
Message-Id: <20210921171121.2148982-2-oupton@google.com>
Mime-Version: 1.0
References: <20210921171121.2148982-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v2 1/2] selftests: KVM: Fix check for !POLLIN in demand_paging_test
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The logical not operator applies only to the left hand side of a bitwise
operator. As such, the check for POLLIN not being set in revents wrong.
Fix it by adding parentheses around the bitwise expression.

Fixes: 4f72180eb4da ("KVM: selftests: Add demand paging content to the demand paging test")
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index e79c1b64977f..10edae425ab3 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -179,7 +179,7 @@ static void *uffd_handler_thread_fn(void *arg)
 			return NULL;
 		}
 
-		if (!pollfd[0].revents & POLLIN)
+		if (!(pollfd[0].revents & POLLIN))
 			continue;
 
 		r = read(uffd, &msg, sizeof(msg));
-- 
2.33.0.464.g1972c5931b-goog

