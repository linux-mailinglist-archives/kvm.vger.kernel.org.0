Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44426412AE6
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 04:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241538AbhIUCCd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 22:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238568AbhIUB5p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 21:57:45 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00746C0C751A
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 18:01:38 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id az30-20020a05620a171e00b00432eb71d467so103202363qkb.18
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 18:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PESbKZ13iPjl74hV0V0Oma6w2P6tLvn6iQL7mqbwGgo=;
        b=ppmJDLMbBlM4yiFlfHYiHNu77wvNXXA5sAEzTiwCbSu7h70G6OjhKF2mjh7FFO64Dq
         mi/BbW0+YbeqFEz87n2vqvzvrplY76fKT4uwCsAlhywV3hvoAJ/pxkM09kbB72YYNAbQ
         LaFiePNwjkwukIs52aik3fTBq2pZaR4bVRx6FpWsM/XuLeVz1+umhLvvcoo93cB9I+Cz
         PGPoF2Lf8eyERDt6eMuXk81Tfae2XfL7oQUY6eeugG7Ye+GCZRe/lRb1GD0M4Nr7N8tJ
         6i4ErXIQdOXEzvwvJtl7l5OxjvuFpswh2FxB18zrh0B9Tk4FzxAGLy7m1yMlGk+RGE9u
         ryYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PESbKZ13iPjl74hV0V0Oma6w2P6tLvn6iQL7mqbwGgo=;
        b=RuOxlFIPyHdwWaaZjSeqNBcbruPfSVMtwjdQxsM2ugBtgh8+paX0q2VYNN4ROGn27m
         pCLh32JYbyVjuhfFZECsCKklBQAM+882e8A88kpjzcg+yR0k7+C0kRGrQUI3b/URVETM
         HC449i4s06nPw+AqVYhwpSlPvvzvqhsBoXyvI08p2OvfHWDMQW1S0ZCm1/RROsyob+0c
         zmEM5PU0yrXJXaTu/dCMPEd08hjBv0nQ5Hyu+mXx0tg5OBoyToKBlrG1yBZsUf8FDc0J
         vECGBAAnwB8L4qdrrPI2/c/a5g1217N9u92FedGV+/5/a/hPYAtKl5atbQRxB75jCDil
         SUCQ==
X-Gm-Message-State: AOAM532K7PXBo1cRvFn1gtMBOGEtI30mflpBUanvyeXm5NmwAyKpFRVZ
        OrY7h0ShJ0ZT+42P7C8lUhMehMg8I7YdlnwhHGlvdxQHwr0wLN7ClTvrsKXOmpsJSTyX0TjdHQ5
        DUUwErZw0qAMAvGeu30R8XlLQP4e2pvyOKn7QjG45vQGTbCJ8sSzHMq5Fgg==
X-Google-Smtp-Source: ABdhPJxxD5Psn8NbnOGzgjmoMwHo/NRrqGL/Hz5g2R/wXaxij8FsuN33N5paHz3bIg3BU/k6S4n92x/nUM4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:122e:: with SMTP id
 p14mr28597769qvv.37.1632186098021; Mon, 20 Sep 2021 18:01:38 -0700 (PDT)
Date:   Tue, 21 Sep 2021 01:01:19 +0000
In-Reply-To: <20210921010120.1256762-1-oupton@google.com>
Message-Id: <20210921010120.1256762-2-oupton@google.com>
Mime-Version: 1.0
References: <20210921010120.1256762-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH 1/2] selftests: KVM: Fix compiler warning in demand_paging_test
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

Building demand_paging_test.c with clang throws the following warning:

>> demand_paging_test.c:182:7: error: logical not is only applied to the left hand side of this bitwise operator [-Werror,-Wlogical-not-parentheses]
                  if (!pollfd[0].revents & POLLIN)

Silence the warning by placing the bitwise operation within parentheses.

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

